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
--BOSS-ONE
--
--==============================================================================
--*/

local FRAME_rise1,FRAME_rise2,FRAME_rise3,FRAME_rise4,FRAME_rise5,FRAME_rise6,FRAME_rise7,FRAME_rise8,FRAME_rise9,FRAME_rise10 = 0,1,2,3,4,5,6,7,8,9
local FRAME_rise11,FRAME_rise12,FRAME_rise13,FRAME_rise14,FRAME_rise15,FRAME_rise16,FRAME_rise17 = 10,11,12,13,14,15,16

local FRAME_walk1,FRAME_walk2,FRAME_walk3,FRAME_walk4,FRAME_walk5,FRAME_walk6,FRAME_walk7,FRAME_walk8 = 17,18,19,20,21,22,23,24
local FRAME_walk9,FRAME_walk10,FRAME_walk11,FRAME_walk12,FRAME_walk13,FRAME_walk14,FRAME_walk15 = 25,26,27,28,29,30,31
local FRAME_walk16,FRAME_walk17,FRAME_walk18,FRAME_walk19,FRAME_walk20,FRAME_walk21,FRAME_walk22 = 32,33,34,35,36,37,38
local FRAME_walk23,FRAME_walk24,FRAME_walk25,FRAME_walk26,FRAME_walk27,FRAME_walk28,FRAME_walk29,FRAME_walk30,FRAME_walk31 = 39,40,41,42,43,44,45,46,47

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7,FRAME_death8,FRAME_death9 = 48,49,50,51,52,53,54,55,56

local FRAME_attack1,FRAME_attack2,FRAME_attack3,FRAME_attack4,FRAME_attack5,FRAME_attack6,FRAME_attack7,FRAME_attack8 = 57,58,59,60,61,62,63,64
local FRAME_attack9,FRAME_attack10,FRAME_attack11,FRAME_attack12,FRAME_attack13,FRAME_attack14,FRAME_attack15 = 65,66,67,68,69,70,71
local FRAME_attack16,FRAME_attack17,FRAME_attack18,FRAME_attack19,FRAME_attack20,FRAME_attack21,FRAME_attack22 = 72,73,74,75,76,77,78
local FRAME_attack23 = 79

local FRAME_shocka1,FRAME_shocka2,FRAME_shocka3,FRAME_shocka4,FRAME_shocka5,FRAME_shocka6,FRAME_shocka7,FRAME_shocka8 = 80,81,82,83,84,85,86,87
local FRAME_shocka9,FRAME_shocka10 = 88,89

local FRAME_shockb1,FRAME_shockb2,FRAME_shockb3,FRAME_shockb4,FRAME_shockb5,FRAME_shockb6 = 90,91,92,93,94,95

local FRAME_shockc1,FRAME_shockc2,FRAME_shockc3,FRAME_shockc4,FRAME_shockc5,FRAME_shockc6,FRAME_shockc7,FRAME_shockc8 = 96,97,98,99,100,101,102,103
local FRAME_shockc9,FRAME_shockc10 = 104,105



function boss_face()
	
-- go for another player if multi player
	if self.enemy.health <= 0  or  random() < 0.02 then -- TODO check condition
		self.enemy = find(self.enemy, "classname", "player")
		if  not self.enemy then -- TODO check condition
			self.enemy = find(self.enemy, "classname", "player")
                end
	end
	ai_face()
end

function boss_rise1()
	self.frame=FRAME_rise1
	self.nextthink = time + 0.1
	self.think = boss_rise2
        sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM)
end
function boss_rise2()
	self.frame=FRAME_rise2
	self.nextthink = time + 0.1
	self.think = boss_rise3
sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM)
end
function boss_rise3()
	self.frame=FRAME_rise3
	self.nextthink = time + 0.1
	self.think = boss_rise4
end
function boss_rise4()
	self.frame=FRAME_rise4
	self.nextthink = time + 0.1
	self.think = boss_rise5
end
function boss_rise5()
	self.frame=FRAME_rise5
	self.nextthink = time + 0.1
	self.think = boss_rise6
end
function boss_rise6()
	self.frame=FRAME_rise6
	self.nextthink = time + 0.1
	self.think = boss_rise7
end
function boss_rise7()
	self.frame=FRAME_rise7
	self.nextthink = time + 0.1
	self.think = boss_rise8
end
function boss_rise8()
	self.frame=FRAME_rise8
	self.nextthink = time + 0.1
	self.think = boss_rise9
end
function boss_rise9()
	self.frame=FRAME_rise9
	self.nextthink = time + 0.1
	self.think = boss_rise10
