#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

int g_AdIndex;

public Plugin myinfo = 
{
	name = "[TF2] Ads",
	author = "Keith The Corgi",
	description = "A simple plugin to put ads in chat.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{
	CreateTimer(300.0, Timer_Ads, _, TIMER_REPEAT);
}

public Action Timer_Ads(Handle timer, any data)
{
	g_AdIndex++;

	switch (g_AdIndex)
	{
		case 1:
			PrintToChatAll("Welcome to the Corgi Fanclub Server!");
		case 2:
			PrintToChatAll("Join Our Discord: https://discord.gg/V576hj6A42");
	}

	if (g_AdIndex >= 2)
		g_AdIndex = 0;
	
	return Plugin_Continue;
}