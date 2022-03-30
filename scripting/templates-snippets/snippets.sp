void OpenNewMenu(int client)
{
	//Initialize a menu and set its title.
	Menu menu = new Menu(MenuHandler_Menu);
	menu.SetTitle("Menu Title:");
	
	//Add items to the menu.
	menu.AddItem("", "Item");
	
	//Display the menu to the client and/or add a back button.
	//menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Menu(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		//Called whenever a menu item is selected.
		case MenuAction_Select:
		{
			char sInfo[32];
			menu.GetItem(param2, sInfo, sizeof(sInfo));
			
			
		}
		
		//Called whenever the menu is being closed for a specific reason.
		//case MenuAction_Cancel:
		//{
		//	if (param2 == MenuCancel_ExitBack)
		//	{
		//
		//	}
		//}
		
		//Called whenever the menu is actually closed.
		case MenuAction_End:
			delete menu;
	}
}