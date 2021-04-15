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

#include "q_stdinc.h"
#include "sys.h"
#include "l_common.h"
#include "q_stdinc.h"
#include "mathlib.h"

vec3_t *l_getvec3(lua_State *L, int pos) {
    if (lua_isuserdata(L, pos)) {
        vec3_t *vec = luaL_testudata(L, pos, GAME_VEC3);

        if (vec) {
            return vec;
        } else {
            vec3_t **vecptr = luaL_testudata(L, pos, GAME_VEC3PTR);

            if (vecptr) {
                return *vecptr;
            } else {
                luaL_error(L, "Invalid type `%s', should be %s\n", lua_typename(L, pos), GAME_VEC3);
            }
        }
/*
    } else if (lua_isstring(L, pos)) {
        const char *vecstring = lua_tostring(L, pos);
        vec_t x, y, z;

        if (sscanf(vecstring, "%f %f %f", &x, &y, &z) == 3) {
            v[0] = x;
            v[1] = y;
            v[2] = z;
        } else {
            luaL_error(L, "Invalid %s string `%s', should be 'num num num'\n", GAME_VEC3, vecstring);
        }
*/
    } else {
        luaL_error(L, "Invalid type `%s', should be %s\n", lua_typename(L, pos), GAME_VEC3);
    }

    return NULL;
}


static int l_vec3_new(lua_State *L) {
    int n = lua_gettop(L);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    

    if (n == 3) {
	vec_t x = luaL_checknumber(L, 1);
	vec_t y = luaL_checknumber(L, 2);
	vec_t z = luaL_checknumber(L, 3);

	out[0][0] = x;
        out[0][1] = y;
        out[0][2] = z;
    } 

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);
   
    return 1;
}

