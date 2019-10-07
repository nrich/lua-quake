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

-- prototypes

--require('defs')

modelindex_eyes, modelindex_player = 0,0-- float

--/*
--=============================================================================
--
--				LEVEL CHANGING / INTERMISSION
--
--=============================================================================
--*/

intermission_running = 0 -- float
intermission_exittime = 0 -- float

--/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
--This is the camera point for the intermission.
--Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
--*/
function info_intermission()
end


qc.SetChangeParms = function()
-- remove items
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) )
	
-- cap super health
	if self.health > 100 then -- TODO check condition
		self.health = 100
        end
	if self.health < 50 then -- TODO check condition
		self.health = 50
        end
	qc.parm1 = self.items
	qc.parm2 = self.health
	qc.parm3 = self.armorvalue
	if self.ammo_shells < 25 then -- TODO check condition
		qc.parm4 = 25
	else
		qc.parm4 = self.ammo_shells
        end
	qc.parm5 = self.ammo_nails
	qc.parm6 = self.ammo_rockets
	qc.parm7 = self.ammo_cells
	qc.parm8 = self.weapon
	qc.parm9 = self.armortype * 100
end

qc.SetNewParms = function()
	qc.parm1 = IT_SHOTGUN | IT_AXE
	qc.parm2 = 100
	qc.parm3 = 0
	qc.parm4 = 25
	qc.parm5 = 0
	qc.parm6 = 0
	qc.parm6 = 0
	qc.parm7 = 0
	qc.parm8 = 1
	qc.parm9 = 0
end

function DecodeLevelParms()
	if serverflags ~= 0 then -- TODO check condition
		if world.model == "maps/start.bsp" then -- TODO check condition
			qc.SetNewParms ()		-- take away all stuff on starting new episode
                end
	end
	
	self.items = qc.parm1
	self.health = qc.parm2
	self.armorvalue = qc.parm3
	self.ammo_shells = qc.parm4
	self.ammo_nails = qc.parm5
	self.ammo_rockets = qc.parm6
	self.ammo_cells = qc.parm7
	self.weapon = qc.parm8
	self.armortype = qc.parm9 * 0.01
end

--/*
--============
--FindIntermission
--
--Returns the entity to view from
--============
--*/
function FindIntermission()
	local spot; -- entity
	local cyc; -- float

-- look for info_intermission first
	spot = find (world, "classname", "info_intermission")
	if spot ~= world then -- TODO check condition
		cyc = random() * 4
		while cyc > 1 do -- TODO check condition
			spot = find (spot, "classname", "info_intermission")
			if  spot == world then -- TODO check condition
				spot = find (spot, "classname", "info_intermission")
                        end
			cyc = cyc - 1
		end
		return spot
	end

-- then look for the start position
	spot = find (world, "classname", "info_player_start")
	if spot ~= world then -- TODO check condition
		return spot
        end
	
-- testinfo_player_start is only found in regioned levels
	spot = find (world, "classname", "testplayerstart")
	if spot ~= world then -- TODO check condition
		return spot
        end
	
	objerror ("FindIntermission: no spot")
end


local nextmap -- string
function GotoNextMap()
	if cvar("samelevel") ~= 0 then -- TODO check condition
		changelevel (qc.mapname)
	else
		changelevel (nextmap)
        end
end


function ExitIntermission()
-- skip any text in deathmatch
	if deathmatch ~= 0 then -- TODO check condition
		GotoNextMap ()
		return
	end
	
	intermission_exittime = time + 1
	intermission_running = intermission_running + 1

