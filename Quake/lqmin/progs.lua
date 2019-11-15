-- edict.flags
local   FL_FLY                                  = 1;
local   FL_SWIM                                 = 2;
local   FL_CLIENT                               = 8;    -- set for all client edicts
local   FL_INWATER                              = 16;   -- for enter / leave water splash
local   FL_MONSTER                              = 32;
local   FL_GODMODE                              = 64;   -- player cheat
local   FL_NOTARGET                             = 128;  -- player cheat
local   FL_ITEM                                 = 256;  -- extra wide size for bonus items
local   FL_ONGROUND                             = 512;  -- standing on something
local   FL_PARTIALGROUND                = 1024; -- not all corners are valid
local   FL_WATERJUMP                    = 2048; -- player jumping out of water
local   FL_JUMPRELEASED                 = 4096; -- for jump debouncing

-- edict.movetype values
local   MOVETYPE_NONE                   = 0;    -- never moves
--local MOVETYPE_ANGLENOCLIP    = 1;
--local MOVETYPE_ANGLECLIP              = 2;
local   MOVETYPE_WALK                   = 3;    -- players only
local   MOVETYPE_STEP                   = 4;    -- discrete, not real time unless fall
local   MOVETYPE_FLY                    = 5;
local   MOVETYPE_TOSS                   = 6;    -- gravity
local   MOVETYPE_PUSH                   = 7;    -- no clip to world, push and crush
local   MOVETYPE_NOCLIP                 = 8;
local   MOVETYPE_FLYMISSILE             = 9;    -- fly with extra size against monsters
local   MOVETYPE_BOUNCE                 = 10;
local   MOVETYPE_BOUNCEMISSILE  = 11;   -- bounce with extra size

-- edict.solid values
local   SOLID_NOT                               = 0;    -- no interaction with other objects
local   SOLID_TRIGGER                   = 1;    -- touch on edge, but not blocking
local   SOLID_BBOX                              = 2;    -- touch on edge, block
local   SOLID_SLIDEBOX                  = 3;    -- touch on edge, but not an onground
local   SOLID_BSP                               = 4;    -- bsp clip, touch on edge, block

local   CHAN_AUTO               = 0;
local   CHAN_WEAPON             = 1;
local   CHAN_VOICE              = 2;
local   CHAN_ITEM               = 3;
local   CHAN_BODY               = 4;

local   ATTN_NONE               = 0;
local   ATTN_NORM               = 1;
local   ATTN_IDLE               = 2;
local   ATTN_STATIC             = 3;

local DEAD_NO                                 = 0
local DEAD_DYING                              = 1
local DEAD_DEAD                               = 2
local DEAD_RESPAWNABLE                = 3

local DAMAGE_NO                               = 0
local DAMAGE_YES                              = 1
local DAMAGE_AIM                              = 2

local VEC_ORIGIN = vec3(0, 0, 0)
local VEC_HULL_MIN = vec3(-16, -16, -24)
local VEC_HULL_MAX = vec3(16, 16, 32)

local VEC_HULL2_MIN = vec3(-32, -32, -24)
local VEC_HULL2_MAX = vec3(32, 32, 64)

teamplay = 0
skill = 0
framecount = 0
deathmatch = qc.deathmatch
coop = qc.coop

local lastspawn = world
local function SelectSpawnPoint()
        local spot; -- entity
        spot = find (world, "classname", "testplayerstart")
        if spot ~= world then
                return spot
        end

        if coop ~= 0 then
                lastspawn = find(lastspawn, "classname", "info_player_coop")
                if lastspawn == world then
                        lastspawn = find (lastspawn, "classname", "info_player_start")
                end
                if lastspawn ~= world then
                        return lastspawn
                end
        elseif deathmatch ~= 0 then
                lastspawn = find(lastspawn, "classname", "info_player_deathmatch")
                if lastspawn == world then
                        lastspawn = find (lastspawn, "classname", "info_player_deathmatch")
                end
                if lastspawn ~= world then
                        return lastspawn
                end
        end
        if qc.serverflags ~= 0 then
                spot = find (world, "classname", "info_player_start2")
                if spot ~= world then
                        return spot
                end
        end
        spot = find (world, "classname", "info_player_start")
        if  spot == world then
                error ("PutClientInServer: no info_player_start on level")
        end

        return spot
end


qc.main = function() 
end

qc.StartFrame = function()
    teamplay = cvar("teamplay");
    skill = cvar("skill");
end

qc.PlayerPreThink = function()
end

qc.PlayerPostThink = function()
end

qc.ClientKill = function()
    bprint(self.netname);
    bprint(" suicides\n");
    self.frags = self.frags - 2;    -- extra penalty
end

qc.ClientConnect = function()
    bprint(self.netname);
    bprint(" entered the game\n");
end

qc.PutClientInServer = function()
    self.classname = "player"
    self.health = 100
    self.takedamage = DAMAGE_AIM
    self.solid = SOLID_SLIDEBOX
    self.movetype = MOVETYPE_WALK
    self.max_health = 100
    self.flags = FL_CLIENT
    self.effects = 0
    --DecodeLevelParms ();

    self.deadflag = DEAD_NO

    local spot = SelectSpawnPoint()
    self.origin = spot.origin + vec3(0, 0, 1)
    self.angles = spot.angles
    self.fixangle = true           -- turn this way immediately

    -- oh, this is a hack!
    setmodel(self, "progs/eyes.mdl")
    local modelindex_eyes = self.modelindex

    setmodel(self, "progs/player.mdl")
    local modelindex_player = self.modelindex

    setsize(self, VEC_HULL_MIN, VEC_HULL_MAX)
    self.view_ofs = vec3(0, 0, 22)

    if qc.deathmatch or qc.coop then
        makevectors(self.angles)
    end
end

qc.ClientDisconnect = function()
    -- let everyone else know
    bprint(self.netname)
    bprint(" left the game with ")
    bprint(ftos(self.frags))
    bprint (" frags\n")
    sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE)
end

qc.SetNewParms = function()
    qc.parm1 = 0
    qc.parm2 = 100
    qc.parm3 = 0
    qc.parm4 = 25
    qc.parm5 = 0
    qc.parm6 = 0
    qc.parm6 = 0
    qc.parm8 = 1
    qc.parm9 = 0
end

qc.SetChangeParms = function()
    qc.parm1 = 0
    qc.parm2 = 100
    qc.parm3 = 0
    qc.parm4 = 25
    qc.parm5 = 0
    qc.parm6 = 0
    qc.parm6 = 0
    qc.parm8 = 1
    qc.parm9 = 0
end


function worldspawn()
    precache_model ("progs/player.mdl")
    precache_model ("progs/eyes.mdl")
    precache_model ("progs/h_player.mdl")
    precache_model ("progs/gib1.mdl")
    precache_model ("progs/gib2.mdl")
    precache_model ("progs/gib3.mdl")
end
