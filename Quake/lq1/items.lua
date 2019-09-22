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
--/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
--BE .8 .3 .4 IN COLOR */


function SUB_regen()
	self.model = self.mdl		-- restore original model
	self.solid = SOLID_TRIGGER	-- allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM)	-- play respawn sound
	setorigin (self, self.origin)
end



--/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
--prints a warning message when spawned
--*/
function noclass()
	dprint ("noclass spawned at")
	dprint (vtos(self.origin))
	dprint ("\n")
	remove (self)
end



--/*
--============
--PlaceItem
--
--plants the object on the floor
--============
--*/
function PlaceItem()
	local oldz; -- float

	self.mdl = self.model		-- so it can be restored on respawn
	self.flags = FL_ITEM		-- make extra wide
	self.solid = SOLID_TRIGGER
	self.movetype = MOVETYPE_TOSS	
	self.velocity = vec3(0, 0, 0)
	self.origin.z = self.origin.z + 6
	oldz = self.origin.z
	if  not droptofloor(self) then -- TODO check condition
		dprint ("Bonus item fell out of level at ")
		dprint (vtos(self.origin))
		dprint ("\n")
		remove(self)
		return
	end
end

--/*
--============
--StartItem
--
--Sets the clipping size and plants the object on the floor
--============
--*/
function StartItem()
	self.nextthink = time + 0.2	-- items start after other solids
	self.think = PlaceItem
end

--/*
--=========================================================================
--
--HEALTH BOX
--
--=========================================================================
--*/
--
-- T_Heal: add health to an entity, limiting health to max_health
-- "ignore" will ignore max_health limit
--
function T_Heal(e, healamount, ignore) -- entity, float, boolean
	if e.health <= 0 then -- TODO check condition
		return false
        end
	if ( not ignore)  and  (e.health >= other.max_health) then -- TODO check condition
		return false
        end
	healamount = ceil(healamount)

	e.health = e.health + healamount
	if ( not ignore)  and  (e.health >= other.max_health) then -- TODO check condition
		e.health = other.max_health
        end
		
	if e.health > 250 then -- TODO check condition
		e.health = 250
        end
	return true
end

--/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
--Health box. Normally gives 25 points.
--Rotten box heals 5-10 points,
--megahealth will add 100 health, then 
--rot you down to your maximum health limit, 
--one point per second.
--*/

local H_ROTTEN = 1 -- float
local H_MEGA = 2 -- float
local	healamount, healtype

function item_health()
	self.touch = health_touch

	if self.spawnflags & H_ROTTEN == H_ROTTEN then -- TODO check condition
		precache_model("maps/b_bh10.bsp")

		precache_sound("items/r_item1.wav")
		setmodel(self, "maps/b_bh10.bsp")
		self.noise = "items/r_item1.wav"
		self.healamount = 15
		self.healtype = 0
	elseif self.spawnflags & H_MEGA == H_MEGA then -- TODO check condition
		precache_model("maps/b_bh100.bsp")
		precache_sound("items/r_item2.wav")
		setmodel(self, "maps/b_bh100.bsp")
		self.noise = "items/r_item2.wav"
		self.healamount = 100
		self.healtype = 2
	else
		precache_model("maps/b_bh25.bsp")
		precache_sound("items/health1.wav")
		setmodel(self, "maps/b_bh25.bsp")
		self.noise = "items/health1.wav"
		self.healamount = 25
		self.healtype = 1
	end
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end


function health_touch()
	local amount; -- float
	local s; -- string
	
	if other.classname ~= "player" then -- TODO check condition
		return
        end
	
	if self.healtype == 2 then -- TODO check condition
		if other.health >= 250 then -- TODO check condition
			return
                end
		if  not T_Heal(other, self.healamount, true) then -- TODO check condition
			return
                end
	else
		if  not T_Heal(other, self.healamount, false) then -- TODO check condition
			return
                end
	end
	
	sprint(other, "You receive ")
	s = ftos(self.healamount)
	sprint(other, s)
	sprint(other, " health\n")
	
-- health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM)

	stuffcmd (other, "bf\n")
	
	self.model = string_null
	self.solid = SOLID_NOT

	-- Megahealth = rot down the player's super health
	if self.healtype == 2 then -- TODO check condition
		other.items = other.items | IT_SUPERHEALTH
		self.nextthink = time + 5
		self.think = item_megahealth_rot
		self.owner = other
	else
		if deathmatch ~= 2 then -- TODO check condition
			if deathmatch ~= 0 then -- TODO check condition
				self.nextthink = time + 20
                        end
			self.think = SUB_regen
		end
	end
	
	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end

