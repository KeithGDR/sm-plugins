//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals

public Plugin myinfo = 
{
	name = "Explosions", 
	author = "Drixevel", 
	description = "Explosions Explosions Explosions Explosions", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_explode", Command_Explode);
}

public void OnMapStart()
{
	PrecacheSound("items/cart_explode.wav");
}

public Action Command_Explode(int client, int args)
{
	if (client == 0 || !IsDrixevel(client))
		return Plugin_Handled;
	
	float vecPos[3];
	GetClientCrosshairOrigin(client, vecPos);
	
	CreateParticle("cinefx_goldrush", 10.0, vecPos);
	EmitSoundToAll("items/cart_explode.wav");
	ScreenShakeAll(SHAKE_START, 50.0, 150.0, 3.0);
	PushAllPlayersFromPoint(vecPos, 500.0, 250.0, 0);
	DamageArea(vecPos, 250.0, 99999.0, 0, 0, 0, DMG_BLAST, -1);
	
	return Plugin_Handled;
}