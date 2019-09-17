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
--KNIGHT
--
--==============================================================================
--*/


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8,FRAME_stand9 = 0,1,2,3,4,5,6,7,8

local FRAME_runb1,FRAME_runb2,FRAME_runb3,FRAME_runb4,FRAME_runb5,FRAME_runb6,FRAME_runb7,FRAME_runb8 = 9,10,11,12,13,14,15,16

--frame runc1 runc2 runc3 runc4 runc5 runc6

local FRAME_runattack1,FRAME_runattack2,FRAME_runattack3,FRAME_runattack4,FRAME_runattack5 = 17,18,19,20,21
local FRAME_runattack6,FRAME_runattack7,FRAME_runattack8,FRAME_runattack9,FRAME_runattack10 = 22,23,24,25,26
local FRAME_runattack11 = 27

local FRAME_pain1,FRAME_pain2,FRAME_pain3 = 28,29,30

local FRAME_painb1,FRAME_painb2,FRAME_painb3,FRAME_painb4,FRAME_painb5,FRAME_painb6,FRAME_painb7,FRAME_painb8,FRAME_painb9 = 31,32,33,34,35,36,37,38,39
local FRAME_painb10,FRAME_painb11 = 40,41

--frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
--frame attack8 attack9 attack10 attack11

local FRAME_attackb1,FRAME_attackb1,FRAME_attackb2,FRAME_attackb3,FRAME_attackb4,FRAME_attackb5 = 42,43,44,45,46,47
local FRAME_attackb6,FRAME_attackb7,FRAME_attackb8,FRAME_attackb9,FRAME_attackb10 = 48,49,50,51,52

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9 = 53,54,55,56,57,58,59,60,61
local FRAME_walk10,FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14 = 62,63,64,65,66

local FRAME_kneel1,FRAME_kneel2,FRAME_kneel3,FRAME_kneel4,FRAME_kneel5 = 67,68,69,70,71

local FRAME_standing2,FRAME_standing3,FRAME_standing4,FRAME_standing5 = 72,73,74,75

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8 = 76,77,78,79,80,81,82,83
local FRAME_death9,FRAME_death10 = 84,85

local FRAME_deathb1,FRAME_deathb2,FRAME_deathb3,FRAME_deathb4,FRAME_deathb5,FRAME_deathb6,FRAME_deathb7,FRAME_deathb8 = 86,87,88,89,90,91,92,93
local FRAME_deathb9,FRAME_deathb10,FRAME_deathb11 = 94,95,96

function knight_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = knight_stand2
	ai_stand()
end
function knight_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = knight_stand3
	ai_stand()
end
function knight_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = knight_stand4
	ai_stand()
end
function knight_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = knight_stand5
	ai_stand()
end
function knight_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = knight_stand6
	ai_stand()
end
function knight_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = knight_stand7
	ai_stand()
end
function knight_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = knight_stand8
	ai_stand()
end
function knight_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = knight_stand9
	ai_stand()
end
function knight_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = knight_stand1
	ai_stand()
end

function knight_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = knight_walk2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE)
        end
end
function knight_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = knight_walk3
	ai_walk(2)
end
function knight_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = knight_walk4
	ai_walk(3)
end
function knight_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = knight_walk5
	ai_walk(4)
end
function knight_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = knight_walk6
	ai_walk(3)
end
function knight_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = knight_walk7
	ai_walk(3)
end
function knight_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = knight_walk8
	ai_walk(3)
end
function knight_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = knight_walk9
	ai_walk(4)
end
function knight_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = knight_walk10
	ai_walk(3)
end
function knight_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = knight_walk11
	ai_walk(3)
end
function knight_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = knight_walk12
	ai_walk(2)
end
function knight_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = knight_walk13
	ai_walk(3)
end
function knight_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = knight_walk14
	ai_walk(4)
end
function knight_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = knight_walk1
	ai_walk(3)
end


function knight_run1()
	self.frame=FRAME_runb1
	self.nextthink = time + 0.1
	self.think = knight_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE)
        end
end
function knight_run2()
	self.frame=FRAME_runb2
	self.nextthink = time + 0.1
	self.think = knight_run3
	ai_run(20)
end
function knight_run3()
	self.frame=FRAME_runb3
	self.nextthink = time + 0.1
	self.think = knight_run4
	ai_run(13)
end
function knight_run4()
	self.frame=FRAME_runb4
	self.nextthink = time + 0.1
	self.think = knight_run5
	ai_run(7)
end
function knight_run5()
	self.frame=FRAME_runb5
	self.nextthink = time + 0.1
	self.think = knight_run6
	ai_run(16)
end
function knight_run6()
	self.frame=FRAME_runb6
	self.nextthink = time + 0.1
	self.think = knight_run7
	ai_run(20)
end
function knight_run7()
	self.frame=FRAME_runb7
	self.nextthink = time + 0.1
	self.think = knight_run8
	ai_run(14)
