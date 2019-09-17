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
--ZOMBIE
--
--==============================================================================
--*/



local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5,FRAME_stand6,FRAME_stand7,FRAME_stand8 = 0,1,2,3,4,5,6,7
local FRAME_stand9,FRAME_stand10,FRAME_stand11,FRAME_stand12,FRAME_stand13,FRAME_stand14,FRAME_stand15 = 8,9,10,11,12,13,14

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9,FRAME_walk10,FRAME_walk11 = 15,16,17,18,19,20,21,22,23,24,25
local FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15,FRAME_walk16,FRAME_walk17,FRAME_walk18,FRAME_walk19 = 26,27,28,29,30,31,32,33

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8,FRAME_run9,FRAME_run10,FRAME_run11,FRAME_run12 = 34,35,36,37,38,39,40,41,42,43,44,45
local FRAME_run13,FRAME_run14,FRAME_run15,FRAME_run16,FRAME_run17,FRAME_run18 = 46,47,48,49,50,51

local FRAME_atta1,FRAME_atta2,FRAME_atta3,FRAME_atta4,FRAME_atta5,FRAME_atta6,FRAME_atta7,FRAME_atta8,FRAME_atta9,FRAME_atta10,FRAME_atta11 = 52,53,54,55,56,57,58,59,60,61,62
local FRAME_atta12,FRAME_atta13 = 63,64

local FRAME_attb1,FRAME_attb2,FRAME_attb3,FRAME_attb4,FRAME_attb5,FRAME_attb6,FRAME_attb7,FRAME_attb8,FRAME_attb9,FRAME_attb10,FRAME_attb11 = 65,66,67,68,69,70,71,72,73,74,75
local FRAME_attb12,FRAME_attb13,FRAME_attb14 = 76,77,78

local FRAME_attc1,FRAME_attc2,FRAME_attc3,FRAME_attc4,FRAME_attc5,FRAME_attc6,FRAME_attc7,FRAME_attc8,FRAME_attc9,FRAME_attc10,FRAME_attc11 = 79,80,81,82,83,84,85,86,87,88,89
local FRAME_attc12 = 90

local FRAME_paina1,FRAME_paina2,FRAME_paina3,FRAME_paina4,FRAME_paina5,FRAME_paina6,FRAME_paina7,FRAME_paina8,FRAME_paina9,FRAME_paina10 = 91,92,93,94,95,96,97,98,99,100
local FRAME_paina11,FRAME_paina12 = 101,102

local FRAME_painb1,FRAME_painb2,FRAME_painb3,FRAME_painb4,FRAME_painb5,FRAME_painb6,FRAME_painb7,FRAME_painb8,FRAME_painb9,FRAME_painb10 = 103,104,105,106,107,108,109,110,111,112
local FRAME_painb11,FRAME_painb12,FRAME_painb13,FRAME_painb14,FRAME_painb15,FRAME_painb16,FRAME_painb17,FRAME_painb18,FRAME_painb19 = 113,114,115,116,117,118,119,120,121
local FRAME_painb20,FRAME_painb21,FRAME_painb22,FRAME_painb23,FRAME_painb24,FRAME_painb25,FRAME_painb26,FRAME_painb27,FRAME_painb28 = 122,123,124,125,126,127,128,129,130

local FRAME_painc1,FRAME_painc2,FRAME_painc3,FRAME_painc4,FRAME_painc5,FRAME_painc6,FRAME_painc7,FRAME_painc8,FRAME_painc9,FRAME_painc10 = 131,132,133,134,135,136,137,138,139,140
local FRAME_painc11,FRAME_painc12,FRAME_painc13,FRAME_painc14,FRAME_painc15,FRAME_painc16,FRAME_painc17,FRAME_painc18 = 141,142,143,144,145,146,147,148

local FRAME_paind1,FRAME_paind2,FRAME_paind3,FRAME_paind4,FRAME_paind5,FRAME_paind6,FRAME_paind7,FRAME_paind8,FRAME_paind9,FRAME_paind10 = 149,150,151,152,153,154,155,156,157,158
local FRAME_paind11,FRAME_paind12,FRAME_paind13 = 159,160,161

local FRAME_paine1,FRAME_paine2,FRAME_paine3,FRAME_paine4,FRAME_paine5,FRAME_paine6,FRAME_paine7,FRAME_paine8,FRAME_paine9,FRAME_paine10 = 162,163,164,165,166,167,168,169,170,171
local FRAME_paine11,FRAME_paine12,FRAME_paine13,FRAME_paine14,FRAME_paine15,FRAME_paine16,FRAME_paine17,FRAME_paine18,FRAME_paine19 = 172,173,174,175,176,177,178,179,180
local FRAME_paine20,FRAME_paine21,FRAME_paine22,FRAME_paine23,FRAME_paine24,FRAME_paine25,FRAME_paine26,FRAME_paine27,FRAME_paine28 = 181,182,183,184,185,186,187,188,189
local FRAME_paine29,FRAME_paine30 = 190,191

