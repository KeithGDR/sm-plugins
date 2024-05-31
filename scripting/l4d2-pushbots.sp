#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

ConVar convar_Enabled;
ConVar convar_Magnitude;
ConVar convar_Radius;

public Plugin myinfo = {
	name = "[L4D2] Push Bots",
	author = "Drixevel",
	description = "Pushes bots away from hazards on the ground.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnPluginStart() {
	CreateConVar("sm_l4d2_pushbots_version", "1.0.0", "Version control for this plugin.", FCVAR_DONTRECORD);
	convar_Enabled = CreateConVar("sm_l4d2_pushbots_enabled", "1", "Should this plugin be enabled or disabled?", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	convar_Magnitude = CreateConVar("sm_l4d2_pushbots_magnitude", "50", "What should the magnitude for movement be?", FCVAR_NOTIFY, true, 0.0);
	convar_Radius = CreateConVar("sm_l4d2_pushbots_radius", "100", "What should the radius for movement be?", FCVAR_NOTIFY, true, 0.0);
	AutoExecConfig();

	CreateTimer(0.1, Timer_Tick, _, TIMER_REPEAT);
}

public Action Timer_Tick(Handle timer) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "insect_swarm")) != -1) {
		PushBots(entity);
	}

	entity = -1;
	while ((entity = FindEntityByClassname(entity, "inferno")) != -1) {
		PushBots(entity);
	}

	return Plugin_Continue;
}

void PushBots(int entity) {
	float origin[3];
	GetEntPropVector(entity, Prop_Data, "m_vecOrigin", origin);

	for (int i = 1; i <= MaxClients; i++) {
		if (!IsClientConnected(i) || !IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2 || !IsFakeClient(i)) {
			continue;
		}

		PushPlayerFromPoint(i, origin, convar_Magnitude.FloatValue, convar_Radius.FloatValue);
	}
}

void PushPlayerFromPoint(int client, float point[3], float magnitude = 50.0, float radius = 0.0) {
	float vecOrigin[3];
	GetClientAbsOrigin(client, vecOrigin);

	if (GetVectorDistance(point, vecOrigin) > radius) {
		return;
	}

	float vector[3];
	MakeVectorFromPoints(point, vecOrigin, vector);

	NormalizeVector(vector, vector);
	ScaleVector(vector, magnitude);

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vector);
}