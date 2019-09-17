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
--
--.enemy
--Will be world if not currently angry at anyone.
--
--.movetarget
--The next path spot to walk toward.  If .enemy, ignore .movetarget.
--When an enemy is killed, the monster will try to return to it's path.
--
--.huntt_ime
--Set to time + something when the player is in sight, but movement straight for
--him is blocked.  This causes the monster to use wall following code for
--movement direction instead of sighting on the player.
--
--.ideal_yaw
--A yaw angle of the intended direction, which will be turned towards at up
--to 45 deg / state.  If the enemy is in view and hunt_time is not active,
--this will be the exact line towards the enemy.
--
--.pausetime
--A monster will leave it's stand state and head towards it's .movetarget when
--time > .pausetime.
--
--walkmove(angle, speed) primitive is all or nothing
--*/


--
-- globals
--
local current_yaw -- float

--
-- when a monster becomes angry at a player, that monster will be used
-- as the sight target the next frame so that monsters near that one
-- will wake up even if they wouldn't have noticed the player
--
local sight_entity -- entity
local sight_entity_time -- float

function anglemod(v) -- float
	while v >= 360 do -- TODO check condition
		v = v - 360
        end
	while v < 0 do -- TODO check condition
		v = v + 360
        end
	return v
end

--/*
--==============================================================================
--
--MOVETARGET CODE
--
--The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.
--
--targetname
--must be present.  The name of this movetarget.
--
--target
--the next spot to move to.  If not present, stop here for good.
--
--pausetime
--The number of seconds to spend standing or bowing for path_stand or path_bow
--
--==============================================================================
--*/


function movetarget_f()
	if  self.targetname == "" then
		objerror ("monster_movetarget: no targetname")
        end
		
	self.solid = SOLID_TRIGGER
	self.touch = t_movetarget
	setsize (self, vec3(-8, -8, -8), vec3(8, 8, 8))
end

--/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
--Monsters will continue walking towards the next target corner.
--*/
function path_corner()
	movetarget_f ()
end


--/*
--=============
--t_movetarget
--
--Something has bumped into a movetarget.  If it is a monster
--moving towards it, change the next destination and continue.
--==============
--*/
function t_movetarget()
        local temp; -- entity

	if other.movetarget ~= self then -- TODO check condition
		return
        end
	
	if other.enemy ~= world then -- TODO check condition
		return		-- fighting, not following a path
        end

	temp = self
	self = other
	other = temp

	if self.classname == "monster_ogre" then -- TODO check condition
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE)-- play chainsaw drag sound
        end

        --dprint ("t_movetarget\n")
        self.movetarget = find (world, "targetname", other.target)
        self.goalentity = self.movetarget
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin)
	if  self.movetarget == world then -- TODO check condition
		self.pausetime = time + 999999
		self.th_stand ()
		return
	end
end



--============================================================================

--/*
--=============
--range
--
--returns the range catagorization of an entity reletive to self
--0	melee range, will become hostile even if back is turned
--1	visibility and infront, or visibility and show hostile
--2	infront and show hostile
--3	only triggered by damage
--=============
--*/
function range(targ) -- entity
        local spot1, spot2; -- vector
        local r;	 -- float
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs
	
	r = vlen (spot1 - spot2)
	if r < 120 then -- TODO check condition
		return RANGE_MELEE
        end
	if r < 500 then -- TODO check condition
		return RANGE_NEAR
        end
	if r < 1000 then -- TODO check condition
		return RANGE_MID
        end
	return RANGE_FAR
end

--/*
--=============
--visible
--
--returns 1 if the entity is visible to self, even if not infront ()
--=============
--*/
function visible(targ) -- entity
	local spot1, spot2; -- vector
	
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs
	traceline (spot1, spot2, true, self)	-- see through other monsters
	
	if qc.trace_inopen  and  qc.trace_inwater then -- TODO check condition
		return false			-- sight line crossed contents
        end

	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end
	return false
end


--/*
--=============
--infront
--
--returns 1 if the entity is in front (in sight) of self
--=============
--*/
function infront(targ) -- entity
	local vec; -- vector
	local dot; -- float
	
	makevectors (self.angles)
	vec = normalize (targ.origin - self.origin)
	dot = vec % qc.v_forward
	
	if  dot > 0.3 then -- TODO check condition
		return true
	end
	return false
end

function HuntTarget()
        self.goalentity = self.enemy;
	self.think = self.th_run
        if self.enemy ~= world then 
	        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin)
        end
	self.nextthink = time + 0.1
	SUB_AttackFinished (1)	-- wait a while before first attack
end

