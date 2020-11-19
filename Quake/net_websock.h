/*
Copyright (C) 1996-1997 Id Software, Inc.
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

#ifndef __net_websock_h
#define __net_websock_h

sys_socket_t  WebSock_Init (void);
void WebSock_Shutdown (void);
void WebSock_Listen (qboolean state);
sys_socket_t  WebSock_OpenSocket (int port);
int  WebSock_CloseSocket (sys_socket_t socketid);
int  WebSock_Connect (sys_socket_t socketid, struct qsockaddr *addr);
sys_socket_t  WebSock_CheckNewConnections (void);
int  WebSock_Read (sys_socket_t socketid, byte *buf, int len, struct qsockaddr *addr);
int  WebSock_Write (sys_socket_t socketid, byte *buf, int len, struct qsockaddr *addr);
int  WebSock_Broadcast (sys_socket_t socketid, byte *buf, int len);
const char *WebSock_AddrToString (struct qsockaddr *addr);
int  WebSock_StringToAddr (const char *string, struct qsockaddr *addr);
int  WebSock_GetSocketAddr (sys_socket_t socketid, struct qsockaddr *addr);
int  WebSock_GetNameFromAddr (struct qsockaddr *addr, char *name);
int  WebSock_GetAddrFromName (const char *name, struct qsockaddr *addr);
int  WebSock_AddrCompare (struct qsockaddr *addr1, struct qsockaddr *addr2);
int  WebSock_GetSocketPort (struct qsockaddr *addr);
int  WebSock_SetSocketPort (struct qsockaddr *addr, int port);

#endif	/* __net_websock_h */

