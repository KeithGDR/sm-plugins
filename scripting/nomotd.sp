#pragma semicolon 1
#define PLUGIN_VERSION  "1.0"

public Plugin:myinfo = {
	name = "No MOTD",
	author = "MasterOfTheXP",
	description = "Removes the initial MOTD shown upon joining.",
	version = PLUGIN_VERSION,
	url = "http://mstr.ca/"
};

public OnPluginStart()
{
	HookUserMessage(GetUserMessageId("VGUIMenu"), VGUIMenu, true);
}

public Action:VGUIMenu(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
	new String:buffer[5];
	BfReadString(bf, buffer, sizeof(buffer));

	if(StrEqual(buffer, "info"))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public OnClientPutInServer(client)
{
	CreateTimer(0.2, timer_menu, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action:timer_menu(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);

	if(client != 0 && !IsFakeClient(client))
	{
		ShowVGUIPanel(client, "team", INVALID_HANDLE, true);
	}
}