function SightSound()
        local rsnd; -- float

	if self.classname == "monster_ogre" then -- TODO check condition
		sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_knight" then -- TODO check condition
		sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_shambler" then -- TODO check condition
		sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_demon1" then -- TODO check condition
		sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_wizard" then -- TODO check condition
		sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_zombie" then -- TODO check condition
		sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_dog" then -- TODO check condition
		sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_hell_knight" then -- TODO check condition
		sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_tarbaby" then -- TODO check condition
		sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_vomit" then -- TODO check condition
		sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_enforcer" then -- TODO check condition
		rsnd = rint(random() * 3)			
		if rsnd == 1 then -- TODO check condition
			sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM)
		elseif rsnd == 2 then -- TODO check condition
			sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM)
		elseif rsnd == 0 then -- TODO check condition
			sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM)
		else
			sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM)
                end
	elseif self.classname == "monster_army" then -- TODO check condition
		sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM)
	elseif self.classname == "monster_shalrath" then -- TODO check condition
		sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM)
        end
end

function FoundTarget()
	if self.enemy ~= world and self.enemy.classname == "player" then -- TODO check condition
                sight_entity = self
		sight_entity_time = time
	end
	
	self.show_hostile = time + 1		-- wake up other monsters

	SightSound ()
	HuntTarget ()
end

--/*
--===========
--FindTarget
--
--Self is currently not attacking anything, so try to find a target
--
--Returns true if an enemy was sighted
--
--When a player fires a missile, the point of impact becomes a fakeplayer so
--that monsters that see the impact will respond as if they had seen the
--player.
--
--To avoid spending too much time, only a single client (or fakeclient) is
--checked each frame.  This means multi player games will have slightly
--slower noticing monsters.
--============
--*/
local sight_entity_time = 0
function FindTarget()
	local client; -- entity
	local r; -- float
-- if the first spawnflag bit is set, the monster will only wake up on
-- really seeing the player, not another monster getting angry

-- spawnflags & 3 is a big hack, because zombie crucified used the first
-- spawn flag prior to the ambush flag, and I forgot about it, so the second
-- spawn flag works as well
	if sight_entity_time >= time - 0.1  and   not (self.spawnflags & 3 == 0)  then -- TODO check condition
		client = sight_entity
		if client.enemy == self.enemy then -- TODO check condition
			return false
                end
	else
		client = checkclient (self)
		if  client == world then -- TODO check condition
			return false	-- current check entity isn't in PVS
                end
	end

	if client == self.enemy then -- TODO check condition
		return false
        end

	if client.flags & FL_NOTARGET == FL_NOTARGET then -- TODO check condition
		return false
        end
	if client.items & IT_INVISIBILITY == IT_INVISIBILITY then -- TODO check condition
		return false
        end

	r = range (client)
	if r == RANGE_FAR then -- TODO check condition
		return false
        end
		
	if  not visible (client) then -- TODO check condition
		return false
        end

	if r == RANGE_NEAR then -- TODO check condition
		if client.show_hostile < time  and   not infront (client) then -- TODO check condition
			return false
                end
	elseif r == RANGE_MID then -- TODO check condition
--		if  /* client.show_hostile < time  or  */  not infront (client) then -- TODO check condition
		if  not infront (client) then -- TODO check condition
			return false
                end
	end
	
--
-- got one
--
	self.enemy = client
	if self.enemy.classname ~= "player" then -- TODO check condition
		self.enemy = self.enemy.enemy
		if self.enemy.classname ~= "player" then -- TODO check condition
			self.enemy = world
			return false
		end
	end
	
	FoundTarget ()

	return true
end


--=============================================================================

function ai_forward(dist) -- float
	walkmove (self, self.angles.y, dist)
end

function ai_back(dist) -- float
	walkmove (self, (self.angles.y+180), dist)
end


--/*
--=============
--ai_pain
--
--stagger back a bit
--=============
--*/
function ai_pain(dist) -- float
	ai_back (dist)
--/*
--	local away; -- float
--	
--	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
--	+ 180*(random()- 0.5) )
--	
--	walkmove (away, dist)
--*/
end

--/*
--=============
--ai_painforward
--
--stagger back a bit
--=============
--*/
function ai_painforward(dist) -- float
	walkmove (self, self.ideal_yaw, dist)
end

--/*
--=============
--ai_walk
--
--The monster is walking it's beat
--=============
--*/
function ai_walk(dist) -- float
	local mtemp; -- vector
	
	movedist = dist
	
	if self.classname == "monster_dragon" then -- TODO check condition
		movetogoal (dist)
		return
	end
	-- check for noticing a player
	if FindTarget () then -- TODO check condition
		return
        end

	movetogoal (self, dist)
end


--/*
--=============
--ai_stand
--
--The monster is staying in one place for a while, with slight angle turns
--=============
--*/
function ai_stand()
	if FindTarget () then -- TODO check condition
		return
        end
	
        if not self.pausetime then self.pausetime = 0 end
	if time > self.pausetime then -- TODO check condition
		self.th_walk ()
		return
	end
	
-- change angle slightly

end

--/*
--=============
--ai_turn
--
--don't move, but turn towards ideal_yaw
--=============
--*/
function ai_turn()
	if FindTarget () then -- TODO check condition
		return
        end
	
	changeyaw (self)
