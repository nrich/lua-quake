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

qboolean SV_CloseEnough(edict_t *ent, edict_t *goal, float dist);
qboolean SV_StepDirection(edict_t *ent, float yaw, float dist);
void SV_NewChaseDir(edict_t *actor, edict_t *enemy, float dist);
const char *l_GetString (lua_State *L, int num, int empty_as_null);
int l_GetStringRef(const char *string);
ddef_t *l_find_def(const char *fieldname);

extern cvar_t sv_aim;

static void SetMinMaxSize (edict_t *e, vec3_t minvec, vec3_t maxvec, qboolean rotate) {
    float *angles;
    vec3_t rmin, rmax;
    float bounds[2][3];
    float xvector[2], yvector[2];
    float a;
    vec3_t  base, transformed;
    int i, j, k, l;

    for (i = 0; i < 3; i++) {
        if (minvec[i] > maxvec[i]) {
            l_RunError("backwards mins/maxs %f %f %d", minvec[i], maxvec[i], i);
        }
    }

    rotate = false;         // FIXME: implement rotation properly again

    if (!rotate) {
        VectorCopy(minvec, rmin);
        VectorCopy(maxvec, rmax);
    } else {
        // find min / max for rotations
        angles = e->v.angles;

        a = angles[1]/180 * M_PI;

        xvector[0] = cos(a);
        xvector[1] = sin(a);
        yvector[0] = -sin(a);
        yvector[1] = cos(a);

        VectorCopy (minvec, bounds[0]);
        VectorCopy (maxvec, bounds[1]);

        rmin[0] = rmin[1] = rmin[2] = 9999;
        rmax[0] = rmax[1] = rmax[2] = -9999;

        for (i = 0; i <= 1; i++) {
            base[0] = bounds[i][0];
            for (j = 0; j <= 1; j++) {
                base[1] = bounds[j][1];
                for (k = 0; k <= 1; k++) {
                    base[2] = bounds[k][2];

                    // transform the point
                    transformed[0] = xvector[0]*base[0] + yvector[0]*base[1];
                    transformed[1] = xvector[1]*base[0] + yvector[1]*base[1];
                    transformed[2] = base[2];

                    for (l = 0; l < 3; l++) {
                        if (transformed[l] < rmin[l])
                            rmin[l] = transformed[l];
                        if (transformed[l] > rmax[l])
                            rmax[l] = transformed[l];
                    }
                }
            }
        }
    }

    // set derived values
    VectorCopy(rmin, e->v.mins);
    VectorCopy(rmax, e->v.maxs);
    VectorSubtract(maxvec, minvec, e->v.size);

    SV_LinkEdict(e, false);
}


int l_builtin_makevectors(lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);

    AngleVectors(vec[0], pr_global_struct->v_forward, pr_global_struct->v_right, pr_global_struct->v_up);   

    return 0;
}

int l_builtin_setorigin(lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    vec3_t *org = luaL_checkudata(L, 2, GAME_VEC3);

    edict_t *e = PROG_TO_EDICT(ent[0]);

    VectorCopy(org[0], e->v.origin);
    SV_LinkEdict(e, false);

    return 0;
}

int l_builtin_setmodel(lua_State *L) {
    int		i;
    const char	**check;
    qmodel_t	*mod;

    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    const char *m = luaL_checkstring(L, 2);
    edict_t *e = PROG_TO_EDICT(ent[0]);

    // check to see if model was properly precached
    for (i = 0, check = sv.model_precache; *check; i++, check++) {
	if (!strcmp(*check, m)) {
	    break;
	}
    }

    if (!*check) {
	l_RunError("no precache: %s", m);
    }

    e->v.model = l_GetStringRef(*check);
    e->v.modelindex = i; //SV_ModelIndex (m);

    mod = sv.models[(int)e->v.modelindex];  // Mod_ForName (m, true);

    if (mod) {
        //johnfitz -- correct physics cullboxes for bmodels
	if (mod->type == mod_brush) {
	    SetMinMaxSize(e, mod->clipmins, mod->clipmaxs, true);
	} else {
	    SetMinMaxSize(e, mod->mins, mod->maxs, true);
	}
	//johnfitz
    } else {
	SetMinMaxSize(e, vec3_origin, vec3_origin, true);
    }

    return 0;
}

int l_builtin_setsize(lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    vec3_t *minvec = luaL_checkudata(L, 2, GAME_VEC3);
    vec3_t *maxvec = luaL_checkudata(L, 3, GAME_VEC3);
    edict_t *e = PROG_TO_EDICT(ent[0]);

    SetMinMaxSize(e, minvec[0], maxvec[0], false);

    return 0;
}


int l_builtin_random(lua_State *L) {
    float num = (rand() & 0x7fff) / ((float)0x7fff);

    lua_pushnumber(L, num);

    return 1;
}

int l_builtin_fabs(lua_State *L) {
    float v = luaL_checknumber(L, 1);
    lua_pushnumber(L, fabs(v));

    return 1;
}

int l_builtin_break(lua_State *L) {
    Con_Printf("break statement\n");
    *(int *)-4 = 0; // dump to debugger

    return 0;
}

