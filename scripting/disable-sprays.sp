#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
	name = "[TF2] Disable Sprays",
	author = "Keith The Corgi",
	description = "Disable all sprays functionality.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{
	AddTempEntHook("Player Decal", OnPlayerDecal);
}

public Action OnPlayerDecal(const char[] te_name, const int[] Players, int numClients, float delay)
{
	int client = TE_ReadNum("m_nPlayer");
	
	if (client > 0 && IsClientInGame(client))
	{		
		PrintToChat(client, "Sprays are currently disabled.");	
		return Plugin_Handled;
	}

	return Plugin_Continue;
}