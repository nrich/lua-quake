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

int l_builtin_makevectors(lua_State *L);
int l_builtin_setorigin(lua_State *L);
int l_builtin_setmodel(lua_State *L);
int l_builtin_setsize(lua_State *L);
int l_builtin_break(lua_State *L);
int l_builtin_sound(lua_State *L);
int l_builtin_normalize(lua_State *L);
int l_builtin_error(lua_State *L);
int l_builtin_objerror(lua_State *L);
int l_builtin_vlen(lua_State *L);
int l_builtin_vectoyaw(lua_State *L);
int l_builtin_random(lua_State *L);
int l_builtin_fabs(lua_State *L);
int l_builtin_spawn(lua_State *L);
int l_builtin_remove(lua_State *L);
int l_builtin_dprint(lua_State *L);
int l_builtin_bprint(lua_State *L);
int l_builtin_sprint(lua_State *L);
int l_builtin_centerprint(lua_State *L);
int l_builtin_rint(lua_State *L);
int l_builtin_particle(lua_State *L);
int l_builtin_cvar_set(lua_State *L);
int l_builtin_cvar(lua_State *L);
int l_builtin_localcmd(lua_State *L);
int l_builtin_floor(lua_State *L);
int l_builtin_ceil(lua_State *L);
int l_builtin_coredump(lua_State *L);
int l_builtin_traceon(lua_State *L);
int l_builtin_traceoff(lua_State *L);
int l_builtin_eprint(lua_State *L);
int l_builtin_changelevel(lua_State *L);
int l_builtin_checkbottom(lua_State *L);
int l_builtin_pointcontents(lua_State *L);
int l_builtin_ftos(lua_State *L);
int l_builtin_vtos(lua_State *L);
int l_builtin_vectoangles(lua_State *L);
int l_builtin_changeyaw(lua_State *L);
int l_builtin_stuffcmd(lua_State *L);
int l_builtin_lightstyle(lua_State *L);
int l_builtin_precache_model(lua_State *L);
int l_builtin_precache_sound(lua_State *L);
int l_builtin_precache_file(lua_State *L);
int l_builtin_walkmove(lua_State *L);
int l_builtin_droptofloor(lua_State *L);
int l_builtin_nextent(lua_State *L);
int l_builtin_traceline(lua_State *L);
int l_builtin_find(lua_State *L);
int l_builtin_findradius(lua_State *L);
int l_builtin_ambientsound(lua_State *L);
int l_builtin_setspawnparms(lua_State *L);
int l_builtin_movetogoal(lua_State *L);
int l_builtin_precache_model(lua_State *L);
int l_builtin_precache_sound(lua_State *L);
int l_builtin_precache_file(lua_State *L);
int l_builtin_aim(lua_State *L);
int l_builtin_checkclient(lua_State *L);
int l_builtin_makestatic(lua_State *L);
int l_builtin_WriteByte(lua_State *L);
int l_builtin_WriteChar(lua_State *L);
int l_builtin_WriteShort(lua_State *L);
int l_builtin_WriteLong(lua_State *L);
int l_builtin_WriteAngle(lua_State *L);
int l_builtin_WriteCoord(lua_State *L);
int l_builtin_WriteString(lua_State *L);
int l_builtin_WriteEntity(lua_State *L);

