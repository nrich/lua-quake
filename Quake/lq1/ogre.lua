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
--OGRE
--
--==============================================================================
--*/


local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8,FRAME_stand9 = 0,1,2,3,4,5,6,7,8

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7 = 9,10,11,12,13,14,15
local FRAME_walk8,FRAME_walk9,FRAME_walk10,FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15,FRAME_walk16 = 16,17,18,19,20,21,22,23,24

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8 = 25,26,27,28,29,30,31,32

local FRAME_swing1,FRAME_swing2,FRAME_swing3,FRAME_swing4,FRAME_swing5,FRAME_swing6,FRAME_swing7 = 33,34,35,36,37,38,39
local FRAME_swing8,FRAME_swing9,FRAME_swing10,FRAME_swing11,FRAME_swing12,FRAME_swing13,FRAME_swing14 = 40,41,42,43,44,45,46

local FRAME_smash1,FRAME_smash2,FRAME_smash3,FRAME_smash4,FRAME_smash5,FRAME_smash6,FRAME_smash7 = 47,48,49,50,51,52,53
local FRAME_smash8,FRAME_smash9,FRAME_smash10,FRAME_smash11,FRAME_smash12,FRAME_smash13,FRAME_smash14 = 54,55,56,57,58,59,60

local FRAME_shoot1,FRAME_shoot2,FRAME_shoot3,FRAME_shoot4,FRAME_shoot5,FRAME_shoot6 = 61,62,63,64,65,66

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5 = 67,68,69,70,71

local FRAME_painb1,FRAME_painb2,FRAME_painb3 = 72,73,74

local FRAME_painc1,FRAME_painc2,FRAME_painc3,FRAME_painc4,FRAME_painc5,FRAME_painc6 = 75,76,77,78,79,80

local FRAME_paind1,FRAME_paind2,FRAME_paind3,FRAME_paind4,FRAME_paind5,FRAME_paind6,FRAME_paind7,FRAME_paind8,FRAME_paind9,FRAME_paind10 = 81,82,83,84,85,86,87,88,89,90
local FRAME_paind11,FRAME_paind12,FRAME_paind13,FRAME_paind14,FRAME_paind15,FRAME_paind16 = 91,92,93,94,95,96

local FRAME_paine1,FRAME_paine2,FRAME_paine3,FRAME_paine4,FRAME_paine5,FRAME_paine6,FRAME_paine7,FRAME_paine8,FRAME_paine9,FRAME_paine10 = 97,98,99,100,101,102,103,104,105,106
local FRAME_paine11,FRAME_paine12,FRAME_paine13,FRAME_paine14,FRAME_paine15 = 107,108,109,110,111

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6 = 112,113,114,115,116,117
local FRAME_death7,FRAME_death8,FRAME_death9,FRAME_death10,FRAME_death11,FRAME_death12 = 118,119,120,121,122,123
local FRAME_death13,FRAME_death14 = 124,125

local FRAME_bdeath1,FRAME_bdeath2,FRAME_bdeath3,FRAME_bdeath4,FRAME_bdeath5,FRAME_bdeath6 = 126,127,128,129,130,131
local FRAME_bdeath7,FRAME_bdeath8,FRAME_bdeath9,FRAME_bdeath10 = 132,133,134,135

local FRAME_pull1,FRAME_pull2,FRAME_pull3,FRAME_pull4,FRAME_pull5,FRAME_pull6,FRAME_pull7,FRAME_pull8,FRAME_pull9,FRAME_pull10,FRAME_pull11 = 136,137,138,139,140,141,142,143,144,145,146

--=============================================================================


function OgreGrenadeExplode()
	T_RadiusDamage (self, self.owner, 40, world)
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM)

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

function OgreGrenadeTouch()
	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end
	if other.takedamage == DAMAGE_AIM then -- TODO check condition
		OgreGrenadeExplode()
		return
	end
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM)	-- bounce sound
	if self.velocity == vec3(0, 0, 0) then -- TODO check condition
		self.avelocity = vec3(0, 0, 0)
        end
end

