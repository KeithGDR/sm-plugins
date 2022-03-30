#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public Plugin myinfo = 
{
	name = "[ANY] Admins", 
	author = "Drixevel", 
	description = "Easy way to add admins to the admins_simple.ini file.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_addadmin", Command_AddAdmin, ADMFLAG_RCON);
	RegAdminCmd("sm_removeadmin", Command_RemoveAdmin, ADMFLAG_RCON);
}

public Action Command_AddAdmin(int client, int args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "Use: sm_addadmin <steamid> <flag>");
		return Plugin_Handled;
	}

	char szTarget[64], szFlags[20];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	GetCmdArg(2, szFlags, sizeof(szFlags));

	char szFile[256];
	BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

	File fFile = OpenFile(szFile, "at");

	fFile.WriteLine("\"%s\" \"%s\"", szTarget, szFlags);

	delete fFile;

	LogAction(0, -1, "System added steamid %s into admins_simple.ini", szTarget);

	ReloadAdmins();

	return Plugin_Handled;
}

public Action Command_RemoveAdmin(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "Use: sm_removeadmin <steamid>");
		return Plugin_Handled;
	}

	char szFilePath[PLATFORM_MAX_PATH], szFileCopyPath[PLATFORM_MAX_PATH], szAuth[21], szLine[256];

	GetCmdArg(1, szAuth, sizeof(szAuth));
	BuildPath(Path_SM, szFilePath, sizeof(szFilePath), "configs/admins_simple.ini");
	FormatEx(szFileCopyPath, sizeof(szFileCopyPath), "%s.copy", szFilePath);

	File fFile = OpenFile(szFilePath, "rt");
	File fTempFile = OpenFile(szFileCopyPath, "wt");

	bool bFound = false;

	while(!fFile.EndOfFile())
	{
		if(!fFile.ReadLine(szLine, sizeof(szLine)))
			continue;

		TrimString(szLine);

		if(StrContains(szLine, szAuth) == -1)
			fTempFile.WriteLine(szLine);
		else
			bFound = true;
	}

	delete fFile;
	delete fTempFile;

	DeleteFile(szFilePath);
	RenameFile(szFilePath, szFileCopyPath);

	if(bFound)
	{
		LogAction(0, -1, "System removed steamid %s from admins_simple.ini", szAuth);
		ReloadAdmins();
	}
	else
		LogAction(0, -1, "System tried to remove steamid %s from admins_simple.ini, but not found.", szAuth);

	return Plugin_Handled;
}

void ReloadAdmins()
{
	DumpAdminCache(AdminCache_Admins, true);
	LogAction(0, -1, "Cache has been refreshed from VIP system plugin.");
}