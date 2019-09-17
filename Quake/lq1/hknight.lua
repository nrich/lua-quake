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

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9 = 9,10,11,12,13,14,15,16,17
local FRAME_walk10,FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15,FRAME_walk16,FRAME_walk17 = 18,19,20,21,22,23,24,25
local FRAME_walk18,FRAME_walk19,FRAME_walk20 = 26,27,28

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8 = 29,30,31,32,33,34,35,36

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5 = 37,38,39,40,41

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8 = 42,43,44,45,46,47,48,49
local FRAME_death9,FRAME_death10,FRAME_death11,FRAME_death12 = 50,51,52,53

local FRAME_deathb1,FRAME_deathb2,FRAME_deathb3,FRAME_deathb4,FRAME_deathb5,FRAME_deathb6,FRAME_deathb7,FRAME_deathb8 = 54,55,56,57,58,59,60,61
local FRAME_deathb9 = 62

local FRAME_char_a1,FRAME_char_a2,FRAME_char_a3,FRAME_char_a4,FRAME_char_a5,FRAME_char_a6,FRAME_char_a7,FRAME_char_a8 = 63,64,65,66,67,68,69,70
local FRAME_char_a9,FRAME_char_a10,FRAME_char_a11,FRAME_char_a12,FRAME_char_a13,FRAME_char_a14,FRAME_char_a15,FRAME_char_a16 = 71,72,73,74,75,76,77,78

local FRAME_magica1,FRAME_magica2,FRAME_magica3,FRAME_magica4,FRAME_magica5,FRAME_magica6,FRAME_magica7,FRAME_magica8 = 79,80,81,82,83,84,85,86
local FRAME_magica9,FRAME_magica10,FRAME_magica11,FRAME_magica12,FRAME_magica13,FRAME_magica14 = 87,88,89,90,91,92

local FRAME_magicb1,FRAME_magicb2,FRAME_magicb3,FRAME_magicb4,FRAME_magicb5,FRAME_magicb6,FRAME_magicb7,FRAME_magicb8 = 93,94,95,96,97,98,99,100
local FRAME_magicb9,FRAME_magicb10,FRAME_magicb11,FRAME_magicb12,FRAME_magicb13 = 101,102,103,104,105

local FRAME_char_b1,FRAME_char_b2,FRAME_char_b3,FRAME_char_b4,FRAME_char_b5,FRAME_char_b6 = 106,107,108,109,110,111

local FRAME_slice1,FRAME_slice2,FRAME_slice3,FRAME_slice4,FRAME_slice5,FRAME_slice6,FRAME_slice7,FRAME_slice8,FRAME_slice9,FRAME_slice10 = 112,113,114,115,116,117,118,119,120,121

local FRAME_smash1,FRAME_smash2,FRAME_smash3,FRAME_smash4,FRAME_smash5,FRAME_smash6,FRAME_smash7,FRAME_smash8,FRAME_smash9,FRAME_smash10 = 122,123,124,125,126,127,128,129,130,131
local FRAME_smash11 = 132

local FRAME_w_attack1,FRAME_w_attack2,FRAME_w_attack3,FRAME_w_attack4,FRAME_w_attack5,FRAME_w_attack6,FRAME_w_attack7 = 133,134,135,136,137,138,139
local FRAME_w_attack8,FRAME_w_attack9,FRAME_w_attack10,FRAME_w_attack11,FRAME_w_attack12,FRAME_w_attack13,FRAME_w_attack14 = 140,141,142,143,144,145,146
local FRAME_w_attack15,FRAME_w_attack16,FRAME_w_attack17,FRAME_w_attack18,FRAME_w_attack19,FRAME_w_attack20 = 147,148,149,150,151,152
local FRAME_w_attack21,FRAME_w_attack22 = 153,154

local FRAME_magicc1,FRAME_magicc2,FRAME_magicc3,FRAME_magicc4,FRAME_magicc5,FRAME_magicc6,FRAME_magicc7,FRAME_magicc8 = 155,156,157,158,159,160,161,162
local FRAME_magicc9,FRAME_magicc10,FRAME_magicc11 = 163,164,165



