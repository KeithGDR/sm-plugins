#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_Late;

public Plugin myinfo = 
{
	name = "[TF2] Disable Gamemode",
	author = "Keith The Corgi",
	description = "Disable gamemodes automatically for all maps.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_Late = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	int entity = -1; char sClass[64];
	while ((entity = FindEntityByClassname(entity, "*")) != -1)
		if (GetEntityClassname(entity, sClass, sizeof(sClass)))
			OnEntityCreated(entity, sClass);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "tf_logic_arena", false) || StrEqual(classname, "tf_logic_koth", false))
	{
		SDKHook(entity, SDKHook_Spawn, OnSpawn);

		if (g_Late)
			AcceptEntityInput(entity, "Kill");
	}
}

public Action OnSpawn(int entity)
{
	AcceptEntityInput(entity, "Kill");
	return Plugin_Continue;
}