local FRAME_cruc_1,FRAME_cruc_2,FRAME_cruc_3,FRAME_cruc_4,FRAME_cruc_5,FRAME_cruc_6 = 192,193,194,195,196,197

local SPAWN_CRUCIFIED = 1 -- float

--=============================================================================

function zombie_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = zombie_stand2
	ai_stand()
end
function zombie_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = zombie_stand3
	ai_stand()
end
function zombie_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = zombie_stand4
	ai_stand()
end
function zombie_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = zombie_stand5
	ai_stand()
end
function zombie_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = zombie_stand6
	ai_stand()
end
function zombie_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = zombie_stand7
	ai_stand()
end
function zombie_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = zombie_stand8
	ai_stand()
end
function zombie_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = zombie_stand9
	ai_stand()
end
function zombie_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = zombie_stand10
	ai_stand()
end
function zombie_stand10()
	self.frame=FRAME_stand10
	self.nextthink = time + 0.1
	self.think = zombie_stand11
	ai_stand()
end
function zombie_stand11()
	self.frame=FRAME_stand11
	self.nextthink = time + 0.1
	self.think = zombie_stand12
	ai_stand()
end
function zombie_stand12()
	self.frame=FRAME_stand12
	self.nextthink = time + 0.1
	self.think = zombie_stand13
	ai_stand()
end
function zombie_stand13()
	self.frame=FRAME_stand13
	self.nextthink = time + 0.1
	self.think = zombie_stand14
	ai_stand()
end
function zombie_stand14()
	self.frame=FRAME_stand14
	self.nextthink = time + 0.1
	self.think = zombie_stand15
	ai_stand()
end
function zombie_stand15()
	self.frame=FRAME_stand15
	self.nextthink = time + 0.1
	self.think = zombie_stand1
	ai_stand()
end

function zombie_cruc1()
	self.frame=FRAME_cruc_1
	self.nextthink = time + 0.1
	self.think = zombie_cruc2
        if random() < 0.1 then -- TODO check condition
	        sound (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC)
        end
end
function zombie_cruc2()
	self.frame=FRAME_cruc_2
	self.nextthink = time + 0.1
	self.think = zombie_cruc3
	self.nextthink = time + 0.1 + random()*0.1
end
function zombie_cruc3()
	self.frame=FRAME_cruc_3
	self.nextthink = time + 0.1
	self.think = zombie_cruc4
	self.nextthink = time + 0.1 + random()*0.1
end
function zombie_cruc4()
	self.frame=FRAME_cruc_4
	self.nextthink = time + 0.1
	self.think = zombie_cruc5
	self.nextthink = time + 0.1 + random()*0.1
end
function zombie_cruc5()
	self.frame=FRAME_cruc_5
	self.nextthink = time + 0.1
	self.think = zombie_cruc6
	self.nextthink = time + 0.1 + random()*0.1
end
function zombie_cruc6()
	self.frame=FRAME_cruc_6
	self.nextthink = time + 0.1
	self.think = zombie_cruc1
	self.nextthink = time + 0.1 + random()*0.1
end

function zombie_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = zombie_walk2
	ai_walk(0)
end
function zombie_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = zombie_walk3
	ai_walk(2)
end
function zombie_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = zombie_walk4
	ai_walk(3)
end
function zombie_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = zombie_walk5
	ai_walk(2)
end
function zombie_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = zombie_walk6
	ai_walk(1)
end
function zombie_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = zombie_walk7
	ai_walk(0)
end
function zombie_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = zombie_walk8
	ai_walk(0)
end
function zombie_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = zombie_walk9
	ai_walk(0)
end
function zombie_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = zombie_walk10
	ai_walk(0)
end
function zombie_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = zombie_walk11
	ai_walk(0)
end
function zombie_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = zombie_walk12
	ai_walk(2)
end
function zombie_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = zombie_walk13
	ai_walk(2)
end
function zombie_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = zombie_walk14
	ai_walk(1)
end
function zombie_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = zombie_walk15
	ai_walk(0)
end
function zombie_walk15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = zombie_walk16
	ai_walk(0)
end
function zombie_walk16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = zombie_walk17
	ai_walk(0)
end
function zombie_walk17()
	self.frame=FRAME_walk17
	self.nextthink = time + 0.1
	self.think = zombie_walk18
	ai_walk(0)
end
function zombie_walk18()
	self.frame=FRAME_walk18
	self.nextthink = time + 0.1
	self.think = zombie_walk19
	ai_walk(0)
end
function zombie_walk19()
	self.frame=FRAME_walk19
	self.nextthink = time + 0.1
	self.think = zombie_walk1
        ai_walk(0)
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE)
        end
