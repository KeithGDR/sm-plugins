#define PLUGIN_VERSION "1.0.0"

public void OnPluginStart()
{
	CreateConVar("sm_pluginnamehere_version", PLUGIN_VERSION, "Standard plugin version ConVar. Please don't change me!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	//RegConsoleCmd("sm_modes", modes);
	//RegConsoleCmd("sm_mode", modes);
	RegConsoleCmd("sm_mode", modes);
	RegConsoleCmd("sm_modes", modes);
	RegAdminCmd("sm_showmodes", Command_ShowModes, ADMFLAG_GENERIC);
}

public Action modes(int client, int args)
{
	ShowModes(client);
	return Plugin_Handled;
}

public Action Command_ShowModes(int client, int args)
{
	if (args < 1)
		return Plugin_Handled;
	
	char sTarget[MAX_TARGET_LENGTH];
	GetCmdArgString(sTarget, sizeof(sTarget));

	int target = FindTarget(client, sTarget, true, false);

	if (target < 1)
		return Plugin_Handled;
	
	ShowModes(target);
	return Plugin_Handled;
}

void ShowModes(int client)
{
	Menu menu = new Menu(Menu_Callback);
	menu.SetTitle("Rules by modes:");
	menu.AddItem("option0", "Jailbreak Rules");
	menu.AddItem("option1", "TTT Rules");
	menu.AddItem("option2", "Complete Rules");
	menu.ExitButton = true;
	menu.Display(client, 30);
}

public int Menu_Callback(Menu menu, MenuAction action, int client, int param)
{
	switch (action) 
	{
		case MenuAction_Select:
		{
			char item[32];
			menu.GetItem(param, item, sizeof(item));
			
			if (StrEqual(item, "option0"))
			{
				MenuRulesJail(client);
			}
			if (StrEqual(item, "option1"))
			{
				MenuRulesTTT(client);
			}
			if (StrEqual(item, "option2"))
			{
				PrintToChat(client, ">>>>x04[\x02LINK\x04] \x10https:LINK LINK");
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

void MenuRulesJail(int client)
{
	Panel panel = new Panel();

	panel.SetTitle("Basic Jailbreak Rules:");

	panel.DrawText("1. You must obey the captain at all times or you may rebel");
	panel.DrawText("2. You can use the !awards command to buy skills");
	panel.DrawText("3. In case you get killed wrongly type !fk to report it.");
	panel.DrawText("4. You can't date allies by microphone or chat");
	panel.DrawText(">>To read the complete rules enter the steam group<<");
	panel.DrawItem("- Accept");

	panel.Send(client, RulesHandler, MENU_TIME_FOREVER);
	delete panel;
}

void MenuRulesTTT(int client)
{
	Panel panel = new Panel();

	panel.SetTitle("Basic TTT Rules:");

	panel.DrawText("How to know if you are a traitor, innocent or detective?");
	panel.DrawText("1. If you are a TRAITOR you get a red T at the top right");
	panel.DrawText("2. If you are INNOCENT you get a green I at the top right");
	panel.DrawText("3. If you are DETECTIVE you get a blue D at the top right");
	panel.DrawText("4. The traitor must kill all those who do not have a red aura");
	panel.DrawText("5. The innocent must survive or help the detective find the traitor.");
	panel.DrawText("6. The detective must find the traitor and kill him before the traitor kills everyone.");
	panel.DrawItem("- Accept");

	panel.Send(client, RulesHandler, MENU_TIME_FOREVER);
	delete panel;
}

public int RulesHandler(Menu menu, MenuAction action, int p1, int p2)
{

}