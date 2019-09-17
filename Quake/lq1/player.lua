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
--PLAYER
--
--==============================================================================
--*/


--
-- running
--
local FRAME_axrun1,FRAME_axrun2,FRAME_axrun3,FRAME_axrun4,FRAME_axrun5,FRAME_axrun6 = 0,1,2,3,4,5

local FRAME_rockrun1,FRAME_rockrun2,FRAME_rockrun3,FRAME_rockrun4,FRAME_rockrun5,FRAME_rockrun6 = 6,7,8,9,10,11

--
-- standing
--
local FRAME_stand1,FRAME_stand2,FRAME_stand3,FRAME_stand4,FRAME_stand5 = 12,13,14,15,16

local FRAME_axstnd1,FRAME_axstnd2,FRAME_axstnd3,FRAME_axstnd4,FRAME_axstnd5,FRAME_axstnd6 = 17,18,19,20,21,22
local FRAME_axstnd7,FRAME_axstnd8,FRAME_axstnd9,FRAME_axstnd10,FRAME_axstnd11,FRAME_axstnd12 = 23,24,25,26,27,28


--
-- pain
--
local FRAME_axpain1,FRAME_axpain2,FRAME_axpain3,FRAME_axpain4,FRAME_axpain5,FRAME_axpain6 = 29,30,31,32,33,34

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6 = 35,36,37,38,39,40


--
-- death
--

local FRAME_axdeth1,FRAME_axdeth2,FRAME_axdeth3,FRAME_axdeth4,FRAME_axdeth5,FRAME_axdeth6 = 41,42,43,44,45,46
local FRAME_axdeth7,FRAME_axdeth8,FRAME_axdeth9 = 47,48,49

local FRAME_deatha1,FRAME_deatha2,FRAME_deatha3,FRAME_deatha4,FRAME_deatha5,FRAME_deatha6,FRAME_deatha7,FRAME_deatha8 = 50,51,52,53,54,55,56,57
local FRAME_deatha9,FRAME_deatha10,FRAME_deatha11 = 58,59,60

local FRAME_deathb1,FRAME_deathb2,FRAME_deathb3,FRAME_deathb4,FRAME_deathb5,FRAME_deathb6,FRAME_deathb7,FRAME_deathb8 = 61,62,63,64,65,66,67,68
local FRAME_deathb9 = 69

local FRAME_deathc1,FRAME_deathc2,FRAME_deathc3,FRAME_deathc4,FRAME_deathc5,FRAME_deathc6,FRAME_deathc7,FRAME_deathc8 = 70,71,72,73,74,75,76,77
local FRAME_deathc9,FRAME_deathc10,FRAME_deathc11,FRAME_deathc12,FRAME_deathc13,FRAME_deathc14,FRAME_deathc15 = 78,79,80,81,82,83,84

local FRAME_deathd1,FRAME_deathd2,FRAME_deathd3,FRAME_deathd4,FRAME_deathd5,FRAME_deathd6,FRAME_deathd7 = 85,86,87,88,89,90,91
local FRAME_deathd8,FRAME_deathd9 = 92,93

local FRAME_deathe1,FRAME_deathe2,FRAME_deathe3,FRAME_deathe4,FRAME_deathe5,FRAME_deathe6,FRAME_deathe7 = 94,95,96,97,98,99,100
local FRAME_deathe8,FRAME_deathe9 = 101,102

--
-- attacks
--
local FRAME_nailatt1,FRAME_nailatt2 = 103,104

local FRAME_light1,FRAME_light2 = 105,106

local FRAME_rockatt1,FRAME_rockatt2,FRAME_rockatt3,FRAME_rockatt4,FRAME_rockatt5,FRAME_rockatt6 = 107,108,109,110,111,112

local FRAME_shotatt1,FRAME_shotatt2,FRAME_shotatt3,FRAME_shotatt4,FRAME_shotatt5,FRAME_shotatt6 = 113,114,115,116,117,118

local FRAME_axatt1,FRAME_axatt2,FRAME_axatt3,FRAME_axatt4,FRAME_axatt5,FRAME_axatt6 = 119,120,121,122,123,124

local FRAME_axattb1,FRAME_axattb2,FRAME_axattb3,FRAME_axattb4,FRAME_axattb5,FRAME_axattb6 = 125,126,127,128,129,130

