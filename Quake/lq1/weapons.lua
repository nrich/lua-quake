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
--*/


-- called by worldspawn
function W_Precache()
	precache_sound ("weapons/r_exp3.wav")	-- new rocket explosion
	precache_sound ("weapons/rocket1i.wav")	-- spike gun
	precache_sound ("weapons/sgun1.wav")
	precache_sound ("weapons/guncock.wav")	-- player shotgun
	precache_sound ("weapons/ric1.wav")	-- ricochet (used in c code)
	precache_sound ("weapons/ric2.wav")	-- ricochet (used in c code)
	precache_sound ("weapons/ric3.wav")	-- ricochet (used in c code)
	precache_sound ("weapons/spike2.wav")	-- super spikes
	precache_sound ("weapons/tink1.wav")	-- spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav")	-- grenade launcher
	precache_sound ("weapons/bounce.wav")		-- grenade bounce
	precache_sound ("weapons/shotgn2.wav")	-- super shotgun
end

function crandom()
	return 2*(random() - 0.5)
end

--/*
--================
--W_FireAxe
--================
--*/
function W_FireAxe()
	local source; -- vector
	local org; -- vector

	source = self.origin + vec3(0, 0, 16)
	traceline (source, source + qc.v_forward*64, false, self)
	if qc.trace_fraction == 1.0 then -- TODO check condition
		return
        end
	
	org = qc.trace_endpos - qc.v_forward*4

	if qc.trace_ent.takedamage then -- TODO check condition
		qc.trace_ent.axhitme = 1
		SpawnBlood (org, vec3(0, 0, 0), 20)
		T_Damage (qc.trace_ent, self, self, 20)
	else
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM)
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
		WriteByte (MSG_BROADCAST, TE_GUNSHOT)
		WriteCoord (MSG_BROADCAST, org.x)
		WriteCoord (MSG_BROADCAST, org.y)
		WriteCoord (MSG_BROADCAST, org.z)
	end
end


--============================================================================


function wall_velocity()
	local vel; -- vector
	
	vel = normalize (self.velocity)
	vel = normalize(vel + qc.v_up*(random()- 0.5) + qc.v_right*(random()- 0.5))
	vel = vel + 2*qc.trace_plane_normal
	vel = vel * 200
	
	return vel
end


--/*
--================
--SpawnMeatSpray
--================
--*/
function SpawnMeatSpray(org, vel) -- vector, vector
	local missile, mpuff; -- entity

	missile = spawn ()
	missile.owner = self
	missile.movetype = MOVETYPE_BOUNCE
	missile.solid = SOLID_NOT

	makevectors (self.angles)

	missile.velocity = vel
	missile.velocity.z = missile.velocity.z + 250 + 50*random()

	missile.avelocity = vec3(3000, 1000, 2000)
	
-- set missile duration
	missile.nextthink = time + 1
	missile.think = SUB_Remove

	setmodel (missile, "progs/zom_gib.mdl")
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, org)
end

--/*
--================
--SpawnBlood
--================
--*/
function SpawnBlood(org, vel, damage) -- vector, vector, float
	particle (org, vel*0.1, 73, damage*2)
end

--/*
--================
--spawn_touchblood
--================
--*/
function spawn_touchblood(damage) -- float
	local vel; -- vector

	vel = wall_velocity () * 0.2
	SpawnBlood (self.origin + vel*0.01, vel, damage)
end


--/*
--================
--SpawnChunk
--================
--*/
function SpawnChunk(org, vel) -- vector, vector
	particle (org, vel*0.02, 0, 10)
end

--/*
--==============================================================================
--
--MULTI-DAMAGE
--
--Collects multiple small damages into a single damage
--
--==============================================================================
--*/

local  multi_ent
local  multi_damage

function ClearMultiDamage()
	multi_ent = world
	multi_damage = 0
end

function ApplyMultiDamage()
	if  not multi_ent or multi_ent == world then -- TODO check condition
		return
        end
	T_Damage (multi_ent, self, self, multi_damage)
end

function AddMultiDamage(hit, damage) -- entity, float
	if  not hit or hit == world then -- TODO check condition
		return
        end
	
	if hit ~= multi_ent then -- TODO check condition
		ApplyMultiDamage ()
		multi_damage = damage
		multi_ent = hit
	else
		multi_damage = multi_damage + damage
        end
