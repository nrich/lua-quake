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


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7 = 0,1,2,3,4,5,6

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9,FRAME_walk10 = 7,8,9,10,11,12,13,14,15,16
local FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15,FRAME_walk16 = 17,18,19,20,21,22

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8 = 23,24,25,26,27,28,29,30

local FRAME_attack1,FRAME_attack2,FRAME_attack3,FRAME_attack4,FRAME_attack5,FRAME_attack6 = 31,32,33,34,35,36
local FRAME_attack7,FRAME_attack8,FRAME_attack9,FRAME_attack10 = 37,38,39,40

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8 = 41,42,43,44,45,46,47,48
local FRAME_death9,FRAME_death10,FRAME_death11,FRAME_death12,FRAME_death13,FRAME_death14 = 49,50,51,52,53,54

local FRAME_fdeath1,FRAME_fdeath2,FRAME_fdeath3,FRAME_fdeath4,FRAME_fdeath5,FRAME_fdeath6,FRAME_fdeath7,FRAME_fdeath8 = 55,56,57,58,59,60,61,62
local FRAME_fdeath9,FRAME_fdeath10,FRAME_fdeath11 = 63,64,65

local FRAME_paina1,FRAME_paina2,FRAME_paina3,FRAME_paina4 = 66,67,68,69

local FRAME_painb1,FRAME_painb2,FRAME_painb3,FRAME_painb4,FRAME_painb5 = 70,71,72,73,74

local FRAME_painc1,FRAME_painc2,FRAME_painc3,FRAME_painc4,FRAME_painc5,FRAME_painc6,FRAME_painc7,FRAME_painc8 = 75,76,77,78,79,80,81,82

local FRAME_paind1,FRAME_paind2,FRAME_paind3,FRAME_paind4,FRAME_paind5,FRAME_paind6,FRAME_paind7,FRAME_paind8 = 83,84,85,86,87,88,89,90
local FRAME_paind9,FRAME_paind10,FRAME_paind11,FRAME_paind12,FRAME_paind13,FRAME_paind14,FRAME_paind15,FRAME_paind16 = 91,92,93,94,95,96,97,98
local FRAME_paind17,FRAME_paind18,FRAME_paind19 = 99,100,101


function Laser_Touch()
	local org; -- vector
	
	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end

	if pointcontents(self.origin) == CONTENT_SKY then -- TODO check condition
		remove(self)
		return
	end
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC)
	org = self.origin - 8*normalize(self.velocity)

	if other.health ~= 0 then -- TODO check condition
		SpawnBlood (org, self.velocity*0.2, 15)
		T_Damage (other, self, self.owner, 15)
	else
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
		WriteByte (MSG_BROADCAST, TE_GUNSHOT)
		WriteCoord (MSG_BROADCAST, org.x)
		WriteCoord (MSG_BROADCAST, org.y)
		WriteCoord (MSG_BROADCAST, org.z)
	end
	
	remove(self)	
end

function LaunchLaser(org, vec) -- vector, vector
	if self.classname == "monster_enforcer" then -- TODO check condition
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM)
        end

	vec = normalize(vec)
	
	newmis = spawn()
	newmis.owner = self
	newmis.movetype = MOVETYPE_FLY
	newmis.solid = SOLID_BBOX
	newmis.effects = EF_DIMLIGHT

	setmodel (newmis, "progs/laser.mdl")
	setsize (newmis, vec3(0, 0, 0), vec3(0, 0, 0))		

	setorigin (newmis, org)

	newmis.velocity = vec * 600
	newmis.angles = vectoangles(newmis.velocity)

	newmis.nextthink = time + 5
	newmis.think = SUB_Remove
	newmis.touch = Laser_Touch
end



function enforcer_fire()
	local org; -- vector

	self.effects = self.effects | EF_MUZZLEFLASH
	makevectors (self.angles)
	
	org = self.origin + qc.v_forward * 30 + qc.v_right * 8.5 + vec3(0, 0, 16)

	LaunchLaser(org, self.enemy.origin - self.origin)
end

--============================================================================

function enf_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = enf_stand2
	ai_stand()
end
function enf_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = enf_stand3
	ai_stand()
end
function enf_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = enf_stand4
	ai_stand()
