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

local stemp, otemp, s, old


function trigger_reactivate()
	self.solid = SOLID_TRIGGER
end

--=============================================================================

local SPAWNFLAG_NOMESSAGE = 1 -- float
local SPAWNFLAG_NOTOUCH = 1 -- float

-- the wait time has passed, so set back up for another activation
function multi_wait()
	if self.max_health ~= 0 then -- TODO check condition
		self.health = self.max_health
		self.takedamage = DAMAGE_YES
		self.solid = SOLID_BBOX
	end
end


-- the trigger was just touched/killed/used
-- self.enemy should be set to the activator so it can be held through a delay
-- so wait for the delay time before firing
function multi_trigger()
	if self.nextthink > time then -- TODO check condition
		return		-- allready been triggered
	end

	if self.classname == "trigger_secret" then -- TODO check condition
		if self.enemy.classname ~= "player" then -- TODO check condition
			return
                end
		qc.found_secrets = qc.found_secrets + 1
		WriteByte (MSG_ALL, SVC_FOUNDSECRET)
	end

	if self.noise ~= "" then -- TODO check condition
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM)
        end

-- don't trigger again until reset
	self.takedamage = DAMAGE_NO

	activator = self.enemy
	
	SUB_UseTargets()

	if self.wait and self.wait > 0 then -- TODO check condition
		self.think = multi_wait
		self.nextthink = time + self.wait
	else
		-- called wheil C code is looping through area links...
		self.touch = SUB_Null
		self.nextthink = time + 0.1
		self.think = SUB_Remove
	end
end

function multi_killed()
	self.enemy = damage_attacker
	multi_trigger()
end

function multi_use()
	self.enemy = activator
	multi_trigger()
end

function multi_touch()
	if other.classname ~= "player" then -- TODO check condition
		return
        end
	
-- if the trigger has an angles field, check player's facing direction
	if self.movedir() ~= vec3(0, 0, 0) then -- TODO check condition
		makevectors (other.angles)
		if qc.v_forward * self.movedir < 0 then -- TODO check condition
			return		-- not facing the right way
                end
	end
	
	self.enemy = other
	multi_trigger ()
end

--/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
--Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
--If "delay" is set, the trigger waits some time after activating before firing.
--"wait" : Seconds between triggerings. (.2 default)
--If notouch is set, the trigger is only fired by other entities, not by touching.
--NOTOUCH has been obsoleted by trigger_relay not 
--sounds
--1)	secret
--2)	beep beep
--3)	large switch
--4)
--set "message" to text string
--*/
function trigger_multiple()
	if self.sounds == 1 then -- TODO check condition
		precache_sound ("misc/secret.wav")
		self.noise = "misc/secret.wav"
	elseif self.sounds == 2 then -- TODO check condition
		precache_sound ("misc/talk.wav")
		self.noise = "misc/talk.wav"
	elseif self.sounds == 3 then -- TODO check condition
		precache_sound ("misc/trigger1.wav")
		self.noise = "misc/trigger1.wav"
	end
	
	if  not self.wait or self.wait == 0 then -- TODO check condition
		self.wait = 0.2
        end
	self.use = multi_use

	InitTrigger ()

	if self.health ~= 0 then -- TODO check condition
		if self.spawnflags & SPAWNFLAG_NOTOUCH == SPAWNFLAG_NOTOUCH then -- TODO check condition
			objerror ("health and notouch don't make sense\n")
                end
		self.max_health = self.health
		self.th_die = multi_killed
		self.takedamage = DAMAGE_YES
		self.solid = SOLID_BBOX
		setorigin (self, self.origin)	-- make sure it links into the world
	else
		if (self.spawnflags & SPAWNFLAG_NOTOUCH == 0)  then -- TODO check condition
			self.touch = multi_touch
		end
	end
end


--/*QUAKED trigger_once (.5 .5 .5) ? notouch
--Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
--"targetname".  If "health" is set, the trigger must be killed to activate.
--If notouch is set, the trigger is only fired by other entities, not by touching.
--if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
--if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
--sounds
--1)	secret
--2)	beep beep
--3)	large switch
--4)
--set "message" to text string
--*/
function trigger_once()
	self.wait = -1
	trigger_multiple()
end

--=============================================================================

--/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
--This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
--*/
function trigger_relay()
	self.use = SUB_UseTargets
end


--=============================================================================

--/*QUAKED trigger_secret (.5 .5 .5) ?
--secret counter trigger
--sounds
--1)	secret
--2)	beep beep
--3)
--4)
--set "message" to text string
--*/
function trigger_secret()
	qc.total_secrets = qc.total_secrets + 1
	self.wait = -1
	if  self.message == "" then -- TODO check condition
		self.message = "You found a secret area!"
        end
	if  self.sounds == 0 then -- TODO check condition
		self.sounds = 1
        end
	
	if self.sounds == 1 then -- TODO check condition
		precache_sound ("misc/secret.wav")
		self.noise = "misc/secret.wav"
	elseif self.sounds == 2 then -- TODO check condition
		precache_sound ("misc/talk.wav")
		self.noise = "misc/talk.wav"
	end

	trigger_multiple ()