function hknight_shot(offset) -- float
	local offang; -- vector
	local org, vec; -- vector
	
	offang = vectoangles (self.enemy.origin - self.origin)
	offang.y = offang.y + offset * 6
	
	makevectors (offang)

	org = self.origin + self.mins + self.size*0.5 + qc.v_forward * 20

-- set missile speed
	vec = normalize (qc.v_forward)
	vec.z = 0 - vec.z + (random() - 0.5)*0.1
	
	launch_spike (org, vec)
	newmis.classname = "knightspike"
	setmodel (newmis, "progs/k_spike.mdl")
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN)		
	newmis.velocity = vec*300
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM)
end

function CheckForCharge()
-- check for mad charge
        if not self.attack_finished then self.attack_finished = 0 end

        if  not enemy_vis then -- TODO check condition
	        return
        end
        if time < self.attack_finished then -- TODO check condition
	        return	
        end
        if  fabs(self.origin.z - self.enemy.origin.z) > 20 then -- TODO check condition
	        return		-- too much height change
        end
        if  vlen (self.origin - self.enemy.origin) < 80 then -- TODO check condition
	        return		-- use regular attack
        end

-- charge		
	SUB_AttackFinished (2)
	hknight_char_a1 ()

end

function CheckContinueCharge()
	if time > self.attack_finished then -- TODO check condition
		SUB_AttackFinished (3)
		hknight_run1 ()
		return		-- done charging
	end
	if random() > 0.5 then -- TODO check condition
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM)
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM)
        end
end

--===========================================================================

function hknight_stand1()
	self.frame=FRAME_stand1
	self.nextthink = time + 0.1
	self.think = hknight_stand2
	ai_stand()
end
function hknight_stand2()
	self.frame=FRAME_stand2
	self.nextthink = time + 0.1
	self.think = hknight_stand3
	ai_stand()
end
function hknight_stand3()
	self.frame=FRAME_stand3
	self.nextthink = time + 0.1
	self.think = hknight_stand4
	ai_stand()
end
function hknight_stand4()
	self.frame=FRAME_stand4
	self.nextthink = time + 0.1
	self.think = hknight_stand5
	ai_stand()
end
function hknight_stand5()
	self.frame=FRAME_stand5
	self.nextthink = time + 0.1
	self.think = hknight_stand6
	ai_stand()
end
function hknight_stand6()
	self.frame=FRAME_stand6
	self.nextthink = time + 0.1
	self.think = hknight_stand7
	ai_stand()
end
function hknight_stand7()
	self.frame=FRAME_stand7
	self.nextthink = time + 0.1
	self.think = hknight_stand8
	ai_stand()
end
function hknight_stand8()
	self.frame=FRAME_stand8
	self.nextthink = time + 0.1
	self.think = hknight_stand9
	ai_stand()
end
function hknight_stand9()
	self.frame=FRAME_stand9
	self.nextthink = time + 0.1
	self.think = hknight_stand1
	ai_stand()
end

--===========================================================================

function hknight_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = hknight_walk2
	hk_idle_sound()
	ai_walk(2)
end
function hknight_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = hknight_walk3
	ai_walk(5)
end
function hknight_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = hknight_walk4
	ai_walk(5)
end
function hknight_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = hknight_walk5
	ai_walk(4)
end
function hknight_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = hknight_walk6
	ai_walk(4)
end
function hknight_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = hknight_walk7
	ai_walk(2)
end
function hknight_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = hknight_walk8
	ai_walk(2)
end
function hknight_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = hknight_walk9
	ai_walk(3)
end
function hknight_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = hknight_walk10
	ai_walk(3)
end
function hknight_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = hknight_walk11
	ai_walk(4)
end
function hknight_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = hknight_walk12
	ai_walk(3)
end
function hknight_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = hknight_walk13
	ai_walk(4)
end
function hknight_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = hknight_walk14
	ai_walk(6)
