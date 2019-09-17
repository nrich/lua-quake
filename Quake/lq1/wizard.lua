--/*  Copyright (C) 1996-1997  Id Software, Inc.
--    Copyright (C) 2019 Neil Richardson (nrich@neiltopia.com)
--
--    This program is free software you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation either version 2 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program if not, write to the Free Software
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
--
--    See file, 'COPYING', for details.
--*/
--/*
--==============================================================================
--
--WIZARD
--
--==============================================================================
--*/


local FRAME_hover1,FRAME_hover2,FRAME_hover3,FRAME_hover4,FRAME_hover5,FRAME_hover6,FRAME_hover7,FRAME_hover8 = 0,1,2,3,4,5,6,7
local FRAME_hover9,FRAME_hover10,FRAME_hover11,FRAME_hover12,FRAME_hover13,FRAME_hover14,FRAME_hover15 = 8,9,10,11,12,13,14

local FRAME_fly1,FRAME_fly2,FRAME_fly3,FRAME_fly4,FRAME_fly5,FRAME_fly6,FRAME_fly7,FRAME_fly8,FRAME_fly9,FRAME_fly10 = 15,16,17,18,19,20,21,22,23,24
local FRAME_fly11,FRAME_fly12,FRAME_fly13,FRAME_fly14 = 25,26,27,28

local FRAME_magatt1,FRAME_magatt2,FRAME_magatt3,FRAME_magatt4,FRAME_magatt5,FRAME_magatt6,FRAME_magatt7 = 29,30,31,32,33,34,35
local FRAME_magatt8,FRAME_magatt9,FRAME_magatt10,FRAME_magatt11,FRAME_magatt12,FRAME_magatt13 = 36,37,38,39,40,41

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4 = 42,43,44,45

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8 = 46,47,48,49,50,51,52,53

--/*
--==============================================================================
--
--WIZARD
--
--If the player moves behind cover before the missile is launched, launch it
--at the last visible spot with no velocity leading, in hopes that the player
--will duck back out and catch it.
--==============================================================================
--*/

--/*
--=============
--LaunchMissile
--
--Sets the given entities velocity and angles so that it will hit self.enemy
--if self.enemy maintains it's current velocity
--0.1 is moderately accurate, 0.0 is totally accurate
--=============
--*/
function LaunchMissile(missile, mspeed, accuracy) -- entity, float, float
	local vec, move; -- vector
	local fly; -- float

	makevectors (self.angles)
		
-- set missile speed
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin

-- calc aproximate time for missile to reach vec
	fly = vlen (vec) / mspeed
	
-- get the entities xy velocity
	move = self.enemy.velocity
	move.z = 0

-- project the target forward in time
	vec = vec + move * fly
	
	vec = normalize(vec)
	vec = vec + accuracy*qc.v_up*(random()- 0.5) + accuracy*qc.v_right*(random()- 0.5)
	
	missile.velocity = vec * mspeed

	missile.angles = vec3(0, 0, 0)
	missile.angles.y = vectoyaw(missile.velocity)

-- set missile duration
	missile.nextthink = time + 5
	missile.think = SUB_Remove	
end



--/*
--=================
--WizardCheckAttack
--=================
--*/
function WizardCheckAttack()
	local spot1, spot2;	 -- vector
	local targ; -- entity
	local chance; -- float

	if time < self.attack_finished then -- TODO check condition
		return false
        end
	if  not enemy_vis then -- TODO check condition
		return false
        end

	if enemy_range == RANGE_FAR then -- TODO check condition
		if self.attack_state ~= AS_STRAIGHT then -- TODO check condition
			self.attack_state = AS_STRAIGHT
			wiz_run1 ()
		end
		return false
	end
		
	targ = self.enemy
	