local FRAME_axattc1,FRAME_axattc2,FRAME_axattc3,FRAME_axattc4,FRAME_axattc5,FRAME_axattc6 = 131,132,133,134,135,136

local FRAME_axattd1,FRAME_axattd2,FRAME_axattd3,FRAME_axattd4,FRAME_axattd5,FRAME_axattd6 = 137,138,139,140,141,142


--/*
--==============================================================================
--PLAYER
--==============================================================================
--*/


function player_stand1()
	self.frame=FRAME_axstnd1
	self.nextthink = time + 0.1
	self.think = player_stand1
	self.weaponframe=0
	if self.velocity.x ~= 0 or self.velocity.y ~= 0 then -- TODO check condition
		self.walkframe=0
		player_run()
		return
	end

	if self.weapon == IT_AXE then -- TODO check condition
		if self.walkframe >= 12 then -- TODO check condition
			self.walkframe = 0
                end
		self.frame = FRAME_axstnd1 + self.walkframe
	else
		if self.walkframe >= 5 then -- TODO check condition
			self.walkframe = 0
                end
		self.frame = FRAME_stand1 + self.walkframe
	end
	self.walkframe = self.walkframe + 1	
end

function player_run()
	self.frame=FRAME_rockrun1
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=0
	if self.velocity.x == 0 and self.velocity.y == 0 then -- TODO check condition
		self.walkframe=0
		player_stand1()
		return
	end

	if self.weapon == IT_AXE then -- TODO check condition
		if self.walkframe == 6 then -- TODO check condition
			self.walkframe = 0
                end
		self.frame = FRAME_axrun1 + self.walkframe
	else
		if self.walkframe == 6 then -- TODO check condition
			self.walkframe = 0
                end
		self.frame = self.frame + self.walkframe
	end
	self.walkframe = self.walkframe + 1
end


function player_shot1()
	self.frame=FRAME_shotatt1
	self.nextthink = time + 0.1
	self.think = player_shot2
	self.weaponframe=1
	self.effects = self.effects | EF_MUZZLEFLASH
end
function player_shot2()
	self.frame=FRAME_shotatt2
	self.nextthink = time + 0.1
	self.think = player_shot3
	self.weaponframe=2
end
function player_shot3()
	self.frame=FRAME_shotatt3
	self.nextthink = time + 0.1
	self.think = player_shot4
	self.weaponframe=3
end
function player_shot4()
	self.frame=FRAME_shotatt4
	self.nextthink = time + 0.1
	self.think = player_shot5
	self.weaponframe=4
end
function player_shot5()
	self.frame=FRAME_shotatt5
	self.nextthink = time + 0.1
	self.think = player_shot6
	self.weaponframe=5
end
function player_shot6()
	self.frame=FRAME_shotatt6
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=6
end

function player_axe1()
	self.frame=FRAME_axatt1
	self.nextthink = time + 0.1
	self.think = player_axe2
	self.weaponframe=1
end
function player_axe2()
	self.frame=FRAME_axatt2
	self.nextthink = time + 0.1
	self.think = player_axe3
	self.weaponframe=2
end
function player_axe3()
	self.frame=FRAME_axatt3
	self.nextthink = time + 0.1
	self.think = player_axe4
	self.weaponframe=3
	W_FireAxe()
end
function player_axe4()
	self.frame=FRAME_axatt4
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=4
end

function player_axeb1()
	self.frame=FRAME_axattb1
	self.nextthink = time + 0.1
	self.think = player_axeb2
	self.weaponframe=5
end
function player_axeb2()
	self.frame=FRAME_axattb2
	self.nextthink = time + 0.1
	self.think = player_axeb3
	self.weaponframe=6
end
function player_axeb3()
	self.frame=FRAME_axattb3
	self.nextthink = time + 0.1
	self.think = player_axeb4
	self.weaponframe=7
	W_FireAxe()
end
function player_axeb4()
	self.frame=FRAME_axattb4
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=8
end

function player_axec1()
	self.frame=FRAME_axattc1
	self.nextthink = time + 0.1
	self.think = player_axec2
	self.weaponframe=1
end
function player_axec2()
	self.frame=FRAME_axattc2
	self.nextthink = time + 0.1
	self.think = player_axec3
	self.weaponframe=2
end
function player_axec3()
	self.frame=FRAME_axattc3
	self.nextthink = time + 0.1
	self.think = player_axec4
	self.weaponframe=3
	W_FireAxe()