--
-- run some text if at the end of an episode
--
	if intermission_running == 2 then -- TODO check condition
		if world.model == "maps/e1m7.bsp" then -- TODO check condition
			WriteByte (MSG_ALL, SVC_CDTRACK)
			WriteByte (MSG_ALL, 2)
			WriteByte (MSG_ALL, 3)
			if  not cvar("registered") then -- TODO check condition
				WriteByte (MSG_ALL, SVC_FINALE)
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!")
			else
				WriteByte (MSG_ALL, SVC_FINALE)
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!")
			end
			return
		elseif world.model == "maps/e2m6.bsp" then -- TODO check condition
			WriteByte (MSG_ALL, SVC_CDTRACK)
			WriteByte (MSG_ALL, 2)
			WriteByte (MSG_ALL, 3)

			WriteByte (MSG_ALL, SVC_FINALE)
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.")
			return
		elseif world.model == "maps/e3m6.bsp" then -- TODO check condition
			WriteByte (MSG_ALL, SVC_CDTRACK)
			WriteByte (MSG_ALL, 2)
			WriteByte (MSG_ALL, 3)

			WriteByte (MSG_ALL, SVC_FINALE)
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.")
			return
		elseif world.model == "maps/e4m7.bsp" then -- TODO check condition
			WriteByte (MSG_ALL, SVC_CDTRACK)
			WriteByte (MSG_ALL, 2)
			WriteByte (MSG_ALL, 3)

			WriteByte (MSG_ALL, SVC_FINALE)
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.")
			return
		end

		GotoNextMap()
	end
	
	if intermission_running == 3 then -- TODO check condition
		if  cvar("registered") == 0 then -- TODO check condition
			WriteByte (MSG_ALL, SVC_SELLSCREEN)
			return
		end
		
		if  (qc.serverflags&15) == 15 then -- TODO check condition
			WriteByte (MSG_ALL, SVC_FINALE)
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.")
			return
		end
		
	end

	GotoNextMap()
end

--/*
--============
--IntermissionThink
--
--When the player presses attack or jump, change to the next level
--============
--*/
function IntermissionThink()
	if time < intermission_exittime then -- TODO check condition
		return
        end

	if  self.button0 == 0 and self.button1 == 0 and self.button2 == 0 then -- TODO check condition
		return
        end
	
	ExitIntermission ()
end

function execute_changelevel()
	local pos; -- entity

	intermission_running = 1
	
-- enforce a wait time before allowing changelevel
	if deathmatch ~= 0 then -- TODO check condition
		intermission_exittime = time + 5
	else
		intermission_exittime = time + 2
        end

	WriteByte (MSG_ALL, SVC_CDTRACK)
	WriteByte (MSG_ALL, 3)
	WriteByte (MSG_ALL, 3)
	
	pos = FindIntermission ()

	other = find (world, "classname", "player")
	while other ~= world do -- TODO check condition
		other.view_ofs = vec3(0, 0, 0)
		other.v_angle = pos.mangle
		other.angles = pos.mangle
		other.fixangle = true		-- turn this way immediately
		other.nextthink = time + 0.5
		other.takedamage = DAMAGE_NO
		other.solid = SOLID_NOT
		other.movetype = MOVETYPE_NONE
		other.modelindex = 0
		setorigin (other, pos.origin)
		other = find (other, "classname", "player")
	end

	WriteByte (MSG_ALL, SVC_INTERMISSION)
end


function changelevel_touch()
	local pos; -- entity

	if other.classname ~= "player" then -- TODO check condition
		return
        end

	if cvar("noexit") == 1 then -- TODO check condition
		T_Damage (other, self, self, 50000)
		return
	end
	bprint (other.netname)
	bprint (" exited the level\n")
	
	nextmap = self.map

	SUB_UseTargets ()

	if  (self.spawnflags & 1 == 0)  and  (deathmatch ~= 0 )  then -- TODO check condition
		GotoNextMap()
		return
	end
	
	self.touch = SUB_Null

-- we can't move people right now, because touch functions are called
-- in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel
	self.nextthink = time + 0.1
end

--/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
--When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
--*/
function trigger_changelevel()
	if self.map == "" then -- TODO check condition
		objerror ("chagnelevel trigger doesn't have map")
        end
	
	InitTrigger ()
	self.touch = changelevel_touch
end


--/*
--=============================================================================
--
--				PLAYER GAME EDGE FUNCTIONS
--
--=============================================================================
--*/


-- called by ClientKill and DeadThink
function respawn()
	if coop ~= 0 then -- TODO check condition
		-- make a copy of the dead body for appearances sake
		CopyToBodyQue (self)
		-- get the spawn qc.parms as they were at level start
		setspawnqc.parms (self)
		-- respawn		
		PutClientInServer ()
	elseif deathmatch ~= 0 then -- TODO check condition
		-- make a copy of the dead body for appearances sake
		CopyToBodyQue (self)
		-- set default spawn qc.parms
		SetNewParms ()
		-- respawn		
		PutClientInServer ()
	else
		localcmd ("restart\n")
	end
end


--/*
--============
--ClientKill
--
--Player entered the suicide command
--============
--*/
qc.ClientKill = function()
	bprint (self.netname)
	bprint (" suicides\n")
	set_suicide_frame ()
	self.modelindex = modelindex_player
	self.frags = self.frags - 2	-- extra penalty
	respawn ()
end