end

--/*
--==============================================================================
--
--BULLETS
--
--==============================================================================
--*/

--/*
--================
--TraceAttack
--================
--*/
function TraceAttack(damage, dir) -- float, vector
	local vel, org; -- vector
	
	vel = normalize(dir + qc.v_up*crandom() + qc.v_right*crandom())
	vel = vel + 2*qc.trace_plane_normal
	vel = vel * 200

	org = qc.trace_endpos - dir*4

	if qc.trace_ent ~= world and qc.trace_ent.takedamage ~= 0 then -- TODO check condition
		SpawnBlood (org, vel*0.2, damage)
		AddMultiDamage (qc.trace_ent, damage)
	else
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
		WriteByte (MSG_BROADCAST, TE_GUNSHOT)
		WriteCoord (MSG_BROADCAST, org.x)
		WriteCoord (MSG_BROADCAST, org.y)
		WriteCoord (MSG_BROADCAST, org.z)
	end
end

--/*
--================
--FireBullets
--
--Used by shotgun, super shotgun, and enemy soldier firing
--Go to the trouble of combining multiple pellets into a single damage call.
--================
--*/
function FireBullets(shotcount, dir, spread) -- float, vector, vector
	local direction; -- vector
	local src; -- vector
	
	makevectors(self.v_angle)

	src = self.origin + qc.v_forward*10
	src.z = self.absmin.z + self.size.z * 0.7

	ClearMultiDamage ()
	while shotcount > 0 do -- TODO check condition
		direction = dir + crandom()*spread.x*qc.v_right + crandom()*spread.y*qc.v_up

		traceline (src, src + direction*2048, false, self)
		if qc.trace_fraction ~= 1.0 then -- TODO check condition
			TraceAttack (4, direction)
                end

		shotcount = shotcount - 1
	end
	ApplyMultiDamage ()
end

--/*
--================
--W_FireShotgun
--================
--*/
function W_FireShotgun()
	local dir; -- vector

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM)	

	self.punchangle.x = -2
	
	self.ammo_shells = self.ammo_shells - 1
	self.currentammo = self.ammo_shells
	dir = aim (self, 100000)
	FireBullets (6, dir, vec3(0.04, 0.04, 0))
end


--/*
--================
--W_FireSuperShotgun
--================
--*/
function W_FireSuperShotgun()
	local dir; -- vector

	if self.currentammo == 1 then -- TODO check condition
		W_FireShotgun ()
		return
	end
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM)	

	self.punchangle.x = -4
	
	self.ammo_shells = self.ammo_shells - 2
	self.currentammo = self.ammo_shells
	dir = aim (self, 100000)
	FireBullets (14, dir, vec3(0.14, 0.08, 0))
end


--/*
--==============================================================================
--
--ROCKETS
--
--==============================================================================
--*/

function s_explode1()
	self.frame=0
	self.nextthink = time + 0.1
	self.think = s_explode2
end
function s_explode2()
	self.frame=1
	self.nextthink = time + 0.1
	self.think = s_explode3
end
function s_explode3()
	self.frame=2
	self.nextthink = time + 0.1
	self.think = s_explode4
end
function s_explode4()
	self.frame=3
	self.nextthink = time + 0.1
	self.think = s_explode5
end
function s_explode5()
	self.frame=4
	self.nextthink = time + 0.1
	self.think = s_explode6
end
function s_explode6()
	self.frame=5
	self.nextthink = time + 0.1
	self.think = SUB_Remove
end

function BecomeExplosion()
	self.movetype = MOVETYPE_NONE
	self.velocity = vec3(0, 0, 0)
	self.touch = SUB_Null
	setmodel (self, "progs/s_explod.spr")
	self.solid = SOLID_NOT
	s_explode1 ()
end

function T_MissileTouch()
	local damg; -- float

	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end

	if pointcontents(self.origin) == CONTENT_SKY then -- TODO check condition
		remove(self)
		return
	end

	damg = 100 + random()*20
	
	if other ~= wordl and  other.health ~= 0 then -- TODO check condition
		if other.classname == "monster_shambler" then -- TODO check condition
			damg = damg * 0.5	-- mostly immune
                end
		T_Damage (other, self, self.owner, damg )
	end

	-- don't do radius damage to the other, because all the damage
	-- was done in the impact
	T_RadiusDamage (self, self.owner, 120, other)