end
function hknight_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = hknight_walk15
	ai_walk(2)
end
function hknight_walk15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = hknight_walk16
	ai_walk(2)
end
function hknight_walk16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = hknight_walk17
	ai_walk(4)
end
function hknight_walk17()
	self.frame=FRAME_walk17
	self.nextthink = time + 0.1
	self.think = hknight_walk18
	ai_walk(3)
end
function hknight_walk18()
	self.frame=FRAME_walk18
	self.nextthink = time + 0.1
	self.think = hknight_walk19
	ai_walk(3)
end
function hknight_walk19()
	self.frame=FRAME_walk19
	self.nextthink = time + 0.1
	self.think = hknight_walk20
	ai_walk(3)
end
function hknight_walk20()
	self.frame=FRAME_walk20
	self.nextthink = time + 0.1
	self.think = hknight_walk1
	ai_walk(2)
end

--===========================================================================

function hknight_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = hknight_run2
	hk_idle_sound()
	ai_run (20)
	 CheckForCharge ()
	 
end
function hknight_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = hknight_run3
	ai_run(25)
end
function hknight_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = hknight_run4
	ai_run(18)
end
function hknight_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = hknight_run5
	ai_run(16)
end
function hknight_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = hknight_run6
	ai_run(14)
end
function hknight_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = hknight_run7
	ai_run(25)
end
function hknight_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = hknight_run8
	ai_run(21)
end
function hknight_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_run(13)
end

--============================================================================

function hknight_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = hknight_pain2
	sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM)
end
function hknight_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = hknight_pain3
end
function hknight_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = hknight_pain4
end
function hknight_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = hknight_pain5
end
function hknight_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = hknight_run1
end

--============================================================================

function hknight_die1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = hknight_die2
	ai_forward(10)
end
function hknight_die2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = hknight_die3
	ai_forward(8)
end
function hknight_die3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = hknight_die4
	self.solid = SOLID_NOT
	 ai_forward(7)
end
function hknight_die4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = hknight_die5
end
function hknight_die5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = hknight_die6
end
function hknight_die6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = hknight_die7
end
function hknight_die7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = hknight_die8
end
function hknight_die8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = hknight_die9
	ai_forward(10)
end
function hknight_die9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = hknight_die10
	ai_forward(11)
end
function hknight_die10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = hknight_die11
end
function hknight_die11()
	self.frame=FRAME_death11
	self.nextthink = time + 0.1
	self.think = hknight_die12
end
function hknight_die12()
	self.frame=FRAME_death12
	self.nextthink = time + 0.1
	self.think = hknight_die12
end

function hknight_dieb1()
	self.frame=FRAME_deathb1
	self.nextthink = time + 0.1
	self.think = hknight_dieb2
end
function hknight_dieb2()
	self.frame=FRAME_deathb2
	self.nextthink = time + 0.1
	self.think = hknight_dieb3
end
function hknight_dieb3()
	self.frame=FRAME_deathb3
	self.nextthink = time + 0.1
	self.think = hknight_dieb4
	self.solid = SOLID_NOT
end
function hknight_dieb4()
	self.frame=FRAME_deathb4
	self.nextthink = time + 0.1
	self.think = hknight_dieb5
end
function hknight_dieb5()
	self.frame=FRAME_deathb5
	self.nextthink = time + 0.1
	self.think = hknight_dieb6
end
function hknight_dieb6()
	self.frame=FRAME_deathb6
	self.nextthink = time + 0.1
	self.think = hknight_dieb7
end
function hknight_dieb7()
	self.frame=FRAME_deathb7
	self.nextthink = time + 0.1
	self.think = hknight_dieb8
end
function hknight_dieb8()
	self.frame=FRAME_deathb8
	self.nextthink = time + 0.1
	self.think = hknight_dieb9
end
function hknight_dieb9()
	self.frame=FRAME_deathb9
	self.nextthink = time + 0.1
	self.think = hknight_dieb9
end