function CheckSpawnPoint(v) -- vector
	return false
end

--/*
--============
--SelectSpawnPoint
--
--Returns the entity to spawn at
--============
--*/
local lastspawn = qc.world
function SelectSpawnPoint()
	local spot; -- entity
-- testinfo_player_start is only found in regioned levels
	spot = find (world, "classname", "testplayerstart")
	if spot ~= world then -- TODO check condition
		return spot
        end
		
-- choose a info_player_deathmatch point
	if coop ~= 0 then -- TODO check condition
		lastspawn = find(lastspawn, "classname", "info_player_coop")
		if lastspawn == world then -- TODO check condition
			lastspawn = find (lastspawn, "classname", "info_player_start")
                end
		if lastspawn ~= world then -- TODO check condition
			return lastspawn
                end
	elseif deathmatch ~= 0 then -- TODO check condition
		lastspawn = find(lastspawn, "classname", "info_player_deathmatch")
		if lastspawn == world then -- TODO check condition
			lastspawn = find (lastspawn, "classname", "info_player_deathmatch")
                end
		if lastspawn ~= world then -- TODO check condition
			return lastspawn
                end
	end
	if qc.serverflags ~= 0 then -- TODO check condition
		spot = find (world, "classname", "info_player_start2")
		if spot ~= world then -- TODO check condition
			return spot
                end
	end
	spot = find (world, "classname", "info_player_start")
	if  spot == world then -- TODO check condition
		error ("PutClientInServer: no info_player_start on level")
        end
	
	return spot
end

--/*
--===========
--PutClientInServer
--
--called each time a player is spawned
--============
--*/


qc.PutClientInServer = function()
	local spot; -- entity

	self.classname = "player"
	self.health = 100
	self.takedamage = DAMAGE_AIM
	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_WALK
	self.show_hostile = 0
	self.max_health = 100
	self.flags = FL_CLIENT
	self.air_finished = time + 12
	self.dmg = 2   		-- initial water damage
	self.super_damage_finished = 0
	self.radsuit_finished = 0
	self.invisible_finished = 0
	self.invincible_finished = 0
	self.effects = 0
	self.invincible_time = 0

	DecodeLevelParms ()
	
	W_SetCurrentAmmo ()

	self.attack_finished = time
	self.th_pain = player_pain
	self.th_die = PlayerDie
	
	self.deadflag = DEAD_NO
-- paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0
	
	spot = SelectSpawnPoint ()

	self.origin = spot.origin + vec3(0, 0, 1)
	self.angles = spot.angles
	self.fixangle = true		-- turn this way immediately

-- oh, this is a hack not 
	setmodel (self, "progs/eyes.mdl")
	modelindex_eyes = self.modelindex

	setmodel (self, "progs/player.mdl")
	modelindex_player = self.modelindex

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX)
	
	self.view_ofs = vec3(0, 0, 22)

	player_stand1 ()
	
	if deathmatch ~= 0 or coop ~= 0 then -- TODO check condition
		makevectors(self.angles)
		spawn_tfog (self.origin + qc.v_forward*20)
	end

	spawn_tdeath (self.origin, self)
end


--/*
--=============================================================================
--
--				QUAKED FUNCTIONS
--
--=============================================================================
--*/


--/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
--The normal starting point for a level.
--*/
function info_player_start()
end


--/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
--Only used on start map for the return point from an episode.
--*/
function info_player_start2()
end


--/*
--saved out by quaked in region mode
--*/
function testplayerstart()
end

--/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
--potential spawning position for deathmatch games
--*/
function info_player_deathmatch()
end

--/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
--potential spawning position for coop games
--*/
function info_player_coop()
end

--/*
--===============================================================================
--
--RULES
--
--===============================================================================
--*/

function PrintClientScore(c) -- entity
	if c.frags > -10  and  c.frags < 0 then -- TODO check condition
		bprint (" ")
	elseif c.frags >= 0 then -- TODO check condition
		if c.frags < 100 then -- TODO check condition
			bprint (" ")
                end
		if c.frags < 10 then -- TODO check condition
			bprint (" ")
                end
	end
	bprint (ftos(c.frags))
	bprint (" ")
	bprint (c.netname)
	bprint ("\n")
end

function DumpScore()
	local e, sort, walk; -- entity

	if world.chain ~= world then -- TODO check condition
		error ("DumpScore: world.chain is set")
        end