function item_megahealth_rot()
	other = self.owner
	
	if other.health > other.max_health then -- TODO check condition
		other.health = other.health - 1
		self.nextthink = time + 1
		return
	end

-- it is possible for a player to die and respawn between rots, so don't
-- just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH)
	
	if deathmatch == 1 then -- TODO check condition
		self.nextthink = time + 20
		self.think = SUB_regen
	end
end

--/*
--===============================================================================
--
--ARMOR
--
--===============================================================================
--*/


function armor_touch()
	local type, value, bit; -- float
	
	if other.health <= 0 then -- TODO check condition
		return
        end
	if other.classname ~= "player" then -- TODO check condition
		return
        end

	if self.classname == "item_armor1" then -- TODO check condition
		type = 0.3
		value = 100
		bit = IT_ARMOR1
	end
	if self.classname == "item_armor2" then -- TODO check condition
		type = 0.6
		value = 150
		bit = IT_ARMOR2
	end
	if self.classname == "item_armorInv" then -- TODO check condition
		type = 0.8
		value = 200
		bit = IT_ARMOR3
	end
	if other.armortype*other.armorvalue >= type*value then -- TODO check condition
		return
        end
		
	other.armortype = type
	other.armorvalue = value
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit

	self.solid = SOLID_NOT
	self.model = string_null
	if deathmatch == 1 then -- TODO check condition
		self.nextthink = time + 20
        end
	self.think = SUB_regen

	sprint(other, "You got armor\n")
-- armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM)
	stuffcmd (other, "bf\n")
	
	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end


--/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function item_armor1()
	self.touch = armor_touch
	precache_model ("progs/armor.mdl")
	setmodel (self, "progs/armor.mdl")
	self.skin = 0
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function item_armor2()
	self.touch = armor_touch
	precache_model ("progs/armor.mdl")
	setmodel (self, "progs/armor.mdl")
	self.skin = 1
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function item_armorInv()
	self.touch = armor_touch
	precache_model ("progs/armor.mdl")
	setmodel (self, "progs/armor.mdl")
	self.skin = 2
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*
--===============================================================================
--
--WEAPONS
--
--===============================================================================
--*/

function bound_other_ammo()
	if other.ammo_shells > 100 then -- TODO check condition
		other.ammo_shells = 100
        end
	if other.ammo_nails > 200 then -- TODO check condition
		other.ammo_nails = 200
        end
	if other.ammo_rockets > 100 then -- TODO check condition
		other.ammo_rockets = 100		
        end
	if other.ammo_cells > 100 then -- TODO check condition
		other.ammo_cells = 100		
        end
end


function RankForWeapon(w) -- float
	if w == IT_LIGHTNING then -- TODO check condition
		return 1
        end
	if w == IT_ROCKET_LAUNCHER then -- TODO check condition
		return 2
        end
	if w == IT_SUPER_NAILGUN then -- TODO check condition
		return 3
        end
	if w == IT_GRENADE_LAUNCHER then -- TODO check condition
		return 4
        end
	if w == IT_SUPER_SHOTGUN then -- TODO check condition
		return 5
        end
	if w == IT_NAILGUN then -- TODO check condition
		return 6
        end
	return 7
end

--/*
--=============
--Deathmatch_Weapon
--
--Deathmatch weapon change rules for picking up a weapon
--
--.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells
--=============
--*/
function Deathmatch_Weapon(old, new) -- float, float
	local _or, nr; -- float

-- change self.weapon if desired
	_or = RankForWeapon (self.weapon)
	nr = RankForWeapon (new)
	if  nr < _or  then -- TODO check condition
		self.weapon = new
        end
end

--/*
--=============
--weapon_touch
--=============
--*/

function weapon_touch()
	local hadammo, best, new, old; -- float
	local stemp; -- entity
	local leave; -- float

	if  not (other.flags & FL_CLIENT == FL_CLIENT) then -- TODO check condition
		return
        end

