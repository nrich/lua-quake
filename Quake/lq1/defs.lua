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

-- edict.flags
FL_FLY					= 1
FL_SWIM					= 2
FL_CLIENT				= 8	-- set for all client edicts
FL_INWATER				= 16	-- for enter / leave water splash
FL_MONSTER				= 32
FL_GODMODE				= 64	-- player cheat
FL_NOTARGET				= 128	-- player cheat
FL_ITEM					= 256	-- extra wide size for bonus items
FL_ONGROUND				= 512	-- standing on something
FL_PARTIALGROUND		= 1024	-- not all corners are valid
FL_WATERJUMP			= 2048	-- player jumping out of water
FL_JUMPRELEASED			= 4096	-- for jump debouncing

-- edict.movetype values
MOVETYPE_NONE			= 0	-- never moves
--float	MOVETYPE_ANGLENOCLIP	= 1
--float	MOVETYPE_ANGLECLIP		= 2
MOVETYPE_WALK			= 3	-- players only
MOVETYPE_STEP			= 4	-- discrete, not real time unless fall
MOVETYPE_FLY			= 5
MOVETYPE_TOSS			= 6	-- gravity
MOVETYPE_PUSH			= 7	-- no clip to world, push and crush
MOVETYPE_NOCLIP			= 8
MOVETYPE_FLYMISSILE		= 9	-- fly with extra size against monsters
MOVETYPE_BOUNCE			= 10
MOVETYPE_BOUNCEMISSILE	= 11	-- bounce with extra size

-- edict.solid values
SOLID_NOT				= 0	-- no interaction with other objects
SOLID_TRIGGER			= 1	-- touch on edge, but not blocking
SOLID_BBOX				= 2	-- touch on edge, block
SOLID_SLIDEBOX			= 3	-- touch on edge, but not an onground
SOLID_BSP				= 4	-- bsp clip, touch on edge, block

-- range values
RANGE_MELEE				= 0
RANGE_NEAR				= 1
RANGE_MID				= 2
RANGE_FAR				= 3

-- deadflag values

DEAD_NO					= 0
DEAD_DYING				= 1
DEAD_DEAD				= 2
DEAD_RESPAWNABLE		= 3

-- takedamage values

DAMAGE_NO				= 0
DAMAGE_YES				= 1
DAMAGE_AIM				= 2

-- items
IT_AXE					= 4096
IT_SHOTGUN				= 1
IT_SUPER_SHOTGUN		= 2
IT_NAILGUN				= 4
IT_SUPER_NAILGUN		= 8
IT_GRENADE_LAUNCHER		= 16
IT_ROCKET_LAUNCHER		= 32
IT_LIGHTNING			= 64
IT_EXTRA_WEAPON			= 128

IT_SHELLS				= 256
IT_NAILS				= 512
IT_ROCKETS				= 1024
IT_CELLS				= 2048

IT_ARMOR1				= 8192
IT_ARMOR2				= 16384
IT_ARMOR3				= 32768
IT_SUPERHEALTH			= 65536

IT_KEY1					= 131072
IT_KEY2					= 262144

IT_INVISIBILITY			= 524288
IT_INVULNERABILITY		= 1048576
IT_SUIT					= 2097152
IT_QUAD					= 4194304

-- point content values

CONTENT_EMPTY			= -1
CONTENT_SOLID			= -2
CONTENT_WATER			= -3
CONTENT_SLIME			= -4
CONTENT_LAVA			= -5
CONTENT_SKY				= -6

STATE_TOP		= 0
STATE_BOTTOM	= 1
STATE_UP		= 2
STATE_DOWN		= 3

-- protocol bytes
SVC_TEMPENTITY		= 23
SVC_KILLEDMONSTER	= 27
SVC_FOUNDSECRET		= 28
SVC_INTERMISSION	= 30
SVC_FINALE			= 31
SVC_CDTRACK			= 32
SVC_SELLSCREEN		= 33


TE_SPIKE		= 0
TE_SUPERSPIKE	= 1
TE_GUNSHOT		= 2
TE_EXPLOSION	= 3
TE_TAREXPLOSION	= 4
TE_LIGHTNING1	= 5
TE_LIGHTNING2	= 6
TE_WIZSPIKE		= 7
TE_KNIGHTSPIKE	= 8
TE_LIGHTNING3	= 9
TE_LAVASPLASH	= 10
TE_TELEPORT		= 11

-- sound channels
-- channel 0 never willingly overrides
-- other channels (1-7) allways override a playing sound on that channel
CHAN_AUTO		= 0
CHAN_WEAPON		= 1
CHAN_VOICE		= 2
CHAN_ITEM		= 3
CHAN_BODY		= 4

ATTN_NONE		= 0
ATTN_NORM		= 1
ATTN_IDLE		= 2
ATTN_STATIC		= 3

-- update types

UPDATE_GENERAL	= 0
UPDATE_STATIC	= 1
UPDATE_BINARY	= 2
UPDATE_TEMP		= 3

-- entity effects

EF_BRIGHTFIELD	= 1
EF_MUZZLEFLASH 	= 2
EF_BRIGHTLIGHT 	= 4
EF_DIMLIGHT 	= 8


-- messages
MSG_BROADCAST	= 0		-- unreliable to all
MSG_ONE			= 1		-- reliable to one (msg_entity)
MSG_ALL			= 2		-- reliable to all
MSG_INIT		= 3		-- write to the init string

AS_STRAIGHT             = 1
AS_SLIDING              = 2
AS_MELEE                = 3
AS_MISSILE              = 4


VEC_ORIGIN = vec3(0, 0, 0)
VEC_HULL_MIN = vec3(-16, -16, -24)
VEC_HULL_MAX = vec3(16, 16, 32)

VEC_HULL2_MIN = vec3(-32, -32, -24)
VEC_HULL2_MAX = vec3(32, 32, 64)