-- build a sorted lis
	e = find(world, "classname", "player")
	sort = world
	while e ~= world do -- TODO check condition
		if  sort == world then -- TODO check condition
			sort = e
			e.chain = world
		else
			if e.frags > sort.frags then -- TODO check condition
				e.chain = sort
				sort = e
			else
				walk = sort
				repeat
					if  walk.chain == world then -- TODO check condition
						e.chain = world
						walk.chain = e
					elseif walk.chain.frags < e.frags then -- TODO check condition
						e.chain = walk.chain
						walk.chain = e
					else
						walk = walk.chain
                                        end
				until not (walk.chain ~= e) -- TODO check condition
			end
		end
		
		e = find(e, "classname", "player")
	end

-- print the list
	
	bprint ("\n")	
	while sort ~= world do -- TODO check condition
		PrintClientScore (sort)
		sort = sort.chain
	end
	bprint ("\n")
end

--/*
--go to the next level for deathmatch
--*/
function NextLevel()
	local o; -- entity

-- find a trigger changelevel
	o = find(world, "classname", "trigger_changelevel")
	if  o == world or  mapname == "start" then -- TODO check condition
		o = spawn()
		o.map = mapname
	end

	nextmap = o.map
	
	if o.nextthink < time then -- TODO check condition
		o.think = execute_changelevel
		o.nextthink = time + 0.1
	end
end

--/*
--============
--CheckRules
--
--Exit deathmatch games upon conditions
--============
--*/
function CheckRules()
	local timelimit; -- float
	local fraglimit; -- float
	
	if gameover then -- TODO check condition
		return
        end
		
	timelimit = cvar("timelimit") * 60
	fraglimit = cvar("fraglimit")
	
	if timelimit ~= 0 and  time >= timelimit then -- TODO check condition
                NextLevel ()
--/*
--		gameover = true
--		bprint ("\n\n\n==============================\n")
--		bprint ("game exited after ")
--		bprint (ftos(timelimit/60))
--		bprint (" minutes\n")
--		DumpScore ()
--		localcmd ("killserver\n")
--*/
		return
	end
	
	if fraglimit ~= 0 and  self.frags >= fraglimit then -- TODO check condition
                NextLevel ()
--/*
--		gameover = true
--		bprint ("\n\n\n==============================\n")
--		bprint ("game exited after ")
--		bprint (ftos(self.frags))
--		bprint (" frags\n")
--		DumpScore ()
--		localcmd ("killserver\n")
--*/
		return
	end
end

--============================================================================

function PlayerDeathThink()
	local old_self; -- entity
	local forward; -- float

	if (self.flags & FL_ONGROUND == FL_ONGROUND) then -- TODO check condition
		forward = vlen (self.velocity)
		forward = forward - 20
		if forward <= 0 then -- TODO check condition
			self.velocity = vec3(0, 0, 0)
		else
			self.velocity = forward * normalize(self.velocity)
                end
	end

-- wait for all buttons released
	if self.deadflag == DEAD_DEAD then -- TODO check condition
		if self.button2 ~= 0 or  self.button1 ~= 0 or  self.button0 ~= 0 then -- TODO check condition
			return
                end
		self.deadflag = DEAD_RESPAWNABLE
		return
	end

-- wait for any button down
	if  self.button2 ~= 0 and self.button1 ~= 0 and  self.button0 ~= 0 then -- TODO check condition
		return
        end

	self.button0 = 0
	self.button1 = 0
	self.button2 = 0
	respawn()
end


function PlayerJump()
        if not self.swim_flag then self.swim_flag = 0 end

	if self.flags & FL_WATERJUMP == FL_WATERJUMP then -- TODO check condition
		return
        end
	
	if self.waterlevel >= 2 then -- TODO check condition
		if self.watertype == CONTENT_WATER then -- TODO check condition
			self.velocity.z = 100
		elseif self.watertype == CONTENT_SLIME then -- TODO check condition
			self.velocity.z = 80
		else
			self.velocity.z = 50
                end

-- play swiming sound
		if self.swim_flag < time then -- TODO check condition
			self.swim_flag = time + 1
			if random() < 0.5 then -- TODO check condition
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM)
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM)
                        end
		end

		return
	end

	if  self.flags & FL_ONGROUND ~= FL_ONGROUND then -- TODO check condition
		return
        end

	if   self.flags & FL_JUMPRELEASED ~= FL_JUMPRELEASED then -- TODO check condition
		return		-- don't pogo stick
        end

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED)

	self.flags = self.flags - FL_ONGROUND	-- don't stairwalk
	
	self.button2 = 0
