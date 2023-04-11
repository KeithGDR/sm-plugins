#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>

public Plugin myinfo = {
	name = "[ANY] Admins Only",
	author = "Drixevel",
	description = "A simple plugin which only allows admins to access the server.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnPluginStart() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) {
			OnClientPostAdminCheck(i);
		}
	}
}

public void OnClientPostAdminCheck(int client) {
	CreateTimer(1.0, Timer_DelayCheck, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_DelayCheck(Handle timer, any data) {
	int client;
	if ((client = GetClientOfUserId(data)) > 0 && !CheckCommandAccess(client, "", ADMFLAG_RESERVATION, true)) {
		KickClient(client, "Only admins can join this server at this time.");
	}

	return Plugin_Continue;
}