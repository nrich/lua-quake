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

#include <ctype.h>

#include "l_common.h"
#include "quakedef.h"

const char *PR_GetString (int num);
ddef_t *l_find_def(const char *fieldname);
int l_GetStringRef(const char *string);
void ED_LoadFromFile (const char *data);

static char stringpool[1024 * 1024 * 10];

extern lua_State *state;

void l_RunError (const char *error, ...) {
    va_list argptr;
    char    string[1024];

    va_start (argptr, error);
    q_vsnprintf (string, sizeof(string), error, argptr);
    va_end (argptr);

    Con_Printf("'%s'\n", string);

    Host_Error("l_RunError: %s", string);
}

const char *l_GetString(lua_State *L, int num, int empty_as_null) {
    const char *string;

    if (num < 1) {
        return empty_as_null ? NULL : "";
    }

    string = &stringpool[num];

    return string;
}

int l_GetStringRef(const char *string) {
    static int nextref = 1;
    int start = 1;
    int len = strlen(string);
    int ref;
    char *next;
    
    if (len == 0)
        return 0;

    if (len > 255)
        Host_Error ("l_GetStringRef: trying to create ref to string `%s' which is > 255 chars in length (was: %d)", string, len);

    while (nextref > start) {
        int plen = (int)stringpool[start];
        char *str = &stringpool[start+1];

        if (plen == len && strncmp(string, str, len) == 0) {
            return start+1;
        } 

        start += plen + 2;
    }

    stringpool[nextref] = len;
    ref = nextref + 1;
    next = &stringpool[ref];
    strncpy(next, string, len); 
    next[len+1] = '\0';
    nextref += len + 2; // len + string + '\0'
    next = &stringpool[nextref];

    return ref;
}


const char *GetString (int num) {
    if (use_luaVM) {
        return l_GetString(state, num, 0);
    } else {
        return PR_GetString(num);
    }
}

int SetEngineString (const char *s) {
    if (use_luaVM) {
        return l_GetStringRef(s);
    } else {
        return PR_SetEngineString(s);
    }
}

qboolean l_ParseEpair(void *base, ddef_t *key, const char *s) {
    int		i, p;
    char	string[128];
    char	*v, *w;
    char	*end;
    void	*d;

    d = (void *)((int *)base + key->ofs);

    switch (key->type & ~DEF_SAVEGLOBAL) {
        case ev_string:
            p = l_GetStringRef(s);
            *(string_t *)d = p;
            break;

        case ev_float:
            *(float *)d = atof(s);
            break;

        case ev_vector:
            q_strlcpy (string, s, sizeof(string));
            end = (char *)string + strlen(string);
            v = string;
            w = string;

            for (i = 0; i < 3 && (w <= end); i++) { // ericw -- added (w <= end) check
                // set v to the next space (or 0 byte), and change that char to a 0 byte
                while (*v && *v != ' ')
                    v++;
                *v = 0;
                ((float *)d)[i] = atof (w);
                w = v = v+1;
            }
            // ericw -- fill remaining elements to 0 in case we hit the end of string
            // before reading 3 floats.
            if (i < 3) {
                Con_DWarning ("Avoided reading garbage for \"%s\" \"%s\"\n", GetString(key->s_name), s);
                for (; i < 3; i++)
                    ((float *)d)[i] = 0.0f;
            }
            break;
        case ev_entity:
            *(int *)d = EDICT_TO_PROG(EDICT_NUM(atoi (s)));
            break;

/*
        case ev_field:
            def = ED_FindField (s);
            if (!def)
            {
                //johnfitz -- HACK -- suppress error becuase fog/sky fields might not be mentioned in defs.qc
                if (strncmp(s, "sky", 3) && strcmp(s, "fog"))
                    Con_DPrintf ("Can't find field %s\n", s);
                return false;
            }
            *(int *)d = G_INT(def->ofs);
            break;

        case ev_function:
            func = ED_FindFunction (s);
            if (!func)
            {
                Con_Printf ("Can't find function %s\n", s);
                return false;
            }
            *(func_t *)d = func - pr_functions;
            break;
*/
        default:
            Con_SafePrintf("Skipping %s %d %d\n", s, key->type, key->type & ~DEF_SAVEGLOBAL);
            break;
    }
    return true;
}

