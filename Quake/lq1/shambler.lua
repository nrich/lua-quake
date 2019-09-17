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
--SHAMBLER
--
--==============================================================================
--*/


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8,FRAME_stand9 = 0,1,2,3,4,5,6,7,8
local FRAME_stand10,FRAME_stand11,FRAME_stand12,FRAME_stand13,FRAME_stand14,FRAME_stand15,FRAME_stand16,FRAME_stand17 = 9,10,11,12,13,14,15,16

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7 = 17,18,19,20,21,22,23
local FRAME_walk8,FRAME_walk9,FRAME_walk10,FRAME_walk11,FRAME_walk12 = 24,25,26,27,28

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6 = 29,30,31,32,33,34

local FRAME_smash1,FRAME_smash2,FRAME_smash3,FRAME_smash4,FRAME_smash5,FRAME_smash6,FRAME_smash7 = 35,36,37,38,39,40,41
local FRAME_smash8,FRAME_smash9,FRAME_smash10,FRAME_smash11,FRAME_smash12 = 42,43,44,45,46

local FRAME_swingr1,FRAME_swingr2,FRAME_swingr3,FRAME_swingr4,FRAME_swingr5 = 47,48,49,50,51
local FRAME_swingr6,FRAME_swingr7,FRAME_swingr8,FRAME_swingr9 = 52,53,54,55

local FRAME_swingl1,FRAME_swingl2,FRAME_swingl3,FRAME_swingl4,FRAME_swingl5 = 56,57,58,59,60
local FRAME_swingl6,FRAME_swingl7,FRAME_swingl8,FRAME_swingl9 = 61,62,63,64

local FRAME_magic1,FRAME_magic2,FRAME_magic3,FRAME_magic4,FRAME_magic5 = 65,66,67,68,69
local FRAME_magic6,FRAME_magic7,FRAME_magic8,FRAME_magic9,FRAME_magic10,FRAME_magic11,FRAME_magic12 = 70,71,72,73,74,75,76

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6 = 77,78,79,80,81,82

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6 = 83,84,85,86,87,88
local FRAME_death7,FRAME_death8,FRAME_death9,FRAME_death10,FRAME_death11 = 89,90,91,92,93

function sham_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = sham_stand2
	ai_stand()
end
function sham_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = sham_stand3
	ai_stand()
end
function sham_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = sham_stand4
	ai_stand()
end
function sham_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = sham_stand5
	ai_stand()
end
function sham_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = sham_stand6
	ai_stand()
end
function sham_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = sham_stand7
	ai_stand()
end
function sham_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = sham_stand8
	ai_stand()
end
function sham_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = sham_stand9
	ai_stand()
end
function sham_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = sham_stand10
	ai_stand()
end
function sham_stand10()
	self.frame=FRAME_stand10
	self.nextthink = time + 0.1
	self.think = sham_stand11
	ai_stand()
end
function sham_stand11()
	self.frame=FRAME_stand11
	self.nextthink = time + 0.1
	self.think = sham_stand12
	ai_stand()
end
function sham_stand12()
	self.frame=FRAME_stand12
	self.nextthink = time + 0.1
	self.think = sham_stand13
	ai_stand()
end
function sham_stand13()
	self.frame=FRAME_stand13
	self.nextthink = time + 0.1
	self.think = sham_stand14
	ai_stand()
end
function sham_stand14()
	self.frame=FRAME_stand14
	self.nextthink = time + 0.1
	self.think = sham_stand15
	ai_stand()
end
function sham_stand15()
	self.frame=FRAME_stand15
	self.nextthink = time + 0.1
	self.think = sham_stand16
	ai_stand()
end
function sham_stand16()
	self.frame=FRAME_stand16
	self.nextthink = time + 0.1
	self.think = sham_stand17
	ai_stand()
end
function sham_stand17()
	self.frame=FRAME_stand17
	self.nextthink = time + 0.1
	self.think = sham_stand1
	ai_stand()
end

function sham_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = sham_walk2
	ai_walk(10)
end
function sham_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = sham_walk3
	ai_walk(9)
end
function sham_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = sham_walk4
	ai_walk(9)
end
function sham_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = sham_walk5
	ai_walk(5)
end
function sham_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = sham_walk6
	ai_walk(6)
end
function sham_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = sham_walk7
	ai_walk(12)
