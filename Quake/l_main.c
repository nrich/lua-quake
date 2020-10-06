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

#define NUM_OF_FIELDS 77

extern        char            *pr_strings;
extern        int             pr_stringssize;
extern        const char      **pr_knownstrings;
extern        int             pr_maxknownstrings;
extern        int             pr_numknownstrings;
extern  ddef_t          *pr_fielddefs;

int use_luaVM;

static dprograms_t lprogs;

int l_vec3_register(lua_State *L);
int l_entity_register(lua_State *L);
int l_global_register(lua_State *L);
void l_builtins(lua_State *L);

static const char *l_entity_fields[] = {
    "modelindex",
    "absmin",
    "absmax",
    "ltime",
    "movetype",
    "solid",
    "origin",
    "oldorigin",
    "velocity",
    "angles",
    "avelocity",
    "punchangle",
    "classname",
    "model",
    "frame",
    "skin",
    "effects",
    "mins",
    "maxs",
    "size",
    "touch",
    "use",
    "think",
    "blocked",
    "nextthink",
    "groundentity",
    "health",
    "frags",
    "weapon",
    "weaponmodel",
    "weaponframe",
    "currentammo",
    "ammo_shells",
    "ammo_nails",
    "ammo_rockets",
    "ammo_cells",
    "items",
    "takedamage",
    "chain",
    "deadflag",
    "view_ofs",
    "button0",
    "button1",
    "button2",
#ifdef LUAQUAKE_ENHANCED
    "button3",
    "button4",
    "button5",
    "button6",
    "button7",
#endif
    "impulse",
    "fixangle",
    "v_angle",
    "idealpitch",
    "netname",
    "enemy",
    "flags",
    "colormap",
    "team",
    "max_health",
    "teleport_time",
    "armortype",
    "armorvalue",
    "waterlevel",
    "watertype",
    "ideal_yaw",
    "yaw_speed",
    "aiment",
    "goalentity",
    "spawnflags",
    "target",
    "targetname",
    "dmg_take",
    "dmg_save",
    "dmg_inflictor",
    "owner",
    "movedir",
    "message",
    "sounds",
    "noise",
    "noise1",
    "noise2",
    "noise3"
};

lua_State *state = NULL;

ddef_t defs[NUM_OF_FIELDS];

ddef_t *l_find_def(const char *fieldname) {
    int i;

    for (i = 0; i < NUM_OF_FIELDS; i++) {
        if (strcmp(fieldname, l_entity_fields[i]) == 0) {
            ddef_t *def = &defs[i];
            return def;
        }
    }

    return NULL;
}

void l_ExecuteProgram(func_t func) {
    if (func > 0) {
        int nargs = 0;

        lua_rawgeti(state, LUA_REGISTRYINDEX, func);

//        Con_SafePrintf("l_ExecuteProgram: Self is %d\n", pr_global_struct->self);

        int *self = lua_newuserdata(state, sizeof(int));
        self[0] = pr_global_struct->self;
        luaL_getmetatable(state, GAME_ENTITY);
        lua_setmetatable(state, -2);
        lua_setglobal(state, "self");

        int *other = lua_newuserdata(state, sizeof(int));
        other[0] = pr_global_struct->other;
        luaL_getmetatable(state, GAME_ENTITY);
        lua_setmetatable(state, -2);
        lua_setglobal(state, "other");

        int *world = lua_newuserdata(state, sizeof(int));
        world[0] = pr_global_struct->world;
        luaL_getmetatable(state, GAME_ENTITY);
        lua_setmetatable(state, -2);
        lua_setglobal(state, "world");

        lua_pushnumber(state, pr_global_struct->time);
        lua_setglobal(state, "time");

#if 1
        if (pr_global_struct->self > 0) {
            int *self = lua_newuserdata(state, sizeof(int));
            self[0] = pr_global_struct->self;

            luaL_getmetatable(state, GAME_ENTITY);
            lua_setmetatable(state, -2);

            if (pr_global_struct->other > 0) {
                int *other = lua_newuserdata(state, sizeof(int));
                other[0] = pr_global_struct->self;

                luaL_getmetatable(state, GAME_ENTITY);
                lua_setmetatable(state, -2);

                nargs++;
            }

            nargs++;
        }
        //Con_SafePrintf("l_ExecuteProgram: Self is %d, other is %d, nargs %d\n", pr_global_struct->self, pr_global_struct->other, nargs);
#endif

        lua_call(state, nargs, 0);      /* call function with self,other arguments and 0 result */
    } else {
//        l_RunError("Undefined function called");
    }
}

/*
static void init_field_def(unsigned short type, const char *fieldname, int *ofs, int *count) {
    defs[*count].type = type;
    defs[*count].ofs = ofs;
    defs[*count].s_name = 0;

    *count++;
    *ofs += type_size[type];
}
*/



