/*
Copyright (C) 1996-2001 Id Software, Inc.
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

#include "q_stdinc.h"
#include "arch_def.h"
#include "net_sys.h"
#include "quakedef.h"
#include "net_defs.h"

#include "net_webrtc.h"

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif


sys_socket_t mainsocket;

//=============================================================================

EM_JS(void, do_Init, (), {
  Asyncify.handleAsync(async () => {
    await Init();
  });
});


sys_socket_t WebSock_Init (void) {
    Con_SafePrintf("WebSock_Init\n");

    do_Init();

    tcpipAvailable = true;
    //return WebSock_OpenSocket(0);
    return 1;
}

//=============================================================================

void WebSock_Shutdown (void) {
}

//=============================================================================

EM_JS(void, do_Listen, (), {
  Asyncify.handleAsync(async () => {
    await Listen();
  });
});

void WebSock_Listen (qboolean state) {
    do_Listen();
}

//=============================================================================

sys_socket_t WebSock_OpenSocket(int port) {
    static int nextsock = 1;

    return port ? ++nextsock : 1;
}

//=============================================================================

int WebSock_CloseSocket(sys_socket_t socketid) {
    return 0;
}

//=============================================================================


//=============================================================================

EM_JS(void, do_Connect, (byte *buf, int len), {
  Asyncify.handleAsync(async () => {
    await Connect(buf, len);
  });
});

int WebSock_Connect(sys_socket_t socketid, struct qsockaddr *addr) {
    Con_SafePrintf("WebSock_Connect\n");

    do_Connect((void *)addr, sizeof(addr));

    return 0;
}

//=============================================================================

sys_socket_t WebSock_CheckNewConnections(void) {
    //Con_SafePrintf("WebSock_CheckNewConnections\n");
    int rc = EM_ASM_INT({
        return CheckNewConnections();
    });

    return rc;
}

//=============================================================================

EM_JS(int, do_Read, (byte *buf, int len, struct qsockaddr *addr, int addrlen), {
  return Asyncify.handleAsync(async () => {
    return await Read(buf, len, addr, addrlen);
  });
});

int WebSock_Read (sys_socket_t socketid, byte *buf, int len, struct qsockaddr *addr) {
    int rc = do_Read(buf, len, addr, sizeof(struct qsockaddr));

    return rc;
}

//=============================================================================

//=============================================================================


int WebSock_Broadcast (sys_socket_t socketid, byte *buf, int len) {
    Con_SafePrintf("WebSock_Broadcast\n");

    return 0;
}

//=============================================================================

EM_JS(int, do_Write, (byte *buf, int len, struct qsockaddr *addr, int addrlen), {
  return Asyncify.handleAsync(async () => {
    return await Write(buf, len, addr, addrlen);
  });
});


int WebSock_Write (sys_socket_t socketid, byte *buf, int len, struct qsockaddr *addr) {
    return do_Write(buf, len, addr, sizeof(*addr));
}

//=============================================================================

const char *WebSock_AddrToString (struct qsockaddr *addr) {
    //return snprintf((char *)addr, sizeof(*addr), "webrtc%03d", ;
    return (const char *)addr;
}

//=============================================================================

int WebSock_StringToAddr (const char *string, struct qsockaddr *addr) {
    return 0;
}

//=============================================================================

int WebSock_GetSocketAddr (sys_socket_t socketid, struct qsockaddr *addr) {
/*
    if (socketid) {
        int count = snprintf((char *)addr, sizeof(*addr)-1, "client%02d\0", socketid);
    } else {
        int count = snprintf((char *)addr, sizeof(*addr)-1, "server\0");
    }
*/

    char *bytes = (char *)addr;
    bytes[0] = (char)(socketid & 255);
    bytes[1] = (char)((socketid >> 8) & 255);

    return 0;    
}

//=============================================================================

int WebSock_GetNameFromAddr (struct qsockaddr *addr, char *name) {
    Con_SafePrintf("WebSock_GetNameFromAddr: %s\n", (const char*)addr);
    return 0;
}

//=============================================================================

int WebSock_GetAddrFromName (const char *name, struct qsockaddr *addr) {
    Con_SafePrintf("WebSock_GetAddrFromName: %s\n", name);
    
    int count = snprintf((char *)addr, sizeof(*addr)-1, "%s", name);

    return 0;
}

//=============================================================================

int WebSock_AddrCompare (struct qsockaddr *addr1, struct qsockaddr *addr2) {
    return strncmp((const char *)addr1, (const char *)addr2, sizeof(*addr1));
}

//=============================================================================

int WebSock_GetSocketPort (struct qsockaddr *addr) {
    return 0;
}


int WebSock_SetSocketPort (struct qsockaddr *addr, int port) {
    return 0;
}

//=============================================================================