end
function boss_rise10()
	self.frame=FRAME_rise10
	self.nextthink = time + 0.1
	self.think = boss_rise11
end
function boss_rise11()
	self.frame=FRAME_rise11
	self.nextthink = time + 0.1
	self.think = boss_rise12
end
function boss_rise12()
	self.frame=FRAME_rise12
	self.nextthink = time + 0.1
	self.think = boss_rise13
end
function boss_rise13()
	self.frame=FRAME_rise13
	self.nextthink = time + 0.1
	self.think = boss_rise14
end
function boss_rise14()
	self.frame=FRAME_rise14
	self.nextthink = time + 0.1
	self.think = boss_rise15
end
function boss_rise15()
	self.frame=FRAME_rise15
	self.nextthink = time + 0.1
	self.think = boss_rise16
end
function boss_rise16()
	self.frame=FRAME_rise16
	self.nextthink = time + 0.1
	self.think = boss_rise17
end
function boss_rise17()
	self.frame=FRAME_rise17
	self.nextthink = time + 0.1
	self.think = boss_missile1
end

function boss_idle1()
	self.frame=FRAME_walk1
	self.nextthink = time + 0.1
	self.think = boss_idle2
-- look for other players
end
function boss_idle2()
	self.frame=FRAME_walk2
	self.nextthink = time + 0.1
	self.think = boss_idle3
	boss_face()
end
function boss_idle3()
	self.frame=FRAME_walk3
	self.nextthink = time + 0.1
	self.think = boss_idle4
	boss_face()
end
function boss_idle4()
	self.frame=FRAME_walk4
	self.nextthink = time + 0.1
	self.think = boss_idle5
	boss_face()
end
function boss_idle5()
	self.frame=FRAME_walk5
	self.nextthink = time + 0.1
	self.think = boss_idle6
	boss_face()
end
function boss_idle6()
	self.frame=FRAME_walk6
	self.nextthink = time + 0.1
	self.think = boss_idle7
	boss_face()
end
function boss_idle7()
	self.frame=FRAME_walk7
	self.nextthink = time + 0.1
	self.think = boss_idle8
	boss_face()
end
function boss_idle8()
	self.frame=FRAME_walk8
	self.nextthink = time + 0.1
	self.think = boss_idle9
	boss_face()
end
function boss_idle9()
	self.frame=FRAME_walk9
	self.nextthink = time + 0.1
	self.think = boss_idle10
	boss_face()
end
function boss_idle10()
	self.frame=FRAME_walk10
	self.nextthink = time + 0.1
	self.think = boss_idle11
	boss_face()
end
function boss_idle11()
	self.frame=FRAME_walk11
	self.nextthink = time + 0.1
	self.think = boss_idle12
	boss_face()
end
function boss_idle12()
	self.frame=FRAME_walk12
	self.nextthink = time + 0.1
	self.think = boss_idle13
	boss_face()
end
function boss_idle13()
	self.frame=FRAME_walk13
	self.nextthink = time + 0.1
	self.think = boss_idle14
	boss_face()
end
function boss_idle14()
	self.frame=FRAME_walk14
	self.nextthink = time + 0.1
	self.think = boss_idle15
	boss_face()
end
function boss_idle15()
	self.frame=FRAME_walk15
	self.nextthink = time + 0.1
	self.think = boss_idle16
	boss_face()
end
function boss_idle16()
	self.frame=FRAME_walk16
	self.nextthink = time + 0.1
	self.think = boss_idle17
	boss_face()
end
function boss_idle17()
	self.frame=FRAME_walk17
	self.nextthink = time + 0.1
	self.think = boss_idle18
	boss_face()
end
function boss_idle18()
	self.frame=FRAME_walk18
	self.nextthink = time + 0.1
	self.think = boss_idle19
	boss_face()
end
function boss_idle19()
	self.frame=FRAME_walk19
	self.nextthink = time + 0.1
	self.think = boss_idle20
	boss_face()
end
function boss_idle20()
	self.frame=FRAME_walk20
	self.nextthink = time + 0.1
	self.think = boss_idle21
	boss_face()
end
function boss_idle21()
	self.frame=FRAME_walk21
	self.nextthink = time + 0.1
	self.think = boss_idle22
	boss_face()
end
function boss_idle22()
	self.frame=FRAME_walk22
	self.nextthink = time + 0.1
	self.think = boss_idle23
	boss_face()
end
function boss_idle23()
	self.frame=FRAME_walk23
	self.nextthink = time + 0.1
	self.think = boss_idle24
	boss_face()
end
function boss_idle24()
	self.frame=FRAME_walk24
	self.nextthink = time + 0.1
	self.think = boss_idle25
	boss_face()