end
function enf_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = enf_stand5
	ai_stand()
end
function enf_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = enf_stand6
	ai_stand()
end
function enf_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = enf_stand7
	ai_stand()
end
function enf_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = enf_stand1
	ai_stand()
end

function enf_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = enf_walk2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE)
        end
end
function enf_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = enf_walk3
	ai_walk(4)
end
function enf_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = enf_walk4
	ai_walk(4)
end
function enf_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = enf_walk5
	ai_walk(3)
end
function enf_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = enf_walk6
	ai_walk(1)
end
function enf_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = enf_walk7
	ai_walk(2)
end
function enf_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = enf_walk8
	ai_walk(2)
end
function enf_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = enf_walk9
	ai_walk(1)
end
function enf_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = enf_walk10
	ai_walk(2)
end
function enf_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = enf_walk11
	ai_walk(4)
end
function enf_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = enf_walk12
	ai_walk(4)
end
function enf_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = enf_walk13
	ai_walk(1)
end
function enf_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = enf_walk14
	ai_walk(2)
end
function enf_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = enf_walk15
	ai_walk(3)
end
function enf_walk15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = enf_walk16
	ai_walk(4)
end
function enf_walk16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = enf_walk1
	ai_walk(2)
end

function enf_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = enf_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE)
        end
end
function enf_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = enf_run3
	ai_run(14)
end
function enf_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = enf_run4
	ai_run(7)
end
function enf_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = enf_run5
	ai_run(12)
end
function enf_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = enf_run6
	ai_run(14)
end
function enf_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = enf_run7
	ai_run(14)
end
function enf_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = enf_run8
	ai_run(7)
end
function enf_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = enf_run1
	ai_run(11)
end

function enf_atk1()
	self.frame=FRAME_attack1
	self.nextthink = time + 0.1
	self.think = enf_atk2
	ai_face()
end
function enf_atk2()
	self.frame=FRAME_attack2
	self.nextthink = time + 0.1
	self.think = enf_atk3
	ai_face()
end
function enf_atk3()
	self.frame=FRAME_attack3
	self.nextthink = time + 0.1
	self.think = enf_atk4
	ai_face()
end
function enf_atk4()
	self.frame=FRAME_attack4
	self.nextthink = time + 0.1
	self.think = enf_atk5
	ai_face()
end
function enf_atk5()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = enf_atk6
	ai_face()
end
function enf_atk6()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = enf_atk7
	enforcer_fire()
end
function enf_atk7()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = enf_atk8
	ai_face()
end
function enf_atk8()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = enf_atk9
	ai_face()
end
function enf_atk9()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = enf_atk10
	ai_face()
end
function enf_atk10()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = enf_atk11
	enforcer_fire()
end
function enf_atk11()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = enf_atk12
	ai_face()
end
function enf_atk12()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = enf_atk13
	ai_face()
end
function enf_atk13()
	self.frame=FRAME_attack9
	self.nextthink = time + 0.1
	self.think = enf_atk14
	ai_face()
end
function enf_atk14()
	self.frame=FRAME_attack10
	self.nextthink = time + 0.1
	self.think = enf_run1
	ai_face()
	SUB_CheckRefire (enf_atk1)
end

function enf_paina1()
	self.frame=FRAME_paina1
	self.nextthink = time + 0.1
	self.think = enf_paina2
end
function enf_paina2()
	self.frame=FRAME_paina2
	self.nextthink = time + 0.1
	self.think = enf_paina3
end
function enf_paina3()
	self.frame=FRAME_paina3
	self.nextthink = time + 0.1
	self.think = enf_paina4
end
function enf_paina4()
	self.frame=FRAME_paina4
	self.nextthink = time + 0.1
	self.think = enf_run1
end

function enf_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = enf_painb2
end
function enf_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = enf_painb3
end
function enf_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = enf_painb4
end
function enf_painb4()
	self.frame=FRAME_painb4
	self.nextthink = time + 0.1
	self.think = enf_painb5
end
function enf_painb5()
	self.frame=FRAME_painb5
	self.nextthink = time + 0.1
	self.think = enf_run1
end

function enf_painc1()
	self.frame=FRAME_painc1
	self.nextthink = time + 0.1
	self.think = enf_painc2