--/*
--================
--OgreFireGrenade
--================
--*/
function OgreFireGrenade()
	local missile, mpuff; -- entity
	
	self.effects = self.effects | EF_MUZZLEFLASH

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM)

	missile = spawn ()
	missile.owner = self
	missile.movetype = MOVETYPE_BOUNCE
	missile.solid = SOLID_BBOX
		
-- set missile speed	

	makevectors (self.angles)

	missile.velocity = normalize(self.enemy.origin - self.origin)
	missile.velocity = missile.velocity * 600
	missile.velocity.z = 200

	missile.avelocity = vec3(300, 300, 300)

	missile.angles = vectoangles(missile.velocity)
	
	missile.touch = OgreGrenadeTouch
	
-- set missile duration
	missile.nextthink = time + 2.5
	missile.think = OgreGrenadeExplode

	setmodel (missile, "progs/grenade.mdl")
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, self.origin)
end


--=============================================================================

--/*
--================
--chainsaw
--
--FIXME
--================
--*/
function chainsaw(side) -- float
        local delta; -- vector
        local ldmg; -- float

	if  self.enemy == world then -- TODO check condition
		return
        end
	if  not CanDamage (self.enemy, self) then -- TODO check condition
		return
        end

	ai_charge(10)

	delta = self.enemy.origin - self.origin

	if vlen(delta) > 100 then -- TODO check condition
		return
        end
		
	ldmg = (random() + random() + random()) * 4
	T_Damage (self.enemy, self, self, ldmg)
	
	if side ~= 0 then -- TODO check condition
		makevectors (self.angles)
		if side == 1 then -- TODO check condition
			SpawnMeatSpray (self.origin + qc.v_forward*16, crandom() * 100 * qc.v_right)
		else
			SpawnMeatSpray (self.origin + qc.v_forward*16, side * qc.v_right)
                end
	end
end


function ogre_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = ogre_stand2
	ai_stand()
end
function ogre_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = ogre_stand3
	ai_stand()
end
function ogre_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = ogre_stand4
	ai_stand()
end
function ogre_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = ogre_stand5
	ai_stand()
end
function ogre_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = ogre_stand6
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE)
        end
        ai_stand()
end
function ogre_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = ogre_stand7
	ai_stand()
end
function ogre_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = ogre_stand8
	ai_stand()
end
function ogre_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = ogre_stand9
	ai_stand()
end
function ogre_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = ogre_stand1
	ai_stand()
end

function ogre_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = ogre_walk2
	ai_walk(3)
end
function ogre_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = ogre_walk3
	ai_walk(2)
end
function ogre_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = ogre_walk4
        ai_walk(2)
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE)
        end
end
function ogre_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = ogre_walk5
	ai_walk(2)
end
function ogre_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = ogre_walk6
	ai_walk(2)
end
function ogre_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = ogre_walk7
        ai_walk(5)
        if random() < 0.1 then -- TODO check condition
	        sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE)
        end
end
function ogre_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = ogre_walk8
	ai_walk(3)
end
function ogre_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = ogre_walk9
	ai_walk(2)
end
function ogre_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = ogre_walk10
	ai_walk(3)
end
function ogre_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = ogre_walk11
	ai_walk(1)
end
function ogre_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = ogre_walk12
	ai_walk(2)
end
function ogre_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = ogre_walk13
	ai_walk(3)
end
function ogre_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = ogre_walk14
	ai_walk(3)
end
function ogre_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = ogre_walk15
	ai_walk(3)
end
function ogre_walk15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = ogre_walk16
	ai_walk(3)
end
function ogre_walk16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = ogre_walk1
	ai_walk(4)
end

function ogre_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = ogre_run2
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE)
        end
end
function ogre_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = ogre_run3
	ai_run(12)
end
function ogre_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = ogre_run4
	ai_run(8)
end
function ogre_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = ogre_run5
	ai_run(22)
end
function ogre_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = ogre_run6
	ai_run(16)
end
function ogre_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = ogre_run7
	ai_run(4)
end
function ogre_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = ogre_run8
	ai_run(13)
end
function ogre_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = ogre_run1
	ai_run(24)
end