int l_builtin_normalize(lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));

    VectorCopy(vec[0], out[0]);

    VectorNormalize(out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

int l_builtin_error(lua_State *L) {
    luaL_traceback(L, L, NULL, 1);
    Host_Error("l_builtin_error: %s\n%s", lua_tostring(L, 1), lua_tostring(L, -1));

    return 0;
}

int l_builtin_objerror(lua_State *L) {
    luaL_traceback(L, L, NULL, 1);
    Host_Error("l_builtin_objerror: %s\n", lua_tostring(L, -1));

    return 0;
}

int l_builtin_vlen(lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);

    lua_pushnumber(L, VectorLength(vec[0]));
    return 1;
}

int l_builtin_vectoyaw(lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);
    float yaw;

    if (vec[0][1] == 0 && vec[0][0] == 0) {
        yaw = 0;
    } else {
        yaw = (int)(atan2(vec[0][1], vec[0][0]) * 180 / M_PI);
        if (yaw < 0) {
            yaw += 360;
        }
    }

    lua_pushnumber(L, yaw);
    return 1;
}

int l_builtin_dprint(lua_State *L) {
    Con_DPrintf("%s", luaL_checkstring(L, 1));
    return 0;
}

int l_builtin_bprint(lua_State *L) {
    SV_BroadcastPrintf("%s", luaL_checkstring(L, 1));
    return 0;
}

int l_builtin_sprint(lua_State *L) {
    client_t        *client;
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *e = PROG_TO_EDICT(ent[0]);

    int entnum = NUM_FOR_EDICT(e);
    if (entnum < 1 || entnum > svs.maxclients) {
        Con_Printf("tried to sprint to a non-client\n");
        return 0;
    }

    client = &svs.clients[entnum-1];
    MSG_WriteChar(&client->message,svc_print);
    MSG_WriteString (&client->message, luaL_checkstring(L, 2));

    return 0;
}

int l_builtin_centerprint(lua_State *L) {
    client_t        *client;
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *e = PROG_TO_EDICT(ent[0]);

    int entnum = NUM_FOR_EDICT(e);
    if (entnum < 1 || entnum > svs.maxclients) {
        Con_Printf("tried to sprint to a non-client\n");
        return 0;
    }

    client = &svs.clients[entnum-1];
    MSG_WriteChar (&client->message,svc_centerprint);
    MSG_WriteString (&client->message, luaL_checkstring(L, 2));

    return 0;
}


int l_builtin_spawn(lua_State *L) {
    int *ent = lua_newuserdata(L, sizeof(int));
    edict_t *ed = ED_Alloc();

    ent[0] = EDICT_TO_PROG(ed);

    ed->v.touch = LUA_NOREF;
    ed->v.use = LUA_NOREF;
    ed->v.think = LUA_NOREF;
    ed->v.blocked = LUA_NOREF;

    ed->v.classname = LUA_NOREF;
    ed->v.model = LUA_NOREF;
    ed->v.weaponmodel = LUA_NOREF;
    ed->v.netname = LUA_NOREF;
    ed->v.target = LUA_NOREF;
    ed->v.targetname = LUA_NOREF;
    ed->v.message = LUA_NOREF;
    ed->v.noise = LUA_NOREF;
    ed->v.noise1 = LUA_NOREF;
    ed->v.noise2 = LUA_NOREF;
    ed->v.noise3 = LUA_NOREF;

    ed->v.movetype = 0;

    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);

    return 1;
}

int l_builtin_rint(lua_State *L) {
    float f = luaL_checknumber(L, 1);
    if (f > 0) {
        lua_pushinteger(L, (int)(f + 0.5));
    } else {
        lua_pushinteger(L, (int)(f - 0.5));
    }

    return 1;
}

int l_builtin_particle(lua_State *L) {
    vec3_t *org = luaL_checkudata(L, 1, GAME_VEC3);
    vec3_t *dir = luaL_checkudata(L, 2, GAME_VEC3);
    float color = luaL_checknumber(L, 3);
    float count = luaL_checknumber(L, 4);

    SV_StartParticle(org[0], dir[0], color, count);

    return 0;
}

int l_builtin_localcmd(lua_State *L) {
    Cbuf_AddText(luaL_checkstring(L, 1));
    return 0;
}

int l_builtin_cvar(lua_State *L) {
    lua_pushnumber(L, Cvar_VariableValue(luaL_checkstring(L, 1)));
    return 1;
}

int l_builtin_cvar_set(lua_State *L) {
    Cvar_Set(luaL_checkstring(L, 1), luaL_checkstring(L, 2));
    return 0;
}

int l_builtin_floor(lua_State *L) {
    float v = luaL_checknumber(L, 1);
    lua_pushnumber(L, floor(v));

    return 1;
}

int l_builtin_ceil(lua_State *L) {
    float v = luaL_checknumber(L, 1);
    lua_pushnumber(L, ceil(v));

    return 1;
}

int l_builtin_coredump(lua_State *L) {
    ED_PrintEdicts();
    return 0;
}

int l_builtin_traceon(lua_State *L) {
    pr_trace = true;
    return 0;
}

int l_builtin_traceoff(lua_State *L) {
    pr_trace = false;
    return 0;
}

int l_builtin_eprint(lua_State *L) {
    int*ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *e = PROG_TO_EDICT(ent[0]);

    int entnum = NUM_FOR_EDICT(e);

    ED_PrintNum (entnum);

    return 0;
}

int l_builtin_changelevel(lua_State *L) {
    // make sure we don't issue two changelevels
    if (svs.changelevel_issued)
        return 0;
    svs.changelevel_issued = true;

    Cbuf_AddText(va("changelevel %s\n", luaL_checkstring(L, 1)));

    return 0;
}