end
function enf_painc2()
	self.frame=FRAME_painc2
	self.nextthink = time + 0.1
	self.think = enf_painc3
end
function enf_painc3()
	self.frame=FRAME_painc3
	self.nextthink = time + 0.1
	self.think = enf_painc4
end
function enf_painc4()
	self.frame=FRAME_painc4
	self.nextthink = time + 0.1
	self.think = enf_painc5
end
function enf_painc5()
	self.frame=FRAME_painc5
	self.nextthink = time + 0.1
	self.think = enf_painc6
end
function enf_painc6()
	self.frame=FRAME_painc6
	self.nextthink = time + 0.1
	self.think = enf_painc7
end
function enf_painc7()
	self.frame=FRAME_painc7
	self.nextthink = time + 0.1
	self.think = enf_painc8
end
function enf_painc8()
	self.frame=FRAME_painc8
	self.nextthink = time + 0.1
	self.think = enf_run1
end

function enf_paind1()
	self.frame=FRAME_paind1
	self.nextthink = time + 0.1
	self.think = enf_paind2
end
function enf_paind2()
	self.frame=FRAME_paind2
	self.nextthink = time + 0.1
	self.think = enf_paind3
end
function enf_paind3()
	self.frame=FRAME_paind3
	self.nextthink = time + 0.1
	self.think = enf_paind4
end
function enf_paind4()
	self.frame=FRAME_paind4
	self.nextthink = time + 0.1
	self.think = enf_paind5
	ai_painforward(2)
end
function enf_paind5()
	self.frame=FRAME_paind5
	self.nextthink = time + 0.1
	self.think = enf_paind6
	ai_painforward(1)
end
function enf_paind6()
	self.frame=FRAME_paind6
	self.nextthink = time + 0.1
	self.think = enf_paind7
end
function enf_paind7()
	self.frame=FRAME_paind7
	self.nextthink = time + 0.1
	self.think = enf_paind8
end
function enf_paind8()
	self.frame=FRAME_paind8
	self.nextthink = time + 0.1
	self.think = enf_paind9
end
function enf_paind9()
	self.frame=FRAME_paind9
	self.nextthink = time + 0.1
	self.think = enf_paind10
end
function enf_paind10()
	self.frame=FRAME_paind10
	self.nextthink = time + 0.1
	self.think = enf_paind11
end
function enf_paind11()
	self.frame=FRAME_paind11
	self.nextthink = time + 0.1
	self.think = enf_paind12
	ai_painforward(1)
end
function enf_paind12()
	self.frame=FRAME_paind12
	self.nextthink = time + 0.1
	self.think = enf_paind13
	ai_painforward(1)
end
function enf_paind13()
	self.frame=FRAME_paind13
	self.nextthink = time + 0.1
	self.think = enf_paind14
	ai_painforward(1)
end
function enf_paind14()
	self.frame=FRAME_paind14
	self.nextthink = time + 0.1
	self.think = enf_paind15
end
function enf_paind15()
	self.frame=FRAME_paind15
	self.nextthink = time + 0.1
	self.think = enf_paind16
end
function enf_paind16()
	self.frame=FRAME_paind16
	self.nextthink = time + 0.1
	self.think = enf_paind17
	ai_pain(1)
end
function enf_paind17()
	self.frame=FRAME_paind17
	self.nextthink = time + 0.1
	self.think = enf_paind18
	ai_pain(1)
end
function enf_paind18()
	self.frame=FRAME_paind18
	self.nextthink = time + 0.1
	self.think = enf_paind19
end
function enf_paind19()
	self.frame=FRAME_paind19
	self.nextthink = time + 0.1
	self.think = enf_run1
end

function enf_pain(attacker, damage) -- entity, float
	local r; -- float

        if not self.pain_finished then self.pain_finished = 0 end

	r = random ()
	if self.pain_finished > time then -- TODO check condition
		return
        end

	
	if r < 0.5 then -- TODO check condition
		sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM)
	else
		sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM)
        end

	if r < 0.2 then -- TODO check condition
		self.pain_finished = time + 1
		enf_paina1 ()
	elseif r < 0.4 then -- TODO check condition
		self.pain_finished = time + 1
		enf_painb1 ()
	elseif r < 0.7 then -- TODO check condition
		self.pain_finished = time + 1
		enf_painc1 ()
	else
		self.pain_finished = time + 2
		enf_paind1 ()
	end