end
function player_axec4()
	self.frame=FRAME_axattc4
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=4
end

function player_axed1()
	self.frame=FRAME_axattd1
	self.nextthink = time + 0.1
	self.think = player_axed2
	self.weaponframe=5
end
function player_axed2()
	self.frame=FRAME_axattd2
	self.nextthink = time + 0.1
	self.think = player_axed3
	self.weaponframe=6
end
function player_axed3()
	self.frame=FRAME_axattd3
	self.nextthink = time + 0.1
	self.think = player_axed4
	self.weaponframe=7
	W_FireAxe()
end
function player_axed4()
	self.frame=FRAME_axattd4
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=8
end


--============================================================================

function player_nail1()
	self.frame=FRAME_nailatt1
	self.nextthink = time + 0.1
	self.think = player_nail2
	self.effects = self.effects | EF_MUZZLEFLASH

	if self.button0 == 0 then -- TODO check condition
                player_run ()
                return
        end
	self.weaponframe = self.weaponframe + 1
	if self.weaponframe == 9 then -- TODO check condition
		self.weaponframe = 1
        end
	SuperDamageSound()
	W_FireSpikes (4)
	self.attack_finished = time + 0.2
end
function player_nail2()
	self.frame=FRAME_nailatt2
	self.nextthink = time + 0.1
	self.think = player_nail1
	self.effects = self.effects | EF_MUZZLEFLASH

	if  self.button0 == 0 then -- TODO check condition
                player_run ()
                return
        end
	self.weaponframe = self.weaponframe + 1
	if self.weaponframe == 9 then -- TODO check condition
		self.weaponframe = 1
end
	SuperDamageSound()
	W_FireSpikes (-4)
	self.attack_finished = time + 0.2
end

--============================================================================

function player_light1()
	self.frame=FRAME_light1
	self.nextthink = time + 0.1
	self.think = player_light2
	self.effects = self.effects | EF_MUZZLEFLASH

	if  self.button0 == 0 then -- TODO check condition
                player_run ()
                return
        end
	self.weaponframe = self.weaponframe + 1
	if self.weaponframe == 5 then -- TODO check condition
		self.weaponframe = 1
        end
	SuperDamageSound()
	W_FireLightning()
	self.attack_finished = time + 0.2
end
function player_light2()
	self.frame=FRAME_light2
	self.nextthink = time + 0.1
	self.think = player_light1
	self.effects = self.effects | EF_MUZZLEFLASH

	if self.button0 == 0 then -- TODO check condition
                player_run ()
                return
        end
	self.weaponframe = self.weaponframe + 1
	if self.weaponframe == 5 then -- TODO check condition
		self.weaponframe = 1
        end
	SuperDamageSound()
	W_FireLightning()
	self.attack_finished = time + 0.2
end

--============================================================================


function player_rocket1()
	self.frame=FRAME_rockatt1
	self.nextthink = time + 0.1
	self.think = player_rocket2
end
function player_rocket2()
	self.frame=FRAME_rockatt2
	self.nextthink = time + 0.1
	self.think = player_rocket3
	self.weaponframe=2
end
function player_rocket3()
	self.frame=FRAME_rockatt3
	self.nextthink = time + 0.1
	self.think = player_rocket4
	self.weaponframe=3
end
function player_rocket4()
	self.frame=FRAME_rockatt4
	self.nextthink = time + 0.1
	self.think = player_rocket5
	self.weaponframe=4
end
function player_rocket5()
	self.frame=FRAME_rockatt5
	self.nextthink = time + 0.1
	self.think = player_rocket6
	self.weaponframe=5
end
function player_rocket6()
	self.frame=FRAME_rockatt6
	self.nextthink = time + 0.1
	self.think = player_run
	self.weaponframe=6
end

function PainSound()
        local rs; -- float

	if self.health < 0 then -- TODO check condition
		return
        end

	if damage_attacker.classname == "teledeath" then -- TODO check condition
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE)
		return
	end

-- water pain sounds
	if self.watertype == CONTENT_WATER  and  self.waterlevel == 3 then -- TODO check condition
		DeathBubbles(1)
		if random() > 0.5 then -- TODO check condition
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM)
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM)
                end
		return
	end

-- slime pain sounds
	if self.watertype == CONTENT_SLIME then -- TODO check condition
