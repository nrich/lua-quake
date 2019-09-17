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


function SUB_Null()
end

function SUB_Remove()
        remove(self)
end


--/*
--QuakeEd only writes a single float for angles (bad idea), so up and down are
--just constant angles.
--*/
function SetMovedir()
	if self.angles() == vec3(0, -1, 0) then -- TODO check condition
		self.movedir = vec3(0, 0, 1)
	elseif self.angles() == vec3(0, -2, 0) then -- TODO check condition
		self.movedir = vec3(0, 0, -1)
	else
		makevectors (self.angles)
		self.movedir = qc.v_forward
	end
	
	self.angles = vec3(0, 0, 0)
end

--/*
--================
--InitTrigger
--================
--*/
function InitTrigger()
-- trigger angles are used for one-way touches.  An angle of 0 is assumed
-- to mean no restrictions, so use a yaw of 360 instead.
	if self.angles() ~= vec3(0, 0, 0) then -- TODO check condition
		SetMovedir ()
        end
	self.solid = SOLID_TRIGGER
	setmodel (self, self.model)	-- set size and link into world
	self.movetype = MOVETYPE_NONE
	self.modelindex = 0
	self.model = ""
end

--/*
--=============
--SUB_CalcMove
--
--calculate self.velocity and self.nextthink to reach dest from
--self.origin traveling at speed
--===============
--*/
function SUB_CalcMoveEnt(ent, tdest, tspeed, func) -- entity, vector, float, void()
        local stemp; -- entity
	stemp = self
	self = ent

	SUB_CalcMove (tdest, tspeed, func)
	self = stemp
end

function SUB_CalcMove(tdest, tspeed, func) -- vector, float, void()
        local vdestdelta; -- vector
        local len, traveltime; -- float

	if tspeed == 0 then -- TODO check condition
		objerror("No speed is defined not ")
        end

	self.think1 = func
	self.finaldest = tdest
	self.think = SUB_CalcMoveDone

	if tdest == self.origin() then -- TODO check condition
		self.velocity = vec3(0, 0, 0)
		self.nextthink = self.ltime + 0.1
		return
	end
		
-- set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin
	
-- calculate length of vector
	len = vlen (vdestdelta)
	
-- divide by speed to get time to reach dest
	traveltime = len / tspeed

	if traveltime < 0.1 then -- TODO check condition
		self.velocity = vec3(0, 0, 0)
		self.nextthink = self.ltime + 0.1
		return
	end
	
-- set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime

-- scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime)	-- qcc won't take vec/float	
end

--/*
--============
--After moving, set origin to exact final destination
--============
--*/
function SUB_CalcMoveDone()
	setorigin(self, self.finaldest)
	self.velocity = vec3(0, 0, 0)
	self.nextthink = -1
	if self.think1 then -- TODO check condition
		self.think1()
        end
end


--/*
--=============
--SUB_CalcAngleMove
--
--calculate self.avelocity and self.nextthink to reach destangle from
--self.angles rotating 
--
--The calling function should make sure self.think is valid
--===============
--*/
function SUB_CalcAngleMoveEnt(ent, destangle, tspeed, func) -- entity, vector, float, void()
        local stemp; -- entity
	stemp = self
	self = ent
	SUB_CalcAngleMove (destangle, tspeed, func)
	self = stemp
end

function SUB_CalcAngleMove(destangle, tspeed, func) -- vector, float, void()
        local destdelta; -- vector
        local len, traveltime; -- float

	if  not tspeed or tspeed == 0 then -- TODO check condition
		objerror("No speed is defined not ")
        end
		
-- set destdelta to the vector needed to move
	destdelta = destangle - self.angles
	
-- calculate length of vector
	len = vlen (destdelta)
	
-- divide by speed to get time to reach dest
	traveltime = len / tspeed

-- set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime

-- scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime)
	
	self.think1 = func
	self.finalangle = destangle
	self.think = SUB_CalcAngleMoveDone
end

--/*
--============
--After rotating, set angle to exact final angle
--============
--*/
function SUB_CalcAngleMoveDone()
	self.angles = self.finalangle
	self.avelocity = vec3(0, 0, 0)
	self.nextthink = -1
	if self.think1 then -- TODO check condition
		self.think1()
        end
end


--=============================================================================

function DelayThink()
	activator = self.enemy
	SUB_UseTargets ()
	remove(self)
end

--/*
--==============================
--SUB_UseTargets
--
--the global "activator" should be set to the entity that initiated the firing.
--
--If self.delay is set, a DelayedUse entity will be created that will actually
--do the SUB_UseTargets after that many seconds have passed.
--
--Centerprints any self.message to the activator.
--
--Removes all entities with a targetname that match self.killtarget,
--and removes them, so some events can remove other triggers.
--
--Search for (string)targetname in all entities that
--match (string)self.target and call their .use function
--
--==============================
--*/
function SUB_UseTargets()
	local t, stemp, otemp, act; -- entity

--
-- check for a delay
--
	if self.delay and self.delay ~= 0 then -- TODO check condition
	-- create a temp object to fire at a later time
		t = spawn()
		t.classname = "DelayedUse"
		t.nextthink = time + self.delay
		t.think = DelayThink
		t.enemy = activator
		t.message = self.message
		t.killtarget = self.killtarget
		t.target = self.target
		return
	end
	
	
--
-- print the message
--
	if activator and activator ~= world and activator.classname == "player"  and  self.message ~= "" then -- TODO check condition
		centerprint (activator, self.message)
		if self.noise ~= "" then -- TODO check condition
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM)
                end
	end

--
-- kill the killtagets
--
	if self.killtarget and self.killtarget ~= world then -- TODO check condition
		t = world
		repeat
			t = find (t, "targetname", self.killtarget)
			if  t == world then -- TODO check condition
				return
                        end
			remove (t)
		until not ( 1 ) -- TODO check condition
	end
	
--
-- fire targets
--
	if self.target ~= "" then -- TODO check condition
		act = activator
		t = world
		repeat
			t = find (t, "targetname", self.target)
			if  t == world then -- TODO check condition
				return
			end
			stemp = self
			otemp = other
			self = t
			other = stemp
			if self.use ~= SUB_Null then -- TODO check condition
				if self.use then -- TODO check condition
					self.use ()
                                end
			end
			self = stemp
			other = otemp
			activator = act
		until not ( true ) -- TODO check condition
	end
	

end


--/*
--
--in nightmare mode, all attack_finished times become 0
--some monsters refire twice automatically
--
--*/

function SUB_AttackFinished(normal) -- float
	self.cnt = 0		-- refire count for nightmare
	if skill ~= 3 then -- TODO check condition
		self.attack_finished = time + normal
        end
end


function SUB_CheckRefire(thinkst) -- void()
	if skill ~= 3 then -- TODO check condition
		return
        end
	if self.cnt == 1 then -- TODO check condition
		return
        end
	if  not visible (self.enemy) then -- TODO check condition
		return
        end
	self.cnt = 1
	self.think = thinkst
end