-- if the player was using his best weapon, change up to the new one if better		
	stemp = self
	self = other
	best = W_BestWeapon()
	self = stemp

	if deathmatch == 2  or coop ~= 0 then -- TODO check condition
		leave = true
	else
		leave = false
        end
	
	if self.classname == "weapon_nailgun" then -- TODO check condition
		if leave  and  (other.items & IT_NAILGUN)  then -- TODO check condition
			return
                end
		hadammo = other.ammo_nails			
		new = IT_NAILGUN
		other.ammo_nails = other.ammo_nails + 30
	elseif self.classname == "weapon_supernailgun" then -- TODO check condition
		if leave  and  (other.items & IT_SUPER_NAILGUN)  then -- TODO check condition
			return
                end
		hadammo = other.ammo_rockets			
		new = IT_SUPER_NAILGUN
		other.ammo_nails = other.ammo_nails + 30
	elseif self.classname == "weapon_supershotgun" then -- TODO check condition
		if leave  and  (other.items & IT_SUPER_SHOTGUN)  then -- TODO check condition
			return
                end
		hadammo = other.ammo_rockets			
		new = IT_SUPER_SHOTGUN
		other.ammo_shells = other.ammo_shells + 5
	elseif self.classname == "weapon_rocketlauncher" then -- TODO check condition
		if leave  and  (other.items & IT_ROCKET_LAUNCHER)  then -- TODO check condition
			return
            end
		hadammo = other.ammo_rockets			
		new = IT_ROCKET_LAUNCHER
		other.ammo_rockets = other.ammo_rockets + 5
	elseif self.classname == "weapon_grenadelauncher" then -- TODO check condition
		if leave  and  (other.items & IT_GRENADE_LAUNCHER)  then -- TODO check condition
			return
                end
		hadammo = other.ammo_rockets			
		new = IT_GRENADE_LAUNCHER
		other.ammo_rockets = other.ammo_rockets + 5
	elseif self.classname == "weapon_lightning" then -- TODO check condition
		if leave  and  (other.items & IT_LIGHTNING)  then -- TODO check condition
			return
                end
		hadammo = other.ammo_rockets			
		new = IT_LIGHTNING
		other.ammo_cells = other.ammo_cells + 15
	else
                print(self.classname)
		objerror ("weapon_touch: unknown classname")
        end

	sprint (other, "You got the ")
	sprint (other, self.netname)
	sprint (other, "\n")
-- weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM)
	stuffcmd (other, "bf\n")

	bound_other_ammo ()

-- change to the weapon
	old = other.items
	other.items = other.items | new
	
	stemp = self
	self = other

	if  deathmatch == 0 then -- TODO check condition
		self.weapon = new
	else
		Deathmatch_Weapon (old, new)
        end

	W_SetCurrentAmmo()

	self = stemp

	if leave then -- TODO check condition
		return
        end

-- remove it in single player, or setup for respawning in deathmatch
	self.model = string_null
	self.solid = SOLID_NOT
	if deathmatch ~= 0 then -- TODO check condition
		self.nextthink = time + 30
        end
	self.think = SUB_regen
	
	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end


--/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_supershotgun()
	precache_model ("progs/g_shot.mdl")
	setmodel (self, "progs/g_shot.mdl")
	self.weapon = IT_SUPER_SHOTGUN
	self.netname = "Double-barrelled Shotgun"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_nailgun()
	precache_model ("progs/g_nail.mdl")
	setmodel (self, "progs/g_nail.mdl")
	self.weapon = IT_NAILGUN
	self.netname = "nailgun"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_supernailgun()
	precache_model ("progs/g_nail2.mdl")
	setmodel (self, "progs/g_nail2.mdl")
	self.weapon = IT_SUPER_NAILGUN
	self.netname = "Super Nailgun"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_grenadelauncher()
	precache_model ("progs/g_rock.mdl")
	setmodel (self, "progs/g_rock.mdl")
	self.weapon = 3
	self.netname = "Grenade Launcher"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end

--/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_rocketlauncher()
	precache_model ("progs/g_rock2.mdl")
	setmodel (self, "progs/g_rock2.mdl")
	self.weapon = 3
	self.netname = "Rocket Launcher"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end


--/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
--*/

function weapon_lightning()
	precache_model ("progs/g_light.mdl")
	setmodel (self, "progs/g_light.mdl")
	self.weapon = 3
	self.netname = "Thunderbolt"
	self.touch = weapon_touch
	setsize (self, vec3(-16, -16, 0), vec3(16, 16, 56))
	StartItem ()