end

--=============================================================================


function counter_use()
	local junk; -- string

	self.count = self.count - 1
	if self.count < 0 then -- TODO check condition
		return
        end
	
	if self.count ~= 0 then -- TODO check condition
		if (activator.classname == "player" and (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) then
			if self.count >= 4 then -- TODO check condition
				centerprint (activator, "There are more to go...")
			elseif self.count == 3 then -- TODO check condition
				centerprint (activator, "Only 3 more to go...")
			elseif self.count == 2 then -- TODO check condition
				centerprint (activator, "Only 2 more to go...")
			else
				centerprint (activator, "Only 1 more to go...")
                        end
		end
		return
	end
	
	if (activator.classname == "player" and  (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) then
		centerprint(activator, "Sequence completed!")
        end
	self.enemy = activator
	multi_trigger ()
end

--/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
--Acts as an intermediary for an action that takes multiple inputs.
--
--If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.
--
--After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
--*/
function trigger_counter()
	self.wait = -1
	if  not self.count or self.count == 0 then -- TODO check condition
		self.count = 2
        end

	self.use = counter_use
end


--/*
--==============================================================================
--
--TELEPORT TRIGGERS
--
--==============================================================================
--*/

local PLAYER_ONLY = 1 -- float
local SILENT = 2 -- float

function play_teleport()
	local v; -- float
	local tmpstr; -- string

	v = random() * 5
	if v < 1 then -- TODO check condition
		tmpstr = "misc/r_tele1.wav"
	elseif v < 2 then -- TODO check condition
		tmpstr = "misc/r_tele2.wav"
	elseif v < 3 then -- TODO check condition
		tmpstr = "misc/r_tele3.wav"
	elseif v < 4 then -- TODO check condition
		tmpstr = "misc/r_tele4.wav"
	else
		tmpstr = "misc/r_tele5.wav"
        end

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM)
	remove (self)
end

function spawn_tfog(org) -- vector
	s = spawn ()
	s.origin = org
	s.nextthink = time + 0.2
	s.think = play_teleport

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_TELEPORT)
	WriteCoord (MSG_BROADCAST, org.x)
	WriteCoord (MSG_BROADCAST, org.y)
	WriteCoord (MSG_BROADCAST, org.z)
end


function tdeath_touch()
	if other == self.owner then -- TODO check condition
		return
        end

-- frag anyone who teleports in on top of an invincible player
	if other.classname == "player" then -- TODO check condition
		if other.invincible_finished > time then -- TODO check condition
			self.classname = "teledeath2"
                end
		if self.owner.classname ~= "player" then -- TODO check condition
			T_Damage (self.owner, self, self, 50000)
			return
		end
		
	end

	if other.health ~= 0 then -- TODO check condition
		T_Damage (other, self, self, 50000)
	end
end


function spawn_tdeath(org, death_owner) -- vector, entity
        local death; -- entity

	death = spawn()
	death.classname = "teledeath"
	death.movetype = MOVETYPE_NONE
	death.solid = SOLID_TRIGGER
	death.angles = vec3(0, 0, 0)
	setsize (death, death_owner.mins - vec3(1, 1, 1), death_owner.maxs + vec3(1, 1, 1))
	setorigin (death, org)
	death.touch = tdeath_touch
	death.nextthink = time + 0.2
	death.think = SUB_Remove
	death.owner = death_owner
	
	force_retouch = 2		-- make sure even still objects get hit
end

function teleport_touch()
        local t; -- entity
        local org; -- vector

	if self.targetname ~= "" then -- TODO check condition
		if self.nextthink < time then -- TODO check condition
			return		-- not fired yet
		end
	end

	if self.spawnflags & PLAYER_ONLY == PLAYER_ONLY then -- TODO check condition
		if other.classname ~= "player" then -- TODO check condition
			return
                end
	end

-- only teleport living creatures
	if other.health <= 0  or  other.solid ~= SOLID_SLIDEBOX then -- TODO check condition
		return
        end

	SUB_UseTargets ()

-- put a tfog where the player was
	spawn_tfog (other.origin)

	t = find (world, "targetname", self.target)
	if  t == world then -- TODO check condition
		objerror ("couldn't find target")
        end
		
-- spawn a tfog flash in front of the destination
	makevectors (t.mangle)
	org = t.origin + 32 * qc.v_forward

	spawn_tfog (org)
	spawn_tdeath(t.origin, other)

-- move the player and lock him down for a little while
	if  other.health ~= 0 then -- TODO check condition
		other.origin = t.origin
		other.velocity = (qc.v_forward * other.velocity.x) + (qc.v_forward * other.velocity.y)
		return
	end

	setorigin (other, t.origin)
	other.angles = t.mangle
	if other.classname == "player" then -- TODO check condition
		other.fixangle = 1		-- turn this way immediately
		other.teleport_time = time + 0.7
		if other.flags & FL_ONGROUND == FL_ONGROUND then -- TODO check condition
			other.flags = other.flags - FL_ONGROUND
                end
		other.velocity = qc.v_forward * 300
	end
	other.flags = other.flags - other.flags & FL_ONGROUND
