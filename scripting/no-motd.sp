#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

bool g_Skip[MAXPLAYERS + 1];

public Plugin myinfo = 
{
	name = "[TF2] Disable MOTD",
	author = "Keith The Corgi",
	description = "Disable MOTD automatically for all players on connect.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("Train"), UserMessageHook, true);
}

public Action UserMessageHook(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (playersNum == 1 && IsClientConnected(players[0]) && !IsFakeClient(players[0]) && !g_Skip[players[0]])
	{
		g_Skip[players[0]] = true;
		RequestFrame(KillMOTD, GetClientUserId(players[0]));
	}
	
	return Plugin_Continue;
}

public void KillMOTD(any data)
{
	int client;
	if ((client = GetClientOfUserId(data)) == 0)
		return;
	
	ShowVGUIPanel(client, "info", _, false);
	ShowVGUIPanel(client, "team", _, true);
}

public void OnClientDisconnect_Post(int client)
{
	g_Skip[client] = false;
}