end


--/*
--===============================================================================
--
--AMMO
--
--===============================================================================
--*/

function ammo_touch()
        local stemp; -- entity
        local best; -- float

	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if other.health <= 0 then -- TODO check condition
		return
        end

-- if the player was using his best weapon, change up to the new one if better		
	stemp = self
	self = other
	best = W_BestWeapon()
	self = stemp


-- shotgun
	if self.weapon == 1 then -- TODO check condition
		if other.ammo_shells >= 100 then -- TODO check condition
			return
                end
		other.ammo_shells = other.ammo_shells + self.aflag
	end

-- spikes
	if self.weapon == 2 then -- TODO check condition
		if other.ammo_nails >= 200 then -- TODO check condition
			return
                end
		other.ammo_nails = other.ammo_nails + self.aflag
	end

--	rockets
	if self.weapon == 3 then -- TODO check condition
		if other.ammo_rockets >= 100 then -- TODO check condition
			return
                end
		other.ammo_rockets = other.ammo_rockets + self.aflag
	end

--	cells
	if self.weapon == 4 then -- TODO check condition
		if other.ammo_cells >= 200 then -- TODO check condition
			return
                end
		other.ammo_cells = other.ammo_cells + self.aflag
	end

	bound_other_ammo ()
	
	sprint (other, "You got the ")
	sprint (other, self.netname)
	sprint (other, "\n")
-- ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM)
	stuffcmd (other, "bf\n")

-- change to a better weapon if appropriate

	if  other.weapon == best  then -- TODO check condition
		stemp = self
		self = other
		self.weapon = W_BestWeapon()
		W_SetCurrentAmmo ()
		self = stemp
	end

-- if changed current ammo, update it
	stemp = self
	self = other
	W_SetCurrentAmmo()
	self = stemp

-- remove it in single player, or setup for respawning in deathmatch
	self.model = string_null
	self.solid = SOLID_NOT
	if deathmatch ~= 0 then -- TODO check condition
		self.nextthink = time + 30
        end
	
	self.think = SUB_regen

	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end




local WEAPON_BIG2 = 1 -- float

--/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
--*/

function item_shells()
	self.touch = ammo_touch

	if self.spawnflags & WEAPON_BIG2 == WEAPON_BIG2 then -- TODO check condition
		precache_model ("maps/b_shell1.bsp")
		setmodel (self, "maps/b_shell1.bsp")
		self.aflag = 40
	else
		precache_model ("maps/b_shell0.bsp")
		setmodel (self, "maps/b_shell0.bsp")
		self.aflag = 20
	end
	self.weapon = 1
	self.netname = "shells"
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end

--/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
--*/

function item_spikes()
	self.touch = ammo_touch

	if self.spawnflags & WEAPON_BIG2 == WEAPON_BIG2 then -- TODO check condition
		precache_model ("maps/b_nail1.bsp")
		setmodel (self, "maps/b_nail1.bsp")
		self.aflag = 50
	else
		precache_model ("maps/b_nail0.bsp")
		setmodel (self, "maps/b_nail0.bsp")
		self.aflag = 25
	end
	self.weapon = 2
	self.netname = "nails"
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end

--/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
--*/

function item_rockets()
	self.touch = ammo_touch

	if self.spawnflags & WEAPON_BIG2 == WEAPON_BIG2 then -- TODO check condition
		precache_model ("maps/b_rock1.bsp")
		setmodel (self, "maps/b_rock1.bsp")
		self.aflag = 10
	else
		precache_model ("maps/b_rock0.bsp")
		setmodel (self, "maps/b_rock0.bsp")
		self.aflag = 5
	end
	self.weapon = 3
	self.netname = "rockets"
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end


--/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
--*/

function item_cells()
	self.touch = ammo_touch

	if self.spawnflags & WEAPON_BIG2 == WEAPON_BIG2 then -- TODO check condition
		precache_model ("maps/b_batt1.bsp")
		setmodel (self, "maps/b_batt1.bsp")
		self.aflag = 12
	else
		precache_model ("maps/b_batt0.bsp")
		setmodel (self, "maps/b_batt0.bsp")
		self.aflag = 6
	end
	self.weapon = 4
	self.netname = "cells"
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end