int l_builtin_checkbottom(lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);

    lua_pushboolean(L, SV_CheckBottom(PROG_TO_EDICT(ent[0])));

    return 1;
}

int l_builtin_pointcontents(lua_State *L) {
    vec3_t *v = luaL_checkudata(L, 1, GAME_VEC3);

    lua_pushboolean(L, SV_PointContents(v[0]));

    return 1;
}

int l_builtin_ftos(lua_State *L) {
    float v = luaL_checknumber(L, 1);

    if (v == (int)v) {
        lua_pushfstring(L, "%d", (int)v);
    } else {
        lua_pushfstring(L, "%5.1f", v);
    }

    return 1;
}

int l_builtin_vtos(lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);

    lua_pushfstring(L, "'%f %f %f'", vec[0][0], vec[0][1], vec[0][2]);
    return 1;
}

int l_builtin_vectoangles (lua_State *L) {
    vec3_t *vec = luaL_checkudata(L, 1, GAME_VEC3);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    float forward;
    float yaw, pitch;

    if (vec[0][1] == 0 && vec[0][0] == 0) {
        yaw = 0;
        if (vec[0][2] > 0)
            pitch = 90;
        else
            pitch = 270;
    } else {
        yaw = (int) (atan2(vec[0][1], vec[0][0]) * 180 / M_PI);
        if (yaw < 0)
            yaw += 360;

        forward = sqrt(vec[0][0] * vec[0][0] + vec[0][1] * vec[0][1]);
        pitch = (int) (atan2(vec[0][2], forward) * 180 / M_PI);
        if (pitch < 0)
            pitch += 360;
    }

    out[0][0] = pitch;
    out[0][1] = yaw;
    out[0][2] = 0;

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

int l_builtin_sound (lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *entity = PROG_TO_EDICT(ent[0]);
    int channel = lua_tointeger(L, 2);
    const char *sample = lua_tostring(L, 3);
    int volume = lua_tonumber(L, 4) * 255;
    float attenuation = lua_tonumber(L, 5);

    if (volume < 0 || volume > 255)
        Host_Error("SV_StartSound: volume = %i", volume);

    if (attenuation < 0 || attenuation > 4)
        Host_Error("SV_StartSound: attenuation = %f", attenuation);

    if (channel < 0 || channel > 7)
        Host_Error ("SV_StartSound: channel = %i", channel);

    if (!sample) {
        luaL_traceback(L, L, NULL, 1);
        Host_Error("l_builtin_sound: %s\n%s", lua_tostring(L, 1), lua_tostring(L, -1));
    }

    SV_StartSound(entity, channel, sample, volume, attenuation);

    return 0;
}

/* TODO this needs to be generalized since it is used in C code */
int l_builtin_changeyaw(lua_State *L) {
    float ideal, current, move, speed;

    int *e = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *ent = PROG_TO_EDICT(e[0]);

    current = anglemod(ent->v.angles[1]);
    ideal = ent->v.ideal_yaw;
    speed = ent->v.yaw_speed;

    if (current == ideal)
        return 0;

    move = ideal - current;
    if (ideal > current) {
        if (move >= 180)
            move = move - 360;
    } else {
        if (move <= -180)
            move = move + 360;
    }

    if (move > 0) {
        if (move > speed)
            move = speed;
    } else {
        if (move < -speed)
            move = -speed;
    }

    ent->v.angles[1] = anglemod(current + move);
    return 0;
}

int l_builtin_stuffcmd(lua_State *L) {
    client_t        *old;

    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    int entnum = ent[0]/(pr_edict_size);

    if (entnum < 1 || entnum > svs.maxclients) {
        luaL_traceback(L, L, NULL, 1);
        l_RunError("Parm 0 not a client %d %d %s %s", entnum, svs.maxclients, lua_tostring(L, 2), lua_tostring(L, -1));
    }

    old = host_client;
    host_client = &svs.clients[entnum-1];
    Host_ClientCommands("%s", lua_tostring(L, 2));
    host_client = old;

    return 0;
}

int l_builtin_lightstyle(lua_State *L) {
    client_t        *client;
    int     j;

    int style = lua_tointeger(L, 1);
    const char *val = lua_tostring(L, 2);

    // bounds check to avoid clobbering sv struct
    if (style < 0 || style >= MAX_LIGHTSTYLES) {
        Con_DWarning("PF_lightstyle: invalid style %d\n", style);
        return 0;
    }

    // change the string in sv
    sv.lightstyles[style] = val;

    // send message to all clients on this server
    if (sv.state != ss_active)
        return 0;

    for (j = 0, client = svs.clients; j < svs.maxclients; j++, client++) {
        if (client->active || client->spawned) {
            MSG_WriteChar(&client->message, svc_lightstyle);
            MSG_WriteChar(&client->message, style);
            MSG_WriteString(&client->message, val);
        }
    }

    return 0;
}

int l_builtin_precache_file (lua_State *L) {
    // precache_file is only used to copy files with qcc, it does nothing
    lua_pushinteger(L, luaL_checkinteger(L, 1));
    return 1;
}

int l_builtin_precache_sound(lua_State *L) {
    int i;
    const char *s = luaL_checkstring(L, 1);
    int strnum = l_GetStringRef(s);

    if (sv.state != ss_loading)
        l_RunError ("PF_Precache_*: Precache can only be done in spawn functions");

    lua_pushinteger(L, strnum);

    if (!s)
        l_RunError("Empty string passed to precache_sound");

    for (i = 0; i < MAX_SOUNDS; i++) {
        if (!sv.sound_precache[i]) {
            sv.sound_precache[i] = s;
            return 1;
        }
        if (!strcmp(sv.sound_precache[i], s))
            return 1;
    }
    l_RunError("PF_precache_sound: overflow");
    return 0;
}

int l_builtin_precache_model(lua_State *L) {
    int             i;
    const char *s = luaL_checkstring(L, 1);
    int strnum = l_GetStringRef(s);

    if (sv.state != ss_loading)
        l_RunError ("PF_Precache_*: Precache can only be done in spawn functions");

    lua_pushinteger(L, strnum);

    if (!s)
        l_RunError("Empty string passed to precache_sound");

    for (i = 0; i < MAX_MODELS; i++) {
        if (!sv.model_precache[i]) {
            sv.model_precache[i] = s;
            sv.models[i] = Mod_ForName (s, true);
            return 1;
        }
        if (!strcmp(sv.model_precache[i], s))
            return 1;
    }
    l_RunError("PF_precache_model: overflow");
    return 0;
}

int l_builtin_nextent (lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    int i = NUM_FOR_EDICT(PROG_TO_EDICT(ent[0]));

    while (1) {
        i++;
        if (i == sv.num_edicts) {
            int *ne = lua_newuserdata(L, sizeof(int));
            ne[0] = EDICT_TO_PROG(sv.edicts);

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);

            return 1;
        }
        edict_t *e = PROG_TO_EDICT(i);
        if (!e->free) {
            int *ne = lua_newuserdata(L, sizeof(int));
            ne[0] = EDICT_TO_PROG(e);

            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);

            return 1;
        }
    }

    lua_pushnil(L);
    return 1;
}

