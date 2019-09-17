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
--BLOB
--
--==============================================================================
--*/



local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8,FRAME_walk9,FRAME_walk10 = 0,1,2,3,4,5,6,7,8,9
local FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15,FRAME_walk16,FRAME_walk17,FRAME_walk18,FRAME_walk19 = 10,11,12,13,14,15,16,17,18
local FRAME_walk20,FRAME_walk21,FRAME_walk22,FRAME_walk23,FRAME_walk24,FRAME_walk25 = 19,20,21,22,23,24

local FRAME_run1,FRAME_run2,FRAME_run3,FRAME_run4,FRAME_run5,FRAME_run6,FRAME_run7,FRAME_run8,FRAME_run9,FRAME_run10,FRAME_run11,FRAME_run12,FRAME_run13 = 25,26,27,28,29,30,31,32,33,34,35,36,37
local FRAME_run14,FRAME_run15,FRAME_run16,FRAME_run17,FRAME_run18,FRAME_run19,FRAME_run20,FRAME_run21,FRAME_run22,FRAME_run23 = 38,39,40,41,42,43,44,45,46,47
local FRAME_run24,FRAME_run25 = 48,49

local FRAME_jump1,FRAME_jump2,FRAME_jump3,FRAME_jump4,FRAME_jump5,FRAME_jump6 = 50,51,52,53,54,55

local FRAME_fly1,FRAME_fly2,FRAME_fly3,FRAME_fly4 = 56,57,58,59

local FRAME_exp = 60

function tbaby_stand1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = tbaby_stand1
	ai_stand()
end

function tbaby_hang1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = tbaby_hang1
	ai_stand()
end

function tbaby_walk1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = tbaby_walk2
	ai_turn()
end
function tbaby_walk2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = tbaby_walk3
	ai_turn()
end
function tbaby_walk3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = tbaby_walk4
	ai_turn()
end
function tbaby_walk4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = tbaby_walk5
	ai_turn()
end
function tbaby_walk5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = tbaby_walk6
	ai_turn()
end
function tbaby_walk6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = tbaby_walk7
	ai_turn()
end
function tbaby_walk7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = tbaby_walk8
	ai_turn()
end
function tbaby_walk8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = tbaby_walk9
	ai_turn()
end
function tbaby_walk9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = tbaby_walk10
	ai_turn()
end
function tbaby_walk10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = tbaby_walk11
	ai_turn()
end
function tbaby_walk11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = tbaby_walk12
	ai_walk(2)
end
function tbaby_walk12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = tbaby_walk13
	ai_walk(2)
end
function tbaby_walk13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = tbaby_walk14
	ai_walk(2)
end
function tbaby_walk14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = tbaby_walk15
	ai_walk(2)
end
function tbaby_walk15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = tbaby_walk16
	ai_walk(2)
end
function tbaby_walk16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = tbaby_walk17
	ai_walk(2)
end
function tbaby_walk17()
	self.frame=FRAME_walk17
	self.nextthink = time + 0.1
	self.think = tbaby_walk18
	ai_walk(2)
end
function tbaby_walk18()
	self.frame=FRAME_walk18
	self.nextthink = time + 0.1
	self.think = tbaby_walk19
	ai_walk(2)
end
function tbaby_walk19()
	self.frame=FRAME_walk19
	self.nextthink = time + 0.1
	self.think = tbaby_walk20
	ai_walk(2)
end
function tbaby_walk20()
	self.frame=FRAME_walk20
	self.nextthink = time + 0.1
	self.think = tbaby_walk21
	ai_walk(2)
end
function tbaby_walk21()
	self.frame=FRAME_walk21
	self.nextthink = time + 0.1
	self.think = tbaby_walk22
	ai_walk(2)
end
function tbaby_walk22()
	self.frame=FRAME_walk22
	self.nextthink = time + 0.1
	self.think = tbaby_walk23
	ai_walk(2)
end
function tbaby_walk23()
	self.frame=FRAME_walk23
	self.nextthink = time + 0.1
	self.think = tbaby_walk24
	ai_walk(2)
end
function tbaby_walk24()
	self.frame=FRAME_walk24
	self.nextthink = time + 0.1
	self.think = tbaby_walk25
	ai_walk(2)