function hknight_die()
-- check for gib
	if self.health < -40 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM)
		ThrowHead ("progs/h_hellkn.mdl", self.health)
		ThrowGib ("progs/gib1.mdl", self.health)
		ThrowGib ("progs/gib2.mdl", self.health)
		ThrowGib ("progs/gib3.mdl", self.health)
		return
	end

-- regular death
	sound (self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM)
	if random() > 0.5 then -- TODO check condition
		hknight_die1 ()
	else
		hknight_dieb1 ()
        end
end


--============================================================================

function hknight_magica1()
	self.frame=FRAME_magica1
	self.nextthink = time + 0.1
	self.think = hknight_magica2
	ai_face()
end
function hknight_magica2()
	self.frame=FRAME_magica2
	self.nextthink = time + 0.1
	self.think = hknight_magica3
	ai_face()
end
function hknight_magica3()
	self.frame=FRAME_magica3
	self.nextthink = time + 0.1
	self.think = hknight_magica4
	ai_face()
end
function hknight_magica4()
	self.frame=FRAME_magica4
	self.nextthink = time + 0.1
	self.think = hknight_magica5
	ai_face()
end
function hknight_magica5()
	self.frame=FRAME_magica5
	self.nextthink = time + 0.1
	self.think = hknight_magica6
	ai_face()
end
function hknight_magica6()
	self.frame=FRAME_magica6
	self.nextthink = time + 0.1
	self.think = hknight_magica7
	ai_face()
end
function hknight_magica7()
	self.frame=FRAME_magica7
	self.nextthink = time + 0.1
	self.think = hknight_magica8
	hknight_shot(-2)
end
function hknight_magica8()
	self.frame=FRAME_magica8
	self.nextthink = time + 0.1
	self.think = hknight_magica9
	hknight_shot(-1)
end
function hknight_magica9()
	self.frame=FRAME_magica9
	self.nextthink = time + 0.1
	self.think = hknight_magica10
	hknight_shot(0)
end
function hknight_magica10()
	self.frame=FRAME_magica10
	self.nextthink = time + 0.1
	self.think = hknight_magica11
	hknight_shot(1)
end
function hknight_magica11()
	self.frame=FRAME_magica11
	self.nextthink = time + 0.1
	self.think = hknight_magica12
	hknight_shot(2)
end
function hknight_magica12()
	self.frame=FRAME_magica12
	self.nextthink = time + 0.1
	self.think = hknight_magica13
	hknight_shot(3)
end
function hknight_magica13()
	self.frame=FRAME_magica13
	self.nextthink = time + 0.1
	self.think = hknight_magica14
	ai_face()
end
function hknight_magica14()
	self.frame=FRAME_magica14
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_face()
end

--============================================================================

function hknight_magicb1()
	self.frame=FRAME_magicb1
	self.nextthink = time + 0.1
	self.think = hknight_magicb2
	ai_face()
end
function hknight_magicb2()
	self.frame=FRAME_magicb2
	self.nextthink = time + 0.1
	self.think = hknight_magicb3
	ai_face()
end
function hknight_magicb3()
	self.frame=FRAME_magicb3
	self.nextthink = time + 0.1
	self.think = hknight_magicb4
	ai_face()
end
function hknight_magicb4()
	self.frame=FRAME_magicb4
	self.nextthink = time + 0.1
	self.think = hknight_magicb5
	ai_face()
end
function hknight_magicb5()
	self.frame=FRAME_magicb5
	self.nextthink = time + 0.1
	self.think = hknight_magicb6
	ai_face()
end
function hknight_magicb6()
	self.frame=FRAME_magicb6
	self.nextthink = time + 0.1
	self.think = hknight_magicb7
	ai_face()
end
function hknight_magicb7()
	self.frame=FRAME_magicb7
	self.nextthink = time + 0.1
	self.think = hknight_magicb8
	hknight_shot(-2)
end
function hknight_magicb8()
	self.frame=FRAME_magicb8
	self.nextthink = time + 0.1
	self.think = hknight_magicb9
	hknight_shot(-1)