-- FIX ME	put in some steam here
		if random() > 0.5 then -- TODO check condition
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM)
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM)
                end
		return
	end

	if self.watertype == CONTENT_LAVA then -- TODO check condition
		if random() > 0.5 then -- TODO check condition
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM)
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM)
                end
		return
	end

	if self.pain_finished > time then -- TODO check condition
		self.axhitme = 0
		return
	end
	self.pain_finished = time + 0.5

-- don't make multiple pain sounds right after each other

-- ax pain sound
	if self.axhitme == 1 then -- TODO check condition
		self.axhitme = 0
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM)
		return
	end
	

	rs = rint((random() * 5) + 1)

	self.noise = ""
	if rs == 1 then -- TODO check condition
		self.noise = "player/pain1.wav"
	elseif rs == 2 then -- TODO check condition
		self.noise = "player/pain2.wav"
	elseif rs == 3 then -- TODO check condition
		self.noise = "player/pain3.wav"
	elseif rs == 4 then -- TODO check condition
		self.noise = "player/pain4.wav"
	elseif rs == 5 then -- TODO check condition
		self.noise = "player/pain5.wav"
	else
		self.noise = "player/pain6.wav"
        end

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM)
	return
end

function player_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = player_pain2
	PainSound()
	self.weaponframe=0
end
function player_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = player_pain3
end
function player_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = player_pain4
end
function player_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = player_pain5
end
function player_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = player_pain6
end
function player_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = player_run
end

function player_axpain1()
	self.frame=FRAME_axpain1
	self.nextthink = time + 0.1
	self.think = player_axpain2
	PainSound()
	self.weaponframe=0
end
function player_axpain2()
	self.frame=FRAME_axpain2
	self.nextthink = time + 0.1
	self.think = player_axpain3
end
function player_axpain3()
	self.frame=FRAME_axpain3
	self.nextthink = time + 0.1
	self.think = player_axpain4
end
function player_axpain4()
	self.frame=FRAME_axpain4
	self.nextthink = time + 0.1
	self.think = player_axpain5
end
function player_axpain5()
	self.frame=FRAME_axpain5
	self.nextthink = time + 0.1
	self.think = player_axpain6
end
function player_axpain6()
	self.frame=FRAME_axpain6
	self.nextthink = time + 0.1
	self.think = player_run
end

function player_pain()
	if self.weaponframe ~= 0 then -- TODO check condition
		return
        end

	if self.invisible_finished > time then -- TODO check condition
		return		-- eyes don't have pain frames
        end

	if self.weapon == IT_AXE then -- TODO check condition
		player_axpain1 ()
	else
		player_pain1 ()
        end
end


function DeathBubblesSpawn()
        local bubble; -- entity
	if self.owner.waterlevel ~= 3 then -- TODO check condition
		return
        end
	bubble = spawn()
	setmodel (bubble, "progs/s_bubble.spr")
	setorigin (bubble, self.owner.origin + vec3(0, 0, 24))
	bubble.movetype = MOVETYPE_NOCLIP
	bubble.solid = SOLID_NOT
	bubble.velocity = vec3(0, 0, 15)
	bubble.nextthink = time + 0.5
	bubble.think = bubble_bob
	bubble.classname = "bubble"
	bubble.frame = 0
	bubble.cnt = 0
	setsize (bubble, vec3(-8, -8, -8), vec3(8, 8, 8))
	self.nextthink = time + 0.1
	self.think = DeathBubblesSpawn
	self.air_finished = self.air_finished + 1
	if self.air_finished >= self.bubble_count then -- TODO check condition
		remove(self)
        end
end

function DeathBubbles(num_bubbles) -- float
        local bubble_spawner; -- entity
	
	bubble_spawner = spawn()
	setorigin (bubble_spawner, self.origin)
	bubble_spawner.movetype = MOVETYPE_NONE
	bubble_spawner.solid = SOLID_NOT
	bubble_spawner.nextthink = time + 0.1
	bubble_spawner.think = DeathBubblesSpawn
	bubble_spawner.air_finished = 0
	bubble_spawner.owner = self
	bubble_spawner.bubble_count = num_bubbles
	return
end