end
function tbaby_walk25()
	self.frame=FRAME_walk25
	self.nextthink = time + 0.1
	self.think = tbaby_walk1
	ai_walk(2)
end

function tbaby_run1()
	self.frame=FRAME_run1
	self.nextthink = time + 0.1
	self.think = tbaby_run2
	ai_face()
end
function tbaby_run2()
	self.frame=FRAME_run2
	self.nextthink = time + 0.1
	self.think = tbaby_run3
	ai_face()
end
function tbaby_run3()
	self.frame=FRAME_run3
	self.nextthink = time + 0.1
	self.think = tbaby_run4
	ai_face()
end
function tbaby_run4()
	self.frame=FRAME_run4
	self.nextthink = time + 0.1
	self.think = tbaby_run5
	ai_face()
end
function tbaby_run5()
	self.frame=FRAME_run5
	self.nextthink = time + 0.1
	self.think = tbaby_run6
	ai_face()
end
function tbaby_run6()
	self.frame=FRAME_run6
	self.nextthink = time + 0.1
	self.think = tbaby_run7
	ai_face()
end
function tbaby_run7()
	self.frame=FRAME_run7
	self.nextthink = time + 0.1
	self.think = tbaby_run8
	ai_face()
end
function tbaby_run8()
	self.frame=FRAME_run8
	self.nextthink = time + 0.1
	self.think = tbaby_run9
	ai_face()
end
function tbaby_run9()
	self.frame=FRAME_run9
	self.nextthink = time + 0.1
	self.think = tbaby_run10
	ai_face()
end
function tbaby_run10()
	self.frame=FRAME_run10
	self.nextthink = time + 0.1
	self.think = tbaby_run11
	ai_face()
end
function tbaby_run11()
	self.frame=FRAME_run11
	self.nextthink = time + 0.1
	self.think = tbaby_run12
	ai_run(2)
end
function tbaby_run12()
	self.frame=FRAME_run12
	self.nextthink = time + 0.1
	self.think = tbaby_run13
	ai_run(2)
end
function tbaby_run13()
	self.frame=FRAME_run13
	self.nextthink = time + 0.1
	self.think = tbaby_run14
	ai_run(2)
end
function tbaby_run14()
	self.frame=FRAME_run14
	self.nextthink = time + 0.1
	self.think = tbaby_run15
	ai_run(2)
end
function tbaby_run15()
	self.frame=FRAME_run15
	self.nextthink = time + 0.1
	self.think = tbaby_run16
	ai_run(2)
end
function tbaby_run16()
	self.frame=FRAME_run16
	self.nextthink = time + 0.1
	self.think = tbaby_run17
	ai_run(2)
end
function tbaby_run17()
	self.frame=FRAME_run17
	self.nextthink = time + 0.1
	self.think = tbaby_run18
	ai_run(2)
end
function tbaby_run18()
	self.frame=FRAME_run18
	self.nextthink = time + 0.1
	self.think = tbaby_run19
	ai_run(2)
end
function tbaby_run19()
	self.frame=FRAME_run19
	self.nextthink = time + 0.1
	self.think = tbaby_run20
	ai_run(2)
end
function tbaby_run20()
	self.frame=FRAME_run20
	self.nextthink = time + 0.1
	self.think = tbaby_run21
	ai_run(2)
end
function tbaby_run21()
	self.frame=FRAME_run21
	self.nextthink = time + 0.1
	self.think = tbaby_run22
	ai_run(2)
end
function tbaby_run22()
	self.frame=FRAME_run22
	self.nextthink = time + 0.1
	self.think = tbaby_run23
	ai_run(2)
end
function tbaby_run23()
	self.frame=FRAME_run23
	self.nextthink = time + 0.1
	self.think = tbaby_run24
	ai_run(2)
end
function tbaby_run24()
	self.frame=FRAME_run24
	self.nextthink = time + 0.1
	self.think = tbaby_run25
	ai_run(2)
end
function tbaby_run25()
	self.frame=FRAME_run25
	self.nextthink = time + 0.1
	self.think = tbaby_run1
	ai_run(2)
end


--============================================================================



