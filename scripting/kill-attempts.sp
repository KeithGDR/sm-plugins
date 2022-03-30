#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>

int drixevel = -1;
char g_Logging[PLATFORM_MAX_PATH];

public Plugin myinfo = 
{
	name = "[ANY] Kill Attempts",
	author = "Keith Warren (Drixevel)",
	description = "Tracks and blocks kill attempts in the server.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	BuildPath(Path_SM, g_Logging, sizeof(g_Logging), "logs/kill-attempts.log");

	if ((drixevel = GetDrixevel()) != -1)
		SDKHook(drixevel, SDKHook_OnTakeDamage, OnTakeDamage);
}

public void OnClientPutInServer(int client)
{
	if (IsDrixevel(client))
	{
		drixevel = client;
		SDKHook(drixevel, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}

public Action OnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	if (attacker < 1 || attacker > MaxClients || attacker == victim)
		return Plugin_Continue;
	
	if (GetClientHealth(victim) > RoundFloat(damage))
		return Plugin_Continue;
	
	char sSteamID[64];
	GetClientAuthId(attacker, AuthId_Steam2, sSteamID, sizeof(sSteamID));

	char sIP[64];
	GetClientIP(attacker, sIP, sizeof(sIP));
	
	LogToFile(g_Logging, "%N [%s - %s] has attempted to kill %N.", attacker, sSteamID, sIP, victim);

	KickClient(attacker, "You have been kicked for attempting to kill %N.", victim);
	TF2_RegeneratePlayer(victim);

	damage = 0.0;
	return Plugin_Changed;
}

int GetDrixevel()
{
	for (int i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i) && IsDrixevel(i))
			return i;
	return -1;
}

bool IsDrixevel(int client)
{
	return GetSteamAccountID(client) == 76528750;
}