function DeathSound()
        local rs; -- float

	-- water death sounds
	if self.waterlevel == 3 then -- TODO check condition
		DeathBubbles(20)
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE)
		return
	end
	
	rs = rint ((random() * 4) + 1)
	if rs == 1 then -- TODO check condition
		self.noise = "player/death1.wav"
        end
	if rs == 2 then -- TODO check condition
		self.noise = "player/death2.wav"
        end
	if rs == 3 then -- TODO check condition
		self.noise = "player/death3.wav"
        end
	if rs == 4 then -- TODO check condition
		self.noise = "player/death4.wav"
        end
	if rs == 5 then -- TODO check condition
		self.noise = "player/death5.wav"
        end

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE)
	return
end


function PlayerDead()
	self.nextthink = -1
-- allow respawn after a certain time
	self.deadflag = DEAD_DEAD
end

function VelocityForDamage(dm) -- float
	local v = vec3() -- vector

	v.x = 100 * crandom()
	v.y = 100 * crandom()
	v.z = 200 + 100 * random()

	if dm > -50 then -- TODO check condition
--		dprint ("level 1\n")
		v = v * 0.7
	elseif dm > -200 then -- TODO check condition
--		dprint ("level 3\n")
		v = v * 2
	else
		v = v * 10
        end

	return v
end

function ThrowGib(gibname, dm) -- string, float
	local new; -- entity

	new = spawn()
	new.origin = self.origin
	setmodel (new, gibname)
	setsize (new, vec3(0, 0, 0), vec3(0, 0, 0))
	new.velocity = VelocityForDamage (dm)
	new.movetype = MOVETYPE_BOUNCE
	new.solid = SOLID_NOT
	new.avelocity.x = random()*600
	new.avelocity.y = random()*600
	new.avelocity.z = random()*600
	new.think = SUB_Remove
	new.ltime = time
	new.nextthink = time + 10 + random()*10
	new.frame = 0
	new.flags = 0
end

function ThrowHead(gibname, dm) -- string, float
	setmodel (self, gibname)
	self.frame = 0
	self.nextthink = -1
	self.movetype = MOVETYPE_BOUNCE
	self.takedamage = DAMAGE_NO
	self.solid = SOLID_NOT
	self.view_ofs = vec3(0, 0, 8)
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	self.velocity = VelocityForDamage (dm)
	self.origin.z = self.origin.z - 24
	self.flags = self.flags - (self.flags & FL_ONGROUND)
	self.avelocity = crandom() * vec3(0, 600, 0)
end


function GibPlayer()
	ThrowHead ("progs/h_player.mdl", self.health)
	ThrowGib ("progs/gib1.mdl", self.health)
	ThrowGib ("progs/gib2.mdl", self.health)
	ThrowGib ("progs/gib3.mdl", self.health)

	self.deadflag = DEAD_DEAD

	if damage_attacker.classname == "teledeath" then -- TODO check condition
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE)
		return
	end

	if damage_attacker.classname == "teledeath2" then -- TODO check condition
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE)
		return
	end
		
	if random() < 0.5 then -- TODO check condition
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE)
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE)
end
end

function PlayerDie()
	local i; -- float
	
	self.items = self.items - (self.items & IT_INVISIBILITY)
	self.invisible_finished = 0	-- don't die as eyes
	self.invincible_finished = 0
	self.super_damage_finished = 0
	self.radsuit_finished = 0
	self.modelindex = modelindex_player	-- don't use eyes

	if deathmatch ~= 0 or coop ~= 0 then -- TODO check condition
		DropBackpack()
        end
	
	self.weaponmodel=""
	self.view_ofs = vec3(0, 0, -8)
	self.deadflag = DEAD_DYING
	self.solid = SOLID_NOT
	self.flags = self.flags - (self.flags & FL_ONGROUND)
	self.movetype = MOVETYPE_TOSS
	if self.velocity.z < 10 then -- TODO check condition
		self.velocity.z = self.velocity.z + random()*300
        end

	if self.health < -40 then -- TODO check condition
		GibPlayer ()
		return
	end

	DeathSound()
	
	self.angles.x = 0
	self.angles.z = 0
	
	if self.weapon == IT_AXE then -- TODO check condition
		player_die_ax1 ()
		return
	end
	
	i = cvar("temp1")
	if  not i then -- TODO check condition
		i = 1 + floor(random()*6)
        end
	
	if i == 1 then -- TODO check condition
		player_diea1()
	elseif i == 2 then -- TODO check condition
		player_dieb1()
	elseif i == 3 then -- TODO check condition
		player_diec1()
	elseif i == 4 then -- TODO check condition
		player_died1()
	else
		player_diee1()
        end