function ogre_swing1()
	self.frame=FRAME_swing1
	self.nextthink = time + 0.1
	self.think = ogre_swing2
	ai_charge(11)
	sound (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM)
end
function ogre_swing2()
	self.frame=FRAME_swing2
	self.nextthink = time + 0.1
	self.think = ogre_swing3
	ai_charge(1)
end
function ogre_swing3()
	self.frame=FRAME_swing3
	self.nextthink = time + 0.1
	self.think = ogre_swing4
	ai_charge(4)
end
function ogre_swing4()
	self.frame=FRAME_swing4
	self.nextthink = time + 0.1
	self.think = ogre_swing5
	ai_charge(13)
end
function ogre_swing5()
	self.frame=FRAME_swing5
	self.nextthink = time + 0.1
	self.think = ogre_swing6
	ai_charge(9)
	chainsaw(0)
	self.angles.y = self.angles.y + random()*25
end
function ogre_swing6()
	self.frame=FRAME_swing6
	self.nextthink = time + 0.1
	self.think = ogre_swing7
	chainsaw(200)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing7()
	self.frame=FRAME_swing7
	self.nextthink = time + 0.1
	self.think = ogre_swing8
	chainsaw(0)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing8()
	self.frame=FRAME_swing8
	self.nextthink = time + 0.1
	self.think = ogre_swing9
	chainsaw(0)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing9()
	self.frame=FRAME_swing9
	self.nextthink = time + 0.1
	self.think = ogre_swing10
	chainsaw(0)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing10()
	self.frame=FRAME_swing10
	self.nextthink = time + 0.1
	self.think = ogre_swing11
	chainsaw(-200)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing11()
	self.frame=FRAME_swing11
	self.nextthink = time + 0.1
	self.think = ogre_swing12
	chainsaw(0)
	self.angles.y = self.angles.y + random()* 25
end
function ogre_swing12()
	self.frame=FRAME_swing12
	self.nextthink = time + 0.1
	self.think = ogre_swing13
	ai_charge(3)
end
function ogre_swing13()
	self.frame=FRAME_swing13
	self.nextthink = time + 0.1
	self.think = ogre_swing14
	ai_charge(8)
end
function ogre_swing14()
	self.frame=FRAME_swing14
	self.nextthink = time + 0.1
	self.think = ogre_run1
	ai_charge(9)
end

function ogre_smash1()
	self.frame=FRAME_smash1
	self.nextthink = time + 0.1
	self.think = ogre_smash2
	ai_charge(6)
	sound (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM)
end
function ogre_smash2()
	self.frame=FRAME_smash2
	self.nextthink = time + 0.1
	self.think = ogre_smash3
	ai_charge(0)
end
function ogre_smash3()
	self.frame=FRAME_smash3
	self.nextthink = time + 0.1
	self.think = ogre_smash4
	ai_charge(0)
end
function ogre_smash4()
	self.frame=FRAME_smash4
	self.nextthink = time + 0.1
	self.think = ogre_smash5
	ai_charge(1)
end
function ogre_smash5()
	self.frame=FRAME_smash5
	self.nextthink = time + 0.1
	self.think = ogre_smash6
	ai_charge(4)
end
function ogre_smash6()
	self.frame=FRAME_smash6
	self.nextthink = time + 0.1
	self.think = ogre_smash7
	ai_charge(4)
	chainsaw(0)
end
function ogre_smash7()
	self.frame=FRAME_smash7
	self.nextthink = time + 0.1
	self.think = ogre_smash8
	ai_charge(4)
	chainsaw(0)
end
function ogre_smash8()
	self.frame=FRAME_smash8
	self.nextthink = time + 0.1
	self.think = ogre_smash9
	ai_charge(10)
	 chainsaw(0)
end
function ogre_smash9()
	self.frame=FRAME_smash9
	self.nextthink = time + 0.1
	self.think = ogre_smash10
	ai_charge(13)
	chainsaw(0)
end
function ogre_smash10()
	self.frame=FRAME_smash10
	self.nextthink = time + 0.1
	self.think = ogre_smash11
	chainsaw(1)