end

function zombie_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = zombie_run2
	ai_run(1)
	self.inpain = 0
end
function zombie_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = zombie_run3
	ai_run(1)
end
function zombie_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = zombie_run4
	ai_run(0)
end
function zombie_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = zombie_run5
	ai_run(1)
end
function zombie_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = zombie_run6
	ai_run(2)
end
function zombie_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = zombie_run7
	ai_run(3)
end
function zombie_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = zombie_run8
	ai_run(4)
end
function zombie_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = zombie_run9
	ai_run(4)
end
function zombie_run9()
	self.frame=FRAME_run9
	self.nextthink = time + 0.1
	self.think = zombie_run10
	ai_run(2)
end
function zombie_run10()
	self.frame=FRAME_run10
	self.nextthink = time + 0.1
	self.think = zombie_run11
	ai_run(0)
end
function zombie_run11()
	self.frame=FRAME_run11
	self.nextthink = time + 0.1
	self.think = zombie_run12
	ai_run(0)
end
function zombie_run12()
	self.frame=FRAME_run12
	self.nextthink = time + 0.1
	self.think = zombie_run13
	ai_run(0)
end
function zombie_run13()
	self.frame=FRAME_run13
	self.nextthink = time + 0.1
	self.think = zombie_run14
	ai_run(2)
end
function zombie_run14()
	self.frame=FRAME_run14
	self.nextthink = time + 0.1
	self.think = zombie_run15
	ai_run(4)
end
function zombie_run15()
	self.frame=FRAME_run15
	self.nextthink = time + 0.1
	self.think = zombie_run16
	ai_run(6)
end
function zombie_run16()
	self.frame=FRAME_run16
	self.nextthink = time + 0.1
	self.think = zombie_run17
	ai_run(7)
end
function zombie_run17()
	self.frame=FRAME_run17
	self.nextthink = time + 0.1
	self.think = zombie_run18
	ai_run(3)
end
function zombie_run18()
	self.frame=FRAME_run18
	self.nextthink = time + 0.1
	self.think = zombie_run1
        ai_run(8)
        if random() < 0.2 then -- TODO check condition
	        sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE)
        end
        if random() > 0.8 then -- TODO check condition
	        sound (self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE)
        end
end

--/*
--=============================================================================
--
--ATTACKS
--
--=============================================================================
--*/

function ZombieGrenadeTouch()
	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end
	if other.takedamage ~= 0 then -- TODO check condition
		T_Damage (other, self, self.owner, 10 )
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM)
		remove (self)
		return
	end
	sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM)	-- bounce sound
	self.velocity = vec3(0, 0, 0)
	self.avelocity = vec3(0, 0, 0)
	self.touch = SUB_Remove
end

--/*
--================
--ZombieFireGrenade
--================
--*/
function ZombieFireGrenade(st) -- vector
	local missile, mpuff; -- entity
	local org; -- vector

	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM)

	missile = spawn ()
	missile.owner = self
	missile.movetype = MOVETYPE_BOUNCE
	missile.solid = SOLID_BBOX

-- calc org
	org = self.origin + st.x * qc.v_forward + st.y * qc.v_right + (st.z - 24) * qc.v_up
	
-- set missile speed	

	makevectors (self.angles)

	missile.velocity = normalize(self.enemy.origin - org)
	missile.velocity = missile.velocity * 600
	missile.velocity.z = 200

	missile.avelocity = vec3(3000, 1000, 2000)

	missile.touch = ZombieGrenadeTouch
	
-- set missile duration
	missile.nextthink = time + 2.5
	missile.think = SUB_Remove

	setmodel (missile, "progs/zom_gib.mdl")
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, org)
end


function zombie_atta1()
	self.frame=FRAME_atta1
	self.nextthink = time + 0.1
	self.think = zombie_atta2
	ai_face()
end
function zombie_atta2()
	self.frame=FRAME_atta2
	self.nextthink = time + 0.1
	self.think = zombie_atta3
	ai_face()
end
function zombie_atta3()
	self.frame=FRAME_atta3
	self.nextthink = time + 0.1
	self.think = zombie_atta4
	ai_face()
end
function zombie_atta4()
	self.frame=FRAME_atta4
	self.nextthink = time + 0.1
	self.think = zombie_atta5
	ai_face()
end
function zombie_atta5()
	self.frame=FRAME_atta5
	self.nextthink = time + 0.1
	self.think = zombie_atta6
	ai_face()
end
function zombie_atta6()
	self.frame=FRAME_atta6
	self.nextthink = time + 0.1
	self.think = zombie_atta7
	ai_face()
end
function zombie_atta7()
	self.frame=FRAME_atta7
	self.nextthink = time + 0.1
	self.think = zombie_atta8
	ai_face()
