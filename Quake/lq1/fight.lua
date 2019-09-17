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
--A monster is in fight mode if it thinks it can effectively attack its
--enemy.
--
--When it decides it can't attack, it goes into hunt mode.
--
--*/



--local enemy_vis, enemy_infront, enemy_range
--local enemy_yaw


function knight_attack()
	local len; -- float
	
-- decide if now is a good swing time
	len = vlen(self.enemy.origin+self.enemy.view_ofs - (self.origin+self.view_ofs))
	
	if len<80 then -- TODO check condition
		knight_atk1 ()
	else
		knight_runatk1 ()
        end
end

--=============================================================================

--/*
--===========
--CheckAttack
--
--The player is in view, so decide to move or launch an attack
--Returns false if movement should continue
--============
--*/
function CheckAttack()
	local spot1, spot2;	 -- vector
	local targ; -- entity
	local chance; -- float

	targ = self.enemy
	
-- see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs

	traceline (spot1, spot2, false, self)

	if qc.trace_ent ~= targ then -- TODO check condition
		return false		-- don't have a clear shot
        end
			
	if qc.trace_inopen  and  qc.trace_inwater then -- TODO check condition
		return false			-- sight line crossed contents
        end

	if enemy_range == RANGE_MELEE then -- TODO check condition
		if self.th_melee then -- TODO check condition
			if self.classname == "monster_knight" then -- TODO check condition
				knight_attack ()
			else
				self.th_melee ()
                        end
			return true
		end
	end
	
-- missile attack
	if  not self.th_missile then -- TODO check condition
		return false
        end
		
	if time < self.attack_finished then -- TODO check condition
		return false
        end
		
	if enemy_range == RANGE_FAR then -- TODO check condition
		return false
        end
		
	if enemy_range == RANGE_MELEE then -- TODO check condition
		chance = 0.9
		self.attack_finished = 0
	elseif enemy_range == RANGE_NEAR then -- TODO check condition
		if self.th_melee then -- TODO check condition
			chance = 0.2
		else
			chance = 0.4
                end
	elseif enemy_range == RANGE_MID then -- TODO check condition
		if self.th_melee then -- TODO check condition
			chance = 0.05
		else
			chance = 0.1
                end
	else
		chance = 0
        end

	if random () < chance then -- TODO check condition
		self.th_missile ()
		SUB_AttackFinished (2*random())
		return true
	end

	return false
end


--/*
--=============
--ai_face
--
--Stay facing the enemy
--=============
--*/
function ai_face()
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin)
	changeyaw (self)
end

--/*
--=============
--ai_charge
--
--The monster is in a melee attack, so get as close as possible to .enemy
--=============
--*/

function ai_charge(d) -- float
	ai_face ()	
	movetogoal (self, d)		-- done in C code...
end

function ai_charge_side()
	local dtemp; -- vector
	local heading; -- float
	
-- aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin)
	changeyaw (self)

	makevectors (self.angles)
	dtemp = self.enemy.origin - 30*qc.v_right
	heading = vectoyaw(dtemp - self.origin)
	
	walkmove(self, heading, 20)
end


--/*
--=============
--ai_melee
--
--=============
--*/
function ai_melee()
	local delta; -- vector
	local ldmg; -- float

	if  self.enemy == world then -- TODO check condition
		return		-- removed before stroke
        end
		
	delta = self.enemy.origin - self.origin

	if vlen(delta) > 60 then -- TODO check condition
		return
        end
		
	ldmg = (random() + random() + random()) * 3
	T_Damage (self.enemy, self, self, ldmg)
end


function ai_melee_side()
	local delta; -- vector
	local ldmg; -- float

	if  self.enemy == world then -- TODO check condition
		return		-- removed before stroke
        end
		
	ai_charge_side()
	
	delta = self.enemy.origin - self.origin

	if vlen(delta) > 60 then -- TODO check condition
		return
        end
	if  not CanDamage (self.enemy, self) then -- TODO check condition
		return
        end
	ldmg = (random() + random() + random()) * 3
	T_Damage (self.enemy, self, self, ldmg)
end


--=============================================================================

