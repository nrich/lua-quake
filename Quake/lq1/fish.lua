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

local FRAME_attack1,FRAME_attack2,FRAME_attack3,FRAME_attack4,FRAME_attack5,FRAME_attack6 = 0,1,2,3,4,5
local FRAME_attack7,FRAME_attack8,FRAME_attack9,FRAME_attack10,FRAME_attack11,FRAME_attack12,FRAME_attack13 = 6,7,8,9,10,11,12
local FRAME_attack14,FRAME_attack15,FRAME_attack16,FRAME_attack17,FRAME_attack18 = 13,14,15,16,17

local FRAME_death1,FRAME_death2,FRAME_death3,FRAME_death4,FRAME_death5,FRAME_death6,FRAME_death7 = 18,19,20,21,22,23,24
local FRAME_death8,FRAME_death9,FRAME_death10,FRAME_death11,FRAME_death12,FRAME_death13,FRAME_death14,FRAME_death15 = 25,26,27,28,29,30,31,32
local FRAME_death16,FRAME_death17,FRAME_death18,FRAME_death19,FRAME_death20,FRAME_death21 = 33,34,35,36,37,38

local FRAME_swim1,FRAME_swim2,FRAME_swim3,FRAME_swim4,FRAME_swim5,FRAME_swim6,FRAME_swim7,FRAME_swim8 = 39,40,41,42,43,44,45,46
local FRAME_swim9,FRAME_swim10,FRAME_swim11,FRAME_swim12,FRAME_swim13,FRAME_swim14,FRAME_swim15,FRAME_swim16,FRAME_swim17 = 47,48,49,50,51,52,53,54,55
local FRAME_swim18 = 56

local FRAME_pain1,FRAME_pain2,FRAME_pain3,FRAME_pain4,FRAME_pain5,FRAME_pain6,FRAME_pain7,FRAME_pain8 = 57,58,59,60,61,62,63,64
local FRAME_pain9 = 65


function f_stand1()
	self.frame=FRAME_swim1
	self.nextthink = time + 0.1
	self.think = f_stand2
end
function f_stand2()
	self.frame=FRAME_swim2
	self.nextthink = time + 0.1
	self.think = f_stand3
end
function f_stand3()
	self.frame=FRAME_swim3
	self.nextthink = time + 0.1
	self.think = f_stand4
end
function f_stand4()
	self.frame=FRAME_swim4
	self.nextthink = time + 0.1
	self.think = f_stand5
end
function f_stand5()
	self.frame=FRAME_swim5
	self.nextthink = time + 0.1
	self.think = f_stand6
end
function f_stand6()
	self.frame=FRAME_swim6
	self.nextthink = time + 0.1
	self.think = f_stand7
end
function f_stand7()
	self.frame=FRAME_swim7
	self.nextthink = time + 0.1
	self.think = f_stand8
end
function f_stand8()
	self.frame=FRAME_swim8
	self.nextthink = time + 0.1
	self.think = f_stand9
end
function f_stand9()
	self.frame=FRAME_swim9
	self.nextthink = time + 0.1
	self.think = f_stand10
end
function f_stand10()
	self.frame=FRAME_swim10
	self.nextthink = time + 0.1
	self.think = f_stand11
end
function f_stand11()
	self.frame=FRAME_swim11
	self.nextthink = time + 0.1
	self.think = f_stand12
end
function f_stand12()
	self.frame=FRAME_swim12
	self.nextthink = time + 0.1
	self.think = f_stand13
end
function f_stand13()
	self.frame=FRAME_swim13
	self.nextthink = time + 0.1
	self.think = f_stand14
end
function f_stand14()
	self.frame=FRAME_swim14
	self.nextthink = time + 0.1
	self.think = f_stand15
end
function f_stand15()
	self.frame=FRAME_swim15
	self.nextthink = time + 0.1
	self.think = f_stand16
end
function f_stand16()
	self.frame=FRAME_swim16
	self.nextthink = time + 0.1
	self.think = f_stand17
end
function f_stand17()
	self.frame=FRAME_swim17
	self.nextthink = time + 0.1
	self.think = f_stand18
end
function f_stand18()
	self.frame=FRAME_swim18
	self.nextthink = time + 0.1
	self.think = f_stand1
end

function f_walk1()
	self.frame=FRAME_swim1
	self.nextthink = time + 0.1
	self.think = f_walk2
end
function f_walk2()
	self.frame=FRAME_swim2
	self.nextthink = time + 0.1
	self.think = f_walk3
end
function f_walk3()
	self.frame=FRAME_swim3
	self.nextthink = time + 0.1
	self.think = f_walk4
end
function f_walk4()
	self.frame=FRAME_swim4
	self.nextthink = time + 0.1
	self.think = f_walk5
end
function f_walk5()
	self.frame=FRAME_swim5
	self.nextthink = time + 0.1
	self.think = f_walk6
end
function f_walk6()
	self.frame=FRAME_swim6
	self.nextthink = time + 0.1
	self.think = f_walk7
end
function f_walk7()
	self.frame=FRAME_swim7
	self.nextthink = time + 0.1
	self.think = f_walk8