static int l_vec3_add(lua_State *L) {
    vec3_t *a = l_getvec3(L, 1);
    vec3_t *b = l_getvec3(L, 2);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorAdd(a[0], b[0], out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_sub(lua_State *L) {
    vec3_t *a = l_getvec3(L, 1);
    vec3_t *b = l_getvec3(L, 2);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorSubtract(a[0], b[0], out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_dot(lua_State *L);
static int l_vec3_mul(lua_State *L) {
    vec3_t *in = NULL;
    vec_t mul = 1;

    if (lua_isuserdata(L, 1) && lua_isuserdata(L, 2)) {
        return l_vec3_dot(L);
    } else if (lua_isuserdata(L, 1)) {
        in = l_getvec3(L, 1);
        mul = luaL_checknumber(L, 2);
    } else if (lua_isuserdata(L, 2)) {
        in = l_getvec3(L, 2);
        mul = luaL_checknumber(L, 1);
    }

    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorScale(in[0], mul, out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_div(lua_State *L) {
    vec3_t *in = NULL;
    vec_t mul = 1;

    if (lua_isuserdata(L, 1)) {
        in = l_getvec3(L, 1);
        mul = luaL_checknumber(L, 2);
    } else if (lua_isuserdata(L, 2)) {
        in = l_getvec3(L, 2);
        mul = luaL_checknumber(L, 1);
    }

    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorScale(in[0], 1/mul, out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_dot(lua_State *L) {
    vec3_t *a = l_getvec3(L, 1);
    vec3_t *b = l_getvec3(L, 2);
    
    vec_t dot = DotProduct(a[0], b[0]);

    lua_pushnumber(L, dot);

    return 1;
}

static int l_vec3_crs(lua_State *L) {
    vec3_t *a = l_getvec3(L, 1);
    vec3_t *b = l_getvec3(L, 2);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    CrossProduct(a[0], b[0], out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_neg(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorCopy(in[0], out[0]);
    VectorInverse(out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_len(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    vec_t len = VectorLength(in[0]);

    lua_pushnumber(L, len);
    return 1;
}

static int l_vec3_eq(lua_State *L) {
    vec3_t *pa = l_getvec3(L, 1);
    vec3_t *pb = l_getvec3(L, 2);

    float *a = pa[0];
    float *b = pb[0];

    int result = 
        a[0] == b[0] &&
        a[1] == b[1] &&
        a[2] == b[2];

    lua_pushboolean(L, result);

    return 1;
}

static int l_vec3_gt(lua_State *L) {
    vec3_t *pa = l_getvec3(L, 1);
    vec3_t *pb = l_getvec3(L, 2);

    float *a = pa[0];
    float *b = pb[0];

    int result = 
        a[0] > b[0] &&
        a[1] > b[1] &&
        a[2] > b[2];

    lua_pushboolean(L, result);

    return 1;
}

static int l_vec3_lt(lua_State *L) {
    vec3_t *pa = l_getvec3(L, 1);
    vec3_t *pb = l_getvec3(L, 2);

    float *a = pa[0];
    float *b = pb[0];

    int result = 
        a[0] < b[0] &&
        a[1] < b[1] &&
        a[2] < b[2];

    lua_pushboolean(L, result);

    return 1;
}

static int l_vec3_ge(lua_State *L) {
    vec3_t *pa = l_getvec3(L, 1);
    vec3_t *pb = l_getvec3(L, 2);

    float *a = pa[0];
    float *b = pb[0];

    int result = 
        a[0] >= b[0] &&
        a[1] >= b[1] &&
        a[2] >= b[2];

    lua_pushboolean(L, result);

    return 1;
}

static int l_vec3_le(lua_State *L) {
    vec3_t *pa = l_getvec3(L, 1);
    vec3_t *pb = l_getvec3(L, 2);

    float *a = pa[0];
    float *b = pb[0];

    int result = 
        a[0] <= b[0] &&
        a[1] <= b[1] &&
        a[2] <= b[2];

    lua_pushboolean(L, result);

    return 1;
}

static int l_vec3_normal(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorCopy(in[0], out[0]);
    VectorNormalize(out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_set(lua_State *L) {
    int n = lua_gettop(L);
    vec3_t *out = l_getvec3(L, 1);
    
    if (n == 4) {
	vec_t x = luaL_checknumber(L, 2);
	vec_t y = luaL_checknumber(L, 3);
	vec_t z = luaL_checknumber(L, 3);

	out[0][0] = x;
        out[0][1] = y;
        out[0][2] = z;
    } else {
	vec3_t *src = l_getvec3(L, 2);
        VectorCopy(src[0], out[0]);
    }

    return 0;
}

static int l_vec3_clone(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    vec3_t *out = lua_newuserdata(L, sizeof(vec3_t));
    
    VectorCopy(in[0], out[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 1;
}

static int l_vec3_anglevectors(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    
    vec3_t *forward = lua_newuserdata(L, sizeof(vec3_t));
    vec3_t *right = lua_newuserdata(L, sizeof(vec3_t));
    vec3_t *up = lua_newuserdata(L, sizeof(vec3_t));

    AngleVectors(in[0], forward[0], right[0], up[0]);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -4);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -3);

    luaL_getmetatable(L, GAME_VEC3);
    lua_setmetatable(L, -2);

    return 3;
}

static int l_vec3_tostring(lua_State *L) {
    vec3_t *vec = l_getvec3(L, 1);

    lua_pushfstring(L, "%f %f %f", vec[0][0], vec[0][1], vec[0][2]);
    return 1;
}

static int l_vec3_index(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    const char *property = luaL_checkstring(L, 2);
    float v = 0;

    if (strncmp("x", property, 1) == 0) {
        v = in[0][0];
    } else if (strncmp("y", property, 1) == 0) {
        v = in[0][1];
    } else if (strncmp("z", property, 1) == 0) {
        v = in[0][2];
    } else if (strncmp("0", property, 1) == 0) {
        v = in[0][0];
    } else if (strncmp("1", property, 1) == 0) {
        v = in[0][1];
    } else if (strncmp("2", property, 1) == 0) {
        v = in[0][2];
    } else if (strncmp("clone", property, 5) == 0) {
        lua_pushcfunction(L, l_vec3_clone);
        return 1;
    } else if (strncmp("angle2vecs", property, 10) == 0) {
        lua_pushcfunction(L, l_vec3_anglevectors);
        return 1;
    } else if (strncmp("normal", property, 6) == 0) {
        lua_pushcfunction(L, l_vec3_normal);
        return 1;
    } else if (strncmp("set", property, 3) == 0) {
        lua_pushcfunction(L, l_vec3_set);
        return 1;
    } else {
        luaL_error(L, "Unknown field `%s' in %s\n", property, GAME_VEC3);
    }

    lua_pushnumber(L, v);
    return 1;
}

static int l_vec3_newindex(lua_State *L) {
    vec3_t *in = l_getvec3(L, 1);
    const char *property = luaL_checkstring(L, 2);
    float v = luaL_checknumber(L, 3);

    if (strncmp("x", property, 1) == 0) {
        in[0][0] = v;
    } else if (strncmp("y", property, 1) == 0) {
        in[0][1] = v;
    } else if (strncmp("z", property, 1) == 0) {
        in[0][2] = v;
    } else if (strncmp("0", property, 1) == 0) {
        in[0][0] = v;
    } else if (strncmp("1", property, 1) == 0) {
        in[0][1] = v;
    } else if (strncmp("2", property, 1) == 0) {
        in[0][2] = v;
    } else {
        luaL_error(L, "Unknown field `%s' in %s\n", property, GAME_VEC3);
    }

    return 0;
}

static int l_vec3_gc(lua_State *L) {
    /* vec3_t *in = luaL_checkudata(L, 1, GAME_VEC3); */

    return 0;
}

int l_vec3_register(lua_State *L) {
    lua_register(L, GAME_VEC3, l_vec3_new);

    luaL_newmetatable(L, GAME_VEC3);
    lua_pushcfunction(L, l_vec3_index);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, l_vec3_newindex);
    lua_setfield(L, -2, "__newindex");
    lua_pushcfunction(L, l_vec3_add);
    lua_setfield(L, -2, "__add");
    lua_pushcfunction(L, l_vec3_sub);
    lua_setfield(L, -2, "__sub");
    lua_pushcfunction(L, l_vec3_mul);
    lua_setfield(L, -2, "__mul");
    lua_pushcfunction(L, l_vec3_div);
    lua_setfield(L, -2, "__div");
    lua_pushcfunction(L, l_vec3_dot);
    lua_setfield(L, -2, "__mod");
    lua_pushcfunction(L, l_vec3_crs);
    lua_setfield(L, -2, "__pow");
    lua_pushcfunction(L, l_vec3_neg);
    lua_setfield(L, -2, "__unm");
    lua_pushcfunction(L, l_vec3_len);
    lua_setfield(L, -2, "__len");
    lua_pushcfunction(L, l_vec3_eq);
    lua_setfield(L, -2, "__eq");
    lua_pushcfunction(L, l_vec3_gt);
    lua_setfield(L, -2, "__gt");
    lua_pushcfunction(L, l_vec3_lt);
    lua_setfield(L, -2, "__lt");
    lua_pushcfunction(L, l_vec3_ge);
    lua_setfield(L, -2, "__ge");
    lua_pushcfunction(L, l_vec3_le);
    lua_setfield(L, -2, "__le");
    lua_pushcfunction(L, l_vec3_tostring);
    lua_setfield(L, -2, "__tostring");
    lua_pushcfunction(L, l_vec3_gc);
    lua_setfield(L, -2, "__gc");
    lua_pushcfunction(L, l_vec3_clone);
    lua_setfield(L, -2, "__call");

    luaL_newmetatable(L, GAME_VEC3PTR);
    lua_pushcfunction(L, l_vec3_index);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, l_vec3_newindex);
    lua_setfield(L, -2, "__newindex");
    lua_pushcfunction(L, l_vec3_add);
    lua_setfield(L, -2, "__add");
    lua_pushcfunction(L, l_vec3_sub);
    lua_setfield(L, -2, "__sub");
    lua_pushcfunction(L, l_vec3_mul);
    lua_setfield(L, -2, "__mul");
    lua_pushcfunction(L, l_vec3_div);
    lua_setfield(L, -2, "__div");
    lua_pushcfunction(L, l_vec3_dot);
    lua_setfield(L, -2, "__mod");
    lua_pushcfunction(L, l_vec3_crs);
    lua_setfield(L, -2, "__pow");
    lua_pushcfunction(L, l_vec3_neg);
    lua_setfield(L, -2, "__unm");
    lua_pushcfunction(L, l_vec3_len);
    lua_setfield(L, -2, "__len");
    lua_pushcfunction(L, l_vec3_eq);
    lua_setfield(L, -2, "__eq");
    lua_pushcfunction(L, l_vec3_gt);
    lua_setfield(L, -2, "__gt");
    lua_pushcfunction(L, l_vec3_lt);
    lua_setfield(L, -2, "__lt");
    lua_pushcfunction(L, l_vec3_ge);
    lua_setfield(L, -2, "__ge");
    lua_pushcfunction(L, l_vec3_le);
    lua_setfield(L, -2, "__le");
    lua_pushcfunction(L, l_vec3_tostring);
    lua_setfield(L, -2, "__tostring");
    lua_pushcfunction(L, l_vec3_gc);
    lua_setfield(L, -2, "__gc");
    lua_pushcfunction(L, l_vec3_clone);
    lua_setfield(L, -2, "__call");

    return 1;
}