-- player jumping sound
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM)
	self.velocity.z = self.velocity.z + 270
end


--/*
--===========
--WaterMove
--
--============
--*/
dmgtime  = 0 -- float

function WaterMove()
        if not self.air_finished then self.air_finished = 0 end
        if not self.pain_finished then self.pain_finished = 0 end

--dprint (ftos(self.waterlevel))
	if self.movetype == MOVETYPE_NOCLIP then -- TODO check condition
		return
        end
	if self.health < 0 then -- TODO check condition
		return
        end

	if self.waterlevel ~= 3 then -- TODO check condition
		if self.air_finished < time then -- TODO check condition
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM)
		elseif self.air_finished < time + 9 then -- TODO check condition
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM)
                end
		self.air_finished = time + 12
		self.dmg = 2
	elseif self.air_finished < time then -- TODO check condition
		if self.pain_finished < time then -- TODO check condition
			self.dmg = self.dmg + 2
			if self.dmg > 15 then -- TODO check condition
				self.dmg = 10
                        end
			T_Damage (self, world, world, self.dmg)
			self.pain_finished = time + 1
		end
	end
	
	if  not self.waterlevel then -- TODO check condition
		if self.flags & FL_INWATER == FL_INWATER then -- TODO check condition
			-- play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM)
			self.flags = self.flags - FL_INWATER
		end
		return
	end

	if self.watertype == CONTENT_LAVA then -- TODO check condition
		if self.dmgtime < time then -- TODO check condition
			if self.radsuit_finished > time then -- TODO check condition
				self.dmgtime = time + 1
			else
				self.dmgtime = time + 0.2
                        end

			T_Damage (self, world, world, 10*self.waterlevel)
		end
	elseif self.watertype == CONTENT_SLIME then -- TODO check condition
		if self.dmgtime < time  and  self.radsuit_finished < time then -- TODO check condition
			self.dmgtime = time + 1
			T_Damage (self, world, world, 4*self.waterlevel)
		end
	end
	
	if   self.flags & FL_INWATER ~= FL_INWATER  then -- TODO check condition

-- player enter water sound

		if self.watertype == CONTENT_LAVA then -- TODO check condition
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM)
                end
		if self.watertype == CONTENT_WATER then -- TODO check condition
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM)
                end
		if self.watertype == CONTENT_SLIME then -- TODO check condition
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM)
                end

		self.flags = self.flags + FL_INWATER
		self.dmgtime = 0
	end
	
	if  (self.flags & FL_WATERJUMP) ~= FL_WATERJUMP then -- TODO check condition
		self.velocity = self.velocity - 0.8*self.waterlevel*qc.frametime*self.velocity
        end
end

function CheckWaterJump()
	local start, _end; -- vector

-- check for a jump-out-of-water
	makevectors (self.angles)
	start = self.origin
	start.z= start.z+ 8 
	qc.v_forward.z= 0
	normalize(qc.v_forward)
	_end = start + qc.v_forward*24
	traceline (start, _end, true, self)
	if qc.trace_fraction < 1 then -- TODO check condition
		start.z= start.z+ self.maxs.z- 8
		_end = start + qc.v_forward*24
		self.movedir = qc.trace_plane_normal * -50
		traceline (start, _end, true, self)
		if qc.trace_fraction == 1 then -- TODO check condition
			self.flags = self.flags | FL_WATERJUMP
			self.velocity.z= 225
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED)
			self.teleport_time = time + 2	-- safety net
			return
		end
	end
end


--/*
--================
--PlayerPreThink
--
--Called every frame before physics are run
--================
--*/
qc.PlayerPreThink = function()
	local mspeed, aspeed; -- float
	local r; -- float

	if intermission_running ~= 0 then -- TODO check condition
		IntermissionThink ()	-- otherwise a button could be missed between
		return					-- the think tics
	end

	if self.view_ofs == vec3(0, 0, 0) then -- TODO check condition
		return		-- intermission or finale
        end

	makevectors (self.v_angle)		-- is this still used

	CheckRules ()
	WaterMove ()

	if self.waterlevel == 2 then -- TODO check condition
		CheckWaterJump ()
        end

	if self.deadflag >= DEAD_DEAD then -- TODO check condition
		PlayerDeathThink ()
		return
	end
	
	if self.deadflag == DEAD_DYING then -- TODO check condition
		return	-- dying, so do nothing
        end

	if self.button2 ~= 0 then -- TODO check condition
		PlayerJump ()
	else
		self.flags = self.flags | FL_JUMPRELEASED
        end

        if not self.pausetime then self.pausetime = 0 end