static int l_isNumeric(const char * s) {
    if (s == NULL || *s == '\0' || isspace(*s))
      return 0;

    char * p;
    strtod (s, &p);
    return *p == '\0';
}

static void l_parse_push_vec3(lua_State *L, const char *keyname, const char *value) {
    char	string[128];
    char	*v, *w;
    char	*end;
    vec3_t	d;
    int i;

    q_strlcpy (string, value, sizeof(string));
    end = (char *)string + strlen(string);
    v = string;
    w = string;

    for (i = 0; i < 3 && (w <= end); i++) { // ericw -- added (w <= end) check
        // set v to the next space (or 0 byte), and change that char to a 0 byte
        while (*v && *v != ' ')
            v++;
        *v = 0;
        ((float *)d)[i] = atof (w);
        w = v = v+1;
    }
    // ericw -- fill remaining elements to 0 in case we hit the end of string
    // before reading 3 floats.
    if (i < 3) {
        Con_DWarning ("Avoided reading garbage for \"%s\" \"%s\"\n", keyname, value);
        for (; i < 3; i++)
            d[i] = 0.0f;
    }

    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    VectorCopy(d, out[0]);
    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);
}

static void l_SetField(edict_t *ent, const char *keyname, const char *value) {
    int *gameref = (int *)(&ent->v.noise3) + 1;

    if (*gameref < 1) {
        lua_newtable(state);
        *gameref = luaL_ref(state, LUA_REGISTRYINDEX);
    }

    lua_rawgeti(state, LUA_REGISTRYINDEX, *gameref);
    lua_pushstring(state, keyname);

    if (l_isNumeric(value)) {
        lua_pushnumber(state, atof(value));
    } else if (q_strncasecmp(keyname, "mangle", 6) == 0 ) {
        Con_SafePrintf("l_SetField: %s %s\n", keyname, value);
        l_parse_push_vec3(state, keyname, value);
    } else {
        lua_pushstring(state, value);
    }

    lua_settable(state, -3);
}

const char *l_ParseEdict (const char *data, edict_t *ent) {
    ddef_t		*key = NULL;
    char		keyname[256];
    qboolean	anglehack, init;
    int		n;

    init = false;

    // clear it
    if (ent != sv.edicts) {	// hack
        memset (&ent->v, 0, sizeof(ent->v));

        ent->v.touch = LUA_NOREF;
        ent->v.use = LUA_NOREF;
        ent->v.think = LUA_NOREF;
        ent->v.blocked = LUA_NOREF;

        ent->v.classname = LUA_NOREF;
        ent->v.model = LUA_NOREF;
        ent->v.weaponmodel = LUA_NOREF;
        ent->v.netname = LUA_NOREF;
        ent->v.target = LUA_NOREF;
        ent->v.targetname = LUA_NOREF;
        ent->v.message = LUA_NOREF;
        ent->v.noise = LUA_NOREF;
        ent->v.noise1 = LUA_NOREF;
        ent->v.noise2 = LUA_NOREF;
        ent->v.noise3 = LUA_NOREF;

        int *gameref = (int *)(&ent->v.noise3) + 1;
        *gameref = LUA_NOREF;

        ent->free = false;
    }

    // go through all the dictionary pairs
    while (1) {
        // parse key
        data = COM_Parse (data);
        if (com_token[0] == '}')
            break;
        if (!data)
            Host_Error ("ED_ParseEntity: EOF without closing brace");

        // anglehack is to allow QuakeEd to write single scalar angles
        // and allow them to be turned into vectors. (FIXME...)
        if (!strcmp(com_token, "angle")) {
            strcpy (com_token, "angles");
            anglehack = true;
        }
        else
            anglehack = false;


        // FIXME: change light to _light to get rid of this hack
        if (!strcmp(com_token, "light"))
            strcpy (com_token, "light_lev");	// hack for single light def

        q_strlcpy (keyname, com_token, sizeof(keyname));


        // another hack to fix keynames with trailing spaces
        n = strlen(keyname);
        while (n && keyname[n-1] == ' ') {
            keyname[n-1] = 0;
            n--;
        }


        // parse value
        data = COM_Parse (data);
        if (!data)
            Host_Error ("ED_ParseEntity: EOF without closing brace");

        if (com_token[0] == '}')
            Host_Error ("ED_ParseEntity: closing brace without data");

        init = true;


        // keynames with a leading underscore are used for utility comments,
        // and are immediately discarded by quake
        if (keyname[0] == '_')
            continue;

        //johnfitz -- hack to support .alpha even when progs.dat doesn't know about it
        if (!strcmp(keyname, "alpha"))
            ent->alpha = ENTALPHA_ENCODE(atof(com_token));
        //johnfitz


        key = l_find_def(keyname); 

        if (!key) {
            //johnfitz -- HACK -- suppress error becuase fog/sky/alpha fields might not be mentioned in defs.qc
            if (strncmp(keyname, "sky", 3) && strcmp(keyname, "fog") && strcmp(keyname, "alpha"))
                Con_DPrintf ("\"%s\" is not a field\n", keyname); //johnfitz -- was Con_Printf

            // TODO set directly to edict as this is a gamelogic only field
            l_SetField(ent, keyname, com_token); 
            continue;
        }

        if (anglehack) {
            char	temp[32];
            strcpy (temp, com_token);
            sprintf (com_token, "0 %s 0", temp);
        }

        if (!l_ParseEpair ((void *)&ent->v, key, com_token))
            Host_Error ("ED_ParseEdict: lua parse error");
    }

    if (!init)
        ent->free = true;

    return data;
}