end
function zombie_atta8()
	self.frame=FRAME_atta8
	self.nextthink = time + 0.1
	self.think = zombie_atta9
	ai_face()
end
function zombie_atta9()
	self.frame=FRAME_atta9
	self.nextthink = time + 0.1
	self.think = zombie_atta10
	ai_face()
end
function zombie_atta10()
	self.frame=FRAME_atta10
	self.nextthink = time + 0.1
	self.think = zombie_atta11
	ai_face()
end
function zombie_atta11()
	self.frame=FRAME_atta11
	self.nextthink = time + 0.1
	self.think = zombie_atta12
	ai_face()
end
function zombie_atta12()
	self.frame=FRAME_atta12
	self.nextthink = time + 0.1
	self.think = zombie_atta13
	ai_face()
end
function zombie_atta13()
	self.frame=FRAME_atta13
	self.nextthink = time + 0.1
	self.think = zombie_run1
	ai_face()
	ZombieFireGrenade(vec3(-10, -22, 30))
end

function zombie_attb1()
	self.frame=FRAME_attb1
	self.nextthink = time + 0.1
	self.think = zombie_attb2
	ai_face()
end
function zombie_attb2()
	self.frame=FRAME_attb2
	self.nextthink = time + 0.1
	self.think = zombie_attb3
	ai_face()
end
function zombie_attb3()
	self.frame=FRAME_attb3
	self.nextthink = time + 0.1
	self.think = zombie_attb4
	ai_face()
end
function zombie_attb4()
	self.frame=FRAME_attb4
	self.nextthink = time + 0.1
	self.think = zombie_attb5
	ai_face()
end
function zombie_attb5()
	self.frame=FRAME_attb5
	self.nextthink = time + 0.1
	self.think = zombie_attb6
	ai_face()
end
function zombie_attb6()
	self.frame=FRAME_attb6
	self.nextthink = time + 0.1
	self.think = zombie_attb7
	ai_face()
end
function zombie_attb7()
	self.frame=FRAME_attb7
	self.nextthink = time + 0.1
	self.think = zombie_attb8
	ai_face()
end
function zombie_attb8()
	self.frame=FRAME_attb8
	self.nextthink = time + 0.1
	self.think = zombie_attb9
	ai_face()
end
function zombie_attb9()
	self.frame=FRAME_attb9
	self.nextthink = time + 0.1
	self.think = zombie_attb10
	ai_face()
end
function zombie_attb10()
	self.frame=FRAME_attb10
	self.nextthink = time + 0.1
	self.think = zombie_attb11
	ai_face()
end
function zombie_attb11()
	self.frame=FRAME_attb11
	self.nextthink = time + 0.1
	self.think = zombie_attb12
	ai_face()
end
function zombie_attb12()
	self.frame=FRAME_attb12
	self.nextthink = time + 0.1
	self.think = zombie_attb13
	ai_face()
end
function zombie_attb13()
	self.frame=FRAME_attb13
	self.nextthink = time + 0.1
	self.think = zombie_attb14
	ai_face()
end
function zombie_attb14()
	self.frame=FRAME_attb13
	self.nextthink = time + 0.1
	self.think = zombie_run1
	ai_face()
	ZombieFireGrenade(vec3(-10, -24, 29))
end

function zombie_attc1()
	self.frame=FRAME_attc1
	self.nextthink = time + 0.1
	self.think = zombie_attc2
	ai_face()
end
function zombie_attc2()
	self.frame=FRAME_attc2
	self.nextthink = time + 0.1
	self.think = zombie_attc3
	ai_face()
end
function zombie_attc3()
	self.frame=FRAME_attc3
	self.nextthink = time + 0.1
	self.think = zombie_attc4
	ai_face()
end
function zombie_attc4()
	self.frame=FRAME_attc4
	self.nextthink = time + 0.1
	self.think = zombie_attc5
	ai_face()
end
function zombie_attc5()
	self.frame=FRAME_attc5
	self.nextthink = time + 0.1
	self.think = zombie_attc6
	ai_face()
end
function zombie_attc6()
	self.frame=FRAME_attc6
	self.nextthink = time + 0.1
	self.think = zombie_attc7
	ai_face()
end
function zombie_attc7()
	self.frame=FRAME_attc7
	self.nextthink = time + 0.1
	self.think = zombie_attc8
	ai_face()
end
function zombie_attc8()
	self.frame=FRAME_attc8
	self.nextthink = time + 0.1
	self.think = zombie_attc9
	ai_face()
end
function zombie_attc9()
	self.frame=FRAME_attc9
	self.nextthink = time + 0.1
	self.think = zombie_attc10
	ai_face()
end
function zombie_attc10()
	self.frame=FRAME_attc10
	self.nextthink = time + 0.1
	self.think = zombie_attc11
	ai_face()