-- teleporters can force a non-moving pause time	
	if time < self.pausetime then -- TODO check condition
		self.velocity = vec3(0, 0, 0)
        end
end
	
--/*
--================
--CheckPowerups
--
--Check for turning off powerups
--================
--*/
function CheckPowerups()
	if self.health <= 0 then -- TODO check condition
		return
        end

        if not self.rad_time then self.rad_time = 0 end

-- invisibility
	if self.invisible_finished ~= 0 then -- TODO check condition
-- sound and screen flash when items starts to run out
		if self.invisible_sound < time then -- TODO check condition
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE)
			self.invisible_sound = time + ((random() * 3) + 1)
		end


		if self.invisible_finished < time + 3 then -- TODO check condition
			if self.invisible_time == 1 then -- TODO check condition
				sprint (self, "Ring of Shadows magic is fading\n")
				stuffcmd (self, "bf\n")
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM)
				self.invisible_time = time + 1
			end
			
			if self.invisible_time < time then -- TODO check condition
				self.invisible_time = time + 1
				stuffcmd (self, "bf\n")
			end
		end

		if self.invisible_finished < time then -- TODO check condition
			self.items = self.items - IT_INVISIBILITY
			self.invisible_finished = 0
			self.invisible_time = 0
		end
		
	-- use the eyes
		self.frame = 0
		self.modelindex = modelindex_eyes
	else
		self.modelindex = modelindex_player	-- don't use eyes
        end

-- invincibility
	if self.invincible_finished ~= 0 then -- TODO check condition
-- sound and screen flash when items starts to run out
		if self.invincible_finished < time + 3 then -- TODO check condition
			if self.invincible_time == 1 then -- TODO check condition
				sprint (self, "Protection is almost burned out\n")
				stuffcmd (self, "bf\n")
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM)
				self.invincible_time = time + 1
			end
			
			if self.invincible_time < time then -- TODO check condition
				self.invincible_time = time + 1
				stuffcmd (self, "bf\n")
			end
		end
		
		if self.invincible_finished < time then -- TODO check condition
			self.items = self.items - IT_INVULNERABILITY
			self.invincible_time = 0
			self.invincible_finished = 0
		end
		if self.invincible_finished > time then -- TODO check condition
			self.effects = self.effects | EF_DIMLIGHT
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT)
                end
	end

-- super damage
	if self.super_damage_finished ~= 0 then -- TODO check condition
-- sound and screen flash when items starts to run out

		if self.super_damage_finished < time + 3 then -- TODO check condition
			if self.super_time == 1 then -- TODO check condition
				sprint (self, "Quad Damage is wearing off\n")
				stuffcmd (self, "bf\n")
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM)
				self.super_time = time + 1
			end
			
			if self.super_time < time then -- TODO check condition
				self.super_time = time + 1
				stuffcmd (self, "bf\n")
			end
		end

		if self.super_damage_finished < time then -- TODO check condition
			self.items = self.items - IT_QUAD
			self.super_damage_finished = 0
			self.super_time = 0
		end
		if self.super_damage_finished > time then -- TODO check condition
			self.effects = self.effects | EF_DIMLIGHT
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT)
                end
	end

-- suit	
	if self.radsuit_finished ~= 0 then -- TODO check condition
		self.air_finished = time + 12		-- don't drown

-- sound and screen flash when items starts to run out
		if self.radsuit_finished < time + 3 then -- TODO check condition
			if self.rad_time == 1 then -- TODO check condition
				sprint (self, "Air supply in Biosuit expiring\n")
				stuffcmd (self, "bf\n")
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM)
				self.rad_time = time + 1
			end
			
			if self.rad_time < time then -- TODO check condition
				self.rad_time = time + 1
				stuffcmd (self, "bf\n")
			end
		end

		if self.radsuit_finished < time then -- TODO check condition
			self.items = self.items - IT_SUIT
			self.rad_time = 0
			self.radsuit_finished = 0
		end
	end

end


--/*
--================
--PlayerPostThink
--
--Called every frame after physics are run
--================
--*/
qc.PlayerPostThink = function()
	local mspeed, aspeed; -- float
	local r; -- float

	if self.view_ofs == vec3(0, 0, 0) then -- TODO check condition
		return		-- intermission or finale
        end
	if self.deadflag ~= 0 then -- TODO check condition
		return
        end
		
