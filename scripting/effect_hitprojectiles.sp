//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals

public Plugin myinfo = 
{
	name = "Hit Projectiles", 
	author = "Drixevel", 
	description = "Allows scouts to hit projectiles.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponname, bool& result)
{
	if (TF2_GetPlayerClass(client) != TFClass_Scout || (StrContains(weaponname, "tf_weapon_bat") == -1 && StrContains(weaponname, "saxxy") == -1))
		return Plugin_Continue;
	
	float vecOrigin[3];
	GetClientAbsOrigin(client, vecOrigin);

	float vecAngles[3];
	GetClientAbsOrigin(client, vecAngles);

	float vecPoint[3];
	AddInFrontOf(vecOrigin, vecAngles, 3.0, vecPoint);

	int entity = -1; float vecProj[3]; int iTeam; char sClass[32];
	while ((entity = FindEntityByClassname(entity, "tf_projectile_*")) != -1)
	{
		GetEntityClassname(entity, sClass, sizeof(sClass));
		
		if (StrContains(sClass, "arrow") != -1 && GetEntityMoveType(entity) == MOVETYPE_NONE)
			continue;
		
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vecProj);

		if (GetVectorDistance(vecPoint, vecProj) > 150.0) //180
			continue;

		float fEyeAngles[3], fDirection[3];
		GetClientEyeAngles(client, fEyeAngles);
		GetAngleVectors(fEyeAngles, fDirection, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fDirection, 2000.0);
		TeleportEntity(entity, NULL_VECTOR, fEyeAngles, fDirection);

		SetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity", client);

		if (HasEntProp(entity, Prop_Send, "m_bCritical"))
			SetEntProp(entity, Prop_Send, "m_bCritical", true);

		iTeam = GetClientTeam(client);
		SetEntProp(entity, Prop_Send, "m_nSkin", (iTeam - 2));
		SetEntProp(entity, Prop_Send, "m_iTeamNum", iTeam);

		SetVariantInt(iTeam);
		AcceptEntityInput(entity, "TeamNum", -1, -1, 0);

		SetVariantInt(iTeam);
		AcceptEntityInput(entity, "SetTeam", -1, -1, 0);

		EmitSoundToAll(")weapons/bat_baseball_hit1.wav", client);
	}
	
	TFTeam team = TF2_GetClientTeam(client);
	bool friendlyfire = FindConVar("mp_friendlyfire").BoolValue;

	entity = -1;
	while ((entity = FindEntityByClassname(entity, "player")) != -1)
	{
		if (client == entity || (!friendlyfire && TF2_GetClientTeam(entity) == team))
			continue;
		
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vecProj);

		if (GetVectorDistance(vecPoint, vecProj) > 150.0)
			continue;

		float fEyeAngles[3], fDirection[3];
		GetClientEyeAngles(client, fEyeAngles);
		GetAngleVectors(fEyeAngles, fDirection, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fDirection, 2000.0);
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, fDirection);

		EmitSoundToAll(")weapons/bat_baseball_hit1.wav", client);
	}

	return Plugin_Continue;
}

void AddInFrontOf(float vecOrigin[3], float vecAngle[3], float units, float output[3]) 
{ 
    float vecAngVectors[3]; 
    vecAngVectors = vecAngle; //Don't change input 
    GetAngleVectors(vecAngVectors, vecAngVectors, NULL_VECTOR, NULL_VECTOR); 
    for (int i; i < 3; i++) 
    	output[i] = vecOrigin[i] + (vecAngVectors[i] * units); 
}