end
function f_walk8()
	self.frame=FRAME_swim8
	self.nextthink = time + 0.1
	self.think = f_walk9
end
function f_walk9()
	self.frame=FRAME_swim9
	self.nextthink = time + 0.1
	self.think = f_walk10
end
function f_walk10()
	self.frame=FRAME_swim10
	self.nextthink = time + 0.1
	self.think = f_walk11
end
function f_walk11()
	self.frame=FRAME_swim11
	self.nextthink = time + 0.1
	self.think = f_walk12
end
function f_walk12()
	self.frame=FRAME_swim12
	self.nextthink = time + 0.1
	self.think = f_walk13
end
function f_walk13()
	self.frame=FRAME_swim13
	self.nextthink = time + 0.1
	self.think = f_walk14
end
function f_walk14()
	self.frame=FRAME_swim14
	self.nextthink = time + 0.1
	self.think = f_walk15
end
function f_walk15()
	self.frame=FRAME_swim15
	self.nextthink = time + 0.1
	self.think = f_walk16
end
function f_walk16()
	self.frame=FRAME_swim16
	self.nextthink = time + 0.1
	self.think = f_walk17
end
function f_walk17()
	self.frame=FRAME_swim17
	self.nextthink = time + 0.1
	self.think = f_walk18
end
function f_walk18()
	self.frame=FRAME_swim18
	self.nextthink = time + 0.1
	self.think = f_walk1
end

function f_run1()
	self.frame=FRAME_swim1
	self.nextthink = time + 0.1
	self.think = f_run2
	if random() < 0.5 then -- TODO check condition
		sound (self, CHAN_VOICE, "fish/idle.wav", 1, ATTN_NORM)
end
end
function f_run2()
	self.frame=FRAME_swim3
	self.nextthink = time + 0.1
	self.think = f_run3
end
function f_run3()
	self.frame=FRAME_swim5
	self.nextthink = time + 0.1
	self.think = f_run4
end
function f_run4()
	self.frame=FRAME_swim7
	self.nextthink = time + 0.1
	self.think = f_run5
end
function f_run5()
	self.frame=FRAME_swim9
	self.nextthink = time + 0.1
	self.think = f_run6
end
function f_run6()
	self.frame=FRAME_swim11
	self.nextthink = time + 0.1
	self.think = f_run7
end
function f_run7()
	self.frame=FRAME_swim13
	self.nextthink = time + 0.1
	self.think = f_run8
end
function f_run8()
	self.frame=FRAME_swim15
	self.nextthink = time + 0.1
	self.think = f_run9
end
function f_run9()
	self.frame=FRAME_swim17
	self.nextthink = time + 0.1
	self.think = f_run1
end

function fish_melee()
	local delta; -- vector
	local ldmg; -- float

	if  self.enemy == world then -- TODO check condition
		return		-- removed before stroke
        end
		
	delta = self.enemy.origin - self.origin

	if vlen(delta) > 60 then -- TODO check condition
		return
        end
		
	sound (self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM)
	ldmg = (random() + random()) * 3
	T_Damage (self.enemy, self, self, ldmg)
end

function f_attack1()
	self.frame=FRAME_attack1
	self.nextthink = time + 0.1
	self.think = f_attack2
end
function f_attack2()
	self.frame=FRAME_attack2
	self.nextthink = time + 0.1
	self.think = f_attack3
end
function f_attack3()
	self.frame=FRAME_attack3
	self.nextthink = time + 0.1
	self.think = f_attack4
end
function f_attack4()
	self.frame=FRAME_attack4
	self.nextthink = time + 0.1
	self.think = f_attack5
end
function f_attack5()
	self.frame=FRAME_attack5
	self.nextthink = time + 0.1
	self.think = f_attack6
end
function f_attack6()
	self.frame=FRAME_attack6
	self.nextthink = time + 0.1
	self.think = f_attack7
end
function f_attack7()
	self.frame=FRAME_attack7
	self.nextthink = time + 0.1
	self.think = f_attack8
end
function f_attack8()
	self.frame=FRAME_attack8
	self.nextthink = time + 0.1
	self.think = f_attack9
end
function f_attack9()
	self.frame=FRAME_attack9
	self.nextthink = time + 0.1
	self.think = f_attack10
end
function f_attack10()
	self.frame=FRAME_attack10
	self.nextthink = time + 0.1
	self.think = f_attack11
end
function f_attack11()
	self.frame=FRAME_attack11
	self.nextthink = time + 0.1
	self.think = f_attack12
end
function f_attack12()
	self.frame=FRAME_attack12
	self.nextthink = time + 0.1
	self.think = f_attack13
end
function f_attack13()
	self.frame=FRAME_attack13
	self.nextthink = time + 0.1
	self.think = f_attack14
end
function f_attack14()
	self.frame=FRAME_attack14
	self.nextthink = time + 0.1
	self.think = f_attack15
end
function f_attack15()
	self.frame=FRAME_attack15
	self.nextthink = time + 0.1
	self.think = f_attack16