void l_LoadFromFile(const char *data) {
    dfunction_t     *func;
    edict_t         *ent = NULL;
    int             inhibit = 0;

    pr_global_struct->time = sv.time;

    // parse ents
    while (1) {
        // parse the opening brace
        data = COM_Parse (data);
        if (!data)
            break;
        if (com_token[0] != '{')
            Host_Error ("l_LoadFromFile: found %s when expecting {",com_token);

        if (!ent)
            ent = EDICT_NUM(0);
        else
            ent = ED_Alloc ();

        data = l_ParseEdict (data, ent);

        // remove things from different skill levels or deathmatch
        if (deathmatch.value) {
            if (((int)ent->v.spawnflags & SPAWNFLAG_NOT_DEATHMATCH)) {
                ED_Free (ent);
                inhibit++;
                continue;
            }
        }
        else if ((current_skill == 0 && ((int)ent->v.spawnflags & SPAWNFLAG_NOT_EASY))
                || (current_skill == 1 && ((int)ent->v.spawnflags & SPAWNFLAG_NOT_MEDIUM))
                || (current_skill >= 2 && ((int)ent->v.spawnflags & SPAWNFLAG_NOT_HARD)) ) {
            ED_Free (ent);
            inhibit++;
            continue;
        }

        //
        // immediately call spawn function
        //
        if (ent->v.classname < 1) {
            Con_SafePrintf ("l_LoadFromFile: No classname for %d:\n", NUM_FOR_EDICT(ent)); //johnfitz -- was Con_Printf
            //ED_Print (ent);
            ED_Free (ent);
            continue;
        }

        lua_getglobal(state, GetString(ent->v.classname));
        if (lua_isnil(state, -1)) {
            lua_pop(state, -1);
            continue;
        }


        pr_global_struct->self = EDICT_TO_PROG(ent);

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

        int *pself = lua_newuserdata(state, sizeof(int));
        pself[0] = pr_global_struct->self;

        luaL_getmetatable(state, GAME_ENTITY);
        lua_setmetatable(state, -2);

        lua_call(state, 1, 0);
    }

    Con_DPrintf ("%i entities inhibited\n", inhibit);

}

void LoadFromFile(const char *data) {
    if (use_luaVM) {
        l_LoadFromFile(data);
    } else {
        ED_LoadFromFile(data);
    }
}