static int l_global_index(lua_State *L) {
    int n = lua_gettop(L);

    globalvars_t *g = luaL_checkudata(L, 1, GAME_GLOBAL);

    const char *property = luaL_checkstring(L, 2);
    int len = strlen(property);

    if (n != 2)
        luaL_error(L, "l_global_index: Number of args to set `%s' is %d, not 2\n", property, n);

    if (strncmp("pad", property, 3) == 0 && len == 3) {
        luaL_error(L, "Global property `pad' is not readable\n");
    } else if (strncmp("self", property, 4) == 0 && len == 4) {
        // edict
        if (g->self == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            edict_t *e = PROG_TO_EDICT(g->self);
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = EDICT_TO_PROG(e);

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp("other", property, 5) == 0 && len == 5) {
        // edict
        if (g->other == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            edict_t *e = PROG_TO_EDICT(g->other);
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = EDICT_TO_PROG(e);

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp("world", property, 5) == 0 && len == 5) {
        // edict
        edict_t *e = PROG_TO_EDICT(g->world);
        int *ent = lua_newuserdata(L, sizeof(int));
        ent[0] = EDICT_TO_PROG(e);

        luaL_getmetatable(L, GAME_ENTITY);
        lua_setmetatable(L, -2);
    } else if (strncmp("time", property, 4) == 0 && len == 4) {
        // float
        lua_pushnumber(L, g->time);
    } else if (strncmp("frametime", property, 9) == 0 && len == 9) {
        // float
        lua_pushnumber(L, g->frametime);
    } else if (strncmp("force_retouch", property, 13) == 0 && len == 13) {
        // float
        lua_pushnumber(L, g->frametime);
    } else if (strncmp("mapname", property, 7) == 0 && len == 7) {
        // string_t
        lua_pushstring(L, GetString(g->mapname));
    } else if (strncmp("deathmatch", property, 10) == 0 && len == 10) {
        // float
        lua_pushinteger(L, g->deathmatch);
    } else if (strncmp("coop", property, 4) == 0 && len == 4) {
        // float
        lua_pushinteger(L, g->coop);
    } else if (strncmp("teamplay", property, 8) == 0 && len == 8) {
        // float
        lua_pushinteger(L, g->teamplay);
    } else if (strncmp("serverflags", property, 11) == 0 && len == 11) {
        // float
        lua_pushnumber(L, g->serverflags);
    } else if (strncmp("total_secrets", property, 13) == 0 && len == 13) {
        // float
        lua_pushnumber(L, g->total_secrets);
    } else if (strncmp("total_monsters", property, 14) == 0 && len == 14) {
        // float
        lua_pushnumber(L, g->total_monsters);
    } else if (strncmp("found_secrets", property, 13) == 0 && len == 13) {
        // float
        lua_pushnumber(L, g->found_secrets);
    } else if (strncmp("killed_monsters", property, 15) == 0 && len == 15) {
        // float
        lua_pushnumber(L, g->killed_monsters);
    } else if (strncmp("parm2", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm2);
    } else if (strncmp("parm3", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm3);
    } else if (strncmp("parm4", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm4);
    } else if (strncmp("parm5", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm5);
    } else if (strncmp("parm6", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm6);
    } else if (strncmp("parm7", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm7);
    } else if (strncmp("parm8", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm8);
    } else if (strncmp("parm9", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm9);
    } else if (strncmp("parm10", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm10);
    } else if (strncmp("parm11", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->time);
    } else if (strncmp("parm12", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm12);
    } else if (strncmp("parm13", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm13);
    } else if (strncmp("parm14", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm14);
    } else if (strncmp("parm15", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm15);
    } else if (strncmp("parm16", property, 6) == 0 && len == 6) {
        // float
        lua_pushnumber(L, g->parm16);
    } else if (strncmp("parm1", property, 5) == 0 && len == 5) {
        // float
        lua_pushnumber(L, g->parm1);
    } else if (strncmp("v_forward", property, 9) == 0 && len == 9) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(g->v_forward, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp("v_up", property, 4) == 0 && len == 4) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(g->v_up, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp("v_right", property, 7) == 0 && len == 7) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(g->v_right, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp("trace_allsolid", property, 14) == 0 && len == 14) {
        // float -> bool
        lua_pushboolean(L, g->trace_allsolid);
    } else if (strncmp("trace_startsolid", property, 16) == 0 && len == 16) {
        // float -> bool
        lua_pushboolean(L, g->trace_startsolid);
    } else if (strncmp("trace_fraction", property, 14) == 0 && len == 14) {
        // float
        lua_pushnumber(L, g->trace_fraction);
    } else if (strncmp("trace_endpos", property, 12) == 0 && len == 12) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(g->trace_endpos, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp("trace_plane_normal", property, 18) == 0 && len == 18) {
        // vec3_t
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(g->trace_plane_normal, out[0]);
        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else if (strncmp("trace_plane_dist", property, 16) == 0 && len == 16) {
        // float
        lua_pushnumber(L, g->trace_plane_dist);
    } else if (strncmp("trace_ent", property, 9) == 0 && len == 9) {
        // edict_t
        if (g->trace_ent == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = g->trace_ent;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp("trace_inopen", property, 12) == 0 && len == 12) {
        // float -> boolean
        lua_pushboolean(L, g->trace_inopen);
    } else if (strncmp("trace_inwater", property, 13) == 0 && len == 13) {
        // float -> boolean
        lua_pushboolean(L, g->trace_inwater);
    } else if (strncmp("msg_entity", property, 10) == 0 && len == 10) {
        // edict
        if (g->msg_entity == 0 && ENTITIY_PUSH_NIL_NOT_WORLD) {
            lua_pushnil(L);
        } else {
            int *ent = lua_newuserdata(L, sizeof(int));
            ent[0] = g->msg_entity;

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
        }
    } else if (strncmp("main", property, 4) == 0 && len == 4) {
        // func_t
        if (g->main == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->main);
        }
    } else if (strncmp("StartFrame", property, 10) == 0 && len == 10) {
        // func_t
        if (g->StartFrame == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->StartFrame);
        }
    } else if (strncmp("PlayerPreThink", property, 14) == 0 && len == 14) {
        // func_t
        if (g->PlayerPreThink == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PlayerPreThink);
        }
    } else if (strncmp("PlayerPostThink", property, 15) == 0 && len == 15) {
        // func_t
        if (g->PlayerPostThink == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PlayerPostThink);
        }
    } else if (strncmp("ClientKill", property, 10) == 0 && len == 10) {
        // func_t
        if (g->ClientKill == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientKill);
        }
    } else if (strncmp("ClientConnect", property, 13) == 0 && len == 13) {
        // func_t
        if (g->ClientConnect == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientConnect);
        }
    } else if (strncmp("PutClientInServer", property, 17) == 0 && len == 17) {
        // func_t
        if (g->PutClientInServer == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PutClientInServer);
        }
    } else if (strncmp("ClientDisconnect", property, 16) == 0 && len == 16) {
        // func_t
        if (g->ClientDisconnect == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientDisconnect);
        }
    } else if (strncmp("SetNewParms", property, 11) == 0 && len == 11) {
        // func_t
        if (g->SetNewParms == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->SetNewParms);
        }
    } else if (strncmp("SetChangeParms", property, 14) == 0 && len == 14) {
        // func_t
        if (g->SetChangeParms == LUA_NOREF) {
            lua_pushnil(L);
        } else {
            lua_rawgeti(L, LUA_REGISTRYINDEX, g->SetChangeParms);
        }
#if 1
    } else if (strncmp("makevectors", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_makevectors);
    } else if (strncmp("setorigin", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_setorigin);
    } else if (strncmp("setmodel", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_setmodel);
    } else if (strncmp("setsize", property, 7) == 0 && len == 7) {
        lua_pushcfunction(L, l_builtin_setsize);
    } else if (strncmp("break", property, 5) == 0 && len == 5) {
        lua_pushcfunction(L, l_builtin_break);
    } else if (strncmp("sound", property, 5) == 0 && len == 5) {
        lua_pushcfunction(L, l_builtin_sound);
    } else if (strncmp("normalize", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_normalize);
    } else if (strncmp("error", property, 5) == 0 && len == 5) {
        lua_pushcfunction(L, l_builtin_error);
    } else if (strncmp("objerror", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_objerror);
    } else if (strncmp("vlen", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_vlen);
    } else if (strncmp("vectoyaw", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_vectoyaw);
    } else if (strncmp("random", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_random);
    } else if (strncmp("fabs", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_fabs);
    } else if (strncmp("spawn", property, 5) == 0 && len == 5) {
        lua_pushcfunction(L, l_builtin_spawn);
    } else if (strncmp("remove", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_remove);
    } else if (strncmp("dprint", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_dprint);
    } else if (strncmp("bprint", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_bprint);
    } else if (strncmp("sprint", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_sprint);
    } else if (strncmp("centerprint", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_centerprint);
    } else if (strncmp("rint", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_rint);
    } else if (strncmp("particle", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_particle);
    } else if (strncmp("cvar_set", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_cvar_set);
    } else if (strncmp("cvar", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_cvar);
    } else if (strncmp("localcmd", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_localcmd);
    } else if (strncmp("floor", property, 5) == 0 && len == 5) {
        lua_pushcfunction(L, l_builtin_floor);
    } else if (strncmp("ceil", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_ceil);
    } else if (strncmp("coredump", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_coredump);
    } else if (strncmp("traceon", property, 7) == 0 && len == 7) {
        lua_pushcfunction(L, l_builtin_traceon);
    } else if (strncmp("traceoff", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_traceoff);
    } else if (strncmp("eprint", property, 6) == 0 && len == 6) {
        lua_pushcfunction(L, l_builtin_eprint);
    } else if (strncmp("changelevel", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_changelevel);
    } else if (strncmp("checkbottom", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_checkbottom);
    } else if (strncmp("pointcontents", property, 13) == 0 && len == 13) {
        lua_pushcfunction(L, l_builtin_pointcontents);
    } else if (strncmp("ftos", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_ftos);
    } else if (strncmp("vtos", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_vtos);
    } else if (strncmp("vectoangles", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_vectoangles);
    } else if (strncmp("changeyaw", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_changeyaw);
    } else if (strncmp("stuffcmd", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_stuffcmd);
    } else if (strncmp("lightstyle", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_lightstyle);
    } else if (strncmp("precache_model", property, 14) == 0 && len == 14) {
        lua_pushcfunction(L, l_builtin_precache_model);
    } else if (strncmp("precache_sound", property, 14) == 0 && len == 14) {
        lua_pushcfunction(L, l_builtin_precache_sound);
    } else if (strncmp("precache_file", property, 13) == 0 && len == 13) {
        lua_pushcfunction(L, l_builtin_precache_file);
    } else if (strncmp("walkmove", property, 8) == 0 && len == 8) {
        lua_pushcfunction(L, l_builtin_walkmove);
    } else if (strncmp("droptofloor", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_droptofloor);
    } else if (strncmp("nextent", property, 7) == 0 && len == 7) {
        lua_pushcfunction(L, l_builtin_nextent);
    } else if (strncmp("traceline", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_traceline);
    } else if (strncmp("find", property, 4) == 0 && len == 4) {
        lua_pushcfunction(L, l_builtin_find);
    } else if (strncmp("findradius", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_findradius);
    } else if (strncmp("ambientsound", property, 12) == 0 && len == 12) {
        lua_pushcfunction(L, l_builtin_ambientsound);
    } else if (strncmp("setspawnparms", property, 13) == 0 && len == 13) {
        lua_pushcfunction(L, l_builtin_setspawnparms);
    } else if (strncmp("movetogoal", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_movetogoal);
    } else if (strncmp("precache_model2", property, 15) == 0 && len == 15) {
        lua_pushcfunction(L, l_builtin_precache_model);
    } else if (strncmp("precache_sound2", property, 15) == 0 && len == 15) {
        lua_pushcfunction(L, l_builtin_precache_sound);
    } else if (strncmp("precache_file2", property, 14) == 0 && len == 14) {
        lua_pushcfunction(L, l_builtin_precache_file);
    } else if (strncmp("aim", property, 3) == 0 && len == 3) {
        lua_pushcfunction(L, l_builtin_aim);
    } else if (strncmp("checkclient", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_checkclient);
    } else if (strncmp("makestatic", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_makestatic);
    } else if (strncmp("WriteByte", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_WriteByte);
    } else if (strncmp("WriteChar", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_WriteChar);
    } else if (strncmp("WriteShort", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_WriteShort);
    } else if (strncmp("WriteLong", property, 9) == 0 && len == 9) {
        lua_pushcfunction(L, l_builtin_WriteLong);
    } else if (strncmp("WriteAngle", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_WriteAngle);
    } else if (strncmp("WriteCoord", property, 10) == 0 && len == 10) {
        lua_pushcfunction(L, l_builtin_WriteCoord);
    } else if (strncmp("WriteString", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_WriteString);
    } else if (strncmp("WriteEntity", property, 11) == 0 && len == 11) {
        lua_pushcfunction(L, l_builtin_WriteEntity);
#endif
#if 1
    } else if (strncmp("MOVETYPE_NONE", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MOVETYPE_NONE);
    } else if (strncmp("MOVETYPE_ANGLENOCLIP", property, 20) == 0 && len == 20) {
        lua_pushinteger(L, MOVETYPE_ANGLENOCLIP);
    } else if (strncmp("MOVETYPE_ANGLECLIP", property, 18) == 0 && len == 18) {
        lua_pushinteger(L, MOVETYPE_ANGLECLIP);
    } else if (strncmp("MOVETYPE_WALK", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MOVETYPE_WALK);
    } else if (strncmp("MOVETYPE_STEP", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MOVETYPE_STEP);
    } else if (strncmp("MOVETYPE_FLY", property, 12) == 0 && len == 12) {
        lua_pushinteger(L, MOVETYPE_FLY);
    } else if (strncmp("MOVETYPE_TOSS", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MOVETYPE_TOSS);
    } else if (strncmp("MOVETYPE_PUSH", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MOVETYPE_PUSH);
    } else if (strncmp("MOVETYPE_NOCLIP", property, 15) == 0 && len == 15) {
        lua_pushinteger(L, MOVETYPE_NOCLIP);
    } else if (strncmp("MOVETYPE_FLYMISSILE", property, 19) == 0 && len == 19) {
        lua_pushinteger(L, MOVETYPE_FLYMISSILE);
    } else if (strncmp("MOVETYPE_BOUNCE", property, 15) == 0 && len == 15) {
        lua_pushinteger(L, MOVETYPE_BOUNCE);
    } else if (strncmp("SOLID_NOT", property, 9) == 0 && len == 9) {
        lua_pushinteger(L, SOLID_NOT);
    } else if (strncmp("SOLID_TRIGGER", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, SOLID_TRIGGER);
    } else if (strncmp("SOLID_BBOX", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, SOLID_BBOX);
    } else if (strncmp("SOLID_SLIDEBOX", property, 14) == 0 && len == 14) {
        lua_pushinteger(L, SOLID_SLIDEBOX);
    } else if (strncmp("SOLID_BSP", property, 9) == 0 && len == 9) {
        lua_pushinteger(L, SOLID_BSP);
    } else if (strncmp("DEAD_NO", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, DEAD_NO);
    } else if (strncmp("DEAD_DYING", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, DEAD_DYING);
    } else if (strncmp("DEAD_DEAD", property, 9) == 0 && len == 9) {
        lua_pushinteger(L, DEAD_DEAD);
    } else if (strncmp("DAMAGE_NO", property, 9) == 0 && len == 9) {
        lua_pushinteger(L, DAMAGE_NO);
    } else if (strncmp("DAMAGE_YES", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, DAMAGE_YES);
    } else if (strncmp("DAMAGE_AIM", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, DAMAGE_AIM);
    } else if (strncmp("FL_FLY", property, 6) == 0 && len == 6) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_SWIM", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, FL_SWIM);
    } else if (strncmp("FL_CONVEYOR", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, FL_CONVEYOR);
    } else if (strncmp("FL_CLIENT", property, 9) == 0 && len == 9) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_INWATER", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_MONSTER", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_GODMODE", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_NOTARGET", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_ITEM", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_ONGROUND", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_PARTIALGROUND", property, 16) == 0 && len == 16) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_WATERJUMP", property, 12) == 0 && len == 12) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("FL_JUMPRELEASED", property, 15) == 0 && len == 15) {
        lua_pushinteger(L, FL_FLY);
    } else if (strncmp("EF_BRIGHTFIELD", property, 14) == 0 && len == 14) {
        lua_pushinteger(L, EF_BRIGHTFIELD);
    } else if (strncmp("EF_MUZZLEFLASH", property, 14) == 0 && len == 14) {
        lua_pushinteger(L, EF_MUZZLEFLASH);
    } else if (strncmp("EF_BRIGHTLIGHT", property, 14) == 0 && len == 14) {
        lua_pushinteger(L, EF_BRIGHTLIGHT);
    } else if (strncmp("EF_DIMLIGHT", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, EF_DIMLIGHT);
    } else if (strncmp("SPAWNFLAG_NOT_EASY", property, 18) == 0 && len == 18) {
        lua_pushinteger(L, SPAWNFLAG_NOT_EASY);
    } else if (strncmp("SPAWNFLAG_NOT_MEDIUM", property, 20) == 0 && len == 20) {
        lua_pushinteger(L, SPAWNFLAG_NOT_MEDIUM);
    } else if (strncmp("SPAWNFLAG_NOT_HARD", property, 18) == 0 && len == 18) {
        lua_pushinteger(L, SPAWNFLAG_NOT_HARD);
    } else if (strncmp("SPAWNFLAG_NOT_DEATHMATCH", property, 24) == 0 && len == 24) {
        lua_pushinteger(L, SPAWNFLAG_NOT_DEATHMATCH);
    } else if (strncmp("MSG_BROADCAST", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, MSG_BROADCAST);
    } else if (strncmp("MSG_ONE", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, MSG_ONE);
    } else if (strncmp("MSG_ALL", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, MSG_ALL);
    } else if (strncmp("MSG_INIT", property, 8) == 0 && len == 8) {
        lua_pushinteger(L, MSG_INIT);
    } else if (strncmp("TE_SPIKE", property, 8) == 0 && len == 8) {
        lua_pushinteger(L, TE_SPIKE);
    } else if (strncmp("TE_SUPERSPIKE", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_SUPERSPIKE);
    } else if (strncmp("TE_GUNSHOT", property, 10) == 0 && len == 10) {
        lua_pushinteger(L, TE_GUNSHOT);
    } else if (strncmp("TE_EXPLOSION", property, 12) == 0 && len == 12) {
        lua_pushinteger(L, TE_EXPLOSION);
    } else if (strncmp("TE_TAREXPLOSION", property, 15) == 0 && len == 15) {
        lua_pushinteger(L, TE_TAREXPLOSION);
    } else if (strncmp("TE_LIGHTNING1", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_LIGHTNING1);
    } else if (strncmp("TE_LIGHTNING2", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_LIGHTNING2);
    } else if (strncmp("TE_WIZSPIKE", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, TE_WIZSPIKE);
    } else if (strncmp("TE_KNIGHTSPIKE", property, 14) == 0 && len == 14) {
        lua_pushinteger(L, TE_KNIGHTSPIKE);
    } else if (strncmp("TE_LIGHTNING3", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_LIGHTNING3);
    } else if (strncmp("TE_LAVASPLASH", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_LAVASPLASH);
    } else if (strncmp("TE_TELEPORT", property, 11) == 0 && len == 11) {
        lua_pushinteger(L, TE_TELEPORT);
    } else if (strncmp("TE_EXPLOSION2", property, 13) == 0 && len == 13) {
        lua_pushinteger(L, TE_EXPLOSION2);
    } else if (strncmp("TE_BEAM", property, 7) == 0 && len == 7) {
        lua_pushinteger(L, TE_BEAM);
#endif
    } else {
        luaL_error(L, "l_global_index: Unknown field `%s' %d\n", property, len);
    }
    return 1;
}