end
function hknight_magicb9()
	self.frame=FRAME_magicb9
	self.nextthink = time + 0.1
	self.think = hknight_magicb10
	hknight_shot(0)
end
function hknight_magicb10()
	self.frame=FRAME_magicb10
	self.nextthink = time + 0.1
	self.think = hknight_magicb11
	hknight_shot(1)
end
function hknight_magicb11()
	self.frame=FRAME_magicb11
	self.nextthink = time + 0.1
	self.think = hknight_magicb12
	hknight_shot(2)
end
function hknight_magicb12()
	self.frame=FRAME_magicb12
	self.nextthink = time + 0.1
	self.think = hknight_magicb13
	hknight_shot(3)
end
function hknight_magicb13()
	self.frame=FRAME_magicb13
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_face()
end

--============================================================================

function hknight_magicc1()
	self.frame=FRAME_magicc1
	self.nextthink = time + 0.1
	self.think = hknight_magicc2
	ai_face()
end
function hknight_magicc2()
	self.frame=FRAME_magicc2
	self.nextthink = time + 0.1
	self.think = hknight_magicc3
	ai_face()
end
function hknight_magicc3()
	self.frame=FRAME_magicc3
	self.nextthink = time + 0.1
	self.think = hknight_magicc4
	ai_face()
end
function hknight_magicc4()
	self.frame=FRAME_magicc4
	self.nextthink = time + 0.1
	self.think = hknight_magicc5
	ai_face()
end
function hknight_magicc5()
	self.frame=FRAME_magicc5
	self.nextthink = time + 0.1
	self.think = hknight_magicc6
	ai_face()
end
function hknight_magicc6()
	self.frame=FRAME_magicc6
	self.nextthink = time + 0.1
	self.think = hknight_magicc7
	hknight_shot(-2)
end
function hknight_magicc7()
	self.frame=FRAME_magicc7
	self.nextthink = time + 0.1
	self.think = hknight_magicc8
	hknight_shot(-1)
end
function hknight_magicc8()
	self.frame=FRAME_magicc8
	self.nextthink = time + 0.1
	self.think = hknight_magicc9
	hknight_shot(0)
end
function hknight_magicc9()
	self.frame=FRAME_magicc9
	self.nextthink = time + 0.1
	self.think = hknight_magicc10
	hknight_shot(1)
end
function hknight_magicc10()
	self.frame=FRAME_magicc10
	self.nextthink = time + 0.1
	self.think = hknight_magicc11
	hknight_shot(2)
end
function hknight_magicc11()
	self.frame=FRAME_magicc11
	self.nextthink = time + 0.1
	self.think = hknight_run1
	hknight_shot(3)
end

--===========================================================================

function hknight_char_a1()
	self.frame=FRAME_char_a1
	self.nextthink = time + 0.1
	self.think = hknight_char_a2
	ai_charge(20)
end
function hknight_char_a2()
	self.frame=FRAME_char_a2
	self.nextthink = time + 0.1
	self.think = hknight_char_a3
	ai_charge(25)
end
function hknight_char_a3()
	self.frame=FRAME_char_a3
	self.nextthink = time + 0.1
	self.think = hknight_char_a4
	ai_charge(18)
end
function hknight_char_a4()
	self.frame=FRAME_char_a4
	self.nextthink = time + 0.1
	self.think = hknight_char_a5
	ai_charge(16)
end
function hknight_char_a5()
	self.frame=FRAME_char_a5
	self.nextthink = time + 0.1
	self.think = hknight_char_a6
	ai_charge(14)
end
function hknight_char_a6()
	self.frame=FRAME_char_a6
	self.nextthink = time + 0.1
	self.think = hknight_char_a7
	ai_charge(20)
	 ai_melee()
end
function hknight_char_a7()
	self.frame=FRAME_char_a7
	self.nextthink = time + 0.1
	self.think = hknight_char_a8
	ai_charge(21)
	 ai_melee()
end
function hknight_char_a8()
	self.frame=FRAME_char_a8
	self.nextthink = time + 0.1
	self.think = hknight_char_a9
	ai_charge(13)
	 ai_melee()