static void init_field_defs() {
    int i = 0;
    int ofs = 0;

#define init_field_def(itype, name)\
{\
defs[i].type = itype;\
defs[i].ofs = ofs;\
defs[i].s_name = 0;\
i++;\
ofs += type_size[itype];\
}

    init_field_def(ev_float, "modelindex");
    init_field_def(ev_vector, "absmin"); 
    init_field_def(ev_vector, "absmax"); 
    init_field_def(ev_float, "ltime"); 
    init_field_def(ev_float, "movetype"); 
    init_field_def(ev_float, "solid"); 
    init_field_def(ev_vector, "origin"); 
    init_field_def(ev_vector, "oldorigin"); 
    init_field_def(ev_vector, "velocity"); 
    init_field_def(ev_vector, "angles"); 
    init_field_def(ev_vector, "avelocity"); 
    init_field_def(ev_vector, "punchangle"); 
    init_field_def(ev_string, "classname"); 
    init_field_def(ev_string, "model"); 
    init_field_def(ev_float, "frame"); 
    init_field_def(ev_float, "skin"); 
    init_field_def(ev_float, "effects"); 
    init_field_def(ev_vector, "mins"); 
    init_field_def(ev_vector, "maxs"); 
    init_field_def(ev_vector, "size"); 
    init_field_def(ev_function, "touch"); 
    init_field_def(ev_function, "use"); 
    init_field_def(ev_function, "think"); 
    init_field_def(ev_function, "blocked"); 
    init_field_def(ev_float, "nextthink"); 
    init_field_def(ev_entity, "groundentity"); 
    init_field_def(ev_float, "health"); 
    init_field_def(ev_float, "frags"); 
    init_field_def(ev_float, "weapon"); 
    init_field_def(ev_string, "weaponmodel"); 
    init_field_def(ev_float, "weaponframe"); 
    init_field_def(ev_float, "currentammo"); 
    init_field_def(ev_float, "ammo_shells"); 
    init_field_def(ev_float, "ammo_nails"); 
    init_field_def(ev_float, "ammo_rockets"); 
    init_field_def(ev_float, "ammo_cells"); 
    init_field_def(ev_float, "items"); 
    init_field_def(ev_float, "takedamage"); 
    init_field_def(ev_entity, "chain"); 
    init_field_def(ev_float, "deadflag"); 
    init_field_def(ev_vector, "view_ofs"); 
    init_field_def(ev_float, "button0");
    init_field_def(ev_float, "button1");
    init_field_def(ev_float, "button2");
#ifdef LUAQUAKE_ENHANCED
    init_field_def(ev_float, "button3");
    init_field_def(ev_float, "button4");
    init_field_def(ev_float, "button5");
    init_field_def(ev_float, "button6");
    init_field_def(ev_float, "button7");
#endif
    init_field_def(ev_float, "impulse");
    init_field_def(ev_float, "fixangle"); 
    init_field_def(ev_vector, "v_angle"); 
    init_field_def(ev_float, "idealpitch"); 
    init_field_def(ev_string, "netname"); 
    init_field_def(ev_entity, "enemy"); 
    init_field_def(ev_float, "flags"); 
    init_field_def(ev_float, "colormap"); 
    init_field_def(ev_float, "team"); 
    init_field_def(ev_float, "max_health"); 
    init_field_def(ev_float, "teleport_time"); 
    init_field_def(ev_float, "armortype"); 
    init_field_def(ev_float, "armorvalue"); 
    init_field_def(ev_float, "waterlevel"); 
    init_field_def(ev_float, "watertype"); 
    init_field_def(ev_float, "ideal_yaw"); 
    init_field_def(ev_float, "yaw_speed"); 
    init_field_def(ev_entity, "aiment"); 
    init_field_def(ev_entity, "goalentity"); 
    init_field_def(ev_float, "spawnflags"); 
    init_field_def(ev_string, "target"); 
    init_field_def(ev_string, "targetname"); 
    init_field_def(ev_float, "dmg_take"); 
    init_field_def(ev_float, "dmg_save"); 
    init_field_def(ev_entity, "dmg_inflictor"); 
    init_field_def(ev_entity, "owner"); 
    init_field_def(ev_vector, "movedir"); 
    init_field_def(ev_string, "message"); 
    init_field_def(ev_float, "sounds"); 
    init_field_def(ev_string, "noise"); 
    init_field_def(ev_string, "noise1"); 
    init_field_def(ev_string, "noise2"); 
    init_field_def(ev_string, "noise3"); 
}

static int l_custom_lua_atpanic(lua_State *L) {
    luaL_traceback(L, L, NULL, 1);
    Host_Error("PANIC: %s", lua_tostring(L, -1));

    return 0;
}

