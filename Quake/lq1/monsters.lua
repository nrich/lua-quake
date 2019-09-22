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
--/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

-- expands to:
-- name ()
--		self.frame=framenum
--		self.nextthink = time + nexttime
--		self.think = nextthink
--		<code>

--/*
--================
--monster_use
--
--Using a monster makes it angry at the current activator
--================
--*/
function monster_use()
	if self.enemy ~= world then -- TODO check condition
		return
        end
	if self.health <= 0 then -- TODO check condition
		return
        end
	if activator.items & IT_INVISIBILITY == IT_INVISIBILITY then -- TODO check condition
		return
        end
	if activator.flags & FL_NOTARGET == FL_NOTARGET then -- TODO check condition
		return
        end
	if activator.classname ~= "player" then -- TODO check condition
		return
        end
	
-- delay reaction so if the monster is teleported, its sound is still
-- heard
	self.enemy = activator
	self.nextthink = time + 0.1
	self.think = FoundTarget
end

--/*
--================
--monster_death_use
--
--When a mosnter dies, it fires all of its targets with the current
--enemy as activator.
--================
--*/
function monster_death_use()
	local ent, otemp, stemp; -- entity

-- fall to ground
	if self.flags & FL_FLY == FL_FLY then -- TODO check condition
		self.flags = self.flags - FL_FLY
        end
	if self.flags & FL_SWIM == FL_SWIM then -- TODO check condition
		self.flags = self.flags - FL_SWIM
        end

	if  self.target == "" then -- TODO check condition
		return
        end

	activator = self.enemy
	SUB_UseTargets ()
end


--============================================================================

function walkmonster_start_go()
        local stemp; -- string
        local etemp; -- entity

	self.origin.z= self.origin.z+ 1	-- raise off floor a bit
	droptofloor(self)
	
	if  not walkmove(self, 0,0) then -- TODO check condition
		dprint ("walkmonster in wall at: ")
		dprint (vtos(self.origin))
		dprint ("\n")
	end
	
	self.takedamage = DAMAGE_AIM

	self.ideal_yaw = self.angles * vec3(0, 1, 0)
	if  not self.yaw_speed or self.yaw_speed == 0 then -- TODO check condition
		self.yaw_speed = 20
        end
	self.view_ofs = vec3(0, 0, 25)
	self.use = monster_use
	
	self.flags = self.flags | FL_MONSTER
	
	if self.target ~= "" then -- TODO check condition
                self.movetarget = find(world, "targetname", self.target)
                self.goalentity = self.movetarget 

		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin)
		if  not self.movetarget or self.movetarget == world then -- TODO check condition
			dprint ("Monster can't find target at ")
			dprint (vtos(self.origin))
			dprint ("\n")
		end


-- this used to be an objerror
		if self.movetarget and self.movetarget ~= world and self.movetarget.classname == "path_corner" then -- TODO check condition
			self.th_walk ()
		else
			self.pausetime = 99999999
                end
		self.th_stand ()
	else
		self.pausetime = 99999999
		self.th_stand ()
	end

-- spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5
end


function walkmonster_start()
-- delay drop to floor to make sure all doors have been spawned
-- spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5
	self.think = walkmonster_start_go
	qc.total_monsters = qc.total_monsters + 1
end



function flymonster_start_go()
	self.takedamage = DAMAGE_AIM

	self.ideal_yaw = self.angles * vec3(0, 1, 0)
	if  not self.yaw_speed or self.yaw_speed == 0 then -- TODO check condition
		self.yaw_speed = 10
        end
	self.view_ofs = vec3(0, 0, 25)
	self.use = monster_use

	self.flags = self.flags | FL_FLY
	self.flags = self.flags | FL_MONSTER

	if  not walkmove(self, 0,0) then -- TODO check condition
		dprint ("flymonster in wall at: ")
		dprint (vtos(self.origin))
		dprint ("\n")
	end

	if self.target ~= "" then -- TODO check condition
                self.movetarget = find(world, "targetname", self.target)
                self.goalentity = self.movetarget 
		if  not self.movetarget or self.movetarget == world then -- TODO check condition
			dprint ("Monster can't find target at ")
			dprint (vtos(self.origin))
			dprint ("\n")
		end
-- this used to be an objerror
		if self.movetarget.classname == "path_corner" then -- TODO check condition
			self.th_walk ()
		else
			self.pausetime = 99999999
                end
		self.th_stand ()
	else
		self.pausetime = 99999999
		self.th_stand ()
	end
end

function flymonster_start()
-- spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5
	self.think = flymonster_start_go
	qc.total_monsters = qc.total_monsters + 1
end


function swimmonster_start_go()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end

	self.takedamage = DAMAGE_AIM
	qc.total_monsters = qc.total_monsters + 1

	self.ideal_yaw = self.angles * vec3(0, 1, 0)
	if  not self.yaw_speed or self.yaw_speed == 0 then -- TODO check condition
		self.yaw_speed = 10
        end
	self.view_ofs = vec3(0, 0, 10)
	self.use = monster_use
	
	self.flags = self.flags | FL_SWIM
	self.flags = self.flags | FL_MONSTER

	if self.target ~= "" then -- TODO check condition
                self.movetarget = find(world, "targetname", self.target)
                self.goalentity = self.movetarget 
		if  not self.movetarget or self.movetarget == world then -- TODO check condition
			dprint ("Monster can't find target at ")
			dprint (vtos(self.origin))
			dprint ("\n")
		end
-- this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin)
		self.th_walk ()
	else
		self.pausetime = 99999999
		self.th_stand ()
	end

-- spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5
end

function swimmonster_start()
-- spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5
	self.think = swimmonster_start_go
	qc.total_monsters = qc.total_monsters + 1
end


