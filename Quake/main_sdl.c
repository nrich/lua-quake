/*
Copyright (C) 1996-2001 Id Software, Inc.
Copyright (C) 2002-2005 John Fitzgibbons and others
Copyright (C) 2007-2008 Kristian Duske
Copyright (C) 2010-2014 QuakeSpasm developers

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

#include "quakedef.h"
#if defined(SDL_FRAMEWORK) || defined(NO_SDL_CONFIG)
#if defined(USE_SDL2)
#include <SDL2/SDL.h>
#else
#include <SDL/SDL.h>
#endif
#else
#include "SDL.h"
#endif
#include <stdio.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <gl4esinit.h>
#endif

#if defined(USE_SDL2)

/* need at least SDL_2.0.0 */
#define SDL_MIN_X	2
#define SDL_MIN_Y	0
#define SDL_MIN_Z	0
#define SDL_REQUIREDVERSION	(SDL_VERSIONNUM(SDL_MIN_X,SDL_MIN_Y,SDL_MIN_Z))
#define SDL_NEW_VERSION_REJECT	(SDL_VERSIONNUM(3,0,0))

#else

/* need at least SDL_1.2.10 */
#define SDL_MIN_X	1
#define SDL_MIN_Y	2
#define SDL_MIN_Z	10
#define SDL_REQUIREDVERSION	(SDL_VERSIONNUM(SDL_MIN_X,SDL_MIN_Y,SDL_MIN_Z))
/* reject 1.3.0 and newer at runtime. */
#define SDL_NEW_VERSION_REJECT	(SDL_VERSIONNUM(1,4,0))

#endif

double		Time, OldTime, NewTime;

static void Sys_AtExit (void)
{
	SDL_Quit();
}

static void Sys_InitSDL (void)
{
#if defined(USE_SDL2)
	SDL_version v;
	SDL_version *sdl_version = &v;
	SDL_GetVersion(&v);
#else
	const SDL_version *sdl_version = SDL_Linked_Version();
#endif

	Sys_Printf("Found SDL version %i.%i.%i\n",sdl_version->major,sdl_version->minor,sdl_version->patch);
	if (SDL_VERSIONNUM(sdl_version->major,sdl_version->minor,sdl_version->patch) < SDL_REQUIREDVERSION)
	{	/*reject running under older SDL versions */
		Sys_Error("You need at least v%d.%d.%d of SDL to run this game.", SDL_MIN_X,SDL_MIN_Y,SDL_MIN_Z);
	}
	if (SDL_VERSIONNUM(sdl_version->major,sdl_version->minor,sdl_version->patch) >= SDL_NEW_VERSION_REJECT)
	{	/*reject running under newer (1.3.x) SDL */
		Sys_Error("Your version of SDL library is incompatible with me.\n"
			  "You need a library version in the line of %d.%d.%d\n", SDL_MIN_X,SDL_MIN_Y,SDL_MIN_Z);
	}

	if (SDL_Init(0) < 0)
	{
		Sys_Error("Couldn't init SDL: %s", SDL_GetError());
	}
	atexit(Sys_AtExit);
}

#define DEFAULT_MEMORY (256 * 1024 * 1024) // ericw -- was 72MB (64-bit) / 64MB (32-bit)

static quakeparms_t	parms;

// On OS X we call SDL_main from the launcher, but SDL2 doesn't redefine main
// as SDL_main on OS X anymore, so we do it ourselves.
#if defined(USE_SDL2) && defined(__APPLE__)
#define main SDL_main
#endif

void do_loop() {
        /* If we have no input focus at all, sleep a bit */
        if (!VID_HasMouseOrInputFocus() || cl.paused)
        {
#ifdef __EMSCRIPTEN__
                emscripten_sleep(16);
#else
                SDL_Delay(16);
#endif
        }
        /* If we're minimised, sleep a bit more */
        if (VID_IsMinimized())
        {
                scr_skipupdate = 1;
#ifdef __EMSCRIPTEN__
                emscripten_sleep(32);
#else
                SDL_Delay(32);
#endif
        }
        else
        {
                scr_skipupdate = 0;
        }
        NewTime = Sys_DoubleTime ();
        Time = NewTime - OldTime;

        Host_Frame (Time);

        if (Time < sys_throttle.value && !cls.timedemo)
#ifdef __EMSCRIPTEN__
                emscripten_sleep(1);
#else
                SDL_Delay(1);
#endif

        OldTime = NewTime;
}

int main(int argc, char *argv[])
{
        int		t;
	host_parms = &parms;
	parms.basedir = ".";

#ifdef __EMSCRIPTEN__
        initialize_gl4es();

        EM_ASM(
            // Make a directory other than '/'
            FS.mkdir('/settings');
            // Then mount with IDBFS type
            FS.mount(IDBFS, {}, '/settings');

            // Then sync
            FS.syncfs(true, function (err) {
            // Error
        });
    );
#endif

	parms.argc = argc;
	parms.argv = argv;

	parms.errstate = 0;

	COM_InitArgv(parms.argc, parms.argv);

	isDedicated = (COM_CheckParm("-dedicated") != 0);

	Sys_InitSDL ();
	Sys_Init();

	parms.memsize = DEFAULT_MEMORY;
	if (COM_CheckParm("-heapsize"))
	{
		t = COM_CheckParm("-heapsize") + 1;
		if (t < com_argc)
			parms.memsize = Q_atoi(com_argv[t]) * 1024;
	}

	parms.membase = malloc (parms.memsize);

	if (!parms.membase)
		Sys_Error ("Not enough memory free; check disk space\n");

	Sys_Printf("Quake %1.2f (c) id Software\n", VERSION);
	Sys_Printf("GLQuake %1.2f (c) id Software\n", GLQUAKE_VERSION);
	Sys_Printf("FitzQuake %1.2f (c) John Fitzgibbons\n", FITZQUAKE_VERSION);
	Sys_Printf("FitzQuake SDL port (c) SleepwalkR, Baker\n");
	Sys_Printf("QuakeSpasm " QUAKESPASM_VER_STRING " (c) Ozkan Sezer, Eric Wasylishen & others\n");

	Sys_Printf("Host_Init\n");
	Host_Init();

	OldTime = Sys_DoubleTime();
	if (isDedicated)
	{
		while (1)
		{
			NewTime = Sys_DoubleTime ();
			Time = NewTime - OldTime;

			while (Time < sys_ticrate.value )
			{
#ifdef __EMSCRIPTEN__
                                emscripten_sleep(1);
#else
				SDL_Delay(1);
#endif
				NewTime = Sys_DoubleTime ();
				Time = NewTime - OldTime;
			}

			Host_Frame (Time);
			OldTime = NewTime;
		}
	}
	else
#ifdef __EMSCRIPTEN__
         emscripten_set_main_loop(do_loop,0,0);
#else
	while (1)
	{
            do_loop();
	}
#endif

	return 0;
}