function Tar_JumpTouch()
	local ldmg; -- float

	if other.takedamage ~= 0 and  other.classname ~= self.classname then -- TODO check condition
		if  vlen(self.velocity) > 400  then -- TODO check condition
			ldmg = 10 + 10*random()
			T_Damage (other, self, self, ldmg)	
			sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM)
		end
	else
		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM)
        end


	if  not checkbottom(self) then -- TODO check condition
		if self.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
--dprint ("popjump\n")
	                self.touch = SUB_Null
                	self.think = tbaby_run1
                	self.movetype = MOVETYPE_STEP
                	self.nextthink = time + 0.1

--			self.velocity.x = (random() - 0.5) * 600
--			self.velocity.y = (random() - 0.5) * 600
--			self.velocity.z = 200
--			self.flags = self.flags - FL_ONGROUND
		end
		return	-- not on ground yet
	end

	self.touch = SUB_Null
	self.think = tbaby_jump1
	self.nextthink = time + 0.1
end


function tbaby_fly1()
	self.frame=FRAME_fly1
	self.nextthink = time + 0.1
	self.think = tbaby_fly2
end
function tbaby_fly2()
	self.frame=FRAME_fly2
	self.nextthink = time + 0.1
	self.think = tbaby_fly3
end
function tbaby_fly3()
	self.frame=FRAME_fly3
	self.nextthink = time + 0.1
	self.think = tbaby_fly4
end
function tbaby_fly4()
	self.frame=FRAME_fly4
	self.nextthink = time + 0.1
	self.think = tbaby_fly1
        self.cnt = self.cnt + 1
        if self.cnt == 4 then -- TODO check condition
                --dprint ("spawn hop\n")
                tbaby_jump5 ()
        end
end

function tbaby_jump1()
	self.frame=FRAME_jump1
	self.nextthink = time + 0.1
	self.think = tbaby_jump2
	ai_face()
end
function tbaby_jump2()
	self.frame=FRAME_jump2
	self.nextthink = time + 0.1
	self.think = tbaby_jump3
	ai_face()
end
function tbaby_jump3()
	self.frame=FRAME_jump3
	self.nextthink = time + 0.1
	self.think = tbaby_jump4
	ai_face()
end
function tbaby_jump4()
	self.frame=FRAME_jump4
	self.nextthink = time + 0.1
	self.think = tbaby_jump5
	ai_face()
end
function tbaby_jump5()
	self.frame=FRAME_jump5
	self.nextthink = time + 0.1
	self.think = tbaby_jump6
	self.movetype = MOVETYPE_BOUNCE
	self.touch = Tar_JumpTouch
	makevectors (self.angles)
	self.origin.z = self.origin.z + 1
	self.velocity = qc.v_forward * 600 + vec3(0, 0, 200)
	self.velocity.z = self.velocity.z + random()*150
	if self.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
		self.flags = self.flags - FL_ONGROUND
        end
	self.cnt = 0
end
function tbaby_jump6()
	self.frame=FRAME_jump6
	self.nextthink = time + 0.1
	self.think = tbaby_fly1
end



--=============================================================================

function tbaby_die1()
	self.frame=FRAME_exp
	self.nextthink = time + 0.1
	self.think = tbaby_die2
        self.takedamage = DAMAGE_NO
end
function tbaby_die2()
	self.frame=FRAME_exp
	self.nextthink = time + 0.1
	self.think = tbaby_run1
	T_RadiusDamage (self, self, 120, world)

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM)
	self.origin = self.origin - 8*normalize(self.velocity)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)
	
	BecomeExplosion ()
end

--=============================================================================


--/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
--*/
function monster_tarbaby()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model2 ("progs/tarbaby.mdl")

	precache_sound2 ("blob/death1.wav")
	precache_sound2 ("blob/hit1.wav")
	precache_sound2 ("blob/land1.wav")
	precache_sound2 ("blob/sight1.wav")
	
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/tarbaby.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 40))
	self.health = 80

	self.th_stand = tbaby_stand1
	self.th_walk = tbaby_walk1
	self.th_run = tbaby_run1
	self.th_missile = tbaby_jump1
	self.th_melee = tbaby_jump1
	self.th_die = tbaby_die1
        self.cnt = 0
	
	walkmonster_start ()
end