int l_builtin_droptofloor(lua_State *L) {
    vec3_t          end;
    trace_t         trace;

    int *e = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *ent = PROG_TO_EDICT(e[0]);

    VectorCopy(ent->v.origin, end);
    end[2] -= 256;

    trace = SV_Move(ent->v.origin, ent->v.mins, ent->v.maxs, end, false, ent);

    if (trace.fraction == 1 || trace.allsolid) {
        lua_pushboolean(L, 0);
    } else {
        VectorCopy(trace.endpos, ent->v.origin);
        SV_LinkEdict (ent, false);
        ent->v.flags = (int)ent->v.flags | FL_ONGROUND;
        ent->v.groundentity = EDICT_TO_PROG(trace.ent);
        lua_pushboolean(L, 1);
    }

    return 1;
}

int l_builtin_walkmove(lua_State *L) {
    vec3_t  move;
    //dfunction_t     *oldf;
    int     oldself;

    int *e = luaL_checkudata(L, 1, GAME_ENTITY);
    oldself = e[0];
    edict_t *ent = PROG_TO_EDICT(e[0]);

    float yaw = luaL_checknumber(L, 2);
    float dist = luaL_checknumber(L, 3);

    if (!((int)ent->v.flags & (FL_ONGROUND|FL_FLY|FL_SWIM))) {
        lua_pushboolean(L, 0);
        return 1;
    }

    yaw = yaw * M_PI * 2 / 360;

    move[0] = cos(yaw) * dist;
    move[1] = sin(yaw) * dist;
    move[2] = 0;

    // save program state, because SV_movestep may call other progs
//    oldf = pr_xfunction;
//    oldself = pr_global_struct->self;
//    pr_global_struct->self = e[0];

    lua_pushboolean(L, SV_movestep(ent, move, true));

    int *self = lua_newuserdata(L, sizeof(int));
    self[0] = oldself;
    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);
    lua_setglobal(L, "self");

//        lua_pushboolean(L, 0);

    // restore program state
//    pr_xfunction = oldf;
    pr_global_struct->self = oldself;
    return 1;
}

int l_builtin_traceline(lua_State *L) {
    trace_t trace;
    vec3_t *v1 = luaL_checkudata(L, 1, GAME_VEC3);
    vec3_t *v2 = luaL_checkudata(L, 2, GAME_VEC3);
    int nomonsters = lua_toboolean(L, 3);
    int *ent = luaL_checkudata(L, 4, GAME_ENTITY);

    if (IS_NAN(v1[0][0]) || IS_NAN(v1[0][1]) || IS_NAN(v1[0][2]))
        v1[0][0] = v1[0][1] = v1[0][2] = 0;
    if (IS_NAN(v2[0][0]) || IS_NAN(v2[0][1]) || IS_NAN(v2[0][2]))
        v2[0][0] = v2[0][1] = v2[0][2] = 0;

    trace = SV_Move(v1[0], vec3_origin, vec3_origin, v2[0], nomonsters, PROG_TO_EDICT(ent[0]));

    pr_global_struct->trace_allsolid = trace.allsolid;
    pr_global_struct->trace_startsolid = trace.startsolid;
    pr_global_struct->trace_fraction = trace.fraction;
    pr_global_struct->trace_inwater = trace.inwater;
    pr_global_struct->trace_inopen = trace.inopen;
    VectorCopy(trace.endpos, pr_global_struct->trace_endpos);
    VectorCopy(trace.plane.normal, pr_global_struct->trace_plane_normal);
    pr_global_struct->trace_plane_dist = trace.plane.dist;
    if (trace.ent)
        pr_global_struct->trace_ent = EDICT_TO_PROG(trace.ent);
    else
        pr_global_struct->trace_ent = EDICT_TO_PROG(sv.edicts);

    return 0;
}

