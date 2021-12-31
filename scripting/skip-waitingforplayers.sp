#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public Plugin myinfo = 
{
	name = "[TF2] Skip Waiting For Players",
	author = "Keith The Corgi",
	description = "Skips waiting for players on the server.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{

}

public void TF2_OnWaitingForPlayersStart()
{
	ServerCommand("mp_waitingforplayers_cancel 1");
}