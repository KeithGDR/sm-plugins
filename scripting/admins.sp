#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

ConVar convar_Enabled;

char g_File[PLATFORM_MAX_PATH];

public Plugin myinfo =  {
	name = "[ANY] Admins", 
	author = "Drixevel", 
	description = "Easy way to add or remove admins to the admins_simple.ini file.", 
	version = "1.0.1", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart() {
	CreateConVar("sm_admins_simple_version", "1.0.0", "Version control for this plugin.", FCVAR_DONTRECORD);
	convar_Enabled = CreateConVar("sm_admins_simple_enabled", "1", "Should this plugin be enabled or disabled?", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	AutoExecConfig();

	BuildPath(Path_SM, g_File, sizeof(g_File), "configs/admins_simple.ini");

	RegAdminCmd("sm_addadmin", Command_AddAdmin, ADMFLAG_RCON);
	RegAdminCmd("sm_removeadmin", Command_RemoveAdmin, ADMFLAG_RCON);
}

public Action Command_AddAdmin(int client, int args) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	if (args < 2) {
		char sCommand[64];
		GetCmdArg(0, sCommand, sizeof(sCommand));
		ReplyToCommand(client, "[SM] %s <target> <flag> <password>", sCommand);
		return Plugin_Handled;
	}

	char sTarget[MAX_TARGET_LENGTH];
	GetCmdArg(1, sTarget, sizeof(sTarget));

	char sFlags[20];
	GetCmdArg(2, sFlags, sizeof(sFlags));

	char sImmunity[16];
	GetCmdArg(3, sImmunity, sizeof(sImmunity));
	int iImmunity = StringToInt(sImmunity);

	char sPassword[64];
	GetCmdArg(4, sPassword, sizeof(sPassword));

	if (iImmunity < 1) {
		iImmunity = 1;
	} else if (iImmunity > 255) {
		iImmunity = 255;
	}

	File fFile = OpenFile(g_File, "at");
	fFile.WriteLine("\"%s\" \"%i:%s\" \"%s\"", sTarget, iImmunity, sFlags, sPassword);
	delete fFile;

	LogAction(client, -1, "\"%L\" added target \"%s\" with \"%s\" flags and \"%i\" immunity into admins_simple.ini", client, sTarget, sFlags, iImmunity);
	ReloadAdmins(client);

	return Plugin_Handled;
}

public Action Command_RemoveAdmin(int client, int args) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	if (args < 1) {
		char sCommand[64];
		GetCmdArg(0, sCommand, sizeof(sCommand));
		ReplyToCommand(client, "[SM] %s <target>", sCommand);
		return Plugin_Handled;
	}

	char sTarget[MAX_TARGET_LENGTH];
	GetCmdArg(1, sTarget, sizeof(sTarget));

	char sCopy[PLATFORM_MAX_PATH];
	FormatEx(sCopy, sizeof(sCopy), "%s.copy", g_File);

	File fFile = OpenFile(g_File, "rt");
	File fTempFile = OpenFile(sCopy, "wt");

	char szLine[256]; bool bFound;
	while (!fFile.EndOfFile()) {
		if (!fFile.ReadLine(szLine, sizeof(szLine))) {
			continue;
		}

		TrimString(szLine);

		if(StrContains(szLine, sTarget) == -1) {
			fTempFile.WriteLine(szLine);
		} else {
			bFound = true;
		}
	}

	delete fFile;
	delete fTempFile;

	DeleteFile(g_File);
	RenameFile(g_File, sCopy);

	if (bFound) {
		LogAction(client, -1, "\"%L\" removed steamid \"%s\" from admins_simple.ini", client, sTarget);
		ReloadAdmins(client);
	} else {
		LogAction(client, -1, "\"%L\" tried to remove steamid \"%s\" from admins_simple.ini, but not found", client, sTarget);
	}

	return Plugin_Handled;
}

void ReloadAdmins(int client) {
	DumpAdminCache(AdminCache_Admins, true);
	LogAction(client, -1, "Cache has been refreshed for the admins plugin by \"%L\"", client);
}