int l_builtin_find(lua_State *L) {
    int             e, ref, f;
    const char      *s, *t, *field;
    edict_t *ed;
    ddef_t *def;

    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);

    e = NUM_FOR_EDICT(PROG_TO_EDICT(ent[0]));
    field = luaL_checkstring(L, 2);
    s = luaL_checkstring(L, 3);

    if (!s)
        l_RunError("find: bad search string");

    def = l_find_def(field);
    if (!def)
        l_RunError("find: unknown field %s", s);
    f = def->ofs;

    for (e++ ; e < sv.num_edicts ; e++) {
        ed = EDICT_NUM(e);

        if (ed->free) {
            continue;
        }
        ref = *(string_t *)&((float*)&ed->v)[f];

        t = l_GetString(L, ref, 1); 

        if (!t)
            continue;
        if (!strcmp(t,s)) {
            int *ne = lua_newuserdata(L, sizeof(int));
            ne[0] = EDICT_TO_PROG(ed);
            luaL_getmetatable(L, GAME_ENTITY);
            lua_setmetatable(L, -2);
            return 1;
        }
    }

#if 0
    lua_pushnil(L);
#else
    int *ne = lua_newuserdata(L, sizeof(int));
    ne[0] = EDICT_TO_PROG(sv.edicts);
    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);
#endif 

    return 1;
}

int l_builtin_findradius(lua_State *L) {
    vec3_t eorg;
    int i, j;

    vec3_t *org = luaL_checkudata(L, 1, GAME_VEC3);
    float rad = luaL_checknumber(L, 2);
    edict_t *chain = (edict_t *)sv.edicts;
    edict_t *ent = NEXT_EDICT(sv.edicts);

    for (i = 1; i < sv.num_edicts; i++, ent = NEXT_EDICT(ent)) {
        if (ent->free)
            continue;
        if (ent->v.solid == SOLID_NOT)
            continue;
        for (j = 0; j < 3; j++)
            eorg[j] = org[0][j] - (ent->v.origin[j] + (ent->v.mins[j] + ent->v.maxs[j]) * 0.5);
        if (VectorLength(eorg) > rad)
            continue;

        ent->v.chain = EDICT_TO_PROG(chain);
        chain = ent;
    }

    int *ne = lua_newuserdata(L, sizeof(int));
    ne[0] = EDICT_TO_PROG(chain);
    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);

    return 1;
}

int l_builtin_ambientsound(lua_State *L) {
    const char      *samp, **check;
    float           vol, attenuation;
    int             i, soundnum;
    int             large = false; //johnfitz -- PROTOCOL_FITZQUAKE

    vec3_t *pos = luaL_checkudata(L, 1, GAME_VEC3);
    samp = luaL_checkstring(L, 2);
    vol = luaL_checknumber(L, 3);
    attenuation = luaL_checknumber(L, 4);

    // check to see if samp was properly precached
    for (soundnum = 0, check = sv.sound_precache; *check; check++, soundnum++) {
        if (!strcmp(*check, samp))
            break;
    }

    if (!*check) {
        Con_Printf ("no precache: %s\n", samp);
        return 0;
    }

    //johnfitz -- PROTOCOL_FITZQUAKE
    if (soundnum > 255) {
        if (sv.protocol == PROTOCOL_NETQUAKE)
            return 0; //don't send any info protocol can't support
        else
            large = true;
    }
    //johnfitz

    // add an svc_spawnambient command to the level signon packet

    //johnfitz -- PROTOCOL_FITZQUAKE
    if (large)
        MSG_WriteByte (&sv.signon,svc_spawnstaticsound2);
    else
        MSG_WriteByte (&sv.signon,svc_spawnstaticsound);
    //johnfitz

    for (i = 0; i < 3; i++)
        MSG_WriteCoord(&sv.signon, pos[0][i], sv.protocolflags);

    //johnfitz -- PROTOCOL_FITZQUAKE
    if (large)
        MSG_WriteShort(&sv.signon, soundnum);
    else
        MSG_WriteByte (&sv.signon, soundnum);
    //johnfitz

    MSG_WriteByte (&sv.signon, vol*255);
    MSG_WriteByte (&sv.signon, attenuation*64);

    return 0;
}

int l_builtin_setspawnparms(lua_State *L) {
    client_t *client;
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    int i = ent[0];

    if (i < 1 || i > svs.maxclients)
        l_RunError ("Entity is not a client");

    // copy spawn parms out of the client_t
    client = svs.clients + (i-1);

    for (i = 0; i < NUM_SPAWN_PARMS; i++) {
        (&pr_global_struct->parm1)[i] = client->spawn_parms[i];
    }

    return 0;
}

int l_builtin_movetogoal(lua_State *L) {
    edict_t         *ent, *goal;
    float           dist;
    int oldself;

    int *e = luaL_checkudata(L, 1, GAME_ENTITY);
    ent = PROG_TO_EDICT(e[0]);

    oldself = e[0];

    goal = PROG_TO_EDICT(ent->v.goalentity);
    dist = luaL_checknumber(L, 2);

    if (!((int)ent->v.flags & (FL_ONGROUND|FL_FLY|FL_SWIM))) {
        lua_pushboolean(L, 0);
        return 1;
    }

    // if the next step hits the enemy, return immediately
    if (PROG_TO_EDICT(ent->v.enemy) != sv.edicts && SV_CloseEnough(ent, goal, dist)) {
        lua_pushboolean(L, 0);
        return 1;
    }

    // bump around...
    if ((rand()&3)==1 || !SV_StepDirection(ent, ent->v.ideal_yaw, dist)) {
        SV_NewChaseDir(ent, goal, dist);
    }

    lua_pushboolean(L, 1);

    int *self = lua_newuserdata(L, sizeof(int));
    self[0] = oldself;
    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);
    lua_setglobal(L, "self");