--/*
--===========
--SoldierCheckAttack
--
--The player is in view, so decide to move or launch an attack
--Returns false if movement should continue
--============
--*/
function SoldierCheckAttack()
	local spot1, spot2;	 -- vector
	local targ; -- entity
	local chance; -- float

	targ = self.enemy
	
-- see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs

	traceline (spot1, spot2, false, self)

	if qc.trace_inopen  and  qc.trace_inwater then -- TODO check condition
		return false			-- sight line crossed contents
        end

	if qc.trace_ent ~= targ then -- TODO check condition
		return false	-- don't have a clear shot
        end
			
	
-- missile attack
	if time < self.attack_finished then -- TODO check condition
		return false
        end
		
	if enemy_range == RANGE_FAR then -- TODO check condition
		return false
        end
		
	if enemy_range == RANGE_MELEE then -- TODO check condition
		chance = 0.9
	elseif enemy_range == RANGE_NEAR then -- TODO check condition
		chance = 0.4
	elseif enemy_range == RANGE_MID then -- TODO check condition
		chance = 0.05
	else
		chance = 0
        end

	if random () < chance then -- TODO check condition
		self.th_missile ()
		SUB_AttackFinished (1 + random())
		if random() < 0.3 then -- TODO check condition
                        -- TODO what should this be?
		        self.lefty =  not self.lefty
                end

		return true
	end

	return false
end
--=============================================================================

--/*
--===========
--ShamCheckAttack
--
--The player is in view, so decide to move or launch an attack
--Returns false if movement should continue
--============
--*/
function ShamCheckAttack()
	local spot1, spot2;	 -- vector
	local targ; -- entity
	local chance; -- float
	local enemy_yaw; -- float

	if enemy_range == RANGE_MELEE then -- TODO check condition
		if CanDamage (self.enemy, self) then -- TODO check condition
			self.attack_state = AS_MELEE
			return true
		end
	end

	if time < self.attack_finished then -- TODO check condition
		return false
        end
	
	if  not enemy_vis then -- TODO check condition
		return false
        end
		
	targ = self.enemy
	
-- see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs

	if vlen(spot1 - spot2) > 600 then -- TODO check condition
		return false
        end

	traceline (spot1, spot2, false, self)

	if qc.trace_inopen  and  qc.trace_inwater then -- TODO check condition
		return false			-- sight line crossed contents
        end

	if qc.trace_ent ~= targ then -- TODO check condition
		return false	-- don't have a clear shot
	end
			
-- missile attack
	if enemy_range == RANGE_FAR then -- TODO check condition
		return false
        end
		
	self.attack_state = AS_MISSILE
	SUB_AttackFinished (2 + 2*random())
	return true
end

--============================================================================

--/*
--===========
--OgreCheckAttack
--
--The player is in view, so decide to move or launch an attack
--Returns false if movement should continue
--============
--*/
function OgreCheckAttack()
	local spot1, spot2;	 -- vector
	local targ; -- entity
	local chance; -- float

	if enemy_range == RANGE_MELEE then -- TODO check condition
		if CanDamage (self.enemy, self) then -- TODO check condition
			self.attack_state = AS_MELEE
			return true
		end
	end

	if time < self.attack_finished then -- TODO check condition
		return false
        end
	
	if  not enemy_vis then -- TODO check condition
		return false
        end
		
	targ = self.enemy
	
-- see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs
	spot2 = targ.origin + targ.view_ofs

	traceline (spot1, spot2, false, self)

	if qc.trace_inopen  and  qc.trace_inwater then -- TODO check condition
		return false			-- sight line crossed contents
        end

	if qc.trace_ent ~= targ then -- TODO check condition
		return false	-- don't have a clear shot
	end
			
-- missile attack
	if time < self.attack_finished then -- TODO check condition
		return false
        end
		
	if enemy_range == RANGE_FAR then -- TODO check condition
		return false
	elseif enemy_range == RANGE_NEAR then -- TODO check condition
		chance = 0.10
	elseif enemy_range == RANGE_MID then -- TODO check condition
		chance = 0.05
	else
		chance = 0
        end

	self.attack_state = AS_MISSILE
	SUB_AttackFinished (1 + 2*random())
	return true
end