end
function sham_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = sham_walk8
	ai_walk(8)
end
function sham_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = sham_walk9
	ai_walk(3)
end
function sham_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = sham_walk10
	ai_walk(13)
end
function sham_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = sham_walk11
	ai_walk(9)
end
function sham_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = sham_walk12
	ai_walk(7)
end
function sham_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = sham_walk1
        ai_walk(7)
        if random() > 0.8 then -- TODO check condition
	        sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE)
        end
end

function sham_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = sham_run2
	ai_run(20)
end
function sham_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = sham_run3
	ai_run(24)
end
function sham_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = sham_run4
	ai_run(20)
end
function sham_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = sham_run5
	ai_run(20)
end
function sham_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = sham_run6
	ai_run(24)
end
function sham_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = sham_run1
        if random() > 0.8 then -- TODO check condition
	        sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE)
        end
end

function sham_smash1()
	self.frame=FRAME_smash1
	self.nextthink = time + 0.1
	self.think = sham_smash2
	sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM)
	ai_charge(2)
end
function sham_smash2()
	self.frame=FRAME_smash2
	self.nextthink = time + 0.1
	self.think = sham_smash3
	ai_charge(6)
end
function sham_smash3()
	self.frame=FRAME_smash3
	self.nextthink = time + 0.1
	self.think = sham_smash4
	ai_charge(6)
end
function sham_smash4()
	self.frame=FRAME_smash4
	self.nextthink = time + 0.1
	self.think = sham_smash5
	ai_charge(5)
end
function sham_smash5()
	self.frame=FRAME_smash5
	self.nextthink = time + 0.1
	self.think = sham_smash6
	ai_charge(4)
end
function sham_smash6()
	self.frame=FRAME_smash6
	self.nextthink = time + 0.1
	self.think = sham_smash7
	ai_charge(1)
end
function sham_smash7()
	self.frame=FRAME_smash7
	self.nextthink = time + 0.1
	self.think = sham_smash8
	ai_charge(0)
end
function sham_smash8()
	self.frame=FRAME_smash8
	self.nextthink = time + 0.1
	self.think = sham_smash9
	ai_charge(0)
end
function sham_smash9()
	self.frame=FRAME_smash9
	self.nextthink = time + 0.1
	self.think = sham_smash10
	ai_charge(0)
end
function sham_smash10()
	self.frame=FRAME_smash10
	self.nextthink = time + 0.1
	self.think = sham_smash11

        local delta; -- vector
        local ldmg; -- float

        if self.enemy == world then -- TODO check condition
            return
        end
        ai_charge(0)

        delta = self.enemy.origin - self.origin

        if vlen(delta) > 100 then -- TODO check condition
                return
        end
        if not CanDamage (self.enemy, self) then -- TODO check condition
                return
        end
		
	ldmg = (random() + random() + random()) * 40
	T_Damage (self.enemy, self, self, ldmg)
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM)

	SpawnMeatSpray (self.origin + qc.v_forward*16, crandom() * 100 * qc.v_right)
	SpawnMeatSpray (self.origin + qc.v_forward*16, crandom() * 100 * qc.v_right)
end
function sham_smash11()
	self.frame=FRAME_smash11
	self.nextthink = time + 0.1
	self.think = sham_smash12
	ai_charge(5)
end
function sham_smash12()
	self.frame=FRAME_smash12
	self.nextthink = time + 0.1
	self.think = sham_run1
	ai_charge(4)
end


function ShamClaw(side) -- float
        local delta; -- vector
        local ldmg; -- float

	if self.enemy == world then -- TODO check condition
		return
        end
	ai_charge(10)

	delta = self.enemy.origin - self.origin

	if vlen(delta) > 100 then -- TODO check condition
		return
        end
		
	ldmg = (random() + random() + random()) * 20
	T_Damage (self.enemy, self, self, ldmg)
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM)

	if side ~= 0 then -- TODO check condition
		makevectors (self.angles)
		SpawnMeatSpray (self.origin + qc.v_forward*16, side * qc.v_right)
	end
end

function sham_swingl1()
	self.frame=FRAME_swingl1
	self.nextthink = time + 0.1
	self.think = sham_swingl2
	sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM)
	ai_charge(5)