end

function set_suicide_frame()
	if self.model ~= "progs/player.mdl" then -- TODO check condition
		return	-- allready gibbed
        end
	self.frame = FRAME_deatha11
	self.solid = SOLID_NOT
	self.movetype = MOVETYPE_TOSS
	self.deadflag = DEAD_DEAD
	self.nextthink = -1
end


function player_diea1()
	self.frame=FRAME_deatha1
	self.nextthink = time + 0.1
	self.think = player_diea2
end
function player_diea2()
	self.frame=FRAME_deatha2
	self.nextthink = time + 0.1
	self.think = player_diea3
end
function player_diea3()
	self.frame=FRAME_deatha3
	self.nextthink = time + 0.1
	self.think = player_diea4
end
function player_diea4()
	self.frame=FRAME_deatha4
	self.nextthink = time + 0.1
	self.think = player_diea5
end
function player_diea5()
	self.frame=FRAME_deatha5
	self.nextthink = time + 0.1
	self.think = player_diea6
end
function player_diea6()
	self.frame=FRAME_deatha6
	self.nextthink = time + 0.1
	self.think = player_diea7
end
function player_diea7()
	self.frame=FRAME_deatha7
	self.nextthink = time + 0.1
	self.think = player_diea8
end
function player_diea8()
	self.frame=FRAME_deatha8
	self.nextthink = time + 0.1
	self.think = player_diea9
end
function player_diea9()
	self.frame=FRAME_deatha9
	self.nextthink = time + 0.1
	self.think = player_diea10
end
function player_diea10()
	self.frame=FRAME_deatha10
	self.nextthink = time + 0.1
	self.think = player_diea11
end
function player_diea11()
	self.frame=FRAME_deatha11
	self.nextthink = time + 0.1
	self.think = player_diea11
	PlayerDead()
end

function player_dieb1()
	self.frame=FRAME_deathb1
	self.nextthink = time + 0.1
	self.think = player_dieb2
end
function player_dieb2()
	self.frame=FRAME_deathb2
	self.nextthink = time + 0.1
	self.think = player_dieb3
end
function player_dieb3()
	self.frame=FRAME_deathb3
	self.nextthink = time + 0.1
	self.think = player_dieb4
end
function player_dieb4()
	self.frame=FRAME_deathb4
	self.nextthink = time + 0.1
	self.think = player_dieb5
end
function player_dieb5()
	self.frame=FRAME_deathb5
	self.nextthink = time + 0.1
	self.think = player_dieb6
end
function player_dieb6()
	self.frame=FRAME_deathb6
	self.nextthink = time + 0.1
	self.think = player_dieb7
end
function player_dieb7()
	self.frame=FRAME_deathb7
	self.nextthink = time + 0.1
	self.think = player_dieb8
end
function player_dieb8()
	self.frame=FRAME_deathb8
	self.nextthink = time + 0.1
	self.think = player_dieb9
end
function player_dieb9()
	self.frame=FRAME_deathb9
	self.nextthink = time + 0.1
	self.think = player_dieb9
	PlayerDead()
end

function player_diec1()
	self.frame=FRAME_deathc1
	self.nextthink = time + 0.1
	self.think = player_diec2
end
function player_diec2()
	self.frame=FRAME_deathc2
	self.nextthink = time + 0.1
	self.think = player_diec3
end
function player_diec3()
	self.frame=FRAME_deathc3
	self.nextthink = time + 0.1
	self.think = player_diec4
end
function player_diec4()
	self.frame=FRAME_deathc4
	self.nextthink = time + 0.1
	self.think = player_diec5
end
function player_diec5()
	self.frame=FRAME_deathc5
	self.nextthink = time + 0.1
	self.think = player_diec6
end
function player_diec6()
	self.frame=FRAME_deathc6
	self.nextthink = time + 0.1
	self.think = player_diec7
end
function player_diec7()
	self.frame=FRAME_deathc7
	self.nextthink = time + 0.1
	self.think = player_diec8
end
function player_diec8()
	self.frame=FRAME_deathc8
	self.nextthink = time + 0.1
	self.think = player_diec9
end
function player_diec9()
	self.frame=FRAME_deathc9
	self.nextthink = time + 0.1
	self.think = player_diec10
end
function player_diec10()
	self.frame=FRAME_deathc10
	self.nextthink = time + 0.1
	self.think = player_diec11