-- do weapon stuff

	W_WeaponFrame ()

        if not self.jump_flag then self.jump_flag = 0 end

-- check to see if player landed and play landing sound	
	if (self.jump_flag < -300)  and  (self.flags & FL_ONGROUND == FL_ONGROUND)  and  (self.health > 0) then -- TODO check condition
		if self.watertype == CONTENT_WATER then -- TODO check condition
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM)
		elseif self.jump_flag < -650 then -- TODO check condition
			T_Damage (self, world, world, 5) 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM)
			self.deathtype = "falling"
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM)
                end

		self.jump_flag = 0
	end

	if  (self.flags & FL_ONGROUND) ~= FL_ONGROUND then -- TODO check condition
		self.jump_flag = self.velocity.z
        end

	CheckPowerups ()
end


--/*
--===========
--ClientConnect
--
--called when a player connects to a server
--============
--*/
qc.ClientConnect = function()
	bprint (self.netname)
	bprint (" entered the game\n")
	
-- a client connecting during an intermission can cause problems
	if intermission_running ~= 0 then -- TODO check condition
		ExitIntermission ()
        end
end


--/*
--===========
--ClientDisconnect
--
--called when a player disconnects from a server
--============
--*/
qc.ClientDisconnect = function()
	if gameover then -- TODO check condition
		return
	-- if the level end trigger has been activated, just return
	-- since they aren't *really* leaving

        else
	        bprint (self.netname)
        end
	bprint (" left the game with ")
	bprint (ftos(self.frags))
	bprint (" frags\n")
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE)
	set_suicide_frame ()
end