static int l_global_newindex(lua_State *L) {
    int n = lua_gettop(L);

    globalvars_t *g = luaL_checkudata(L, 1, GAME_GLOBAL);

    const char *property = luaL_checkstring(L, 2);
    int len = strlen(property);

    if (n != 3)
        luaL_error(L, "l_global_index: Number of args to set `%s' is %d, not 3\n", property, n);

    if (strncmp("pad", property, 3) == 0 && len == 3) {
        luaL_error(L, "Global property `pad' is not assignable\n");
    } else if (strncmp("self", property, 4) == 0 && len == 4) {
        // edict
        luaL_error(L, "Global property `self' is not assignable\n");
    } else if (strncmp("other", property, 5) == 0 && len == 5) {
        // edict
        luaL_error(L, "Global property `other' is not assignable\n");
    } else if (strncmp("world", property, 5) == 0 && len == 5) {
        // edict
        luaL_error(L, "Global property `world' is not assignable\n");
    } else if (strncmp("time", property, 4) == 0 && len == 4) {
        // float
        luaL_error(L, "Global property `time' is not assignable\n");
    } else if (strncmp("frametime", property, 9) == 0 && len == 9) {
        // float
        g->frametime = luaL_checknumber(L, 3);
    } else if (strncmp("force_retouch", property, 13) == 0 && len == 13) {
        // float
        g->force_retouch = luaL_checknumber(L, 3);
    } else if (strncmp("mapname", property, 7) == 0 && len == 7) {
        // string_t
        luaL_error(L, "Global property `mapname' is not assignable\n");
    } else if (strncmp("deathmatch", property, 10) == 0 && len == 10) {
        // float
        luaL_error(L, "Global property `deathmatch' is not assignable\n");
    } else if (strncmp("coop", property, 4) == 0 && len == 4) {
        // float
        luaL_error(L, "Global property `coop' is not assignable\n");
    } else if (strncmp("teamplay", property, 8) == 0 && len == 8) {
        // float
        luaL_error(L, "Global property `teamplay' is not assignable\n");
    } else if (strncmp("serverflags", property, 11) == 0 && len == 11) {
        // float
        g->serverflags = luaL_checknumber(L, 3);
    } else if (strncmp("total_secrets", property, 13) == 0 && len == 13) {
        // float
        g->total_secrets = luaL_checknumber(L, 3);
    } else if (strncmp("total_monsters", property, 14) == 0 && len == 14) {
        // float
        g->total_monsters = luaL_checknumber(L, 3);
    } else if (strncmp("found_secrets", property, 13) == 0 && len == 13) {
        // float
        g->found_secrets = luaL_checknumber(L, 3);
    } else if (strncmp("killed_monsters", property, 15) == 0 && len == 15) {
        // float
        g->killed_monsters = luaL_checknumber(L, 3);
    } else if (strncmp("parm2", property, 5) == 0 && len == 5) {
        // float
        g->parm2 = luaL_checknumber(L, 3);
    } else if (strncmp("parm3", property, 5) == 0 && len == 5) {
        // float
        g->parm3 = luaL_checknumber(L, 3);
    } else if (strncmp("parm4", property, 5) == 0 && len == 5) {
        // float
        g->parm4 = luaL_checknumber(L, 3);
    } else if (strncmp("parm5", property, 5) == 0 && len == 5) {
        // float
        g->parm5 = luaL_checknumber(L, 3);
    } else if (strncmp("parm6", property, 5) == 0 && len == 5) {
        // float
        g->parm6 = luaL_checknumber(L, 3);
    } else if (strncmp("parm7", property, 5) == 0 && len == 5) {
        // float
        g->parm7 = luaL_checknumber(L, 3);
    } else if (strncmp("parm8", property, 5) == 0 && len == 5) {
        // float
        g->parm8 = luaL_checknumber(L, 3);
    } else if (strncmp("parm9", property, 5) == 0 && len == 5) {
        // float
        g->parm9 = luaL_checknumber(L, 3);
    } else if (strncmp("parm10", property, 6) == 0 && len == 6) {
        // float
        g->parm10 = luaL_checknumber(L, 3);
    } else if (strncmp("parm11", property, 6) == 0 && len == 6) {
        // float
        g->parm11 = luaL_checknumber(L, 3);
    } else if (strncmp("parm12", property, 6) == 0 && len == 6) {
        // float
        g->parm12 = luaL_checknumber(L, 3);
    } else if (strncmp("parm13", property, 6) == 0 && len == 6) {
        // float
        g->parm13 = luaL_checknumber(L, 3);
    } else if (strncmp("parm14", property, 6) == 0 && len == 6) {
        // float
        g->parm14 = luaL_checknumber(L, 3);
    } else if (strncmp("parm15", property, 6) == 0 && len == 6) {
        // float
        g->parm15 = luaL_checknumber(L, 3);
    } else if (strncmp("parm16", property, 6) == 0 && len == 6) {
        // float
        g->parm16 = luaL_checknumber(L, 3);
    } else if (strncmp("parm1", property, 5) == 0 && len == 5) {
        // float
        g->parm1 = luaL_checknumber(L, 3);
    } else if (strncmp("v_forward", property, 9) == 0 && len == 9) {
        // vec3_t
        luaL_error(L, "Global property `v_forward' is not assignable\n");
    } else if (strncmp("v_up", property, 4) == 0 && len == 4) {
        // vec3_t
        luaL_error(L, "Global property `v_up' is not assignable\n");
    } else if (strncmp("v_right", property, 7) == 0 && len == 7) {
        // vec3_t
        luaL_error(L, "Global property `v_right' is not assignable\n");
    } else if (strncmp("trace_allsolid", property, 14) == 0 && len == 14) {
        // float
        luaL_error(L, "Global property `trace_allsolid' is not assignable\n");
    } else if (strncmp("trace_startsolid", property, 16) == 0 && len == 16) {
        // float
        luaL_error(L, "Global property `trace_startsolid' is not assignable\n");
    } else if (strncmp("trace_fraction", property, 14) == 0 && len == 14) {
        // float
        luaL_error(L, "Global property `trace_fraction' is not assignable\n");
    } else if (strncmp("trace_endpos", property, 12) == 0 && len == 12) {
        // vec3_t
        luaL_error(L, "Global property `trace_plane_normal' is not assignable\n");
    } else if (strncmp("trace_plane_normal", property, 18) == 0 && len == 18) {
        // vec3_t
        luaL_error(L, "Global property `trace_plane_normal' is not assignable\n");
    } else if (strncmp("trace_plane_dist", property, 16) == 0 && len == 16) {
        // float
        luaL_error(L, "Global property `trace_plane_dist' is not assignable\n");
    } else if (strncmp("trace_ent", property, 9) == 0 && len == 9) {
        // edict_t
        luaL_error(L, "Global property `trace_ent' is not assignable\n");
    } else if (strncmp("trace_inopen", property, 12) == 0 && len == 12) {
        // float
        luaL_error(L, "Global property `trace_inopen' is not assignable\n");
    } else if (strncmp("trace_inwater", property, 13) == 0 && len == 13) {
        // float
        luaL_error(L, "Global property `trace_inwater' is not assignable\n");
    } else if (strncmp("msg_entity", property, 10) == 0 && len == 10) {
        // edict
        luaL_error(L, "Global property `msg_entity' is not assignable\n");
    } else if (strncmp("main", property, 4) == 0 && len == 4) {
        // func_t
        if (g->main != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->main);
        }

        if (lua_isnil(L, 3)) {
            g->main = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "main");
        } else if (lua_isfunction(L, 3)) {
            g->main = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->main);
            lua_setglobal(L, "main");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "main");
        }
    } else if (strncmp("StartFrame", property, 10) == 0 && len == 10) {
        // func_t
        if (g->StartFrame != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->StartFrame);
        }

        if (lua_isnil(L, 3)) {
            g->StartFrame = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "StartFrame");
        } else if (lua_isfunction(L, 3)) {
            g->StartFrame = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->StartFrame);
            lua_setglobal(L, "StartFrame");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "StartFrame");
        }
    } else if (strncmp("PlayerPreThink", property, 14) == 0 && len == 14) {
        // func_t
        if (g->PlayerPreThink != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->PlayerPreThink);
        }

        if (lua_isnil(L, 3)) {
            g->PlayerPreThink = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "PlayerPostThink");
        } else if (lua_isfunction(L, 3)) {
            g->PlayerPreThink = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PlayerPostThink);
            lua_setglobal(L, "PlayerPostThink");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "PlayerPreThink");
        }

    } else if (strncmp("PlayerPostThink", property, 15) == 0 && len == 15) {
        // func_t
        if (g->PlayerPostThink != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->PlayerPostThink);
        }

        if (lua_isnil(L, 3)) {
            g->PlayerPostThink = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "PlayerPostThink");
        } else if (lua_isfunction(L, 3)) {
            g->PlayerPostThink = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PlayerPostThink);
            lua_setglobal(L, "PlayerPostThink");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "PlayerPostThink");
        }

    } else if (strncmp("ClientKill", property, 10) == 0 && len == 10) {
        // func_t
        if (g->ClientKill != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->ClientKill);
        }

        if (lua_isnil(L, 3)) {
            g->ClientKill = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "ClientKill");
        } else if (lua_isfunction(L, 3)) {
            g->ClientKill = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientKill);
            lua_setglobal(L, "ClientKill");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "ClientKill");
        }

    } else if (strncmp("ClientConnect", property, 13) == 0 && len == 13) {
        // func_t
        if (g->ClientConnect != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->ClientConnect);
        }

        if (lua_isnil(L, 3)) {
            g->ClientConnect = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "ClientConnect");
        } else if (lua_isfunction(L, 3)) {
            g->ClientConnect = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientConnect);
            lua_setglobal(L, "ClientConnect");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "ClientConnect");
        }

    } else if (strncmp("PutClientInServer", property, 17) == 0 && len == 17) {
        // func_t
        if (g->PutClientInServer != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->PutClientInServer);
        }

        if (lua_isnil(L, 3)) {
            g->PutClientInServer = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "PutClientInServer");
        } else if (lua_isfunction(L, 3)) {
            g->PutClientInServer = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->PutClientInServer);
            lua_setglobal(L, "PutClientInServer");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "PutClientInServer");
        }

    } else if (strncmp("ClientDisconnect", property, 16) == 0 && len == 16) {
        // func_t
        if (g->ClientDisconnect != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->ClientDisconnect);
        }

        if (lua_isnil(L, 3)) {
            g->ClientDisconnect = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "ClientDisconnect");
        } else if (lua_isfunction(L, 3)) {
            g->ClientDisconnect = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->ClientDisconnect);
            lua_setglobal(L, "ClientDisconnect");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "ClientDisconnect");
        }

    } else if (strncmp("SetNewParms", property, 11) == 0 && len == 11) {
        // func_t
        if (g->SetNewParms != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->SetNewParms);
        }

        if (lua_isnil(L, 3)) {
            g->SetNewParms = LUA_NOREF;

            lua_pushnil(L);
            lua_setglobal(L, "SetNewParms");
        } else if (lua_isfunction(L, 3)) {
            g->SetNewParms = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->SetNewParms);
            lua_setglobal(L, "SetNewParms");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "SetNewParms");
        }
    } else if (strncmp("SetChangeParms", property, 14) == 0 && len == 14) {
        // func_t
        if (g->SetChangeParms != LUA_NOREF) {
            luaL_unref(L, LUA_REGISTRYINDEX, g->SetChangeParms);
        }

        if (lua_isnil(L, 3)) {
            g->SetChangeParms = LUA_NOREF;
            lua_pushnil(L);
            lua_setglobal(L, "SetChangeParms");
        } else if (lua_isfunction(L, 3)) {
            g->SetChangeParms = luaL_ref(L, LUA_REGISTRYINDEX);

            lua_rawgeti(L, LUA_REGISTRYINDEX, g->SetChangeParms);
            lua_setglobal(L, "SetChangeParms");
        } else {
            luaL_error(L, "Value `%s' assigned to `%s' is not a function\n", luaL_typename(L, 3), "SetChangeParms");
        }
#if 1
    } else if (strncmp("makevectors", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("setorigin", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("setmodel", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("setsize", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("break", property, 5) == 0 && len == 5) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("sound", property, 5) == 0 && len == 5) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("normalize", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("error", property, 5) == 0 && len == 5) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("objerror", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("vlen", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("vectoyaw", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("random", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("fabs", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("spawn", property, 5) == 0 && len == 5) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("remove", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("dprint", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("bprint", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("sprint", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("centerprint", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("rint", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("particle", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("cvar_set", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("cvar", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("localcmd", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("floor", property, 5) == 0 && len == 5) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("ceil", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("coredump", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("traceon", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("traceoff", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("eprint", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("changelevel", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("checkbottom", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("pointcontents", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("ftos", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("vtos", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("vectoangles", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("changeyaw", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("stuffcmd", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("lightstyle", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_model", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_sound", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_file", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("walkmove", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("droptofloor", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("nextent", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("traceline", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("find", property, 4) == 0 && len == 4) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("findradius", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("ambientsound", property, 12) == 0 && len == 12) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("setspawnparms", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("movetogoal", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_model2", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_sound2", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("precache_file2", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("aim", property, 3) == 0 && len == 3) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("checkclient", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("makestatic", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteByte", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteChar", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteShort", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteLong", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteAngle", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteCoord", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteString", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("WriteEntity", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
#endif

#if 1
    } else if (strncmp("MOVETYPE_NONE", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_ANGLENOCLIP", property, 20) == 0 && len == 20) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_ANGLECLIP", property, 18) == 0 && len == 18) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_WALK", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_STEP", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_FLY", property, 12) == 0 && len == 12) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_TOSS", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_PUSH", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_NOCLIP", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_FLYMISSILE", property, 19) == 0 && len == 19) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MOVETYPE_BOUNCE", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SOLID_NOT", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SOLID_TRIGGER", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SOLID_BBOX", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SOLID_SLIDEBOX", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SOLID_BSP", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DEAD_NO", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DEAD_DYING", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DEAD_DEAD", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DAMAGE_NO", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DAMAGE_YES", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("DAMAGE_AIM", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_FLY", property, 6) == 0 && len == 6) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_SWIM", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_CONVEYOR", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_CLIENT", property, 9) == 0 && len == 9) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_INWATER", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_MONSTER", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_GODMODE", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_NOTARGET", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_ITEM", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_ONGROUND", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_PARTIALGROUND", property, 16) == 0 && len == 16) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_WATERJUMP", property, 12) == 0 && len == 12) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("FL_JUMPRELEASED", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("EF_BRIGHTFIELD", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("EF_MUZZLEFLASH", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("EF_BRIGHTLIGHT", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("EF_DIMLIGHT", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SPAWNFLAG_NOT_EASY", property, 18) == 0 && len == 18) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SPAWNFLAG_NOT_MEDIUM", property, 20) == 0 && len == 20) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SPAWNFLAG_NOT_HARD", property, 18) == 0 && len == 18) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("SPAWNFLAG_NOT_DEATHMATCH", property, 24) == 0 && len == 24) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MSG_BROADCAST", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MSG_ONE", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MSG_ALL", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("MSG_INIT", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_SPIKE", property, 8) == 0 && len == 8) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_SUPERSPIKE", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_GUNSHOT", property, 10) == 0 && len == 10) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_EXPLOSION", property, 12) == 0 && len == 12) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_TAREXPLOSION", property, 15) == 0 && len == 15) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_LIGHTNING1", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_LIGHTNING2", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_WIZSPIKE", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_KNIGHTSPIKE", property, 14) == 0 && len == 14) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_LIGHTNING3", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_LAVASPLASH", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_TELEPORT", property, 11) == 0 && len == 11) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_EXPLOSION2", property, 13) == 0 && len == 13) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
    } else if (strncmp("TE_BEAM", property, 7) == 0 && len == 7) {
        luaL_error(L, "Global property `%s' is not assignable\n", property);
#endif

    } else {
        luaL_error(L, "l_global_newindex: Unknown field `%s'\n", property);
    }

    return 0;
}

static int l_global_tostring(lua_State *L) {
    globalvars_t *g = luaL_checkudata(L, 1, GAME_GLOBAL);

    lua_pushfstring(L, "%s: %p %p", GAME_GLOBAL, g, pr_global_struct);
    return 1;
}

int l_global_register(lua_State *L) {
    luaL_newmetatable(L, GAME_GLOBAL);

    lua_pushcfunction(L, l_global_index);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, l_global_newindex);
    lua_setfield(L, -2, "__newindex");
    lua_pushcfunction(L, l_global_tostring);
    lua_setfield(L, -2, "__tostring");

    return 1;
}