end
function player_diec11()
	self.frame=FRAME_deathc11
	self.nextthink = time + 0.1
	self.think = player_diec12
end
function player_diec12()
	self.frame=FRAME_deathc12
	self.nextthink = time + 0.1
	self.think = player_diec13
end
function player_diec13()
	self.frame=FRAME_deathc13
	self.nextthink = time + 0.1
	self.think = player_diec14
end
function player_diec14()
	self.frame=FRAME_deathc14
	self.nextthink = time + 0.1
	self.think = player_diec15
end
function player_diec15()
	self.frame=FRAME_deathc15
	self.nextthink = time + 0.1
	self.think = player_diec15
	PlayerDead()
end

function player_died1()
	self.frame=FRAME_deathd1
	self.nextthink = time + 0.1
	self.think = player_died2
end
function player_died2()
	self.frame=FRAME_deathd2
	self.nextthink = time + 0.1
	self.think = player_died3
end
function player_died3()
	self.frame=FRAME_deathd3
	self.nextthink = time + 0.1
	self.think = player_died4
end
function player_died4()
	self.frame=FRAME_deathd4
	self.nextthink = time + 0.1
	self.think = player_died5
end
function player_died5()
	self.frame=FRAME_deathd5
	self.nextthink = time + 0.1
	self.think = player_died6
end
function player_died6()
	self.frame=FRAME_deathd6
	self.nextthink = time + 0.1
	self.think = player_died7
end
function player_died7()
	self.frame=FRAME_deathd7
	self.nextthink = time + 0.1
	self.think = player_died8
end
function player_died8()
	self.frame=FRAME_deathd8
	self.nextthink = time + 0.1
	self.think = player_died9
end
function player_died9()
	self.frame=FRAME_deathd9
	self.nextthink = time + 0.1
	self.think = player_died9
	PlayerDead()
end

function player_diee1()
	self.frame=FRAME_deathe1
	self.nextthink = time + 0.1
	self.think = player_diee2
end
function player_diee2()
	self.frame=FRAME_deathe2
	self.nextthink = time + 0.1
	self.think = player_diee3
end
function player_diee3()
	self.frame=FRAME_deathe3
	self.nextthink = time + 0.1
	self.think = player_diee4
end
function player_diee4()
	self.frame=FRAME_deathe4
	self.nextthink = time + 0.1
	self.think = player_diee5
end
function player_diee5()
	self.frame=FRAME_deathe5
	self.nextthink = time + 0.1
	self.think = player_diee6
end
function player_diee6()
	self.frame=FRAME_deathe6
	self.nextthink = time + 0.1
	self.think = player_diee7
end
function player_diee7()
	self.frame=FRAME_deathe7
	self.nextthink = time + 0.1
	self.think = player_diee8
end
function player_diee8()
	self.frame=FRAME_deathe8
	self.nextthink = time + 0.1
	self.think = player_diee9
end
function player_diee9()
	self.frame=FRAME_deathe9
	self.nextthink = time + 0.1
	self.think = player_diee9
	PlayerDead()
end

function player_die_ax1()
	self.frame=FRAME_axdeth1
	self.nextthink = time + 0.1
	self.think = player_die_ax2
end
function player_die_ax2()
	self.frame=FRAME_axdeth2
	self.nextthink = time + 0.1
	self.think = player_die_ax3
end
function player_die_ax3()
	self.frame=FRAME_axdeth3
	self.nextthink = time + 0.1
	self.think = player_die_ax4
end
function player_die_ax4()
	self.frame=FRAME_axdeth4
	self.nextthink = time + 0.1
	self.think = player_die_ax5
end
function player_die_ax5()
	self.frame=FRAME_axdeth5
	self.nextthink = time + 0.1
	self.think = player_die_ax6
end
function player_die_ax6()
	self.frame=FRAME_axdeth6
	self.nextthink = time + 0.1
	self.think = player_die_ax7
end
function player_die_ax7()
	self.frame=FRAME_axdeth7
	self.nextthink = time + 0.1
	self.think = player_die_ax8
end
function player_die_ax8()
	self.frame=FRAME_axdeth8
	self.nextthink = time + 0.1
	self.think = player_die_ax9
end
function player_die_ax9()
	self.frame=FRAME_axdeth9
	self.nextthink = time + 0.1
	self.think = player_die_ax9
	PlayerDead()
end