static int l_set_gamepath(lua_State* L, const char* path) {
    const char *oldpath;
    char newpath[1024];

    lua_getglobal(L, "package");
    lua_getfield(L, -1, "path");
    oldpath = lua_tostring(L, -1);

    strncpy(newpath, oldpath, sizeof(newpath));
    q_strlcat(newpath, ";", sizeof(newpath));
    q_strlcat(newpath, path, sizeof(newpath));
    q_strlcat(newpath, "/?.lua", sizeof(newpath));

    lua_pop(L, 1);
    lua_pushstring(L, newpath);
    lua_setfield(L, -2, "path");
    lua_pop(L, 1);

    return 0;
}

static const char *l_init(char *path) {
    char scriptname[1024];
    char compiledname[1024];

    // TODO fix reload
    if (state) {
        lua_close(state);
        state = NULL;
    }

    if (!state)
        state = luaL_newstate();

    if (!state)
        return "Could not load state\n";

    strncpy(scriptname, path, sizeof(scriptname));
    strncpy(compiledname, path, sizeof(compiledname));

    q_strlcat(scriptname, "/progs.lua", sizeof(scriptname));
    q_strlcat(compiledname, "/progs.luac", sizeof(compiledname));

    luaL_openlibs(state);

    l_vec3_register(state);
    l_entity_register(state);
    l_global_register(state);
    l_builtins(state);

    pr_global_struct = lua_newuserdata(state, sizeof(globalvars_t));
    memset(pr_global_struct, 0, sizeof(globalvars_t));

    lprogs.entityfields = NUM_OF_FIELDS;
    lprogs.numfielddefs = NUM_OF_FIELDS;
    progs = &lprogs;

    init_field_defs();

//    pr_edict_size = progs->entityfields * 4 + sizeof(edict_t) - sizeof(entvars_t);
    pr_edict_size = sizeof(edict_t) + sizeof(int);
    // round off to next highest whole word address (esp for Alpha)
    // this ensures that pointers in the engine data area are always
    // properly aligned
    pr_edict_size += sizeof(void *) - 1;
    pr_edict_size &= ~(sizeof(void *) - 1);

    pr_global_struct->main = LUA_NOREF;
    pr_global_struct->StartFrame = LUA_NOREF;
    pr_global_struct->PlayerPreThink = LUA_NOREF;
    pr_global_struct->PlayerPostThink = LUA_NOREF;
    pr_global_struct->ClientKill = LUA_NOREF;
    pr_global_struct->ClientConnect = LUA_NOREF;
    pr_global_struct->PutClientInServer = LUA_NOREF;
    pr_global_struct->ClientDisconnect = LUA_NOREF;
    pr_global_struct->SetNewParms = LUA_NOREF;
    pr_global_struct->SetChangeParms = LUA_NOREF;
    pr_global_struct->world = 0;

    pr_numknownstrings = 0;
    pr_maxknownstrings = 0;
    pr_stringssize = 0;
    if (pr_knownstrings)
        Z_Free((void *)pr_knownstrings);
    pr_knownstrings = NULL;

    luaL_getmetatable(state, GAME_GLOBAL);
    lua_setmetatable(state, -2);

    lua_setglobal(state, GAME_NAMESPACE);

    lua_atpanic(state, &l_custom_lua_atpanic);

    l_set_gamepath(state, path);

    if (luaL_dofile(state, compiledname) != 0) {
        Con_SafePrintf("Could not execute lua chunkfile '%s'\n", lua_tostring(state, -1));
        if (luaL_dofile(state, scriptname) != 0) {
            Con_SafePrintf("Could not execute lua script '%s'\n", lua_tostring(state, -1));
            return "Could not load lua chunkfile or script";
        }
    }

    use_luaVM = 1;
    return NULL;
}

void ExecuteProgram(func_t func) {
    if (use_luaVM) {
        l_ExecuteProgram(func);
    } else {
        PR_ExecuteProgram(func);
    }
}

void LoadProgs(void) {
    //PR_LoadProgs();
    char scriptdir[sizeof(com_gamedir)];
    char *end;
    const char *err;

    strncpy(scriptdir, com_gamedir, sizeof(scriptdir));

    end = &scriptdir[strlen(scriptdir)-4];

    if (q_strncasecmp(end, "/id1", 4) == 0) {
        // id1 => lq1
        end[1] = 'l';
        end[2] = 'q';

        err = l_init(scriptdir);

        if (!err) {
            return;
        }

        // lq1 => id1
        end[1] = 'i';
        end[2] = 'd';
    }

    err = l_init(scriptdir);
    if (err)
        Sys_Error(err);
}

