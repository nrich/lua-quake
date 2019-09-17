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
--SOLDIER / PLAYER
--
--==============================================================================
--*/


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8 = 0,1,2,3,4,5,6,7

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8 = 8,9,10,11,12,13,14,15
local FRAME_death9,FRAME_death10 = 16,17

local FRAME_deathc1,FRAME_deathc2,FRAME_deathc3,FRAME_deathc4,FRAME_deathc5,FRAME_deathc6,FRAME_deathc7,FRAME_deathc8 = 18,19,20,21,22,23,24,25
local FRAME_deathc9,FRAME_deathc10,FRAME_deathc11 = 26,27,28

local FRAME_load1,FRAME_load2,FRAME_load3,FRAME_load4,FRAME_load5,FRAME_load6,FRAME_load7,FRAME_load8,FRAME_load9,FRAME_load10,FRAME_load11 = 29,30,31,32,33,34,35,36,37,38,39

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6 = 40,41,42,43,44,45

local FRAME_painb1,FRAME_painb2,FRAME_painb3,FRAME_painb4,FRAME_painb5,FRAME_painb6,FRAME_painb7,FRAME_painb8,FRAME_painb9,FRAME_painb10 = 46,47,48,49,50,51,52,53,54,55
local FRAME_painb11,FRAME_painb12,FRAME_painb13,FRAME_painb14 = 56,57,58,59

local FRAME_painc1,FRAME_painc2,FRAME_painc3,FRAME_painc4,FRAME_painc5,FRAME_painc6,FRAME_painc7,FRAME_painc8,FRAME_painc9,FRAME_painc10 = 60,61,62,63,64,65,66,67,68,69
local FRAME_painc11,FRAME_painc12,FRAME_painc13 = 70,71,72

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8 = 73,74,75,76,77,78,79,80

local FRAME_shoot1,FRAME_shoot2,FRAME_shoot3,FRAME_shoot4,FRAME_shoot5,FRAME_shoot6,FRAME_shoot7,FRAME_shoot8,FRAME_shoot9 = 81,82,83,84,85,86,87,88,89

local FRAME_prowl_1,FRAME_prowl_2,FRAME_prowl_3,FRAME_prowl_4,FRAME_prowl_5,FRAME_prowl_6,FRAME_prowl_7,FRAME_prowl_8 = 90,91,92,93,94,95,96,97
local FRAME_prowl_9,FRAME_prowl_10,FRAME_prowl_11,FRAME_prowl_12,FRAME_prowl_13,FRAME_prowl_14,FRAME_prowl_15,FRAME_prowl_16 = 98,99,100,101,102,103,104,105
local FRAME_prowl_17,FRAME_prowl_18,FRAME_prowl_19,FRAME_prowl_20,FRAME_prowl_21,FRAME_prowl_22,FRAME_prowl_23,FRAME_prowl_24 = 106,107,108,109,110,111,112,113

--/*
--==============================================================================
--SOLDIER CODE
--==============================================================================
--*/


function army_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = army_stand2
	ai_stand();
end
function army_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = army_stand3
	ai_stand();
end
function army_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = army_stand4
	ai_stand();
end
function army_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = army_stand5
	ai_stand();
end
function army_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = army_stand6
	ai_stand();
end
function army_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = army_stand7
	ai_stand();
end
function army_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = army_stand8
	ai_stand();
end
function army_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = army_stand1
	ai_stand();
end

function army_walk1()
	self.frame=FRAME_prowl_1
	self.nextthink = time + 0.1
	self.think = army_walk2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE)
        end
end
function army_walk2()
	self.frame=FRAME_prowl_2
	self.nextthink = time + 0.1
	self.think = army_walk3
	ai_walk(1);
end
function army_walk3()
	self.frame=FRAME_prowl_3
	self.nextthink = time + 0.1
	self.think = army_walk4
	ai_walk(1);
end
function army_walk4()
	self.frame=FRAME_prowl_4
	self.nextthink = time + 0.1
	self.think = army_walk5
	ai_walk(1);
end
function army_walk5()
	self.frame=FRAME_prowl_5
	self.nextthink = time + 0.1
	self.think = army_walk6
	ai_walk(2);
