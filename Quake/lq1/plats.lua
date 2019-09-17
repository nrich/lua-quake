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


local PLAT_LOW_TRIGGER = 1 -- float

function plat_spawn_inside_trigger()
	local trigger; -- entity
	local tmin, tmax; -- vector
--
-- middle trigger
--	
	trigger = spawn()
	trigger.touch = plat_center_touch
	trigger.movetype = MOVETYPE_NONE
	trigger.solid = SOLID_TRIGGER
	trigger.enemy = self
	
	tmin = self.mins + vec3(25, 25, 0)
	tmax = self.maxs - vec3(25, 25, -8)
	tmin.z= tmax.z- (self.pos1.z- self.pos2.z+ 8)
	if self.spawnflags & PLAT_LOW_TRIGGER == PLAT_LOW_TRIGGER then -- TODO check condition
		tmax.z= tmin.z+ 8
        end
	
	if self.size.x<= 50 then -- TODO check condition
		tmin.x= (self.mins.x+ self.maxs.x) / 2
		tmax.x= tmin.x+ 1
	end
	if self.size.y<= 50 then -- TODO check condition
		tmin.y= (self.mins.y+ self.maxs.y) / 2
		tmax.y= tmin.y+ 1
	end
	
	setsize (trigger, tmin, tmax)
end

function plat_hit_top()
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM)
	self.state = STATE_TOP
	self.think = plat_go_down
	self.nextthink = self.ltime + 3
end

function plat_hit_bottom()
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM)
	self.state = STATE_BOTTOM
end

function plat_go_down()
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM)
	self.state = STATE_DOWN
	SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom)
end

function plat_go_up()
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM)
	self.state = STATE_UP
	SUB_CalcMove (self.pos1, self.speed, plat_hit_top)
end

function plat_center_touch()
	if other.classname ~= "player" then -- TODO check condition
		return
        end
		
	if other.health <= 0 then -- TODO check condition
		return
        end

	self = self.enemy
	if self.state == STATE_BOTTOM then -- TODO check condition
		plat_go_up ()
	elseif self.state == STATE_TOP then -- TODO check condition
		self.nextthink = self.ltime + 1	-- delay going down
        end
end

function plat_outside_touch()
	if other.classname ~= "player" then -- TODO check condition
		return
        end

	if other.health <= 0 then -- TODO check condition
		return
        end
		
--dprint ("plat_outside_touch\n")
	self = self.enemy
	if self.state == STATE_TOP then -- TODO check condition
		plat_go_down ()
        end
end

function plat_trigger_use()
	if self.think then -- TODO check condition
		return		-- allready activated
        end
	plat_go_down()
end


function plat_crush()
	T_Damage (other, self, self, 1)
	
	if self.state == STATE_UP then -- TODO check condition
		plat_go_down ()
	elseif self.state == STATE_DOWN then -- TODO check condition
		plat_go_up ()
	else
		objerror ("plat_crush: bad self.state\n")
        end
end

function plat_use()
	self.use = SUB_Null
	if self.state ~= STATE_UP then -- TODO check condition
		objerror ("plat_use: not in up state")
        end
	plat_go_down()
end


--/*QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER
--speed	default 150
--
--Plats are always drawn in the extended position, so they will light correctly.
--
--If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.
--
--If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
--Set "sounds" to one of the following:
--1) base fast
--2) chain slow
--*/


function func_plat()
        local t; -- entity

	if  not self.t_length or self.t_length == 0 then -- TODO check condition
		self.t_length = 80
        end
	if  not self.t_width or self.t_width == 0 then -- TODO check condition
		self.t_width = 10
        end

	if self.sounds == 0 then -- TODO check condition
		self.sounds = 2
        end
-- FIX THIS TO LOAD A GENERIC PLAT SOUND

	if self.sounds == 1 then -- TODO check condition
		precache_sound ("plats/plat1.wav")
		precache_sound ("plats/plat2.wav")
		self.noise = "plats/plat1.wav"
		self.noise1 = "plats/plat2.wav"
	end

	if self.sounds == 2 then -- TODO check condition
		precache_sound ("plats/medplat1.wav")
		precache_sound ("plats/medplat2.wav")
		self.noise = "plats/medplat1.wav"
		self.noise1 = "plats/medplat2.wav"
	end


	self.mangle = self.angles
	self.angles = vec3(0, 0, 0)

	self.classname = "plat"
	self.solid = SOLID_BSP
	self.movetype = MOVETYPE_PUSH
	setorigin (self, self.origin)	
	setmodel (self, self.model)
	setsize (self, self.mins , self.maxs)

	self.blocked = plat_crush
	if  not self.speed or self.speed == 0 then -- TODO check condition
		self.speed = 150
        end

-- pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin
	self.pos2 = self.origin
	if self.height and self.height ~= 0 then -- TODO check condition
		self.pos2.z= self.origin.z- self.height
	else
		self.pos2.z= self.origin.z- self.size.z+ 8
        end

	self.use = plat_trigger_use

	plat_spawn_inside_trigger ()	-- the "start moving" trigger	

	if self.targetname ~= "" then -- TODO check condition
		self.state = STATE_UP
		self.use = plat_use
	else
		setorigin (self, self.pos2)
		self.state = STATE_BOTTOM
	end
end

--============================================================================


function train_blocked()
        if not self.attack_finished then self.attack_finished = 0 end
	if time < self.attack_finished then -- TODO check condition
		return
        end
	self.attack_finished = time + 0.5
	T_Damage (other, self, self, self.dmg)
end

function train_use()
	if self.think ~= func_train_find then -- TODO check condition
		return		-- already activated
        end
	train_next()
end

function train_wait()
	if self.wait and self.wait ~= 0 then -- TODO check condition
		self.nextthink = self.ltime + self.wait
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM)
	else
		self.nextthink = self.ltime + 0.1
        end
	
	self.think = train_next
end

function train_next()
	local targ; -- entity

	targ = find (world, "targetname", self.target)
	self.target = targ.target
	if  self.target == "" then -- TODO check condition
		objerror ("train_next: no next target")
        end
	if targ.wait and targ.wait ~= 0 then -- TODO check condition
		self.wait = targ.wait
	else
		self.wait = 0
        end
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM)
	SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait)
end

function func_train_find()

	local targ; -- entity

	targ = find (world, "targetname", self.target)
	self.target = targ.target
	setorigin (self, targ.origin - self.mins)
	if  self.targetname == "" then -- TODO check condition
		self.nextthink = self.ltime + 0.1
		self.think = train_next
	end
end

--/*QUAKED func_train (0 .5 .8) ?
--Trains are moving platforms that players can ride.
--The targets origin specifies the min point of the train at each corner.
--The train spawns at the first target it is pointing at.
--If the train is the target of a button or trigger, it will not begin moving until activated.
--speed	default 100
--dmg		default	2
--sounds
--1) ratchet metal
--
--*/
function func_train()
	if  not self.speed or self.speed == 0 then -- TODO check condition
		self.speed = 100
        end
	if  self.target == "" then -- TODO check condition
		objerror ("func_train without a target")
        end
	if  not self.dmg then -- TODO check condition
		self.dmg = 2
        end

	if self.sounds == 0 then -- TODO check condition
		self.noise = ("misc/null.wav")
		precache_sound ("misc/null.wav")
		self.noise1 = ("misc/null.wav")
		precache_sound ("misc/null.wav")
	end

	if self.sounds == 1 then -- TODO check condition
		self.noise = ("plats/train2.wav")
		precache_sound ("plats/train2.wav")
		self.noise1 = ("plats/train1.wav")
		precache_sound ("plats/train1.wav")
	end

	self.cnt = 1
	self.solid = SOLID_BSP
	self.movetype = MOVETYPE_PUSH
	self.blocked = train_blocked
	self.use = train_use
	self.classname = "train"

	setmodel (self, self.model)
	setsize (self, self.mins , self.maxs)
	setorigin (self, self.origin)

-- start trains on the second frame, to make sure their targets have had
-- a chance to spawn
	self.nextthink = self.ltime + 0.1
	self.think = func_train_find
end

--/*QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
--This is used for the final bos
--*/
function misc_teleporttrain()
	if  not self.speed or self.speed == 0 then -- TODO check condition
		self.speed = 100
        end
	if  not self.target or self.target == world then -- TODO check condition
		objerror ("func_train without a target")
        end

	self.cnt = 1
	self.solid = SOLID_NOT
	self.movetype = MOVETYPE_PUSH
	self.blocked = train_blocked
	self.use = train_use
	self.avelocity = vec3(100, 200, 300)

	self.noise = ("misc/null.wav")
	precache_sound ("misc/null.wav")
	self.noise1 = ("misc/null.wav")
	precache_sound ("misc/null.wav")

	precache_model2 ("progs/teleport.mdl")
	setmodel (self, "progs/teleport.mdl")
	setsize (self, self.mins , self.maxs)
	setorigin (self, self.origin)

-- start trains on the second frame, to make sure their targets have had
-- a chance to spawn
	self.nextthink = self.ltime + 0.1
	self.think = func_train_find
end