--	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM)
	self.origin = self.origin - 8*normalize(self.velocity)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_EXPLOSION)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)

	BecomeExplosion ()
end



--/*
--================
--W_FireRocket
--================
--*/
function W_FireRocket()
	local missile, mpuff; -- entity
	
	self.ammo_rockets = self.ammo_rockets - 1
	self.currentammo = self.ammo_rockets
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM)

	self.punchangle.x = -2

	missile = spawn ()
	missile.owner = self
	missile.movetype = MOVETYPE_FLYMISSILE
	missile.solid = SOLID_BBOX
		
-- set missile speed	

	makevectors (self.v_angle)
	missile.velocity = aim(self, 1000)
	missile.velocity = missile.velocity * 1000
	missile.angles = vectoangles(missile.velocity)
	
	missile.touch = T_MissileTouch
	
-- set missile duration
	missile.nextthink = time + 5
	missile.think = SUB_Remove

	setmodel (missile, "progs/missile.mdl")
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, self.origin + qc.v_forward*8 + vec3(0, 0, 16))
end

--/*
--===============================================================================
--
--LIGHTNING
--
--===============================================================================
--*/

--/*
--=================
--LightningDamage
--=================
--*/
function LightningDamage(p1, p2, from, damage) -- vector, vector, entity, float
	local e1, e2; -- entity
	local f; -- vector
	
	f = p2 - p1
	normalize (f)
	f.x = 0 - f.y
	f.y = f.x
	f.z = 0
	f = f*16

	e1 = world
	e1 = world

	traceline (p1, p2, false, self)
	if qc.trace_ent and qc.trace_ent.takedamage ~= 0 then -- TODO check condition
		particle (qc.trace_endpos, vec3(0, 0, 100), 225, damage*4)
		T_Damage (qc.trace_ent, from, from, damage)
		if self.classname == "player" then -- TODO check condition
			if other ~= world and other.classname == "player" then -- TODO check condition
				qc.trace_ent.velocity.z = qc.trace_ent.velocity.z + 400
                        end
		end
	end
	e1 = qc.trace_ent

	traceline (p1 + f, p2 + f, false, self)
	if qc.trace_ent ~= e1  and  qc.trace_ent.takedamage ~= 0 then -- TODO check condition
		particle (qc.trace_endpos, vec3(0, 0, 100), 225, damage*4)
		T_Damage (qc.trace_ent, from, from, damage)
	end
	e2 = qc.trace_ent

	traceline (p1 - f, p2 - f, false, self)
	if qc.trace_ent ~= e1  and  qc.trace_ent ~= e2  and  qc.trace_ent.takedamage ~= 0 then -- TODO check condition
		particle (qc.trace_endpos, vec3(0, 0, 100), 225, damage*4)
		T_Damage (qc.trace_ent, from, from, damage)
	end
end


function W_FireLightning()
	local org; -- vector

	if self.ammo_cells < 1 then -- TODO check condition
		self.weapon = W_BestWeapon ()
		W_SetCurrentAmmo ()
		return
	end

-- explode if under water
	if self.waterlevel > 1 then -- TODO check condition
		T_RadiusDamage (self, self, 35*self.ammo_cells, world)
		self.ammo_cells = 0
		W_SetCurrentAmmo ()
		return
	end

        if not self.t_width then self.t_width = 0 end
	if self.t_width < time then -- TODO check condition
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM)
		self.t_width = time + 0.6
	end
	self.punchangle.x = -2

	self.ammo_cells = self.ammo_cells - 1
	self.currentammo = self.ammo_cells

	org = self.origin + vec3(0, 0, 16)
	
	traceline (org, org + qc.v_forward*600, true, self)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2)
	WriteEntity (MSG_BROADCAST, self)
	WriteCoord (MSG_BROADCAST, org.x)
	WriteCoord (MSG_BROADCAST, org.y)
	WriteCoord (MSG_BROADCAST, org.z)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.x)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.y)
	WriteCoord (MSG_BROADCAST, qc.trace_endpos.z)

	LightningDamage (self.origin, qc.trace_endpos + qc.v_forward*4, self, 30)
