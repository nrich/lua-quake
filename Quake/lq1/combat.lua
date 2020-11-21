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



--============================================================================

--/*
--============
--CanDamage
--
--Returns true if the inflictor can directly damage the target.  Used for
--explosions and melee attacks.
--============
--*/
function CanDamage(targ, inflictor) -- entity, entity
-- bmodels need special checking because their origin is 0,0,0
	if targ.movetype == MOVETYPE_PUSH then -- TODO check condition
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), true, self)
		if qc.trace_fraction == 1 then -- TODO check condition
			return true
                end
		if qc.trace_ent == targ then -- TODO check condition
			return true
                end
		return false
	end
	
	traceline(inflictor.origin, targ.origin, true, self)
	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end
	traceline(inflictor.origin, targ.origin + vec3(15, 15, 0), true, self)
	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end
	traceline(inflictor.origin, targ.origin + vec3(-15, -15, 0), true, self)
	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end
	traceline(inflictor.origin, targ.origin + vec3(-15, 15, 0), true, self)
	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end
	traceline(inflictor.origin, targ.origin + vec3(15, -15, 0), true, self)
	if qc.trace_fraction == 1 then -- TODO check condition
		return true
        end

	return false
end


--/*
--============
--Killed
--============
--*/
function Killed(targ, attacker) -- entity, entity
	local oself; -- entity

	oself = self
	self = targ
	
	if self.health < -99 then -- TODO check condition
		self.health = -99		-- don't let sbar look bad if a player
        end

	if self.movetype == MOVETYPE_PUSH  or  self.movetype == MOVETYPE_NONE then -- TODO check condition
		self.th_die ()
		self = oself
		return
	end

	self.enemy = attacker

-- bump the monster counter
	if self.flags & FL_MONSTER == FL_MONSTER then -- TODO check condition
		qc.killed_monsters = qc.killed_monsters + 1
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER)
	end

	ClientObituary(self, attacker)
	
	self.takedamage = DAMAGE_NO
	self.touch = SUB_Null

	monster_death_use()
	self.th_die ()
	
	self = oself
end


--/*
--============
--T_Damage
--
--The damage is coming from inflictor, but get mad at attacker
--This should be the only function that ever reduces health.
--============
--*/
function T_Damage(targ, inflictor, attacker, damage) -- entity, entity, entity, float
	local dir; -- vector
	local oldself; -- entity
	local save; -- float
	local take; -- float

        if targ == world then
                return
        end

	if targ.takedamage == 0 then -- TODO check condition
		return
        end

        if not targ.invincible_finished then targ.invincible_finished = 0 end
        if not attacker.super_damage_finished then attacker.super_damage_finished = 0 end

-- used by buttons and triggers to set activator for target firing
	damage_attacker = attacker

-- check for quad damage powerup on the attacker
	if attacker.super_damage_finished > time then -- TODO check condition
		damage = damage * 4
        end

-- save damage based on the target's armor level

	save = ceil(targ.armortype*damage)
	if save >= targ.armorvalue then -- TODO check condition
		save = targ.armorvalue
		targ.armortype = 0	-- lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3))
	end
	
	targ.armorvalue = targ.armorvalue - save
	take = ceil(damage-save)

-- add to the damage total for clients, which will be sent as a single
-- message at the end of the frame
-- FIXME: remove after combining shotgun blasts?
	if targ.flags & FL_CLIENT == FL_CLIENT then -- TODO check condition
		targ.dmg_take = targ.dmg_take + take
		targ.dmg_save = targ.dmg_save + save
		targ.dmg_inflictor = inflictor
	end

-- figure momentum add
	if  (inflictor ~= world)  and  (targ.movetype == MOVETYPE_WALK)  then -- TODO check condition
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5
		dir = normalize(dir)
		targ.velocity = targ.velocity + dir*damage*8
	end

-- check for godmode or invincibility
	if targ.flags & FL_GODMODE == FL_GODMODE then -- TODO check condition
		return
        end
	if targ.invincible_finished >= time then -- TODO check condition
		if self.invincible_sound < time then -- TODO check condition
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM)
			self.invincible_sound = time + 2
		end
		return
	end

-- team play damage avoidance
	if  teamplay ~= 0 and  (targ.team > 0) and (targ.team == attacker.team)  then -- TODO check condition
		return
        end
		
-- do the damage
	targ.health = targ.health - take
			
	if targ.health <= 0 then -- TODO check condition
		Killed (targ, attacker)
		return
	end

-- react to the damage
	oldself = self
	self = targ

	if  (self.flags & FL_MONSTER == FL_MONSTER)  and  attacker ~= world then -- TODO check condition
	-- get mad unless of the same class (except for soldiers)
		if self ~= attacker  and  attacker ~= self.enemy then -- TODO check condition
			if  (self.classname ~= attacker.classname -- TODO check condition
			 or  (self.classname == "monster_army" ) ) then
				if self.enemy and self.enemy.classname == "player" then -- TODO check condition
					self.oldenemy = self.enemy
                                end
				self.enemy = attacker
				FoundTarget ()
			end
		end
	end

	if self.th_pain then -- TODO check condition
		self.th_pain (attacker, take)
	-- nightmare mode monsters don't go into pain frames often
		if skill == 3 then -- TODO check condition
			self.pain_finished = time + 5		
                end
	end

	self = oldself
end

--/*
--============
--T_RadiusDamage
--============
--*/
function T_RadiusDamage(inflictor, attacker, damage, ignore) -- entity, entity, float, entity
	local points; -- float
	local head; -- entity
	local org; -- vector

	head = findradius(inflictor.origin, damage+40)
	
	while head ~= world do -- TODO check condition
		if head ~= ignore then -- TODO check condition
			if head.takedamage ~= 0 then -- TODO check condition
				org = head.origin + (head.mins + head.maxs)*0.5
				points = 0.5*vlen (inflictor.origin - org)
				if points < 0 then -- TODO check condition
					points = 0
                                end
				points = damage - points
				if head == attacker then -- TODO check condition
					points = points * 0.5
                                end
				if points > 0 then -- TODO check condition
					if CanDamage (head, inflictor) then -- TODO check condition
						if head.classname == "monster_shambler" then -- TODO check condition
							T_Damage (head, inflictor, attacker, points*0.5)
						else
							T_Damage (head, inflictor, attacker, points)
                                                end
					end
				end
			end
		end
		head = head.chain
	end
end

--/*
--============
--T_BeamDamage
--============
--*/
function T_BeamDamage(attacker, damage) -- entity, float
	local points; -- float
	local head; -- entity
	
	head = findradius(attacker.origin, damage+40)
	
	while head ~= world do -- TODO check condition
		if head.takedamage ~= 0 then -- TODO check condition
			points = 0.5*vlen (attacker.origin - head.origin)
			if points < 0 then -- TODO check condition
				points = 0
                        end
			points = damage - points
			if head == attacker then -- TODO check condition
				points = points * 0.5
                        end
			if points > 0 then -- TODO check condition
				if CanDamage (head, attacker) then -- TODO check condition
					if head.classname == "monster_shambler" then -- TODO check condition
						T_Damage (head, attacker, attacker, points*0.5)
					else
						T_Damage (head, attacker, attacker, points)
                                        end
				end
			end
		end
		head = head.chain
	end
end

