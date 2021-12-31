#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_Late;

public Plugin myinfo = 
{
	name = "[TF2] Open Doors",
	author = "Keith The Corgi",
	description = "Opens all doors and automatically locks them.",
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
	if (StrContains(classname, "door", false) != -1 || StrEqual(classname, "func_brush", false))
	{
		SDKHook(entity, SDKHook_SpawnPost, OnSpawnPost);

		if (g_Late)
		{
			AcceptEntityInput(entity, "Unlock");
			AcceptEntityInput(entity, "Open");
			AcceptEntityInput(entity, "Lock");
		}
	}
}

public Action OnSpawnPost(int entity)
{
	AcceptEntityInput(entity, "Unlock");
	AcceptEntityInput(entity, "Open");
	AcceptEntityInput(entity, "Lock");
	return Plugin_Continue;
}