end


--=============================================================================


function GrenadeExplode()
	T_RadiusDamage (self, self.owner, 120, world)

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
	WriteByte (MSG_BROADCAST, TE_EXPLOSION)
	WriteCoord (MSG_BROADCAST, self.origin.x)
	WriteCoord (MSG_BROADCAST, self.origin.y)
	WriteCoord (MSG_BROADCAST, self.origin.z)

	BecomeExplosion ()
end

function GrenadeTouch()
	if other == self.owner then -- TODO check condition
		return		-- don't explode on owner
        end
	if other.takedamage == DAMAGE_AIM then -- TODO check condition
		GrenadeExplode()
		return
	end
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM)	-- bounce sound
	if self.velocity == vec3(0, 0, 0) then -- TODO check condition
		self.avelocity = vec3(0, 0, 0)
        end
end

--/*
--================
--W_FireGrenade
--================
--*/
function W_FireGrenade()
	local missile, mpuff; -- entity
	
	self.ammo_rockets = self.ammo_rockets - 1
	self.currentammo = self.ammo_rockets
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM)

	self.punchangle.x = -2

	missile = spawn ()
	missile.owner = self
	missile.movetype = MOVETYPE_BOUNCE
	missile.solid = SOLID_BBOX
	missile.classname = "grenade"
		
-- set missile speed	

	makevectors (self.v_angle)

	if self.v_angle.x ~= 0 then -- TODO check condition
		missile.velocity = qc.v_forward*600 + qc.v_up * 200 + crandom()*qc.v_right*10 + crandom()*qc.v_up*10
	else
		missile.velocity = aim(self, 10000)
		missile.velocity = missile.velocity * 600
		missile.velocity.z = 200
	end

	missile.avelocity = vec3(300, 300, 300)

	missile.angles = vectoangles(missile.velocity)
	
	missile.touch = GrenadeTouch
	
-- set missile duration
	missile.nextthink = time + 2.5
	missile.think = GrenadeExplode

	setmodel (missile, "progs/grenade.mdl")
	setsize (missile, vec3(0, 0, 0), vec3(0, 0, 0))		
	setorigin (missile, self.origin)
end


--=============================================================================



--/*
--===============
--launch_spike
--
--Used for both the player and the ogre
--===============
--*/
function launch_spike(org, dir) -- vector, vector
	newmis = spawn ()
	newmis.owner = self
	newmis.movetype = MOVETYPE_FLYMISSILE
	newmis.solid = SOLID_BBOX

	newmis.angles = vectoangles(dir)
	
	newmis.touch = spike_touch
	newmis.classname = "spike"
	newmis.think = SUB_Remove
	newmis.nextthink = time + 6
	setmodel (newmis, "progs/spike.mdl")
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN)		
	setorigin (newmis, org)

	newmis.velocity = dir * 1000
end

function W_FireSuperSpikes()
	local dir; -- vector
	local old; -- entity
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM)
	self.attack_finished = time + 0.2
	self.ammo_nails = self.ammo_nails - 2
	self.currentammo = self.ammo_nails
	dir = aim (self, 1000)
	launch_spike (self.origin + vec3(0, 0, 16), dir)
	newmis.touch = superspike_touch
	setmodel (newmis, "progs/s_spike.mdl")
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN)		
	self.punchangle.x = -2
end

function W_FireSpikes(ox) -- float
	local dir; -- vector
	local old; -- entity
	
	makevectors (self.v_angle)
	
	if self.ammo_nails >= 2  and  self.weapon == IT_SUPER_NAILGUN then -- TODO check condition
		W_FireSuperSpikes ()
		return
	end

	if self.ammo_nails < 1 then -- TODO check condition
		self.weapon = W_BestWeapon ()
		W_SetCurrentAmmo ()
		return
	end

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM)
	self.attack_finished = time + 0.2
	self.ammo_nails = self.ammo_nails - 1
	self.currentammo = self.ammo_nails
	dir = aim (self, 1000)
	launch_spike (self.origin + vec3(0, 0, 16) + qc.v_right*ox, dir)

	self.punchangle.x = -2
