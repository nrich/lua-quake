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
--DOG
--
--==============================================================================
--*/

local FRAME_attack1,FRAME_attack2,FRAME_attack3,FRAME_attack4,FRAME_attack5,FRAME_attack6,FRAME_attack7,FRAME_attack8 = 0,1,2,3,4,5,6,7

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8,FRAME_death9 = 8,9,10,11,12,13,14,15,16

local FRAME_deathb1,FRAME_deathb2,FRAME_deathb3,FRAME_deathb4,FRAME_deathb5,FRAME_deathb6,FRAME_deathb7,FRAME_deathb8 = 17,18,19,20,21,22,23,24
local FRAME_deathb9 = 25

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6 = 26,27,28,29,30,31

local FRAME_painb1,FRAME_painb2,FRAME_painb3,FRAME_painb4,FRAME_painb5,FRAME_painb6,FRAME_painb7,FRAME_painb8,FRAME_painb9,FRAME_painb10 = 32,33,34,35,36,37,38,39,40,41
local FRAME_painb11,FRAME_painb12,FRAME_painb13,FRAME_painb14,FRAME_painb15,FRAME_painb16 = 42,43,44,45,46,47

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8,FRAME_run9,FRAME_run10,FRAME_run11,FRAME_run12 = 48,49,50,51,52,53,54,55,56,57,58,59

local FRAME_leap1,FRAME_leap2,FRAME_leap3,FRAME_leap4,FRAME_leap5,FRAME_leap6,FRAME_leap7,FRAME_leap8,FRAME_leap9 = 60,61,62,63,64,65,66,67,68

local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8,FRAME_stand9 = 69,70,71,72,73,74,75,76,77

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8 = 78,79,80,81,82,83,84,85



--/*
--================
--dog_bite
--
--================
--*/
function dog_bite()
local delta; -- vector
local ldmg; -- float

	if  self.enemy == world then -- TODO check condition
		return
        end

	ai_charge(10)

	if  not CanDamage (self.enemy, self) then -- TODO check condition
		return
        end

	delta = self.enemy.origin - self.origin

	if vlen(delta) > 100 then -- TODO check condition
		return
        end
		
	ldmg = (random() + random() + random()) * 8
	T_Damage (self.enemy, self, self, ldmg)
end

function Dog_JumpTouch()
	local ldmg; -- float

	if self.health <= 0 then -- TODO check condition
		return
        end
		
	if other.takedamage ~= 0 then -- TODO check condition
		if  vlen(self.velocity) > 300  then -- TODO check condition
			ldmg = 10 + 10*random()
			T_Damage (other, self, self, ldmg)	
		end
	end

	if  not checkbottom(self) then -- TODO check condition
		if self.flags & FL_ONGROUND then -- TODO check condition
--dprint ("popjump\n")
	                self.touch = SUB_Null
    	                self.think = dog_leap1
	                self.nextthink = time + 0.1

--			self.velocity.x = (random() - 0.5) * 600
--			self.velocity.y = (random() - 0.5) * 600
--			self.velocity.z = 200
--			self.flags = self.flags - FL_ONGROUND
		end
		return	-- not on ground yet
	end

	self.touch = SUB_Null
	self.think = dog_run1
	self.nextthink = time + 0.1
end


function dog_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = dog_stand2
	ai_stand()
end
function dog_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = dog_stand3
	ai_stand()
end
function dog_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = dog_stand4
	ai_stand()
end
function dog_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = dog_stand5
	ai_stand()
end
function dog_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = dog_stand6
	ai_stand()
end
function dog_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = dog_stand7
	ai_stand()
end
function dog_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = dog_stand8
	ai_stand()
end
function dog_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = dog_stand9
	ai_stand()
end
function dog_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = dog_stand1
	ai_stand()
end

function dog_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = dog_walk2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE)
        end
end
function dog_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = dog_walk3
	ai_walk(8)
end
function dog_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = dog_walk4
	ai_walk(8)
end
function dog_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = dog_walk5
	ai_walk(8)
end
function dog_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = dog_walk6
	ai_walk(8)
end
function dog_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = dog_walk7
	ai_walk(8)
end
function dog_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = dog_walk8
	ai_walk(8)
end
function dog_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = dog_walk1
	ai_walk(8)
end

function dog_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = dog_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE)
        end
end
function dog_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = dog_run3
	ai_run(32)
end
function dog_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = dog_run4
	ai_run(32)
end
function dog_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = dog_run5
	ai_run(20)
end
function dog_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = dog_run6
	ai_run(64)