--/*
--===========
--ClientObituary
--
--called when a player dies
--============
--*/
function ClientObituary(targ, attacker) -- entity, entity
	local rnum; -- float
	local deathstring, deathstring2; -- string
	rnum = random()

	if targ.classname == "player" then -- TODO check condition
		if attacker.classname == "teledeath" then -- TODO check condition
			bprint (targ.netname)
			bprint (" was telefragged by ")
			bprint (attacker.owner.netname)
			bprint ("\n")

			attacker.owner.frags = attacker.owner.frags + 1
			return
		end

		if attacker.classname == "teledeath2" then -- TODO check condition
			bprint ("Satan's power deflects ")
			bprint (targ.netname)
			bprint ("'s telefrag\n")

			targ.frags = targ.frags - 1
			return
		end

		if attacker.classname == "player" then -- TODO check condition
			if targ == attacker then -- TODO check condition
				-- killed self
				attacker.frags = attacker.frags - 1
				bprint (targ.netname)
				
				if targ.weapon == 64  and  targ.waterlevel > 1 then -- TODO check condition
					bprint (" discharges into the water.\n")
					return
				end
				if targ.weapon == 16 then -- TODO check condition
					bprint (" tries to put the pin back in\n")
				elseif rnum then -- TODO check condition
					bprint (" becomes bored with life\n")
				else
					bprint (" checks if his weapon is loaded\n")
                                end
				return
			else
				attacker.frags = attacker.frags + 1

				rnum = attacker.weapon
				if rnum == IT_AXE then -- TODO check condition
                                        deathstring = " was ax-murdered by " -- string
					deathstring2 = "\n"
				end
				if rnum == IT_SHOTGUN then -- TODO check condition
                                        deathstring = " chewed on " -- string
					deathstring2 = "'s boomstick\n"
				end
				if rnum == IT_SUPER_SHOTGUN then -- TODO check condition
                                        deathstring = " ate 2 loads of " -- string
					deathstring2 = "'s buckshot\n"
				end
				if rnum == IT_NAILGUN then -- TODO check condition
                                        deathstring = " was nailed by " -- string
					deathstring2 = "\n"
				end
				if rnum == IT_SUPER_NAILGUN then -- TODO check condition
                                        deathstring = " was punctured by " -- string
					deathstring2 = "\n"
				end
				if rnum == IT_GRENADE_LAUNCHER then -- TODO check condition
                                        deathstring = " eats " -- string
					deathstring2 = "'s pineapple\n"
					if targ.health < -40 then -- TODO check condition
                                                deathstring = " was gibbed by " -- string
						deathstring2 = "'s grenade\n"
					end
				end
				if rnum == IT_ROCKET_LAUNCHER then -- TODO check condition
                                        deathstring = " rides " -- string
					deathstring2 = "'s rocket\n"
					if targ.health < -40 then -- TODO check condition
                                                deathstring = " was gibbed by " -- string
						deathstring2 = "'s rocket\n" 
					end
				end
				if rnum == IT_LIGHTNING then -- TODO check condition
                                        deathstring = " accepts " -- string
					if attacker.waterlevel > 1 then -- TODO check condition
						deathstring2 = "'s discharge\n"
					else
						deathstring2 = "'s shaft\n"
                                        end
				end
				bprint (targ.netname)
				bprint (deathstring)
				bprint (attacker.netname)
				bprint (deathstring2)
			end
			return
		else
			targ.frags = targ.frags - 1		-- killed self
			rnum = targ.watertype

			bprint (targ.netname)
			if rnum == -3 then -- TODO check condition
				if random() < 0.5 then -- TODO check condition
					bprint (" sleeps with the fishes\n")
				else
					bprint (" sucks it down\n")
                                end
				return
			elseif rnum == -4 then -- TODO check condition
				if random() < 0.5 then -- TODO check condition
					bprint (" gulped a load of slime\n")
				else
					bprint (" can't exist on slime alone\n")
                                end
				return
			elseif rnum == -5 then -- TODO check condition
				if targ.health < -15 then -- TODO check condition
					bprint (" burst into flames\n")
					return
				end
				if random() < 0.5 then -- TODO check condition
					bprint (" turned into hot slag\n")
				else
					bprint (" visits the Volcano God\n")
                                end
				return
			end

			if attacker.flags & FL_MONSTER == FL_MONSTER then -- TODO check condition
				if attacker.classname == "monster_army" then -- TODO check condition
					bprint (" was shot by a Grunt\n")
                                end
				if attacker.classname == "monster_demon1" then -- TODO check condition
					bprint (" was eviscerated by a Fiend\n")
                                end
				if attacker.classname == "monster_dog" then -- TODO check condition
					bprint (" was mauled by a Rottweiler\n")
                                end
				if attacker.classname == "monster_dragon" then -- TODO check condition
					bprint (" was fried by a Dragon\n")
                                end
				if attacker.classname == "monster_enforcer" then -- TODO check condition
					bprint (" was blasted by an Enforcer\n")
                                end
				if attacker.classname == "monster_fish" then -- TODO check condition
					bprint (" was fed to the Rotfish\n")
                                end
				if attacker.classname == "monster_hell_knight" then -- TODO check condition
					bprint (" was slain by a Death Knight\n")
                                end
				if attacker.classname == "monster_knight" then -- TODO check condition
					bprint (" was slashed by a Knight\n")
                                end
				if attacker.classname == "monster_ogre" then -- TODO check condition
					bprint (" was destroyed by an Ogre\n")
                                end
				if attacker.classname == "monster_oldone" then -- TODO check condition
					bprint (" became one with Shub-Niggurath\n")
                                end
				if attacker.classname == "monster_shalrath" then -- TODO check condition
					bprint (" was exploded by a Vore\n")
                                end
				if attacker.classname == "monster_shambler" then -- TODO check condition
					bprint (" was smashed by a Shambler\n")
                                end
				if attacker.classname == "monster_tarbaby" then -- TODO check condition
					bprint (" was slimed by a Spawn\n")
                                end
				if attacker.classname == "monster_vomit" then -- TODO check condition
					bprint (" was vomited on by a Vomitus\n")
                                end
				if attacker.classname == "monster_wizard" then -- TODO check condition
					bprint (" was scragged by a Scrag\n")
                                end
				if attacker.classname == "monster_zombie" then -- TODO check condition
					bprint (" joins the Zombies\n")
                                end

				return
			end
			if attacker.classname == "explo_box" then -- TODO check condition
				bprint (" blew up\n")
				return
			end
			if attacker.solid == SOLID_BSP  and  attacker ~= world then -- TODO check condition
				bprint (" was squished\n")
				return
			end
			if targ.deathtype == "falling" then -- TODO check condition
				targ.deathtype = ""
				bprint (" fell to his death\n")
				return
			end
			if attacker.classname == "trap_shooter"  or  attacker.classname == "trap_spikeshooter" then -- TODO check condition
				bprint (" was spiked\n")
				return
			end
			if attacker.classname == "fireball" then -- TODO check condition
				bprint (" ate a lavaball\n")
				return
			end
			if attacker.classname == "trigger_changelevel" then -- TODO check condition
				bprint (" tried to leave\n")
				return
			end

			bprint (" died\n")
		end
	end
end
