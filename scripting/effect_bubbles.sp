//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals
int g_Bubble[MAXPLAYERS + 1] = {INVALID_ENT_REFERENCE, ...};
float g_LastVelocity[MAXPLAYERS + 1][3];
int g_Particles[MAXPLAYERS + 1][7];

public Plugin myinfo = 
{
	name = "Bubbles", 
	author = "Drixevel", 
	description = "Trap players in bubbles.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_OnPlayerDeath);
	RegConsoleCmd("sm_bubble", Command_Bubble);
	
	for (int i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i))
			OnClientPutInServer(i);
}

public void OnPluginEnd()
{
	for (int i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i))
			UnbubbleClient(i);
}

public void OnMapStart()
{
	PrecacheModel("models/effects/resist_shield/resist_shield.mdl");
	PrecacheModel("models/empty.mdl");
	PrecacheSound("weapons/bumper_car_hit_ball.wav");
	PrecacheSound("ambient/water/water_splash1.wav");
	PrecacheSound("ambient/water/water_splash2.wav");
	PrecacheSound("ambient/water/water_splash3.wav");
}

public void Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	
	if (victim > 0)
		UnbubbleClient(victim);
}

public void OnClientPutInServer(int client)
{
	for (int i = 0; i < 7; i++)
		g_Particles[client][i] = INVALID_ENT_REFERENCE;
}

public void OnClientDisconnect(int client)
{
	UnbubbleClient(client);
}

public Action Command_Bubble(int client, int args)
{
	if (client == 0 || !IsDrixevel(client))
		return Plugin_Handled;
	
	char sTarget[64];
	GetCmdArgString(sTarget, sizeof(sTarget));
	
	int target = FindTarget(client, sTarget, false, false);
	
	if (target == -1)
		return Plugin_Handled;
	
	if (g_Bubble[target] == INVALID_ENT_REFERENCE)
		BubbleClient(target);
	else
		UnbubbleClient(target);
	
	return Plugin_Handled;
}

void BubbleClient(int client)
{
	if (client == 0 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client) || g_Bubble[client] != INVALID_ENT_REFERENCE)
		return;
	
	float vecOrigin[3];
	GetClientAbsOrigin(client, vecOrigin);
	
	float vecAngles[3];
	GetClientAbsAngles(client, vecAngles);
	
	int prop = CreateProp("models/effects/resist_shield/resist_shield.mdl", vecOrigin, vecAngles, 1, false);
	int iLink = CreateLink(client);
	
	SetVariantString("!activator");
	AcceptEntityInput(prop, "SetParent", iLink); 
	
	TF2_AddCondition(client, TFCond_FreezeInput, TFCondDuration_Infinite);
	EmitSoundToAll("weapons/bumper_car_hit_ball.wav", client);
	g_Particles[client][0] = EntIndexToEntRef(AttachParticle(client, "waterfall_bottommist"));
	g_Particles[client][1] = EntIndexToEntRef(AttachParticle(client, "waterfall_bottomsplash"));
	g_Particles[client][2] = EntIndexToEntRef(AttachParticle(client, "waterfall_bottomwaves"));
	g_Particles[client][3] = EntIndexToEntRef(AttachParticle(client, "waterfall_mist"));
	g_Particles[client][4] = EntIndexToEntRef(AttachParticle(client, "waterfall_rocksplash"));
	g_Particles[client][5] = EntIndexToEntRef(AttachParticle(client, "waterfall_rocksplash_2"));
	g_Particles[client][6] = EntIndexToEntRef(AttachParticle(client, "waterfall_sides"));
	SetEntityRenderColor(client, 0, 255, 255, 255);
	
	g_Bubble[client] = EntIndexToEntRef(iLink);
}

void UnbubbleClient(int client)
{
	if (client == 0 || client > MaxClients)
		return;
	
	if (g_Bubble[client] != INVALID_ENT_REFERENCE)
		AcceptEntityInput(g_Bubble[client], "Kill");
	
	g_Bubble[client] = INVALID_ENT_REFERENCE;
	TF2_RemoveCondition(client, TFCond_FreezeInput);
	SetEntityRenderColor(client, 255, 255, 255, 255);
	
	for (int i = 0; i < 7; i++)
	{
		if (g_Particles[client][i] != INVALID_ENT_REFERENCE)
			AcceptEntityInput(g_Particles[client][i], "Kill");
		
		g_Particles[client][i] = INVALID_ENT_REFERENCE;
	}
}

