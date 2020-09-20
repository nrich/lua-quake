#include "quakedef.h"

#include "q_stdinc.h"
#include "arch_def.h"
#include "net_sys.h"
#include "quakedef.h"
#include "net_defs.h"

#include "net_loop.h"

net_driver_t net_drivers[MAX_NET_DRIVERS] =
{
    {
    "Loopback",
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
    }
};
const int net_numdrivers = 1;

net_landriver_t net_landrivers[MAX_NET_DRIVERS];
const int net_numlandrivers = 0;