end
function ogre_smash11()
	self.frame=FRAME_smash11
	self.nextthink = time + 0.1
	self.think = ogre_smash12
	ai_charge(2)
	chainsaw(0)
	self.nextthink = self.nextthink + random()*0.2
end
function ogre_smash12()
	self.frame=FRAME_smash12
	self.nextthink = time + 0.1
	self.think = ogre_smash13
	ai_charge(0)
end
function ogre_smash13()
	self.frame=FRAME_smash13
	self.nextthink = time + 0.1
	self.think = ogre_smash14
	ai_charge(4)
end
function ogre_smash14()
	self.frame=FRAME_smash14
	self.nextthink = time + 0.1
	self.think = ogre_run1
	ai_charge(12)
end

function ogre_nail1()
	self.frame=FRAME_shoot1
	self.nextthink = time + 0.1
	self.think = ogre_nail2
	ai_face()
end
function ogre_nail2()
	self.frame=FRAME_shoot2
	self.nextthink = time + 0.1
	self.think = ogre_nail3
	ai_face()
end
function ogre_nail3()
	self.frame=FRAME_shoot2
	self.nextthink = time + 0.1
	self.think = ogre_nail4
	ai_face()
end
function ogre_nail4()
	self.frame=FRAME_shoot3
	self.nextthink = time + 0.1
	self.think = ogre_nail5
	ai_face()
	OgreFireGrenade()
end
function ogre_nail5()
	self.frame=FRAME_shoot4
	self.nextthink = time + 0.1
	self.think = ogre_nail6
	ai_face()
end
function ogre_nail6()
	self.frame=FRAME_shoot5
	self.nextthink = time + 0.1
	self.think = ogre_nail7
	ai_face()
end
function ogre_nail7()
	self.frame=FRAME_shoot6
	self.nextthink = time + 0.1
	self.think = ogre_run1
	ai_face()
end

function ogre_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = ogre_pain2
end
function ogre_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = ogre_pain3
end
function ogre_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = ogre_pain4
end
function ogre_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = ogre_pain5
end
function ogre_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = ogre_run1
end


function ogre_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = ogre_painb2
end
function ogre_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = ogre_painb3
end
function ogre_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = ogre_run1
end


function ogre_painc1()
	self.frame=FRAME_painc1
	self.nextthink = time + 0.1
	self.think = ogre_painc2
end
function ogre_painc2()
	self.frame=FRAME_painc2
	self.nextthink = time + 0.1
	self.think = ogre_painc3
end
function ogre_painc3()
	self.frame=FRAME_painc3
	self.nextthink = time + 0.1
	self.think = ogre_painc4
end
function ogre_painc4()
	self.frame=FRAME_painc4
	self.nextthink = time + 0.1
	self.think = ogre_painc5
end
function ogre_painc5()
	self.frame=FRAME_painc5
	self.nextthink = time + 0.1
	self.think = ogre_painc6
end
function ogre_painc6()
	self.frame=FRAME_painc6
	self.nextthink = time + 0.1
	self.think = ogre_run1
end


function ogre_paind1()
	self.frame=FRAME_paind1
	self.nextthink = time + 0.1
	self.think = ogre_paind2
end
function ogre_paind2()
	self.frame=FRAME_paind2
	self.nextthink = time + 0.1
	self.think = ogre_paind3
	ai_pain(10)
end
function ogre_paind3()
	self.frame=FRAME_paind3
	self.nextthink = time + 0.1
	self.think = ogre_paind4
	ai_pain(9)
end
function ogre_paind4()
	self.frame=FRAME_paind4
	self.nextthink = time + 0.1
	self.think = ogre_paind5
	ai_pain(4)
end
function ogre_paind5()
	self.frame=FRAME_paind5
	self.nextthink = time + 0.1
	self.think = ogre_paind6
end
function ogre_paind6()
	self.frame=FRAME_paind6
	self.nextthink = time + 0.1
	self.think = ogre_paind7
end
function ogre_paind7()
	self.frame=FRAME_paind7
	self.nextthink = time + 0.1
	self.think = ogre_paind8
end
function ogre_paind8()
	self.frame=FRAME_paind8
	self.nextthink = time + 0.1
	self.think = ogre_paind9
