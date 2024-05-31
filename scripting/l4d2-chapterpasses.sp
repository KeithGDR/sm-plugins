#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>

ConVar convar_Enabled;
ConVar convar_PartLength;
ConVar convar_Attempts;
ConVar convar_Time_Panic;
ConVar convar_Time_Kill;

char g_Password[32];
float g_Current;
int g_Attempts;
Handle g_KillTimer;

public Plugin myinfo = {
	name = "[L4D2] Chapter Passes",
	author = "Drixevel",
	description = "Requires passwords which are periodicially printed throughout a map and required input to open the saferoom door.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnPluginStart() {
	CreateConVar("sm_l4d2_chapterpasses_version", "1.0.0", "Version control for this plugin.", FCVAR_DONTRECORD);
	convar_Enabled = CreateConVar("sm_l4d2_chapterpasses_enabled", "1", "Should this plugin be enabled or disabled?", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	convar_PartLength = CreateConVar("sm_l4d2_chapterpasses_part_length", "3", "How many letters or numbers should be generated per password part?", FCVAR_NOTIFY, true, 1.0);
	convar_Attempts = CreateConVar("sm_l4d2_chapterpasses_attempts", "3", "How many attempts do survivors have to open the saferoom door via password?", FCVAR_NOTIFY, true, 1.0);
	convar_Time_Panic = CreateConVar("sm_l4d2_chapterpasses_time_panic", "20", "How many seconds should the panic event be active if they fail the password check?", FCVAR_NOTIFY, true, 1.0);
	convar_Time_Kill = CreateConVar("sm_l4d2_chapterpasses_time_kill", "20", "How many seconds should the kill event happen after the panic event where survivors have to be in the safe room or they die?", FCVAR_NOTIFY, true, 1.0);
	AutoExecConfig();

	CreateTimer(1.0, Timer_Tick, _, TIMER_REPEAT);
	HookEvent("player_left_start_area", Event_RoundStart);
}

public void OnMapEnd() {
	g_Password[0] = '\0';
	g_Current = 0.0;
	g_Attempts = 0;
	g_KillTimer = null;
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	if (!convar_Enabled.BoolValue) {
		return;
	}

	SetSaferoomDoor(true);
}

public Action Timer_Tick(Handle timer) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	float flow = L4D2_GetFurthestSurvivorFlow();
	float max = L4D2Direct_GetMapMaxFlowDistance();

	//Flow: 5000.0/20000.0
	//PrintHintTextToAll("Flow: %.2f/%.2f", flow, max);

	if (flow >= max * 0.25 && g_Current < 0.25) {
		AppendPassword(1);
		g_Current = 0.25;
		//PrintToChatAll("25% Flow Reached");
	} else if (flow >= max * 0.50 && g_Current < 0.50) {
		AppendPassword(2);
		g_Current = 0.50;
		//PrintToChatAll("50% Flow Reached");
	} else if (flow >= max * 0.75 && g_Current < 0.75) {
		AppendPassword(3);
		g_Current = 0.75;
		//PrintToChatAll("75% Flow Reached");
	} else if (flow >= max * 0.98 && g_Current < 1.00) { //0.98 so that they have to input it right before the saferoom instead of at it.
		AppendPassword(4);
		g_Current = 1.00;
		//PrintToChatAll("100% Flow Reached");
	}

	return Plugin_Continue;
}

void AppendPassword(int step) {
	char password[64];
	int character;

	for (int i = 0; i < convar_PartLength.IntValue; i++) {
		// Generate a random ASCII value for a-z (97-122) or 0-9 (48-57)
		if (GetRandomInt(0, 1) == 0) {
			character = GetRandomInt(97, 122); // a-z
		} else {
			character = GetRandomInt(48, 57); // 0-9
		}

		// Append the character to the password
		Format(password, sizeof(password), "%s%c", password, character);
	}

	PrintToChatAll("Password [Part %i]: %s", step, password);
	StrCat(g_Password, sizeof(g_Password), password);
}

public void OnClientSayCommand_Post(int client, const char[] command, const char[] sArgs) {
	if (!convar_Enabled.BoolValue) {
		return;
	}

	if (g_Current != 1.0) {
		return;
	}

	char sCommand[64];
	strcopy(sCommand, sizeof(sCommand), sArgs);
	ReplaceString(sCommand, sizeof(sCommand), "!", "");

	if (StrEqual(sCommand, g_Password)) {
		if (g_Attempts >= convar_Attempts.IntValue) {
			PrintToChat(client, "You have no more attempts remaining.");
			return;
		}

		PrintToChat(client, "Correct Password!");
		SetSaferoomDoor(false);
	} else {
		PrintToChat(client, "Incorrect Password!");
		g_Attempts++;

		if (g_Attempts < convar_Attempts.IntValue) {
			PrintToChat(client, "You have %i attempts remaining.", convar_Attempts.IntValue - g_Attempts);
		} else {
			PrintToChat(client, "You have no more attempts remaining.");

			if (g_KillTimer == null) {
				L4D_ForcePanicEvent();
				PrintToChat(client, "The door will open in %.0f seconds.", convar_Time_Panic.FloatValue);
				g_KillTimer = CreateTimer(convar_Time_Panic.FloatValue, Timer_OpenDoor, _, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

public Action Timer_OpenDoor(Handle timer) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	SetSaferoomDoor(false);

	PrintToChatAll("Survivors have been given %.0f seconds to get into the saferoom or they die.", convar_Time_Kill.FloatValue);
	g_KillTimer = CreateTimer(convar_Time_Kill.FloatValue, Timer_KillSurvivors, _, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}

public Action Timer_KillSurvivors(Handle timer) {
	if (!convar_Enabled.BoolValue) {
		return Plugin_Continue;
	}

	for (int i = 1; i <= MaxClients; i++) {
		if (!IsClientConnected(i) || !IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2) {
			continue;
		}

		if (!L4D_IsInLastCheckpoint(i)) {
			ForcePlayerSuicide(i);
		}
	}

	SetSaferoomDoor(true);

	return Plugin_Continue;
}

void SetSaferoomDoor(bool state) {
	int door = L4D_GetCheckpointLast();

	if (!IsValidEntity(door)) {
		return;
	}

	if (state) {
		AcceptEntityInput(door, "Close");
		AcceptEntityInput(door, "ForceClosed");
		AcceptEntityInput(door, "Lock");
		SetEntProp(door, Prop_Data, "m_hasUnlockSequence", 1);
		PrintToChatAll("Saferoom door has been closed and locked.");
	} else {
		SetEntProp(door, Prop_Data, "m_hasUnlockSequence", 0);
		AcceptEntityInput(door, "Unlock");
		AcceptEntityInput(door, "ForceClosed");
		AcceptEntityInput(door, "Open");
		PrintToChatAll("Saferoom door has been unlocked.");
	}
}

stock bool StopTimer(Handle& timer) {
	if (timer != null) {
		KillTimer(timer);
		timer = null;
		return true;
	}
	
	return false;
}