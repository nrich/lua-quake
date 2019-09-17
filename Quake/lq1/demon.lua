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
--DEMON
--
--==============================================================================
--*/


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8,FRAME_stand9 = 0,1,2,3,4,5,6,7,8
local FRAME_stand10,FRAME_stand11,FRAME_stand12,FRAME_stand13 = 9,10,11,12

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8 = 13,14,15,16,17,18,19,20

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6 = 21,22,23,24,25,26

local FRAME_leap1,FRAME_leap2,FRAME_leap3,FRAME_leap4,FRAME_leap5,FRAME_leap6,FRAME_leap7,FRAME_leap8,FRAME_leap9,FRAME_leap10 = 27,28,29,30,31,32,33,34,35,36
local FRAME_leap11,FRAME_leap12 = 37,38

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6 = 39,40,41,42,43,44

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8,FRAME_death9 = 45,46,47,48,49,50,51,52,53

local FRAME_attacka1,FRAME_attacka2,FRAME_attacka3,FRAME_attacka4,FRAME_attacka5,FRAME_attacka6,FRAME_attacka7,FRAME_attacka8 = 54,55,56,57,58,59,60,61
local FRAME_attacka9,FRAME_attacka10,FRAME_attacka11,FRAME_attacka12,FRAME_attacka13,FRAME_attacka14,FRAME_attacka15 = 62,63,64,65,66,67,68

--============================================================================


function demon1_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = demon1_stand2
	ai_stand()
end
function demon1_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = demon1_stand3
	ai_stand()
end
function demon1_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = demon1_stand4
	ai_stand()
end
function demon1_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = demon1_stand5
	ai_stand()
end
function demon1_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = demon1_stand6
	ai_stand()
end
function demon1_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = demon1_stand7
	ai_stand()
end
function demon1_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = demon1_stand8
	ai_stand()
end
function demon1_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = demon1_stand9
	ai_stand()
end
function demon1_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = demon1_stand10
	ai_stand()
end
function demon1_stand10()
	self.frame=FRAME_stand10
	self.nextthink = time + 0.1
	self.think = demon1_stand11
	ai_stand()
end
function demon1_stand11()
	self.frame=FRAME_stand11
	self.nextthink = time + 0.1
	self.think = demon1_stand12
	ai_stand()
end
function demon1_stand12()
	self.frame=FRAME_stand12
	self.nextthink = time + 0.1
	self.think = demon1_stand13
	ai_stand()
end
function demon1_stand13()
	self.frame=FRAME_stand13
	self.nextthink = time + 0.1
	self.think = demon1_stand1
	ai_stand()
end

function demon1_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = demon1_walk2
        if random() < 0.2 then -- TODO check condition
                sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE)
        end
        ai_walk(8)
end
function demon1_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = demon1_walk3
	ai_walk(6)
end
function demon1_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = demon1_walk4
	ai_walk(6)
end
function demon1_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = demon1_walk5
	ai_walk(7)
end
function demon1_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = demon1_walk6
	ai_walk(4)
end
function demon1_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = demon1_walk7
	ai_walk(6)
end
function demon1_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = demon1_walk8
	ai_walk(10)
end
function demon1_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = demon1_walk1
	ai_walk(10)
end

function demon1_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = demon1_run2
        if random() < 0.2 then -- TODO check condition
                sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE)
        end
end
function demon1_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = demon1_run3
	ai_run(15)
end
function demon1_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = demon1_run4
	ai_run(36)
end
function demon1_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = demon1_run5
	ai_run(20)
end
function demon1_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = demon1_run6
	ai_run(15)
end
function demon1_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = demon1_run1
	ai_run(36)
end

function demon1_jump1()
	self.frame=FRAME_leap1
	self.nextthink = time + 0.1
	self.think = demon1_jump2
	ai_face()
end
function demon1_jump2()
	self.frame=FRAME_leap2
	self.nextthink = time + 0.1
	self.think = demon1_jump3
	ai_face()
end
function demon1_jump3()
	self.frame=FRAME_leap3
	self.nextthink = time + 0.1
	self.think = demon1_jump4
	ai_face()
end
function demon1_jump4()
	self.frame=FRAME_leap4
	self.nextthink = time + 0.1
	self.think = demon1_jump5
	ai_face()
	
	self.touch = Demon_JumpTouch
	makevectors (self.angles)
	self.origin.z = self.origin.z + 1
	self.velocity = qc.v_forward * 600 + vec3(0, 0, 250)
	if self.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
		self.flags = self.flags - FL_ONGROUND
        end
