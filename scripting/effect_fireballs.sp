//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals

public Plugin myinfo = 
{
	name = "Fireballs", 
	author = "Drixevel", 
	description = "Create fireballs from your skull in multiple directions.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_fireball", Command_Fireball);
}

public Action Command_Fireball(int client, int args)
{
	if (client == 0 || !IsDrixevel(client))
		return Plugin_Handled;

	if (!IsPlayerAlive(client))
	{
		PrintToChat(client, "[SM] You must be alive to use this command.");
		return Plugin_Handled;
	}

	char sArg[32];
	GetCmdArgString(sArg, sizeof(sArg));
	
	float dir = StringToFloat(sArg);

	float vecPosition[3];
	GetClientEyePosition(client, vecPosition);

	float vecAngles[3];
	GetClientEyeAngles(client, vecAngles);

	RotateYaw(vecAngles, dir);
	
	TF2_FireProjectile(vecPosition, vecAngles, "tf_projectile_spellfireball", client, GetClientTeam(client), GetRandomFloat(900.0, 1300.0), GetRandomFloat(60.0, 120.0), GetRandomBool(), GetActiveWeapon(client));

	return Plugin_Handled;
}