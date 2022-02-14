#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <tf2_stocks>

public Plugin myinfo = 
{
	name = "Random Tracker",
	author = "Keith Warren (Drixevel)",
	description = "Because players love to kill on random servers.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_OnPlayerDeath);
}

public void Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	if (GetSteamAccountID(victim) == 76528750 && GetSteamAccountID(attacker) != 76528750 && attacker > 0 && attacker <= MaxClients && !IsFakeClient(attacker))
	{
		SavePlayerSteamID(attacker);
		PrintToChatAll("%N kicked by the random tracker for attempt: %i", attacker, GetPlayerAttempts(attacker));
		KickClient(attacker, "Congrats, you're now a statistic.");
		CreateTimer(1.0, Timer_Respawn, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_Respawn(Handle timer, any data)
{
	int client;
	if ((client = GetClientOfUserId(data)) > 0)
	{
		if (TF2_GetClientTeam(client) < TFTeam_Red)
			TF2_ChangeClientTeam(client, TFTeam_Red);
		
		if (!IsPlayerAlive(client))
			TF2_RespawnPlayer(client);
	}
}

void SavePlayerSteamID(int client)
{
	char sSteamID[64];
	if (!GetClientAuthId(client, AuthId_Steam2, sSteamID, sizeof(sSteamID)))
		return;
	
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "random-tracker.txt");

	File file = OpenFile(sPath, "a");
	file.WriteLine(sSteamID);
	file.Close();
}

int GetPlayerAttempts(int client)
{
	char sSteamID[64];
	if (!GetClientAuthId(client, AuthId_Steam2, sSteamID, sizeof(sSteamID)))
		return 0;
	
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "random-tracker.txt");

	File file = OpenFile(sPath, "r");

	if (file == null)
		return 0;
	
	int amount; char sLine[64];
	while(!file.EndOfFile() && file.ReadLine(sLine, sizeof(sLine)))
	{
		TrimString(sLine);
		
		if (StrEqual(sLine, sSteamID, false))
			amount++;
	}

	file.Close();
	return amount;
}