end
function demon1_jump5()
	self.frame=FRAME_leap5
	self.nextthink = time + 0.1
	self.think = demon1_jump6
end
function demon1_jump6()
	self.frame=FRAME_leap6
	self.nextthink = time + 0.1
	self.think = demon1_jump7
end
function demon1_jump7()
	self.frame=FRAME_leap7
	self.nextthink = time + 0.1
	self.think = demon1_jump8
end
function demon1_jump8()
	self.frame=FRAME_leap8
	self.nextthink = time + 0.1
	self.think = demon1_jump9
end
function demon1_jump9()
	self.frame=FRAME_leap9
	self.nextthink = time + 0.1
	self.think = demon1_jump10
end
function demon1_jump10()
	self.frame=FRAME_leap10
	self.nextthink = time + 0.1
	self.think = demon1_jump1
self.nextthink = time + 3
-- if three seconds pass, assume demon is stuck and jump again
end

function demon1_jump11()
	self.frame=FRAME_leap11
	self.nextthink = time + 0.1
	self.think = demon1_jump12
end
function demon1_jump12()
	self.frame=FRAME_leap12
	self.nextthink = time + 0.1
	self.think = demon1_run1
end


function demon1_atta1()
	self.frame=FRAME_attacka1
	self.nextthink = time + 0.1
	self.think = demon1_atta2
	ai_charge(4)
end
function demon1_atta2()
	self.frame=FRAME_attacka2
	self.nextthink = time + 0.1
	self.think = demon1_atta3
	ai_charge(0)
end
function demon1_atta3()
	self.frame=FRAME_attacka3
	self.nextthink = time + 0.1
	self.think = demon1_atta4
	ai_charge(0)
end
function demon1_atta4()
	self.frame=FRAME_attacka4
	self.nextthink = time + 0.1
	self.think = demon1_atta5
	ai_charge(1)
end
function demon1_atta5()
	self.frame=FRAME_attacka5
	self.nextthink = time + 0.1
	self.think = demon1_atta6
	ai_charge(2)
	 Demon_Melee(200)
end
function demon1_atta6()
	self.frame=FRAME_attacka6
	self.nextthink = time + 0.1
	self.think = demon1_atta7
	ai_charge(1)
end
function demon1_atta7()
	self.frame=FRAME_attacka7
	self.nextthink = time + 0.1
	self.think = demon1_atta8
	ai_charge(6)
end
function demon1_atta8()
	self.frame=FRAME_attacka8
	self.nextthink = time + 0.1
	self.think = demon1_atta9
	ai_charge(8)
end
function demon1_atta9()
	self.frame=FRAME_attacka9
	self.nextthink = time + 0.1
	self.think = demon1_atta10
	ai_charge(4)
end
function demon1_atta10()
	self.frame=FRAME_attacka10
	self.nextthink = time + 0.1
	self.think = demon1_atta11
	ai_charge(2)
end
function demon1_atta11()
	self.frame=FRAME_attacka11
	self.nextthink = time + 0.1
	self.think = demon1_atta12
	Demon_Melee(-200)
end
function demon1_atta12()
	self.frame=FRAME_attacka12
	self.nextthink = time + 0.1
	self.think = demon1_atta13
	ai_charge(5)
end
function demon1_atta13()
	self.frame=FRAME_attacka13
	self.nextthink = time + 0.1
	self.think = demon1_atta14
	ai_charge(8)
end
function demon1_atta14()
	self.frame=FRAME_attacka14
	self.nextthink = time + 0.1
	self.think = demon1_atta15
	ai_charge(4)
end
function demon1_atta15()
	self.frame=FRAME_attacka15
	self.nextthink = time + 0.1
	self.think = demon1_run1
	ai_charge(4)
end

function demon1_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = demon1_pain2
end
function demon1_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = demon1_pain3
end
function demon1_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = demon1_pain4
end
function demon1_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = demon1_pain5
end
function demon1_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = demon1_pain6
end
function demon1_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = demon1_run1
end

function demon1_pain(attacker, damage) -- entity, float
        if not self.pain_finished then self.pain_finished = 0 end

	if self.touch == Demon_JumpTouch then -- TODO check condition
		return
        end

	if self.pain_finished > time then -- TODO check condition
		return
        end

	self.pain_finished = time + 1
        sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM)

	if random()*200 > damage then -- TODO check condition
		return		-- didn't flinch
        end
		
	demon1_pain1 ()
end