//        lua_pushboolean(L, 0);

    // restore program state
//    pr_xfunction = oldf;
    pr_global_struct->self = oldself;

    return 1;
}


int l_builtin_remove(lua_State *L) {
    int *ent = luaL_checkudata(L, 1, GAME_ENTITY);
    edict_t *ed = PROG_TO_EDICT(ent[0]);
    ED_Free(ed);

    return 0;
}

static sizebuf_t *WriteDest(lua_State *L) {
    int             entnum;
    int             dest;
    edict_t *ent;

    dest = luaL_checkinteger(L, 1);
    switch (dest) {
        case MSG_BROADCAST:
            return &sv.datagram;
        case MSG_ONE:
            ent = PROG_TO_EDICT(pr_global_struct->msg_entity);
            entnum = NUM_FOR_EDICT(ent);
            if (entnum < 1 || entnum > svs.maxclients)
                l_RunError("WriteDest: not a client");
            return &svs.clients[entnum-1].message;
        case MSG_ALL:
            return &sv.reliable_datagram;
        case MSG_INIT:
            return &sv.signon;
        default:
            l_RunError("WriteDest: bad destination");
            break;
    }

    return NULL;
}

int l_builtin_WriteByte(lua_State *L) {
    MSG_WriteByte(WriteDest(L), luaL_checkinteger(L, 2));
    return 0;
}

int l_builtin_WriteChar(lua_State *L) {
    MSG_WriteChar(WriteDest(L), luaL_checkinteger(L, 2));
    return 0;
}

int l_builtin_WriteShort(lua_State *L) {
    MSG_WriteShort(WriteDest(L), luaL_checkinteger(L, 2));
    return 0;
}

int l_builtin_WriteLong(lua_State *L) {
    MSG_WriteLong(WriteDest(L), luaL_checkinteger(L, 2));
    return 0;
}

int l_builtin_WriteAngle(lua_State *L) {
    MSG_WriteAngle(WriteDest(L), luaL_checknumber(L, 2), sv.protocolflags);
    return 0;
}

int l_builtin_WriteCoord(lua_State *L) {
    MSG_WriteCoord(WriteDest(L), luaL_checknumber(L, 2), sv.protocolflags);
    return 0;
}

int l_builtin_WriteString(lua_State *L) {
    MSG_WriteString(WriteDest(L), luaL_checkstring(L, 1));
    return 0;
}

int l_builtin_WriteEntity(lua_State *L) {
    int *ent = luaL_checkudata(L, 2, GAME_ENTITY);
    MSG_WriteShort(WriteDest(L), ent[0]);

    return 0;
}

int l_builtin_aim(lua_State *L) {
    edict_t	*ent, *check, *bestent;
    vec3_t	start, dir, end, bestdir;
    int		i, j;
    trace_t	tr;
    float	dist, bestdist;
    float	speed;

    int *pent = luaL_checkudata(L, 1, GAME_ENTITY);
    ent = PROG_TO_EDICT(pent[0]);

    speed = luaL_checknumber(L, 2);
    (void) speed; /* variable set but not used */

    VectorCopy(ent->v.origin, start);
    start[2] += 20;

    // try sending a trace straight
    VectorCopy(pr_global_struct->v_forward, dir);
    VectorMA(start, 2048, dir, end);
    tr = SV_Move(start, vec3_origin, vec3_origin, end, false, ent);
    if (tr.ent && tr.ent->v.takedamage == DAMAGE_AIM && (!teamplay.value || ent->v.team <= 0 || ent->v.team != tr.ent->v.team)) {
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(pr_global_struct->v_forward, out[0]);

        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);

        return 1;
    }

    // try all possible entities
    VectorCopy(dir, bestdir);
    bestdist = sv_aim.value;
    bestent = NULL;

    check = NEXT_EDICT(sv.edicts);
    for (i = 1; i < sv.num_edicts; i++, check = NEXT_EDICT(check)) {
        if (check->v.takedamage != DAMAGE_AIM)
            continue;
        if (check == ent)
            continue;
        if (teamplay.value && ent->v.team > 0 && ent->v.team == check->v.team)
            continue;	// don't aim at teammate
        for (j = 0; j < 3; j++)
            end[j] = check->v.origin[j] + 0.5 * (check->v.mins[j] + check->v.maxs[j]);
        VectorSubtract (end, start, dir);
        VectorNormalize (dir);
        dist = DotProduct(dir, pr_global_struct->v_forward);
        if (dist < bestdist)
            continue;	// to far to turn
        tr = SV_Move(start, vec3_origin, vec3_origin, end, false, ent);
        if (tr.ent == check) {
            // can shoot at this one
            bestdist = dist;
            bestent = check;
        }
    }

    if (bestent) {
        VectorSubtract(bestent->v.origin, ent->v.origin, dir);
        dist = DotProduct(dir, pr_global_struct->v_forward);
        VectorScale (pr_global_struct->v_forward, dist, end);
        end[2] = dir[2];
        VectorNormalize(end);

        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(end, out[0]);

        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    } else {
        vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
        VectorCopy(bestdir, out[0]);

        luaL_getmetatable(L, GAME_VEC3);
        lua_setmetatable(L, -2);
    }

    return 1;
}