end
function army_walk6()
	self.frame=FRAME_prowl_6
	self.nextthink = time + 0.1
	self.think = army_walk7
	ai_walk(3);
end
function army_walk7()
	self.frame=FRAME_prowl_7
	self.nextthink = time + 0.1
	self.think = army_walk8
	ai_walk(4);
end
function army_walk8()
	self.frame=FRAME_prowl_8
	self.nextthink = time + 0.1
	self.think = army_walk9
	ai_walk(4);
end
function army_walk9()
	self.frame=FRAME_prowl_9
	self.nextthink = time + 0.1
	self.think = army_walk10
	ai_walk(2);
end
function army_walk10()
	self.frame=FRAME_prowl_10
	self.nextthink = time + 0.1
	self.think = army_walk11
	ai_walk(2);
end
function army_walk11()
	self.frame=FRAME_prowl_11
	self.nextthink = time + 0.1
	self.think = army_walk12
	ai_walk(2);
end
function army_walk12()
	self.frame=FRAME_prowl_12
	self.nextthink = time + 0.1
	self.think = army_walk13
	ai_walk(1);
end
function army_walk13()
	self.frame=FRAME_prowl_13
	self.nextthink = time + 0.1
	self.think = army_walk14
	ai_walk(0);
end
function army_walk14()
	self.frame=FRAME_prowl_14
	self.nextthink = time + 0.1
	self.think = army_walk15
	ai_walk(1);
end
function army_walk15()
	self.frame=FRAME_prowl_15
	self.nextthink = time + 0.1
	self.think = army_walk16
	ai_walk(1);
end
function army_walk16()
	self.frame=FRAME_prowl_16
	self.nextthink = time + 0.1
	self.think = army_walk17
	ai_walk(1);
end
function army_walk17()
	self.frame=FRAME_prowl_17
	self.nextthink = time + 0.1
	self.think = army_walk18
	ai_walk(3);
end
function army_walk18()
	self.frame=FRAME_prowl_18
	self.nextthink = time + 0.1
	self.think = army_walk19
	ai_walk(3);
end
function army_walk19()
	self.frame=FRAME_prowl_19
	self.nextthink = time + 0.1
	self.think = army_walk20
	ai_walk(3);
end
function army_walk20()
	self.frame=FRAME_prowl_20
	self.nextthink = time + 0.1
	self.think = army_walk21
	ai_walk(3);
end
function army_walk21()
	self.frame=FRAME_prowl_21
	self.nextthink = time + 0.1
	self.think = army_walk22
	ai_walk(2);
end
function army_walk22()
	self.frame=FRAME_prowl_22
	self.nextthink = time + 0.1
	self.think = army_walk23
	ai_walk(1);
end
function army_walk23()
	self.frame=FRAME_prowl_23
	self.nextthink = time + 0.1
	self.think = army_walk24
	ai_walk(1);
end
function army_walk24()
	self.frame=FRAME_prowl_24
	self.nextthink = time + 0.1
	self.think = army_walk1
	ai_walk(1);
end

function army_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = army_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE)
        end
end
function army_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = army_run3
	ai_run(15);
end
function army_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = army_run4
	ai_run(10);
end
function army_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = army_run5
	ai_run(10);
end
function army_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = army_run6
	ai_run(8);
end
function army_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = army_run7
	ai_run(15);
end
function army_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = army_run8
	ai_run(10);
end
function army_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = army_run1
	ai_run(8);
end

function army_atk1()
	self.frame=FRAME_shoot1
	self.nextthink = time + 0.1
	self.think = army_atk2
	ai_face();
end
function army_atk2()
	self.frame=FRAME_shoot2
	self.nextthink = time + 0.1
	self.think = army_atk3
	ai_face();
end
function army_atk3()
	self.frame=FRAME_shoot3
	self.nextthink = time + 0.1
	self.think = army_atk4
	ai_face();
end
function army_atk4()
	self.frame=FRAME_shoot4
	self.nextthink = time + 0.1
	self.think = army_atk5
	ai_face();
end
function army_atk5()
	self.frame=FRAME_shoot5
	self.nextthink = time + 0.1
	self.think = army_atk6
	ai_face();
        army_fire();
        self.effects = self.effects | EF_MUZZLEFLASH;