end



local hit_z
function spike_touch()
        local rand; -- float
	if other == self.owner then -- TODO check condition
		return
        end

	if other ~= world and other.solid == SOLID_TRIGGER then -- TODO check condition
		return	-- trigger field, do nothing
        end

	if pointcontents(self.origin) == CONTENT_SKY then -- TODO check condition
		remove(self)
		return
	end
	
-- hit something that bleeds
	if other ~= world and other.takedamage ~= 0 then -- TODO check condition
		spawn_touchblood (9)
		T_Damage (other, self, self.owner, 9)
	else
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
		
		if self.classname == "wizspike" then -- TODO check condition
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE)
		elseif self.classname == "knightspike" then -- TODO check condition
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE)
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE)
                end
		WriteCoord (MSG_BROADCAST, self.origin.x)
		WriteCoord (MSG_BROADCAST, self.origin.y)
		WriteCoord (MSG_BROADCAST, self.origin.z)
	end

	remove(self)

end

function superspike_touch()
        local rand; -- float
	if other == self.owner then -- TODO check condition
		return
        end

	if other.solid == SOLID_TRIGGER then -- TODO check condition
		return	-- trigger field, do nothing
        end

	if pointcontents(self.origin) == CONTENT_SKY then -- TODO check condition
		remove(self)
		return
	end
	
-- hit something that bleeds
	if other.takedamage ~= 0 then -- TODO check condition
		spawn_touchblood (18)
		T_Damage (other, self, self.owner, 18)
	else
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY)
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE)
		WriteCoord (MSG_BROADCAST, self.origin.x)
		WriteCoord (MSG_BROADCAST, self.origin.y)
		WriteCoord (MSG_BROADCAST, self.origin.z)
	end

	remove(self)

end


--/*
--===============================================================================
--
--PLAYER WEAPON USE
--
--===============================================================================
--*/

function W_SetCurrentAmmo()
	player_run ()		-- get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) )
	
	if self.weapon == IT_AXE then -- TODO check condition
		self.currentammo = 0
		self.weaponmodel = "progs/v_axe.mdl"
		self.weaponframe = 0
	elseif self.weapon == IT_SHOTGUN then -- TODO check condition
		self.currentammo = self.ammo_shells
		self.weaponmodel = "progs/v_shot.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_SHELLS
	elseif self.weapon == IT_SUPER_SHOTGUN then -- TODO check condition
		self.currentammo = self.ammo_shells
		self.weaponmodel = "progs/v_shot2.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_SHELLS
	elseif self.weapon == IT_NAILGUN then -- TODO check condition
		self.currentammo = self.ammo_nails
		self.weaponmodel = "progs/v_nail.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_NAILS
	elseif self.weapon == IT_SUPER_NAILGUN then -- TODO check condition
		self.currentammo = self.ammo_nails
		self.weaponmodel = "progs/v_nail2.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_NAILS
	elseif self.weapon == IT_GRENADE_LAUNCHER then -- TODO check condition
		self.currentammo = self.ammo_rockets
		self.weaponmodel = "progs/v_rock.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_ROCKETS
	elseif self.weapon == IT_ROCKET_LAUNCHER then -- TODO check condition
		self.currentammo = self.ammo_rockets
		self.weaponmodel = "progs/v_rock2.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_ROCKETS
	elseif self.weapon == IT_LIGHTNING then -- TODO check condition
		self.currentammo = self.ammo_cells
		self.weaponmodel = "progs/v_light.mdl"
		self.weaponframe = 0
		self.items = self.items | IT_CELLS
	else
		self.currentammo = 0
		self.weaponmodel = ""
		self.weaponframe = 0
	end
end