static byte *checkpvs;      //ericw -- changed to malloc
static int checkpvs_capacity;

static int l_newcheckclient(int check) {
    int             i;
    byte    *pvs;
    edict_t *ent;
    mleaf_t *leaf;
    vec3_t  org;
    int     pvsbytes;

    // cycle to the next one

    if (check < 1)
        check = 1;
    if (check > svs.maxclients)
        check = svs.maxclients;

    if (check == svs.maxclients)
        i = 1;
    else
        i = check + 1;

    for ( ;  ; i++) {
        if (i == svs.maxclients+1)
            i = 1;

        ent = EDICT_NUM(i);

        if (i == check)
            break;  // didn't find anything else

        if (ent->free)
            continue;
        if (ent->v.health <= 0)
            continue;
        if ((int)ent->v.flags & FL_NOTARGET)
            continue;

        // anything that is a client, or has a client as an enemy
        break;
    }

    // get the PVS for the entity
    VectorAdd(ent->v.origin, ent->v.view_ofs, org);
    leaf = Mod_PointInLeaf(org, sv.worldmodel);
    pvs = Mod_LeafPVS(leaf, sv.worldmodel);

    pvsbytes = (sv.worldmodel->numleafs+7)>>3;
    if (checkpvs == NULL || pvsbytes > checkpvs_capacity) {
        checkpvs_capacity = pvsbytes;
        checkpvs = (byte *) realloc(checkpvs, checkpvs_capacity);
        if (!checkpvs)
            Sys_Error ("PF_newcheckclient: realloc() failed on %d bytes", checkpvs_capacity);
    }
    memcpy (checkpvs, pvs, pvsbytes);

    return i;
}


#define MAX_CHECK       16
static int c_invis, c_notvis;
int l_builtin_checkclient(lua_State *L) {
    edict_t *ent, *self;
    mleaf_t *leaf;
    int             l;
    vec3_t  view;
    int *ne;

    // find a new check if on a new frame
    if (sv.time - sv.lastchecktime >= 0.1) {
        sv.lastcheck = l_newcheckclient(sv.lastcheck);
        sv.lastchecktime = sv.time;
    }

    // return check if it might be visible
    ent = EDICT_NUM(sv.lastcheck);
    if (ent->free || ent->v.health <= 0) {
        ne = lua_newuserdata(L, sizeof(int));
        ne[0] = EDICT_TO_PROG(sv.edicts);

        luaL_getmetatable(L, GAME_ENTITY);
        lua_setmetatable(L, -2);

        return 1;
    }

    // if current entity can't possibly see the check entity, return 0
    int *e = luaL_checkudata(L, 1, GAME_ENTITY);
    self = PROG_TO_EDICT(e[0]);

    VectorAdd (self->v.origin, self->v.view_ofs, view);
    leaf = Mod_PointInLeaf (view, sv.worldmodel);
    l = (leaf - sv.worldmodel->leafs) - 1;
    if ((l < 0) || !(checkpvs[l>>3] & (1 << (l & 7)))) {
        c_notvis++;

        ne = lua_newuserdata(L, sizeof(int));
        ne[0] = EDICT_TO_PROG(sv.edicts);

        luaL_getmetatable(L, GAME_ENTITY);
        lua_setmetatable(L, -2);

        return 1;
    }

    // might be able to see it
    c_invis++;

    ne = lua_newuserdata(L, sizeof(int));
    ne[0] = EDICT_TO_PROG(ent);

    luaL_getmetatable(L, GAME_ENTITY);
    lua_setmetatable(L, -2);

    return 1;
}

int l_builtin_makestatic(lua_State *L) {
    edict_t	*ent;
    int		i;
    int	bits = 0; //johnfitz -- PROTOCOL_FITZQUAKE
    int *e = luaL_checkudata(L, 1, GAME_ENTITY);

    ent = PROG_TO_EDICT(e[0]);

    //johnfitz -- don't send invisible static entities
    if (ent->alpha == ENTALPHA_ZERO) {
        ED_Free(ent);
        return 0;
    }
    //johnfitz

    //johnfitz -- PROTOCOL_FITZQUAKE
    if (sv.protocol == PROTOCOL_NETQUAKE) {
        if (SV_ModelIndex(GetString(ent->v.model)) & 0xFF00 || (int)(ent->v.frame) & 0xFF00) {
            ED_Free(ent);
            return 0; //can't display the correct model & frame, so don't show it at all
        }
    } else {
        if (SV_ModelIndex(GetString(ent->v.model)) & 0xFF00)
            bits |= B_LARGEMODEL;
        if ((int)(ent->v.frame) & 0xFF00)
            bits |= B_LARGEFRAME;
        if (ent->alpha != ENTALPHA_DEFAULT)
            bits |= B_ALPHA;
    }

    if (bits) {
        MSG_WriteByte(&sv.signon, svc_spawnstatic2);
        MSG_WriteByte(&sv.signon, bits);
    } else {
        MSG_WriteByte(&sv.signon, svc_spawnstatic);
    }

    if (bits & B_LARGEMODEL)
        MSG_WriteShort(&sv.signon, SV_ModelIndex(GetString(ent->v.model)));
    else
        MSG_WriteByte(&sv.signon, SV_ModelIndex(GetString(ent->v.model)));

    if (bits & B_LARGEFRAME)
        MSG_WriteShort (&sv.signon, ent->v.frame);
    else
        MSG_WriteByte (&sv.signon, ent->v.frame);
    //johnfitz

    MSG_WriteByte (&sv.signon, ent->v.colormap);
    MSG_WriteByte (&sv.signon, ent->v.skin);
    for (i = 0; i < 3; i++) {
        MSG_WriteCoord(&sv.signon, ent->v.origin[i], sv.protocolflags);
        MSG_WriteAngle(&sv.signon, ent->v.angles[i], sv.protocolflags);
    }

    //johnfitz -- PROTOCOL_FITZQUAKE
    if (bits & B_ALPHA)
        MSG_WriteByte(&sv.signon, ent->alpha);
    //johnfitz

    // throw the entity away now
    ED_Free(ent);

    return 0;
}