int CreateLink(int iClient)
{
	int iLink = CreateEntityByName("tf_taunt_prop");
	DispatchSpawn(iLink); 
	
	SetEntityModel(iLink, "models/empty.mdl");
	
	SetEntProp(iLink, Prop_Send, "m_fEffects", 16|64);
	
	SetVariantString("!activator"); 
	AcceptEntityInput(iLink, "SetParent", iClient); 
	
	SetVariantString("flag");
	AcceptEntityInput(iLink, "SetParentAttachment", iClient);
	
	return iLink;
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (client == 0 || g_Bubble[client] == INVALID_ENT_REFERENCE)
		return Plugin_Continue;
		
	float vOrigin[3];
	GetEntPropVector(client, Prop_Data, "m_vecOrigin", vOrigin);
	
	if (GetEntityFlags(client) & FL_ONGROUND)
	{
		float speed[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", speed);
		
		speed[0] = GetRandomFloat(-2000.0, 2000.0);
		speed[1] = GetRandomFloat(-2000.0, 2000.0);
		speed[2] = 500.0;
		
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, speed);
		CreateTempParticle("water_burning_steam", vOrigin);
		
		char sSound[PLATFORM_MAX_PATH];
		FormatEx(sSound, sizeof(sSound), "ambient/water/water_splash%i.wav", GetRandomInt(1, 3));
		EmitSoundToAll(sSound, client);
		
		return Plugin_Continue;
	}
	
	float vVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vVelocity);
	
	float temp[3];
	GetVectorAngles(vVelocity, temp);
	
	Handle trace = TR_TraceRayFilterEx(vOrigin, temp, MASK_SHOT, RayType_Infinite, TEF_ExcludeEntity, client);
	
	if (!TR_DidHit(trace))
	{
		delete trace;
		return Plugin_Continue;
	}
	
	float end[3];
	TR_GetEndPosition(end, trace);
	
	if (GetVectorDistance(vOrigin, end) > 50.0)
	{
		delete trace;
		return Plugin_Continue;
	}
	
	float vNormal[3];
	TR_GetPlaneNormal(trace, vNormal);
	
	delete trace;
	
	float dotProduct = GetVectorDotProduct(vNormal, vVelocity);
	
	ScaleVector(vNormal, dotProduct);
	ScaleVector(vNormal, GetRandomFloat(2.0, 2.2));
	
	float vBounceVec[3];
	SubtractVectors(vVelocity, vNormal, vBounceVec);
	
	if (vBounceVec[0] == 0.0)
		vBounceVec[0] = GetRandomFloat(GetRandomFloat(-500.0, -400.0), GetRandomFloat(400.0, 500.0));
	else if (vBounceVec[0] == g_LastVelocity[client][0])
		vBounceVec[0] += GetRandomFloat(-30.0, 30.0);
		
	if (vBounceVec[1] == 0.0)
		vBounceVec[1] = GetRandomFloat(GetRandomFloat(-500.0, -400.0), GetRandomFloat(400.0, 500.0));
	else if (vBounceVec[1] == g_LastVelocity[client][1])
		vBounceVec[1] += GetRandomFloat(-30.0, 30.0);
		
	if (vBounceVec[2] < 250.0)
		vBounceVec[2] += GetRandomFloat(50.0, 100.0);
	
	vBounceVec[0] += GetRandomFloat(-300.0, 300.0);
	vBounceVec[1] += GetRandomFloat(-300.0, 300.0);
	
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vBounceVec);
	//PrintToChat(client, "%.2f/%.2f/%.2f", vBounceVec[0], vBounceVec[1], vBounceVec[2]);
	
	DamageArea(vOrigin, 100.0, 50.0, client, 0, GetClientTeam(client) == 2 ? 3 : 2, DMG_CLUB, -1, vBounceVec);
	
	char sSound[PLATFORM_MAX_PATH];
	FormatEx(sSound, sizeof(sSound), "ambient/water/water_splash%i.wav", GetRandomInt(1, 3));
	EmitSoundToAll(sSound, client);
	CreateTempParticle("Explosion_bubbles", end);
	
	g_LastVelocity[client][0] = vBounceVec[0];
	g_LastVelocity[client][1] = vBounceVec[1];
	g_LastVelocity[client][2] = vBounceVec[2];
	
	return Plugin_Continue;
}

public bool TEF_ExcludeEntity(int entity, int contentsMask, any data)
{
	return (entity != data);
}