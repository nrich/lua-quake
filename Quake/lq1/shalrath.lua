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
--SHAL-RATH
--
--==============================================================================
--*/

local FRAME_attack1,FRAME_attack2,FRAME_attack3,FRAME_attack4,FRAME_attack5,FRAME_attack6,FRAME_attack7,FRAME_attack8 = 0,1,2,3,4,5,6,7
local FRAME_attack9,FRAME_attack10,FRAME_attack11 = 8,9,10

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5 = 11,12,13,14,15

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7 = 16,17,18,19,20,21,22

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9,FRAME_walk10 = 23,24,25,26,27,28,29,30,31,32
local FRAME_walk11,FRAME_walk12 = 33,34

function shal_stand()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = shal_stand
	ai_stand()
end

function shal_walk1()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = shal_walk2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE)
        end
end
function shal_walk2()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = shal_walk3
	ai_walk(4)
end
function shal_walk3()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = shal_walk4
	ai_walk(0)
end
function shal_walk4()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = shal_walk5
	ai_walk(0)
end
function shal_walk5()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = shal_walk6
	ai_walk(0)
end
function shal_walk6()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = shal_walk7
	ai_walk(0)
end
function shal_walk7()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = shal_walk8
	ai_walk(5)
end
function shal_walk8()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = shal_walk9
	ai_walk(6)
end
function shal_walk9()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = shal_walk10
	ai_walk(5)
end
function shal_walk10()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = shal_walk11
	ai_walk(0)
end
function shal_walk11()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = shal_walk12
	ai_walk(4)
end
function shal_walk12()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = shal_walk1
	ai_walk(5)
end

function shal_run1()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = shal_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE)
        end
end
function shal_run2()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = shal_run3
	ai_run(4)
end
function shal_run3()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = shal_run4
	ai_run(0)
end
function shal_run4()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = shal_run5
	ai_run(0)
end
function shal_run5()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = shal_run6
	ai_run(0)
end
function shal_run6()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = shal_run7
	ai_run(0)
end
function shal_run7()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = shal_run8
	ai_run(5)
end
function shal_run8()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = shal_run9
	ai_run(6)
end
function shal_run9()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = shal_run10
	ai_run(5)
end
function shal_run10()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = shal_run11
	ai_run(0)
end
function shal_run11()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = shal_run12
	ai_run(4)
end
function shal_run12()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = shal_run1
	ai_run(5)
end

function shal_attack1()
	self.frame=FRAME_attack1
	self.nextthink = time + 0.1
	self.think = shal_attack2
        sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM)
        ai_face()
end
function shal_attack2()
	self.frame=FRAME_attack2
	self.nextthink = time + 0.1
	self.think = shal_attack3
	ai_face()
end
function shal_attack3()
	self.frame=FRAME_attack3
	self.nextthink = time + 0.1
	self.think = shal_attack4
	ai_face()
end
function shal_attack4()
	self.frame=FRAME_attack4
	self.nextthink = time + 0.1
	self.think = shal_attack5
	ai_face()
end
function shal_attack5()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = shal_attack6
	ai_face()
end
function shal_attack6()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = shal_attack7
	ai_face()
end
function shal_attack7()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = shal_attack8
	ai_face()
end
function shal_attack8()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = shal_attack9
	ai_face()
end
function shal_attack9()
	self.frame=FRAME_attack9
	self.nextthink = time + 0.1
	self.think = shal_attack10
	ShalMissile()
end
function shal_attack10()
	self.frame=FRAME_attack10
	self.nextthink = time + 0.1
	self.think = shal_attack11
	ai_face()
end
function shal_attack11()
	self.frame=FRAME_attack11
	self.nextthink = time + 0.1
	self.think = shal_run1
end

function shal_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = shal_pain2
end
function shal_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = shal_pain3
end
function shal_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = shal_pain4
end
function shal_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = shal_pain5
end
function shal_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = shal_run1
end

function shal_death1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = shal_death2
end
function shal_death2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = shal_death3
end
function shal_death3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = shal_death4
end
function shal_death4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = shal_death5
end
function shal_death5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = shal_death6
end
function shal_death6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = shal_death7
end
function shal_death7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = shal_death7
end


function shalrath_pain()
        if not self.pain_finished then self.pain_finished = 0 end

	if self.pain_finished > time then -- TODO check condition
		return
        end

	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM)
	shal_pain1()
	self.pain_finished = time + 3
end

function shalrath_die()
-- check for gib
	if self.health < -90 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_shal.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM)
	shal_death1()
	self.solid = SOLID_NOT
	-- insert death sounds here
end

--/*
--================
--ShalMissile
--================
--*/
function ShalMissile()
	local missile; -- entity
	local dir; -- vector
	local dist, flytime; -- float

	dir = normalize((self.enemy.origin + vec3(0, 0, 10)) - self.origin)
	dist = vlen (self.enemy.origin - self.origin)
	flytime = dist * 0.002
	if flytime < 0.1 then -- TODO check condition
		flytime = 0.1
        end

	self.effects = self.effects | EF_MUZZLEFLASH
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM)

	missile = spawn ()
	missile.owner = self

	missile.solid = SOLID_BBOX
	missile.movetype = MOVETYPE_FLYMISSILE
	setmodel (missile, "progs/v_spike.mdl")

	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		

	missile.origin = self.origin + vec3(0, 0, 10)
	missile.velocity = dir * 400
	missile.avelocity = vec3(300, 300, 300)
	missile.nextthink = flytime + time
	missile.think = ShalHome
	missile.enemy = self.enemy
	missile.touch = ShalMissileTouch
end

function ShalHome()
	local dir, vtemp; -- vector
	vtemp = self.enemy.origin + vec3(0, 0, 10)
	if self.enemy.health < 1 then -- TODO check condition
		remove(self)
		return
	end
	dir = normalize(vtemp - self.origin)
	if skill == 3 then -- TODO check condition
		self.velocity = dir * 350
	else
		self.velocity = dir * 250
end
	self.nextthink = time + 0.2
	self.think = ShalHome	
end

function ShalMissileTouch()
	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end

	if other.classname == "monster.zombie" then -- TODO check condition
		T_Damage (other, self, self, 110)	
        end
	T_RadiusDamage (self, self.owner, 40, world)
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_EXPLOSION)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)

	self.velocity = vec3(0, 0, 0)
	self.touch = SUB_Null
	setmodel (self, "progs/s_explod.spr")
	self.solid = SOLID_NOT
	s_explode1 ()
end

--=================================================================

--/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
--*/
function monster_shalrath()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model2 ("progs/shalrath.mdl")
	precache_model2 ("progs/h_shal.mdl")
	precache_model2 ("progs/v_spike.mdl")
	
	precache_sound2 ("shalrath/attack.wav")
	precache_sound2 ("shalrath/attack2.wav")
	precache_sound2 ("shalrath/death.wav")
	precache_sound2 ("shalrath/idle.wav")
	precache_sound2 ("shalrath/pain.wav")
	precache_sound2 ("shalrath/sight.wav")
	
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP
	
	setmodel (self, "progs/shalrath.mdl")
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX)
	self.health = 400

	self.th_stand = shal_stand
	self.th_walk = shal_walk1
	self.th_run = shal_run1
	self.th_die = shalrath_die
	self.th_pain = shalrath_pain
	self.th_missile = shal_attack1

	self.think = walkmonster_start
	self.nextthink = time + 0.1 + random ()*0.1	
end
