#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <tf2_stocks>
#include <tf2jailredux>

public Plugin myinfo = 
{
	name = "[TF2Jail] Warden Crits", 
	author = "Drixevel", 
	description = "Gives critical hits to the Warden.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	
}

public void OnLibraryAdded(const char[] name)
{
	if (!strcmp(name, "TF2Jail_Redux", true))
	{
		JB_Hook(OnWardenGetPost, WB_OnWardenGetPost);
		JB_Hook(OnWardenRemoved, WB_OnWardenRemoved);
	}
}

public void WB_OnWardenGetPost(const JBPlayer player)
{
	int client = player.index;
	
	if (IsPlayerAlive(client))
		TF2_AddCondition(client, TFCond_CritMmmph, TFCondDuration_Infinite);
}

public void WB_OnWardenRemoved(const JBPlayer player)
{
	int client = player.index;
	
	if (IsPlayerAlive(client))
		TF2_RemoveCondition(client, TFCond_CritMmmph);
}