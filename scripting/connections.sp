#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
	name = "[TF2] Connections",
	author = "Keith The Corgi",
	description = "Simple plugin to log connections to the server.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{

}

public void OnClientAuthorized(int client, const char[] auth)
{
	if (IsFakeClient(client))
		return;
	
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "logs/connections.log");

	char sSteam2[64];
	GetClientAuthId(client, AuthId_Steam2, sSteam2, sizeof(sSteam2));

	char sSteam3[64];
	GetClientAuthId(client, AuthId_Steam3, sSteam3, sizeof(sSteam3));

	char sSteam64[64];
	GetClientAuthId(client, AuthId_SteamID64, sSteam64, sizeof(sSteam64));

	char sIP[64];
	GetClientIP(client, sIP, sizeof(sIP));

	LogToFile(sPath, "%N - [%s][%s][%s][%s]", client, sSteam2, sSteam3, sSteam64, sIP);
}