end
function f_attack16()
	self.frame=FRAME_attack16
	self.nextthink = time + 0.1
	self.think = f_attack17
end
function f_attack17()
	self.frame=FRAME_attack17
	self.nextthink = time + 0.1
	self.think = f_attack18
end
function f_attack18()
	self.frame=FRAME_attack18
	self.nextthink = time + 0.1
	self.think = f_run1
end

function f_death1()
	self.frame=FRAME_death1
	self.nextthink = time + 0.1
	self.think = f_death2
end
function f_death2()
	self.frame=FRAME_death2
	self.nextthink = time + 0.1
	self.think = f_death3
end
function f_death3()
	self.frame=FRAME_death3
	self.nextthink = time + 0.1
	self.think = f_death4
end
function f_death4()
	self.frame=FRAME_death4
	self.nextthink = time + 0.1
	self.think = f_death5
end
function f_death5()
	self.frame=FRAME_death5
	self.nextthink = time + 0.1
	self.think = f_death6
end
function f_death6()
	self.frame=FRAME_death6
	self.nextthink = time + 0.1
	self.think = f_death7
end
function f_death7()
	self.frame=FRAME_death7
	self.nextthink = time + 0.1
	self.think = f_death8
end
function f_death8()
	self.frame=FRAME_death8
	self.nextthink = time + 0.1
	self.think = f_death9
end
function f_death9()
	self.frame=FRAME_death9
	self.nextthink = time + 0.1
	self.think = f_death10
end
function f_death10()
	self.frame=FRAME_death10
	self.nextthink = time + 0.1
	self.think = f_death11
end
function f_death11()
	self.frame=FRAME_death11
	self.nextthink = time + 0.1
	self.think = f_death12
end
function f_death12()
	self.frame=FRAME_death12
	self.nextthink = time + 0.1
	self.think = f_death13
end
function f_death13()
	self.frame=FRAME_death13
	self.nextthink = time + 0.1
	self.think = f_death14
end
function f_death14()
	self.frame=FRAME_death14
	self.nextthink = time + 0.1
	self.think = f_death15
end
function f_death15()
	self.frame=FRAME_death15
	self.nextthink = time + 0.1
	self.think = f_death16
end
function f_death16()
	self.frame=FRAME_death16
	self.nextthink = time + 0.1
	self.think = f_death17
end
function f_death17()
	self.frame=FRAME_death17
	self.nextthink = time + 0.1
	self.think = f_death18
end
function f_death18()
	self.frame=FRAME_death18
	self.nextthink = time + 0.1
	self.think = f_death19
end
function f_death19()
	self.frame=FRAME_death19
	self.nextthink = time + 0.1
	self.think = f_death20
end
function f_death20()
	self.frame=FRAME_death20
	self.nextthink = time + 0.1
	self.think = f_death21
end
function f_death21()
	self.frame=FRAME_death21
	self.nextthink = time + 0.1
	self.think = f_death21
end

function f_pain1()
	self.frame=FRAME_pain1
	self.nextthink = time + 0.1
	self.think = f_pain2
end
function f_pain2()
	self.frame=FRAME_pain2
	self.nextthink = time + 0.1
	self.think = f_pain3
end
function f_pain3()
	self.frame=FRAME_pain3
	self.nextthink = time + 0.1
	self.think = f_pain4
end
function f_pain4()
	self.frame=FRAME_pain4
	self.nextthink = time + 0.1
	self.think = f_pain5
end
function f_pain5()
	self.frame=FRAME_pain5
	self.nextthink = time + 0.1
	self.think = f_pain6
end
function f_pain6()
	self.frame=FRAME_pain6
	self.nextthink = time + 0.1
	self.think = f_pain7
end
function f_pain7()
	self.frame=FRAME_pain7
	self.nextthink = time + 0.1
	self.think = f_pain8
end
function f_pain8()
	self.frame=FRAME_pain8
	self.nextthink = time + 0.1
	self.think = f_pain9
end
function f_pain9()
	self.frame=FRAME_pain9
	self.nextthink = time + 0.1
	self.think = f_run1
end

function fish_pain(attacker, damage) -- entity, float

-- fish allways do pain frames
	f_pain1 ()
end



--/*QUAKED monster_fish (1 0 0) (-16 -16 -24) (16 16 24) Ambush
--*/
function monster_fish()
	if deathmatch ~= 0 then -- TODO check condition
		remove(self)
		return
	end
	precache_model2 ("progs/fish.mdl")

	precache_sound2 ("fish/death.wav")
	precache_sound2 ("fish/bite.wav")
	precache_sound2 ("fish/idle.wav")

	self.solid = SOLID_SLIDEBOX
	self.movetype = MOVETYPE_STEP

	setmodel (self, "progs/fish.mdl")

	setsize (self, vec3(-16, -16, -24), vec3(16, 16, 24))
	self.health = 25
	
	self.th_stand = f_stand1
	self.th_walk = f_walk1
	self.th_run = f_run1
	self.th_die = f_death1
	self.th_pain = fish_pain
	self.th_melee = f_attack1
	
	swimmonster_start ()
end