function demon1_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = demon1_die2
end
function demon1_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = demon1_die3
end
function demon1_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = demon1_die4
end
function demon1_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = demon1_die5
end
function demon1_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = demon1_die6
end
function demon1_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = demon1_die7
        self.solid = SOLID_NOT
end
function demon1_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = demon1_die8
end
function demon1_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = demon1_die9
end
function demon1_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = demon1_die9
end

function demon_die()
-- check for gib
	if self.health < -80 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_demon.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		return
	end

-- regular death
	demon1_die1 ()
end


function Demon_MeleeAttack()
	demon1_atta1 ()
end


--/*QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush
--
--*/
function monster_demon1()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/demon.mdl")
	precache_model ("progs/h_demon.mdl")

	precache_sound ("demon/ddeath.wav")
	precache_sound ("demon/dhit2.wav")
	precache_sound ("demon/djump.wav")
	precache_sound ("demon/dpain1.wav")
	precache_sound ("demon/idle1.wav")
	precache_sound ("demon/sight2.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/demon.mdl")

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX)
	self.health = 300

	self.th_stand = demon1_stand1
	self.th_walk = demon1_walk1
	self.th_run = demon1_run1
	self.th_die = demon_die
	self.th_melee = Demon_MeleeAttack		-- one of two attacks
	self.th_missile = demon1_jump1			-- jump attack
	self.th_pain = demon1_pain
		
	walkmonster_start()
end


--/*
--==============================================================================
--
--DEMON
--
--==============================================================================
--*/

--/*
--==============
--CheckDemonMelee
--
--Returns true if a melee attack would hit right now
--==============
--*/
function CheckDemonMelee()
	if enemy_range == RANGE_MELEE then -- TODO check condition
		self.attack_state = AS_MELEE
		return true
	end
	return false
end

--/*
--==============
--CheckDemonJump
--
--==============
--*/
function CheckDemonJump()
	local dist; -- vector
	local d; -- float

	if (self.origin.z + self.mins.z > self.enemy.origin.z + self.enemy.mins.z + 0.75 * self.enemy.size.z) then
		return false
        end
		
	if (self.origin.z + self.maxs.z < self.enemy.origin.z + self.enemy.mins.z + 0.25 * self.enemy.size.z) then
		return false
        end
		
	dist = self.enemy.origin - self.origin
	dist.z = 0
	
	d = vlen(dist)
	
	if d < 100 then -- TODO check condition
		return false
        end
		
	if d > 200 then -- TODO check condition
		if random() < 0.9 then -- TODO check condition
			return false
                end
	end
		
	return true
end

function DemonCheckAttack()
	local vec; -- vector
	
-- if close enough for slashing, go for it
	if CheckDemonMelee () then -- TODO check condition
		self.attack_state = AS_MELEE
		return true
	end
	
	if CheckDemonJump () then -- TODO check condition
		self.attack_state = AS_MISSILE
        sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM)
		return true
	end
	
	return false
end


--===========================================================================

function Demon_Melee(side) -- float
	local ldmg; -- float
	local delta; -- vector
	
	ai_face ()
	walkmove (self, self.ideal_yaw, 12)	-- allow a little closing

	delta = self.enemy.origin - self.origin

	if vlen(delta) > 100 then -- TODO check condition
		return
        end
	if  not CanDamage (self.enemy, self) then -- TODO check condition
		return
        end
		
        sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM)
	ldmg = 10 + 5*random()
	T_Damage (self.enemy, self, self, ldmg)	

	makevectors (self.angles)
	SpawnMeatSpray (self.origin + qc.v_forward*16, side * qc.v_right)
end


function Demon_JumpTouch()
	local ldmg; -- float

	if self.health <= 0 then -- TODO check condition
		return
        end
		
	if other.takedamage ~= 0 then -- TODO check condition
		if  vlen(self.velocity) > 400  then -- TODO check condition
			ldmg = 40 + 10*random()
			T_Damage (other, self, self, ldmg)	
		end
	end

	if  not checkbottom(self) then -- TODO check condition
		if self.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
--dprint ("popjump\n")
	                self.touch = SUB_Null
	                self.think = demon1_jump1
	                self.nextthink = time + 0.1

--			self.velocity.x = (random() - 0.5) * 600
--			self.velocity.y = (random() - 0.5) * 600
--			self.velocity.z = 200
--			self.flags = self.flags - FL_ONGROUND
		end
		return	-- not on ground yet
	end

	self.touch = SUB_Null
	self.think = demon1_jump11
	self.nextthink = time + 0.1
end