end

--/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
--This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
--*/
function info_teleport_destination()
-- this does nothing, just serves as a target spot
	self.mangle = self.angles
	self.angles = vec3(0, 0, 0)
	self.model = ""
	self.origin = self.origin + vec3(0, 0, 27)
	if  self.targetname == "" then -- TODO check condition
                return
		--objerror ("no targetname")
        end
end

function teleport_use()
	self.nextthink = time + 0.2
	force_retouch = 2		-- make sure even still objects get hit
	self.think = SUB_Null
end

--/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
--Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.
--
--If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
--*/
function trigger_teleport()
	local o; -- vector

	InitTrigger ()
	self.touch = teleport_touch
	-- find the destination 
	if  self.target == world then -- TODO check condition
		objerror ("no target")
        end
	self.use = teleport_use

	if  (self.spawnflags & SILENT ~= SILENT) then -- TODO check condition
		precache_sound ("ambience/hum1.wav")
		o = (self.mins + self.maxs)*0.5
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC)
	end
end

--/*
--==============================================================================
--
--trigger_setskill
--
--==============================================================================
--*/

function trigger_skill_touch()
	if other.classname ~= "player" then -- TODO check condition
		return
        end
		
	cvar_set ("skill", self.message)
end

--/*QUAKED trigger_setskill (.5 .5 .5) ?
--sets skill level to the value of "message".
--Only used on start map.
--*/
function trigger_setskill()
	InitTrigger ()
	self.touch = trigger_skill_touch
end


--/*
--==============================================================================
--
--ONLY REGISTERED TRIGGERS
--
--==============================================================================
--*/

function trigger_onlyregistered_touch()
        if not self.attack_finished then self.attack_finished = 0 end
	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if self.attack_finished > time then -- TODO check condition
		return
        end

	self.attack_finished = time + 2
	if cvar("registered") ~= "" then -- TODO check condition
		self.message = ""
		SUB_UseTargets ()
		remove (self)
	else
		if self.message ~= "" then -- TODO check condition
			centerprint (other, self.message)
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM)
		end
	end
end

--/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
--Only fires if playing the registered version, otherwise prints the message
--*/
function trigger_onlyregistered()
	precache_sound ("misc/talk.wav")
	InitTrigger ()
	self.touch = trigger_onlyregistered_touch
end

--============================================================================

function hurt_on()
	self.solid = SOLID_TRIGGER
	self.nextthink = -1
end

function hurt_touch()
	if other.takedamage ~= 0 then -- TODO check condition
		self.solid = SOLID_NOT
		T_Damage (other, self, self, self.dmg)
		self.think = hurt_on
		self.nextthink = time + 1
	end

	return
end

--/*QUAKED trigger_hurt (.5 .5 .5) ?
--Any object touching this will be hurt
--set dmg to damage amount
--defalt dmg = 5
--*/
function trigger_hurt()
	InitTrigger ()
	self.touch = hurt_touch
	if  not self.dmg or self.dmg == 0 then -- TODO check condition
		self.dmg = 5
        end
end

--============================================================================

local PUSH_ONCE = 1 -- float

function trigger_push_touch()
	if other.classname == "grenade" then -- TODO check condition
		other.velocity = self.speed * self.movedir * 10
	elseif other.health > 0 then -- TODO check condition
		other.velocity = self.speed * self.movedir * 10
		if other.classname == "player" then -- TODO check condition
			if other.fly_sound < time then -- TODO check condition
				other.fly_sound = time + 1.5
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM)
			end
		end
	end
	if self.spawnflags & PUSH_ONCE == PUSH_ONCE then -- TODO check condition
		remove(self)
        end
end


--/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
--Pushes the player
--*/
function trigger_push()
	InitTrigger ()
	precache_sound ("ambience/windfly.wav")
	self.touch = trigger_push_touch
	if  not self.speed or self.speed == 0 then -- TODO check condition
		self.speed = 1000
        end
end

--============================================================================

function trigger_monsterjump_touch()
	if  other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) ~= FL_MONSTER  then -- TODO check condition
		return
        end

-- set XY even if not on ground, so the jump will clear lips
	other.velocity.x= self.movedir.x* self.speed
	other.velocity.y= self.movedir.y* self.speed
	
	if   not (other.flags & FL_ONGROUND == FL_ONGROUND)  then -- TODO check condition
		return
        end
	
	other.flags = other.flags - FL_ONGROUND

	other.velocity.z= self.height
end

--/*QUAKED trigger_monsterjump (.5 .5 .5) ?
--Walking monsters that touch this will jump in the direction of the trigger's angle
--"speed" default to 200, the speed thrown forward
--"height" default to 200, the speed thrown upwards
--*/
function trigger_monsterjump()
	if  not self.speed or self.speed == 0 then -- TODO check condition
		self.speed = 200
        end
	if  not self.height or self.height == 0 then -- TODO check condition
		self.height = 200
        end
	if self.angles == vec3(0, 0, 0) then -- TODO check condition
		self.angles = vec3(0, 360, 0)
        end
	InitTrigger ()
	self.touch = trigger_monsterjump_touch
end