-- see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs

	traceline (spot1, spot2, false, self)

	if qc.trace_ent ~= targ then -- TODO check condition
		if self.attack_state ~= AS_STRAIGHT then -- TODO check condition
			self.attack_state = AS_STRAIGHT
			wiz_run1 ()
		end
		return false
	end
			
	if enemy_range == RANGE_MELEE then -- TODO check condition
		chance = 0.9
	elseif enemy_range == RANGE_NEAR then -- TODO check condition
		chance = 0.6
	elseif enemy_range == RANGE_MID then -- TODO check condition
		chance = 0.2
	else
		chance = 0
        end

	if random () < chance then -- TODO check condition
		self.attack_state = AS_MISSILE
		return true
	end

	if enemy_range == RANGE_MID then -- TODO check condition
		if self.attack_state ~= AS_STRAIGHT then -- TODO check condition
			self.attack_state = AS_STRAIGHT
			wiz_run1 ()
		end
	else
		if self.attack_state ~= AS_SLIDING then -- TODO check condition
			self.attack_state = AS_SLIDING
			wiz_side1 ()
		end
	end
	
	return false
end

--/*
--=================
--WizardAttackFinished
--=================
--*/
function WizardAttackFinished()
	if enemy_range >= RANGE_MID  or   not enemy_vis then -- TODO check condition
		self.attack_state = AS_STRAIGHT
		self.think = wiz_run1
	else
		self.attack_state = AS_SLIDING
		self.think = wiz_side1
	end
end

--/*
--==============================================================================
--
--FAST ATTACKS
--
--==============================================================================
--*/

function Wiz_FastFire()
	local vec; -- vector
	local dst; -- vector

	if self.owner.health > 0 then -- TODO check condition
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH

		makevectors (self.enemy.angles)	
		dst = self.enemy.origin - 13*self.movedir
	
		vec = normalize(dst - self.origin)
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM)
		launch_spike (self.origin, vec)
		newmis.velocity = vec*600
		newmis.owner = self.owner
		newmis.classname = "wizspike"
		setmodel (newmis, "progs/w_spike.mdl")
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN)		
	end

	remove (self)
end


function Wiz_StartFast()
	local missile; -- entity
	
	sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM)
	self.v_angle = self.angles
	makevectors (self.angles)

	missile = spawn ()
	missile.owner = self
	missile.nextthink = time + 0.6
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, self.origin + vec3(0, 0, 30) + qc.v_forward*14 + qc.v_right*14)
	missile.enemy = self.enemy
	missile.nextthink = time + 0.8
	missile.think = Wiz_FastFire
	missile.movedir = qc.v_right

	missile = spawn ()
	missile.owner = self
	missile.nextthink = time + 1
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, self.origin + vec3(0, 0, 30) + qc.v_forward*14 + qc.v_right* -14)
	missile.enemy = self.enemy
	missile.nextthink = time + 0.3
	missile.think = Wiz_FastFire
	missile.movedir = VEC_ORIGIN - qc.v_right
end



function Wiz_idlesound()
        local wr; -- float
	wr = random() * 5

        if not self.waitmin then self.waitmin = 0 end

	if self.waitmin < time then -- TODO check condition
	 	self.waitmin = time + 2
	 	if wr > 4.5 then -- TODO check condition
	 		sound (self, CHAN_VOICE, "wizard/widle1.wav", 1,  ATTN_IDLE)
                end
	 	if wr < 1.5 then -- TODO check condition
	 		sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE)
                end
	end
	return
end

function wiz_stand1()
	self.frame=FRAME_hover1
	self.nextthink = time + 0.1
	self.think = wiz_stand2
	ai_stand()
end
function wiz_stand2()
	self.frame=FRAME_hover2
	self.nextthink = time + 0.1
	self.think = wiz_stand3
	ai_stand()
end
function wiz_stand3()
	self.frame=FRAME_hover3
	self.nextthink = time + 0.1
	self.think = wiz_stand4
	ai_stand()
end
function wiz_stand4()
	self.frame=FRAME_hover4
	self.nextthink = time + 0.1
	self.think = wiz_stand5
	ai_stand()
end
function wiz_stand5()
	self.frame=FRAME_hover5
	self.nextthink = time + 0.1
	self.think = wiz_stand6
	ai_stand()
end
function wiz_stand6()
	self.frame=FRAME_hover6
	self.nextthink = time + 0.1
	self.think = wiz_stand7
	ai_stand()
end
function wiz_stand7()
	self.frame=FRAME_hover7
	self.nextthink = time + 0.1
	self.think = wiz_stand8
	ai_stand()
end
function wiz_stand8()
	self.frame=FRAME_hover8
	self.nextthink = time + 0.1
	self.think = wiz_stand1
	ai_stand()
end