end
function boss_idle25()
	self.frame=FRAME_walk25
	self.nextthink = time + 0.1
	self.think = boss_idle26
	boss_face()
end
function boss_idle26()
	self.frame=FRAME_walk26
	self.nextthink = time + 0.1
	self.think = boss_idle27
	boss_face()
end
function boss_idle27()
	self.frame=FRAME_walk27
	self.nextthink = time + 0.1
	self.think = boss_idle28
	boss_face()
end
function boss_idle28()
	self.frame=FRAME_walk28
	self.nextthink = time + 0.1
	self.think = boss_idle29
	boss_face()
end
function boss_idle29()
	self.frame=FRAME_walk29
	self.nextthink = time + 0.1
	self.think = boss_idle30
	boss_face()
end
function boss_idle30()
	self.frame=FRAME_walk30
	self.nextthink = time + 0.1
	self.think = boss_idle31
	boss_face()
end
function boss_idle31()
	self.frame=FRAME_walk31
	self.nextthink = time + 0.1
	self.think = boss_idle1
	boss_face()
end

function boss_missile1()
	self.frame=FRAME_attack1
	self.nextthink = time + 0.1
	self.think = boss_missile2
	boss_face()
end
function boss_missile2()
	self.frame=FRAME_attack2
	self.nextthink = time + 0.1
	self.think = boss_missile3
	boss_face()
end
function boss_missile3()
	self.frame=FRAME_attack3
	self.nextthink = time + 0.1
	self.think = boss_missile4
	boss_face()
end
function boss_missile4()
	self.frame=FRAME_attack4
	self.nextthink = time + 0.1
	self.think = boss_missile5
	boss_face()
end
function boss_missile5()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = boss_missile6
	boss_face()
end
function boss_missile6()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = boss_missile7
	boss_face()
end
function boss_missile7()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = boss_missile8
	boss_face()
end
function boss_missile8()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = boss_missile9
	boss_face()
end
function boss_missile9()
	self.frame=FRAME_attack9
	self.nextthink = time + 0.1
	self.think = boss_missile10
	boss_missile(vec3(100, 100, 200))
end
function boss_missile10()
	self.frame=FRAME_attack10
	self.nextthink = time + 0.1
	self.think = boss_missile11
	boss_face()
end
function boss_missile11()
	self.frame=FRAME_attack11
	self.nextthink = time + 0.1
	self.think = boss_missile12
	boss_face()
end
function boss_missile12()
	self.frame=FRAME_attack12
	self.nextthink = time + 0.1
	self.think = boss_missile13
	boss_face()
end
function boss_missile13()
	self.frame=FRAME_attack13
	self.nextthink = time + 0.1
	self.think = boss_missile14
	boss_face()
end
function boss_missile14()
	self.frame=FRAME_attack14
	self.nextthink = time + 0.1
	self.think = boss_missile15
	boss_face()
end
function boss_missile15()
	self.frame=FRAME_attack15
	self.nextthink = time + 0.1
	self.think = boss_missile16
	boss_face()
end
function boss_missile16()
	self.frame=FRAME_attack16
	self.nextthink = time + 0.1
	self.think = boss_missile17
	boss_face()
end
function boss_missile17()
	self.frame=FRAME_attack17
	self.nextthink = time + 0.1
	self.think = boss_missile18
	boss_face()
end
function boss_missile18()
	self.frame=FRAME_attack18
	self.nextthink = time + 0.1
	self.think = boss_missile19
	boss_face()
end
function boss_missile19()
	self.frame=FRAME_attack19
	self.nextthink = time + 0.1
	self.think = boss_missile20
	boss_face()
end
function boss_missile20()
	self.frame=FRAME_attack20
	self.nextthink = time + 0.1
	self.think = boss_missile21
	boss_missile(vec3(100, -100, 200))
end
function boss_missile21()
	self.frame=FRAME_attack21
	self.nextthink = time + 0.1
	self.think = boss_missile22
	boss_face()
end
function boss_missile22()
	self.frame=FRAME_attack22
	self.nextthink = time + 0.1
	self.think = boss_missile23
	boss_face()
end
function boss_missile23()
	self.frame=FRAME_attack23
	self.nextthink = time + 0.1
	self.think = boss_missile1
	boss_face()
end

function boss_shocka1()
	self.frame=FRAME_shocka1
	self.nextthink = time + 0.1
	self.think = boss_shocka2
end
function boss_shocka2()
	self.frame=FRAME_shocka2
	self.nextthink = time + 0.1
	self.think = boss_shocka3