--/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
--DO NOT USE THIS not  not  not  not  IT WILL BE REMOVED not 
--*/

local WEAPON_SHOTGUN = 1 -- float
local WEAPON_ROCKET = 2 -- float
local WEAPON_SPIKES = 4 -- float
local WEAPON_BIG = 8 -- float
function item_weapon()
	self.touch = ammo_touch

	if self.spawnflags & WEAPON_SHOTGUN == WEAPON_SHOTGUN then -- TODO check condition
		if self.spawnflags & WEAPON_BIG == WEAPON_BIG then -- TODO check condition
			precache_model ("maps/b_shell1.bsp")
			setmodel (self, "maps/b_shell1.bsp")
			self.aflag = 40
		else
			precache_model ("maps/b_shell0.bsp")
			setmodel (self, "maps/b_shell0.bsp")
			self.aflag = 20
		end
		self.weapon = 1
		self.netname = "shells"
	end

	if self.spawnflags & WEAPON_SPIKES == WEAPON_SPIKES then -- TODO check condition
		if self.spawnflags & WEAPON_BIG == WEAPON_BIG then -- TODO check condition
			precache_model ("maps/b_nail1.bsp")
			setmodel (self, "maps/b_nail1.bsp")
			self.aflag = 40
		else
			precache_model ("maps/b_nail0.bsp")
			setmodel (self, "maps/b_nail0.bsp")
			self.aflag = 20
		end
		self.weapon = 2
		self.netname = "spikes"
	end

	if self.spawnflags & WEAPON_ROCKET == WEAPON_ROCKET then -- TODO check condition
		if self.spawnflags & WEAPON_BIG == WEAPON_BIG then -- TODO check condition
			precache_model ("maps/b_rock1.bsp")
			setmodel (self, "maps/b_rock1.bsp")
			self.aflag = 10
		else
			precache_model ("maps/b_rock0.bsp")
			setmodel (self, "maps/b_rock0.bsp")
			self.aflag = 5
		end
		self.weapon = 3
		self.netname = "rockets"
	end
	
	setsize (self, vec3(0, 0, 0), vec3(32, 32, 56))
	StartItem ()
end


--/*
--===============================================================================
--
--KEYS
--
--===============================================================================
--*/

function key_touch()
        local stemp; -- entity
        local best; -- float

	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if other.health <= 0 then -- TODO check condition
		return
        end
	if other.items & self.items ~= 0 then -- TODO check condition
		return
        end

	sprint (other, "You got the ")
	sprint (other, self.netname)
	sprint (other,"\n")

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM)
	stuffcmd (other, "bf\n")
	other.items = other.items | self.items

	if coop == 0 then -- TODO check condition
		self.solid = SOLID_NOT
		self.model = string_null
	end

	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end


function key_setsounds()
	if world.worldtype == 0 then -- TODO check condition
		precache_sound ("misc/medkey.wav")
		self.noise = "misc/medkey.wav"
	end
	if world.worldtype == 1 then -- TODO check condition
		precache_sound ("misc/runekey.wav")
		self.noise = "misc/runekey.wav"
	end
	if world.worldtype == 2 then -- TODO check condition
		precache_sound2 ("misc/basekey.wav")
		self.noise = "misc/basekey.wav"
	end
end

--/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
--SILVER key
--In order for keys to work
--you MUST set your maps
--worldtype to one of the
--following:
--0: medieval
--1: metal
--2: base
--*/

function item_key1()
	if world.worldtype == 0 then -- TODO check condition
		precache_model ("progs/w_s_key.mdl")
		setmodel (self, "progs/w_s_key.mdl")
		self.netname = "silver key"
	elseif world.worldtype == 1 then -- TODO check condition
		precache_model ("progs/m_s_key.mdl")
		setmodel (self, "progs/m_s_key.mdl")
		self.netname = "silver runekey"
	elseif world.worldtype == 2 then -- TODO check condition
		precache_model2 ("progs/b_s_key.mdl")
		setmodel (self, "progs/b_s_key.mdl")
		self.netname = "silver keycard"
	end
	key_setsounds()
	self.touch = key_touch
	self.items = IT_KEY1
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end

--/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
--GOLD key
--In order for keys to work
--you MUST set your maps
--worldtype to one of the
--following:
--0: medieval
--1: metal
--2: base
--*/