function W_BestWeapon()
	local it; -- float
	
	it = self.items

	if self.ammo_cells >= 1  and  (it & IT_LIGHTNING == IT_LIGHTNING)  then -- TODO check condition
		return IT_LIGHTNING
	elseif self.ammo_nails >= 2  and  (it & IT_SUPER_NAILGUN == IT_SUPER_NAILGUN)  then -- TODO check condition
		return IT_SUPER_NAILGUN
	elseif self.ammo_shells >= 2  and  (it & IT_SUPER_SHOTGUN == IT_SUPER_SHOTGUN)  then -- TODO check condition
		return IT_SUPER_SHOTGUN
	elseif self.ammo_nails >= 1  and  (it & IT_NAILGUN == IT_NAILGUN)  then -- TODO check condition
		return IT_NAILGUN
	elseif self.ammo_shells >= 1  and  (it & IT_SHOTGUN == IT_SHOTGUN)  then -- TODO check condition
		return IT_SHOTGUN
        end

	return IT_AXE
end

function W_CheckNoAmmo()
	if self.currentammo > 0 then -- TODO check condition
		return true
        end

	if self.weapon == IT_AXE then -- TODO check condition
		return true
        end
	
	self.weapon = W_BestWeapon ()

	W_SetCurrentAmmo ()
	
-- drop the weapon down
	return false
end

--/*
--============
--W_Attack
--
--An attack impulse can be triggered now
--============
--*/

function W_Attack()
	local r; -- float

	if  not W_CheckNoAmmo () then -- TODO check condition
		return
        end

	makevectors	(self.v_angle)			-- calculate forward angle for velocity
	self.show_hostile = time + 1	-- wake monsters up

	if self.weapon == IT_AXE then -- TODO check condition
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM)
		r = random()
		if r < 0.25 then -- TODO check condition
			player_axe1 ()
		elseif r<0.5 then -- TODO check condition
			player_axeb1 ()
		elseif r<0.75 then -- TODO check condition
			player_axec1 ()
		else
			player_axed1 ()
                end
		self.attack_finished = time + 0.5
	elseif self.weapon == IT_SHOTGUN then -- TODO check condition
		player_shot1 ()
		W_FireShotgun ()
		self.attack_finished = time + 0.5
	elseif self.weapon == IT_SUPER_SHOTGUN then -- TODO check condition
		player_shot1 ()
		W_FireSuperShotgun ()
		self.attack_finished = time + 0.7
	elseif self.weapon == IT_NAILGUN then -- TODO check condition
		player_nail1 ()
	elseif self.weapon == IT_SUPER_NAILGUN then -- TODO check condition
		player_nail1 ()
	elseif self.weapon == IT_GRENADE_LAUNCHER then -- TODO check condition
		player_rocket1()
		W_FireGrenade()
		self.attack_finished = time + 0.6
	elseif self.weapon == IT_ROCKET_LAUNCHER then -- TODO check condition
		player_rocket1()
		W_FireRocket()
		self.attack_finished = time + 0.8
	elseif self.weapon == IT_LIGHTNING then -- TODO check condition
		player_light1()
		self.attack_finished = time + 0.1
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM)
	end
end

--/*
--============
--W_ChangeWeapon
--
--============
--*/
function W_ChangeWeapon()
	local it, am, fl; -- float
	
	it = self.items
	am = 0
	
	if self.impulse == 1 then -- TODO check condition
		fl = IT_AXE
	elseif self.impulse == 2 then -- TODO check condition
		fl = IT_SHOTGUN
		if self.ammo_shells < 1 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 3 then -- TODO check condition
		fl = IT_SUPER_SHOTGUN
		if self.ammo_shells < 2 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 4 then -- TODO check condition
		fl = IT_NAILGUN
		if self.ammo_nails < 1 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 5 then -- TODO check condition
		fl = IT_SUPER_NAILGUN
		if self.ammo_nails < 2 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 6 then -- TODO check condition
		fl = IT_GRENADE_LAUNCHER
		if self.ammo_rockets < 1 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 7 then -- TODO check condition
		fl = IT_ROCKET_LAUNCHER
		if self.ammo_rockets < 1 then -- TODO check condition
			am = 1
                end
	elseif self.impulse == 8 then -- TODO check condition
		fl = IT_LIGHTNING
		if self.ammo_cells < 1 then -- TODO check condition
			am = 1
                end
	end

	self.impulse = 0
	
	if  not (self.items & fl == fl) then -- TODO check condition
		sprint (self, "no weapon.\n")
		return
	end
	
	if am ~= 0 then -- TODO check condition
		sprint (self, "not enough ammo.\n")
		return
	end

