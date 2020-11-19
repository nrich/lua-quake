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

#ifndef __NET_DIRECT_H
#define __NET_DIRECT_H

// net_loop.h
int		Direct_Init (void);
void		Direct_Listen (qboolean state);
void		Direct_SearchForHosts (qboolean xmit);
qsocket_t	*Direct_Connect (const char *host);
qsocket_t	*Direct_CheckNewConnections (void);
int		Direct_GetMessage (qsocket_t *sock);
int		Direct_SendMessage (qsocket_t *sock, sizebuf_t *data);
int		Direct_SendUnreliableMessage (qsocket_t *sock, sizebuf_t *data);
qboolean	Direct_CanSendMessage (qsocket_t *sock);
qboolean	Direct_CanSendUnreliableMessage (qsocket_t *sock);
void		Direct_Close (qsocket_t *sock);
void		Direct_Shutdown (void);

#endif	/* __NET_DIRECT_H */