function wiz_walk1()
	self.frame=FRAME_hover1
	self.nextthink = time + 0.1
	self.think = wiz_walk2
        ai_walk(8)
        Wiz_idlesound()
end
function wiz_walk2()
	self.frame=FRAME_hover2
	self.nextthink = time + 0.1
	self.think = wiz_walk3
	ai_walk(8)
end
function wiz_walk3()
	self.frame=FRAME_hover3
	self.nextthink = time + 0.1
	self.think = wiz_walk4
	ai_walk(8)
end
function wiz_walk4()
	self.frame=FRAME_hover4
	self.nextthink = time + 0.1
	self.think = wiz_walk5
	ai_walk(8)
end
function wiz_walk5()
	self.frame=FRAME_hover5
	self.nextthink = time + 0.1
	self.think = wiz_walk6
	ai_walk(8)
end
function wiz_walk6()
	self.frame=FRAME_hover6
	self.nextthink = time + 0.1
	self.think = wiz_walk7
	ai_walk(8)
end
function wiz_walk7()
	self.frame=FRAME_hover7
	self.nextthink = time + 0.1
	self.think = wiz_walk8
	ai_walk(8)
end
function wiz_walk8()
	self.frame=FRAME_hover8
	self.nextthink = time + 0.1
	self.think = wiz_walk1
	ai_walk(8)
end

function wiz_side1()
	self.frame=FRAME_hover1
	self.nextthink = time + 0.1
	self.think = wiz_side2
        ai_run(8)
        Wiz_idlesound()
end
function wiz_side2()
	self.frame=FRAME_hover2
	self.nextthink = time + 0.1
	self.think = wiz_side3
	ai_run(8)
end
function wiz_side3()
	self.frame=FRAME_hover3
	self.nextthink = time + 0.1
	self.think = wiz_side4
	ai_run(8)
end
function wiz_side4()
	self.frame=FRAME_hover4
	self.nextthink = time + 0.1
	self.think = wiz_side5
	ai_run(8)
end
function wiz_side5()
	self.frame=FRAME_hover5
	self.nextthink = time + 0.1
	self.think = wiz_side6
	ai_run(8)
end
function wiz_side6()
	self.frame=FRAME_hover6
	self.nextthink = time + 0.1
	self.think = wiz_side7
	ai_run(8)
end
function wiz_side7()
	self.frame=FRAME_hover7
	self.nextthink = time + 0.1
	self.think = wiz_side8
	ai_run(8)
end
function wiz_side8()
	self.frame=FRAME_hover8
	self.nextthink = time + 0.1
	self.think = wiz_side1
	ai_run(8)
end

function wiz_run1()
	self.frame=FRAME_fly1
	self.nextthink = time + 0.1
	self.think = wiz_run2
        ai_run(16)
        Wiz_idlesound()
end
function wiz_run2()
	self.frame=FRAME_fly2
	self.nextthink = time + 0.1
	self.think = wiz_run3
	ai_run(16)
end
function wiz_run3()
	self.frame=FRAME_fly3
	self.nextthink = time + 0.1
	self.think = wiz_run4
	ai_run(16)
end
function wiz_run4()
	self.frame=FRAME_fly4
	self.nextthink = time + 0.1
	self.think = wiz_run5
	ai_run(16)
end
function wiz_run5()
	self.frame=FRAME_fly5
	self.nextthink = time + 0.1
	self.think = wiz_run6
	ai_run(16)
end
function wiz_run6()
	self.frame=FRAME_fly6
	self.nextthink = time + 0.1
	self.think = wiz_run7
	ai_run(16)
end
function wiz_run7()
	self.frame=FRAME_fly7
	self.nextthink = time + 0.1
	self.think = wiz_run8
	ai_run(16)
end
function wiz_run8()
	self.frame=FRAME_fly8
	self.nextthink = time + 0.1
	self.think = wiz_run9
	ai_run(16)
end
function wiz_run9()
	self.frame=FRAME_fly9
	self.nextthink = time + 0.1
	self.think = wiz_run10
	ai_run(16)
end
function wiz_run10()
	self.frame=FRAME_fly10
	self.nextthink = time + 0.1
	self.think = wiz_run11
	ai_run(16)
