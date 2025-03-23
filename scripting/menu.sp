#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public Plugin myinfo = {
	name = "[ANY] Menu",
	author = "KeithGDR",
	description = "It's a MENU.",
	version = "1.0.0",
	url = "https://KeithGDR.dev/"
};

public void OnPluginStart() {

}

void ShowStatistics(int client) {
	char buffer[128];

	Panel panel = new Panel();
	panel.SetTitle("Statistics");

	FormatEx(buffer, sizeof(buffer), "Zombies Killed: %i", GetEntProp(client, Prop_Send, "m_checkpointZombieKills"));
	panel.DrawText(buffer);

	panel.Send(client, MenuHandler_Stats, MENU_TIME_FOREVER);
	panel.Close();
}

public int MenuHandler_Stats(Menu menu, MenuAction action, int param1, int param2) {

}