--
-- set weapon, set ammo
--
	self.weapon = fl		
	W_SetCurrentAmmo ()
end

--/*
--============
--CheatCommand
--============
--*/
function CheatCommand()
	if deathmatch ~= 0 or coop ~= 0 then -- TODO check condition
		return
        end

	self.ammo_rockets = 100
	self.ammo_nails = 200
	self.ammo_shells = 100
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2

	self.ammo_cells = 200
	self.items = self.items | IT_LIGHTNING

	self.weapon = IT_ROCKET_LAUNCHER
	self.impulse = 0
	W_SetCurrentAmmo ()
end

--/*
--============
--CycleWeaponCommand
--
--Go to the next weapon with ammo
--============
--*/
function CycleWeaponCommand()
	local it, am; -- float
	
	it = self.items
	self.impulse = 0
	
	while true do -- TODO check condition
		am = 0

		if self.weapon == IT_LIGHTNING then -- TODO check condition
			self.weapon = IT_AXE
		elseif self.weapon == IT_AXE then -- TODO check condition
			self.weapon = IT_SHOTGUN
			if self.ammo_shells < 1 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_SHOTGUN then -- TODO check condition
			self.weapon = IT_SUPER_SHOTGUN
			if self.ammo_shells < 2 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_SUPER_SHOTGUN then -- TODO check condition
			self.weapon = IT_NAILGUN
			if self.ammo_nails < 1 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_NAILGUN then -- TODO check condition
			self.weapon = IT_SUPER_NAILGUN
			if self.ammo_nails < 2 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_SUPER_NAILGUN then -- TODO check condition
			self.weapon = IT_GRENADE_LAUNCHER
			if self.ammo_rockets < 1 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_GRENADE_LAUNCHER then -- TODO check condition
			self.weapon = IT_ROCKET_LAUNCHER
			if self.ammo_rockets < 1 then -- TODO check condition
				am = 1
                        end
		elseif self.weapon == IT_ROCKET_LAUNCHER then -- TODO check condition
			self.weapon = IT_LIGHTNING
			if self.ammo_cells < 1 then -- TODO check condition
				am = 1
                        end
		end
	
		if  (self.items & self.weapon ~= 0)  and  am == 0 then -- TODO check condition
			W_SetCurrentAmmo ()
			return
		end
	end

end

--/*
--============
--ServerflagsCommand
--
--Just for development
--============
--*/
function ServerflagsCommand()
	serverflags = serverflags * 2 + 1
end

function QuadCheat()
	if deathmatch ~= 0 or coop ~= 0 then -- TODO check condition
		return
        end
	self.super_time = 1
	self.super_damage_finished = time + 30
	self.items = self.items | IT_QUAD
	dprint ("quad cheat\n")
end

--/*
--============
--ImpulseCommands
--
--============
--*/
function ImpulseCommands()
	if self.impulse >= 1  and  self.impulse <= 8 then -- TODO check condition
		W_ChangeWeapon ()
        end

	if self.impulse == 9 then -- TODO check condition
		CheatCommand ()
        end
	if self.impulse == 10 then -- TODO check condition
		CycleWeaponCommand ()
        end
	if self.impulse == 11 then -- TODO check condition
		ServerflagsCommand ()
        end

	if self.impulse == 255 then -- TODO check condition
		QuadCheat ()
        end
		
	self.impulse = 0
end

--/*
--============
--W_WeaponFrame
--
--Called every frame so impulse events can be handled as well as possible
--============
--*/
function W_WeaponFrame()
        if not self.attack_finished then self.attack_finished = 0 end

	if time < self.attack_finished then -- TODO check condition
		return
        end

	ImpulseCommands ()
	
-- check for attack
	if self.button0 ~= 0 then -- TODO check condition
		SuperDamageSound ()
		W_Attack ()
	end
end

--/*
--========
--SuperDamageSound
--
--Plays sound if needed
--========
--*/
function SuperDamageSound()
        if not self.super_damage_finished then self.super_damage_finished = 0 end
        if not self.super_sound then self.super_sound = 0 end

	if self.super_damage_finished > time then -- TODO check condition
		if self.super_sound < time then -- TODO check condition
			self.super_sound = time + 1
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM)
		end
	end
	return
end