end
function knight_run8()
	self.frame=FRAME_runb8
	self.nextthink = time + 0.1
	self.think = knight_run1
	ai_run(6)
end


function knight_runatk1()
	self.frame=FRAME_runattack1
	self.nextthink = time + 0.1
	self.think = knight_runatk2
        if random() > 0.5 then -- TODO check condition
	        sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM)
        else
	        sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM)
        end
        ai_charge(20)
end
function knight_runatk2()
	self.frame=FRAME_runattack2
	self.nextthink = time + 0.1
	self.think = knight_runatk3
	ai_charge_side()
end
function knight_runatk3()
	self.frame=FRAME_runattack3
	self.nextthink = time + 0.1
	self.think = knight_runatk4
	ai_charge_side()
end
function knight_runatk4()
	self.frame=FRAME_runattack4
	self.nextthink = time + 0.1
	self.think = knight_runatk5
	ai_charge_side()
end
function knight_runatk5()
	self.frame=FRAME_runattack5
	self.nextthink = time + 0.1
	self.think = knight_runatk6
	ai_melee_side()
end
function knight_runatk6()
	self.frame=FRAME_runattack6
	self.nextthink = time + 0.1
	self.think = knight_runatk7
	ai_melee_side()
end
function knight_runatk7()
	self.frame=FRAME_runattack7
	self.nextthink = time + 0.1
	self.think = knight_runatk8
	ai_melee_side()
end
function knight_runatk8()
	self.frame=FRAME_runattack8
	self.nextthink = time + 0.1
	self.think = knight_runatk9
	ai_melee_side()
end
function knight_runatk9()
	self.frame=FRAME_runattack9
	self.nextthink = time + 0.1
	self.think = knight_runatk10
	ai_melee_side()
end
function knight_runatk10()
	self.frame=FRAME_runattack10
	self.nextthink = time + 0.1
	self.think = knight_runatk11
	ai_charge_side()
end
function knight_runatk11()
	self.frame=FRAME_runattack11
	self.nextthink = time + 0.1
	self.think = knight_run1
	ai_charge(10)
end

function knight_atk1()
	self.frame=FRAME_attackb1
	self.nextthink = time + 0.1
	self.think = knight_atk2
	sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM)
	ai_charge(0)
end
function knight_atk2()
	self.frame=FRAME_attackb2
	self.nextthink = time + 0.1
	self.think = knight_atk3
	ai_charge(7)
end
function knight_atk3()
	self.frame=FRAME_attackb3
	self.nextthink = time + 0.1
	self.think = knight_atk4
	ai_charge(4)
end
function knight_atk4()
	self.frame=FRAME_attackb4
	self.nextthink = time + 0.1
	self.think = knight_atk5
	ai_charge(0)
end
function knight_atk5()
	self.frame=FRAME_attackb5
	self.nextthink = time + 0.1
	self.think = knight_atk6
	ai_charge(3)
end
function knight_atk6()
	self.frame=FRAME_attackb6
	self.nextthink = time + 0.1
	self.think = knight_atk7
	ai_charge(4)
	 ai_melee()
end
function knight_atk7()
	self.frame=FRAME_attackb7
	self.nextthink = time + 0.1
	self.think = knight_atk8
	ai_charge(1)
	 ai_melee()
end
function knight_atk8()
	self.frame=FRAME_attackb8
	self.nextthink = time + 0.1
	self.think = knight_atk9
	ai_charge(3)
	ai_melee()
end
function knight_atk9()
	self.frame=FRAME_attackb9
	self.nextthink = time + 0.1
	self.think = knight_atk10
	ai_charge(1)
end
function knight_atk10()
	self.frame=FRAME_attackb10
	self.nextthink = time + 0.1
	self.think = knight_run1
	ai_charge(5)
end

--===========================================================================

function knight_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = knight_pain2
end
function knight_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = knight_pain3
end
function knight_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = knight_run1
end

function knight_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = knight_painb2
	ai_painforward(0)
end
function knight_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = knight_painb3
	ai_painforward(3)
end
function knight_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = knight_painb4
end
function knight_painb4()
	self.frame=FRAME_painb4
	self.nextthink = time + 0.1
	self.think = knight_painb5
end
function knight_painb5()
	self.frame=FRAME_painb5
	self.nextthink = time + 0.1
	self.think = knight_painb6
	ai_painforward(2)
end
function knight_painb6()
	self.frame=FRAME_painb6
	self.nextthink = time + 0.1
	self.think = knight_painb7
	ai_painforward(4)
end
function knight_painb7()
	self.frame=FRAME_painb7
	self.nextthink = time + 0.1
	self.think = knight_painb8
	ai_painforward(2)
end
function knight_painb8()
	self.frame=FRAME_painb8
	self.nextthink = time + 0.1
	self.think = knight_painb9
	ai_painforward(5)
end
function knight_painb9()
	self.frame=FRAME_painb9
	self.nextthink = time + 0.1
	self.think = knight_painb10
	ai_painforward(5)