end

--============================================================================




function enf_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = enf_die2
end
function enf_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = enf_die3
end
function enf_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = enf_die4
	self.solid = SOLID_NOT
	self.ammo_cells = 5
	DropBackpack()
end
function enf_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = enf_die5
	ai_forward(14)
end
function enf_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = enf_die6
	ai_forward(2)
end
function enf_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = enf_die7
end
function enf_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = enf_die8
end
function enf_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = enf_die9
end
function enf_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = enf_die10
	ai_forward(3)
end
function enf_die10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = enf_die11
	ai_forward(5)
end
function enf_die11()
	self.frame=FRAME_death11
	self.nextthink = time + 0.1
	self.think = enf_die12
	ai_forward(5)
end
function enf_die12()
	self.frame=FRAME_death12
	self.nextthink = time + 0.1
	self.think = enf_die13
	ai_forward(5)
end
function enf_die13()
	self.frame=FRAME_death13
	self.nextthink = time + 0.1
	self.think = enf_die14
end
function enf_die14()
	self.frame=FRAME_death14
	self.nextthink = time + 0.1
	self.think = enf_die14
end

function enf_fdie1()
	self.frame=FRAME_fdeath1
	self.nextthink = time + 0.1
	self.think = enf_fdie2
end
function enf_fdie2()
	self.frame=FRAME_fdeath2
	self.nextthink = time + 0.1
	self.think = enf_fdie3
end
function enf_fdie3()
	self.frame=FRAME_fdeath3
	self.nextthink = time + 0.1
	self.think = enf_fdie4
	self.solid = SOLID_NOT
	self.ammo_cells = 5
	DropBackpack()
end
function enf_fdie4()
	self.frame=FRAME_fdeath4
	self.nextthink = time + 0.1
	self.think = enf_fdie5
end
function enf_fdie5()
	self.frame=FRAME_fdeath5
	self.nextthink = time + 0.1
	self.think = enf_fdie6
end
function enf_fdie6()
	self.frame=FRAME_fdeath6
	self.nextthink = time + 0.1
	self.think = enf_fdie7
end
function enf_fdie7()
	self.frame=FRAME_fdeath7
	self.nextthink = time + 0.1
	self.think = enf_fdie8
end
function enf_fdie8()
	self.frame=FRAME_fdeath8
	self.nextthink = time + 0.1
	self.think = enf_fdie9
end
function enf_fdie9()
	self.frame=FRAME_fdeath9
	self.nextthink = time + 0.1
	self.think = enf_fdie10
end
function enf_fdie10()
	self.frame=FRAME_fdeath10
	self.nextthink = time + 0.1
	self.think = enf_fdie11
end
function enf_fdie11()
	self.frame=FRAME_fdeath11
	self.nextthink = time + 0.1
	self.think = enf_fdie11
end


function enf_die()
-- check for gib
	if self.health < -35 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_mega.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM)
	if random() > 0.5 then -- TODO check condition
		enf_die1 ()
	else
		enf_fdie1 ()
        end
end


--/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
--
--*/
function monster_enforcer()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model2 ("progs/enforcer.mdl")
	precache_model2 ("progs/h_mega.mdl")
	precache_model2 ("progs/laser.mdl")

	precache_sound2 ("enforcer/death1.wav")
	precache_sound2 ("enforcer/enfire.wav")
	precache_sound2 ("enforcer/enfstop.wav")
	precache_sound2 ("enforcer/idle1.wav")
	precache_sound2 ("enforcer/pain1.wav")
	precache_sound2 ("enforcer/pain2.wav")
	precache_sound2 ("enforcer/sight1.wav")
	precache_sound2 ("enforcer/sight2.wav")
	precache_sound2 ("enforcer/sight3.wav")
	precache_sound2 ("enforcer/sight4.wav")
	
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/enforcer.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 80

	self.th_stand = enf_stand1
	self.th_walk = enf_walk1
	self.th_run = enf_run1
	self.th_pain = enf_pain
	self.th_die = enf_die
	self.th_missile = enf_atk1

	walkmonster_start()
end