end
function army_atk6()
	self.frame=FRAME_shoot6
	self.nextthink = time + 0.1
	self.think = army_atk7
	ai_face();
end
function army_atk7()
	self.frame=FRAME_shoot7
	self.nextthink = time + 0.1
	self.think = army_atk8
	ai_face();
        SUB_CheckRefire (army_atk1);
end
function army_atk8()
	self.frame=FRAME_shoot8
	self.nextthink = time + 0.1
	self.think = army_atk9
	ai_face();
end
function army_atk9()
	self.frame=FRAME_shoot9
	self.nextthink = time + 0.1
	self.think = army_run1
	ai_face();
end


function army_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = army_pain2
end
function army_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = army_pain3
end
function army_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = army_pain4
end
function army_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = army_pain5
end
function army_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = army_pain6
end
function army_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = army_run1
	ai_pain(1);
end

function army_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = army_painb2
end
function army_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = army_painb3
	ai_painforward(13);
end
function army_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = army_painb4
	ai_painforward(9);
end
function army_painb4()
	self.frame=FRAME_painb4
	self.nextthink = time + 0.1
	self.think = army_painb5
end
function army_painb5()
	self.frame=FRAME_painb5
	self.nextthink = time + 0.1
	self.think = army_painb6
end
function army_painb6()
	self.frame=FRAME_painb6
	self.nextthink = time + 0.1
	self.think = army_painb7
end
function army_painb7()
	self.frame=FRAME_painb7
	self.nextthink = time + 0.1
	self.think = army_painb8
end
function army_painb8()
	self.frame=FRAME_painb8
	self.nextthink = time + 0.1
	self.think = army_painb9
end
function army_painb9()
	self.frame=FRAME_painb9
	self.nextthink = time + 0.1
	self.think = army_painb10
end
function army_painb10()
	self.frame=FRAME_painb10
	self.nextthink = time + 0.1
	self.think = army_painb11
end
function army_painb11()
	self.frame=FRAME_painb11
	self.nextthink = time + 0.1
	self.think = army_painb12
end
function army_painb12()
	self.frame=FRAME_painb12
	self.nextthink = time + 0.1
	self.think = army_painb13
	ai_pain(2);
end
function army_painb13()
	self.frame=FRAME_painb13
	self.nextthink = time + 0.1
	self.think = army_painb14
end
function army_painb14()
	self.frame=FRAME_painb14
	self.nextthink = time + 0.1
	self.think = army_run1
end

function army_painc1()
	self.frame=FRAME_painc1
	self.nextthink = time + 0.1
	self.think = army_painc2
end
function army_painc2()
	self.frame=FRAME_painc2
	self.nextthink = time + 0.1
	self.think = army_painc3
	ai_pain(1);
end
function army_painc3()
	self.frame=FRAME_painc3
	self.nextthink = time + 0.1
	self.think = army_painc4
end
function army_painc4()
	self.frame=FRAME_painc4
	self.nextthink = time + 0.1
	self.think = army_painc5
end
function army_painc5()
	self.frame=FRAME_painc5
	self.nextthink = time + 0.1
	self.think = army_painc6
	ai_painforward(1);
end
function army_painc6()
	self.frame=FRAME_painc6
	self.nextthink = time + 0.1
	self.think = army_painc7
	ai_painforward(1);
end
function army_painc7()
	self.frame=FRAME_painc7
	self.nextthink = time + 0.1
	self.think = army_painc8
end
function army_painc8()
	self.frame=FRAME_painc8
	self.nextthink = time + 0.1
	self.think = army_painc9
	ai_pain(1);
end
function army_painc9()
	self.frame=FRAME_painc9
	self.nextthink = time + 0.1
	self.think = army_painc10
	ai_painforward(4);
end
function army_painc10()
	self.frame=FRAME_painc10
	self.nextthink = time + 0.1
	self.think = army_painc11
	ai_painforward(3);
end
function army_painc11()
	self.frame=FRAME_painc11
	self.nextthink = time + 0.1
	self.think = army_painc12
	ai_painforward(6);
end
function army_painc12()
	self.frame=FRAME_painc12
	self.nextthink = time + 0.1
	self.think = army_painc13
	ai_painforward(8);