end
function boss_shocka3()
	self.frame=FRAME_shocka3
	self.nextthink = time + 0.1
	self.think = boss_shocka4
end
function boss_shocka4()
	self.frame=FRAME_shocka4
	self.nextthink = time + 0.1
	self.think = boss_shocka5
end
function boss_shocka5()
	self.frame=FRAME_shocka5
	self.nextthink = time + 0.1
	self.think = boss_shocka6
end
function boss_shocka6()
	self.frame=FRAME_shocka6
	self.nextthink = time + 0.1
	self.think = boss_shocka7
end
function boss_shocka7()
	self.frame=FRAME_shocka7
	self.nextthink = time + 0.1
	self.think = boss_shocka8
end
function boss_shocka8()
	self.frame=FRAME_shocka8
	self.nextthink = time + 0.1
	self.think = boss_shocka9
end
function boss_shocka9()
	self.frame=FRAME_shocka9
	self.nextthink = time + 0.1
	self.think = boss_shocka10
end
function boss_shocka10()
	self.frame=FRAME_shocka10
	self.nextthink = time + 0.1
	self.think = boss_missile1
end

function boss_shockb1()
	self.frame=FRAME_shockb1
	self.nextthink = time + 0.1
	self.think = boss_shockb2
end
function boss_shockb2()
	self.frame=FRAME_shockb2
	self.nextthink = time + 0.1
	self.think = boss_shockb3
end
function boss_shockb3()
	self.frame=FRAME_shockb3
	self.nextthink = time + 0.1
	self.think = boss_shockb4
end
function boss_shockb4()
	self.frame=FRAME_shockb4
	self.nextthink = time + 0.1
	self.think = boss_shockb5
end
function boss_shockb5()
	self.frame=FRAME_shockb5
	self.nextthink = time + 0.1
	self.think = boss_shockb6
end
function boss_shockb6()
	self.frame=FRAME_shockb6
	self.nextthink = time + 0.1
	self.think = boss_shockb7
end
function boss_shockb7()
	self.frame=FRAME_shockb1
	self.nextthink = time + 0.1
	self.think = boss_shockb8
end
function boss_shockb8()
	self.frame=FRAME_shockb2
	self.nextthink = time + 0.1
	self.think = boss_shockb9
end
function boss_shockb9()
	self.frame=FRAME_shockb3
	self.nextthink = time + 0.1
	self.think = boss_shockb10
end
function boss_shockb10()
	self.frame=FRAME_shockb4
	self.nextthink = time + 0.1
	self.think = boss_missile1
end

function boss_shockc1()
	self.frame=FRAME_shockc1
	self.nextthink = time + 0.1
	self.think = boss_shockc2
end
function boss_shockc2()
	self.frame=FRAME_shockc2
	self.nextthink = time + 0.1
	self.think = boss_shockc3
end
function boss_shockc3()
	self.frame=FRAME_shockc3
	self.nextthink = time + 0.1
	self.think = boss_shockc4
end
function boss_shockc4()
	self.frame=FRAME_shockc4
	self.nextthink = time + 0.1
	self.think = boss_shockc5
end
function boss_shockc5()
	self.frame=FRAME_shockc5
	self.nextthink = time + 0.1
	self.think = boss_shockc6
end
function boss_shockc6()
	self.frame=FRAME_shockc6
	self.nextthink = time + 0.1
	self.think = boss_shockc7
end
function boss_shockc7()
	self.frame=FRAME_shockc7
	self.nextthink = time + 0.1
	self.think = boss_shockc8
end
function boss_shockc8()
	self.frame=FRAME_shockc8
	self.nextthink = time + 0.1
	self.think = boss_shockc9
end
function boss_shockc9()
	self.frame=FRAME_shockc9
	self.nextthink = time + 0.1
	self.think = boss_shockc10
end
function boss_shockc10()
	self.frame=FRAME_shockc10
	self.nextthink = time + 0.1
	self.think = boss_death1
end

function boss_death1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = boss_death2
sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM)
end
function boss_death2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = boss_death3
end
function boss_death3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = boss_death4
end
function boss_death4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = boss_death5
end
function boss_death5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = boss_death6
end
function boss_death6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = boss_death7
end
function boss_death7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = boss_death8
end
function boss_death8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = boss_death9
end
function boss_death9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = boss_death10
	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM)
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)
end

function boss_death10()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = boss_death10
	killed_monsters = killed_monsters + 1
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER)	-- FIXME: reliable broadcast
	SUB_UseTargets ()
	remove (self)
end