end
function hknight_char_a9()
	self.frame=FRAME_char_a9
	self.nextthink = time + 0.1
	self.think = hknight_char_a10
	ai_charge(20)
	 ai_melee()
end
function hknight_char_a10()
	self.frame=FRAME_char_a10
	self.nextthink = time + 0.1
	self.think = hknight_char_a11
	ai_charge(20)
	 ai_melee()
end
function hknight_char_a11()
	self.frame=FRAME_char_a11
	self.nextthink = time + 0.1
	self.think = hknight_char_a12
	ai_charge(18)
	 ai_melee()
end
function hknight_char_a12()
	self.frame=FRAME_char_a12
	self.nextthink = time + 0.1
	self.think = hknight_char_a13
	ai_charge(16)
end
function hknight_char_a13()
	self.frame=FRAME_char_a13
	self.nextthink = time + 0.1
	self.think = hknight_char_a14
	ai_charge(14)
end
function hknight_char_a14()
	self.frame=FRAME_char_a14
	self.nextthink = time + 0.1
	self.think = hknight_char_a15
	ai_charge(25)
end
function hknight_char_a15()
	self.frame=FRAME_char_a15
	self.nextthink = time + 0.1
	self.think = hknight_char_a16
	ai_charge(21)
end
function hknight_char_a16()
	self.frame=FRAME_char_a16
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_charge(13)
end

--===========================================================================

function hknight_char_b1()
	self.frame=FRAME_char_b1
	self.nextthink = time + 0.1
	self.think = hknight_char_b2
	CheckContinueCharge ()
	 ai_charge(23)
	 ai_melee()
end
function hknight_char_b2()
	self.frame=FRAME_char_b2
	self.nextthink = time + 0.1
	self.think = hknight_char_b3
	ai_charge(17)
	 ai_melee()
end
function hknight_char_b3()
	self.frame=FRAME_char_b3
	self.nextthink = time + 0.1
	self.think = hknight_char_b4
	ai_charge(12)
	 ai_melee()
end
function hknight_char_b4()
	self.frame=FRAME_char_b4
	self.nextthink = time + 0.1
	self.think = hknight_char_b5
	ai_charge(22)
	 ai_melee()
end
function hknight_char_b5()
	self.frame=FRAME_char_b5
	self.nextthink = time + 0.1
	self.think = hknight_char_b6
	ai_charge(18)
	 ai_melee()
end
function hknight_char_b6()
	self.frame=FRAME_char_b6
	self.nextthink = time + 0.1
	self.think = hknight_char_b1
	ai_charge(8)
	 ai_melee()
end

--===========================================================================

function hknight_slice1()
	self.frame=FRAME_slice1
	self.nextthink = time + 0.1
	self.think = hknight_slice2
	ai_charge(9)
end
function hknight_slice2()
	self.frame=FRAME_slice2
	self.nextthink = time + 0.1
	self.think = hknight_slice3
	ai_charge(6)
end
function hknight_slice3()
	self.frame=FRAME_slice3
	self.nextthink = time + 0.1
	self.think = hknight_slice4
	ai_charge(13)
end
function hknight_slice4()
	self.frame=FRAME_slice4
	self.nextthink = time + 0.1
	self.think = hknight_slice5
	ai_charge(4)
end
function hknight_slice5()
	self.frame=FRAME_slice5
	self.nextthink = time + 0.1
	self.think = hknight_slice6
	ai_charge(7)
	 ai_melee()
end
function hknight_slice6()
	self.frame=FRAME_slice6
	self.nextthink = time + 0.1
	self.think = hknight_slice7
	ai_charge(15)
	 ai_melee()
end
function hknight_slice7()
	self.frame=FRAME_slice7
	self.nextthink = time + 0.1
	self.think = hknight_slice8
	ai_charge(8)
	 ai_melee()
end
function hknight_slice8()
	self.frame=FRAME_slice8
	self.nextthink = time + 0.1
	self.think = hknight_slice9
	ai_charge(2)
	 ai_melee()