end
function army_painc13()
	self.frame=FRAME_painc13
	self.nextthink = time + 0.1
	self.think = army_run1
end

function army_pain(attacker, damage) -- entity, float
	local r; -- float
	
        if not self.pain_finished then self.pain_finished = 0 end
	if self.pain_finished > time then -- TODO check condition
		return
        end

	r = random()

	if r < 0.2 then -- TODO check condition
		self.pain_finished = time + 0.6
		army_pain1 ()
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM)
	elseif r < 0.6 then -- TODO check condition
		self.pain_finished = time + 1.1
		army_painb1 ()
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM)
	else
		self.pain_finished = time + 1.1
		army_painc1 ()
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM)
	end
end


function army_fire()
	local dir; -- vector
	local en; -- entity
	
	ai_face()
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM)	

-- fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy
	
	dir = en.origin - en.velocity*0.2
	dir = normalize (dir - self.origin)
	
	FireBullets (4, dir, vec3(0.1, 0.1, 0))
end



function army_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = army_die2
end
function army_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = army_die3
end
function army_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = army_die4
	self.solid = SOLID_NOT;self.ammo_shells = 5;
        DropBackpack();
end
function army_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = army_die5
end
function army_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = army_die6
end
function army_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = army_die7
end
function army_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = army_die8
end
function army_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = army_die9
end
function army_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = army_die10
end
function army_die10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = army_die10
end

function army_cdie1()
	self.frame=FRAME_deathc1
	self.nextthink = time + 0.1
	self.think = army_cdie2
end
function army_cdie2()
	self.frame=FRAME_deathc2
	self.nextthink = time + 0.1
	self.think = army_cdie3
	ai_back(5);
end
function army_cdie3()
	self.frame=FRAME_deathc3
	self.nextthink = time + 0.1
	self.think = army_cdie4
	self.solid = SOLID_NOT;self.ammo_shells = 5;DropBackpack();ai_back(4);
end
function army_cdie4()
	self.frame=FRAME_deathc4
	self.nextthink = time + 0.1
	self.think = army_cdie5
	ai_back(13);
end
function army_cdie5()
	self.frame=FRAME_deathc5
	self.nextthink = time + 0.1
	self.think = army_cdie6
	ai_back(3);
end
function army_cdie6()
	self.frame=FRAME_deathc6
	self.nextthink = time + 0.1
	self.think = army_cdie7
	ai_back(4);
end
function army_cdie7()
	self.frame=FRAME_deathc7
	self.nextthink = time + 0.1
	self.think = army_cdie8
end
function army_cdie8()
	self.frame=FRAME_deathc8
	self.nextthink = time + 0.1
	self.think = army_cdie9
end
function army_cdie9()
	self.frame=FRAME_deathc9
	self.nextthink = time + 0.1
	self.think = army_cdie10
end
function army_cdie10()
	self.frame=FRAME_deathc10
	self.nextthink = time + 0.1
	self.think = army_cdie11
end
function army_cdie11()
	self.frame=FRAME_deathc11
	self.nextthink = time + 0.1
	self.think = army_cdie11
end


function army_die()
-- check for gib
	if self.health < -35 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_guard.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM)
	if random() < 0.5 then -- TODO check condition
		army_die1 ()
	else
		army_cdie1 ()
        end
end


--/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
--*/
function monster_army()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/soldier.mdl")
	precache_model ("progs/h_guard.mdl")
	precache_model ("progs/gib1.mdl")
	precache_model ("progs/gib2.mdl")
	precache_model ("progs/gib3.mdl")

	precache_sound ("soldier/death1.wav")
	precache_sound ("soldier/idle.wav")
	precache_sound ("soldier/pain1.wav")
	precache_sound ("soldier/pain2.wav")
	precache_sound ("soldier/sattck1.wav")
	precache_sound ("soldier/sight1.wav")

	precache_sound ("player/udeath.wav")		-- gib death


	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/soldier.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 30

	self.th_stand = army_stand1
	self.th_walk = army_walk1
	self.th_run = army_run1
	self.th_missile = army_atk1
	self.th_pain = army_pain
	self.th_die = army_die

	walkmonster_start ()
end