function boss_missile(p) -- vector
	local offang; -- vector
	local org, vec, d; -- vector
	local t; -- float

	offang = vectoangles (self.enemy.origin - self.origin)	
	makevectors (offang)

	org = self.origin + p.x*qc.v_forward + p.y*qc.v_right + p.z*vec3(0, 0, 1)
	
-- lead the player on hard mode
	if skill > 1 then -- TODO check condition
		t = vlen(self.enemy.origin - org) / 300
		vec = self.enemy.velocity
		vec.z = 0
		d = self.enemy.origin + t * vec		
	else
		d = self.enemy.origin
	end
	
	vec = normalize (d - org)

	launch_spike (org, vec)
	setmodel (newmis, "progs/lavaball.mdl")
	newmis.avelocity = vec3(200, 100, 300)
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN)		
	newmis.velocity = vec*300
	newmis.touch = T_MissileTouch -- rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM)

-- check for dead enemy
	if self.enemy.health <= 0 then -- TODO check condition
		boss_idle1 ()
        end
end


function boss_awake()
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP
	self.takedamage = DAMAGE_NO
	
	setmodel (self, "progs/boss.mdl")
	setsize (self, vec3(-128, -128, -24), vec3(128, 128, 256))
	
	if skill == 0 then -- TODO check condition
		self.health = 1
	else
		self.health = 3
        end

	self.enemy = activator

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)

	self.yaw_speed = 20
	boss_rise1 ()
end


--/*QUAKED monster_boss (1 0 0) (-128 -128 -24) (128 128 256)
--*/
function monster_boss()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model ("progs/boss.mdl")
	precache_model ("progs/lavaball.mdl")

	precache_sound ("weapons/rocket1i.wav")
	precache_sound ("boss1/out1.wav")
	precache_sound ("boss1/sight1.wav")
	precache_sound ("misc/power.wav")
	precache_sound ("boss1/throw.wav")
	precache_sound ("boss1/pain.wav")
	precache_sound ("boss1/death.wav")

	qc.total_monsters = qc.total_monsters + 1

	self.use = boss_awake
end

--===========================================================================

local le1, le2
local lightning_end = 0

function lightning_fire()
	local p1, p2; -- vector
	
	if time >= lightning_end then -- TODO check condition
		self = le1
		door_go_down ()
		self = le2
		door_go_down ()
		return
	end
	
	p1 = (le1.mins + le1.maxs) * 0.5
	p1.z = le1.absmin.z - 16
	
	p2 = (le2.mins + le2.maxs) * 0.5
	p2.z = le2.absmin.z - 16
	
	-- compensate for length of bolt
	p2 = p2 - normalize(p2-p1)*100

	self.nextthink = time + 0.1
	self.think = lightning_fire

	WriteByte (MSG_ALL, SVC_TEMPENTITY)
	WriteByte (MSG_ALL, TE_LIGHTNING3)
	WriteEntity (MSG_ALL, world)
	WriteCoord (MSG_ALL, p1.x)
	WriteCoord (MSG_ALL, p1.y)
	WriteCoord (MSG_ALL, p1.z)
	WriteCoord (MSG_ALL, p2.x)
	WriteCoord (MSG_ALL, p2.y)
	WriteCoord (MSG_ALL, p2.z)
end

function lightning_use()
	if lightning_end >= time + 1 then -- TODO check condition
		return
        end

	le1 = find( world, "target", "lightning")
	le2 = find( le1, "target", "lightning")
	if  le1 == world or  le2 == world then -- TODO check condition
		dprint ("missing lightning targets\n")
		return
	end
	
	if (le1.state ~= STATE_TOP  and  le1.state ~= STATE_BOTTOM) or  (le2.state ~= STATE_TOP  and  le2.state ~= STATE_BOTTOM) or  (le1.state ~= le2.state) then
--		dprint ("not aligned\n")
		return
	end

-- don't let the electrodes go back up until the bolt is done
	le1.nextthink = -1
	le2.nextthink = -1
	lightning_end = time + 1

	sound (self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM)
	lightning_fire ()		

-- advance the boss pain if down
	self = find (world, "classname", "monster_boss")
	if  self == world then -- TODO check condition
		return
        end
	self.enemy = activator
	if le1.state == STATE_TOP  and  self.health > 0 then -- TODO check condition
		sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM)
		self.health = self.health - 1
		if self.health >= 2 then -- TODO check condition
			boss_shocka1()
		elseif self.health == 1 then -- TODO check condition
			boss_shockb1()
		elseif self.health == 0 then -- TODO check condition
			boss_shockc1()
                end
	end
end


--/*QUAKED event_lightning (0 1 1) (-16 -16 -16) (16 16 16)
--Just for boss level.
--*/
function event_lightning()
	self.use = lightning_use
end