end
function wiz_run11()
	self.frame=FRAME_fly11
	self.nextthink = time + 0.1
	self.think = wiz_run12
	ai_run(16)
end
function wiz_run12()
	self.frame=FRAME_fly12
	self.nextthink = time + 0.1
	self.think = wiz_run13
	ai_run(16)
end
function wiz_run13()
	self.frame=FRAME_fly13
	self.nextthink = time + 0.1
	self.think = wiz_run14
	ai_run(16)
end
function wiz_run14()
	self.frame=FRAME_fly14
	self.nextthink = time + 0.1
	self.think = wiz_run1
	ai_run(16)
end

function wiz_fast1()
	self.frame=FRAME_magatt1
	self.nextthink = time + 0.1
	self.think = wiz_fast2
	ai_face()
	Wiz_StartFast()
end
function wiz_fast2()
	self.frame=FRAME_magatt2
	self.nextthink = time + 0.1
	self.think = wiz_fast3
	ai_face()
end
function wiz_fast3()
	self.frame=FRAME_magatt3
	self.nextthink = time + 0.1
	self.think = wiz_fast4
	ai_face()
end
function wiz_fast4()
	self.frame=FRAME_magatt4
	self.nextthink = time + 0.1
	self.think = wiz_fast5
	ai_face()
end
function wiz_fast5()
	self.frame=FRAME_magatt5
	self.nextthink = time + 0.1
	self.think = wiz_fast6
	ai_face()
end
function wiz_fast6()
	self.frame=FRAME_magatt6
	self.nextthink = time + 0.1
	self.think = wiz_fast7
	ai_face()
end
function wiz_fast7()
	self.frame=FRAME_magatt5
	self.nextthink = time + 0.1
	self.think = wiz_fast8
	ai_face()
end
function wiz_fast8()
	self.frame=FRAME_magatt4
	self.nextthink = time + 0.1
	self.think = wiz_fast9
	ai_face()
end
function wiz_fast9()
	self.frame=FRAME_magatt3
	self.nextthink = time + 0.1
	self.think = wiz_fast10
	ai_face()
end
function wiz_fast10()
	self.frame=FRAME_magatt2
	self.nextthink = time + 0.1
	self.think = wiz_run1
	ai_face()
	SUB_AttackFinished(2)
	WizardAttackFinished ()
end

function wiz_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = wiz_pain2
end
function wiz_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = wiz_pain3
end
function wiz_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = wiz_pain4
end
function wiz_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = wiz_run1
end

function wiz_death1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = wiz_death2
        self.velocity.x = -200 + 400*random()
        self.velocity.y = -200 + 400*random()
        self.velocity.z = 100 + 100*random()
        self.flags = self.flags - (self.flags & FL_ONGROUND)
        sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM)
end
function wiz_death2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = wiz_death3
end
function wiz_death3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = wiz_death4
	self.solid = SOLID_NOT
end
function wiz_death4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = wiz_death5
end
function wiz_death5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = wiz_death6
end
function wiz_death6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = wiz_death7
end
function wiz_death7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = wiz_death8
end
function wiz_death8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = wiz_death8
end

function wiz_die()
-- check for gib
	if self.health < -40 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_wizard.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		return
	end

	wiz_death1 ()
end


function Wiz_Pain(attacker, damage) -- entity, float
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM)
	if random()*70 > damage then -- TODO check condition
		return		-- didn't flinch
        end

	wiz_pain1 ()
end


function Wiz_Missile()
	wiz_fast1()
end

--/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
--*/
function monster_wizard()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/wizard.mdl")
	precache_model ("progs/h_wizard.mdl")
	precache_model ("progs/w_spike.mdl")

	precache_sound ("wizard/hit.wav")		-- used by c code
	precache_sound ("wizard/wattack.wav")
	precache_sound ("wizard/wdeath.wav")
	precache_sound ("wizard/widle1.wav")
	precache_sound ("wizard/widle2.wav")
	precache_sound ("wizard/wpain.wav")
	precache_sound ("wizard/wsight.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/wizard.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 80

	self.th_stand = wiz_stand1
	self.th_walk = wiz_walk1
	self.th_run = wiz_run1
	self.th_missile = Wiz_Missile
	self.th_pain = Wiz_Pain
	self.th_die = wiz_die
		
	flymonster_start ()
end