end
function zombie_attc11()
	self.frame=FRAME_attc11
	self.nextthink = time + 0.1
	self.think = zombie_attc12
	ai_face()
end
function zombie_attc12()
	self.frame=FRAME_attc12
	self.nextthink = time + 0.1
	self.think = zombie_run1
	ai_face()
	ZombieFireGrenade(vec3(-12, -19, 29))
end

function zombie_missile()
	local r; -- float
	
	r = random()
	
	if r < 0.3 then -- TODO check condition
		zombie_atta1 ()
	elseif r < 0.6 then -- TODO check condition
		zombie_attb1 ()
	else
		zombie_attc1 ()
        end
end


--/*
--=============================================================================
--
--PAIN
--
--=============================================================================
--*/

function zombie_paina1()
	self.frame=FRAME_paina1
	self.nextthink = time + 0.1
	self.think = zombie_paina2
	sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM)
end
function zombie_paina2()
	self.frame=FRAME_paina2
	self.nextthink = time + 0.1
	self.think = zombie_paina3
	ai_painforward(3)
end
function zombie_paina3()
	self.frame=FRAME_paina3
	self.nextthink = time + 0.1
	self.think = zombie_paina4
	ai_painforward(1)
end
function zombie_paina4()
	self.frame=FRAME_paina4
	self.nextthink = time + 0.1
	self.think = zombie_paina5
	ai_pain(1)
end
function zombie_paina5()
	self.frame=FRAME_paina5
	self.nextthink = time + 0.1
	self.think = zombie_paina6
	ai_pain(3)
end
function zombie_paina6()
	self.frame=FRAME_paina6
	self.nextthink = time + 0.1
	self.think = zombie_paina7
	ai_pain(1)
end
function zombie_paina7()
	self.frame=FRAME_paina7
	self.nextthink = time + 0.1
	self.think = zombie_paina8
end
function zombie_paina8()
	self.frame=FRAME_paina8
	self.nextthink = time + 0.1
	self.think = zombie_paina9
end
function zombie_paina9()
	self.frame=FRAME_paina9
	self.nextthink = time + 0.1
	self.think = zombie_paina10
end
function zombie_paina10()
	self.frame=FRAME_paina10
	self.nextthink = time + 0.1
	self.think = zombie_paina11
end
function zombie_paina11()
	self.frame=FRAME_paina11
	self.nextthink = time + 0.1
	self.think = zombie_paina12
end
function zombie_paina12()
	self.frame=FRAME_paina12
	self.nextthink = time + 0.1
	self.think = zombie_run1
end

function zombie_painb1()
	self.frame=FRAME_painb1
	self.nextthink = time + 0.1
	self.think = zombie_painb2
	sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM)
end
function zombie_painb2()
	self.frame=FRAME_painb2
	self.nextthink = time + 0.1
	self.think = zombie_painb3
	ai_pain(2)
end
function zombie_painb3()
	self.frame=FRAME_painb3
	self.nextthink = time + 0.1
	self.think = zombie_painb4
	ai_pain(8)
end
function zombie_painb4()
	self.frame=FRAME_painb4
	self.nextthink = time + 0.1
	self.think = zombie_painb5
	ai_pain(6)
end
function zombie_painb5()
	self.frame=FRAME_painb5
	self.nextthink = time + 0.1
	self.think = zombie_painb6
	ai_pain(2)
end
function zombie_painb6()
	self.frame=FRAME_painb6
	self.nextthink = time + 0.1
	self.think = zombie_painb7
end
function zombie_painb7()
	self.frame=FRAME_painb7
	self.nextthink = time + 0.1
	self.think = zombie_painb8
end
function zombie_painb8()
	self.frame=FRAME_painb8
	self.nextthink = time + 0.1
	self.think = zombie_painb9
end
function zombie_painb9()
	self.frame=FRAME_painb9
	self.nextthink = time + 0.1
	self.think = zombie_painb10
	sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM)
end
function zombie_painb10()
	self.frame=FRAME_painb10
	self.nextthink = time + 0.1
	self.think = zombie_painb11
end
function zombie_painb11()
	self.frame=FRAME_painb11
	self.nextthink = time + 0.1
	self.think = zombie_painb12
end
function zombie_painb12()
	self.frame=FRAME_painb12
	self.nextthink = time + 0.1
	self.think = zombie_painb13
end
function zombie_painb13()
	self.frame=FRAME_painb13
	self.nextthink = time + 0.1
	self.think = zombie_painb14
end
function zombie_painb14()
	self.frame=FRAME_painb14
	self.nextthink = time + 0.1
	self.think = zombie_painb15
end
function zombie_painb15()
	self.frame=FRAME_painb15
	self.nextthink = time + 0.1
	self.think = zombie_painb16