end
function dog_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = dog_run7
	ai_run(32)
end
function dog_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = dog_run8
	ai_run(16)
end
function dog_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = dog_run9
	ai_run(32)
end
function dog_run9()
	self.frame=FRAME_run9
	self.nextthink = time + 0.1
	self.think = dog_run10
	ai_run(32)
end
function dog_run10()
	self.frame=FRAME_run10
	self.nextthink = time + 0.1
	self.think = dog_run11
	ai_run(20)
end
function dog_run11()
	self.frame=FRAME_run11
	self.nextthink = time + 0.1
	self.think = dog_run12
	ai_run(64)
end
function dog_run12()
	self.frame=FRAME_run12
	self.nextthink = time + 0.1
	self.think = dog_run1
	ai_run(32)
end

function dog_atta1()
	self.frame=FRAME_attack1
	self.nextthink = time + 0.1
	self.think = dog_atta2
	ai_charge(10)
end
function dog_atta2()
	self.frame=FRAME_attack2
	self.nextthink = time + 0.1
	self.think = dog_atta3
	ai_charge(10)
end
function dog_atta3()
	self.frame=FRAME_attack3
	self.nextthink = time + 0.1
	self.think = dog_atta4
	ai_charge(10)
end
function dog_atta4()
	self.frame=FRAME_attack4
	self.nextthink = time + 0.1
	self.think = dog_atta5
        sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM)
end
function dog_atta5()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = dog_atta6
	ai_charge(10)
end
function dog_atta6()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = dog_atta7
	ai_charge(10)
end
function dog_atta7()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = dog_atta8
	ai_charge(10)
end
function dog_atta8()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = dog_run1
	ai_charge(10)
end

function dog_leap1()
	self.frame=FRAME_leap1
	self.nextthink = time + 0.1
	self.think = dog_leap2
	ai_face()
end
function dog_leap2()
	self.frame=FRAME_leap2
	self.nextthink = time + 0.1
	self.think = dog_leap3
	ai_face()
	
	self.touch = Dog_JumpTouch
	makevectors (self.angles)
	self.origin.z = self.origin.z + 1
	self.velocity = qc.v_forward * 300 + vec3(0, 0, 200)
	if self.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
		self.flags = self.flags - FL_ONGROUND
        end
end

function dog_leap3()
	self.frame=FRAME_leap3
	self.nextthink = time + 0.1
	self.think = dog_leap4
end
function dog_leap4()
	self.frame=FRAME_leap4
	self.nextthink = time + 0.1
	self.think = dog_leap5
end
function dog_leap5()
	self.frame=FRAME_leap5
	self.nextthink = time + 0.1
	self.think = dog_leap6
end
function dog_leap6()
	self.frame=FRAME_leap6
	self.nextthink = time + 0.1
	self.think = dog_leap7
end
function dog_leap7()
	self.frame=FRAME_leap7
	self.nextthink = time + 0.1
	self.think = dog_leap8
end
function dog_leap8()
	self.frame=FRAME_leap8
	self.nextthink = time + 0.1
	self.think = dog_leap9
end
function dog_leap9()
	self.frame=FRAME_leap9
	self.nextthink = time + 0.1
	self.think = dog_leap9
end

function dog_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = dog_pain2
end
function dog_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = dog_pain3
end
function dog_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = dog_pain4
end
function dog_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = dog_pain5
end
function dog_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = dog_pain6
end
function dog_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = dog_run1
end

function dog_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = dog_painb2
end
function dog_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = dog_painb3
end
function dog_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = dog_painb4
	ai_pain(4)
end
function dog_painb4()
	self.frame=FRAME_painb4
	self.nextthink = time + 0.1
	self.think = dog_painb5
	ai_pain(12)
end
function dog_painb5()
	self.frame=FRAME_painb5
	self.nextthink = time + 0.1
	self.think = dog_painb6
	ai_pain(12)
end
function dog_painb6()
	self.frame=FRAME_painb6
	self.nextthink = time + 0.1
	self.think = dog_painb7
	ai_pain(2)
end
function dog_painb7()
	self.frame=FRAME_painb7
	self.nextthink = time + 0.1
	self.think = dog_painb8
end
function dog_painb8()
	self.frame=FRAME_painb8
	self.nextthink = time + 0.1
	self.think = dog_painb9
	ai_pain(4)
end
function dog_painb9()
	self.frame=FRAME_painb9
	self.nextthink = time + 0.1
	self.think = dog_painb10
end
function dog_painb10()
	self.frame=FRAME_painb10
	self.nextthink = time + 0.1
	self.think = dog_painb11
	ai_pain(10)
