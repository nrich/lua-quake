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

#include <lua5.3/lua.h>
#include <lua5.3/lauxlib.h>
#include <lua5.3/lualib.h>

#if !defined(LUA_VERSION_NUM) || (LUA_VERSION_NUM < 501)
#include <compat-5.3.h>
#endif

#define GAME_ENTITY     "Entity"
#define GAME_VEC3       "vec3"
#define GAME_VEC3PTR    "vec3ptr"
#define GAME_GLOBAL     "Global"

#define GAME_NAMESPACE "qc"

#define MSG_BROADCAST   0               // unreliable to all
#define MSG_ONE         1               // reliable to one (msg_entity)
#define MSG_ALL         2               // reliable to all
#define MSG_INIT        3               // write to the init string

void l_RunError (const char *error, ...);

#define BUILTINS_IN_GLOBAL

#define ENTITIY_PUSH_NIL_NOT_WORLD 0

#ifndef _setjmp
#define _setjmp setjmp
#endif

#ifndef _longjmp
#define _longjmp longjmp
#endif

float l_getnumber(lua_State *L, int pos, const char *name);
void *l_getuserdata(lua_State *L, int pos, const char *typename, const char *name);
const char *l_getstring(lua_State *L, int pos, const char *name);
