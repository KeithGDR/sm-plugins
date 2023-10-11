#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <vsh2>
#include <MoreColors>

public Plugin myinfo = {
	name = "[VSH2] Backstab Message",
	author = "Drixevel",
	description = "Shows a message when a spy backstabs a boss.",
	version = "1.0.0",
	url = "https://drixevel.dev/"
};

public void OnLibraryAdded(const char[] name) {
	if (StrEqual(name, "VSH2")) {
		if (!VSH2_HookEx(OnBossTakeDamage_OnStabbed, OnBossStabbed)) {
			LogError("Error Hooking OnBossTakeDamage_OnStabbed forward.");
		}
	}
}

public Action OnBossStabbed(VSH2Player victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom) {
	CPrintToChatAll("{olive}[VSH2] {green}%N {default}Just {red}BACKSTABBED {green}%N{default}!", attacker, victim.index);
	return Plugin_Continue;
}