end
function sham_swingl2()
	self.frame=FRAME_swingl2
	self.nextthink = time + 0.1
	self.think = sham_swingl3
	ai_charge(3)
end
function sham_swingl3()
	self.frame=FRAME_swingl3
	self.nextthink = time + 0.1
	self.think = sham_swingl4
	ai_charge(7)
end
function sham_swingl4()
	self.frame=FRAME_swingl4
	self.nextthink = time + 0.1
	self.think = sham_swingl5
	ai_charge(3)
end
function sham_swingl5()
	self.frame=FRAME_swingl5
	self.nextthink = time + 0.1
	self.think = sham_swingl6
	ai_charge(7)
end
function sham_swingl6()
	self.frame=FRAME_swingl6
	self.nextthink = time + 0.1
	self.think = sham_swingl7
	ai_charge(9)
end
function sham_swingl7()
	self.frame=FRAME_swingl7
	self.nextthink = time + 0.1
	self.think = sham_swingl8
	ai_charge(5)
	 ShamClaw(250)
end
function sham_swingl8()
	self.frame=FRAME_swingl8
	self.nextthink = time + 0.1
	self.think = sham_swingl9
	ai_charge(4)
end
function sham_swingl9()
	self.frame=FRAME_swingl9
	self.nextthink = time + 0.1
	self.think = sham_run1
        ai_charge(8)
        if random()<0.5 then -- TODO check condition
	        self.think = sham_swingr1
        end
end

function sham_swingr1()
	self.frame=FRAME_swingr1
	self.nextthink = time + 0.1
	self.think = sham_swingr2
	sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM)
	ai_charge(1)
end
function sham_swingr2()
	self.frame=FRAME_swingr2
	self.nextthink = time + 0.1
	self.think = sham_swingr3
	ai_charge(8)
end
function sham_swingr3()
	self.frame=FRAME_swingr3
	self.nextthink = time + 0.1
	self.think = sham_swingr4
	ai_charge(14)
end
function sham_swingr4()
	self.frame=FRAME_swingr4
	self.nextthink = time + 0.1
	self.think = sham_swingr5
	ai_charge(7)
end
function sham_swingr5()
	self.frame=FRAME_swingr5
	self.nextthink = time + 0.1
	self.think = sham_swingr6
	ai_charge(3)
end
function sham_swingr6()
	self.frame=FRAME_swingr6
	self.nextthink = time + 0.1
	self.think = sham_swingr7
	ai_charge(6)
end
function sham_swingr7()
	self.frame=FRAME_swingr7
	self.nextthink = time + 0.1
	self.think = sham_swingr8
	ai_charge(6)
	 ShamClaw(-250)
end
function sham_swingr8()
	self.frame=FRAME_swingr8
	self.nextthink = time + 0.1
	self.think = sham_swingr9
	ai_charge(3)
end
function sham_swingr9()
	self.frame=FRAME_swingr9
	self.nextthink = time + 0.1
	self.think = sham_run1
        ai_charge(10)
        if random()<0.5 then -- TODO check condition
	        self.think = sham_swingl1
        end
end

function sham_melee()
	local chance; -- float
	
	chance = random()
	if chance > 0.6  or  self.health == 600 then -- TODO check condition
		sham_smash1 ()
	elseif chance > 0.3 then -- TODO check condition
		sham_swingr1 ()
	else
		sham_swingl1 ()
        end
end


--============================================================================

function CastLightning()
	local org, dir; -- vector
	
	self.effects = self.effects | EF_MUZZLEFLASH

	ai_face ()

	org = self.origin + vec3(0, 0, 40)

	dir = self.enemy.origin + vec3(0, 0, 16) - org
	dir = normalize (dir)

	traceline (org, self.origin + dir*600, true, self)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1)
	WriteEntity (MSG_BROADCAST, self)
	WriteCoord (MSG_BROADCAST, org.x)
	WriteCoord (MSG_BROADCAST, org.y)
	WriteCoord (MSG_BROADCAST, org.z)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.x)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.y)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.z)

	LightningDamage (org, qc.trace_endpos, self, 10)
end

function sham_magic1()
	self.frame=FRAME_magic1
	self.nextthink = time + 0.1
	self.think = sham_magic2
        ai_face()
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM)
end
function sham_magic2()
	self.frame=FRAME_magic2
	self.nextthink = time + 0.1
	self.think = sham_magic3
	ai_face()