function item_key2()
	if world.worldtype == 0 then -- TODO check condition
		precache_model ("progs/w_g_key.mdl")
		setmodel (self, "progs/w_g_key.mdl")
		self.netname = "gold key"
	end
	if world.worldtype == 1 then -- TODO check condition
		precache_model ("progs/m_g_key.mdl")
		setmodel (self, "progs/m_g_key.mdl")
		self.netname = "gold runekey"
	end
	if world.worldtype == 2 then -- TODO check condition
		precache_model2 ("progs/b_g_key.mdl")
		setmodel (self, "progs/b_g_key.mdl")
		self.netname = "gold keycard"
	end
	key_setsounds()
	self.touch = key_touch
	self.items = IT_KEY2
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end



--/*
--===============================================================================
--
--END OF LEVEL RUNES
--
--===============================================================================
--*/

function sigil_touch()
        local stemp; -- entity
        local best; -- float

	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if other.health <= 0 then -- TODO check condition
		return
        end

	centerprint (other, "You got the rune!")

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM)
	stuffcmd (other, "bf\n")
	self.solid = SOLID_NOT
	self.model = string_null
	qc.serverflags = qc.serverflags | (self.spawnflags & 15)
	self.classname = ""		-- so rune doors won't find it
	
	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end


--/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
--End of level sigil, pick up to end episode and return to jrstart.
--*/

function item_sigil()
	if  self.spawnflags == 0 then -- TODO check condition
		objerror ("no spawnflags")
        end

	precache_sound ("misc/runekey.wav")
	self.noise = "misc/runekey.wav"

	if self.spawnflags & 1 == 1  then -- TODO check condition
		precache_model ("progs/end1.mdl")
		setmodel (self, "progs/end1.mdl")
	end
	if self.spawnflags & 2 == 2 then -- TODO check condition
		precache_model2 ("progs/end2.mdl")
		setmodel (self, "progs/end2.mdl")
	end
	if self.spawnflags & 4 == 4 then -- TODO check condition
		precache_model2 ("progs/end3.mdl")
		setmodel (self, "progs/end3.mdl")
	end
	if self.spawnflags & 8 == 8 then -- TODO check condition
		precache_model2 ("progs/end4.mdl")
		setmodel (self, "progs/end4.mdl")
	end
	
	self.touch = sigil_touch
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end

--/*
--===============================================================================
--
--POWERUPS
--
--===============================================================================
--*/



function powerup_touch()
        local stemp; -- entity
        local best; -- float

	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if other.health <= 0 then -- TODO check condition
		return
        end

	sprint (other, "You got the ")
	sprint (other, self.netname)
	sprint (other,"\n")

	if deathmatch ~= 0 then -- TODO check condition
		self.mdl = self.model
		
		if (self.classname == "item_artifact_invulnerability" or -- TODO check condition
			(self.classname == "item_artifact_invisibility")) then
			self.nextthink = time + 60*5
		else
			self.nextthink = time + 60
                end
		
		self.think = SUB_regen
	end

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM)
	stuffcmd (other, "bf\n")
	self.solid = SOLID_NOT
	other.items = other.items | self.items
	self.model = string_null

-- do the apropriate action
	if self.classname == "item_artifact_envirosuit" then -- TODO check condition
		other.rad_time = 1
		other.radsuit_finished = time + 30
	end
	
	if self.classname == "item_artifact_invulnerability" then -- TODO check condition
		other.invincible_time = 1
		other.invincible_finished = time + 30
	end
	
	if self.classname == "item_artifact_invisibility" then -- TODO check condition
		other.invisible_time = 1
		other.invisible_finished = time + 30
	end

	if self.classname == "item_artifact_super_damage" then -- TODO check condition
		other.super_time = 1
		other.super_damage_finished = time + 30
	end

	activator = other
	SUB_UseTargets()				-- fire all targets / killtargets
end



--/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
--Player is invulnerable for 30 seconds
--*/
function item_artifact_invulnerability()
	self.touch = powerup_touch

	precache_model ("progs/invulner.mdl")
	precache_sound ("items/protect.wav")
	precache_sound ("items/protect2.wav")
	precache_sound ("items/protect3.wav")
	self.noise = "items/protect.wav"
	setmodel (self, "progs/invulner.mdl")
	self.netname = "Pentagram of Protection"
	self.items = IT_INVULNERABILITY
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end