int l_builtin_fixme(lua_State *L) {
    l_RunError("Function not implemented\n");
    return 0;
}

void l_builtins(lua_State *L) {
#ifdef BUILTINS_IN_GLOBAL
    lua_register(L, "makevectors", l_builtin_makevectors);
    lua_register(L, "setorigin", l_builtin_setorigin);
    lua_register(L, "setmodel", l_builtin_setmodel);
    lua_register(L, "setsize", l_builtin_setsize);
    lua_register(L, "break", l_builtin_break);
    lua_register(L, "sound", l_builtin_sound);
    lua_register(L, "normalize", l_builtin_normalize);
    lua_register(L, "error", l_builtin_error);
    lua_register(L, "objerror", l_builtin_objerror);
    lua_register(L, "vlen", l_builtin_vlen);
    lua_register(L, "vectoyaw", l_builtin_vectoyaw);
    lua_register(L, "random", l_builtin_random);
    lua_register(L, "fabs", l_builtin_fabs);
    lua_register(L, "spawn", l_builtin_spawn);
    lua_register(L, "remove", l_builtin_remove);
    lua_register(L, "dprint", l_builtin_dprint);
    lua_register(L, "bprint", l_builtin_bprint);
    lua_register(L, "sprint", l_builtin_sprint);
    lua_register(L, "centerprint", l_builtin_centerprint);
    lua_register(L, "rint", l_builtin_rint);
    lua_register(L, "particle", l_builtin_particle);
    lua_register(L, "cvar_set", l_builtin_cvar_set);
    lua_register(L, "cvar", l_builtin_cvar);
    lua_register(L, "localcmd", l_builtin_localcmd);
    lua_register(L, "floor", l_builtin_floor);
    lua_register(L, "ceil", l_builtin_ceil);
    lua_register(L, "coredump", l_builtin_coredump);
    lua_register(L, "traceon", l_builtin_traceon);
    lua_register(L, "traceoff", l_builtin_traceoff);
    lua_register(L, "eprint", l_builtin_eprint);
    lua_register(L, "changelevel", l_builtin_changelevel);
    lua_register(L, "checkbottom", l_builtin_checkbottom);
    lua_register(L, "pointcontents", l_builtin_pointcontents);
    lua_register(L, "ftos", l_builtin_ftos);
    lua_register(L, "vtos", l_builtin_vtos);
    lua_register(L, "vectoangles", l_builtin_vectoangles);
    lua_register(L, "changeyaw", l_builtin_changeyaw);
    lua_register(L, "stuffcmd", l_builtin_stuffcmd);
    lua_register(L, "lightstyle", l_builtin_lightstyle);
    lua_register(L, "precache_model", l_builtin_precache_model);
    lua_register(L, "precache_sound", l_builtin_precache_sound);
    lua_register(L, "precache_file", l_builtin_precache_file);
    lua_register(L, "walkmove", l_builtin_walkmove);
    lua_register(L, "droptofloor", l_builtin_droptofloor);
    lua_register(L, "nextent", l_builtin_nextent);
    lua_register(L, "traceline", l_builtin_traceline);
    lua_register(L, "find", l_builtin_find);
    lua_register(L, "findradius", l_builtin_findradius);
    lua_register(L, "ambientsound", l_builtin_ambientsound);
    lua_register(L, "setspawnparms", l_builtin_setspawnparms);
    lua_register(L, "movetogoal", l_builtin_movetogoal);
    lua_register(L, "precache_model2", l_builtin_precache_model);
    lua_register(L, "precache_sound2", l_builtin_precache_sound);
    lua_register(L, "precache_file2", l_builtin_precache_file);
    lua_register(L, "aim", l_builtin_aim);
    lua_register(L, "checkclient", l_builtin_checkclient);
    lua_register(L, "makestatic", l_builtin_makestatic);

    lua_register(L, "WriteByte", l_builtin_WriteByte);
    lua_register(L, "WriteChar", l_builtin_WriteChar);
    lua_register(L, "WriteShort", l_builtin_WriteShort);
    lua_register(L, "WriteLong", l_builtin_WriteLong);
    lua_register(L, "WriteAngle", l_builtin_WriteAngle);
    lua_register(L, "WriteCoord", l_builtin_WriteCoord);
    lua_register(L, "WriteString", l_builtin_WriteString);
    lua_register(L, "WriteEntity", l_builtin_WriteEntity);

    lua_register(L, "fixme", l_builtin_fixme);
#endif
}
