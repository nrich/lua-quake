/*
Copyright (C) 1996-2001 Id Software, Inc.
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
#include "net_direct.h"

#define sfunc   net_landrivers[sock->landriver]
#define dfunc   net_landrivers[net_landriverlevel]

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

static int net_landriverlevel;

int Direct_Init (void) {
    int     i, num_inited;
    sys_socket_t    csock;

    num_inited = 0;
    for (i = 0; i < net_numlandrivers; i++) {
        csock = net_landrivers[i].Init ();
        if (csock == INVALID_SOCKET)
            continue;
        net_landrivers[i].initialized = true;
        net_landrivers[i].controlSock = csock;
        num_inited++;
    }

    if (num_inited == 0)
        return -1;

    return 0;
}


void Direct_Shutdown (void) {
}


void Direct_Listen (qboolean state) {
    int i;

    for (i = 0; i < net_numlandrivers; i++) {
        if (net_landrivers[i].initialized)
            net_landrivers[i].Listen(state);
    }
}


void Direct_SearchForHosts (qboolean xmit) {
//    if (!sv.active)
//        return;

    hostCacheCount = 1;
    if (Q_strcmp(hostname.string, "UNNAMED") == 0)
        Q_strcpy(hostcache[0].name, "direct");
    else
        Q_strcpy(hostcache[0].name, hostname.string);
    Q_strcpy(hostcache[0].map, sv.name);
    hostcache[0].users = net_activeconnections;
    hostcache[0].maxusers = 4;
    hostcache[0].driver = net_driverlevel;
    hostcache[0].ldriver = net_landriverlevel;

    Q_strcpy(hostcache[0].cname, "browser");
}

qsocket_t *_Connect(const char *host) {
    qsocket_t       *sock;
    sys_socket_t            newsock;
    struct qsockaddr sendaddr;
    newsock = dfunc.Open_Socket(0);
    if (newsock == INVALID_SOCKET)
        return NULL;

    sock = NET_NewQSocket ();
    if (sock == NULL)
        return NULL;

    sock->socket = newsock;
    sock->landriver = net_landriverlevel;

    sock->receiveMessageLength = 0;
    sock->sendMessageLength = 0;
    sock->canSend = true;

    if (dfunc.Connect(newsock, &sendaddr) == -1) {
        return NULL;
    }

    return sock;
}

qsocket_t *Direct_Connect (const char *host) {
    qsocket_t *ret = NULL;

    Con_Printf("Direct_Connect: %s\n", host);

    for (net_landriverlevel = 0; net_landriverlevel < net_numlandrivers; net_landriverlevel++) {
        Con_Printf("Direct_Connect: %d %d\n", net_landriverlevel, net_landrivers[net_landriverlevel].initialized);

        if (net_landrivers[net_landriverlevel].initialized) {
            if ((ret = _Connect(host)) != NULL) {
                break;
            }
        }
    }

    return ret;
}


qsocket_t *Direct_CheckNewConnections (void) {
        struct qsockaddr clientaddr;
        struct qsockaddr newaddr;
        sys_socket_t            newsock;
        sys_socket_t            acceptsock;
        qsocket_t       *sock;
        qsocket_t       *s;
        int                     len;
        int                     command;
        int                     control;
        int                     ret;

    acceptsock = dfunc.CheckNewConnections();
    if (acceptsock == INVALID_SOCKET)
        return NULL;

    dfunc.GetSocketAddr(acceptsock, &clientaddr);

    SZ_Clear(&net_message);

    len = dfunc.Read (acceptsock, net_message.data, net_message.maxsize, &clientaddr);
    if (len < (int) sizeof(int))
        return NULL;
    net_message.cursize = len;

    sock = NET_NewQSocket ();
    if (sock == NULL) {
        SZ_Clear(&net_message);
        dfunc.Write (acceptsock, net_message.data, net_message.cursize, &sock->addr);
        return NULL;
    }

    // allocate a network socket
    newsock = dfunc.Open_Socket(0);
    if (newsock == INVALID_SOCKET) {
        NET_FreeQSocket(sock);
        return NULL;
    }

/*
    // connect to the client
    if (dfunc.Connect (newsock, &clientaddr) == -1) {
        dfunc.Close_Socket(newsock);
        NET_FreeQSocket(sock);
        return NULL;
    }
*/

    // everything is allocated, just fill in the details
    sock->socket = newsock;
    sock->landriver = net_landriverlevel;
    sock->addr = clientaddr;

    sock->receiveMessageLength = 0;
    sock->sendMessageLength = 0;
    sock->canSend = true;

    //Q_strcpy(sock->address, dfunc.AddrToString(&clientaddr));

    // send him back the info about the server connection he has been allocated
    SZ_Clear(&net_message);

    return sock;
}

int Direct_GetMessage (qsocket_t *sock) {
    byte buffer[NET_DATAGRAMSIZE];
    struct qsockaddr readaddr;
    int len;

    len = sfunc.Read(sock->socket, buffer, NET_DATAGRAMSIZE, &sock->addr);

/*
    if (len)
        Con_Printf("Direct_GetMessage: %d\n", len);
*/

    if (len < 0) {
        return -1;
    } else if (len == 0) {
        return 0;
    }

    Q_memcpy(sock->receiveMessage, buffer, len);
    sock->receiveMessageLength = len;

    SZ_Clear (&net_message);
    SZ_Write (&net_message, &sock->receiveMessage[0], len);

    return 1;
}


int Direct_SendMessage (qsocket_t *sock, sizebuf_t *data) {
    Q_memcpy(sock->sendMessage, data->data, data->cursize);
    sock->sendMessageLength = data->cursize;

//    Con_Printf("Direct_SendMessage: %d %s\n", sock->sendMessageLength, (char *)&sock->sendMessage[0]);

    if (sfunc.Write (sock->socket, (byte *)&sock->sendMessage[0], sock->sendMessageLength, &sock->addr) == -1)
        return -1;

    sock->lastSendTime = net_time;
    return 1;
}


int Direct_SendUnreliableMessage (qsocket_t *sock, sizebuf_t *data) {
//    Con_Printf("Direct_SendUnreliableMessage: %d %s\n", sock->sendMessageLength, (char *)&sock->sendMessage[0]);

    return Direct_SendMessage(sock, data);
}


qboolean Direct_CanSendMessage (qsocket_t *sock) {
    return true;
    return sock->canSend;
}


qboolean Direct_CanSendUnreliableMessage (qsocket_t *sock) {
    return true;
}


void Direct_Close (qsocket_t *sock) {
    sfunc.Close_Socket(sock->socket);
}