end
function zombie_painb16()
	self.frame=FRAME_painb16
	self.nextthink = time + 0.1
	self.think = zombie_painb17
end
function zombie_painb17()
	self.frame=FRAME_painb17
	self.nextthink = time + 0.1
	self.think = zombie_painb18
end
function zombie_painb18()
	self.frame=FRAME_painb18
	self.nextthink = time + 0.1
	self.think = zombie_painb19
end
function zombie_painb19()
	self.frame=FRAME_painb19
	self.nextthink = time + 0.1
	self.think = zombie_painb20
end
function zombie_painb20()
	self.frame=FRAME_painb20
	self.nextthink = time + 0.1
	self.think = zombie_painb21
end
function zombie_painb21()
	self.frame=FRAME_painb21
	self.nextthink = time + 0.1
	self.think = zombie_painb22
end
function zombie_painb22()
	self.frame=FRAME_painb22
	self.nextthink = time + 0.1
	self.think = zombie_painb23
end
function zombie_painb23()
	self.frame=FRAME_painb23
	self.nextthink = time + 0.1
	self.think = zombie_painb24
end
function zombie_painb24()
	self.frame=FRAME_painb24
	self.nextthink = time + 0.1
	self.think = zombie_painb25
end
function zombie_painb25()
	self.frame=FRAME_painb25
	self.nextthink = time + 0.1
	self.think = zombie_painb26
	ai_painforward(1)
end
function zombie_painb26()
	self.frame=FRAME_painb26
	self.nextthink = time + 0.1
	self.think = zombie_painb27
end
function zombie_painb27()
	self.frame=FRAME_painb27
	self.nextthink = time + 0.1
	self.think = zombie_painb28
end
function zombie_painb28()
	self.frame=FRAME_painb28
	self.nextthink = time + 0.1
	self.think = zombie_run1
end

function zombie_painc1()
	self.frame=FRAME_painc1
	self.nextthink = time + 0.1
	self.think = zombie_painc2
	sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM)
end
function zombie_painc2()
	self.frame=FRAME_painc2
	self.nextthink = time + 0.1
	self.think = zombie_painc3
end
function zombie_painc3()
	self.frame=FRAME_painc3
	self.nextthink = time + 0.1
	self.think = zombie_painc4
	ai_pain(3)
end
function zombie_painc4()
	self.frame=FRAME_painc4
	self.nextthink = time + 0.1
	self.think = zombie_painc5
	ai_pain(1)
end
function zombie_painc5()
	self.frame=FRAME_painc5
	self.nextthink = time + 0.1
	self.think = zombie_painc6
end
function zombie_painc6()
	self.frame=FRAME_painc6
	self.nextthink = time + 0.1
	self.think = zombie_painc7
end
function zombie_painc7()
	self.frame=FRAME_painc7
	self.nextthink = time + 0.1
	self.think = zombie_painc8
end
function zombie_painc8()
	self.frame=FRAME_painc8
	self.nextthink = time + 0.1
	self.think = zombie_painc9
end
function zombie_painc9()
	self.frame=FRAME_painc9
	self.nextthink = time + 0.1
	self.think = zombie_painc10
end
function zombie_painc10()
	self.frame=FRAME_painc10
	self.nextthink = time + 0.1
	self.think = zombie_painc11
end
function zombie_painc11()
	self.frame=FRAME_painc11
	self.nextthink = time + 0.1
	self.think = zombie_painc12
	ai_painforward(1)
end
function zombie_painc12()
	self.frame=FRAME_painc12
	self.nextthink = time + 0.1
	self.think = zombie_painc13
	ai_painforward(1)
end
function zombie_painc13()
	self.frame=FRAME_painc13
	self.nextthink = time + 0.1
	self.think = zombie_painc14
end
function zombie_painc14()
	self.frame=FRAME_painc14
	self.nextthink = time + 0.1
	self.think = zombie_painc15
end
function zombie_painc15()
	self.frame=FRAME_painc15
	self.nextthink = time + 0.1
	self.think = zombie_painc16
end
function zombie_painc16()
	self.frame=FRAME_painc16
	self.nextthink = time + 0.1
	self.think = zombie_painc17
end
function zombie_painc17()
	self.frame=FRAME_painc17
	self.nextthink = time + 0.1
	self.think = zombie_painc18
end
function zombie_painc18()
	self.frame=FRAME_painc18
	self.nextthink = time + 0.1
	self.think = zombie_run1
end

function zombie_paind1()
	self.frame=FRAME_paind1
	self.nextthink = time + 0.1
	self.think = zombie_paind2
	sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM)
end
function zombie_paind2()
	self.frame=FRAME_paind2
	self.nextthink = time + 0.1
	self.think = zombie_paind3
end
function zombie_paind3()
	self.frame=FRAME_paind3
	self.nextthink = time + 0.1
	self.think = zombie_paind4