end
function dog_painb11()
	self.frame=FRAME_painb11
	self.nextthink = time + 0.1
	self.think = dog_painb12
end
function dog_painb12()
	self.frame=FRAME_painb12
	self.nextthink = time + 0.1
	self.think = dog_painb13
end
function dog_painb13()
	self.frame=FRAME_painb13
	self.nextthink = time + 0.1
	self.think = dog_painb14
end
function dog_painb14()
	self.frame=FRAME_painb14
	self.nextthink = time + 0.1
	self.think = dog_painb15
end
function dog_painb15()
	self.frame=FRAME_painb15
	self.nextthink = time + 0.1
	self.think = dog_painb16
end
function dog_painb16()
	self.frame=FRAME_painb16
	self.nextthink = time + 0.1
	self.think = dog_run1
end

function dog_pain()
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM)

	if random() > 0.5 then -- TODO check condition
		dog_pain1 ()
	else
		dog_painb1 ()
        end
end

function dog_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = dog_die2
end
function dog_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = dog_die3
end
function dog_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = dog_die4
end
function dog_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = dog_die5
end
function dog_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = dog_die6
end
function dog_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = dog_die7
end
function dog_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = dog_die8
end
function dog_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = dog_die9
end
function dog_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = dog_die9
end

function dog_dieb1()
	self.frame=FRAME_deathb1
	self.nextthink = time + 0.1
	self.think = dog_dieb2
end
function dog_dieb2()
	self.frame=FRAME_deathb2
	self.nextthink = time + 0.1
	self.think = dog_dieb3
end
function dog_dieb3()
	self.frame=FRAME_deathb3
	self.nextthink = time + 0.1
	self.think = dog_dieb4
end
function dog_dieb4()
	self.frame=FRAME_deathb4
	self.nextthink = time + 0.1
	self.think = dog_dieb5
end
function dog_dieb5()
	self.frame=FRAME_deathb5
	self.nextthink = time + 0.1
	self.think = dog_dieb6
end
function dog_dieb6()
	self.frame=FRAME_deathb6
	self.nextthink = time + 0.1
	self.think = dog_dieb7
end
function dog_dieb7()
	self.frame=FRAME_deathb7
	self.nextthink = time + 0.1
	self.think = dog_dieb8
end
function dog_dieb8()
	self.frame=FRAME_deathb8
	self.nextthink = time + 0.1
	self.think = dog_dieb9
end
function dog_dieb9()
	self.frame=FRAME_deathb9
	self.nextthink = time + 0.1
	self.think = dog_dieb9
end


function dog_die()
-- check for gib
	if self.health < -35 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowGib ("progs/gib3.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		ThrowHead ("progs/h_dog.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM)
	self.solid = SOLID_NOT

	if random() > 0.5 then -- TODO check condition
		dog_die1 ()
	else
		dog_dieb1 ()
        end
end

--============================================================================

--/*
--==============
--CheckDogMelee
--
--Returns true if a melee attack would hit right now
--==============
--*/
function CheckDogMelee()
	if enemy_range == RANGE_MELEE then -- TODO check condition
		self.attack_state = AS_MELEE
		return true
	end
	return false
end

--/*
--==============
--CheckDogJump
--
--==============
--*/
function CheckDogJump()
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
	
	if d < 80 then -- TODO check condition
		return false
        end
		
	if d > 150 then -- TODO check condition
		return false
        end
		
	return true
end

function DogCheckAttack()
	local vec; -- vector
	
-- if close enough for slashing, go for it
	if CheckDogMelee () then -- TODO check condition
		self.attack_state = AS_MELEE
		return true
	end
	
	if CheckDogJump () then -- TODO check condition
		self.attack_state = AS_MISSILE
		return true
	end
	
	return false
end


--===========================================================================

--/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush
--
--*/
function monster_dog()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/h_dog.mdl")
	precache_model ("progs/dog.mdl")

	precache_sound ("dog/dattack1.wav")
	precache_sound ("dog/ddeath.wav")
	precache_sound ("dog/dpain1.wav")
	precache_sound ("dog/dsight.wav")
	precache_sound ("dog/idle.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/dog.mdl")

	setsize (self, vec3(-32, -32, -24), vec3(32, 32, 40))
	self.health = 25

	self.th_stand = dog_stand1
	self.th_walk = dog_walk1
	self.th_run = dog_run1
	self.th_pain = dog_pain
	self.th_die = dog_die
	self.th_melee = dog_atta1
	self.th_missile = dog_leap1

	walkmonster_start()
end
