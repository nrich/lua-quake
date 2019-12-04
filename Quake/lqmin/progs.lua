local function SelectSpawnPoint()
    local spot = find (world, "classname", "info_player_start")
    if  spot == world then
        error ("PutClientInServer: no info_player_start on level")
    end

    return spot
end

qc.PutClientInServer = function()
    self.health = 100
    self.solid = 3 -- SOLID_SLIDEBOX
    self.movetype = 3 -- MOVETYPE_WALK
    self.flags = 8 -- FL_CLIENT
    self.effects = 0

    local spot = SelectSpawnPoint()
    self.origin = spot.origin + vec3(0, 0, 1)
    self.angles = spot.angles
    self.fixangle = true           -- turn this way immediately

    setmodel(self, "progs/player.mdl")

    setsize(self, vec3(-16, -16, -24), vec3(16, 16, 24))
    self.view_ofs = vec3(0, 0, 22)
end

function worldspawn()
    precache_model ("progs/player.mdl")
end