end
function ogre_paind9()
	self.frame=FRAME_paind9
	self.nextthink = time + 0.1
	self.think = ogre_paind10
end
function ogre_paind10()
	self.frame=FRAME_paind10
	self.nextthink = time + 0.1
	self.think = ogre_paind11
end
function ogre_paind11()
	self.frame=FRAME_paind11
	self.nextthink = time + 0.1
	self.think = ogre_paind12
end
function ogre_paind12()
	self.frame=FRAME_paind12
	self.nextthink = time + 0.1
	self.think = ogre_paind13
end
function ogre_paind13()
	self.frame=FRAME_paind13
	self.nextthink = time + 0.1
	self.think = ogre_paind14
end
function ogre_paind14()
	self.frame=FRAME_paind14
	self.nextthink = time + 0.1
	self.think = ogre_paind15
end
function ogre_paind15()
	self.frame=FRAME_paind15
	self.nextthink = time + 0.1
	self.think = ogre_paind16
end
function ogre_paind16()
	self.frame=FRAME_paind16
	self.nextthink = time + 0.1
	self.think = ogre_run1
end

function ogre_paine1()
	self.frame=FRAME_paine1
	self.nextthink = time + 0.1
	self.think = ogre_paine2
end
function ogre_paine2()
	self.frame=FRAME_paine2
	self.nextthink = time + 0.1
	self.think = ogre_paine3
	ai_pain(10)
end
function ogre_paine3()
	self.frame=FRAME_paine3
	self.nextthink = time + 0.1
	self.think = ogre_paine4
	ai_pain(9)
end
function ogre_paine4()
	self.frame=FRAME_paine4
	self.nextthink = time + 0.1
	self.think = ogre_paine5
	ai_pain(4)
end
function ogre_paine5()
	self.frame=FRAME_paine5
	self.nextthink = time + 0.1
	self.think = ogre_paine6
end
function ogre_paine6()
	self.frame=FRAME_paine6
	self.nextthink = time + 0.1
	self.think = ogre_paine7
end
function ogre_paine7()
	self.frame=FRAME_paine7
	self.nextthink = time + 0.1
	self.think = ogre_paine8
end
function ogre_paine8()
	self.frame=FRAME_paine8
	self.nextthink = time + 0.1
	self.think = ogre_paine9
end
function ogre_paine9()
	self.frame=FRAME_paine9
	self.nextthink = time + 0.1
	self.think = ogre_paine10
end
function ogre_paine10()
	self.frame=FRAME_paine10
	self.nextthink = time + 0.1
	self.think = ogre_paine11
end
function ogre_paine11()
	self.frame=FRAME_paine11
	self.nextthink = time + 0.1
	self.think = ogre_paine12
end
function ogre_paine12()
	self.frame=FRAME_paine12
	self.nextthink = time + 0.1
	self.think = ogre_paine13
end
function ogre_paine13()
	self.frame=FRAME_paine13
	self.nextthink = time + 0.1
	self.think = ogre_paine14
end
function ogre_paine14()
	self.frame=FRAME_paine14
	self.nextthink = time + 0.1
	self.think = ogre_paine15
end
function ogre_paine15()
	self.frame=FRAME_paine15
	self.nextthink = time + 0.1
	self.think = ogre_run1
end


function ogre_pain(attacker, damage) -- entity, float
	local r; -- float

        if not self.pain_finished then self.pain_finished = 0 end

-- don't make multiple pain sounds right after each other
	if self.pain_finished > time then -- TODO check condition
		return
        end

	sound (self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM)		

	r = random()
	
	if r < 0.25 then -- TODO check condition
		ogre_pain1 ()
		self.pain_finished = time + 1
	elseif r < 0.5 then -- TODO check condition
		ogre_painb1 ()
		self.pain_finished = time + 1
	elseif r < 0.75 then -- TODO check condition
		ogre_painc1 ()
		self.pain_finished = time + 1
	elseif r < 0.88 then -- TODO check condition
		ogre_paind1 ()
		self.pain_finished = time + 2
	else
		ogre_paine1 ()
		self.pain_finished = time + 2
	end