end
function sham_magic3()
	self.frame=FRAME_magic3
	self.nextthink = time + 0.1
	self.think = sham_magic4
        ai_face()
        self.nextthink = self.nextthink + 0.2
        local o; -- entity

        self.effects = self.effects | EF_MUZZLEFLASH
        ai_face()
        self.owner = spawn()
        o = self.owner
        setmodel (o, "progs/s_light.mdl")
        setorigin (o, self.origin)
        o.angles = self.angles
        o.nextthink = time + 0.7
        o.think = SUB_Remove
end
function sham_magic4()
	self.frame=FRAME_magic4
	self.nextthink = time + 0.1
	self.think = sham_magic5
        self.effects = self.effects | EF_MUZZLEFLASH
        self.owner.frame = 1
end
function sham_magic5()
	self.frame=FRAME_magic5
	self.nextthink = time + 0.1
	self.think = sham_magic6
        self.effects = self.effects | EF_MUZZLEFLASH
        self.owner.frame = 2
end
function sham_magic6()
	self.frame=FRAME_magic6
	self.nextthink = time + 0.1
	self.think = sham_magic9
        remove (self.owner)
        CastLightning()
        sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM)
end
function sham_magic9()
	self.frame=FRAME_magic9
	self.nextthink = time + 0.1
	self.think = sham_magic10
end
function sham_magic10()
	self.frame=FRAME_magic10
	self.nextthink = time + 0.1
	self.think = sham_magic11
end
function sham_magic11()
	self.frame=FRAME_magic11
	self.nextthink = time + 0.1
	self.think = sham_magic12
        if skill == 3 then -- TODO check condition
	        CastLightning()
        end
end
function sham_magic12()
	self.frame=FRAME_magic12
	self.nextthink = time + 0.1
	self.think = sham_run1
end



function sham_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = sham_pain2
end
function sham_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = sham_pain3
end
function sham_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = sham_pain4
end
function sham_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = sham_pain5
end
function sham_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = sham_pain6
end
function sham_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = sham_run1
end

function sham_pain(attacker, damage) -- entity, float
	sound (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM)

        if not self.pain_finished then self.pain_finished = 0 end

	if self.health <= 0 then -- TODO check condition
		return		-- allready dying, don't go into pain frame
        end

	if random()*400 > damage then -- TODO check condition
		return		-- didn't flinch
        end

	if self.pain_finished > time then -- TODO check condition
		return
        end
	self.pain_finished = time + 2
		
	sham_pain1 ()
end


--============================================================================

function sham_death1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = sham_death2
end
function sham_death2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = sham_death3
end
function sham_death3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = sham_death4
	self.solid = SOLID_NOT
end
function sham_death4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = sham_death5
end
function sham_death5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = sham_death6
end
function sham_death6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = sham_death7
end
function sham_death7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = sham_death8
end
function sham_death8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = sham_death9
end
function sham_death9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = sham_death10
end
function sham_death10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = sham_death11
end
function sham_death11()
	self.frame=FRAME_death11
	self.nextthink = time + 0.1
	self.think = sham_death11
end

function sham_die()
-- check for gib
	if self.health < -60 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_shams.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM)
	sham_death1 ()
end

--============================================================================


--/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
--*/
function monster_shambler()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/shambler.mdl")
	precache_model ("progs/s_light.mdl")
	precache_model ("progs/h_shams.mdl")
	precache_model ("progs/bolt.mdl")
	
	precache_sound ("shambler/sattck1.wav")
	precache_sound ("shambler/sboom.wav")
	precache_sound ("shambler/sdeath.wav")
	precache_sound ("shambler/shurt2.wav")
	precache_sound ("shambler/sidle.wav")
	precache_sound ("shambler/ssight.wav")
	precache_sound ("shambler/melee1.wav")
	precache_sound ("shambler/melee2.wav")
	precache_sound ("shambler/smack.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP
	setmodel (self, "progs/shambler.mdl")

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX)
	self.health = 600

	self.th_stand = sham_stand1
	self.th_walk = sham_walk1
	self.th_run = sham_run1
	self.th_die = sham_die
	self.th_melee = sham_melee
	self.th_missile = sham_magic1
	self.th_pain = sham_pain
	
	walkmonster_start()
end