end
function zombie_paind4()
	self.frame=FRAME_paind4
	self.nextthink = time + 0.1
	self.think = zombie_paind5
end
function zombie_paind5()
	self.frame=FRAME_paind5
	self.nextthink = time + 0.1
	self.think = zombie_paind6
end
function zombie_paind6()
	self.frame=FRAME_paind6
	self.nextthink = time + 0.1
	self.think = zombie_paind7
end
function zombie_paind7()
	self.frame=FRAME_paind7
	self.nextthink = time + 0.1
	self.think = zombie_paind8
end
function zombie_paind8()
	self.frame=FRAME_paind8
	self.nextthink = time + 0.1
	self.think = zombie_paind9
end
function zombie_paind9()
	self.frame=FRAME_paind9
	self.nextthink = time + 0.1
	self.think = zombie_paind10
	ai_pain(1)
end
function zombie_paind10()
	self.frame=FRAME_paind10
	self.nextthink = time + 0.1
	self.think = zombie_paind11
end
function zombie_paind11()
	self.frame=FRAME_paind11
	self.nextthink = time + 0.1
	self.think = zombie_paind12
end
function zombie_paind12()
	self.frame=FRAME_paind12
	self.nextthink = time + 0.1
	self.think = zombie_paind13
end
function zombie_paind13()
	self.frame=FRAME_paind13
	self.nextthink = time + 0.1
	self.think = zombie_run1
end

function zombie_paine1()
	self.frame=FRAME_paine1
	self.nextthink = time + 0.1
	self.think = zombie_paine2
sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM)
self.health = 60
end
function zombie_paine2()
	self.frame=FRAME_paine2
	self.nextthink = time + 0.1
	self.think = zombie_paine3
	ai_pain(8)
end
function zombie_paine3()
	self.frame=FRAME_paine3
	self.nextthink = time + 0.1
	self.think = zombie_paine4
	ai_pain(5)
end
function zombie_paine4()
	self.frame=FRAME_paine4
	self.nextthink = time + 0.1
	self.think = zombie_paine5
	ai_pain(3)
end
function zombie_paine5()
	self.frame=FRAME_paine5
	self.nextthink = time + 0.1
	self.think = zombie_paine6
	ai_pain(1)
end
function zombie_paine6()
	self.frame=FRAME_paine6
	self.nextthink = time + 0.1
	self.think = zombie_paine7
	ai_pain(2)
end
function zombie_paine7()
	self.frame=FRAME_paine7
	self.nextthink = time + 0.1
	self.think = zombie_paine8
	ai_pain(1)
end
function zombie_paine8()
	self.frame=FRAME_paine8
	self.nextthink = time + 0.1
	self.think = zombie_paine9
	ai_pain(1)
end
function zombie_paine9()
	self.frame=FRAME_paine9
	self.nextthink = time + 0.1
	self.think = zombie_paine10
	ai_pain(2)
end
function zombie_paine10()
	self.frame=FRAME_paine10
	self.nextthink = time + 0.1
	self.think = zombie_paine11
sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM)
self.solid = SOLID_NOT
end
function zombie_paine11()
	self.frame=FRAME_paine11
	self.nextthink = time + 0.1
	self.think = zombie_paine12
	self.nextthink = self.nextthink + 5
	self.health = 60
end
function zombie_paine12()
	self.frame=FRAME_paine12
	self.nextthink = time + 0.1
	self.think = zombie_paine13
        -- see if ok to stand up
        self.health = 60
        sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE)
        self.solid = SOLID_SLIDEBOX
        if  not walkmove (self, 0, 0) then -- TODO check condition
	        self.think = zombie_paine11
	        self.solid = SOLID_NOT
	        return
        end
end
function zombie_paine13()
	self.frame=FRAME_paine13
	self.nextthink = time + 0.1
	self.think = zombie_paine14
end
function zombie_paine14()
	self.frame=FRAME_paine14
	self.nextthink = time + 0.1
	self.think = zombie_paine15
end
function zombie_paine15()
	self.frame=FRAME_paine15
	self.nextthink = time + 0.1
	self.think = zombie_paine16
end
function zombie_paine16()
	self.frame=FRAME_paine16
	self.nextthink = time + 0.1
	self.think = zombie_paine17
end
function zombie_paine17()
	self.frame=FRAME_paine17
	self.nextthink = time + 0.1
	self.think = zombie_paine18
end
function zombie_paine18()
	self.frame=FRAME_paine18
	self.nextthink = time + 0.1
	self.think = zombie_paine19
end
function zombie_paine19()
	self.frame=FRAME_paine19
	self.nextthink = time + 0.1
	self.think = zombie_paine20
end
function zombie_paine20()
	self.frame=FRAME_paine20
	self.nextthink = time + 0.1
	self.think = zombie_paine21
