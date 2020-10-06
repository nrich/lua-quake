/*
Copyright (C) 2019 Neil Richardson (nrich@neiltopia.com)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/


#include "l_common.h"
#include "quakedef.h"
#include "progs.h"

#ifndef ENTITIY_PUSH_NIL_NOT_WORLD
#define ENTITIY_PUSH_NIL_NOT_WORLD 1
#endif

static int l_entity_eq(lua_State *L) {
    int *left = luaL_checkudata(L, 1, GAME_ENTITY);
    int *right = luaL_checkudata(L, 2, GAME_ENTITY);

    lua_pushboolean(L, left[0] == right[0]);

    return 1;
}

static int l_entity_index(lua_State *L) {
    int n = lua_gettop(L);

    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *ed = PROG_TO_EDICT(ent[0]);

    const char *property = luaL_checkstring(L, 2); 
    int len = strlen(property);

    if (n != 2)
        Sys_Error("l_entity_index: Number of args to set `%s' is %d, not 2\n", property, n);
    
    if (strncmp(property, "modelindex", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.modelindex);
    } else if (strncmp(property, "absmin", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(ed->v.absmin, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "absmax", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(ed->v.absmax, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "ltime", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.ltime);
    } else if (strncmp(property, "movetype", 8) == 0 && len == 8) {
        // float
        lua_pushnumber(L, ed->v.movetype);
    } else if (strncmp(property, "solid", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.solid);
    } else if (strncmp(property, "origin", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(ed->v.origin, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "oldorigin", 9) == 0 && len == 9) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(ed->v.oldorigin, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "velocity", 8) == 0 && len == 8) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.velocity);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "angles", 6) == 0 && len == 6) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.angles);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "avelocity", 9) == 0 && len == 9) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.avelocity);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "punchangle", 10) == 0 && len == 10) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.punchangle);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "classname", 9) == 0 && len == 9) {
        // string_t
        lua_pushstring(L, GetString(ed->v.classname));
    } else if (strncmp(property, "model", 5) == 0 && len == 5) {
        // string_t
        lua_pushstring(L, GetString(ed->v.model));
    } else if (strncmp(property, "frame", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.frame);
    } else if (strncmp(property, "skin", 4) == 0 && len == 4) {
        // float
        lua_pushnumber(L, ed->v.skin);
    } else if (strncmp(property, "effects", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.effects);
    } else if (strncmp(property, "mins", 4) == 0 && len == 4) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.mins);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "maxs", 4) == 0 && len == 4) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.maxs);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "size", 4) == 0 && len == 4) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.size);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "touch", 5) == 0 && len == 5) {
        // func_t
        if (ed->v.touch == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, ed->v.touch);
        }
    } else if (strncmp(property, "use", 3) == 0 && len == 3) { 
        // func_t
        if (ed->v.use > 0) {
            lua_rawgeti(L, LUA_REGISTRYINDEX, ed->v.use);
        } else {
            lua_pushnil(L);
        }
    } else if (strncmp(property, "think", 5) == 0 && len == 5) {
        // func_t
        if (ed->v.think > 0) {
            lua_rawgeti(L, LUA_REGISTRYINDEX, ed->v.think);
        } else {
            lua_pushnil(L);
        }
    } else if (strncmp(property, "blocked", 7) == 0 && len == 7) {
        // func_t
        if (ed->v.blocked > 0) {
            lua_rawgeti(L, LUA_REGISTRYINDEX, ed->v.blocked);
        } else {
            lua_pushnil(L);
        }
    } else if (strncmp(property, "nextthink", 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, ed->v.nextthink);
    } else if (strncmp(property, "groundentity", 12) == 0 && len == 12) {
        // edict
        if (ed->v.groundentity == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.groundentity;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "health", 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, ed->v.health);
    } else if (strncmp(property, "frags", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.frags);
    } else if (strncmp(property, "weaponmodel", 11) == 0 && len == 11) {
        // string_t
        lua_pushstring(L, GetString(ed->v.weaponmodel));
    } else if (strncmp(property, "weaponframe", 11) == 0 && len == 11) {
        // float
        lua_pushnumber(L, ed->v.weaponframe);
    } else if (strncmp(property, "weapon", 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, ed->v.weapon);
    } else if (strncmp(property, "currentammo", 11) == 0 && len == 11) {
        // float
        lua_pushnumber(L, ed->v.currentammo);
    } else if (strncmp(property, "ammo_shells", 11) == 0 && len == 11) {
        // float
        lua_pushnumber(L, ed->v.ammo_shells);
    } else if (strncmp(property, "ammo_nails", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.ammo_nails);
    } else if (strncmp(property, "ammo_rockets", 12) == 0 && len == 12) {
        // float
        lua_pushnumber(L, ed->v.ammo_rockets);
    } else if (strncmp(property, "ammo_cells", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.ammo_cells);
    } else if (strncmp(property, "items", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.items);
    } else if (strncmp(property, "takedamage", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.takedamage);
    } else if (strncmp(property, "chain", 5) == 0 && len == 5) {
        // edict
        if (ed->v.chain == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.chain;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "deadflag", 8) == 0 && len == 8) {
        // float
        lua_pushnumber(L, ed->v.deadflag);
    } else if (strncmp(property, "view_ofs", 8) == 0 && len == 8) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.view_ofs);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "button0", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button0);
    } else if (strncmp(property, "button1", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button1);
    } else if (strncmp(property, "button2", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button2);
#ifdef LUAQUAKE_ENHANCED
    } else if (strncmp(property, "button3", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button3);
    } else if (strncmp(property, "button4", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button4);
    } else if (strncmp(property, "button5", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button5);
    } else if (strncmp(property, "button6", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button6);
    } else if (strncmp(property, "button7", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.button7);
#endif
    } else if (strncmp(property, "impulse", 7) == 0 && len == 7) {
        // float
        lua_pushnumber(L, ed->v.impulse);
    } else if (strncmp(property, "fixangle", 8) == 0 && len == 8) {
        // float
        lua_pushboolean(L, ed->v.fixangle);
    } else if (strncmp(property, "v_angle", 7) == 0 && len == 7) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.v_angle);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "idealpitch", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.idealpitch);
    } else if (strncmp(property, "netname", 7) == 0 && len == 7) {
        // string_t
        lua_pushstring(L, GetString(ed->v.netname));
    } else if (strncmp(property, "enemy", 5) == 0 && len == 5) {
        // edict
        if (ed->v.enemy == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.enemy;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "flags", 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, ed->v.flags);
    } else if (strncmp(property, "colormap", 8) == 0 && len == 8) {
        // float
        lua_pushnumber(L, ed->v.colormap);
    } else if (strncmp(property, "team", 4) == 0 && len == 4) {
        // float
        lua_pushnumber(L, ed->v.team);
    } else if (strncmp(property, "max_health", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.max_health);
    } else if (strncmp(property, "teleport_time", 13) == 0 && len == 13) {
        // float
        lua_pushnumber(L, ed->v.teleport_time);
    } else if (strncmp(property, "armortype", 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, ed->v.armortype);
    } else if (strncmp(property, "armorvalue", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.armorvalue);
    } else if (strncmp(property, "waterlevel", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.waterlevel);
    } else if (strncmp(property, "watertype", 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, ed->v.watertype);
    } else if (strncmp(property, "ideal_yaw", 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, ed->v.ideal_yaw);
    } else if (strncmp(property, "yaw_speed", 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, ed->v.yaw_speed);
    } else if (strncmp(property, "aiment", 6) == 0 && len == 6) {
        // edict
        if (ed->v.aiment == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.aiment;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "goalentity", 10) == 0 && len == 10) {
        // edict
        if (ed->v.goalentity == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.goalentity;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "spawnflags", 10) == 0 && len == 10) {
        // float
        lua_pushnumber(L, ed->v.spawnflags);
    } else if (strncmp(property, "target", 6) == 0 && len == 6) {
        // string_t
        lua_pushstring(L, GetString(ed->v.target));
    } else if (strncmp(property, "targetname", 10) == 0 && len == 10) {
        // string_t
        lua_pushstring(L, GetString(ed->v.targetname));
    } else if (strncmp(property, "dmg_take", 8) == 0 && len == 8) {
        // float
        lua_pushnumber(L, ed->v.dmg_take);
    } else if (strncmp(property, "dmg_save", 8) == 0 && len == 8) {
        // float
        lua_pushnumber(L, ed->v.dmg_save);
    } else if (strncmp(property, "dmg_inflictor", 13) == 0 && len == 13) {
        // edict
        if (ed->v.dmg_inflictor == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.dmg_inflictor;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "owner", 5) == 0 && len == 5) {
        // edict
        if (ed->v.owner == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = ed->v.owner;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp(property, "movedir", 7) == 0 && len == 7) {
        // vec3_t
        lua_pushlightuserdata(L, &ed->v.movedir);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp(property, "message", 7) == 0 && len == 7) {
        // string_t
        lua_pushstring(L, GetString(ed->v.message));
    } else if (strncmp(property, "sounds", 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, ed->v.sounds);
    } else if (strncmp(property, "noise1", 6) == 0 && len == 6) {
        // string_t
        lua_pushstring(L, GetString(ed->v.noise1));
    } else if (strncmp(property, "noise2", 6) == 0 && len == 6) {
        // string_t
        lua_pushstring(L, GetString(ed->v.noise2));
    } else if (strncmp(property, "noise3", 6) == 0 && len == 6) {
        // string_t
        lua_pushstring(L, GetString(ed->v.noise3));
    } else if (strncmp(property, "noise", 5) == 0 && len == 5) {
        // string_t
        lua_pushstring(L, GetString(ed->v.noise));
    } else {
        // game local vars
        int *gameref = (int *)(&ed->v.noise3) + 1;

        if (*gameref > 0) {
            lua_rawgeti(L, LUA_REGISTRYINDEX, *gameref);
            if (!lua_isnil(L, -1)) {
                lua_pushstring(L, property);
                lua_gettable(L, -2);
            }
        } else {
            lua_pushnil(L);
        }
    }

    return 1;
}

static int l_entity_newindex(lua_State *L) {
    int n = lua_gettop(L);

    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *ed = PROG_TO_EDICT(ent[0]);

    const char *property = luaL_checkstring(L, 2); 
    int len = strlen(property);

    if (n != 3)
        Sys_Error("l_entity_newindex: Number of args to set `%s' is %d, not 3\n", property, n);

    if (strncmp(property, "modelindex", 10) == 0 && len == 10) {
        ed->v.modelindex = luaL_checknumber(L, 3);
    } else if (strncmp(property, "absmin", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.absmin);
    } else if (strncmp(property, "absmax", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.absmax);
    } else if (strncmp(property, "ltime", 5) == 0 && len == 5) {
        // float
        ed->v.ltime = luaL_checknumber(L, 3);
    } else if (strncmp(property, "movetype", 8) == 0 && len == 8) {
        // float
        ed->v.movetype = luaL_checknumber(L, 3);
    } else if (strncmp(property, "solid", 5) == 0 && len == 5) {
        // float
        ed->v.solid = luaL_checknumber(L, 3);
    } else if (strncmp(property, "origin", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.origin);
    } else if (strncmp(property, "oldorigin", 9) == 0 && len == 9) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.oldorigin);
    } else if (strncmp(property, "velocity", 8) == 0 && len == 8) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.velocity);
    } else if (strncmp(property, "angles", 6) == 0 && len == 6) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.angles);
    } else if (strncmp(property, "avelocity", 9) == 0 && len == 9) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.avelocity);
    } else if (strncmp(property, "punchangle", 10) == 0 && len == 10) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.punchangle);
    } else if (strncmp(property, "classname", 9) == 0 && len == 9) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.classname = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.classname = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "classname");
        }
    } else if (strncmp(property, "model", 5) == 0 && len == 5) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.model = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.model = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "model");
        }
    } else if (strncmp(property, "frame", 5) == 0 && len == 5) {
        // float
        ed->v.frame = luaL_checknumber(L, 3);
    } else if (strncmp(property, "skin", 4) == 0 && len == 4) {
        // float
        ed->v.skin = luaL_checknumber(L, 3);
    } else if (strncmp(property, "effects", 7) == 0 && len == 7) {
        // float
        ed->v.effects = luaL_checknumber(L, 3);
    } else if (strncmp(property, "mins", 4) == 0 && len == 4) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.mins);
    } else if (strncmp(property, "maxs", 4) == 0 && len == 4) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.maxs);
    } else if (strncmp(property, "size", 4) == 0 && len == 4) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.size);
    } else if (strncmp(property, "touch", 5) == 0 && len == 5) {
        // func_t
        if (ed->v.touch != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, ed->v.touch);
        }

        if (lua_isnil(L, 3)) {
            ed->v.touch = LUA_NOREF;
        } else if (lua_isfunction(L, 3)) {
            ed->v.touch = luaL_ref(L, LUA_REGISTRYINDEX);
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "touch");
        }
    } else if (strncmp(property, "use", 3) == 0 && len == 3) { 
        // func_t
        if (ed->v.use > 0) {
            luaL_unref(L, LUA_REGISTRYINDEX, ed->v.use);
        }

        if (lua_isnil(L, 3)) {
            ed->v.use = LUA_NOREF;
        } else if (lua_isfunction(L, 3)) {
            ed->v.use = luaL_ref(L, LUA_REGISTRYINDEX);
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "use");
        }
    } else if (strncmp(property, "think", 5) == 0 && len == 5) {
        // func_t
        if (ed->v.think != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, ed->v.think);
        }

        if (lua_isnil(L, 3)) {
            ed->v.think = LUA_NOREF;
        } else if (lua_isfunction(L, 3)) {
            ed->v.think = luaL_ref(L, LUA_REGISTRYINDEX);
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "think");
        }
    } else if (strncmp(property, "blocked", 7) == 0 && len == 7) {
        // func_t
        if (ed->v.blocked != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, ed->v.blocked);
        }

        if (lua_isnil(L, 3)) {
            ed->v.blocked = LUA_NOREF;
        } else if (lua_isfunction(L, 3)) {
            ed->v.blocked = luaL_ref(L, LUA_REGISTRYINDEX);
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "blocked");
        }
    } else if (strncmp(property, "nextthink", 9) == 0 && len == 9) {
        // float
        ed->v.nextthink = luaL_checknumber(L, 3);
    } else if (strncmp(property, "groundentity", 12) == 0 && len == 12) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.groundentity = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.groundentity = ent[0];
        }
    } else if (strncmp(property, "health", 6) == 0 && len == 6) {
        // float
        ed->v.health = luaL_checknumber(L, 3);
    } else if (strncmp(property, "frags", 5) == 0 && len == 5) {
        // float
        ed->v.frags = luaL_checknumber(L, 3);
    } else if (strncmp(property, "weaponmodel", 11) == 0 && len == 11) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.weaponmodel = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.weaponmodel = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "weaponmodel");
        }
    } else if (strncmp(property, "weaponframe", 11) == 0 && len == 11) {
        // float
        ed->v.weaponframe = luaL_checknumber(L, 3);
    } else if (strncmp(property, "weapon", 6) == 0 && len == 6) {
        // float
        ed->v.weapon = luaL_checknumber(L, 3);
    } else if (strncmp(property, "currentammo", 11) == 0 && len == 11) {
        // float
        ed->v.currentammo = luaL_checknumber(L, 3);
    } else if (strncmp(property, "ammo_shells", 11) == 0 && len == 11) {
        // float
        ed->v.ammo_shells = luaL_checknumber(L, 3);
    } else if (strncmp(property, "ammo_nails", 10) == 0 && len == 10) {
        // float
        ed->v.ammo_nails = luaL_checknumber(L, 3);
    } else if (strncmp(property, "ammo_rockets", 12) == 0 && len == 12) {
        // float
        ed->v.ammo_rockets = luaL_checknumber(L, 3);
    } else if (strncmp(property, "ammo_cells", 10) == 0 && len == 10) {
        // float
        ed->v.ammo_cells = luaL_checknumber(L, 3);
    } else if (strncmp(property, "items", 5) == 0 && len == 5) {
        // float
        ed->v.items = luaL_checknumber(L, 3);
    } else if (strncmp(property, "takedamage", 10) == 0 && len == 10) {
        // float
        ed->v.takedamage = luaL_checknumber(L, 3);
    } else if (strncmp(property, "chain", 5) == 0 && len == 5) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.groundentity = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.chain = ent[0];
        }
    } else if (strncmp(property, "deadflag", 8) == 0 && len == 8) {
        // float
        ed->v.deadflag = luaL_checknumber(L, 3);
    } else if (strncmp(property, "view_ofs", 8) == 0 && len == 8) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.view_ofs);
    } else if (strncmp(property, "button0", 7) == 0 && len == 7) {
        // float
        ed->v.button0 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button1", 7) == 0 && len == 7) {
        // float
        ed->v.button1 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button2", 7) == 0 && len == 7) {
        // float
        ed->v.button2 = luaL_checknumber(L, 3);
#ifdef LUAQUAKE_ENHANCED
    } else if (strncmp(property, "button3", 7) == 0 && len == 7) {
        // float
        ed->v.button3 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button4", 7) == 0 && len == 7) {
        // float
        ed->v.button4 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button5", 7) == 0 && len == 7) {
        // float
        ed->v.button5 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button6", 7) == 0 && len == 7) {
        // float
        ed->v.button6 = luaL_checknumber(L, 3);
    } else if (strncmp(property, "button7", 7) == 0 && len == 7) {
        // float
        ed->v.button7 = luaL_checknumber(L, 3);
#endif
    } else if (strncmp(property, "impulse", 7) == 0 && len == 7) {
        // float
        ed->v.impulse = luaL_checknumber(L, 3);
    } else if (strncmp(property, "fixangle", 8) == 0 && len == 8) {
        // float
        ed->v.fixangle = lua_toboolean(L, 3);
    } else if (strncmp(property, "v_angle", 7) == 0 && len == 7) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.v_angle);
    } else if (strncmp(property, "idealpitch", 10) == 0 && len == 10) {
        // float
        ed->v.idealpitch = luaL_checknumber(L, 3);
    } else if (strncmp(property, "netname", 7) == 0 && len == 7) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.netname = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.netname = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "netname");
        }
    } else if (strncmp(property, "enemy", 5) == 0 && len == 5) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.enemy = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.enemy = ent[0];
        }
    } else if (strncmp(property, "flags", 5) == 0 && len == 5) {
        // float
        ed->v.flags = luaL_checknumber(L, 3);
    } else if (strncmp(property, "colormap", 8) == 0 && len == 8) {
        // float
        ed->v.colormap = luaL_checknumber(L, 3);
    } else if (strncmp(property, "team", 4) == 0 && len == 4) {
        // float
        ed->v.team = luaL_checknumber(L, 3);
    } else if (strncmp(property, "max_health", 10) == 0 && len == 10) {
        // float
        ed->v.max_health = luaL_checknumber(L, 3);
    } else if (strncmp(property, "teleport_time", 13) == 0 && len == 13) {
        // float
        ed->v.teleport_time = luaL_checknumber(L, 3);
    } else if (strncmp(property, "armortype", 9) == 0 && len == 9) {
        // float
        ed->v.armortype = luaL_checknumber(L, 3);
    } else if (strncmp(property, "armorvalue", 10) == 0 && len == 10) {
        // float
        ed->v.armorvalue = luaL_checknumber(L, 3);
    } else if (strncmp(property, "waterlevel", 10) == 0 && len == 10) {
        // float
        ed->v.waterlevel = luaL_checknumber(L, 3);
    } else if (strncmp(property, "watertype", 9) == 0 && len == 9) {
        // float
        ed->v.watertype = luaL_checknumber(L, 3);
    } else if (strncmp(property, "ideal_yaw", 9) == 0 && len == 9) {
        // float
        ed->v.ideal_yaw = luaL_checknumber(L, 3);
    } else if (strncmp(property, "yaw_speed", 9) == 0 && len == 9) {
        // float
        ed->v.yaw_speed = luaL_checknumber(L, 3);
    } else if (strncmp(property, "aiment", 6) == 0 && len == 6) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.aiment = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.aiment = ent[0];
        }
    } else if (strncmp(property, "goalentity", 10) == 0 && len == 10) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.goalentity = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.goalentity = ent[0];
        }
    } else if (strncmp(property, "spawnflags", 10) == 0 && len == 10) {
        // float
        ed->v.spawnflags = luaL_checknumber(L, 3);
    } else if (strncmp(property, "target", 6) == 0 && len == 6) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.target = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.target = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "target");
        }
    } else if (strncmp(property, "targetname", 10) == 0 && len == 10) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.targetname = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.targetname = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "targetname");
        }
    } else if (strncmp(property, "dmg_take", 8) == 0 && len == 8) {
        // float
        ed->v.dmg_take = luaL_checknumber(L, 3);
    } else if (strncmp(property, "dmg_save", 8) == 0 && len == 8) {
        // float
        ed->v.dmg_save = luaL_checknumber(L, 3);
    } else if (strncmp(property, "dmg_inflictor", 13) == 0 && len == 13) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.dmg_inflictor = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.dmg_inflictor = ent[0];
        }
    } else if (strncmp(property, "owner", 5) == 0 && len == 5) {
        // edict
        if (lua_isnil(L, 3)) {
            ed->v.owner = 0;
        } else {
            int *ent = luaL_checkudata(L, 3, GAME_ENTITY);
            ed->v.owner = ent[0];
        }
    } else if (strncmp(property, "movedir", 7) == 0 && len == 7) {
        // vec3_t
        vec3_t *in = luaL_checkudata(L, 3, GAME_VEC3);
        VectorCopy(in[0], ed->v.movedir);
    } else if (strncmp(property, "message", 7) == 0 && len == 7) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.message = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.message = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "message");
        }
    } else if (strncmp(property, "sounds", 6) == 0 && len == 6) {
        // float
        ed->v.sounds = luaL_checknumber(L, 3);
    } else if (strncmp(property, "noise1", 6) == 0 && len == 6) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.noise1 = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.noise1 = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "noise1");
        }

    } else if (strncmp(property, "noise2", 6) == 0 && len == 6) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.noise2 = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.noise2 = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "noise2");
        }

    } else if (strncmp(property, "noise3", 6) == 0 && len == 6) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.noise3 = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.noise3 = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "noise3");
        }
    } else if (strncmp(property, "noise", 5) == 0 && len == 5) {
        // string_t
        if (lua_isnil(L, 3)) {
            ed->v.noise = 0;
        } else if (lua_isstring(L, 3)) {
            ed->v.noise = SetEngineString(lua_tostring(L, 3));
        } else {
            Sys_Error("Value `%s' assigned to `%s' is not a string\n", luaL_typename(L, 3), "noise");
        }
    } else {
        // game local vars
        int *gameref = (int *)(&ed->v.noise3) + 1;

        if (*gameref < 1) {
            lua_newtable(L);
            *gameref = luaL_ref(L, LUA_REGISTRYINDEX);
        }

        lua_rawgeti(L, LUA_REGISTRYINDEX, *gameref);
        lua_pushstring(L, property);
        lua_pushvalue(L, 3);
        lua_settable(L, -3);
    }

    return 0;
}

static int l_entity_tostring(lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);

    lua_pushfstring(L, "%s: %p %d", GAME_ENTITY, ent, ent[0]);
    return 1;
}

int l_entity_register(lua_State *L) {
    luaL_newmetatable(L, GAME_ENTITY);
    lua_pushcfunction(L, l_entity_index);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, l_entity_newindex);
    lua_setfield(L, -2, "__newindex");
    lua_pushcfunction(L, l_entity_eq);
    lua_setfield(L, -2, "__eq");
    lua_pushcfunction(L, l_entity_tostring);
    lua_setfield(L, -2, "__tostring");

    return 1;
}