end
function hknight_slice9()
	self.frame=FRAME_slice9
	self.nextthink = time + 0.1
	self.think = hknight_slice10
	ai_melee()
end
function hknight_slice10()
	self.frame=FRAME_slice10
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_charge(3)
end

--===========================================================================

function hknight_smash1()
	self.frame=FRAME_smash1
	self.nextthink = time + 0.1
	self.think = hknight_smash2
	ai_charge(1)
end
function hknight_smash2()
	self.frame=FRAME_smash2
	self.nextthink = time + 0.1
	self.think = hknight_smash3
	ai_charge(13)
end
function hknight_smash3()
	self.frame=FRAME_smash3
	self.nextthink = time + 0.1
	self.think = hknight_smash4
	ai_charge(9)
end
function hknight_smash4()
	self.frame=FRAME_smash4
	self.nextthink = time + 0.1
	self.think = hknight_smash5
	ai_charge(11)
end
function hknight_smash5()
	self.frame=FRAME_smash5
	self.nextthink = time + 0.1
	self.think = hknight_smash6
	ai_charge(10)
	 ai_melee()
end
function hknight_smash6()
	self.frame=FRAME_smash6
	self.nextthink = time + 0.1
	self.think = hknight_smash7
	ai_charge(7)
	 ai_melee()
end
function hknight_smash7()
	self.frame=FRAME_smash7
	self.nextthink = time + 0.1
	self.think = hknight_smash8
	ai_charge(12)
	 ai_melee()
end
function hknight_smash8()
	self.frame=FRAME_smash8
	self.nextthink = time + 0.1
	self.think = hknight_smash9
	ai_charge(2)
	 ai_melee()
end
function hknight_smash9()
	self.frame=FRAME_smash9
	self.nextthink = time + 0.1
	self.think = hknight_smash10
	ai_charge(3)
	 ai_melee()
end
function hknight_smash10()
	self.frame=FRAME_smash10
	self.nextthink = time + 0.1
	self.think = hknight_smash11
	ai_charge(0)
end
function hknight_smash11()
	self.frame=FRAME_smash11
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_charge(0)
end

--============================================================================

function hknight_watk1()
	self.frame=FRAME_w_attack1
	self.nextthink = time + 0.1
	self.think = hknight_watk2
	ai_charge(2)
end
function hknight_watk2()
	self.frame=FRAME_w_attack2
	self.nextthink = time + 0.1
	self.think = hknight_watk3
	ai_charge(0)
end
function hknight_watk3()
	self.frame=FRAME_w_attack3
	self.nextthink = time + 0.1
	self.think = hknight_watk4
	ai_charge(0)
end
function hknight_watk4()
	self.frame=FRAME_w_attack4
	self.nextthink = time + 0.1
	self.think = hknight_watk5
	ai_melee()
end
function hknight_watk5()
	self.frame=FRAME_w_attack5
	self.nextthink = time + 0.1
	self.think = hknight_watk6
	ai_melee()
end
function hknight_watk6()
	self.frame=FRAME_w_attack6
	self.nextthink = time + 0.1
	self.think = hknight_watk7
	ai_melee()
end
function hknight_watk7()
	self.frame=FRAME_w_attack7
	self.nextthink = time + 0.1
	self.think = hknight_watk8
	ai_charge(1)
end
function hknight_watk8()
	self.frame=FRAME_w_attack8
	self.nextthink = time + 0.1
	self.think = hknight_watk9
	ai_charge(4)
end
function hknight_watk9()
	self.frame=FRAME_w_attack9
	self.nextthink = time + 0.1
	self.think = hknight_watk10
	ai_charge(5)
end
function hknight_watk10()
	self.frame=FRAME_w_attack10
	self.nextthink = time + 0.1
	self.think = hknight_watk11
	ai_charge(3)
	 ai_melee()
end
function hknight_watk11()
	self.frame=FRAME_w_attack11
	self.nextthink = time + 0.1
	self.think = hknight_watk12
	ai_charge(2)
	 ai_melee()