end
function zombie_paine21()
	self.frame=FRAME_paine21
	self.nextthink = time + 0.1
	self.think = zombie_paine22
end
function zombie_paine22()
	self.frame=FRAME_paine22
	self.nextthink = time + 0.1
	self.think = zombie_paine23
end
function zombie_paine23()
	self.frame=FRAME_paine23
	self.nextthink = time + 0.1
	self.think = zombie_paine24
end
function zombie_paine24()
	self.frame=FRAME_paine24
	self.nextthink = time + 0.1
	self.think = zombie_paine25
end
function zombie_paine25()
	self.frame=FRAME_paine25
	self.nextthink = time + 0.1
	self.think = zombie_paine26
	ai_painforward(5)
end
function zombie_paine26()
	self.frame=FRAME_paine26
	self.nextthink = time + 0.1
	self.think = zombie_paine27
	ai_painforward(3)
end
function zombie_paine27()
	self.frame=FRAME_paine27
	self.nextthink = time + 0.1
	self.think = zombie_paine28
	ai_painforward(1)
end
function zombie_paine28()
	self.frame=FRAME_paine28
	self.nextthink = time + 0.1
	self.think = zombie_paine29
	ai_pain(1)
end
function zombie_paine29()
	self.frame=FRAME_paine29
	self.nextthink = time + 0.1
	self.think = zombie_paine30
end
function zombie_paine30()
	self.frame=FRAME_paine30
	self.nextthink = time + 0.1
	self.think = zombie_run1
end

function zombie_die()
	sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM)
	ThrowHead ("progs/h_zombie.mdl", self.health)
	ThrowGib ("progs/gib1.mdl", self.health)
	ThrowGib ("progs/gib2.mdl", self.health)
	ThrowGib ("progs/gib3.mdl", self.health)
end

--/*
--=================
--zombie_pain
--
--Zombies can only be killed (gibbed) by doing 60 hit points of damage
--in a single frame (rockets, grenades, quad shotgun, quad nailgun).
--
--A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
--down to the ground.
--
--A hit of from 10 to 40 points in one frame will cause it to go down if it
--has been twice in two seconds, otherwise it goes into one of the four
--fast pain frames.
--
--A hit of less than 10 points of damage (winged by a shotgun) will be ignored.
--
--FIXME: don't use pain_finished because of nightmare hack
--=================
--*/
function zombie_pain(attacker, take) -- entity, float
	local r; -- float

	self.health = 60		-- allways reset health

	if take < 9 then -- TODO check condition
		return				-- totally ignore
        end

	if self.inpain == 2 then -- TODO check condition
		return			-- down on ground, so don't reset any counters
        end

-- go down immediately if a big enough hit
	if take >= 25 then -- TODO check condition
		self.inpain = 2
		zombie_paine1 ()
		return
	end
	
	if self.inpain then -- TODO check condition
-- if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3
		return			-- currently going through an animation, don't change
	end
	
	if self.pain_finished > time then -- TODO check condition
-- hit again, so drop down
		self.inpain = 2
		zombie_paine1 ()
		return
	end

-- gp into one of the fast pain animations	
	self.inpain = 1

	r = random()
	if r < 0.25 then -- TODO check condition
		zombie_paina1 ()
	elseif r <  0.5 then -- TODO check condition
		zombie_painb1 ()
	elseif r <  0.75 then -- TODO check condition
		zombie_painc1 ()
	else
		zombie_paind1 ()
        end
end

--============================================================================

--/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush
--
--If crucified, stick the bounding box 12 pixels back into a wall to look right.
--*/
function monster_zombie()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end

	precache_model ("progs/zombie.mdl")
	precache_model ("progs/h_zombie.mdl")
	precache_model ("progs/zom_gib.mdl")

	precache_sound ("zombie/z_idle.wav")
	precache_sound ("zombie/z_idle1.wav")
	precache_sound ("zombie/z_shot1.wav")
	precache_sound ("zombie/z_gib.wav")
	precache_sound ("zombie/z_pain.wav")
	precache_sound ("zombie/z_pain1.wav")
	precache_sound ("zombie/z_fall.wav")
	precache_sound ("zombie/z_miss.wav")
	precache_sound ("zombie/z_hit.wav")
	precache_sound ("zombie/idle_w2.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/zombie.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 60

	self.th_stand = zombie_stand1
	self.th_walk = zombie_walk1
	self.th_run = zombie_run1
	self.th_pain = zombie_pain
	self.th_die = zombie_die
	self.th_missile = zombie_missile
        self.inpain = 0

	if self.spawnflags & SPAWN_CRUCIFIED == SPAWN_CRUCIFIED then -- TODO check condition
		self.movetype = MOVETYPE_NONE
		zombie_cruc1 ()
	else
		walkmonster_start()
        end
end
