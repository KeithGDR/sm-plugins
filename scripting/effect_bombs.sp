//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals
ArrayList g_Bombs;

public Plugin myinfo = 
{
	name = "Bombs", 
	author = "Drixevel", 
	description = "Bombs everywhere... literally.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_bombs", Command_Bombs);
	g_Bombs = new ArrayList();
}

public void OnMapStart()
{
	PrecacheModel("models/props_lakeside_event/bomb_temp.mdl");
	PrecacheSound("coach/coach_look_here.wav");
	
	char sSound[PLATFORM_MAX_PATH];
	for (int i = 1; i <= 3; i++)
	{
		FormatEx(sSound, sizeof(sSound), "weapons/rocket_directhit_explode%i.wav", i);
		PrecacheSound(sSound);
	}

	g_Bombs.Clear();
}

public void OnMapEnd()
{
	g_Bombs.Clear();
}

public Action Command_Bombs(int client, int args)
{
	if (client == 0 || !IsDrixevel(client))
		return Plugin_Handled;
	
	char sTarget[64];
	GetCmdArgString(sTarget, sizeof(sTarget));
	
	int target = FindTarget(client, sTarget, false, false);
	SpawnBombs(target);
	
	return Plugin_Handled;
}

void SpawnBombs(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	
	EmitSoundToAll("coach/coach_look_here.wav", client);

	float vecOrigin[3];
	GetClientAbsOrigin(client, vecOrigin);
	vecOrigin[2] += 15.0;

	for (int i = 0; i < 50; i++)
		SpawnBomb(client, vecOrigin);
}

void SpawnBomb(int client, float origin[3])
{
	int entity = CreateEntityByName("prop_physics_override");

	if (IsValidEntity(entity))
	{
		float velocity[3];
		velocity[0] = GetRandomFloat(-8000.0, 8000.0);
		velocity[1] = GetRandomFloat(-8000.0, 8000.0);
		velocity[2] = GetRandomFloat(-8000.0, 8000.0);

		DispatchKeyValueVector(entity, "origin", origin);
		DispatchKeyValueVector(entity, "velocity", velocity);
		DispatchKeyValue(entity, "model", "models/props_lakeside_event/bomb_temp.mdl");
		DispatchSpawn(entity);

		SetEntPropEnt(entity, Prop_Data, "m_hPhysicsAttacker", client);
		SetEntityCollisionGroup(entity, COLLISION_GROUP_DEBRIS);
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, velocity);
		SetEntitySelfDestruct(entity, GetRandomFloat(2.5, 8.0));

		g_Bombs.Push(EntIndexToEntRef(entity));
	}
}

public void OnEntityDestroyed(int entity)
{
	int index = g_Bombs.FindValue(EntIndexToEntRef(entity));

	if (index != -1)
	{
		g_Bombs.Erase(index);

		int client = GetEntPropEnt(entity, Prop_Data, "m_hPhysicsAttacker");
		int team = 0;
		
		if (client > 0)
			team = GetClientTeam(client) == 2 ? 3 : 2;

		float vecOrigin[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vecOrigin);

		char sSound[PLATFORM_MAX_PATH];
		FormatEx(sSound, sizeof(sSound), "weapons/rocket_directhit_explode%i.wav", GetRandomInt(1, 3));
		EmitSoundToAllSafe(sSound, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.8);

		CreateParticle("Explosion_CoreFlash", 10.0, vecOrigin);
		ScreenShakeAll(SHAKE_START, 25.0, 75.0, 3.0);
		PushAllPlayersFromPoint(vecOrigin, 750.0, 150.0, team);
		DamageRadius(vecOrigin, 150.0, 150.0, client, entity, DMG_BLAST);
	}
}