end
function hknight_watk12()
	self.frame=FRAME_w_attack12
	self.nextthink = time + 0.1
	self.think = hknight_watk13
	ai_charge(2)
	 ai_melee()
end
function hknight_watk13()
	self.frame=FRAME_w_attack13
	self.nextthink = time + 0.1
	self.think = hknight_watk14
	ai_charge(0)
end
function hknight_watk14()
	self.frame=FRAME_w_attack14
	self.nextthink = time + 0.1
	self.think = hknight_watk15
	ai_charge(0)
end
function hknight_watk15()
	self.frame=FRAME_w_attack15
	self.nextthink = time + 0.1
	self.think = hknight_watk16
	ai_charge(0)
end
function hknight_watk16()
	self.frame=FRAME_w_attack16
	self.nextthink = time + 0.1
	self.think = hknight_watk17
	ai_charge(1)
end
function hknight_watk17()
	self.frame=FRAME_w_attack17
	self.nextthink = time + 0.1
	self.think = hknight_watk18
	ai_charge(1)
	 ai_melee()
end
function hknight_watk18()
	self.frame=FRAME_w_attack18
	self.nextthink = time + 0.1
	self.think = hknight_watk19
	ai_charge(3)
	 ai_melee()
end
function hknight_watk19()
	self.frame=FRAME_w_attack19
	self.nextthink = time + 0.1
	self.think = hknight_watk20
	ai_charge(4)
	 ai_melee()
end
function hknight_watk20()
	self.frame=FRAME_w_attack20
	self.nextthink = time + 0.1
	self.think = hknight_watk21
	ai_charge(6)
end
function hknight_watk21()
	self.frame=FRAME_w_attack21
	self.nextthink = time + 0.1
	self.think = hknight_watk22
	ai_charge(7)
end
function hknight_watk22()
	self.frame=FRAME_w_attack22
	self.nextthink = time + 0.1
	self.think = hknight_run1
	ai_charge(3)
end

--============================================================================

function hk_idle_sound()
	if random() < 0.2 then -- TODO check condition
		sound (self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM)
        end
end

function hknight_pain(attacker, damage) -- entity, float
        if not self.pain_finished then self.pain_finished = 0 end

	if self.pain_finished > time then -- TODO check condition
		return
        end

	sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM)

	if time - self.pain_finished > 5 then -- TODO check condition
		hknight_pain1 ()
		self.pain_finished = time + 1
		return
	end
	
	if (random()*30 > damage)  then -- TODO check condition
		return		-- didn't flinch
        end

	self.pain_finished = time + 1
	hknight_pain1 ()
end

local hknight_type = 0

function hknight_melee()
	hknight_type = hknight_type + 1

	sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM)
	if hknight_type == 1 then -- TODO check condition
		hknight_slice1 ()
	elseif hknight_type == 2 then -- TODO check condition
		hknight_smash1 ()
	elseif hknight_type == 3 then -- TODO check condition
		hknight_watk1 ()
		hknight_type = 0
	end
end

--/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
--*/
function monster_hell_knight()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model2 ("progs/hknight.mdl")
	precache_model2 ("progs/k_spike.mdl")
	precache_model2 ("progs/h_hellkn.mdl")

	
	precache_sound2 ("hknight/attack1.wav")
	precache_sound2 ("hknight/death1.wav")
	precache_sound2 ("hknight/pain1.wav")
	precache_sound2 ("hknight/sight1.wav")
	precache_sound ("hknight/hit.wav")		-- used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav")
	precache_sound2 ("hknight/idle.wav")
	precache_sound2 ("hknight/grunt.wav")

	precache_sound ("knight/sword1.wav")
	precache_sound ("knight/sword2.wav")
	
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/hknight.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 250

	self.th_stand = hknight_stand1
	self.th_walk = hknight_walk1
	self.th_run = hknight_run1
	self.th_melee = hknight_melee
	self.th_missile = hknight_magicc1
	self.th_pain = hknight_pain
	self.th_die = hknight_die
	
	walkmonster_start ()
end
