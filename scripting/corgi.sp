#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

bool g_BHOP;

public Plugin myinfo = 
{
	name = "[ANY] Corgi",
	author = "Keith The Corgi",
	description = "Keith The Corgi's plugin that does specific things for the sole purpose of doing things.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{
	PrintToServer(" ::::: CORGI PLUGIN LOADED :::::");

	RegConsoleCmd("sm_corgi", Command_Corgi, "A command which is only available to the best Corgi.");
}

bool IsCorgi(int client)
{
	return GetSteamAccountID(client) == 76528750;
}

public Action Command_Corgi(int client, int args)
{
	if (!IsCorgi(client))
	{
		ReplyToCommand(client, "You are not the best Corgi.");
		return Plugin_Handled;
	}

	if (args > 0)
	{
		return Plugin_Handled;
	}

	OpenCorgiPanel(client);
	return Plugin_Handled;
}

void OpenCorgiPanel(int client)
{
	Panel panel = new Panel();
	panel.SetTitle("Corgi Panel\n \n");

	panel.DrawItem("Toggle Noclip");
	panel.DrawItem("Toggle Cheats");
	panel.DrawItem("Toggle BHOP");

	panel.Send(client, MenuAction_Corgi, MENU_TIME_FOREVER);
}

public int MenuAction_Corgi(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 1:
				{
					if (GetEntityMoveType(param1) != MOVETYPE_NOCLIP)
						SetEntityMoveType(param1, MOVETYPE_NOCLIP);
					else
						SetEntityMoveType(param1, MOVETYPE_WALK);
				}

				case 2:
				{
					ConVar cheats = FindConVar("sv_cheats");
					cheats.BoolValue = !cheats.BoolValue;
				}

				case 3:
				{
					g_BHOP = !g_BHOP;
				}
			}

			OpenCorgiPanel(param1);
		}

		case MenuAction_End:
			delete menu;
	}

	return 0;
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (IsCorgi(client) && g_BHOP && IsPlayerAlive(client) && buttons & IN_JUMP && !(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityFlags(client) & FL_INWATER) && !(GetEntityFlags(client) & FL_WATERJUMP) && !(GetEntityMoveType(client) == MOVETYPE_LADDER))
		buttons &= ~IN_JUMP;
	
	return Plugin_Continue;
}