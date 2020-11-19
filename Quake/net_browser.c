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

#include "q_stdinc.h"
#include "arch_def.h"
#include "net_sys.h"
#include "quakedef.h"
#include "net_defs.h"

#include "net_direct.h"
#include "net_loop.h"

net_driver_t net_drivers[] =
{
	{	"Loopback",
		false,
		Loop_Init,
		Loop_Listen,
		Loop_SearchForHosts,
		Loop_Connect,
		Loop_CheckNewConnections,
		Loop_GetMessage,
		Loop_SendMessage,
		Loop_SendUnreliableMessage,
		Loop_CanSendMessage,
		Loop_CanSendUnreliableMessage,
		Loop_Close,
		Loop_Shutdown
	},
	{	"Direct",
		false,
		Direct_Init,
		Direct_Listen,
		Direct_SearchForHosts,
		Direct_Connect,
		Direct_CheckNewConnections,
		Direct_GetMessage,
		Direct_SendMessage,
		Direct_SendUnreliableMessage,
		Direct_CanSendMessage,
		Direct_CanSendUnreliableMessage,
		Direct_Close,
		Direct_Shutdown
	}
};

const int net_numdrivers = (sizeof(net_drivers) / sizeof(net_drivers[0]));

#include "net_websock.h"

net_landriver_t	net_landrivers[] =
{
	{	"WebSock",
		false,
		0,
		WebSock_Init,
		WebSock_Shutdown,
		WebSock_Listen,
		WebSock_OpenSocket,
		WebSock_CloseSocket,
		WebSock_Connect,
		WebSock_CheckNewConnections,
		WebSock_Read,
		WebSock_Write,
		WebSock_Broadcast,
		WebSock_AddrToString,
		WebSock_StringToAddr,
		WebSock_GetSocketAddr,
		WebSock_GetNameFromAddr,
		WebSock_GetAddrFromName,
		WebSock_AddrCompare,
		WebSock_GetSocketPort,
		WebSock_SetSocketPort
	}/*,
	{	"WebRTC",
		false,
		0,
		WebRTC_Init,
		WebRTC_Shutdown,
		WebRTC_Listen,
		WebRTC_OpenSocket,
		WebRTC_CloseSocket,
		WebRTC_Connect,
		WebRTC_CheckNewConnections,
		WebRTC_Read,
		WebRTC_Write,
		WebRTC_Broadcast,
		WebRTC_AddrToString,
		WebRTC_StringToAddr,
		WebRTC_GetSocketAddr,
		WebRTC_GetNameFromAddr,
		WebRTC_GetAddrFromName,
		WebRTC_AddrCompare,
		WebRTC_GetSocketPort,
		WebRTC_SetSocketPort
	}*/
};

const int net_numlandrivers = (sizeof(net_landrivers) / sizeof(net_landrivers[0]));