end
function knight_painb10()
	self.frame=FRAME_painb10
	self.nextthink = time + 0.1
	self.think = knight_painb11
	ai_painforward(0)
end
function knight_painb11()
	self.frame=FRAME_painb11
	self.nextthink = time + 0.1
	self.think = knight_run1
end

function knight_pain(attacker, damage) -- entity, float
	local r; -- float

        if not self.pain_finished then self.pain_finished = 0 end

	if self.pain_finished > time then -- TODO check condition
		return
        end

	r = random()
	
	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM)
	if r < 0.85 then -- TODO check condition
		knight_pain1 ()
		self.pain_finished = time + 1
	else
		knight_painb1 ()
		self.pain_finished = time + 1
	end
	
end

--===========================================================================

function knight_bow1()
	self.frame=FRAME_kneel1
	self.nextthink = time + 0.1
	self.think = knight_bow2
	ai_turn()
end
function knight_bow2()
	self.frame=FRAME_kneel2
	self.nextthink = time + 0.1
	self.think = knight_bow3
	ai_turn()
end
function knight_bow3()
	self.frame=FRAME_kneel3
	self.nextthink = time + 0.1
	self.think = knight_bow4
	ai_turn()
end
function knight_bow4()
	self.frame=FRAME_kneel4
	self.nextthink = time + 0.1
	self.think = knight_bow5
	ai_turn()
end

function knight_bow5()
	self.frame=FRAME_kneel5
	self.nextthink = time + 0.1
	self.think = knight_bow5
	ai_turn()
end

function knight_bow6()
	self.frame=FRAME_kneel4
	self.nextthink = time + 0.1
	self.think = knight_bow7
	ai_turn()
end
function knight_bow7()
	self.frame=FRAME_kneel3
	self.nextthink = time + 0.1
	self.think = knight_bow8
	ai_turn()
end
function knight_bow8()
	self.frame=FRAME_kneel2
	self.nextthink = time + 0.1
	self.think = knight_bow9
	ai_turn()
end
function knight_bow9()
	self.frame=FRAME_kneel1
	self.nextthink = time + 0.1
	self.think = knight_bow10
	ai_turn()
end
function knight_bow10()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = knight_walk1
	ai_turn()
end



function knight_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = knight_die2
end
function knight_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = knight_die3
end
function knight_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = knight_die4
	self.solid = SOLID_NOT
end
function knight_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = knight_die5
end
function knight_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = knight_die6
end
function knight_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = knight_die7
end
function knight_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = knight_die8
end
function knight_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = knight_die9
end
function knight_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = knight_die10
end
function knight_die10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = knight_die10
end


function knight_dieb1()
	self.frame=FRAME_deathb1
	self.nextthink = time + 0.1
	self.think = knight_dieb2
end
function knight_dieb2()
	self.frame=FRAME_deathb2
	self.nextthink = time + 0.1
	self.think = knight_dieb3
end
function knight_dieb3()
	self.frame=FRAME_deathb3
	self.nextthink = time + 0.1
	self.think = knight_dieb4
	self.solid = SOLID_NOT
end
function knight_dieb4()
	self.frame=FRAME_deathb4
	self.nextthink = time + 0.1
	self.think = knight_dieb5
end
function knight_dieb5()
	self.frame=FRAME_deathb5
	self.nextthink = time + 0.1
	self.think = knight_dieb6
end
function knight_dieb6()
	self.frame=FRAME_deathb6
	self.nextthink = time + 0.1
	self.think = knight_dieb7
end
function knight_dieb7()
	self.frame=FRAME_deathb7
	self.nextthink = time + 0.1
	self.think = knight_dieb8
end
function knight_dieb8()
	self.frame=FRAME_deathb8
	self.nextthink = time + 0.1
	self.think = knight_dieb9
end
function knight_dieb9()
	self.frame=FRAME_deathb9
	self.nextthink = time + 0.1
	self.think = knight_dieb10
end
function knight_dieb10()
	self.frame=FRAME_deathb10
	self.nextthink = time + 0.1
	self.think = knight_dieb11
end
function knight_dieb11()
	self.frame=FRAME_deathb11
	self.nextthink = time + 0.1
	self.think = knight_dieb11
end


function knight_die()
-- check for gib
	if self.health < -40 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_knight.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM)
	if random() < 0.5 then -- TODO check condition
		knight_die1 ()
	else
		knight_dieb1 ()
end
end


--/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
--*/
function monster_knight()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/knight.mdl")
	precache_model ("progs/h_knight.mdl")

	precache_sound ("knight/kdeath.wav")
	precache_sound ("knight/khurt.wav")
	precache_sound ("knight/ksight.wav")
	precache_sound ("knight/sword1.wav")
	precache_sound ("knight/sword2.wav")
	precache_sound ("knight/idle.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/knight.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 75

	self.th_stand = knight_stand1
	self.th_walk = knight_walk1
	self.th_run = knight_run1
	self.th_melee = knight_atk1
	self.th_pain = knight_pain
	self.th_die = knight_die
	
	walkmonster_start ()
end