end

--=============================================================================

--/*
--=============
--ChooseTurn
--=============
--*/
function ChooseTurn(dest3) -- vector
	local dir, newdir; -- vector
	
	dir = self.origin - dest3

	newdir.x = qc.trace_plane_normal.y
	newdir.y = 0 - qc.trace_plane_normal.x
	newdir.z = 0
	
	if dir * newdir > 0 then -- TODO check condition
		dir.x = 0 - qc.trace_plane_normal.y
		dir.y = qc.trace_plane_normal.x
	else
		dir.x = qc.trace_plane_normal.y
		dir.y = 0 - qc.trace_plane_normal.x
	end

	dir.z = 0
	self.ideal_yaw = vectoyaw(dir)	
end

--/*
--============
--FacingIdeal
--
--============
--*/
function FacingIdeal()
	local delta; -- float
	
	delta = anglemod(self.angles.y - self.ideal_yaw)
	if delta > 45  and  delta < 315 then -- TODO check condition
		return false
        end
	return true
end


--=============================================================================


function CheckAnyAttack()
	if  not enemy_vis then -- TODO check condition
		return
        end
	if self.classname == "monster_army" then -- TODO check condition
		return SoldierCheckAttack ()
        end
	if self.classname == "monster_ogre" then -- TODO check condition
		return OgreCheckAttack ()
        end
	if self.classname == "monster_shambler" then -- TODO check condition
		return ShamCheckAttack ()
        end
	if self.classname == "monster_demon1" then -- TODO check condition
		return DemonCheckAttack ()
        end
	if self.classname == "monster_dog" then -- TODO check condition
		return DogCheckAttack ()
        end
	if self.classname == "monster_wizard" then -- TODO check condition
		return WizardCheckAttack ()
        end
	return CheckAttack ()
end


--/*
--=============
--ai_run_melee
--
--Turn and close until within an angle to launch a melee attack
--=============
--*/
function ai_run_melee()
	self.ideal_yaw = enemy_yaw
	changeyaw (self)

	if FacingIdeal() then -- TODO check condition
		self.th_melee ()
		self.attack_state = AS_STRAIGHT
	end
end


--/*
--=============
--ai_run_missile
--
--Turn in place until within an angle to launch a missile attack
--=============
--*/
function ai_run_missile()
	self.ideal_yaw = enemy_yaw
	changeyaw (self)
	if FacingIdeal() then -- TODO check condition
		self.th_missile ()
		self.attack_state = AS_STRAIGHT
	end
end


--/*
--=============
--ai_run_slide
--
--Strafe sideways, but stay at aproximately the same range
--=============
--*/
function ai_run_slide()
	local ofs; -- float
	
	self.ideal_yaw = enemy_yaw
	changeyaw (self)
	if self.lefty then -- TODO check condition
		ofs = 90
	else
		ofs = -90
        end
	
	if walkmove (self, self.ideal_yaw + ofs, movedist) then -- TODO check condition
		return
        end

	self.lefty = not self.lefty
	
	walkmove (self, self.ideal_yaw - ofs, movedist)
end


--/*
--=============
--ai_run
--
--The monster has an enemy it is trying to kill
--=============
--*/
function ai_run(dist) -- float
	local delta; -- vector
	local axis; -- float
	local direct, ang_rint, ang_floor, ang_ceil; -- float
	
	movedist = dist
-- see if the enemy is dead
	if self.enemy ~= world and self.enemy.health <= 0 then -- TODO check condition
		self.enemy = world
	-- FIXME: look all around for other targets
		if self.oldenemy and self.oldenemy.health > 0 then -- TODO check condition
			self.enemy = self.oldenemy
			HuntTarget ()
		else
			if self.movetarget ~= world then -- TODO check condition
				self.th_walk ()
			else
				self.th_stand ()
                        end
			return
		end
	end

	self.show_hostile = time + 1		-- wake up other monsters

-- check knowledge of enemy
	enemy_vis = visible(self.enemy)
	if enemy_vis then -- TODO check condition
		self.search_time = time + 5
        end

-- look for other coop players
	if coop ~= 0 and self.search_time < time then -- TODO check condition
		if FindTarget () then -- TODO check condition
			return
                end
	end

	enemy_infront = infront(self.enemy)
	enemy_range = range(self.enemy)
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin)
	
	if self.attack_state == AS_MISSILE then -- TODO check condition
--dprint ("ai_run_missile\n")
		ai_run_missile ()
		return
	end
	if self.attack_state == AS_MELEE then -- TODO check condition
--dprint ("ai_run_melee\n")
		ai_run_melee ()
		return
	end

	if CheckAnyAttack () then -- TODO check condition
		return					-- beginning an attack
        end
		
	if self.attack_state == AS_SLIDING then -- TODO check condition
		ai_run_slide ()
		return
	end
		
-- head straight in
	movetogoal (self, dist)		-- done in C code...
end