end

function ogre_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = ogre_die2
end
function ogre_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = ogre_die3
end
function ogre_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = ogre_die4
        self.solid = SOLID_NOT
        self.ammo_rockets = 2
        DropBackpack()
end
function ogre_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = ogre_die5
end
function ogre_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = ogre_die6
end
function ogre_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = ogre_die7
end
function ogre_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = ogre_die8
end
function ogre_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = ogre_die9
end
function ogre_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = ogre_die10
end
function ogre_die10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = ogre_die11
end
function ogre_die11()
	self.frame=FRAME_death11
	self.nextthink = time + 0.1
	self.think = ogre_die12
end
function ogre_die12()
	self.frame=FRAME_death12
	self.nextthink = time + 0.1
	self.think = ogre_die13
end
function ogre_die13()
	self.frame=FRAME_death13
	self.nextthink = time + 0.1
	self.think = ogre_die14
end
function ogre_die14()
	self.frame=FRAME_death14
	self.nextthink = time + 0.1
	self.think = ogre_die14
end

function ogre_bdie1()
	self.frame=FRAME_bdeath1
	self.nextthink = time + 0.1
	self.think = ogre_bdie2
end
function ogre_bdie2()
	self.frame=FRAME_bdeath2
	self.nextthink = time + 0.1
	self.think = ogre_bdie3
	ai_forward(5)
end
function ogre_bdie3()
	self.frame=FRAME_bdeath3
	self.nextthink = time + 0.1
	self.think = ogre_bdie4
	self.solid = SOLID_NOT
	self.ammo_rockets = 2
	DropBackpack()
end
function ogre_bdie4()
	self.frame=FRAME_bdeath4
	self.nextthink = time + 0.1
	self.think = ogre_bdie5
	ai_forward(1)
end
function ogre_bdie5()
	self.frame=FRAME_bdeath5
	self.nextthink = time + 0.1
	self.think = ogre_bdie6
	ai_forward(3)
end
function ogre_bdie6()
	self.frame=FRAME_bdeath6
	self.nextthink = time + 0.1
	self.think = ogre_bdie7
	ai_forward(7)
end
function ogre_bdie7()
	self.frame=FRAME_bdeath7
	self.nextthink = time + 0.1
	self.think = ogre_bdie8
	ai_forward(25)
end
function ogre_bdie8()
	self.frame=FRAME_bdeath8
	self.nextthink = time + 0.1
	self.think = ogre_bdie9
end
function ogre_bdie9()
	self.frame=FRAME_bdeath9
	self.nextthink = time + 0.1
	self.think = ogre_bdie10
end
function ogre_bdie10()
	self.frame=FRAME_bdeath10
	self.nextthink = time + 0.1
	self.think = ogre_bdie10
end

function ogre_die()
-- check for gib
	if self.health < -80 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_ogre.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

	sound (self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM)
	
	if random() < 0.5 then -- TODO check condition
		ogre_die1 ()
	else
		ogre_bdie1 ()
        end
end

function ogre_melee()
	if random() > 0.5 then -- TODO check condition
		ogre_smash1 ()
	else
		ogre_swing1 ()
        end
end


--/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush
--
--*/
function monster_ogre()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/ogre.mdl")
	precache_model ("progs/h_ogre.mdl")
	precache_model ("progs/grenade.mdl")

	precache_sound ("ogre/ogdrag.wav")
	precache_sound ("ogre/ogdth.wav")
	precache_sound ("ogre/ogidle.wav")
	precache_sound ("ogre/ogidle2.wav")
	precache_sound ("ogre/ogpain1.wav")
	precache_sound ("ogre/ogsawatk.wav")
	precache_sound ("ogre/ogwake.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/ogre.mdl")

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX)
	self.health = 200

	self.th_stand = ogre_stand1
	self.th_walk = ogre_walk1
	self.th_run = ogre_run1
	self.th_die = ogre_die
	self.th_melee = ogre_melee
	self.th_missile = ogre_nail1
	self.th_pain = ogre_pain
	
	walkmonster_start()
end

function monster_ogre_marksman()
	monster_ogre ()
end