--/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
--Player takes no damage from water or slime for 30 seconds
--*/
function item_artifact_envirosuit()
	self.touch = powerup_touch

	precache_model ("progs/suit.mdl")
	precache_sound ("items/suit.wav")
	precache_sound ("items/suit2.wav")
	self.noise = "items/suit.wav"
	setmodel (self, "progs/suit.mdl")
	self.netname = "Biosuit"
	self.items = IT_SUIT
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end


--/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
--Player is invisible for 30 seconds
--*/
function item_artifact_invisibility()
	self.touch = powerup_touch

	precache_model ("progs/invisibl.mdl")
	precache_sound ("items/inv1.wav")
	precache_sound ("items/inv2.wav")
	precache_sound ("items/inv3.wav")
	self.noise = "items/inv1.wav"
	setmodel (self, "progs/invisibl.mdl")
	self.netname = "Ring of Shadows"
	self.items = IT_INVISIBILITY
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end


--/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
--The next attack from the player will do 4x damage
--*/
function item_artifact_super_damage()
	self.touch = powerup_touch

	precache_model ("progs/quaddama.mdl")
	precache_sound ("items/damage.wav")
	precache_sound ("items/damage2.wav")
	precache_sound ("items/damage3.wav")
	self.noise = "items/damage.wav"
	setmodel (self, "progs/quaddama.mdl")
	self.netname = "Quad Damage"
	self.items = IT_QUAD
	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 32))
	StartItem ()
end



--/*
--===============================================================================
--
--PLAYER BACKPACKS
--
--===============================================================================
--*/

function BackpackTouch()
	local s; -- string
	local best; -- float
	local stemp; -- entity
	
	if other.classname ~= "player" then -- TODO check condition
		return
        end
	if other.health <= 0 then -- TODO check condition
		return
        end
		
-- if the player was using his best weapon, change up to the new one if better		
	stemp = self
	self = other
	best = W_BestWeapon()
	self = stemp

-- change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells
	other.ammo_nails = other.ammo_nails + self.ammo_nails
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets
	other.ammo_cells = other.ammo_cells + self.ammo_cells

	other.items = other.items | self.items
	
	bound_other_ammo ()

	sprint (other, "You get ")

	if self.ammo_shells ~= 0 then -- TODO check condition
		s = ftos(self.ammo_shells)
		sprint (other, s)
		sprint (other, " shells  ")
	end
	if self.ammo_nails ~= 0 then -- TODO check condition
		s = ftos(self.ammo_nails)
		sprint (other, s)
		sprint (other, " nails ")
	end
	if self.ammo_rockets ~= 0 then -- TODO check condition
		s = ftos(self.ammo_rockets)
		sprint (other, s)
		sprint (other, " rockets  ")
	end
	if self.ammo_cells ~= 0 then -- TODO check condition
		s = ftos(self.ammo_cells)
		sprint (other, s)
		sprint (other, " cells  ")
	end
	
	sprint (other, "\n")
-- backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM)
	stuffcmd (other, "bf\n")

-- change to a better weapon if appropriate
	if  other.weapon == best  then -- TODO check condition
		stemp = self
		self = other
		self.weapon = W_BestWeapon()
		self = stemp
	end

	
	remove(self)
	
	self = other
	W_SetCurrentAmmo ()
end

--/*
--===============
--DropBackpack
--===============
--*/
function DropBackpack()
	local item; -- entity

	if  (self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells) == 0 then -- TODO check condition
		return	-- nothing in it
        end

	item = spawn()
	item.origin = self.origin - vec3(0, 0, 24)
	
	item.items = self.weapon

	item.ammo_shells = self.ammo_shells
	item.ammo_nails = self.ammo_nails
	item.ammo_rockets = self.ammo_rockets
	item.ammo_cells = self.ammo_cells

	item.velocity.z = 300
	item.velocity.x = -100 + (random() * 200)
	item.velocity.y = -100 + (random() * 200)
	
	item.flags = FL_ITEM
	item.solid = SOLID_TRIGGER
	item.movetype = MOVETYPE_TOSS
	setmodel (item, "progs/backpack.mdl")
	setsize (item, vec3(-16, -16, 0), vec3(16, 16, 56))
	item.touch = BackpackTouch
	
	item.nextthink = time + 120	-- remove after 2 minutes
	item.think = SUB_Remove
end
