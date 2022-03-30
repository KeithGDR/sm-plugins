/*
	- Legacy Compile Data
	version = 5,
	filevers = "1.8.0.5845",
	date = "06/18/2016",
	time = "00:01:09"
*/

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <adminmenu>
#include <clientprefs>
#include <cstrike>

/*public SharedPlugin:__pl_HoE_store =
{
	name = "HoE-store",
	file = "HoE-store.smx",
	required = 1,
};
public SharedPlugin:__pl_HoE_tags_admin =
{
	name = "HoE-tags-admin",
	file = "HoE-tags-admin.smx",
	required = 0,
};*/

public Plugin myinfo =
{
	name = "Store",
	description = "A store system for Source.",
	author = "Keith Warren (Drixevel) | Hell on Earth Team",
	version = "1.0.0",
	url = "http://www.drixevel.com/"
};

new g_vard8c;
new g_vard88;
new g_var1130;
new g_var1134;
new g_var1240;
new g_vareec;
new g_varee8;
new g_var1244 = -1;
new g_Game;
new g_Late;
new g_var3608;
new g_vara48c;
Handle g_LookupAttachment;
ArrayList g_WeaponEntities;
ArrayList g_WeaponNames;
ArrayList g_Projectiles;
StringMap g_ProjectileNames;
new g_vara7ac;
new g_vara7b0;
new g_vara7b4;
new g_vara7b8;
new g_vara7bc;
new g_vara7c0;
new g_vara7c4;
new g_vara7c8;
new g_vara7cc;
new g_vara7d0;
new g_vara7d4;
new g_vara7d8;
new g_vara7dc;
new g_vara7e0;
new g_vara7e4;
new g_vara7e8;
new g_vara7ec;
new g_vara7f0;
new g_vara7f4;
new g_vara7f8;
new g_vara7fc;
new g_vara800;
new g_vara804;
new g_vara808;
new g_vara7a8;
new g_var307c;
new g_var3080;
new g_var3084;
new g_var3088;
new g_var308c;
new g_var3190;
new g_var3194;
new g_var3198;
new g_var319c;
new g_var31a0;
new g_var31a4;
new g_var31a8;
new g_var31cc;
new g_var31e0;
new g_var31e4;
new g_var31d4;
new g_var31d0;
new g_var31dc;
new g_var31d8;
new g_var31e8;
new g_var31ec;
new g_var31f0;
new g_var31f4;
new g_var31f8;
new g_var31fc;
new g_var3200;
new g_var3204;
new g_var3208;
new g_var320c;
new g_var3210;
new g_var3214;
new g_var3218;
new g_var321c;
new g_var3220;
new g_var3224;
new g_var3228;
new g_var322c;
new g_var3230;
new g_var3234;
new g_var3238;
new g_var325c;
new g_var3260;
new g_var3264;
new g_var3268;
new g_var326c;
new g_var3270;
new g_var3274;
new g_var3378;
new g_var347c;
new g_var35e0;
new g_var3610;
new g_var35e4;
new g_var35f0;
new g_var35f4;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingTag");
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingName");
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingChat");
	
	g_Game = GetEngineVersion() == Engine_CSS;
	
	CreateNative("HoE_Store_GetClientCredits", Native_GetClientCredits);
	CreateNative("HoE_Store_AddClientCredits", Native_AddClientCredits);
	CreateNative("HoE_Store_RemoveClientCredits", Native_RemoveClientCredits);
	CreateNative("HoE_Store_TagEquipped", Native_TagEquipped);
	CreateNative("HoE_Store_NameEquipped", Native_NameEquipped);
	CreateNative("HoE_Store_ChatEquipped", Native_ChatEquipped);
	
	RegPluginLibrary("HoE-store");
	
	g_Late = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	g_var3608 = LibraryExists("HoE-tags-admin");
	
	LoadTranslations("common.phrases");
	
	/*new var1;
	if (g_Game)
	{
		var1[0] = 43448;
	}
	else
	{
		var1[0] = 43472;
	}
	
	LoadTranslations(var1);*/
	
	12176/* ERROR unknown load Constant */ = CreateConVar("sm_store_status", "1", "Status of the plugin.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 4/* ERROR unknown load Binary */ = CreateConVar("sm_store_credits", "1", "Amount of credits to give clients.", 256, true, 0.0, false, 0.0);
	12176 + 8/* ERROR unknown load Binary */ = CreateConVar("sm_store_credits_hs", "2", "Amount of credits to give a client who get a headshot.", 256, true, 0.0, false, 0.0);
	12176 + 12/* ERROR unknown load Binary */ = CreateConVar("sm_store_credits_kill", "1", "Amount of credits to give a client who gets a kill.", 256, true, 0.0, false, 0.0);
	12176 + 16/* ERROR unknown load Binary */ = CreateConVar("sm_store_credits_knife", "3", "Amount of credits to give a client who gets a knife kill.", 256, true, 0.0, false, 0.0);
	12176 + 20/* ERROR unknown load Binary */ = CreateConVar("sm_store_database", "store", "Name of the database config entry to use.", 256, false, 0.0, false, 0.0);
	12176 + 24/* ERROR unknown load Binary */ = CreateConVar("sm_store_default_credits", "1000", "Default amount of credits to give clients who connect for the first time.", 256, true, 0.0, false, 0.0);
	12176 + 28/* ERROR unknown load Binary */ = CreateConVar("sm_store_respawn_delay", "15", "Delay to give clients who purchase a respawn.", 256, true, 1.0, false, 0.0);
	12176 + 32/* ERROR unknown load Binary */ = CreateConVar("sm_store_respawn_max", "3", "Maximum amount of respawns to give clients per round.", 256, true, 1.0, false, 0.0);
	12176 + 36/* ERROR unknown load Binary */ = CreateConVar("sm_store_respawn_cost", "500", "Amount of credits to purchase a respawn.", 256, true, 1.0, false, 0.0);
	12176 + 40/* ERROR unknown load Binary */ = CreateConVar("sm_store_purge", "120", "Amount of days to purge clients who haven't connected.", 256, true, 0.0, false, 0.0);
	12176 + 44/* ERROR unknown load Binary */ = CreateConVar("sm_store_refund", "1", "Status of the refunding functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 48/* ERROR unknown load Binary */ = CreateConVar("sm_store_gifting", "1", "Status of the gifting functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 52/* ERROR unknown load Binary */ = CreateConVar("sm_store_admin_access_flag", "z", "Required flags for admins to have in order to access the admin menu.", 256, false, 0.0, false, 0.0);
	12176 + 56/* ERROR unknown load Binary */ = CreateConVar("sm_store_autopistol_cost", "3500", "Amount of credits to purchase auto pistols.", 256, true, 1.0, false, 0.0);
	12176 + 60/* ERROR unknown load Binary */ = CreateConVar("sm_store_autopistol_expiry", "45", "Amount of days until auto pistols would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 64/* ERROR unknown load Binary */ = CreateConVar("sm_store_autopistol_enable", "1", "Status of the auto pistols functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 68/* ERROR unknown load Binary */ = CreateConVar("sm_store_chat_color_cost", "15000", "Amount of credits to purchase chat colors.", 256, true, 1.0, false, 0.0);
	12176 + 72/* ERROR unknown load Binary */ = CreateConVar("sm_store_chat_color_expiry", "0", "Amount of days until chat colors would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 76/* ERROR unknown load Binary */ = CreateConVar("sm_store_name_color_cost", "20000", "Amount of credits to purchase name colors.", 256, true, 1.0, false, 0.0);
	12176 + 80/* ERROR unknown load Binary */ = CreateConVar("sm_store_name_color_expiry", "0", "Amount of days until name colors would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 84/* ERROR unknown load Binary */ = CreateConVar("sm_store_grenade_trail_cost", "3500", "Amount of credits to purchase trails.", 256, true, 1.0, false, 0.0);
	12176 + 88/* ERROR unknown load Binary */ = CreateConVar("sm_store_grenade_trail_expiry", "0", "Amount of days until trails would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 92/* ERROR unknown load Binary */ = CreateConVar("sm_store_weapon_color_cost", "3500", "Amount of credits to purchase weapon colors.", 256, true, 1.0, false, 0.0);
	12176 + 96/* ERROR unknown load Binary */ = CreateConVar("sm_store_weapon_color_expiry", "0", "Amount of days until weapon colors would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 100/* ERROR unknown load Binary */ = CreateConVar("sm_store_tracers_cost", "3500", "Amount of credits to purchase tracers.", 256, true, 1.0, false, 0.0);
	12176 + 104/* ERROR unknown load Binary */ = CreateConVar("sm_store_tracers_expiry", "0", "Amount of days until tracers would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 108/* ERROR unknown load Binary */ = CreateConVar("sm_store_refund_percentage", "0.65", "Percentage of credits to take out of items that are refunded.", 256, true, 0.0, false, 0.0);
	12176 + 112/* ERROR unknown load Binary */ = CreateConVar("sm_store_gifting_cooldown", "10", "Amount of time in order to ", 256, true, 0.0, false, 0.0);
	12176 + 116/* ERROR unknown load Binary */ = CreateConVar("sm_store_lasersights_cost", "3500", "Amount of credits to purchase laser sights.", 256, true, 1.0, false, 0.0);
	12176 + 120/* ERROR unknown load Binary */ = CreateConVar("sm_store_lasersights_expiry", "0", "Amount of days until laser sights would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 124/* ERROR unknown load Binary */ = CreateConVar("sm_store_customtags_cost", "30000", "Amount of credits to purchase custom tags.", 256, true, 1.0, false, 0.0);
	12176 + 128/* ERROR unknown load Binary */ = CreateConVar("sm_store_customtags_expiry", "0", "Amount of days until custom tags would expire after purchase.", 256, true, 0.0, false, 0.0);
	12176 + 132/* ERROR unknown load Binary */ = CreateConVar("sm_store_distribution_message", "1", "Status for the message to give clients when they receive credits automatically.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 136/* ERROR unknown load Binary */ = CreateConVar("sm_store_weapon_color_enable", "1", "Status of the weapon colors functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 140/* ERROR unknown load Binary */ = CreateConVar("sm_store_chat_color_enable", "1", "Status of the chat colors functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 144/* ERROR unknown load Binary */ = CreateConVar("sm_store_name_color_enable", "1", "Status of the name colors functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 148/* ERROR unknown load Binary */ = CreateConVar("sm_store_grenade_trail_enable", "1", "Status of the grenade trails functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 152/* ERROR unknown load Binary */ = CreateConVar("sm_store_tracers_enable", "1", "Status of the tracers functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 156/* ERROR unknown load Binary */ = CreateConVar("sm_store_lasersights_enable", "1", "Status of the laser sights functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 160/* ERROR unknown load Binary */ = CreateConVar("sm_store_custom_tags_enable", "1", "Status of the custom tags functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 164/* ERROR unknown load Binary */ = CreateConVar("sm_store_grenade_model_enable", "1", "Status of the grenade models functionality.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 168/* ERROR unknown load Binary */ = CreateConVar("sm_store_color_codes", "b", "Flags to allow players to use color codes in chat.", 256, false, 0.0, false, 0.0);
	12176 + 172/* ERROR unknown load Binary */ = CreateConVar("sm_store_trim_tags", "1", "Status of trimming tags down so names are fully displayed: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 176/* ERROR unknown load Binary */ = CreateConVar("sm_store_migrations_status", "1", "Status of player data migrations: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 180/* ERROR unknown load Binary */ = CreateConVar("sm_store_respawns", "1", "Status of the respawns functionality: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 184/* ERROR unknown load Binary */ = CreateConVar("sm_store_hats_enable", "1", "Status of the hats functionality: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 188/* ERROR unknown load Binary */ = CreateConVar("sm_store_trails_enable", "1", "Status of the trails functionality: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 192/* ERROR unknown load Binary */ = CreateConVar("sm_store_playermodels_enable", "1", "Status of the player models functionality: (1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 196/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_admin_logs", "1", "Status of the admin transaction logging.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 200/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_admin_logs_filename", "logs/store.admin.transactions.log", "Filename to use for admin transaction logs.", 256, false, 0.0, false, 0.0);
	12176 + 204/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_refunds_logs", "1", "Status of the refunds transaction logging.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 208/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_refunds_logs_filename", "logs/store.refunds.transactions.log", "Filename to use for refunds transaction logs.", 256, false, 0.0, false, 0.0);
	12176 + 212/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_gifting_logs", "1", "Status of the gifting transaction logging.\n(1 = on, 0 = off)", 256, true, 0.0, true, 1.0);
	12176 + 216/* ERROR unknown load Binary */ = CreateConVar("sm_store_transaction_gifting_logs_filename", "logs/store.gifting.transactions.log", "Filename to use for giftingtransaction logs.", 256, false, 0.0, false, 0.0);
	12176 + 220/* ERROR unknown load Binary */ = CreateConVar("sm_store_resetplayer_flags", "b", "Flags to allow admins to reset players.", 256, false, 0.0, false, 0.0);
	12176 + 224/* ERROR unknown load Binary */ = CreateConVar("sm_store_deleteitem_flags", "b", "Flags to allow admins to delete certain items.", 256, false, 0.0, false, 0.0);
	12176 + 228/* ERROR unknown load Binary */ = CreateConVar("sm_store_resetitems", "b", "Flags to allow admins to reset player items.", 256, false, 0.0, false, 0.0);
	12176 + 232/* ERROR unknown load Binary */ = CreateConVar("sm_store_migration_credits", "1", "Status of the credits migration.", 256, true, 0.0, true, 1.0);
	
	new i;
	while (i < 59)
	{
		HookConVarChange(12176[i], OnConVarsChanged);
		i++;
	}
	
	RegConsoleCmd("sm_store", OnOpenStoreMenu, "Open store menu.", 0);
	RegConsoleCmd("sm_givecredits", OnGiveCredits, "Give clients credits.", 0);
	RegConsoleCmd("sm_removecredits", OnRemoveCredits, "Remove clients credits.", 0);
	RegConsoleCmd("sm_resetcredits", OnResetCredits, "Reset clients credits.", 0);
	RegConsoleCmd("sm_resetplayer", OnResetPlayer, "Reset a clients store data.", 0);
	RegConsoleCmd("sm_deleteitem", OnDeleteItem, "Delete an item on a client.", 0);
	RegConsoleCmd("sm_resetitems", OnResetItems, "Reset a players items.", 0);
	RegConsoleCmd("sm_vh", ToggleTransmit, "", 0);
	RegConsoleCmd("sm_viewhat", ToggleTransmit, "", 0);
	
	HookEvent("player_spawn", OnPlayerSpawn, EventHookMode:1);
	HookEvent("player_death", OnPlayerDeath, EventHookMode:1);
	HookEvent("round_start", OnRoundStart, EventHookMode:1);
	HookEvent("round_end", OnRoundEnd, EventHookMode:1);
	HookEvent("bullet_impact", OnBulletImpact, EventHookMode:1);
	
	CreateTimer(60.0, GiveCreditsToAll, _, TIMER_REPEAT);
	
	g_vara48c = RegClientCookie("AutoPistols", "Enable/Disable auto pistols.", CookieAccess:2);
	
	if (!g_Game)
	{
		GameData conf = new GameData("store.gamedata");
		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetFromConf(conf, SDKConf_Signature, "LookupAttachment");
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain, 0, 0);
		PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer, 0, 0);
		g_LookupAttachment = EndPrepSDKCall();
		delete conf;
		
		if (g_LookupAttachment == null)
			LogError("LookupAttachment signature is outdated or this mod doesn't support hats.");
	}
	
	g_WeaponEntities = new ArrayList(1, 0);
	g_WeaponEntities.PushString("weapon_cz75a");
	g_WeaponEntities.PushString("weapon_deagle");
	g_WeaponEntities.PushString("weapon_elite");
	g_WeaponEntities.PushString("weapon_fiveseven");
	g_WeaponEntities.PushString("weapon_glock");
	g_WeaponEntities.PushString("weapon_p228");
	g_WeaponEntities.PushString("weapon_p250");
	g_WeaponEntities.PushString("weapon_hkp2000");
	g_WeaponEntities.PushString("weapon_revolver");
	g_WeaponEntities.PushString("weapon_tec9");
	g_WeaponEntities.PushString("weapon_usp");
	g_WeaponEntities.PushString("weapon_usp_silencer");
	
	g_WeaponNames = new ArrayList(1, 0);
	g_WeaponNames.PushString("awp");
	g_WeaponNames.PushString("scout");
	g_WeaponNames.PushString("sg550");
	g_WeaponNames.PushString("sg552");
	g_WeaponNames.PushString("sg556");
	g_WeaponNames.PushString("g3sg1");
	g_WeaponNames.PushString("aug");
	g_WeaponNames.PushString("scar17");
	g_WeaponNames.PushString("scar20");
	g_WeaponNames.PushString("ssg08");
	g_WeaponNames.PushString("spring");
	g_WeaponNames.PushString("k98s");
	
	g_Projectiles = new ArrayList(ByteCountToCells(256), 0);
	g_Projectiles.PushString("flashbang_projectile");
	g_Projectiles.PushString("hegrenade_projectile");
	g_Projectiles.PushString("smokegrenade_projectile");
	
	g_ProjectileNames = new StringMap();
	g_ProjectileNames.SetString("flashbang_projectile", "Flashbangs", true);
	g_ProjectileNames.SetString("hegrenade_projectile", "High Explosive Grenades", true);
	g_ProjectileNames.SetString("smokegrenade_projectile", "Smoke Grenades", true);
	
	if (g_Game)
	{
		g_Projectiles.PushString("molotov_projectile");
		g_Projectiles.PushString("decoy_projectile");
		g_Projectiles.PushString("incgrenade_projectile");
		g_ProjectileNames.SetString("molotov_projectile", "Molotovs", true);
		g_ProjectileNames.SetString("decoy_projectile", "Decoy Grenades", true);
		g_ProjectileNames.SetString("incgrenade_projectile", "Incendiary Grenades", true);
	}
	
	g_vara7ac = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7b0 = CreateTrie();
	g_vara7b4 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7b8 = CreateTrie();
	g_vara7bc = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7c0 = CreateTrie();
	g_vara7c4 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7c8 = CreateTrie();
	g_vara7cc = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7d0 = CreateTrie();
	g_vara7d4 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7d8 = CreateTrie();
	g_vara7dc = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7e0 = CreateTrie();
	g_vara7e4 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7e8 = CreateTrie();
	g_vara7ec = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7f0 = CreateTrie();
	g_vara7f4 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara7f8 = CreateTrie();
	g_vara7fc = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara800 = CreateTrie();
	g_vara804 = CreateArray(.4968.ByteCountToCells(1024), 0);
	g_vara808 = CreateTrie();
	g_vara7a8 = CreateTrie();
	
	AutoExecConfig(true, "", "sourcemod");
}

public OnConVarsChanged(Handle:convar, String:oldValue[], String:newValue[])
{
	if (.3076.StrEqual(oldValue, newValue, true))
	{
		return 0;
	}
	new value = StringToInt(newValue, 10);
	new Float:fValue = StringToFloat(newValue);
	new bool:bValue = value;
	if (12176/* ERROR unknown load Constant */ == convar)
	{
		g_var307c = bValue;
	}
	else
	{
		if (12176 + 4/* ERROR unknown load Binary */ == convar)
		{
			g_var3080 = value;
		}
		if (12176 + 8/* ERROR unknown load Binary */ == convar)
		{
			g_var3084 = value;
		}
		if (12176 + 12/* ERROR unknown load Binary */ == convar)
		{
			g_var3088 = value;
		}
		if (12176 + 16/* ERROR unknown load Binary */ == convar)
		{
			g_var308c = value;
		}
		if (12176 + 20/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 256, newValue);
		}
		if (12176 + 24/* ERROR unknown load Binary */ == convar)
		{
			g_var3190 = value;
		}
		if (12176 + 28/* ERROR unknown load Binary */ == convar)
		{
			g_var3194 = fValue;
		}
		if (12176 + 32/* ERROR unknown load Binary */ == convar)
		{
			g_var3198 = value;
		}
		if (12176 + 36/* ERROR unknown load Binary */ == convar)
		{
			g_var319c = value;
		}
		if (12176 + 40/* ERROR unknown load Binary */ == convar)
		{
			g_var31a0 = value;
		}
		if (12176 + 44/* ERROR unknown load Binary */ == convar)
		{
			g_var31a4 = bValue;
		}
		if (12176 + 48/* ERROR unknown load Binary */ == convar)
		{
			g_var31a8 = bValue;
		}
		if (12176 + 52/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 32, newValue);
		}
		if (12176 + 56/* ERROR unknown load Binary */ == convar)
		{
			g_var31cc = value;
		}
		if (12176 + 60/* ERROR unknown load Binary */ == convar)
		{
			g_var31e0 = value;
		}
		if (12176 + 64/* ERROR unknown load Binary */ == convar)
		{
			g_var31e4 = bValue;
		}
		if (12176 + 68/* ERROR unknown load Binary */ == convar)
		{
			g_var31d4 = value;
		}
		if (12176 + 72/* ERROR unknown load Binary */ == convar)
		{
			g_var31d0 = value;
		}
		if (12176 + 76/* ERROR unknown load Binary */ == convar)
		{
			g_var31dc = value;
		}
		if (12176 + 80/* ERROR unknown load Binary */ == convar)
		{
			g_var31d8 = value;
		}
		if (12176 + 84/* ERROR unknown load Binary */ == convar)
		{
			g_var31e8 = value;
		}
		if (12176 + 88/* ERROR unknown load Binary */ == convar)
		{
			g_var31ec = value;
		}
		if (12176 + 92/* ERROR unknown load Binary */ == convar)
		{
			g_var31f0 = value;
		}
		if (12176 + 96/* ERROR unknown load Binary */ == convar)
		{
			g_var31f4 = value;
		}
		if (12176 + 100/* ERROR unknown load Binary */ == convar)
		{
			g_var31f8 = value;
		}
		if (12176 + 104/* ERROR unknown load Binary */ == convar)
		{
			g_var31fc = value;
		}
		if (12176 + 108/* ERROR unknown load Binary */ == convar)
		{
			g_var3200 = fValue;
		}
		if (12176 + 112/* ERROR unknown load Binary */ == convar)
		{
			g_var3204 = value;
		}
		if (12176 + 116/* ERROR unknown load Binary */ == convar)
		{
			g_var3208 = value;
		}
		if (12176 + 120/* ERROR unknown load Binary */ == convar)
		{
			g_var320c = value;
		}
		if (12176 + 124/* ERROR unknown load Binary */ == convar)
		{
			g_var3210 = value;
		}
		if (12176 + 128/* ERROR unknown load Binary */ == convar)
		{
			g_var3214 = value;
		}
		if (12176 + 132/* ERROR unknown load Binary */ == convar)
		{
			g_var3218 = bValue;
		}
		if (12176 + 136/* ERROR unknown load Binary */ == convar)
		{
			g_var321c = bValue;
		}
		if (12176 + 140/* ERROR unknown load Binary */ == convar)
		{
			g_var3220 = bValue;
		}
		if (12176 + 144/* ERROR unknown load Binary */ == convar)
		{
			g_var3224 = bValue;
		}
		if (12176 + 148/* ERROR unknown load Binary */ == convar)
		{
			g_var3228 = bValue;
		}
		if (12176 + 152/* ERROR unknown load Binary */ == convar)
		{
			g_var322c = bValue;
		}
		if (12176 + 156/* ERROR unknown load Binary */ == convar)
		{
			g_var3230 = bValue;
		}
		if (12176 + 160/* ERROR unknown load Binary */ == convar)
		{
			g_var3234 = bValue;
		}
		if (12176 + 164/* ERROR unknown load Binary */ == convar)
		{
			g_var3238 = bValue;
		}
		if (12176 + 168/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 32, newValue);
		}
		if (12176 + 172/* ERROR unknown load Binary */ == convar)
		{
			g_var325c = bValue;
		}
		if (12176 + 176/* ERROR unknown load Binary */ == convar)
		{
			g_var3260 = bValue;
		}
		if (12176 + 180/* ERROR unknown load Binary */ == convar)
		{
			g_var3264 = bValue;
		}
		if (12176 + 184/* ERROR unknown load Binary */ == convar)
		{
			g_var3268 = bValue;
		}
		if (12176 + 188/* ERROR unknown load Binary */ == convar)
		{
			g_var326c = bValue;
		}
		if (12176 + 192/* ERROR unknown load Binary */ == convar)
		{
			g_var3270 = bValue;
		}
		if (12176 + 196/* ERROR unknown load Binary */ == convar)
		{
			g_var3274 = bValue;
		}
		if (12176 + 200/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 256, newValue);
		}
		if (12176 + 204/* ERROR unknown load Binary */ == convar)
		{
			g_var3378 = bValue;
		}
		if (12176 + 208/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 256, newValue);
		}
		if (12176 + 212/* ERROR unknown load Binary */ == convar)
		{
			g_var347c = bValue;
		}
		if (12176 + 216/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 256, newValue);
		}
		if (12176 + 220/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 32, newValue);
		}
		if (12176 + 224/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 32, newValue);
		}
		if (12176 + 228/* ERROR unknown load Binary */ == convar)
		{
			strcopy("", 32, newValue);
		}
		if (12176 + 232/* ERROR unknown load Binary */ == convar)
		{
			g_var35e0 = bValue;
		}
	}
	return 0;
}

public OnConfigsExecuted()
{
	g_var307c = GetConVarBool(12176/* ERROR unknown load Constant */);
	g_var3080 = GetConVarInt(12176 + 4/* ERROR unknown load Binary */);
	g_var3084 = GetConVarInt(12176 + 8/* ERROR unknown load Binary */);
	g_var3088 = GetConVarInt(12176 + 12/* ERROR unknown load Binary */);
	g_var308c = GetConVarInt(12176 + 16/* ERROR unknown load Binary */);
	GetConVarString(12176 + 20/* ERROR unknown load Binary */, "", 256);
	g_var3190 = GetConVarInt(12176 + 24/* ERROR unknown load Binary */);
	g_var3194 = GetConVarFloat(12176 + 28/* ERROR unknown load Binary */);
	g_var3198 = GetConVarInt(12176 + 32/* ERROR unknown load Binary */);
	g_var319c = GetConVarInt(12176 + 36/* ERROR unknown load Binary */);
	g_var31a0 = GetConVarInt(12176 + 40/* ERROR unknown load Binary */);
	g_var31a4 = GetConVarBool(12176 + 44/* ERROR unknown load Binary */);
	g_var31a8 = GetConVarBool(12176 + 48/* ERROR unknown load Binary */);
	GetConVarString(12176 + 52/* ERROR unknown load Binary */, "", 32);
	g_var31cc = GetConVarInt(12176 + 56/* ERROR unknown load Binary */);
	g_var31e0 = GetConVarInt(12176 + 60/* ERROR unknown load Binary */);
	g_var31e4 = GetConVarBool(12176 + 64/* ERROR unknown load Binary */);
	g_var31d4 = GetConVarInt(12176 + 68/* ERROR unknown load Binary */);
	g_var31d0 = GetConVarInt(12176 + 72/* ERROR unknown load Binary */);
	g_var31dc = GetConVarInt(12176 + 76/* ERROR unknown load Binary */);
	g_var31d8 = GetConVarInt(12176 + 80/* ERROR unknown load Binary */);
	g_var31e8 = GetConVarInt(12176 + 84/* ERROR unknown load Binary */);
	g_var31ec = GetConVarInt(12176 + 88/* ERROR unknown load Binary */);
	g_var31f0 = GetConVarInt(12176 + 92/* ERROR unknown load Binary */);
	g_var31f4 = GetConVarInt(12176 + 96/* ERROR unknown load Binary */);
	g_var31f8 = GetConVarInt(12176 + 100/* ERROR unknown load Binary */);
	g_var31fc = GetConVarInt(12176 + 104/* ERROR unknown load Binary */);
	g_var3200 = GetConVarFloat(12176 + 108/* ERROR unknown load Binary */);
	g_var3204 = GetConVarInt(12176 + 112/* ERROR unknown load Binary */);
	g_var3208 = GetConVarInt(12176 + 116/* ERROR unknown load Binary */);
	g_var320c = GetConVarInt(12176 + 120/* ERROR unknown load Binary */);
	g_var3210 = GetConVarInt(12176 + 124/* ERROR unknown load Binary */);
	g_var3214 = GetConVarInt(12176 + 128/* ERROR unknown load Binary */);
	g_var3218 = GetConVarBool(12176 + 132/* ERROR unknown load Binary */);
	g_var321c = GetConVarBool(12176 + 136/* ERROR unknown load Binary */);
	g_var3220 = GetConVarBool(12176 + 140/* ERROR unknown load Binary */);
	g_var3224 = GetConVarBool(12176 + 144/* ERROR unknown load Binary */);
	g_var3228 = GetConVarBool(12176 + 148/* ERROR unknown load Binary */);
	g_var322c = GetConVarBool(12176 + 152/* ERROR unknown load Binary */);
	g_var3230 = GetConVarBool(12176 + 156/* ERROR unknown load Binary */);
	g_var3234 = GetConVarBool(12176 + 160/* ERROR unknown load Binary */);
	g_var3238 = GetConVarBool(12176 + 164/* ERROR unknown load Binary */);
	GetConVarString(12176 + 168/* ERROR unknown load Binary */, "", 32);
	g_var325c = GetConVarBool(12176 + 172/* ERROR unknown load Binary */);
	g_var3260 = GetConVarBool(12176 + 176/* ERROR unknown load Binary */);
	g_var3264 = GetConVarBool(12176 + 180/* ERROR unknown load Binary */);
	g_var3268 = GetConVarBool(12176 + 184/* ERROR unknown load Binary */);
	g_var326c = GetConVarBool(12176 + 188/* ERROR unknown load Binary */);
	g_var3270 = GetConVarBool(12176 + 192/* ERROR unknown load Binary */);
	g_var3274 = GetConVarBool(12176 + 196/* ERROR unknown load Binary */);
	GetConVarString(12176 + 200/* ERROR unknown load Binary */, "", 256);
	g_var3378 = GetConVarBool(12176 + 204/* ERROR unknown load Binary */);
	GetConVarString(12176 + 208/* ERROR unknown load Binary */, "", 256);
	g_var347c = GetConVarBool(12176 + 212/* ERROR unknown load Binary */);
	GetConVarString(12176 + 216/* ERROR unknown load Binary */, "", 256);
	GetConVarString(12176 + 220/* ERROR unknown load Binary */, "", 32);
	GetConVarString(12176 + 224/* ERROR unknown load Binary */, "", 32);
	GetConVarString(12176 + 228/* ERROR unknown load Binary */, "", 32);
	g_var35e0 = GetConVarBool(12176 + 232/* ERROR unknown load Binary */);
	if (g_var307c)
	{
		new var1;
		if (g_Game && !IsServerProcessing())
		{
			return 0;
		}
		g_var3610 = .59236.ParseItemsFile(false);
		if (g_var35e4)
		{
			if (0 < g_var31a0)
			{
				new purge = GetTime({0,0}) - g_var31a0 * 24 * 60 * 60;
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT id, name FROM `%s` WHERE last_join_date < %d;", "hellonearth_store_players", purge);
				SQL_TQuery(g_var35e4, TQuery_OnPurgePlayers, sQuery, any:0, DBPriority:1);
			}
		}
		SQL_TConnect(OnSQLConnect, "", any:0);
	}
	return 0;
}

public OnLibraryAdded(String:name[])
{
	if (.3076.StrEqual(name, "HoE-tags-admin", true))
	{
		g_var3608 = 1;
	}
	return 0;
}

public OnLibraryRemoved(String:name[])
{
	if (.3076.StrEqual(name, "HoE-tags-admin", true))
	{
		g_var3608 = 0;
	}
	return 0;
}

public OnPluginEnd()
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsPlayerAlive(i))
		{
			.258936.RemoveHatEntity(i);
			.261540.RemoveTrailEntity(i);
			.265276.ResetPlayerModel(i);
		}
		i++;
	}
	.37608.ClearHandle(g_var35e4);
	return 0;
}

public OnSQLConnect(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		if (g_var35e4)
		{
			return 0;
		}
		g_var35e4 = hndl;
		PrintToServer("Store database connected successfully.");
		new String:sQuery[4096];
		Format(sQuery, 4096, "CREATE TABLE IF NOT EXISTS `%s` (`id` int(11) NOT NULL AUTO_INCREMENT, `steam2` varchar(32) NOT NULL, `steam3` varchar(32) NOT NULL, `name` varchar(%i) NOT NULL, `credits` int(11) NOT NULL, `auto_pistols` int(1) NOT NULL, `auto_pistols_expire` int(11) NOT NULL, `weapon_colors` int(1) NOT NULL, `weapon_colors_expire` int(11) NOT NULL, `grenade_trails` int(1) NOT NULL, `grenade_trails_expire` int(11) NOT NULL, `tracers` int(1) NOT NULL, `tracers_expire` int(11) NOT NULL, `laser_sights` int(1) NOT NULL, `laser_sights_expire` int(11) NOT NULL, `chat_colors` int(1) NOT NULL, `chat_colors_expire` int(11) NOT NULL, `name_colors` int(1) NOT NULL, `name_colors_expire` int(11) NOT NULL, `custom_tags` int(1) NOT NULL, `custom_tags_expire` int(11) NOT NULL, `join_date` int(11) NOT NULL, `last_join_date` int(11) NOT NULL, `converted` int(1) NOT NULL DEFAULT 1, PRIMARY KEY (`id`), UNIQUE KEY `id` (`id`), UNIQUE KEY `steam2` (`steam2`), UNIQUE KEY `steam3` (`steam3`));", "hellonearth_store_players", 32);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		Format(sQuery, 4096, "CREATE TABLE IF NOT EXISTS `%s` (`id` int(11) NOT NULL AUTO_INCREMENT, `player_id` int(11) NOT NULL, `steamid` varchar(64) NOT NULL, `name` varchar(%i) NOT NULL, `type` VARCHAR(%i) NOT NULL, `purchase_price` int(11) NOT NULL, `purchase_date` int(11) NOT NULL, `expiration_enable` INT(1) NOT NULL DEFAULT '0', `expiration_date` int(11) NOT NULL, PRIMARY KEY (`id`), UNIQUE KEY `id` (`id`));", "hellonearth_store_items", 256, 256);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		Format(sQuery, 4096, "CREATE TABLE IF NOT EXISTS `%s` (`id` int(11) NOT NULL AUTO_INCREMENT, `player_id` int(11) NOT NULL, `name` VARCHAR(%i) NOT NULL, `type` varchar(%i) NOT NULL, `entity` varchar(64) NOT NULL, `team` INT(1) NOT NULL DEFAULT '0', PRIMARY KEY (`id`));", "hellonearth_store_equipped", 256, 256);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		if (g_Late)
		{
			new i = 1;
			while (i <= MaxClients)
			{
				if (IsClientInGame(i))
				{
					OnClientPutInServer(i);
				}
				if (AreClientCookiesCached(i))
				{
					OnClientCookiesCached(i);
				}
				i++;
			}
			g_Late = 0;
		}
		return 0;
	}
	LogError("Error connecting to database: %s", error);
	return 0;
}

public TQuery_OnPurgePlayers(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new rows = SQL_GetRowCount(hndl);
		if (0 >= rows)
		{
			return 0;
		}
		new Transaction:hTrans = SQL_CreateTransaction();
		while (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(hndl, 0, 0);
			new String:sQuery[4096];
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE id = '%i';", "hellonearth_store_players", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_equipped", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
		}
		SQL_ExecuteTransaction(g_var35e4, hTrans, OnPurgeSuccess, OnPurgeFailure, rows, DBPriority:1);
		LogMessage("%i players purged successfully older than %i days.", rows, g_var31a0);
		return 0;
	}
	LogError("Error retrieving IDs for purging: %s", error);
	return 0;
}

public OnPurgeSuccess(Database:db, any:data, numQueries, Handle:results[], any:queryData[])
{
	LogMessage("Successfully purged %i players from the database.", data);
	return 0;
}

public OnPurgeFailure(Database:db, any:data, numQueries, String:error[], failIndex, any:queryData[])
{
	LogError("Error purging inactive players: [%i] %s", failIndex, error);
	return 0;
}

public OnMapStart()
{
	g_var35f0 = PrecacheModel("materials/sprites/laserbeam.vmt", true);
	g_var35f4 = PrecacheModel("materials/sprites/redglow1.vmt", true);
	if (!g_var3610)
	{
		g_var3610 = .59236.ParseItemsFile(true);
		return 0;
	}
	new i;
	while (GetArraySize(g_vara7ac) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7ac, i, 0, false);
		new String:sModel[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "model", sModel, 256, 0) && strlen(sModel) > 0)
		{
			if (!IsModelPrecached(sModel))
			{
				PrecacheModel(sModel, true);
				.11516.Downloader_AddFileToDownloadsTable(sModel);
			}
		}
		else
		{
			LogError("Error adding model '%s' to the 'Hats' category.", sModel);
		}
		i++;
	}
	new i;
	while (GetArraySize(g_vara7b4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7b4, i, 0, false);
		new String:sMaterial[256];
		new var2;
		if (hTrie && GetTrieString(hTrie, "material", sMaterial, 256, 0) && strlen(sMaterial) > 0)
		{
			if (!IsModelPrecached(sMaterial))
			{
				new iMaterialID = PrecacheModel(sMaterial, true);
				.11516.Downloader_AddFileToDownloadsTable(sMaterial);
				SetTrieValue(g_vara7a8, sMaterial, iMaterialID, true);
			}
		}
		else
		{
			LogError("Error adding material '%s' to the 'Trails' category.", sMaterial);
		}
		i++;
	}
	new i;
	while (GetArraySize(g_vara7bc) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7bc, i, 0, false);
		new String:sModel[256];
		new var3;
		if (hTrie && GetTrieString(hTrie, "model", sModel, 256, 0) && strlen(sModel) > 0)
		{
			if (!IsModelPrecached(sModel))
			{
				PrecacheModel(sModel, true);
				.11516.Downloader_AddFileToDownloadsTable(sModel);
			}
		}
		else
		{
			LogError("Error adding material '%s' to the 'Grenade Models' category.", sModel);
		}
		i++;
	}
	new i;
	while (GetArraySize(g_vara804) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara804, i, 0, false);
		new String:sModel[256];
		new var4;
		if (hTrie && GetTrieString(hTrie, "model", sModel, 256, 0) && strlen(sModel) > 0)
		{
			if (!IsModelPrecached(sModel))
			{
				PrecacheModel(sModel, true);
				.11516.Downloader_AddFileToDownloadsTable(sModel);
			}
		}
		else
		{
			LogError("Error adding material '%s' to the 'Player Models' category.", sModel);
		}
		i++;
	}
	return 0;
}

.59236.ParseItemsFile(bool:bReloadAssets)
{
	new String:sPath[256];
	BuildPath(PathType:0, sPath, 256, "configs/hellonearth/store/store.cfg");
	new Handle:hKV = CreateKeyValues("Store", "", "");
	if (!FileToKeyValues(hKV, sPath))
	{
		LogError("Error parsing store configuration file, missing file.");
		CloseHandle(hKV);
		return 0;
	}
	if (KvJumpToKey(hKV, "Hats", false))
	{
		.69028.ClearArray2(g_vara7ac);
		ClearTrie(g_vara7b0);
		if (KvGotoFirstSubKey(hKV, true))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iPrice = KvGetNum(hKV, "price", 0);
				SetTrieValue(hTrie, "price", iPrice, true);
				new String:sModel[256];
				KvGetString(hKV, "model", sModel, 256, "");
				SetTrieString(hTrie, "model", sModel, true);
				new Float:fPosition[3] = 0.0;
				KvGetVector(hKV, "position", fPosition, 52520);
				SetTrieArray(hTrie, "position", fPosition, 3, true);
				new Float:fAngle[3] = 0.0;
				KvGetVector(hKV, "angle", fAngle, 52520);
				SetTrieArray(hTrie, "angle", fAngle, 3, true);
				new bool:bBonemerge = .37520.KvGetBool(hKV, "bonemerge", false);
				SetTrieValue(hTrie, "bonemerge", bBonemerge, true);
				new String:sAttachment[256];
				new var1;
				if (g_Game)
				{
					var1[0] = 52596;
				}
				else
				{
					var1[0] = 52608;
				}
				KvGetString(hKV, "attachment", sAttachment, 256, var1);
				SetTrieString(hTrie, "attachment", sAttachment, true);
				new index = PushArrayCell(g_vara7ac, hTrie);
				SetTrieValue(g_vara7b0, sName, index, true);
			} while (KvGotoNextKey(hKV, true));
		}
		else
		{
			LogError("Error parsing 'hats' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Trails", false))
	{
		.69028.ClearArray2(g_vara7b4);
		ClearTrie(g_vara7b8);
		if (KvGotoFirstSubKey(hKV, true))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iPrice = KvGetNum(hKV, "price", 0);
				SetTrieValue(hTrie, "price", iPrice, true);
				new String:sMaterial[256];
				KvGetString(hKV, "material", sMaterial, 256, "");
				SetTrieString(hTrie, "material", sMaterial, true);
				new Float:fInitialWidth = KvGetFloat(hKV, "initial_width", 10.0);
				SetTrieValue(hTrie, "initial_width", fInitialWidth, true);
				new Float:fFinalWidth = KvGetFloat(hKV, "final_width", 10.0);
				SetTrieValue(hTrie, "final_width", fFinalWidth, true);
				new iFadeTime = KvGetNum(hKV, "fade_time", 10);
				SetTrieValue(hTrie, "fade_time", iFadeTime, true);
				new index = PushArrayCell(g_vara7b4, hTrie);
				SetTrieValue(g_vara7b8, sName, index, true);
			} while (KvGotoNextKey(hKV, true));
		}
		else
		{
			LogError("Error parsing 'trails' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Grenade Models", false))
	{
		.69028.ClearArray2(g_vara7bc);
		ClearTrie(g_vara7c0);
		if (KvGotoFirstSubKey(hKV, true))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iPrice = KvGetNum(hKV, "price", 0);
				SetTrieValue(hTrie, "price", iPrice, true);
				new String:sModel[256];
				KvGetString(hKV, "model", sModel, 256, "");
				SetTrieString(hTrie, "model", sModel, true);
				new String:sEntity[32];
				KvGetString(hKV, "entity", sEntity, 32, "");
				SetTrieString(hTrie, "entity", sEntity, true);
				new index = PushArrayCell(g_vara7bc, hTrie);
				SetTrieValue(g_vara7c0, sName, index, true);
			} while (KvGotoNextKey(hKV, true));
		}
		else
		{
			LogError("Error parsing 'grenade models' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Weapon Colors", false))
	{
		.69028.ClearArray2(g_vara7c4);
		ClearTrie(g_vara7c8);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iColor[4];
				KvGetColor(hKV, NULL_STRING, iColor, iColor[1], iColor[2], iColor[3]);
				SetTrieArray(hTrie, "color", iColor, 4, true);
				new index = PushArrayCell(g_vara7c4, hTrie);
				SetTrieValue(g_vara7c8, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'weapon colors' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Grenade Trails", false))
	{
		.69028.ClearArray2(g_vara7cc);
		ClearTrie(g_vara7d0);
		if (KvGotoFirstSubKey(hKV, true))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iColor[4];
				KvGetColor(hKV, "color", iColor, iColor[1], iColor[2], iColor[3]);
				SetTrieArray(hTrie, "color", iColor, 4, true);
				new String:sEntity[32];
				KvGetString(hKV, "entity", sEntity, 32, "");
				SetTrieString(hTrie, "entity", sEntity, true);
				new index = PushArrayCell(g_vara7cc, hTrie);
				SetTrieValue(g_vara7d0, sName, index, true);
			} while (KvGotoNextKey(hKV, true));
		}
		else
		{
			LogError("Error parsing 'grenade trails' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Tracers", false))
	{
		.69028.ClearArray2(g_vara7d4);
		ClearTrie(g_vara7d8);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iColor[4];
				KvGetColor(hKV, NULL_STRING, iColor, iColor[1], iColor[2], iColor[3]);
				SetTrieArray(hTrie, "color", iColor, 4, true);
				new index = PushArrayCell(g_vara7d4, hTrie);
				SetTrieValue(g_vara7d8, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'tracers' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Laser Sights", false))
	{
		.69028.ClearArray2(g_vara7dc);
		ClearTrie(g_vara7e0);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iColor[4];
				KvGetColor(hKV, NULL_STRING, iColor, iColor[1], iColor[2], iColor[3]);
				SetTrieArray(hTrie, "color", iColor, 4, true);
				new index = PushArrayCell(g_vara7dc, hTrie);
				SetTrieValue(g_vara7e0, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'laser sights' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Chat Colors", false))
	{
		.69028.ClearArray2(g_vara7e4);
		ClearTrie(g_vara7e8);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new String:sColor[256];
				KvGetString(hKV, NULL_STRING, sColor, 256, "");
				SetTrieString(hTrie, "colortag", sColor, true);
				new index = PushArrayCell(g_vara7e4, hTrie);
				SetTrieValue(g_vara7e8, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'chat colors' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Name Colors", false))
	{
		.69028.ClearArray2(g_vara7ec);
		ClearTrie(g_vara7f0);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new String:sColor[256];
				KvGetString(hKV, NULL_STRING, sColor, 256, "");
				SetTrieString(hTrie, "colortag", sColor, true);
				new index = PushArrayCell(g_vara7ec, hTrie);
				SetTrieValue(g_vara7f0, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'name colors' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Custom Tags", false))
	{
		.69028.ClearArray2(g_vara7f4);
		ClearTrie(g_vara7f8);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new String:sTag[256];
				KvGetString(hKV, NULL_STRING, sTag, 256, "");
				SetTrieString(hTrie, "tag", sTag, true);
				new index = PushArrayCell(g_vara7f4, hTrie);
				SetTrieValue(g_vara7f8, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'custom tags' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Custom Tags Colors", false))
	{
		.69028.ClearArray2(g_vara7fc);
		ClearTrie(g_vara800);
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new String:sColor[256];
				KvGetString(hKV, NULL_STRING, sColor, 256, "");
				SetTrieString(hTrie, "color", sColor, true);
				new index = PushArrayCell(g_vara7fc, hTrie);
				SetTrieValue(g_vara800, sName, index, true);
			} while (KvGotoNextKey(hKV, false));
		}
		else
		{
			LogError("Error parsing 'custom tags colors' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	if (KvJumpToKey(hKV, "Player Models", false))
	{
		.69028.ClearArray2(g_vara804);
		ClearTrie(g_vara808);
		if (KvGotoFirstSubKey(hKV, true))
		{
			do {
				new Handle:hTrie = CreateTrie();
				new String:sName[256];
				KvGetSectionName(hKV, sName, 256);
				SetTrieString(hTrie, "name", sName, true);
				new iPrice = KvGetNum(hKV, "price", 0);
				SetTrieValue(hTrie, "price", iPrice, true);
				new String:sModel[256];
				KvGetString(hKV, "model", sModel, 256, "");
				SetTrieString(hTrie, "model", sModel, true);
				new iTeam = KvGetNum(hKV, "team", 0);
				SetTrieValue(hTrie, "team", iTeam, true);
				new index = PushArrayCell(g_vara804, hTrie);
				SetTrieValue(g_vara808, sName, index, true);
			} while (KvGotoNextKey(hKV, true));
		}
		else
		{
			LogError("Error parsing 'player models' section of items config, empty section.");
		}
		KvRewind(hKV);
	}
	CloseHandle(hKV);
	if (bReloadAssets)
	{
		CreateTimer(5.0, Timer_CallMapStart, any:0, 0);
	}
	return 1;
}

public Timer_CallMapStart(Handle:timer)
{
	OnMapStart();
	return 0;
}

.69028.ClearArray2(Handle:hArray)
{
	new i;
	while (GetArraySize(hArray) > i)
	{
		new Handle:hBuffer = GetArrayCell(hArray, i, 0, false);
		.37608.ClearHandle(hBuffer);
		i++;
	}
	ClearArray(hArray);
	return 0;
}

public OnClientPutInServer(client)
{
	if (IsFakeClient(client))
	{
		return 0;
	}
	SDKHook(client, SDKHookType:32, OnWeaponEquip);
	13924[client] = 0;
	14188[client] = -1;
	14716[client] = 0;
	42656[client] = 0;
	42128[client] = -1;
	42392[client] = 0;
	17884[client] = -1;
	18148[client] = -1;
	19732[client] = 0;
	16036[client] = 0;
	16300[client] = 0;
	16564[client] = 0;
	16828[client] = 0;
	17092[client] = 0;
	17356[client] = 0;
	17620[client] = 0;
	15508[client] = 0;
	15772[client] = 1;
	.80376.RefreshStoreTries(client, true);
	new String:sSteamID[64];
	new var1;
	if (g_var35e4 && GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true))
	{
		new String:sQuery[4096];
		Format(sQuery, 4096, "SELECT * FROM `%s` WHERE steam2 = '%s';", "hellonearth_store_players", sSteamID);
		SQL_TQuery(g_var35e4, SQL_OnClientVerification, sQuery, GetClientUserId(client), DBPriority:1);
	}
	return 0;
}

public SQL_OnClientVerification(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new client = GetClientOfUserId(data);
	if (hndl)
	{
		if (client < 1)
		{
			return 0;
		}
		if (SQL_FetchRow(hndl))
		{
			13924[client] = SQL_FetchInt(hndl, 0, 0);
			14188[client] = SQL_FetchInt(hndl, 4, 0);
			14452[client] = .37564.SQL_FetchBool(hndl, 5, 0);
			16036[client] = .37564.SQL_FetchBool(hndl, 7, 0);
			16300[client] = .37564.SQL_FetchBool(hndl, 9, 0);
			16564[client] = .37564.SQL_FetchBool(hndl, 11, 0);
			16828[client] = .37564.SQL_FetchBool(hndl, 13, 0);
			17092[client] = .37564.SQL_FetchBool(hndl, 15, 0);
			17356[client] = .37564.SQL_FetchBool(hndl, 17, 0);
			17620[client] = .37564.SQL_FetchBool(hndl, 19, 0);
			new String:sQuery[4096];
			new String:sAddon[4096];
			new iExpiry = SQL_FetchInt(hndl, 6, 0);
			15244[client] = iExpiry;
			new var1;
			if (14452[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				14452[client] = 0;
				.3640.StrCat(sAddon, 4096, ", auto_pistols = '0', auto_pistols_expire = '0'");
				15244[client] = -1;
			}
			iExpiry = SQL_FetchInt(hndl, 8, 0);
			new var2;
			if (16036[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				16036[client] = 0;
				.3640.StrCat(sAddon, 4096, ", weapon_colors = '0', weapon_colors_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 10, 0);
			new var3;
			if (16300[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				16300[client] = 0;
				.3640.StrCat(sAddon, 4096, ", grenade_trails = '0', grenade_trails_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 12, 0);
			new var4;
			if (16564[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				16564[client] = 0;
				.3640.StrCat(sAddon, 4096, ", tracers = '0', tracers_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 14, 0);
			new var5;
			if (16828[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				16828[client] = 0;
				.3640.StrCat(sAddon, 4096, ", laser_sights = '0', laser_sights_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 16, 0);
			new var6;
			if (17092[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				17092[client] = 0;
				.3640.StrCat(sAddon, 4096, ", chat_colors = '0', chat_colors_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 18, 0);
			new var7;
			if (17356[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				17356[client] = 0;
				.3640.StrCat(sAddon, 4096, ", name_colors = '0', name_colors_expire = '0'");
			}
			iExpiry = SQL_FetchInt(hndl, 20, 0);
			new var8;
			if (17620[client] && iExpiry && GetTime({0,0}) > iExpiry)
			{
				17620[client] = 0;
				.3640.StrCat(sAddon, 4096, ", name_colors = '0', name_colors_expire = '0'");
			}
			15508[client] = .37564.SQL_FetchBool(hndl, 23, 0);
			new String:sName[32];
			GetClientName(client, sName, 32);
			new String:sSafeName[68];
			SQL_EscapeString(g_var35e4, sName, sSafeName, 65, 0);
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s', last_join_date = '%i'%s WHERE id = '%i';", "hellonearth_store_players", sSafeName, GetTime({0,0}), sAddon, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnUpdateClient, sQuery, GetClientUserId(client), DBPriority:1);
		}
		else
		{
			new String:sSteamID[64];
			GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
			new String:sSteamID3[64];
			GetClientAuthId(client, AuthIdType:2, sSteamID3, 64, true);
			new iTime = GetTime({0,0});
			new String:sName[32];
			GetClientName(client, sName, 32);
			new String:sSafeName[68];
			SQL_EscapeString(g_var35e4, sName, sSafeName, 65, 0);
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (steam2, steam3, name, credits, join_date, last_join_date) VALUES ('%s', '%s', '%s', '%i', '%i', '%i');", "hellonearth_store_players", sSteamID, sSteamID3, sSafeName, g_var3190, iTime, iTime);
			SQL_TQuery(g_var35e4, SQL_OnInsertNewClient, sQuery, GetClientUserId(client), DBPriority:1);
		}
		return 0;
	}
	LogError("Error on client verification: [%L] - %s", client, error);
	return 0;
}

public TQuery_OnUpdateClient(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new client = GetClientOfUserId(data);
	if (hndl)
	{
		if (0 < client)
		{
			.77308.PullClientItems(client);
		}
		return 0;
	}
	LogError("Error on client database updates: [%i] - %s", client, error);
	return 0;
}

public SQL_OnInsertNewClient(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new client = GetClientOfUserId(data);
		if (0 < client)
		{
			13924[client] = SQL_GetInsertId(hndl);
			14188[client] = g_var3190;
			14452[client] = 0;
			16036[client] = 0;
			16300[client] = 0;
			16564[client] = 0;
			16828[client] = 0;
			17092[client] = 0;
			17356[client] = 0;
			17620[client] = 0;
			15508[client] = 1;
			new String:sSteamID[64];
			GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
			if (g_var35e0)
			{
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT credits FROM `store_credits` WHERE steamid = '%s';", sSteamID);
				SQL_TQuery(g_var35e4, TQuery_OnMigrateCredits, sQuery, GetClientUserId(client), DBPriority:2);
			}
		}
		return 0;
	}
	LogError("Error inserting a new client: %s", error);
	return 0;
}

public TQuery_OnMigrateCredits(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new client = GetClientOfUserId(data);
		new var1;
		if (SQL_FetchRow(hndl) && client > 0)
		{
			new var2 = 14188[client];
			var2 = var2[SQL_FetchInt(hndl, 0, 0)];
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET credits =  %i WHERE id = '%i';", "hellonearth_store_players", 14188[client], 13924[client]);
			.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:2);
			new String:sSteamID[64];
			GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
			Format(sQuery, 4096, "DELETE FROM `store_credits` WHERE steamid = '%s';", sSteamID);
			.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:2);
		}
		return 0;
	}
	LogError("Error pulling client credits: %s", error);
	return 0;
}

.77308.PullClientItems(client)
{
	new var1;
	if (client < 1 || 13924[client] <= 0)
	{
		return 0;
	}
	new String:sSteamID[64];
	GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
	new String:sQuery[4096];
	Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' OR steamid = '%s';", "hellonearth_store_items", 13924[client], sSteamID);
	SQL_TQuery(g_var35e4, TQuery_OnPullClientItems, sQuery, GetClientUserId(client), DBPriority:1);
	return 0;
}

public TQuery_OnPullClientItems(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new client = GetClientOfUserId(data);
		if (client < 1)
		{
			return 0;
		}
		while (SQL_FetchRow(hndl))
		{
			new String:sName[256];
			SQL_FetchString(hndl, 3, sName, 256, 0);
			new String:sType[256];
			SQL_FetchString(hndl, 4, sType, 256, 0);
			PushArrayString(41332[client], sName);
			PushArrayString(41596[client], sType);
		}
		new String:sQuery[4096];
		Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i';", "hellonearth_store_equipped", 13924[client]);
		SQL_TQuery(g_var35e4, TQuery_OnParseEquipped, sQuery, GetClientUserId(client), DBPriority:1);
		return 0;
	}
	LogError("Error pulling client items: %s", error);
	return 0;
}

public TQuery_OnParseEquipped(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new client = GetClientOfUserId(data);
		if (client < 1)
		{
			return 0;
		}
		new Handle:hTrie;
		GetTrieValue(41860[client], "Grenade Models", hTrie);
		new Handle:hTrie2;
		GetTrieValue(41860[client], "Grenade Trails", hTrie2);
		new Handle:hTrie3;
		GetTrieValue(41860[client], "Player Models", hTrie3);
		while (SQL_FetchRow(hndl))
		{
			new String:sName[256];
			SQL_FetchString(hndl, 2, sName, 256, 0);
			new String:sType[256];
			SQL_FetchString(hndl, 3, sType, 256, 0);
			new String:sEntity[32];
			SQL_FetchString(hndl, 4, sEntity, 32, 0);
			new iTeam = SQL_FetchInt(hndl, 5, 0);
			new var1;
			if (!(FindStringInArray(41332[client], sName) == -1 && FindStringInArray(41596[client], sType) == -1))
			{
				if (.3076.StrEqual(sType, "Grenade Models", true))
				{
					SetTrieString(hTrie, sEntity, sName, true);
				}
				if (.3076.StrEqual(sType, "Grenade Trails", true))
				{
					SetTrieString(hTrie2, sEntity, sName, true);
				}
				else
				{
					if (.3076.StrEqual(sType, "Player Models", true))
					{
						new String:sTeam[12];
						IntToString(iTeam, sTeam, 12);
						SetTrieString(hTrie3, sTeam, sName, true);
					}
					SetTrieString(41860[client], sType, sName, true);
				}
				new var2;
				if (IsClientInGame(client) && IsPlayerAlive(client))
				{
					if (.3076.StrEqual(sType, "Hats", true))
					{
						.255140.CreateHatEntity(client, sName, true);
					}
					if (.3076.StrEqual(sType, "Trails", true))
					{
						.259788.CreateTrailEntity(client, sName, true);
					}
				}
			}
		}
		new var3;
		if (IsClientInGame(client) && IsPlayerAlive(client))
		{
			.263964.SetPlayerModel(client, GetClientTeam(client), true);
		}
		return 0;
	}
	LogError("Error pulling client equipped items: %s", error);
	return 0;
}

.80376.RefreshStoreTries(client, bool:bCreate)
{
	.37608.ClearHandle(41332[client]);
	.37608.ClearHandle(41596[client]);
	if (41860[client])
	{
		new Handle:hTrie;
		if (GetTrieValue(41860[client], "Grenade Models", hTrie))
		{
			.37608.ClearHandle(hTrie);
		}
		new Handle:hTrie2;
		if (GetTrieValue(41860[client], "Grenade Trails", hTrie2))
		{
			.37608.ClearHandle(hTrie2);
		}
		new Handle:hTrie3;
		if (GetTrieValue(41860[client], "Player Models", hTrie3))
		{
			.37608.ClearHandle(hTrie3);
		}
		CloseHandle(41860[client]);
		41860[client] = 0;
	}
	if (bCreate)
	{
		41332[client] = CreateArray(.4968.ByteCountToCells(1024), 0);
		41596[client] = CreateArray(.4968.ByteCountToCells(1024), 0);
		41860[client] = CreateTrie();
		new Handle:hTrie = CreateTrie();
		SetTrieValue(41860[client], "Grenade Models", hTrie, true);
		new Handle:hTrie2 = CreateTrie();
		SetTrieValue(41860[client], "Grenade Trails", hTrie2, true);
		new Handle:hTrie3 = CreateTrie();
		SetTrieValue(41860[client], "Player Models", hTrie3, true);
	}
	return 0;
}

public GiveCreditsToAll(Handle:timer)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			.81756.GiveClientCredits(i, g_var3080, g_var3218);
		}
		i++;
	}
	return 0;
}

.81756.GiveClientCredits(client, credits, bool:bMessage)
{
	new var1;
	if (IsClientInGame(client) && !IsFakeClient(client) && 13924[client])
	{
		new var2 = 14188[client];
		var2 = var2[credits];
		14716[client] = 1;
		if (bMessage)
		{
			.13572.CPrintToChat(client, "%t", "give credits", credits);
		}
		return 1;
	}
	return 0;
}

.82096.ResetCredits(client)
{
	new var1;
	if (IsClientInGame(client) && !IsFakeClient(client) && 13924[client])
	{
		14188[client] = 0;
		.13572.CPrintToChat(client, "%t", "reset credits");
		14716[client] = 1;
		return 1;
	}
	return 0;
}

.82392.RemoveClientCredits(client, credits, bool:bMessage)
{
	new var1;
	if (IsClientInGame(client) && !IsFakeClient(client) && 13924[client])
	{
		14188[client] -= credits;
		if (bMessage)
		{
			.13572.CPrintToChat(client, "%t", "remove credits", credits);
		}
		if (14188[client] <= -1)
		{
			14188[client] = 0;
			LogError("Client '%L' almost went into negative credits for some reason, please report. [%i]", client, credits);
		}
		14716[client] = 1;
		return 1;
	}
	return 0;
}

public OnClientSayCommand_Post(client, String:command[], String:sArgs[])
{
	new var1;
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client))
	{
		return 0;
	}
	if (39220[client])
	{
		new credits = StringToInt(sArgs, 10);
		new i = 1;
		while (i <= MaxClients)
		{
			new var2;
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				.81756.GiveClientCredits(i, credits, false);
			}
			i++;
		}
		.113268.OpenStoreMenu(client);
		.13572.CPrintToChat(client, "%t", "give credits to all", credits);
		.269948.LogTransaction("", g_var3274, "'%L' has given all clients '%i' credits.", client, credits);
		39220[client] = 0;
	}
	else
	{
		if (39484[client])
		{
			new credits = StringToInt(sArgs, 10);
			new i = 1;
			while (i <= MaxClients)
			{
				new var3;
				if (IsClientInGame(i) && !IsFakeClient(i) && 39748[client] == GetClientTeam(i))
				{
					.81756.GiveClientCredits(i, credits, false);
				}
				i++;
			}
			new String:sTeamName[128];
			GetTeamName(39748[client], sTeamName, 128);
			.113268.OpenStoreMenu(client);
			.13572.CPrintToChat(client, "%t", "give credits to team", credits, sTeamName);
			.269948.LogTransaction("", g_var3274, "'%L' has given the team '%s' %i credits.", client, sTeamName, credits);
			39484[client] = 0;
			39748[client] = 0;
		}
		if (40012[client])
		{
			new credits = StringToInt(sArgs, 10);
			.81756.GiveClientCredits(40276[client], credits, false);
			.113268.OpenStoreMenu(client);
			.13572.CPrintToChat(client, "%t", "give credits to player", credits, 40276[client]);
			.269948.LogTransaction("", g_var3274, "'%L' has given '%L' %i credits.", client, 40276[client], credits);
			40012[client] = 0;
			40276[client] = 0;
		}
		if (40540[client])
		{
			new credits = StringToInt(sArgs, 10);
			new i = 1;
			while (i <= MaxClients)
			{
				new var4;
				if (IsClientInGame(i) && !IsFakeClient(i))
				{
					.82392.RemoveClientCredits(i, credits, false);
				}
				i++;
			}
			.13572.CPrintToChat(client, "%t", "remove credits from all", credits);
			.269948.LogTransaction("", g_var3274, "'%L' has removed '%i' credits from all.", client, credits);
			40540[client] = 0;
		}
		if (40804[client])
		{
			new credits = StringToInt(sArgs, 10);
			new i = 1;
			while (i <= MaxClients)
			{
				new var5;
				if (IsClientInGame(i) && !IsFakeClient(i) && 40804[client] == GetClientTeam(i))
				{
					.82392.RemoveClientCredits(i, credits, false);
				}
				i++;
			}
			new String:sTeamName[128];
			GetTeamName(40804[client], sTeamName, 128);
			.13572.CPrintToChat(client, "%t", "remove credits from team", credits, sTeamName);
			.269948.LogTransaction("", g_var3274, "'%L' has removed '%i' credits from team '%s'.", client, credits, sTeamName);
			40804[client] = 0;
		}
		if (41068[client])
		{
			new credits = StringToInt(sArgs, 10);
			.82392.RemoveClientCredits(41068[client], credits, false);
			.13572.CPrintToChat(client, "%t", "remove credits from player", credits, 41068[client]);
			.269948.LogTransaction("", g_var3274, "'%L' has removed '%i' credits from player '%L'.", client, credits, 41068[client]);
			41068[client] = 0;
		}
		if (42392[client])
		{
			new target = 42128[client];
			new credits = StringToInt(sArgs, 10);
			if (0 >= credits)
			{
				.13572.CPrintToChat(client, "%t", "invalid credits amount");
				return 0;
			}
			if (14188[client] < credits)
			{
				.13572.CPrintToChat(client, "%t", "invalid credits amount");
				return 0;
			}
			.225472.ConfirmGiftCredits(client, target, credits);
			42128[client] = -1;
			42392[client] = 0;
		}
	}
	return 0;
}


/* ERROR! null */
 function "OnChatMessage" (number 92)
public OnClientCookiesCached(client)
{
	new String:sValue[12];
	GetClientCookie(client, g_vara48c, sValue, 12);
	if (strlen(sValue))
	{
		38428[client] = StringToInt(sValue, 10);
	}
	else
	{
		SetClientCookie(client, g_vara48c, "1");
		38428[client] = 1;
	}
	return 0;
}

public OnClientDisconnect(client)
{
	if (IsFakeClient(client))
	{
		return 0;
	}
	38428[client] = 0;
	14452[client] = 0;
	16036[client] = 0;
	16300[client] = 0;
	16564[client] = 0;
	16828[client] = 0;
	17092[client] = 0;
	17356[client] = 0;
	17620[client] = 0;
	42128[client] = -1;
	42392[client] = 0;
	42656[client] = 0;
	.80376.RefreshStoreTries(client, true);
	new var1;
	if (14716[client] && 13924[client] > -1 && 14188[client] > -1)
	{
		new String:sQuery[4096];
		Format(sQuery, 4096, "UPDATE `%s` SET credits = '%i' WHERE id = '%i';", "hellonearth_store_players", 14188[client], 13924[client]);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
	}
	13924[client] = 0;
	14188[client] = -1;
	14716[client] = 0;
	return 0;
}

.91444.CheckPrice(client, price)
{
	return 14188[client] >= price;
}

public OnOpenStoreMenu(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	new var1;
	if (g_var35e4 && 13924[client] <= 0 && 14188[client] <= -1 && 41332[client] && 41860[client])
	{
		.14692.CReplyToCommand(client, "Your data is being fetched, please wait.");
		return 3;
	}
	if (!IsClientInGame(client))
	{
		.14692.CReplyToCommand(client, "%t %t", "default prefix", "Command is in-game only");
		return 3;
	}
	.113268.OpenStoreMenu(client);
	return 3;
}

public OnGiveCredits(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 2)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID> <CREDITS>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArg(1, sArg1, 32);
		new String:sArg2[12];
		GetCmdArg(2, sArg2, 12);
		new credits = StringToInt(sArg2, 10);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		if (0 >= credits)
		{
			.13572.CPrintToChat(client, "%t", "invalid credits amount");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			.81756.GiveClientCredits(target, credits, false);
			.14692.CReplyToCommand(client, "You have given SteamID '%s' %i credits!", sArg1, credits);
			.4716.PrintToChatAll("%t", "give credits to client all", sArg1, credits, client);
			.269948.LogTransaction("", g_var3274, "'%L' has given '%L' %i credits.", client, target, credits);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackCell(hPack, credits);
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var1;
		if (authID == AuthIdType:1)
		{
			var1[0] = 56540;
		}
		else
		{
			var1[0] = 56548;
		}
		Format(sQuery, 4096, "UPDATE `%s` SET credits = credits + %i WHERE %s = '%s';", "hellonearth_store_players", credits, var1, sArg1);
		SQL_TQuery(g_var35e4, OnGiveCreditsSteamID, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public OnGiveCreditsSteamID(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new credits = ReadPackCell(data);
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		.14692.CReplyToCommand(client, "You have given SteamID '%s' %i credits!", sSteamID, credits);
		.4716.PrintToChatAll("%t", "give credits to client all", sSteamID, credits, client);
		.269948.LogTransaction("", g_var3274, "'%L' has given the SteamID '%s' %i credits.", client, sSteamID, credits);
		return 0;
	}
	CloseHandle(data);
	LogError("Error giving credits to an offline SteamID: %s", error);
	return 0;
}

public OnRemoveCredits(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 2)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID> <CREDITS>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArg(1, sArg1, 32);
		new String:sArg2[12];
		GetCmdArg(2, sArg2, 12);
		new credits = StringToInt(sArg2, 10);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		if (0 >= credits)
		{
			.13572.CPrintToChat(client, "%t", "invalid credits amount");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			.82392.RemoveClientCredits(target, credits, false);
			.14692.CReplyToCommand(client, "You have removed %i credits for SteamID '%s'!", credits, sArg1);
			.269948.LogTransaction("", g_var3274, "'%L' has removed '%L' %i credits.", client, target, credits);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackCell(hPack, credits);
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var1;
		if (authID == AuthIdType:1)
		{
			var1[0] = 57008;
		}
		else
		{
			var1[0] = 57016;
		}
		Format(sQuery, 4096, "UPDATE `%s` SET credits = credits - %i WHERE %s = '%s';", "hellonearth_store_players", credits, var1, sArg1);
		SQL_TQuery(g_var35e4, OnRemoveCreditsSteamID, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public OnRemoveCreditsSteamID(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new credits = ReadPackCell(data);
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		.14692.CReplyToCommand(client, "You have removed %i credits for SteamID '%s'!", credits, sSteamID);
		.269948.LogTransaction("", g_var3274, "'%L' has removed the SteamID '%s' %i credits.", client, sSteamID, credits);
		return 0;
	}
	CloseHandle(data);
	LogError("Error removing credits to a SteamID: %s", error);
	return 0;
}

public OnResetCredits(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 1)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArgString(sArg1, 32);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			.82096.ResetCredits(target);
			.14692.CReplyToCommand(client, "You have reset all credits for SteamID '%s'!", sArg1);
			.269948.LogTransaction("", g_var3274, "'%L' has reset the credits of '%L'.", client, target);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var1;
		if (authID == AuthIdType:1)
		{
			var1[0] = 57404;
		}
		else
		{
			var1[0] = 57412;
		}
		Format(sQuery, 4096, "UPDATE `%s` SET credits = 0 WHERE %s = '%s';", "hellonearth_store_players", var1, sArg1);
		SQL_TQuery(g_var35e4, OnResetCreditsSteamID, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public OnResetCreditsSteamID(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		.14692.CReplyToCommand(client, "You have reset all credits for SteamID '%s'!", sSteamID);
		.269948.LogTransaction("", g_var3274, "'%L' has reset the credits of SteamID '%s'.", client, sSteamID);
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting credits to a SteamID: %s", error);
	return 0;
}

public OnResetPlayer(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 1)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArgString(sArg1, 32);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(client));
			WritePackCell(hPack, GetClientUserId(target));
			WritePackString(hPack, sArg1);
			new String:sQuery[4096];
			new Transaction:hTrans = SQL_CreateTransaction();
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE id = '%i';", "hellonearth_store_players", 13924[target]);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", 13924[target]);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_equipped", 13924[target]);
			SQL_AddQuery(hTrans, sQuery, any:0);
			SQL_ExecuteTransaction(g_var35e4, hTrans, hTrans_OnResetPlayer_Success, hTrans_OnResetPlayer_Failure, hPack, DBPriority:1);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var1;
		if (authID == AuthIdType:1)
		{
			var1[0] = 57832;
		}
		else
		{
			var1[0] = 57840;
		}
		Format(sQuery, 4096, "SELECT id FROM `%s` WHERE %s = '%s';", "hellonearth_store_players", var1, sArg1);
		SQL_TQuery(g_var35e4, TQuery_OnResetPlayerOffline, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public hTrans_OnResetPlayer_Success(Database:db, any:data, numQueries, Handle:results[], any:queryData[])
{
	ResetPack(data, false);
	new client = GetClientOfUserId(ReadPackCell(data));
	new target = GetClientOfUserId(ReadPackCell(data));
	new String:sSteamID[32];
	ReadPackString(data, sSteamID, 32);
	CloseHandle(data);
	if (0 < target)
	{
		OnClientPutInServer(target);
	}
	.14692.CReplyToCommand(client, "You have reset all store data for SteamID '%s'!", sSteamID);
	.269948.LogTransaction("", g_var3274, "'%L' has reset the store data of SteamID '%s'.", client, sSteamID);
	return 0;
}

public hTrans_OnResetPlayer_Failure(Database:db, any:data, numQueries, String:error[], failIndex, any:queryData[])
{
	ResetPack(data, false);
	new client = GetClientOfUserId(ReadPackCell(data));
	new target = GetClientOfUserId(ReadPackCell(data));
	new String:sSteamID[32];
	ReadPackString(data, sSteamID, 32);
	CloseHandle(data);
	.14692.CReplyToCommand(client, "Error on resetting a clients store data.");
	LogError("Error on resetting a clients store data from '%N' for '%N': [%i] %s", client, target, failIndex, error);
	return 0;
}

public TQuery_OnResetPlayerOffline(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		if (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(g_var35e4, 0, 0);
			new String:sQuery[4096];
			new Transaction:hTrans = SQL_CreateTransaction();
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE id = '%i';", "hellonearth_store_players", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_equipped", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			SQL_ExecuteTransaction(g_var35e4, hTrans, hTrans_OnResetPlayer2_Success, hTrans_OnResetPlayer2_Failure, data, DBPriority:1);
		}
		else
		{
			.14692.CReplyToCommand(client, "Error resetting store data of SteamID '%s', user not found in database.", sSteamID);
			CloseHandle(data);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting a SteamID offline: %s", error);
	return 0;
}

public hTrans_OnResetPlayer2_Success(Database:db, any:data, numQueries, Handle:results[], any:queryData[])
{
	ResetPack(data, false);
	new client = GetClientOfUserId(ReadPackCell(data));
	new String:sSteamID[32];
	ReadPackString(data, sSteamID, 32);
	CloseHandle(data);
	.14692.CReplyToCommand(client, "You have reset all store data for SteamID '%s'!", sSteamID);
	.269948.LogTransaction("", g_var3274, "'%L' has reset the store data of SteamID '%s'.", client, sSteamID);
	return 0;
}

public hTrans_OnResetPlayer2_Failure(Database:db, any:data, numQueries, String:error[], failIndex, any:queryData[])
{
	ResetPack(data, false);
	new client = GetClientOfUserId(ReadPackCell(data));
	new String:sSteamID[32];
	ReadPackString(data, sSteamID, 32);
	CloseHandle(data);
	.14692.CReplyToCommand(client, "Error on resetting a clients store data.");
	LogError("Error on resetting a clients store data from '%N' for SteamID '%s': [%i] %s", client, sSteamID, failIndex, error);
	return 0;
}

public OnDeleteItem(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 1)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArgString(sArg1, 32);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			new var1;
			if (41332[target] && 41860[target])
			{
				return 3;
			}
			new Handle:hMenu = CreateMenu(MenuHandle_OnDeleteClientItem, MenuAction:28);
			SetMenuTitle(hMenu, "%s", "refunds main menu");
			new i;
			while (GetArraySize(41332[target]) > i)
			{
				new String:sName[256];
				GetArrayString(41332[target], i, sName, 256);
				new String:sType[256];
				GetArrayString(41596[target], i, sType, 256);
				.35744.AddMenuItemFormat(hMenu, sType, 0, "%s - %s", sName, sType);
				i++;
			}
			if (GetMenuItemCount(hMenu) < 1)
			{
				AddMenuItem(hMenu, "", "Client has no items.", 1);
			}
			.35208.PushMenuCell(hMenu, "target", GetClientUserId(target));
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, client, 0);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var2;
		if (authID == AuthIdType:1)
		{
			var2[0] = 58728;
		}
		else
		{
			var2[0] = 58736;
		}
		Format(sQuery, 4096, "SELECT id FROM `%s` WHERE %s = '%s';", "hellonearth_store_players", var2, sArg1);
		SQL_TQuery(g_var35e4, TQuery_OnSelectSteamIDDeleteItem, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public MenuHandle_OnDeleteClientItem(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sType[256];
			new String:sName[256];
			GetMenuItem(menu, param2, sType, 256, 0, sName, 256);
			new String:sBuffer[2][32] = {
				" - ",
				"RE player_id = '%i' AND type = '%s' AND name = '%s';"
			};
			.3816.ExplodeString(sName, " - ", sBuffer, 2, 32, false);
			new target = GetClientOfUserId(.35348.GetMenuCell(menu, "target", 0));
			if (target < 1)
			{
				return 0;
			}
			.104192.DeleteUserItem(target, sType, sBuffer[0][sBuffer], false);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.104192.DeleteUserItem(client, String:sType[], String:sName[], bool:bShowRefundsMenu)
{
	new var1;
	if (client < 1 || 13924[client] < 1 || strlen(sType) < 1 || strlen(sName) < 1 || g_var35e4)
	{
		return 0;
	}
	new Handle:hPack = CreateDataPack();
	WritePackCell(hPack, GetClientUserId(client));
	WritePackString(hPack, sType);
	WritePackString(hPack, sName);
	WritePackCell(hPack, 13924[client]);
	WritePackCell(hPack, bShowRefundsMenu);
	new String:sQuery[4096];
	Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND type = '%s' AND name = '%s';", "hellonearth_store_items", 13924[client], sType, sName);
	SQL_TQuery(g_var35e4, TQuery_OnDeleteUserItem, sQuery, hPack, DBPriority:1);
	return 0;
}

public TQuery_OnDeleteUserItem(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sType[256];
		ReadPackString(data, sType, 256);
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new iDataID = ReadPackCell(data);
		new bool:bShowRefundsMenu = ReadPackCell(data);
		CloseHandle(data);
		if (0 < client)
		{
			new index = FindStringInArray(41332[client], sName);
			if (index != -1)
			{
				RemoveFromArray(41332[client], index);
				RemoveFromArray(41596[client], index);
			}
			RemoveFromTrie(41860[client], sName);
			if (IsPlayerAlive(client))
			{
				if (.3076.StrEqual(sType, "Hats", true))
				{
					.258936.RemoveHatEntity(client);
				}
				if (.3076.StrEqual(sType, "Trails", true))
				{
					.261540.RemoveTrailEntity(client);
				}
				if (.3076.StrEqual(sType, "Player Models", true))
				{
					.265276.ResetPlayerModel(client);
				}
			}
			if (bShowRefundsMenu)
			{
				.219736.DisplayRefundsMenu(client);
			}
		}
		if (g_var35e4)
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = '%s';", "hellonearth_store_equipped", iDataID, sName, sType);
			.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error delete an item from a client: %s", error);
	return 0;
}

public TQuery_OnSelectSteamIDDeleteItem(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		if (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(hndl, 0, 0);
			new String:sQuery[4096];
			Format(sQuery, 4096, "SELECT id, type, name FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", ID);
			SQL_TQuery(g_var35e4, TQuery_OnDisplayDeleteItems, sQuery, data, DBPriority:1);
		}
		else
		{
			.14692.CReplyToCommand(client, "Error retrieving SteamID '%s' to delete an item, user not found in database.", sSteamID);
			CloseHandle(data);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting items to a SteamID online: %s", error);
	return 0;
}

public TQuery_OnDisplayDeleteItems(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		if (client < 1)
		{
			return 0;
		}
		new Handle:hMenu = CreateMenu(MenuHandle_DeleteUserItemOffline, MenuAction:28);
		SetMenuTitle(hMenu, "SteamID '%s' Items:", sSteamID);
		while (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(hndl, 0, 0);
			new String:sType[256];
			SQL_FetchString(hndl, 1, sType, 256, 0);
			new String:sName[256];
			SQL_FetchString(hndl, 2, sName, 256, 0);
			new String:sID[12];
			IntToString(ID, sID, 12);
			.35744.AddMenuItemFormat(hMenu, sID, 0, "%s - %s", sName, sType);
		}
		.35896.PushMenuString(hMenu, "steamid", sSteamID);
		DisplayMenu(hMenu, client, 0);
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting items to a SteamID online: %s", error);
	return 0;
}

public MenuHandle_DeleteUserItemOffline(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sID[32];
			new String:sDisplay[256];
			GetMenuItem(menu, param2, sID, 32, 0, sDisplay, 256);
			new ID = StringToInt(sID, 10);
			new String:sSteamID[32];
			.35952.GetMenuString(menu, "steamid", sSteamID, 32);
			new String:sBuffer[2][32] = {
				" - ",
				"r_id = '%i' AND type = '%s' AND name = '%s';"
			};
			.3816.ExplodeString(sDisplay, " - ", sBuffer, 2, 32, false);
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(param1));
			WritePackString(hPack, sBuffer[1]);
			WritePackString(hPack, sBuffer[0][sBuffer]);
			WritePackString(hPack, sSteamID);
			new String:sQuery[4096];
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND type = '%s' AND name = '%s';", ID, sBuffer[0][sBuffer], sBuffer[1]);
			SQL_TQuery(g_var35e4, TQuery_OnDeleteUserItemOffline, sQuery, hPack, DBPriority:1);
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnDeleteUserItemOffline(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sType[256];
		ReadPackString(data, sType, 256);
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		if (client < 1)
		{
			return 0;
		}
		.14692.CReplyToCommand(client, "You have deleted an item for SteamID '%s'! [%s - %s]", sSteamID, sName, sType);
		.269948.LogTransaction("", g_var3274, "'%L' has deleted an item for SteamID '%s' [%s - %s].", client, sSteamID, sName, sType);
		return 0;
	}
	CloseHandle(data);
	LogError("Error deleting an item for a SteamID offline: %s", error);
	return 0;
}

public OnResetItems(client, args)
{
	if (!g_var307c)
	{
		return 3;
	}
	if (g_var35e4)
	{
		if (!.36728.CheckAdminFlagsByString(client, ""))
		{
			.13572.CPrintToChat(client, "%t", "no required flags");
			return 3;
		}
		if (args < 1)
		{
			new String:sCommand[64];
			GetCmdArg(0, sCommand, 64);
			.14692.CReplyToCommand(client, "[SM] %s <STEAMID>", sCommand);
			return 3;
		}
		new String:sArg1[32];
		GetCmdArgString(sArg1, 32);
		new AuthIdType:authID;
		if (StrContains(sArg1, "STEAM_", true) != -1)
		{
			authID = MissingTAG:1;
		}
		else
		{
			if (StrContains(sArg1, "[U", true) != -1)
			{
				authID = MissingTAG:2;
			}
			.13572.CPrintToChat(client, "%t", "invalid steamid");
			return 3;
		}
		new target = .112632.GetClientBySteamID(sArg1, authID);
		if (0 < target)
		{
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(client));
			WritePackCell(hPack, GetClientUserId(target));
			WritePackString(hPack, sArg1);
			new String:sQuery[4096];
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", 13924[target]);
			SQL_TQuery(g_var35e4, TQuery_OnResetItemsOnline, sQuery, hPack, DBPriority:1);
			return 3;
		}
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackString(hPack, sArg1);
		new String:sQuery[4096];
		new var1;
		if (authID == AuthIdType:1)
		{
			var1[0] = 59712;
		}
		else
		{
			var1[0] = 59720;
		}
		Format(sQuery, 4096, "SELECT id FROM `%s` WHERE %s = '%s';", "hellonearth_store_players", var1, sArg1);
		SQL_TQuery(g_var35e4, TQuery_OnSelectSteamIDResetItems, sQuery, hPack, DBPriority:1);
		return 3;
	}
	.13572.CPrintToChat(client, "%t", "error on command not connected");
	return 3;
}

public TQuery_OnResetItemsOnline(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new target = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		.14692.CReplyToCommand(client, "You have reset all items for SteamID '%s'!", sSteamID);
		.269948.LogTransaction("", g_var3274, "'%L' has reset the items of SteamID '%s'.", client, sSteamID);
		if (0 < target)
		{
			14452[target] = 0;
			16036[target] = 0;
			16300[target] = 0;
			16564[target] = 0;
			16828[target] = 0;
			17092[target] = 0;
			17356[target] = 0;
			17620[target] = 0;
			.258936.RemoveHatEntity(target);
			.261540.RemoveTrailEntity(target);
			.265276.ResetPlayerModel(target);
			.80376.RefreshStoreTries(target, true);
			.13572.CPrintToChat(target, "Your Store items have been reset by an admin.");
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting items to a SteamID online: %s", error);
	return 0;
}

public TQuery_OnSelectSteamIDResetItems(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		if (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(hndl, 0, 0);
			new String:sQuery[4096];
			Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i';", "hellonearth_store_items", ID);
			SQL_TQuery(g_var35e4, TQuery_OnResetItemsOffline, sQuery, data, DBPriority:1);
		}
		else
		{
			.14692.CReplyToCommand(client, "Error resetting items of SteamID '%s', user not found in database.", sSteamID);
			CloseHandle(data);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error selecting a SteamID for resetting items: %s", error);
	return 0;
}

public TQuery_OnResetItemsOffline(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sSteamID[32];
		ReadPackString(data, sSteamID, 32);
		CloseHandle(data);
		.14692.CReplyToCommand(client, "You have reset all items for SteamID '%s'!", sSteamID);
		.269948.LogTransaction("", g_var3274, "'%L' has reset the items of SteamID '%s'.", client, sSteamID);
		return 0;
	}
	CloseHandle(data);
	LogError("Error resetting items to a SteamID offline: %s", error);
	return 0;
}

.112632.GetClientBySteamID(String:sSteamID[], AuthIdType:authType)
{
	new String:sSteamID2[64];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientAuthId(i, authType, sSteamID2, 64, true) && .3076.StrEqual(sSteamID, sSteamID2, true))
		{
			return i;
		}
		i++;
	}
	return 0;
}

public ToggleTransmit(client, args)
{
	if (!IsClientInGame(client))
	{
		return 3;
	}
	new var1;
	if (42656[client])
	{
		var1 = 0;
	}
	else
	{
		var1 = 1;
	}
	42656[client] = var1;
	new var2;
	if (42656[client])
	{
		var2 = 60228;
	}
	else
	{
		var2 = 60232;
	}
	.13572.CPrintToChat(client, "%t", "view hat", var2);
	return 3;
}

.113268.OpenStoreMenu(client)
{
	new var1;
	if (!15772[client] || 13924[client] <= 0 || 14188[client] <= -1 || 41332[client] || 41860[client])
	{
		.14692.CReplyToCommand(client, "Your data is being fetched, please wait.");
		return 0;
	}
	new var2;
	if (g_var3260 && 15508[client])
	{
		15772[client] = 0;
		.114280.StartClientConversion(client);
		return 0;
	}
	new Handle:hMenu = CreateMenu(MenuHandle_StoreMain, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store main menu", 14188[client]);
	AddMenuItem(hMenu, "Credits", "How do I get credits?", 0);
	AddMenuItem(hMenu, "Inventory", "Inventory", 0);
	AddMenuItem(hMenu, "Store", "Store", 0);
	new var3;
	if (g_var31a4)
	{
		var3 = 0;
	}
	else
	{
		var3 = 6;
	}
	AddMenuItem(hMenu, "Refunds", "Refunds", var3);
	new var4;
	if (g_var31a8)
	{
		var4 = 0;
	}
	else
	{
		var4 = 6;
	}
	AddMenuItem(hMenu, "Gifting", "Gifting", var4);
	new var5;
	if (.36728.CheckAdminFlagsByString(client, ""))
	{
		var5 = 0;
	}
	else
	{
		var5 = 6;
	}
	AddMenuItem(hMenu, "Admin Options", "Admin Options", var5);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

.114280.StartClientConversion(client)
{
	new String:sSteamID[64];
	GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
	new String:sQuery[4096];
	Format(sQuery, 4096, "SELECT id, category, data FROM `store_items` WHERE steamid = '%s';", sSteamID);
	SQL_TQuery(g_var35e4, TQuery_OnSyncItems, sQuery, GetClientUserId(client), DBPriority:2);
	return 0;
}

public TQuery_OnSyncItems(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new client = GetClientOfUserId(data);
		if (client < 1)
		{
			return 0;
		}
		if (SQL_GetRowCount(hndl) < 1)
		{
			.120752.EndConversion(client);
			return 0;
		}
		new Handle:hIDArray = CreateArray(1, 0);
		new Handle:hNameArray = CreateArray(256, 0);
		new Handle:hDataArray = CreateArray(.4968.ByteCountToCells(256), 0);
		while (SQL_FetchRow(hndl))
		{
			new ID = SQL_FetchInt(hndl, 0, 0);
			new String:sCategory[256];
			SQL_FetchString(hndl, 1, sCategory, 256, 0);
			new String:sData[256];
			SQL_FetchString(hndl, 2, sData, 256, 0);
			new var1;
			if (!(ID <= 0 || strlen(sCategory) < 1 || strlen(sData) < 1))
			{
				PushArrayCell(hIDArray, ID);
				PushArrayString(hNameArray, sCategory);
				PushArrayString(hDataArray, sData);
			}
		}
		new String:sSteamID[64];
		GetClientAuthId(client, AuthIdType:1, sSteamID, 64, true);
		.115720.ConvertItemsDataClient(client, 13924[client], sSteamID, hIDArray, hNameArray, hDataArray);
		return 0;
	}
	LogError("Error syncing items from old store database: %s", error);
	return 0;
}

.115720.ConvertItemsDataClient(client, iAccountID, String:sSteamID[], Handle:hIDArray, Handle:hNameArray, Handle:hDataArray)
{
	new Handle:hKV = CreateKeyValues("Items", "", "");
	new String:sPath[256];
	BuildPath(PathType:0, sPath, 256, "configs/hellonearth/store.conversion.cfg");
	if (!FileToKeyValues(hKV, sPath))
	{
		LogError("Error finding conversion file.");
		CloseHandle(hKV);
		CloseHandle(hIDArray);
		CloseHandle(hNameArray);
		CloseHandle(hDataArray);
		return 0;
	}
	new String:sQuery[4096];
	new Transaction:hTrans = SQL_CreateTransaction();
	new bool:bAlreadyHasTag;
	new String:sItemsList[256];
	new i;
	while (GetArraySize(hNameArray) > i)
	{
		new ID = GetArrayCell(hIDArray, i, 0, false);
		new String:sCategory[256];
		GetArrayString(hNameArray, i, sCategory, 256);
		new String:sData[256];
		GetArrayString(hDataArray, i, sData, 256);
		new String:sType[256];
		new String:sName[256];
		new bool:bHasTag;
		new iPrice;
		.118112.ConvertItemDataStrings(hKV, sCategory, sData, sType, 256, sName, 256, iPrice, bHasTag);
		new var1;
		if (bHasTag && !bAlreadyHasTag)
		{
			Format(sQuery, 4096, "UPDATE `%s` SET custom_tags = '1' WHERE id = '%i';", "hellonearth_store_players", iAccountID);
			SQL_AddQuery(hTrans, sQuery, any:0);
			if (0 < client)
			{
				17620[client] = 1;
			}
			bAlreadyHasTag = true;
		}
		else
		{
			new var2;
			if (strlen(sType) > 0 && strlen(sName) > 0)
			{
				new var3;
				if (FindStringInArray(41332[client], sName) != -1 && FindStringInArray(41596[client], sType) != -1)
				{
					if (0 < ID)
					{
						Format(sQuery, 4096, "DELETE FROM `store_items` WHERE id = '%i';", ID);
						SQL_AddQuery(hTrans, sQuery, any:0);
					}
					i++;
				}
				Format(sQuery, 4096, "INSERT INTO `%s` (player_id, steamid, name, type, purchase_price, purchase_date) VALUES ('%i', '%s', '%s', '%s', '%i', '%i');", "hellonearth_store_items", iAccountID, sSteamID, sName, sType, iPrice, GetTime({0,0}));
				SQL_AddQuery(hTrans, sQuery, any:0);
				if (0 < client)
				{
					PushArrayString(41332[client], sName);
					PushArrayString(41596[client], sType);
				}
				new var4;
				if (strlen(sItemsList) > 0)
				{
					var4[0] = 60868;
				}
				else
				{
					var4[0] = 60872;
				}
				Format(sItemsList, 255, "%s%s%s", sItemsList, var4, sName);
			}
		}
		if (0 < ID)
		{
			Format(sQuery, 4096, "DELETE FROM `store_items` WHERE id = '%i';", ID);
			SQL_AddQuery(hTrans, sQuery, any:0);
		}
		i++;
	}
	CloseHandle(hIDArray);
	CloseHandle(hNameArray);
	CloseHandle(hDataArray);
	new Handle:hPack = CreateDataPack();
	WritePackCell(hPack, GetClientUserId(client));
	WritePackString(hPack, sItemsList);
	SQL_ExecuteTransaction(g_var35e4, hTrans, OnConvertItemsDataSuccess, OnConvertItemsDataFailure, hPack, DBPriority:2);
	return 0;
}

.118112.ConvertItemDataStrings(Handle:hKV, String:sCategory[], String:sData[], String:sType[], iTypeSize, String:sName[], iNameSize, &iPrice, &bool:bHasTag)
{
	if (.3076.StrEqual(sCategory, "trail", true))
	{
		new var1;
		if (KvJumpToKey(hKV, "Trails", false) && KvGotoFirstSubKey(hKV, true))
		{
			do {
				new String:sSection[256];
				KvGetSectionName(hKV, sSection, 256);
				new String:sTrail[256];
				KvGetString(hKV, "model", sTrail, 256, "");
				new var2;
				if (strlen(sSection) < 0 || strlen(sTrail) < 1)
				{
				}
				else
				{
					if (.3076.StrEqual(sTrail, sData, true))
					{
						strcopy(sType, iTypeSize, "Trails");
						strcopy(sName, iNameSize, sSection);
						iPrice = KvGetNum(hKV, "price", 0);
						KvRewind(hKV);
					}
				}
			} while (KvGotoNextKey(hKV, true));
			KvRewind(hKV);
		}
	}
	else
	{
		if (.3076.StrEqual(sCategory, "hat", true))
		{
			new var3;
			if (KvJumpToKey(hKV, "Hats", false) && KvGotoFirstSubKey(hKV, true))
			{
				do {
					new String:sSection[256];
					KvGetSectionName(hKV, sSection, 256);
					new String:sHat[256];
					KvGetString(hKV, "model", sHat, 256, "");
					new var4;
					if (strlen(sSection) < 0 || strlen(sHat) < 1)
					{
					}
					else
					{
						if (.3076.StrEqual(sHat, sData, true))
						{
							strcopy(sType, iTypeSize, "Hats");
							strcopy(sName, iNameSize, sSection);
							iPrice = KvGetNum(hKV, "price", 0);
							KvRewind(hKV);
						}
					}
				} while (KvGotoNextKey(hKV, true));
				KvRewind(hKV);
			}
		}
		if (.3076.StrEqual(sCategory, "tag", true))
		{
			bHasTag = 1;
			return 0;
		}
		if (.3076.StrEqual(sCategory, "model", true))
		{
			new var5;
			if (KvJumpToKey(hKV, "Models", false) && KvGotoFirstSubKey(hKV, true))
			{
				do {
					new String:sSection[256];
					KvGetSectionName(hKV, sSection, 256);
					new String:sModel[256];
					KvGetString(hKV, "model", sModel, 256, "");
					new var6;
					if (strlen(sSection) < 0 || strlen(sModel) < 1)
					{
					}
					else
					{
						if (.3076.StrEqual(sModel, sData, true))
						{
							strcopy(sType, iTypeSize, "Player Models");
							strcopy(sName, iNameSize, sSection);
							iPrice = KvGetNum(hKV, "price", 0);
							KvRewind(hKV);
						}
					}
				} while (KvGotoNextKey(hKV, true));
				KvRewind(hKV);
			}
		}
	}
	return 0;
}

public OnConvertItemsDataSuccess(Database:db, any:data, numQueries, Handle:results[], any:queryData[])
{
	ResetPack(data, false);
	new client = GetClientOfUserId(ReadPackCell(data));
	new String:sItemsList[256];
	ReadPackString(data, sItemsList, 255);
	CloseHandle(data);
	if (0 < client)
	{
		new var1;
		if (strlen(sItemsList) > 0)
		{
			var1 = sItemsList;
		}
		else
		{
			var1 = 61116;
		}
		.13572.CPrintToChat(client, "Your items have all been migrated successfully.\nItems Recovered: %s", var1);
		.120752.EndConversion(client);
	}
	return 0;
}

.120752.EndConversion(client)
{
	new String:sQuery[4096];
	Format(sQuery, 4096, "UPDATE `%s` SET converted = 0 WHERE id = '%i';", "hellonearth_store_players", 13924[client]);
	.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:2);
	15508[client] = 0;
	15772[client] = 1;
	.113268.OpenStoreMenu(client);
	return 0;
}

public OnConvertItemsDataFailure(Database:db, any:data, numQueries, String:error[], failIndex, any:queryData[])
{
	new client = GetClientOfUserId(data);
	if (client < 1)
	{
		LogError("Error on pushing converted items for '%i (disconnected)': [%i] %s", client, failIndex, error);
		return 0;
	}
	LogError("Error on pushing converted items for '%L': [%i] %s", client, failIndex, error);
	.13572.CPrintToChat(client, "Error pulling your items and credits.");
	return 0;
}

public MenuHandle_StoreMain(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Credits", true))
			{
				.122028.DisplayCreditsMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Inventory", true))
				{
					.122680.DisplayInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Store", true))
				{
					.188096.DisplayStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Refunds", true))
				{
					.219736.DisplayRefundsMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Gifting", true))
				{
					.223472.DisplayGiftingMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Admin Options", true))
				{
					.239436.DisplayAdminOptionsMenu(param1);
				}
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.122028.DisplayCreditsMenu(client)
{
	new String:sPath[256];
	BuildPath(PathType:0, sPath, 256, "configs/hellonearth/store/store.howto.txt");
	new Handle:hFile = OpenFile(sPath, "r", false, "GAME");
	new String:sText[1024];
	ReadFileString(hFile, sText, 1024, 1024);
	CloseHandle(hFile);
	new Handle:hMenu = CreateMenu(MenuHandle_CreditsHowTo, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store credits menu", 14188[client]);
	AddMenuItem(hMenu, "", sText, 1);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_CreditsHowTo(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.122680.DisplayInventoryMenu(client)
{
	new var1;
	if (41332[client] && 41860[client])
	{
		.14692.CReplyToCommand(client, "Your data is being fetched, please wait.");
		return 0;
	}
	new Handle:hMenu = CreateMenu(MenuHandle_Inventory, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory menu", 14188[client]);
	if (g_var3268)
	{
		AddMenuItem(hMenu, "Hats", "Hats", 0);
	}
	if (g_var326c)
	{
		AddMenuItem(hMenu, "Trails", "Trails", 0);
	}
	AddMenuItem(hMenu, "Weapon Related", "Weapon Related", 0);
	AddMenuItem(hMenu, "Fun Stuff", "Fun Stuff", 0);
	if (g_var3270)
	{
		AddMenuItem(hMenu, "Player Models", "Player Models", 0);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_Inventory(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Hats", true))
			{
				.124040.DisplayHatsInventoryMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Trails", true))
				{
					.128784.DisplayTrailsInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Weapon Related", true))
				{
					.133528.DisplayWeaponRelatedInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Fun Stuff", true))
				{
					.161200.DisplayFunStuffInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Player Models", true))
				{
					.181136.DisplayPlayerModelsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.124040.DisplayHatsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayHatsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory hats menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Hats", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7ac) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7ac, i, 0, false);
		new find = -1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			find = FindStringInArray(41332[client], sName);
			new String:sType[256];
			new var2;
			if (41596[client] && find != -1 && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Hats", true))
			{
				find = -1;
			}
		}
		if (find != -1)
		{
			new var3;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var4 = 61824;
			}
			else
			{
				var4 = 61828;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var4);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayHatsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Hats", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.124040.DisplayHatsInventoryMenu(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Hats", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Hats';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipHat, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.124040.DisplayHatsInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Hats';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckHatEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing hats loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.122680.DisplayInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckHatEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Hats' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipHat, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Hats');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipHat, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a hat item: %s", error);
	return 0;
}

public TQuery_OnEquipHat(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				.255140.CreateHatEntity(client, sName, true);
			}
			SetTrieString(41860[client], "Hats", sName, true);
			.124040.DisplayHatsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a hat item: %s", error);
	return 0;
}

public TQuery_OnUnequipHat(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Hats");
			.258936.RemoveHatEntity(client);
			.13572.CPrintToChat(client, "%t", "hat unequipped");
			.124040.DisplayHatsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a hat item: %s", error);
	return 0;
}

.128784.DisplayTrailsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayTrailsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory trails menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Trails", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7b4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7b4, i, 0, false);
		new find = -1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			find = FindStringInArray(41332[client], sName);
			new String:sType[256];
			new var2;
			if (41596[client] && find != -1 && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Trails", true))
			{
				find = -1;
			}
		}
		if (find != -1)
		{
			new var3;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var4 = 62520;
			}
			else
			{
				var4 = 62524;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var4);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayTrailsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Trails", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.128784.DisplayTrailsInventoryMenu(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Trails", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Trails';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipTrail, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.128784.DisplayTrailsInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Trails';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckTrailEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing trails loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.122680.DisplayInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckTrailEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Trails' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipTrail, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Trails');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipTrail, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a trail item: %s", error);
	return 0;
}

public TQuery_OnEquipTrail(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				.259788.CreateTrailEntity(client, sName, true);
			}
			SetTrieString(41860[client], "Trails", sName, true);
			.128784.DisplayTrailsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on a client equipping a trail item: %s", error);
	return 0;
}

public TQuery_OnUnequipTrail(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Trails");
			.261540.RemoveTrailEntity(client);
			.13572.CPrintToChat(client, "%t", "trail unequipped");
			.128784.DisplayTrailsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a trail item: %s", error);
	return 0;
}

.133528.DisplayWeaponRelatedInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_WeaponRelatedInv, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory weapon related menu");
	new ExpirationDate = 15244[client];
	new DaysLeft = ExpirationDate - GetTime({0,0}) / 86400;
	new var1;
	if (38428[client])
	{
		var1 = 63232;
	}
	else
	{
		var1 = 63236;
	}
	new var2;
	if (g_var31e4 && 14452[client])
	{
		var3 = 0;
	}
	else
	{
		var3 = 6;
	}
	.35744.AddMenuItemFormat(hMenu, "AutomatedPistols", var3, "Automated Pistols [%s][%d]", var1, DaysLeft);
	if (g_var3238)
	{
		AddMenuItem(hMenu, "Grenade Models", "Grenade Models", 0);
	}
	if (g_var321c)
	{
		new var4;
		if (16036[client])
		{
			var4 = 0;
		}
		else
		{
			var4 = 1;
		}
		AddMenuItem(hMenu, "Weapon Colors", "Weapon Colors", var4);
	}
	if (g_var3228)
	{
		new var5;
		if (16300[client])
		{
			var5 = 0;
		}
		else
		{
			var5 = 1;
		}
		AddMenuItem(hMenu, "Grenade Trails", "Grenade Trails", var5);
	}
	if (g_var322c)
	{
		new var6;
		if (16564[client])
		{
			var6 = 0;
		}
		else
		{
			var6 = 1;
		}
		AddMenuItem(hMenu, "Tracers", "Tracers", var6);
	}
	if (g_var3230)
	{
		new var7;
		if (16828[client])
		{
			var7 = 0;
		}
		else
		{
			var7 = 1;
		}
		AddMenuItem(hMenu, "Laser Sights", "Laser Sight", var7);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_WeaponRelatedInv(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			if (.3076.StrEqual(sInfo, "AutomatedPistols", true))
			{
				new var1;
				if (38428[param1])
				{
					var1 = 0;
				}
				else
				{
					var1 = 1;
				}
				38428[param1] = var1;
				new var2;
				if (38428[param1])
				{
					var2 = 63432;
				}
				else
				{
					var2 = 63436;
				}
				.13572.CPrintToChat(param1, "%t", "toggle automatic pistols", var2);
				new String:sValue[12];
				IntToString(38428[param1], sValue, 12);
				SetClientCookie(param1, g_vara48c, sValue);
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
				return 0;
			}
			if (.3076.StrEqual(sInfo, "Grenade Models", true))
			{
				.135784.DisplayGrenadeModelsInventoryMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Weapon Colors", true))
				{
					.142304.DisplayWeaponColorsInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Grenade Trails", true))
				{
					.146508.DisplayGrenadeTrailsInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Tracers", true))
				{
					.152792.DisplayTracersInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Laser Sights", true))
				{
					.156996.DisplayLaserSightsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.122680.DisplayInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.135784.DisplayGrenadeModelsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeModelsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory grenade models menu");
	new i;
	while (g_Projectiles.Length > i)
	{
		new String:sEntity[32];
		g_Projectiles.GetString(i, sEntity, 32);
		new String:sDisplay[256];
		g_ProjectileNames.GetString(sEntity, sDisplay, 256, 0);
		AddMenuItem(hMenu, sEntity, sDisplay, 0);
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeModelsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sEntity[32];
			GetMenuItem(menu, param2, sEntity, 32, 0, "", 0);
			.136732.DisplayGrenadeModelsInventoryMenu2(param1, sEntity);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.136732.DisplayGrenadeModelsInventoryMenu2(client, String:sEntity[])
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeModelsInventoryMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory grenade models entity menu", sEntity);
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	new Handle:hTrie;
	new var1;
	if (41860[client] && GetTrieValue(41860[client], "Grenade Models", hTrie) && hTrie)
	{
		bEquipped = GetTrieString(hTrie, sEntity, sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7bc) > i)
	{
		new Handle:hTrie2 = GetArrayCell(g_vara7bc, i, 0, false);
		if (hTrie2)
		{
			new String:sName[256];
			GetTrieString(hTrie2, "name", sName, 256, 0);
			new String:sEntity2[64];
			GetTrieString(hTrie2, "entity", sEntity2, 64, 0);
			new find = FindStringInArray(41332[client], sName);
			new var2;
			if (find != -1 && .3076.StrEqual(sEntity, sEntity2, true))
			{
				new var3;
				if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
				{
					var4 = 63688;
				}
				else
				{
					var4 = 63692;
				}
				.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var4);
			}
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35896.PushMenuString(hMenu, "entity", sEntity);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeModelsInventoryMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new String:sEntity[32];
			.35952.GetMenuString(menu, "entity", sEntity, 32);
			if (41860[param1])
			{
				new Handle:hTrie2;
				new var1;
				if (41860[param1] && GetTrieValue(41860[param1], "Grenade Models", hTrie2) && hTrie2)
				{
					new String:sName2[256];
					new var2;
					if (GetTrieString(hTrie2, sEntity, sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
					{
						.13572.CPrintToChat(param1, "%t", "item already equipped");
						.136732.DisplayGrenadeModelsInventoryMenu2(param1, sEntity);
						return 0;
					}
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new Handle:hTrie;
					new var3;
					if (41860[param1] && GetTrieValue(41860[param1], "Grenade Models", hTrie))
					{
						if (hTrie)
						{
							new String:sName2[256];
							GetTrieString(hTrie, sEntity, sName2, 256, 0);
							new Handle:hPack = CreateDataPack();
							WritePackCell(hPack, GetClientUserId(param1));
							WritePackString(hPack, sName2);
							WritePackString(hPack, sEntity);
							WritePackCell(hPack, hTrie);
							new String:sQuery[4096];
							Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Grenade Models' AND entity = '%s';", "hellonearth_store_equipped", 13924[param1], sName2, sEntity);
							SQL_TQuery(g_var35e4, TQuery_OnUnequipGrenadeModel, sQuery, hPack, DBPriority:1);
						}
						.13572.CPrintToChat(param1, "%t", "error changing grenade models loadout data", sEntity);
						.136732.DisplayGrenadeModelsInventoryMenu2(param1, sEntity);
						return 0;
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.136732.DisplayGrenadeModelsInventoryMenu2(param1, sEntity);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				WritePackString(hPack, sEntity);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Grenade Models' AND entity = '%s';", "hellonearth_store_equipped", 13924[param1], sEntity);
				SQL_TQuery(g_var35e4, TQuery_OnCheckGrenadeModelEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing grenade models loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.135784.DisplayGrenadeModelsInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckGrenadeModelEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Grenade Models' AND player_id = '%i' AND entity = '%s';", "hellonearth_store_equipped", sName, 13924[client], sEntity);
			SQL_TQuery(g_var35e4, TQuery_OnEquipGrenadeModel, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type, entity) VALUES ('%i', '%s', 'Grenade Models', '%s');", "hellonearth_store_equipped", 13924[client], sName, sEntity);
			SQL_TQuery(g_var35e4, TQuery_OnEquipGrenadeModel, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a trail item: %s", error);
	return 0;
}

public TQuery_OnEquipGrenadeModel(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			new Handle:hTrie;
			new var2;
			if (GetTrieValue(41860[client], "Grenade Models", hTrie) && hTrie)
			{
				SetTrieString(hTrie, sEntity, sName, true);
			}
			.136732.DisplayGrenadeModelsInventoryMenu2(client, sEntity);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a grenade model: %s", error);
	return 0;
}

public TQuery_OnUnequipGrenadeModel(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[64];
		ReadPackString(data, sEntity, 64);
		new Handle:hTrie = ReadPackCell(data);
		CloseHandle(data);
		if (0 < client)
		{
			if (hTrie)
			{
				RemoveFromTrie(hTrie, sEntity);
			}
			.13572.CPrintToChat(client, "%t", "grenade model unequipped", sEntity);
			.136732.DisplayGrenadeModelsInventoryMenu2(client, sEntity);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a grenade model item: %s", error);
	return 0;
}

.142304.DisplayWeaponColorsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayWeaponColorsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory weapon colors menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Weapon Colors", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7c4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7c4, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 64620;
			}
			else
			{
				var2 = 64624;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayWeaponColorsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Weapon Colors", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.142304.DisplayWeaponColorsInventoryMenu(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Weapon Colors", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Weapon Colors';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipWeaponColor, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.142304.DisplayWeaponColorsInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Weapon Colors';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckWeaponColorEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing weapon colors loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckWeaponColorEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Weapon Colors' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipWeaponColor, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Weapon Colors');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipWeaponColor, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a weapon color item: %s", error);
	return 0;
}

public TQuery_OnEquipWeaponColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Weapon Colors", sName, true);
			.142304.DisplayWeaponColorsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a weapon color: %s", error);
	return 0;
}

public TQuery_OnUnequipWeaponColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Weapon Colors");
			.13572.CPrintToChat(client, "%t", "weapon color unequipped");
			.142304.DisplayWeaponColorsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a weapon color item: %s", error);
	return 0;
}

.146508.DisplayGrenadeTrailsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeTrailsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory grenade trails menu");
	new i;
	while (g_Projectiles.Length > i)
	{
		new String:sEntity[32];
		g_Projectiles.GetString(i, sEntity, 32);
		new String:sDisplay[256];
		g_ProjectileNames.GetString(sEntity, sDisplay, 256, 0);
		AddMenuItem(hMenu, sEntity, sDisplay, 0);
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeTrailsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sEntity[32];
			GetMenuItem(menu, param2, sEntity, 32, 0, "", 0);
			.147456.DisplayGrenadeTrailsInventoryMenu2(param1, sEntity);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.147456.DisplayGrenadeTrailsInventoryMenu2(client, String:sEntity[])
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeTrailsInventoryMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory grenade trails entity menu", sEntity);
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	new Handle:hTrie;
	new var1;
	if (41860[client] && GetTrieValue(41860[client], "Grenade Trails", hTrie) && hTrie)
	{
		bEquipped = GetTrieString(hTrie, sEntity, sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7cc) > i)
	{
		new Handle:hTrie2 = GetArrayCell(g_vara7cc, i, 0, false);
		if (hTrie2)
		{
			new String:sName[256];
			GetTrieString(hTrie2, "name", sName, 256, 0);
			new String:sEntity2[64];
			GetTrieString(hTrie2, "entity", sEntity2, 64, 0);
			if (.3076.StrEqual(sEntity, sEntity2, true))
			{
				new var2;
				if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
				{
					var3 = 65504;
				}
				else
				{
					var3 = 65508;
				}
				.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var3);
			}
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35896.PushMenuString(hMenu, "entity", sEntity);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeTrailsInventoryMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new String:sEntity[32];
			.35952.GetMenuString(menu, "entity", sEntity, 32);
			if (41860[param1])
			{
				new Handle:hTrie2;
				new var1;
				if (41860[param1] && GetTrieValue(41860[param1], "Grenade Trails", hTrie2) && hTrie2)
				{
					new String:sName2[256];
					new var2;
					if (GetTrieString(hTrie2, sEntity, sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
					{
						.13572.CPrintToChat(param1, "%t", "item already equipped");
						.147456.DisplayGrenadeTrailsInventoryMenu2(param1, sEntity);
						return 0;
					}
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new Handle:hTrie;
					new var3;
					if (41860[param1] && GetTrieValue(41860[param1], "Grenade Trails", hTrie))
					{
						if (hTrie)
						{
							new Handle:hPack = CreateDataPack();
							WritePackCell(hPack, GetClientUserId(param1));
							WritePackString(hPack, sName);
							WritePackString(hPack, sEntity);
							WritePackCell(hPack, hTrie);
							new String:sQuery[4096];
							Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Grenade Trails' AND entity = '%s';", "hellonearth_store_equipped", 13924[param1], sName, sEntity);
							SQL_TQuery(g_var35e4, TQuery_OnUnequipGrenadeTrail, sQuery, hPack, DBPriority:1);
						}
						.13572.CPrintToChat(param1, "%t", "error changing grenade trails loadout data", sEntity);
						.147456.DisplayGrenadeTrailsInventoryMenu2(param1, sEntity);
						return 0;
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.136732.DisplayGrenadeModelsInventoryMenu2(param1, sEntity);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				WritePackString(hPack, sEntity);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Grenade Trails' AND entity = '%s';", "hellonearth_store_equipped", 13924[param1], sEntity);
				SQL_TQuery(g_var35e4, TQuery_OnCheckGrenadeTrailEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing grenade trails loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckGrenadeTrailEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Grenade Trails' AND player_id = '%i' AND entity = '%s';", "hellonearth_store_equipped", sName, 13924[client], sEntity);
			SQL_TQuery(g_var35e4, TQuery_OnEquipGrenadeTrail, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type, entity) VALUES ('%i', '%s', 'Grenade Trails', '%s');", "hellonearth_store_equipped", 13924[client], sName, sEntity);
			SQL_TQuery(g_var35e4, TQuery_OnEquipGrenadeTrail, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a grenade trail item: %s", error);
	return 0;
}

public TQuery_OnEquipGrenadeTrail(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			new Handle:hTrie;
			new var2;
			if (GetTrieValue(41860[client], "Grenade Trails", hTrie) && hTrie)
			{
				SetTrieString(hTrie, sEntity, sName, true);
			}
			.146508.DisplayGrenadeTrailsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a grenade trail: %s", error);
	return 0;
}

public TQuery_OnUnequipGrenadeTrail(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sEntity[64];
		ReadPackString(data, sEntity, 64);
		new Handle:hTrie = ReadPackCell(data);
		CloseHandle(data);
		if (0 < client)
		{
			if (hTrie)
			{
				RemoveFromTrie(hTrie, sEntity);
			}
			.13572.CPrintToChat(client, "%t", "grenade trails unequipped", sEntity);
			.136732.DisplayGrenadeModelsInventoryMenu2(client, sEntity);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a grenade trail item: %s", error);
	return 0;
}

.152792.DisplayTracersInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayTracersInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory tracers menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Tracers", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7d4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7d4, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 66432;
			}
			else
			{
				var2 = 66436;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayTracersInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Tracers", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.152792.DisplayTracersInventoryMenu(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Tracers", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Tracers';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipTracer, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.152792.DisplayTracersInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Tracers';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckTracerEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing tracers loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckTracerEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Tracers' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipTracer, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Tracers');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipTracer, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a tracer item: %s", error);
	return 0;
}

public TQuery_OnEquipTracer(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Tracers", sName, true);
			.152792.DisplayTracersInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a tracer: %s", error);
	return 0;
}

public TQuery_OnUnequipTracer(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Tracers");
			.13572.CPrintToChat(client, "%t", "tracers unequipped");
			.152792.DisplayTracersInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a tracer item: %s", error);
	return 0;
}

.156996.DisplayLaserSightsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayLaserSightsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory laser sights menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Laser Sights", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7dc) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7dc, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 67160;
			}
			else
			{
				var2 = 67164;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayLaserSightsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Laser Sights", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.156996.DisplayLaserSightsInventoryMenu(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Laser Sights", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Laser Sights';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipLaserSight, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.156996.DisplayLaserSightsInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Laser Sights';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckLaserSightEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing laser sights loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.133528.DisplayWeaponRelatedInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckLaserSightEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Laser Sights' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipLaserSight, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Laser Sights');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipLaserSight, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a laser sight item: %s", error);
	return 0;
}

public TQuery_OnEquipLaserSight(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Laser Sights", sName, true);
			.156996.DisplayLaserSightsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a laser sight: %s", error);
	return 0;
}

public TQuery_OnUnequipLaserSight(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Laser Sights");
			.13572.CPrintToChat(client, "%t", "laser sights unequipped");
			.156996.DisplayLaserSightsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a laser sight item: %s", error);
	return 0;
}

.161200.DisplayFunStuffInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_FunStuffInv, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory fun stuff menu");
	if (g_var3220)
	{
		new var1;
		if (17092[client])
		{
			var1 = 0;
		}
		else
		{
			var1 = 1;
		}
		AddMenuItem(hMenu, "Chat Colors", "Chat Colors", var1);
	}
	if (g_var3224)
	{
		new var2;
		if (17356[client])
		{
			var2 = 0;
		}
		else
		{
			var2 = 1;
		}
		AddMenuItem(hMenu, "Name Colors", "Name Colors", var2);
	}
	if (g_var3234)
	{
		new var3;
		if (17620[client])
		{
			var3 = 0;
		}
		else
		{
			var3 = 1;
		}
		AddMenuItem(hMenu, "Custom Tag", "Custom Tag", var3);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_FunStuffInv(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Chat Colors", true))
			{
				.162296.DisplayChatColorsInventoryMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Name Colors", true))
				{
					.167120.DisplayNameColorsInventoryMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Custom Tag", true))
				{
					.171944.DisplayCustomTagsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.122680.DisplayInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.162296.DisplayChatColorsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayChatColorsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory chat colors menu");
	AddMenuItem(hMenu, "Select Color", "Select Color", 0);
	AddMenuItem(hMenu, "Restore Default", "Restore Default", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayChatColorsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Select Color", true))
			{
				.163592.DisplayChatColorsInventoryMenu2(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Restore Default", true))
				{
					new String:sName[256];
					new var1;
					if (41860[param1] && GetTrieString(41860[param1], "Chat Colors", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Chat Colors';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipChatColor, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
					}
					.162296.DisplayChatColorsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.163592.DisplayChatColorsInventoryMenu2(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayChatColorsInventoryMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory chat colors select menu");
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Chat Colors", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7e4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7e4, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 68332;
			}
			else
			{
				var2 = 68336;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayChatColorsInventoryMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Chat Colors", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.163592.DisplayChatColorsInventoryMenu2(param1);
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Chat Colors';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckChatColorEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing chat colors loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.162296.DisplayChatColorsInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckChatColorEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Chat Colors' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipChatColor, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Chat Colors');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipChatColor, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a chat color item: %s", error);
	return 0;
}

public TQuery_OnEquipChatColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Chat Colors", sName, true);
			.162296.DisplayChatColorsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a chat color: %s", error);
	return 0;
}

public TQuery_OnUnequipChatColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Chat Colors");
			.13572.CPrintToChat(client, "%t", "default chat color restored");
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a chat color item: %s", error);
	return 0;
}

.167120.DisplayNameColorsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayNameColorsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory name colors menu");
	AddMenuItem(hMenu, "Select Color", "Select Color", 0);
	AddMenuItem(hMenu, "Restore Default", "Restore Default", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayNameColorsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Select Color", true))
			{
				.168416.DisplayNameColorsInventoryMenu2(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Restore Default", true))
				{
					new String:sName[256];
					new var1;
					if (41860[param1] && GetTrieString(41860[param1], "Name Colors", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Name Colors';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipNameColor, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
					}
					.167120.DisplayNameColorsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.168416.DisplayNameColorsInventoryMenu2(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayNameColorsInventoryMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory name colors select menu");
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Name Colors", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7ec) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7ec, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 69204;
			}
			else
			{
				var2 = 69208;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayNameColorsInventoryMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Name Colors", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.168416.DisplayNameColorsInventoryMenu2(param1);
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Name Colors';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckNameColorEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing name colors loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckNameColorEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Name Colors' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipNameColor, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Name Colors');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipNameColor, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a name color item: %s", error);
	return 0;
}

public TQuery_OnEquipNameColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Name Colors", sName, true);
			.167120.DisplayNameColorsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a name color: %s", error);
	return 0;
}

public TQuery_OnUnequipNameColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Name Colors");
			.13572.CPrintToChat(client, "%t", "default name color restored");
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a name color item: %s", error);
	return 0;
}

.171944.DisplayCustomTagsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayCustomTagsInventoryMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory custom tags menu");
	AddMenuItem(hMenu, "Set Tag", "Set Tag", 0);
	AddMenuItem(hMenu, "Select Color", "Select Color", 0);
	AddMenuItem(hMenu, "Restore Default", "Restore Default", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayCustomTagsInventoryMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Set Tag", true))
			{
				.173364.DisplayCustomTagsInventoryMenu2(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Select Color", true))
				{
					.177608.DisplayCustomTagsInventoryMenu3(param1);
				}
				if (.3076.StrEqual(sInfo, "Restore Default", true))
				{
					new String:sName[256];
					new var1;
					if (41860[param1] && GetTrieString(41860[param1], "Custom Tags Colors", sName, 256, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Custom Tags Colors';", "hellonearth_store_equipped", 13924[param1], sName);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipCustomTagColor, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
					}
					.171944.DisplayCustomTagsInventoryMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.173364.DisplayCustomTagsInventoryMenu2(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayCustomTagsInventoryMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory custom tags select menu");
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Custom Tags", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7f4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7f4, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 70144;
			}
			else
			{
				var2 = 70148;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayCustomTagsInventoryMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Custom Tags", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.173364.DisplayCustomTagsInventoryMenu2(param1);
					return 0;
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new String:sName3[32];
					new var2;
					if (41860[param1] && GetTrieString(41860[param1], "Custom Tags", sName3, 32, 0))
					{
						new Handle:hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(param1));
						WritePackString(hPack, sName3);
						new String:sQuery[4096];
						Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Custom Tags';", "hellonearth_store_equipped", 13924[param1], sName2);
						SQL_TQuery(g_var35e4, TQuery_OnUnequipCustomTags, sQuery, hPack, DBPriority:1);
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.171944.DisplayCustomTagsInventoryMenu(param1);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Custom Tags';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckCustomTagEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing custom tags loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnUnequipCustomTags(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Custom Tags");
			.13572.CPrintToChat(client, "%t", "custom tag unequipped");
			.171944.DisplayCustomTagsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a custom tag item: %s", error);
	return 0;
}

public TQuery_OnCheckCustomTagEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Custom Tags' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipCustomTag, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Custom Tags');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipCustomTag, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a custom tag item: %s", error);
	return 0;
}

public TQuery_OnEquipCustomTag(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Custom Tags", sName, true);
			.171944.DisplayCustomTagsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a custom tag: %s", error);
	return 0;
}

.177608.DisplayCustomTagsInventoryMenu3(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayCustomTagsInventoryMenu3, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory custom tags colors select menu");
	new String:sEquipped[256];
	new bool:bEquipped;
	if (41860[client])
	{
		bEquipped = GetTrieString(41860[client], "Custom Tags Colors", sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara7fc) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7fc, i, 0, false);
		if (hTrie)
		{
			new String:sName[256];
			GetTrieString(hTrie, "name", sName, 256, 0);
			new var1;
			if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
			{
				var2 = 70912;
			}
			else
			{
				var2 = 70916;
			}
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var2);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayCustomTagsInventoryMenu3(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new String:sName2[256];
				new var1;
				if (41860[param1] && GetTrieString(41860[param1], "Custom Tags Colors", sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
				{
					.13572.CPrintToChat(param1, "%t", "item already equipped");
					.177608.DisplayCustomTagsInventoryMenu3(param1);
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Custom Tags Colors';", "hellonearth_store_equipped", 13924[param1]);
				SQL_TQuery(g_var35e4, TQuery_OnCheckCustomTagColorEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing custom tags colors loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.161200.DisplayFunStuffInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckCustomTagColorEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Custom Tags Colors' AND player_id = '%i';", "hellonearth_store_equipped", sName, 13924[client]);
			SQL_TQuery(g_var35e4, TQuery_OnEquipCustomTagColor, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type) VALUES ('%i', '%s', 'Custom Tags Colors');", "hellonearth_store_equipped", 13924[client], sName);
			SQL_TQuery(g_var35e4, TQuery_OnEquipCustomTagColor, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a custom tag color item: %s", error);
	return 0;
}

public TQuery_OnEquipCustomTagColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			SetTrieString(41860[client], "Custom Tags Colors", sName, true);
			.171944.DisplayCustomTagsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a custom tag color: %s", error);
	return 0;
}

public TQuery_OnUnequipCustomTagColor(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		CloseHandle(data);
		if (0 < client)
		{
			RemoveFromTrie(41860[client], "Custom Tags Colors");
			.13572.CPrintToChat(client, "%t", "default tag color restored");
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a custom tag color item: %s", error);
	return 0;
}

.181136.DisplayPlayerModelsInventoryMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_PlayerModelsInv, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory player models menu");
	AddMenuItem(hMenu, "2", "Terrorists", 0);
	AddMenuItem(hMenu, "3", "Counter Terrorists", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_PlayerModelsInv(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			.181780.DisplayPlayerModelsInventoryMenu2(param1, StringToInt(sInfo, 10));
		}
		case 8:
		{
			if (param2 == -6)
			{
				.122680.DisplayInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.181780.DisplayPlayerModelsInventoryMenu2(client, iTeam)
{
	new String:sTeam[32];
	GetTeamName(iTeam, sTeam, 32);
	new Handle:hMenu = CreateMenu(MenuHandle_PlayerModelsInv2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store inventory player models team menu", sTeam);
	AddMenuItem(hMenu, "Unequip123456789", "Unequip", 0);
	new String:sEquipped[256];
	new bool:bEquipped;
	new Handle:hTrie;
	new var1;
	if (41860[client] && GetTrieValue(41860[client], "Player Models", hTrie) && hTrie)
	{
		new String:sTeam2[12];
		IntToString(iTeam, sTeam2, 12);
		bEquipped = GetTrieString(hTrie, sTeam2, sEquipped, 256, 0);
	}
	new i;
	while (GetArraySize(g_vara804) > i)
	{
		new Handle:hTrie2 = GetArrayCell(g_vara804, i, 0, false);
		if (hTrie2)
		{
			new String:sName[256];
			GetTrieString(hTrie2, "name", sName, 256, 0);
			new team;
			GetTrieValue(hTrie2, "team", team);
			if (team == iTeam)
			{
				new find = -1;
				if (41332[client])
				{
					find = FindStringInArray(41332[client], sName);
					new String:sType[256];
					new var2;
					if (41596[client] && find != -1 && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Player Models", true))
					{
						find = -1;
					}
				}
				if (find != -1)
				{
					new var3;
					if (bEquipped && .3076.StrEqual(sName, sEquipped, true))
					{
						var4 = 71728;
					}
					else
					{
						var4 = 71732;
					}
					.35744.AddMenuItemFormat(hMenu, sName, 0, "%s %s", sName, var4);
				}
			}
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35208.PushMenuCell(hMenu, "team", iTeam);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_PlayerModelsInv2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			if (41860[param1])
			{
				new iTeam = .35348.GetMenuCell(menu, "team", 0);
				new String:sTeam[12];
				IntToString(iTeam, sTeam, 12);
				new Handle:hTrie2;
				new var1;
				if (41860[param1] && GetTrieValue(41860[param1], "Player Models", hTrie2) && hTrie2)
				{
					new String:sName2[256];
					new var2;
					if (GetTrieString(hTrie2, sTeam, sName2, 256, 0) && .3076.StrEqual(sName, sName2, true))
					{
						.13572.CPrintToChat(param1, "%t", "item already equipped");
						.181780.DisplayPlayerModelsInventoryMenu2(param1, iTeam);
						return 0;
					}
				}
				if (.3076.StrEqual(sName, "Unequip123456789", true))
				{
					new Handle:hTrie;
					new var3;
					if (41860[param1] && GetTrieValue(41860[param1], "Player Models", hTrie))
					{
						if (hTrie)
						{
							new String:sName2[32];
							GetTrieString(hTrie, sTeam, sName2, 32, 0);
							new Handle:hPack = CreateDataPack();
							WritePackCell(hPack, GetClientUserId(param1));
							WritePackString(hPack, sName2);
							WritePackString(hPack, sTeam);
							WritePackCell(hPack, iTeam);
							WritePackCell(hPack, hTrie);
							new String:sQuery[4096];
							Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = 'Player Models' AND team = '%i';", "hellonearth_store_equipped", 13924[param1], sName2, iTeam);
							SQL_TQuery(g_var35e4, TQuery_OnUnequipPlayerModel, sQuery, hPack, DBPriority:1);
						}
						.13572.CPrintToChat(param1, "%t", "error changing player models loadout data", iTeam);
						.181780.DisplayPlayerModelsInventoryMenu2(param1, iTeam);
						return 0;
					}
					else
					{
						.13572.CPrintToChat(param1, "%t", "no item equipped");
						.181780.DisplayPlayerModelsInventoryMenu2(param1, iTeam);
					}
					return 0;
				}
				new Handle:hPack = CreateDataPack();
				WritePackCell(hPack, GetClientUserId(param1));
				WritePackString(hPack, sName);
				WritePackCell(hPack, iTeam);
				WritePackString(hPack, sTeam);
				new String:sQuery[4096];
				Format(sQuery, 4096, "SELECT * FROM `%s` WHERE player_id = '%i' AND type = 'Player Models' AND team = '%i';", "hellonearth_store_equipped", 13924[param1], iTeam);
				SQL_TQuery(g_var35e4, TQuery_OnCheckPlayerModelEquip, sQuery, hPack, DBPriority:1);
			}
			.13572.CPrintToChat(param1, "%t", "error changing player models colors loadout");
			return 0;
		}
		case 8:
		{
			if (param2 == -6)
			{
				.181136.DisplayPlayerModelsInventoryMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnCheckPlayerModelEquip(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new iTeam = ReadPackCell(data);
		new String:sTeam[12];
		ReadPackString(data, sTeam, 12);
		if (SQL_FetchRow(hndl))
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "UPDATE `%s` SET name = '%s' WHERE type = 'Player Models' AND player_id = '%i' AND team = '%i';", "hellonearth_store_equipped", sName, 13924[client], iTeam);
			SQL_TQuery(g_var35e4, TQuery_OnEquipPlayerModel, sQuery, data, DBPriority:1);
		}
		else
		{
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type, team) VALUES ('%i', '%s', 'Player Models', '%i');", "hellonearth_store_equipped", 13924[client], sName, iTeam);
			SQL_TQuery(g_var35e4, TQuery_OnEquipPlayerModel, sQuery, data, DBPriority:1);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client check to equip a player model item: %s", error);
	return 0;
}

public TQuery_OnEquipPlayerModel(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new iTeam = ReadPackCell(data);
		new String:sTeam[12];
		ReadPackString(data, sTeam, 12);
		CloseHandle(data);
		new var1;
		if (client > 0 && IsClientInGame(client))
		{
			new Handle:hTrie;
			new var2;
			if (GetTrieValue(41860[client], "Player Models", hTrie) && hTrie)
			{
				SetTrieString(hTrie, sTeam, sName, true);
				if (IsPlayerAlive(client))
				{
					.263964.SetPlayerModel(client, iTeam, true);
				}
			}
			.181136.DisplayPlayerModelsInventoryMenu(client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client equipping a player model: %s", error);
	return 0;
}

public TQuery_OnUnequipPlayerModel(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sTeam[12];
		ReadPackString(data, sTeam, 12);
		new iTeam = ReadPackCell(data);
		new Handle:hTrie = ReadPackCell(data);
		CloseHandle(data);
		if (0 < client)
		{
			if (hTrie)
			{
				RemoveFromTrie(hTrie, sTeam);
			}
			.265276.ResetPlayerModel(client);
			new String:sTeamName[32];
			GetTeamName(iTeam, sTeamName, 32);
			.13572.CPrintToChat(client, "%t", "player model unequipped", sTeamName);
			.181780.DisplayPlayerModelsInventoryMenu2(client, iTeam);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on client unequipping a player model item: %s", error);
	return 0;
}

.188096.DisplayStoreMenu(client)
{
	new var1;
	if (41332[client] && 41860[client])
	{
		.14692.CReplyToCommand(client, "Your data is being fetched, please wait.");
		return 0;
	}
	new Handle:hMenu = CreateMenu(MenuHandle_Store, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store main menu", 14188[client]);
	if (g_var3268)
	{
		AddMenuItem(hMenu, "Hats", "Hats", 0);
	}
	if (g_var326c)
	{
		AddMenuItem(hMenu, "Trails", "Trails", 0);
	}
	AddMenuItem(hMenu, "Weapon Related", "Weapon Related", 0);
	AddMenuItem(hMenu, "Fun Stuff", "Fun Stuff", 0);
	if (g_var3270)
	{
		AddMenuItem(hMenu, "Player Models", "Player Models", 0);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_Store(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Hats", true))
			{
				.189456.DisplayHatsStoreMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Trails", true))
				{
					.191276.DisplayTrailsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Weapon Related", true))
				{
					.193096.DisplayWeaponRelatedStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Fun Stuff", true))
				{
					.203112.DisplayFunStuffStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Player Models", true))
				{
					.208788.DisplayPlayerModelsStoreMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.189456.DisplayHatsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayHatsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store hats menu");
	new i;
	while (GetArraySize(g_vara7ac) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7ac, i, 0, false);
		new bool:bNotDisabled = 1;
		new bool:bTypeCheck = 1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			new find = FindStringInArray(41332[client], sName);
			bNotDisabled = find != -1;
			new String:sType[256];
			new var2;
			if (41596[client] && bNotDisabled && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Hats", true))
			{
				bTypeCheck = false;
			}
		}
		new iPrice;
		GetTrieValue(hTrie, "price", iPrice);
		if (bTypeCheck)
		{
			new var3;
			if (bNotDisabled)
			{
				var3 = 1;
			}
			else
			{
				var3 = 0;
			}
			.35744.AddMenuItemFormat(hMenu, sName, var3, "%s [%i]", sName, iPrice);
		}
		i++;
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayHatsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iIndex;
			GetTrieValue(g_vara7b0, sName, iIndex);
			new Handle:hTrie = GetArrayCell(g_vara7ac, iIndex, 0, false);
			new iPrice;
			new var1;
			if (hTrie && GetTrieValue(hTrie, "price", iPrice))
			{
				if (!.91444.CheckPrice(param1, iPrice))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase");
					.189456.DisplayHatsStoreMenu(param1);
					return 0;
				}
			}
			.211576.DisplayConfirmItemPurchaseMenu(param1, sName, "Hats", iPrice, 0, "");
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.191276.DisplayTrailsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayTrailsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store trails menu");
	new i;
	while (GetArraySize(g_vara7b4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7b4, i, 0, false);
		new bool:bNotDisabled = 1;
		new bool:bTypeCheck = 1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			new find = FindStringInArray(41332[client], sName);
			bNotDisabled = find != -1;
			new String:sType[256];
			new var2;
			if (41596[client] && bNotDisabled && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Trails", true))
			{
				bTypeCheck = false;
			}
		}
		new iPrice;
		GetTrieValue(hTrie, "price", iPrice);
		if (bTypeCheck)
		{
			new var3;
			if (bNotDisabled)
			{
				var3 = 1;
			}
			else
			{
				var3 = 0;
			}
			.35744.AddMenuItemFormat(hMenu, sName, var3, "%s [%i]", sName, iPrice);
		}
		i++;
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayTrailsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iIndex;
			GetTrieValue(g_vara7b8, sName, iIndex);
			new Handle:hTrie = GetArrayCell(g_vara7b4, iIndex, 0, false);
			new iPrice;
			new var1;
			if (hTrie && GetTrieValue(hTrie, "price", iPrice))
			{
				if (!.91444.CheckPrice(param1, iPrice))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase");
					.191276.DisplayTrailsStoreMenu(param1);
					return 0;
				}
			}
			.211576.DisplayConfirmItemPurchaseMenu(param1, sName, "Trails", iPrice, 0, "");
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.193096.DisplayWeaponRelatedStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_WeaponRelated, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store weapons related menu");
	new var1;
	if (g_var31e4 && !14452[client])
	{
		var2 = 0;
	}
	else
	{
		var2 = 1;
	}
	.35744.AddMenuItemFormat(hMenu, "AutomatedPistols", var2, "Automated Pistols [%i][%i]", g_var31cc, g_var31e0);
	if (g_var3238)
	{
		.35744.AddMenuItemFormat(hMenu, "Grenade Models", 0, "Grenade Models");
	}
	if (g_var321c)
	{
		new var3;
		if (!16036[client])
		{
			var3 = 0;
		}
		else
		{
			var3 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Weapon Colors", var3, "Weapon Colors [%i]", g_var31f0);
	}
	if (g_var3228)
	{
		new var4;
		if (!16300[client])
		{
			var4 = 0;
		}
		else
		{
			var4 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Grenade Trails", var4, "Grenade Trails [%i]", g_var31e8);
	}
	if (g_var322c)
	{
		new var5;
		if (!16564[client])
		{
			var5 = 0;
		}
		else
		{
			var5 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Tracers", var5, "Tracers [%i]", g_var31f8);
	}
	if (g_var3230)
	{
		new var6;
		if (!16828[client])
		{
			var6 = 0;
		}
		else
		{
			var6 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Laser Sights", var6, "Laser Sight [%i]", g_var3208);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_WeaponRelated(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			if (.3076.StrEqual(sInfo, "AutomatedPistols", true))
			{
				if (!.91444.CheckPrice(param1, g_var31cc))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase automated pistols");
					.193096.DisplayWeaponRelatedStoreMenu(param1);
					return 0;
				}
				new post = g_var31e0 * 86400;
				new expire = GetTime({0,0}) + post;
				15244[param1] = expire;
				new String:sQuery[4096];
				Format(sQuery, 4096, "UPDATE `%s` SET auto_pistols = '1', auto_pistols_expire = '%i' WHERE id = '%i';", "hellonearth_store_players", expire, 13924[param1]);
				SQL_TQuery(g_var35e4, hQuery_OnPurchasePistols, sQuery, GetClientUserId(param1), DBPriority:1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Grenade Models", true))
				{
					.196452.DisplayGrenadeModelsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Weapon Colors", true))
				{
					if (!.91444.CheckPrice(param1, g_var31f0))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase weapon colors");
						.193096.DisplayWeaponRelatedStoreMenu(param1);
						return 0;
					}
					.199624.DisplayWeaponColorsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Grenade Trails", true))
				{
					if (!.91444.CheckPrice(param1, g_var31e8))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase grenade trails");
						.193096.DisplayWeaponRelatedStoreMenu(param1);
						return 0;
					}
					.200496.DisplayGrenadeTrailsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Tracers", true))
				{
					if (!.91444.CheckPrice(param1, g_var31f8))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase tracers");
						.193096.DisplayWeaponRelatedStoreMenu(param1);
						return 0;
					}
					.201368.DisplayTracersStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Laser Sights", true))
				{
					if (!.91444.CheckPrice(param1, g_var3208))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase laser sights");
						.193096.DisplayWeaponRelatedStoreMenu(param1);
						return 0;
					}
					.202240.DisplayLaserSightsStoreMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public hQuery_OnPurchasePistols(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new client = GetClientOfUserId(data);
	if (hndl)
	{
		if (client < 1)
		{
			return 0;
		}
		if (!.91444.CheckPrice(client, g_var31cc))
		{
			.13572.CPrintToChat(client, "%t", "not enough credits to purchase automated pistols");
			.193096.DisplayWeaponRelatedStoreMenu(client);
			return 0;
		}
		14452[client] = 1;
		.13572.CPrintToChat(client, "%t", "purchased automated pistols");
		.193096.DisplayWeaponRelatedStoreMenu(client);
		return 0;
	}
	new var1;
	if (client > 0 && IsClientInGame(client))
	{
		.193096.DisplayWeaponRelatedStoreMenu(client);
		.13572.CPrintToChat(client, "%t", "error purchasing automated pistols");
	}
	LogError("Error on client purchasing pistols: %s", error);
	return 0;
}

.196452.DisplayGrenadeModelsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeModelsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store grenade models menu");
	new i;
	while (g_Projectiles.Length > i)
	{
		new String:sEntity[32];
		g_Projectiles.GetString(i, sEntity, 32);
		new String:sDisplay[256];
		g_ProjectileNames.GetString(sEntity, sDisplay, 256, 0);
		AddMenuItem(hMenu, sEntity, sDisplay, 0);
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeModelsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sEntity[32];
			GetMenuItem(menu, param2, sEntity, 32, 0, "", 0);
			.197400.DisplayGrenadeModelsStoreMenu2(param1, sEntity);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.197400.DisplayGrenadeModelsStoreMenu2(client, String:sEntity[])
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeModelsStoreMenu2, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store grenade models entity menu", sEntity);
	new i;
	while (GetArraySize(g_vara7bc) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7bc, i, 0, false);
		new bool:bNotDisabled = 1;
		new bool:bTypeCheck = 1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			new find = FindStringInArray(41332[client], sName);
			bNotDisabled = find != -1;
			new String:sType[256];
			new var2;
			if (41596[client] && bNotDisabled && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Grenade Models", true))
			{
				bTypeCheck = false;
			}
		}
		new iPrice;
		GetTrieValue(hTrie, "price", iPrice);
		new String:sEntity2[32];
		GetTrieString(hTrie, "entity", sEntity2, 32, 0);
		new var3;
		if (bTypeCheck && .3076.StrEqual(sEntity, sEntity2, true))
		{
			new var4;
			if (bNotDisabled)
			{
				var4 = 1;
			}
			else
			{
				var4 = 0;
			}
			.35744.AddMenuItemFormat(hMenu, sName, var4, "%s [%i]", sName, iPrice);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35896.PushMenuString(hMenu, "entity", sEntity);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeModelsStoreMenu2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iIndex;
			GetTrieValue(g_vara7c0, sName, iIndex);
			new Handle:hTrie = GetArrayCell(g_vara7bc, iIndex, 0, false);
			new iPrice;
			new var1;
			if (hTrie && GetTrieValue(hTrie, "price", iPrice))
			{
				if (!.91444.CheckPrice(param1, iPrice))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase");
					.191276.DisplayTrailsStoreMenu(param1);
					return 0;
				}
			}
			new String:sEntity[32];
			.35952.GetMenuString(menu, "entity", sEntity, 32);
			.211576.DisplayConfirmItemPurchaseMenu(param1, sName, "Grenade Models", iPrice, 0, sEntity);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.196452.DisplayGrenadeModelsStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.199624.DisplayWeaponColorsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayWeaponColorsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase weapon colors menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayWeaponColorsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var31f0))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase weapon colors");
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Weapon Colors", "weapon_colors", "weapon_colors_expire", g_var31f0, g_var31f4);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.200496.DisplayGrenadeTrailsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayGrenadeTrailsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase grenade trails menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayGrenadeTrailsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var31e8))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase grenade trails");
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Grenade Trails", "grenade_trails", "grenade_trails_expire", g_var31e8, g_var31ec);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.201368.DisplayTracersStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayTracersStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase tracers menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayTracersStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var31f8))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase tracers");
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Tracers", "tracers", "tracers_expire", g_var31f8, g_var31fc);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.202240.DisplayLaserSightsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayLaserSightsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase laser sights menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayLaserSightsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var3208))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase laser sights");
				.193096.DisplayWeaponRelatedStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Laser Sights", "laser_sights", "laser_sights_expire", g_var3208, g_var320c);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.193096.DisplayWeaponRelatedStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.203112.DisplayFunStuffStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_FunStuff, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store fun stuff menu");
	if (g_var3264)
	{
		.35744.AddMenuItemFormat(hMenu, "Respawn", 0, "Respawn [%i]", g_var319c);
	}
	if (g_var3220)
	{
		new var1;
		if (!17092[client])
		{
			var1 = 0;
		}
		else
		{
			var1 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Chat Colors", var1, "Chat Colors [%i]", g_var31d4);
	}
	if (g_var3224)
	{
		new var2;
		if (!17356[client])
		{
			var2 = 0;
		}
		else
		{
			var2 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Name Colors", var2, "Name Colors [%i]", g_var31dc);
	}
	if (g_var3234)
	{
		new var3;
		if (!17620[client])
		{
			var3 = 0;
		}
		else
		{
			var3 = 1;
		}
		.35744.AddMenuItemFormat(hMenu, "Custom Tag", var3, "Custom Tag [%i]", g_var3210);
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "[No Items Available]", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_FunStuff(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Respawn", true))
			{
				if (38956[param1])
				{
					.203112.DisplayFunStuffStoreMenu(param1);
					return 0;
				}
				if (GetClientTeam(param1) < 2)
				{
					.13572.CPrintToChat(param1, "%t", "respawn no spectators");
					.203112.DisplayFunStuffStoreMenu(param1);
					return 0;
				}
				if (IsPlayerAlive(param1))
				{
					.13572.CPrintToChat(param1, "%t", "respawn must be dead");
					.203112.DisplayFunStuffStoreMenu(param1);
					return 0;
				}
				if (!.91444.CheckPrice(param1, g_var319c))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase respawns");
					.203112.DisplayFunStuffStoreMenu(param1);
					return 0;
				}
				if (0 >= 38692[param1])
				{
					.13572.CPrintToChat(param1, "%t", "all respawns used this round");
					.203112.DisplayFunStuffStoreMenu(param1);
					return 0;
				}
				.82392.RemoveClientCredits(param1, g_var319c, false);
				38692[param1]--;
				.13572.CPrintToChat(param1, "%t", "purchased respawn", g_var319c, 38692[param1], .2920.RoundFloat(g_var3194));
				.14112.CPrintToChatAll("%t", "purchase respawn global", param1, .2920.RoundFloat(g_var3194));
				38956[param1] = CreateTimer(g_var3194, DelayedRespawnTimer, GetClientUserId(param1), 2);
				.203112.DisplayFunStuffStoreMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Chat Colors", true))
				{
					if (!.91444.CheckPrice(param1, g_var31d4))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase chat colors");
						.203112.DisplayFunStuffStoreMenu(param1);
						return 0;
					}
					.206172.DisplayChatColorsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Name Colors", true))
				{
					if (!.91444.CheckPrice(param1, g_var31dc))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase name colors");
						.203112.DisplayFunStuffStoreMenu(param1);
						return 0;
					}
					.207044.DisplayNameColorsStoreMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Custom Tag", true))
				{
					if (!.91444.CheckPrice(param1, g_var3210))
					{
						.13572.CPrintToChat(param1, "%t", "not enough credits to purchase custom tags");
						.203112.DisplayFunStuffStoreMenu(param1);
						return 0;
					}
					.207916.DisplayCustomTagsStoreMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public DelayedRespawnTimer(Handle:hTimer, any:data)
{
	new client = GetClientOfUserId(data);
	new var1;
	if (client > 0 && IsClientInGame(client))
	{
		if (!IsPlayerAlive(client))
		{
			CS_RespawnPlayer(client);
		}
		38956[client] = 0;
	}
	return 0;
}

.206172.DisplayChatColorsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayChatColorsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase chat colors menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayChatColorsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var31d4))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase chat colors");
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Chat Colors", "chat_colors", "chat_colors_expire", g_var31d4, g_var31d0);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.203112.DisplayFunStuffStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.207044.DisplayNameColorsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayNameColorsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase name colors menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayNameColorsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var31dc))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase name colors");
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Name Colors", "name_colors", "name_colors_expire", g_var31dc, g_var31d8);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.203112.DisplayFunStuffStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.207916.DisplayCustomTagsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayCustomTagsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase custom tags menu");
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayCustomTagsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			if (!.91444.CheckPrice(param1, g_var3210))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase custom tags");
				.203112.DisplayFunStuffStoreMenu(param1);
				return 0;
			}
			.217732.PurchaseGlobalPackage(param1, "Custom Tags", "custom_tags", "custom_tags_expire", g_var3210, g_var3214);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.203112.DisplayFunStuffStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.208788.DisplayPlayerModelsStoreMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_PlayerModels, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store player models menu");
	AddMenuItem(hMenu, "2", "Terrorists", 0);
	AddMenuItem(hMenu, "3", "Counter Terrorists", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_PlayerModels(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			.209432.DisplayPlayerModelsStoreMenu2(param1, StringToInt(sInfo, 10));
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.209432.DisplayPlayerModelsStoreMenu2(client, iTeam2)
{
	new String:sTeam[32];
	GetTeamName(iTeam2, sTeam, 32);
	new Handle:hMenu = CreateMenu(MenuHandle_DisplayPlayerModelsStoreMenu, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "store store player models team menu", sTeam);
	new i;
	while (GetArraySize(g_vara804) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara804, i, 0, false);
		new bool:bNotDisabled = 1;
		new bool:bTypeCheck = 1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			new find = FindStringInArray(41332[client], sName);
			bNotDisabled = find != -1;
			new String:sType[256];
			new var2;
			if (41596[client] && bNotDisabled && GetArrayString(41596[client], find, sType, 256) && !.3076.StrEqual(sType, "Player Models", true))
			{
				bTypeCheck = false;
			}
		}
		new iPrice;
		GetTrieValue(hTrie, "price", iPrice);
		new iTeam;
		GetTrieValue(hTrie, "team", iTeam);
		new var3;
		if (iTeam && iTeam2 != iTeam)
		{
		}
		else
		{
			if (bTypeCheck)
			{
				new var4;
				if (bNotDisabled)
				{
					var4 = 1;
				}
				else
				{
					var4 = 0;
				}
				.35744.AddMenuItemFormat(hMenu, sName, var4, "%s [%i]", sName, iPrice);
			}
		}
		i++;
	}
	.35208.PushMenuCell(hMenu, "team", iTeam2);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_DisplayPlayerModelsStoreMenu(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iTeam = .35348.GetMenuCell(menu, "team", 0);
			new iIndex;
			GetTrieValue(g_vara808, sName, iIndex);
			new Handle:hTrie = GetArrayCell(g_vara804, iIndex, 0, false);
			new iPrice;
			new var1;
			if (hTrie && GetTrieValue(hTrie, "price", iPrice))
			{
				if (!.91444.CheckPrice(param1, iPrice))
				{
					.13572.CPrintToChat(param1, "%t", "not enough credits to purchase");
					.209432.DisplayPlayerModelsStoreMenu2(param1, iTeam);
					return 0;
				}
			}
			.211576.DisplayConfirmItemPurchaseMenu(param1, sName, "Player Models", iPrice, iTeam, "");
		}
		case 8:
		{
			if (param2 == -6)
			{
				.208788.DisplayPlayerModelsStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.211576.DisplayConfirmItemPurchaseMenu(client, String:sName[], String:sType[], iPrice, iTeam, String:sEntity[])
{
	new Handle:hMenu = CreateMenu(MenuHandle_ConfirmItemBuy, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm purchase package", sName);
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	.35896.PushMenuString(hMenu, "name", sName);
	.35896.PushMenuString(hMenu, "type", sType);
	.35208.PushMenuCell(hMenu, "price", iPrice);
	.35208.PushMenuCell(hMenu, "team", iTeam);
	.35896.PushMenuString(hMenu, "entity", sEntity);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_ConfirmItemBuy(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[256];
			GetMenuItem(menu, param2, sInfo, 256, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.188096.DisplayStoreMenu(param1);
				return 0;
			}
			new String:sName[256];
			.35952.GetMenuString(menu, "name", sName, 256);
			new String:sType[256];
			.35952.GetMenuString(menu, "type", sType, 256);
			new iPrice = .35348.GetMenuCell(menu, "price", 0);
			new iTeam = .35348.GetMenuCell(menu, "team", 0);
			new String:sEntity[32];
			.35952.GetMenuString(menu, "entity", sEntity, 32);
			if (!.91444.CheckPrice(param1, iPrice))
			{
				.13572.CPrintToChat(param1, "%t", "not enough credits to purchase");
				.188096.DisplayStoreMenu(param1);
				return 0;
			}
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(param1));
			WritePackString(hPack, sName);
			WritePackString(hPack, sType);
			WritePackCell(hPack, iPrice);
			WritePackCell(hPack, iTeam);
			WritePackString(hPack, sEntity);
			new String:sSteamID[64];
			GetClientAuthId(param1, AuthIdType:1, sSteamID, 64, true);
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, steamid, name, type, purchase_price, purchase_date) VALUES ('%i', '%s', '%s', '%s', '%i', '%i');", "hellonearth_store_items", 13924[param1], sSteamID, sName, sType, iPrice, GetTime({0,0}));
			SQL_TQuery(g_var35e4, TQuery_OnInsertItems, sQuery, hPack, DBPriority:1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.188096.DisplayStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnInsertItems(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sType[256];
		ReadPackString(data, sType, 256);
		new iPrice = ReadPackCell(data);
		new iTeam = ReadPackCell(data);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		CloseHandle(data);
		new var1;
		if (client < 1 || 41332[client])
		{
			return 0;
		}
		if (!.91444.CheckPrice(client, iPrice))
		{
			LogError("Client '%L' seems to have purchased an item without enough credits. [Credits: %i, Price: %i]", client, 14188[client], iPrice);
		}
		.82392.RemoveClientCredits(client, iPrice, false);
		PushArrayString(41332[client], sName);
		PushArrayString(41596[client], sType);
		.13572.CPrintToChat(client, "%t", "purchased item", sName, iPrice);
		new Handle:hMenu = CreateMenu(MenuHandle_ConfirmEquip, MenuAction:28);
		SetMenuTitle(hMenu, "%t", "equip item menu");
		AddMenuItem(hMenu, "Yes", "Yes", 0);
		AddMenuItem(hMenu, "No", "No", 0);
		.35896.PushMenuString(hMenu, "name", sName);
		.35896.PushMenuString(hMenu, "type", sType);
		.35208.PushMenuCell(hMenu, "team", iTeam);
		.35896.PushMenuString(hMenu, "entity", sEntity);
		DisplayMenu(hMenu, client, 0);
		return 0;
	}
	CloseHandle(data);
	LogError("Error inserting an item in the database: %s", error);
	return 0;
}

public MenuHandle_ConfirmEquip(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				return 0;
			}
			new String:sName[256];
			.35952.GetMenuString(menu, "name", sName, 256);
			new String:sType[256];
			.35952.GetMenuString(menu, "type", sType, 256);
			new iTeam = .35348.GetMenuCell(menu, "team", 0);
			new String:sEntity[32];
			.35952.GetMenuString(menu, "entity", sEntity, 32);
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(param1));
			WritePackString(hPack, sName);
			WritePackString(hPack, sType);
			WritePackCell(hPack, iTeam);
			WritePackString(hPack, sEntity);
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type, entity, team) VALUES('%i', '%s', '%s', '%s', '%i') ON DUPLICATE KEY UPDATE name = '%s', type = '%s';", "hellonearth_store_equipped", 13924[param1], sName, sType, sEntity, iTeam, sName, sType);
			SQL_TQuery(g_var35e4, TQuery_OnChangeEquippedType, sQuery, hPack, DBPriority:1);
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnChangeEquippedType(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sType[256];
		ReadPackString(data, sType, 256);
		new iTeam = ReadPackCell(data);
		new String:sEntity[32];
		ReadPackString(data, sEntity, 32);
		CloseHandle(data);
		new var1;
		if (client < 1 || 41860[client])
		{
			return 0;
		}
		if (.3076.StrEqual(sType, "Grenade Models", true))
		{
			new Handle:hTrie;
			new var2;
			if (GetTrieValue(41860[client], "Grenade Models", hTrie) && hTrie)
			{
				SetTrieString(hTrie, sEntity, sName, true);
			}
		}
		else
		{
			if (.3076.StrEqual(sType, "Grenade Trails", true))
			{
				new Handle:hTrie;
				new var3;
				if (GetTrieValue(41860[client], "Grenade Trails", hTrie) && hTrie)
				{
					SetTrieString(hTrie, sEntity, sName, true);
				}
			}
			if (.3076.StrEqual(sType, "Player Models", true))
			{
				new Handle:hTrie;
				new var4;
				if (GetTrieValue(41860[client], "Player Models", hTrie) && hTrie)
				{
					new String:sTeam[12];
					IntToString(iTeam, sTeam, 12);
					SetTrieString(hTrie, sTeam, sName, true);
				}
			}
			SetTrieString(41860[client], sType, sName, true);
		}
		.13572.CPrintToChat(client, "%t", "item equipped after purchase", sName);
		if (IsPlayerAlive(client))
		{
			if (.3076.StrEqual(sType, "Hats", true))
			{
				.255140.CreateHatEntity(client, sName, true);
			}
			if (.3076.StrEqual(sType, "Trails", true))
			{
				.259788.CreateTrailEntity(client, sName, true);
			}
			if (.3076.StrEqual(sType, "Player Models", true))
			{
				.263964.SetPlayerModel(client, iTeam, true);
			}
		}
		.188096.DisplayStoreMenu(client);
		return 0;
	}
	CloseHandle(data);
	LogError("Error inserting an item in the database: %s", error);
	return 0;
}

.217732.PurchaseGlobalPackage(client, String:sName[], String:sEnableColumn[], String:sExpiryColumn[], iCost, iExpiry)
{
	new expire;
	if (0 < iExpiry)
	{
		new post = iExpiry * 86400;
		expire = GetTime({0,0}) + post;
	}
	new Handle:hPack = CreateDataPack();
	WritePackCell(hPack, GetClientUserId(client));
	WritePackCell(hPack, iCost);
	WritePackString(hPack, sEnableColumn);
	WritePackString(hPack, sName);
	WritePackCell(hPack, iExpiry);
	new String:sQuery[4096];
	Format(sQuery, 4096, "UPDATE `%s` SET %s = 1, %s = %i WHERE id = '%i';", "hellonearth_store_players", sEnableColumn, sExpiryColumn, expire, 13924[client]);
	SQL_TQuery(g_var35e4, TQuery_OnPurchasePackage, sQuery, hPack, DBPriority:1);
	return 0;
}

public TQuery_OnPurchasePackage(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new iCost = ReadPackCell(data);
		new String:sEnableColumn[32];
		ReadPackString(data, sEnableColumn, 32);
		new String:sName[32];
		ReadPackString(data, sName, 32);
		new iExpire = ReadPackCell(data);
		CloseHandle(data);
		.82392.RemoveClientCredits(client, iCost, false);
		.13572.CPrintToChat(client, "%t", "purchased package");
		if (.3076.StrEqual(sEnableColumn, "weapon_colors", true))
		{
			16036[client] = 1;
		}
		else
		{
			if (.3076.StrEqual(sEnableColumn, "grenade_trails", true))
			{
				16300[client] = 1;
			}
			if (.3076.StrEqual(sEnableColumn, "tracers", true))
			{
				16564[client] = 1;
			}
			if (.3076.StrEqual(sEnableColumn, "laser_sights", true))
			{
				16828[client] = 1;
			}
			if (.3076.StrEqual(sEnableColumn, "chat_colors", true))
			{
				17092[client] = 1;
			}
			if (.3076.StrEqual(sEnableColumn, "name_colors", true))
			{
				17356[client] = 1;
			}
			if (.3076.StrEqual(sEnableColumn, "custom_tags", true))
			{
				17620[client] = 1;
			}
		}
		new String:sExpire[64];
		Format(sExpire, 64, "%t", "it will expire in", iExpire);
		new var1;
		if (iExpire)
		{
			var1 = sExpire;
		}
		else
		{
			var1 = 77176;
		}
		.13572.CPrintToChat(client, "%t", "package purchased successfully", sName, var1);
		.113268.OpenStoreMenu(client);
		return 0;
	}
	CloseHandle(data);
	LogError("Error purchasing package for client: %s", error);
	return 0;
}

.219736.DisplayRefundsMenu(client)
{
	new var1;
	if (41332[client] && 41860[client])
	{
		.13572.CPrintToChat(client, "%t", "error accessing refunds menu");
		return 0;
	}
	new Handle:hMenu = CreateMenu(MenuHandle_Refunds, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "refunds main menu", 14188[client]);
	new i;
	while (GetArraySize(41332[client]) > i)
	{
		new String:sName[256];
		GetArrayString(41332[client], i, sName, 256);
		new String:sType[256];
		GetArrayString(41596[client], i, sType, 256);
		.35744.AddMenuItemFormat(hMenu, sType, 0, "%s - %s", sName, sType);
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "You have no items.", 1);
	}
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_Refunds(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sType[256];
			new String:sName[256];
			GetMenuItem(menu, param2, sType, 256, 0, sName, 256);
			new String:sBuffer[2][32] = {
				" - ",
				"No"
			};
			.3816.ExplodeString(sName, " - ", sBuffer, 2, 32, false);
			.221084.DisplayConfirmItemRefund(param1, sType, sBuffer[0][sBuffer]);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.221084.DisplayConfirmItemRefund(client, String:sType[], String:sName[])
{
	new Handle:hMenu = CreateMenu(MenuHandle_RefundsConfirm, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "refund confirm", g_var3200 * 100);
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	.35896.PushMenuString(hMenu, "name", sName);
	.35896.PushMenuString(hMenu, "type", sType);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_RefundsConfirm(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.219736.DisplayRefundsMenu(param1);
				return 0;
			}
			new String:sName[256];
			.35952.GetMenuString(menu, "name", sName, 256);
			new String:sType[256];
			.35952.GetMenuString(menu, "type", sType, 256);
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(param1));
			WritePackString(hPack, sName);
			WritePackString(hPack, sType);
			new String:sQuery[4096];
			Format(sQuery, 4096, "SELECT id, purchase_price FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = '%s';", "hellonearth_store_items", 13924[param1], sName, sType);
			SQL_TQuery(g_var35e4, TQuery_OnRefundItem, sQuery, hPack, DBPriority:1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.219736.DisplayRefundsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public TQuery_OnRefundItem(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sType[256];
		ReadPackString(data, sType, 256);
		CloseHandle(data);
		if (client < 1)
		{
			return 0;
		}
		new iID;
		new iPrice;
		if (SQL_FetchRow(hndl))
		{
			iID = SQL_FetchInt(hndl, 0, 0);
			iPrice = SQL_FetchInt(hndl, 1, 0);
		}
		new var1;
		if (iID <= 0 || iPrice <= 0)
		{
			.13572.CPrintToChat(client, "%t", "fail refunded");
			.219736.DisplayRefundsMenu(client);
			return 0;
		}
		new deduct = RoundToFloor(float(iPrice) * g_var3200);
		.81756.GiveClientCredits(client, deduct, false);
		.104192.DeleteUserItem(client, sType, sName, true);
		.13572.CPrintToChat(client, "%t", "refunded", deduct);
		.269948.LogTransaction("", g_var3378, "Client '%L' has refunded the item '%s' with the type '%s' for credits '%i'.", client, sName, sType, deduct);
		return 0;
	}
	LogError("Error on refunding item: %s", error);
	CloseHandle(data);
	return 0;
}

.223472.DisplayGiftingMenu(client)
{
	new var1;
	if (41332[client] && 41860[client])
	{
		.14692.CReplyToCommand(client, "Your data is being fetched, please wait.");
		return 0;
	}
	new Handle:hMenu = CreateMenu(MenuHandle_Gifting, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "gifting main menu", 14188[client]);
	AddMenuItem(hMenu, "Send Credits", "Send Credits", 0);
	AddMenuItem(hMenu, "Send Item(s)", "Send Item(s)", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_Gifting(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (0 > 14980[param1])
			{
				.13572.CPrintToChat(param1, "%t", "gifting timer", 14980[param1]);
				.223472.DisplayGiftingMenu(param1);
				return 0;
			}
			if (.3076.StrEqual(sInfo, "Send Credits", true))
			{
				new Handle:hMenu = CreateMenu(MenuHandle_SendCredits, MenuAction:28);
				SetMenuTitle(hMenu, "%t", "select a player");
				.238896.InsertDatabaseClientsMenu(param1, hMenu);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, param1, 0);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Send Item(s)", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_SendItems, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "select a player");
					.238896.InsertDatabaseClientsMenu(param1, hMenu);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_SendCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			42128[param1] = GetClientOfUserId(StringToInt(sInfo, 10));
			42392[param1] = 1;
			.13572.CPrintToChat(param1, "%t", "type the amount of credits to gift", 42128[param1]);
			.238220.CreateGiftingTimer(param1, g_var3204);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.225472.ConfirmGiftCredits(client, target, credits)
{
	new Handle:hMenu = CreateMenu(MenuHandle_GiftCreditsConfirm, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "confirm send credits", credits, target);
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	.35208.PushMenuCell(hMenu, "target", target);
	.35208.PushMenuCell(hMenu, "credits", credits);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_GiftCreditsConfirm(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				return 0;
			}
			new target = .35348.GetMenuCell(menu, "target", 0);
			new credits = .35348.GetMenuCell(menu, "credits", 0);
			if (target < 1)
			{
				.13572.CPrintToChat(param1, "%t", "error giving credits invalid client");
				.223472.DisplayGiftingMenu(param1);
				return 0;
			}
			.82392.RemoveClientCredits(param1, credits, false);
			.81756.GiveClientCredits(target, credits, false);
			.13572.CPrintToChat(param1, "%t", "sent credits", credits, target);
			.13572.CPrintToChat(target, "%t", "received credits", credits, param1);
			.14112.CPrintToChatAll("%t", "received credits global", target, credits, param1);
			.269948.LogTransaction("", g_var347c, "'%L' has given '%L' %i credits via gifting.", param1, target, credits);
			.223472.DisplayGiftingMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_SendItems(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new iTarget = GetClientOfUserId(StringToInt(sInfo, 10));
			new Handle:hMenu = CreateMenu(MenuHandle_OnSendItemsType, MenuAction:28);
			SetMenuTitle(hMenu, "%t", "pick an item type to give", iTarget);
			AddMenuItem(hMenu, "Player Models", "Player Models", 0);
			AddMenuItem(hMenu, "Hats", "Hats", 0);
			AddMenuItem(hMenu, "Trails", "Trails", 0);
			.35208.PushMenuCell(hMenu, "target", iTarget);
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, 0);
			.238220.CreateGiftingTimer(param1, g_var3204);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_OnSendItemsType(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sType[256];
			GetMenuItem(menu, param2, sType, 256, 0, "", 0);
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			if (iTarget < 1)
			{
				.13572.CPrintToChat(param1, "%t", "error retrieving client items");
				.223472.DisplayGiftingMenu(param1);
				return 0;
			}
			if (.3076.StrEqual(sType, "Player Models", true))
			{
				new Handle:hMenu = CreateMenu(MenuHandle_SendItemPlayerModelsTeam, MenuAction:28);
				SetMenuTitle(hMenu, "%t", "pick an item type to give player models team");
				AddMenuItem(hMenu, "2", "Terrorists", 0);
				AddMenuItem(hMenu, "3", "Counter-Terrorists", 0);
				.35208.PushMenuCell(hMenu, "target", iTarget);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, param1, 0);
			}
			else
			{
				if (.3076.StrEqual(sType, "Hats", true))
				{
					.230380.SendGiftHats(param1, iTarget);
				}
				if (.3076.StrEqual(sType, "Trails", true))
				{
					.231628.SendGiftTrails(param1, iTarget);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_SendItemPlayerModelsTeam(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sTeam[12];
			GetMenuItem(menu, param2, sTeam, 12, 0, "", 0);
			new iTeam = StringToInt(sTeam, 10);
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			.228956.SendGiftPlayerModels(param1, iTarget, iTeam);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.228956.SendGiftPlayerModels(client, iTarget, iTeam)
{
	new Handle:hMenu = CreateMenu(MenuHandle_SendItemPlayerModels, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "send gift player models target", iTarget);
	new i;
	while (GetArraySize(g_vara804) > i)
	{
		new Handle:hTrie2 = GetArrayCell(g_vara804, i, 0, false);
		if (hTrie2)
		{
			new String:sName[256];
			GetTrieString(hTrie2, "name", sName, 256, 0);
			new team;
			GetTrieValue(hTrie2, "team", team);
			if (team == iTeam)
			{
				new find = -1;
				if (41332[client])
				{
					find = FindStringInArray(41332[client], sName);
				}
				if (find != -1)
				{
					.35744.AddMenuItemFormat(hMenu, sName, 0, "%s", sName);
				}
			}
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35208.PushMenuCell(hMenu, "target", iTarget);
	.35208.PushMenuCell(hMenu, "team", iTeam);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_SendItemPlayerModels(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			new iTeam = .35348.GetMenuCell(menu, "team", 0);
			.232876.SendPlayerGift(param1, iTarget, sName, "Player Models", iTeam);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.230380.SendGiftHats(client, iTarget)
{
	new Handle:hMenu = CreateMenu(MenuHandle_SendItemHats, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "send gift hats menu");
	new i;
	while (GetArraySize(g_vara7ac) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7ac, i, 0, false);
		new find = -1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			find = FindStringInArray(41332[client], sName);
		}
		if (find != -1)
		{
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s", sName);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35208.PushMenuCell(hMenu, "target", iTarget);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_SendItemHats(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			.232876.SendPlayerGift(param1, iTarget, sName, "Hats", 0);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.231628.SendGiftTrails(client, iTarget)
{
	new Handle:hMenu = CreateMenu(MenuHandle_SendItemTrails, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "send gift trails menu");
	new i;
	while (GetArraySize(g_vara7b4) > i)
	{
		new Handle:hTrie = GetArrayCell(g_vara7b4, i, 0, false);
		new find = -1;
		new String:sName[256];
		new var1;
		if (hTrie && GetTrieString(hTrie, "name", sName, 256, 0) && 41332[client])
		{
			find = FindStringInArray(41332[client], sName);
		}
		if (find != -1)
		{
			.35744.AddMenuItemFormat(hMenu, sName, 0, "%s", sName);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "No items found.", 1);
	}
	.35208.PushMenuCell(hMenu, "target", iTarget);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_SendItemTrails(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sName[256];
			GetMenuItem(menu, param2, sName, 256, 0, "", 0);
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			.232876.SendPlayerGift(param1, iTarget, sName, "Trails", 0);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.232876.SendPlayerGift(client, target, String:sName[], String:sType[], iTeam)
{
	new Handle:hMenu = CreateMenu(MenuHandle_ConfirmGiftSend, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "send player gift", sName, target);
	AddMenuItem(hMenu, "Yes", "Yes", 0);
	AddMenuItem(hMenu, "No", "No", 0);
	.35208.PushMenuCell(hMenu, "target", target);
	.35896.PushMenuString(hMenu, "name", sName);
	.35896.PushMenuString(hMenu, "type", sType);
	.35208.PushMenuCell(hMenu, "team", iTeam);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_ConfirmGiftSend(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[12];
			GetMenuItem(menu, param2, sInfo, 12, 0, "", 0);
			if (.3076.StrEqual(sInfo, "No", true))
			{
				.223472.DisplayGiftingMenu(param1);
				return 0;
			}
			new iTarget = .35348.GetMenuCell(menu, "target", 0);
			new String:sName[256];
			.35952.GetMenuString(menu, "name", sName, 256);
			new String:sType[256];
			.35952.GetMenuString(menu, "type", sType, 256);
			new iTeam = .35348.GetMenuCell(menu, "team", 0);
			.234080.ProcessSendItem(param1, iTarget, sName, sType, iTeam);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.223472.DisplayGiftingMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.234080.ProcessSendItem(client, target, String:sName[], String:sType[], iTeam)
{
	if (41332[client])
	{
		if (41332[target])
		{
			if (FindStringInArray(41332[target], sName) != -1)
			{
				.13572.CPrintToChat(client, "%t", "already has that item", target);
				.223472.DisplayGiftingMenu(client);
				return 0;
			}
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(client));
			WritePackCell(hPack, GetClientUserId(target));
			WritePackString(hPack, sName);
			WritePackString(hPack, sType);
			new String:sQuery[4096];
			Format(sQuery, 4096, "SELECT purchase_price, purchase_date FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = '%s';", "hellonearth_store_items", 13924[client], sName, sType);
			SQL_TQuery(g_var35e4, TQuery_OnSelectItemData, sQuery, hPack, DBPriority:1);
			return 0;
		}
		.13572.CPrintToChat(client, "%t", "process item error from");
		.223472.DisplayGiftingMenu(client);
		return 0;
	}
	.13572.CPrintToChat(client, "%t", "process item error to");
	.223472.DisplayGiftingMenu(client);
	return 0;
}

public TQuery_OnSelectItemData(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new target = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sType[256];
		ReadPackString(data, sType, 256);
		CloseHandle(data);
		if (0 > client)
		{
			return 0;
		}
		if (0 > target)
		{
			.13572.CPrintToChat(client, "%t", "error gifting client item invalid client");
			.223472.DisplayGiftingMenu(client);
			return 0;
		}
		if (FindStringInArray(41332[target], sName) != -1)
		{
			.13572.CPrintToChat(client, "%t", "already has that item", target);
			.223472.DisplayGiftingMenu(client);
			return 0;
		}
		if (SQL_GetRowCount(hndl) < 1)
		{
			.13572.CPrintToChat(client, "%t", "error fetching item information during gift");
			.223472.DisplayGiftingMenu(client);
			return 0;
		}
		if (SQL_FetchRow(hndl))
		{
			new iPrice = SQL_FetchInt(hndl, 0, 0);
			new iPurchaseDate = SQL_FetchInt(hndl, 1, 0);
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, GetClientUserId(client));
			WritePackCell(hPack, GetClientUserId(target));
			WritePackString(hPack, sName);
			WritePackString(hPack, sType);
			WritePackCell(hPack, 13924[client]);
			new String:sQuery[4096];
			Format(sQuery, 4096, "INSERT INTO `%s` (player_id, name, type, purchase_price, purchase_date) VALUES ('%i', '%s', '%s', '%i', '%i');", "hellonearth_store_items", 13924[target], sName, sType, iPrice, iPurchaseDate);
			SQL_TQuery(g_var35e4, TQuery_OnGiftItem, sQuery, hPack, DBPriority:1);
		}
		else
		{
			.13572.CPrintToChat(client, "%t", "error gifting process more than one row");
		}
		.223472.DisplayGiftingMenu(client);
		return 0;
	}
	CloseHandle(data);
	LogError("Error on selecting an items data during a gift: %s", error);
	return 0;
}

public TQuery_OnGiftItem(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		ResetPack(data, false);
		new client = GetClientOfUserId(ReadPackCell(data));
		new target = GetClientOfUserId(ReadPackCell(data));
		new String:sName[256];
		ReadPackString(data, sName, 256);
		new String:sType[256];
		ReadPackString(data, sType, 256);
		new iDatabase = ReadPackCell(data);
		CloseHandle(data);
		new String:sQuery[4096];
		Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = '%s';", "hellonearth_store_items", iDatabase, sName, sType);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		Format(sQuery, 4096, "DELETE FROM `%s` WHERE player_id = '%i' AND name = '%s' AND type = '%s';", "hellonearth_store_equipped", iDatabase, sName, sType);
		.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
		new var1;
		if (client > 0 && client <= MaxClients)
		{
			new index = FindStringInArray(41596[client], sType);
			if (index != -1)
			{
				RemoveFromArray(41332[client], index);
				RemoveFromArray(41596[client], index);
			}
			RemoveFromTrie(41860[client], sType);
			if (IsPlayerAlive(client))
			{
				if (.3076.StrEqual(sType, "Player Models", true))
				{
					.265276.ResetPlayerModel(client);
				}
				if (.3076.StrEqual(sType, "Hats", true))
				{
					.258936.RemoveHatEntity(client);
				}
				if (.3076.StrEqual(sType, "Trails", true))
				{
					.261540.RemoveTrailEntity(client);
				}
			}
			.13572.CPrintToChat(client, "%t", "item gifting completed");
			.14112.CPrintToChatAll("%t", "item gifting completed global", target, sName, client);
			.269948.LogTransaction("", g_var347c, "'%L' has sent '%L' the item '%s' with the type '%s' as a gift.", client, target, sName, sType);
			.223472.DisplayGiftingMenu(client);
		}
		new var2;
		if (target > 0 && target <= MaxClients)
		{
			PushArrayString(41332[target], sName);
			PushArrayString(41596[target], sType);
			.13572.CPrintToChat(target, "%t", "item received", sName, client);
		}
		return 0;
	}
	CloseHandle(data);
	LogError("Error on inserting an items data during a gift: %s", error);
	return 0;
}

.238220.CreateGiftingTimer(client, iTime)
{
	new var1;
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client) || 14980[client] > 0)
	{
		return 0;
	}
	14980[client] = iTime;
	CreateTimer(1.0, GiftingTimer, GetClientUserId(client), 3);
	return 0;
}

public GiftingTimer(Handle:hTimer, any:data)
{
	new client = GetClientOfUserId(data);
	if (client < 1)
	{
		14980[client] = 0;
		return 4;
	}
	14980[client]--;
	if (0 >= 14980[client])
	{
		14980[client] = 0;
		return 4;
	}
	return 0;
}

.238896.InsertDatabaseClientsMenu(client, Handle:hMenu)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i) && 13924[i] > 0 && client != i)
		{
			new String:sUserId[12];
			IntToString(GetClientUserId(i), sUserId, 12);
			new String:sName[32];
			GetClientName(i, sName, 32);
			AddMenuItem(hMenu, sUserId, sName, 0);
		}
		i++;
	}
	if (GetMenuItemCount(hMenu) < 1)
	{
		AddMenuItem(hMenu, "", "[No clients to show]", 1);
	}
	return 0;
}

.239436.DisplayAdminOptionsMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_AdminOptions, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "admin options main menu", 14188[client]);
	AddMenuItem(hMenu, "Give Player Credits", "Give Player Credits", 0);
	AddMenuItem(hMenu, "Reset Player Credits", "Reset Player Credits", 0);
	AddMenuItem(hMenu, "Remove Player Credits", "Remove Player Credits", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_AdminOptions(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Give Player Credits", true))
			{
				.240336.GiveCreditsMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Reset Player Credits", true))
				{
					.246552.ResetCreditsMenu(param1);
				}
				if (.3076.StrEqual(sInfo, "Remove Player Credits", true))
				{
					.249380.RemoveCreditsMenu(param1);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.113268.OpenStoreMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.240336.GiveCreditsMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_GiveCredits, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "give players credits");
	AddMenuItem(hMenu, "All", "Give All", 0);
	AddMenuItem(hMenu, "Team", "Give Team", 0);
	AddMenuItem(hMenu, "Player", "Give Player", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_GiveCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "All", true))
			{
				new Handle:hMenu = CreateMenu(MenuHandle_GiveAllCredits, MenuAction:28);
				SetMenuTitle(hMenu, "%t", "give all credits");
				AddMenuItem(hMenu, "1000", "1000", 0);
				AddMenuItem(hMenu, "2500", "2500", 0);
				AddMenuItem(hMenu, "5000", "5000", 0);
				AddMenuItem(hMenu, "10000", "10000", 0);
				AddMenuItem(hMenu, "20000", "20000", 0);
				AddMenuItem(hMenu, "30000", "30000", 0);
				AddMenuItem(hMenu, "50000", "50000", 0);
				AddMenuItem(hMenu, "Custom", "Custom (type in chat)", 0);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, param1, 0);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Team", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_GiveTeamCredits, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "give team credits");
					AddMenuItem(hMenu, "2", "Terrorists", 0);
					AddMenuItem(hMenu, "3", "Counter Terrorists", 0);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
				if (.3076.StrEqual(sInfo, "Player", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_GivePlayerCredits, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "give players credits");
					AddTargetsToMenu2(hMenu, param1, 32);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.239436.DisplayAdminOptionsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_GiveAllCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "Custom", true))
			{
				.13572.CPrintToChat(param1, "%t", "type amount to give all");
				39220[param1] = 1;
				return 0;
			}
			new credits = StringToInt(sInfo, 10);
			new i = 1;
			while (i <= MaxClients)
			{
				new var1;
				if (IsClientInGame(i) && !IsFakeClient(i))
				{
					.81756.GiveClientCredits(i, credits, false);
				}
				i++;
			}
			.13572.CPrintToChat(param1, "%t", "all clients given credits", credits);
			.4716.PrintToChatAll("%t", "all clients given credits all", credits, param1);
			.113268.OpenStoreMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.240336.GiveCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_GiveTeamCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new Handle:hMenu = CreateMenu(MenuHandle_GiveTeamCredits2, MenuAction:28);
			SetMenuTitle(hMenu, "%t", "give all credits");
			AddMenuItem(hMenu, "1000", "1000", 0);
			AddMenuItem(hMenu, "2500", "2500", 0);
			AddMenuItem(hMenu, "5000", "5000", 0);
			AddMenuItem(hMenu, "10000", "10000", 0);
			AddMenuItem(hMenu, "20000", "20000", 0);
			AddMenuItem(hMenu, "30000", "30000", 0);
			AddMenuItem(hMenu, "50000", "50000", 0);
			AddMenuItem(hMenu, "Custom", "Custom (type in chat)", 0);
			.35208.PushMenuCell(hMenu, "Team", StringToInt(sInfo, 10));
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, 0);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.240336.GiveCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_GiveTeamCredits2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new credits = StringToInt(sInfo, 10);
			new team = .35348.GetMenuCell(menu, "Team", 0);
			new String:sTeam[64];
			GetTeamName(team, sTeam, 64);
			if (.3076.StrEqual(sInfo, "Custom", true))
			{
				.13572.CPrintToChat(param1, "%t", "type amount to give team", sTeam);
				39484[param1] = 1;
				39748[param1] = team;
				return 0;
			}
			new i = 1;
			while (i <= MaxClients)
			{
				new var1;
				if (IsClientInGame(i) && !IsFakeClient(i) && team == GetClientTeam(i))
				{
					.81756.GiveClientCredits(i, credits, false);
				}
				i++;
			}
			.13572.CPrintToChat(param1, "%t", "team given credits", sTeam, credits);
			.4716.PrintToChatAll("%t", "team given credits all", credits, sTeam);
			.113268.OpenStoreMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.239436.DisplayAdminOptionsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_GivePlayerCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new target = GetClientOfUserId(StringToInt(sInfo, 10));
			new Handle:hMenu = CreateMenu(MenuHandle_GivePlayerCredits2, MenuAction:28);
			SetMenuTitle(hMenu, "%t", "give all credits");
			AddMenuItem(hMenu, "1000", "1000", 0);
			AddMenuItem(hMenu, "2500", "2500", 0);
			AddMenuItem(hMenu, "5000", "5000", 0);
			AddMenuItem(hMenu, "10000", "10000", 0);
			AddMenuItem(hMenu, "20000", "20000", 0);
			AddMenuItem(hMenu, "30000", "30000", 0);
			AddMenuItem(hMenu, "50000", "50000", 0);
			AddMenuItem(hMenu, "Custom", "Custom (type in chat)", 0);
			.35208.PushMenuCell(hMenu, "Target", target);
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, 0);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.240336.GiveCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_GivePlayerCredits2(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new credits = StringToInt(sInfo, 10);
			new target = .35348.GetMenuCell(menu, "Target", 0);
			if (.3076.StrEqual(sInfo, "Custom", true))
			{
				.13572.CPrintToChat(param1, "%t", "type amount to give client", target);
				40012[param1] = 1;
				40276[param1] = target;
				return 0;
			}
			.81756.GiveClientCredits(target, credits, false);
			.13572.CPrintToChat(param1, "%t", "client given credits", target, credits);
			.4716.PrintToChatAll("%t", "client given credits all", target, credits, param1);
			.113268.OpenStoreMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.240336.GiveCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.246552.ResetCreditsMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_ResetCredits, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "reset player credits");
	AddMenuItem(hMenu, "All", "Reset All", 0);
	AddMenuItem(hMenu, "Team", "Reset Team", 0);
	AddMenuItem(hMenu, "Player", "Reset Player", 0);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_ResetCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "All", true))
			{
				new i = 1;
				while (i <= MaxClients)
				{
					new var1;
					if (IsClientInGame(i) && !IsFakeClient(i))
					{
						.82096.ResetCredits(i);
					}
					i++;
				}
				.13572.CPrintToChat(param1, "%t", "all players reset");
				.246552.ResetCreditsMenu(param1);
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Team", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_ResetTeamCredits, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "reset team credits");
					AddMenuItem(hMenu, "2", "Terrorists", 0);
					AddMenuItem(hMenu, "3", "Counter Terrorists", 0);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
				if (.3076.StrEqual(sInfo, "Player", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_ResetPlayerCredits, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "reset player credits");
					AddTargetsToMenu2(hMenu, param1, 32);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.239436.DisplayAdminOptionsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_ResetTeamCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new team = StringToInt(sInfo, 10);
			new i = 1;
			while (i <= MaxClients)
			{
				new var1;
				if (IsClientInGame(i) && !IsFakeClient(i) && team == GetClientTeam(i))
				{
					.82096.ResetCredits(i);
				}
				i++;
			}
			new String:sTeam[32];
			GetTeamName(team, sTeam, 32);
			.13572.CPrintToChat(param1, "%t", "all players on team reset", sTeam);
			.246552.ResetCreditsMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.246552.ResetCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_ResetPlayerCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			new target = GetClientOfUserId(StringToInt(sInfo, 10));
			if (target < 1)
			{
				.13572.CPrintToChat(param1, "%t", "player reset invalid");
				.246552.ResetCreditsMenu(param1);
			}
			.82096.ResetCredits(target);
			.13572.CPrintToChat(param1, "%t", "player reset", target);
			.246552.ResetCreditsMenu(param1);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.246552.ResetCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

.249380.RemoveCreditsMenu(client)
{
	new Handle:hMenu = CreateMenu(MenuHandle_RemoveCredits, MenuAction:28);
	SetMenuTitle(hMenu, "%t", "reset player credits");
	AddMenuItem(hMenu, "All", "Remove From All", 0);
	AddMenuItem(hMenu, "Team", "Remove From Team", 0);
	AddTargetsToMenu2(hMenu, client, 32);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandle_RemoveCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			if (.3076.StrEqual(sInfo, "All", true))
			{
				40540[param1] = 1;
				.13572.CPrintToChat(param1, "%t", "type amount to remove from all");
			}
			else
			{
				if (.3076.StrEqual(sInfo, "Team", true))
				{
					new Handle:hMenu = CreateMenu(MenuHandle_RemoveTeamCredits, MenuAction:28);
					SetMenuTitle(hMenu, "%t", "reset team credits");
					AddMenuItem(hMenu, "2", "Terrorists", 0);
					AddMenuItem(hMenu, "3", "Counter Terrorists", 0);
					SetMenuExitBackButton(hMenu, true);
					DisplayMenu(hMenu, param1, 0);
				}
				41068[param1] = StringToInt(sInfo, 10);
				.13572.CPrintToChat(param1, "%t", "type amount to remove from client", 41068[param1]);
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.239436.DisplayAdminOptionsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandle_RemoveTeamCredits(Menu:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			new String:sInfo[32];
			GetMenuItem(menu, param2, sInfo, 32, 0, "", 0);
			40804[param1] = StringToInt(sInfo, 10);
			new String:sTeam[32];
			GetTeamName(40804[param1], sTeam, 32);
			.13572.CPrintToChat(param1, "%t", "type amount to remove from team", sTeam);
		}
		case 8:
		{
			if (param2 == -6)
			{
				.249380.RemoveCreditsMenu(param1);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public OnPlayerSpawn(Event:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (IsFakeClient(client) || !IsPlayerAlive(client) || 41860[client])
	{
		return 0;
	}
	RequestFrame(OnPlayerSpawnPostFrame, GetClientUserId(client));
	return 0;
}

public OnPlayerSpawnPostFrame(any:data)
{
	new client = GetClientOfUserId(data);
	new var1;
	if (client > 0 && IsPlayerAlive(client) && 41860[client])
	{
		new String:sHat[256];
		if (GetTrieString(41860[client], "Hats", sHat, 256, 0))
		{
			.255140.CreateHatEntity(client, sHat, true);
		}
		new String:sTrail[256];
		if (GetTrieString(41860[client], "Trails", sTrail, 256, 0))
		{
			.259788.CreateTrailEntity(client, sTrail, true);
		}
		new Handle:hTrie;
		new var2;
		if (GetTrieValue(41860[client], "Player Models", hTrie) && hTrie)
		{
			.263964.SetPlayerModel(client, GetClientTeam(client), true);
		}
	}
	return 0;
}

public OnPlayerDeath(Event:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (client < 1 || attacker < 1 || !IsClientInGame(client) || !IsClientInGame(attacker))
	{
		return 0;
	}
	new var2;
	if (!IsFakeClient(attacker) && 13924[attacker] > 0)
	{
		new String:sWeapon[64];
		GetEventString(event, "weapon", sWeapon, 64, "");
		if (GetEventBool(event, "headshot", false))
		{
			.81756.GiveClientCredits(attacker, g_var3084, false);
		}
		else
		{
			if (StrContains(sWeapon, "knife", true) != -1)
			{
				.81756.GiveClientCredits(attacker, g_var308c, false);
			}
			.81756.GiveClientCredits(attacker, g_var3088, false);
		}
	}
	if (0 < 13924[client])
	{
		.258936.RemoveHatEntity(client);
		.261540.RemoveTrailEntity(client);
		.265276.ResetPlayerModel(client);
	}
	return 0;
}

public OnRoundStart(Event:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && 38956[i])
		{
			.37608.ClearHandle(38956[i]);
		}
		38692[i] = g_var3198;
		i++;
	}
	return 0;
}

public OnRoundEnd(Event:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			CancelClientMenu(i, true, Handle:0);
			if (14716[i])
			{
				new String:sQuery[4096];
				Format(sQuery, 4096, "UPDATE `%s` SET credits = %i WHERE id = '%i';", "hellonearth_store_players", 14188[i], 13924[i]);
				.37172.SQL_TFastQuery(g_var35e4, sQuery, DBPriority:1);
				14716[i] = 0;
			}
			.258936.RemoveHatEntity(i);
			.261540.RemoveTrailEntity(i);
			.265276.ResetPlayerModel(i);
		}
		i++;
	}
	return 0;
}

public OnBulletImpact(Event:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client) || IsFakeClient(client) || 41860[client])
	{
		return 0;
	}
	new String:sName[256];
	new var2;
	if (g_var322c && 16564[client] && GetTrieString(41860[client], "Tracers", sName, 256, 0))
	{
		new iIndex;
		GetTrieValue(g_vara7d8, sName, iIndex);
		new Handle:hTrie = GetArrayCell(g_vara7d4, iIndex, 0, false);
		if (hTrie)
		{
			new iColor[4];
			GetTrieArray(hTrie, "color", iColor, 4, 0);
			new Float:m_fOrigin[3] = 0.0;
			GetClientEyePosition(client, m_fOrigin);
			new Float:m_fImpact[3] = 0.0;
			m_fImpact[0] = GetEventFloat(event, "x", 0.0);
			m_fImpact[1] = GetEventFloat(event, "y", 0.0);
			m_fImpact[2] = GetEventFloat(event, "z", 0.0);
			.7088.TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_var35f0, 0, 0, 0, 0.5, 1.0, 1.0, 1, 0.0, iColor, 0);
			.6632.TE_SendToAll(0.0);
		}
	}
	return 0;
}

.255140.CreateHatEntity(client, String:sName[], bool:bRemove)
{
	new var1;
	if (!g_var3268 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return 0;
	}
	new var2;
	if (bRemove || EntRefToEntIndex(17884[client]) == -1)
	{
		.258936.RemoveHatEntity(client);
	}
	new iIndex;
	GetTrieValue(g_vara7b0, sName, iIndex);
	new Handle:hTrie = GetArrayCell(g_vara7ac, iIndex, 0, false);
	if (hTrie)
	{
		new String:sAttachment[256];
		GetTrieString(hTrie, "attachment", sAttachment, 256, 0);
		if (!.259244.LookupAttachment(client, sAttachment))
		{
			return 0;
		}
		new Float:m_fHatAngles[3] = 0.0;
		GetClientAbsAngles(client, m_fHatAngles);
		new Float:fAngles[3] = 0.0;
		GetTrieArray(hTrie, "angle", fAngles, 3, 0);
		m_fHatAngles[0] = m_fHatAngles[0] + fAngles[0];
		m_fHatAngles[1] += fAngles[1];
		m_fHatAngles[2] += fAngles[2];
		new Float:fPosition[3] = 0.0;
		GetTrieArray(hTrie, "position", fPosition, 3, 0);
		new Float:m_fOffset[3] = 0.0;
		m_fOffset[0] = fPosition[0];
		m_fOffset[1] = fPosition[1];
		m_fOffset[2] = fPosition[2];
		new Float:m_fForward[3] = 0.0;
		new Float:m_fRight[3] = 0.0;
		new Float:m_fUp[3] = 0.0;
		GetAngleVectors(m_fHatAngles, m_fForward, m_fRight, m_fUp);
		new Float:m_fHatOrigin[3] = 0.0;
		GetClientAbsOrigin(client, m_fHatOrigin);
		m_fHatOrigin[0] = m_fHatOrigin[0] + m_fRight[0] * m_fOffset[0] + m_fForward[0] * m_fOffset[1] + m_fUp[0] * m_fOffset[2];
		m_fHatOrigin[1] += m_fRight[1] * m_fOffset[0] + m_fForward[1] * m_fOffset[1] + m_fUp[1] * m_fOffset[2];
		m_fHatOrigin[2] += m_fRight[2] * m_fOffset[0] + m_fForward[2] * m_fOffset[1] + m_fUp[2] * m_fOffset[2];
		new String:sModel[256];
		new var3;
		if (GetTrieString(hTrie, "model", sModel, 256, 0) && strlen(sModel) && IsModelPrecached(sModel))
		{
			new entity = CreateEntityByName("prop_dynamic_override", -1);
			if (IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "model", sModel);
				DispatchKeyValue(entity, "spawnflags", "256");
				DispatchKeyValue(entity, "solid", "0");
				SetEntPropEnt(entity, PropType:0, "m_hOwnerEntity", client, 0);
				new bool:bBonemerge;
				new var4;
				if (GetTrieValue(hTrie, "bonemerge", bBonemerge) && bBonemerge)
				{
					Bonemerge(entity);
				}
				DispatchSpawn(entity);
				AcceptEntityInput(entity, "TurnOn", entity, entity, 0);
				17884[client] = EntIndexToEntRef(entity);
				SDKHook(entity, SDKHookType:6, Hook_SetTransmit);
				TeleportEntity(entity, m_fHatOrigin, m_fHatAngles, NULL_VECTOR);
				SetVariantString("!activator");
				AcceptEntityInput(entity, "SetParent", client, entity, 0);
				SetVariantString(sAttachment);
				AcceptEntityInput(entity, "SetParentAttachmentMaintainOffset", entity, entity, 0);
			}
		}
		return 0;
	}
	return 0;
}

public Hook_SetTransmit(entity, client)
{
	new var1;
	if (17884[client] == EntIndexToEntRef(entity) && !42656[client])
	{
		return 3;
	}
	if (IsClientObserver(client))
	{
		new observer = GetEntPropEnt(client, PropType:0, "m_hObserverTarget", 0);
		new var2;
		if (observer != -1 && 17884[observer] == EntIndexToEntRef(entity))
		{
			return 3;
		}
	}
	return 0;
}

.258936.RemoveHatEntity(client)
{
	new entity = EntRefToEntIndex(17884[client]);
	new var1;
	if (entity != -1 && IsValidEntity(entity))
	{
		SDKUnhook(entity, SDKHookType:6, Hook_SetTransmit);
		AcceptEntityInput(entity, "Kill", -1, -1, 0);
		17884[client] = -1;
	}
	return 0;
}

.259244.LookupAttachment(client, String:point[])
{
	if (g_Game)
	{
		return 1;
	}
	new var1;
	if (strlen(point) < 1 || g_LookupAttachment || client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return 0;
	}
	return SDKCall(g_LookupAttachment, client, point);
}

public Bonemerge(entity)
{
	new m_iEntEffects = GetEntProp(entity, PropType:0, "m_fEffects", 4, 0);
	m_iEntEffects &= -33;
	m_iEntEffects |= 1;
	m_iEntEffects |= 128;
	SetEntProp(entity, PropType:0, "m_fEffects", m_iEntEffects, 4, 0);
	return 0;
}

.259788.CreateTrailEntity(client, String:sName[], bool:bRemove)
{
	new var1;
	if (!g_var326c || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return 0;
	}
	new var2;
	if (bRemove || EntRefToEntIndex(18148[client]) == -1)
	{
		.261540.RemoveTrailEntity(client);
	}
	new iIndex;
	GetTrieValue(g_vara7b8, sName, iIndex);
	new Handle:hTrie = GetArrayCell(g_vara7b4, iIndex, 0, false);
	if (hTrie)
	{
		new String:sMaterial[256];
		GetTrieString(hTrie, "material", sMaterial, 256, 0);
		new iMaterialID;
		GetTrieValue(g_vara7a8, sMaterial, iMaterialID);
		new Float:fInitialWidth = 0.0;
		GetTrieValue(hTrie, "initial_width", fInitialWidth);
		new Float:fFinalWidth = 0.0;
		GetTrieValue(hTrie, "final_width", fFinalWidth);
		new iFadeTime;
		GetTrieValue(hTrie, "fade_time", iFadeTime);
		decl entity;
		new var3;
		if (g_Game)
		{
			var3[0] = 82008;
		}
		else
		{
			var3[0] = 82020;
		}
		entity = CreateEntityByName(var3, -1);
		if (IsValidEntity(entity))
		{
			if (g_Game)
			{
				DispatchKeyValue(entity, "classname", "env_sprite");
				DispatchKeyValue(entity, "spawnflags", "1");
				DispatchKeyValue(entity, "scale", "0.0");
				DispatchKeyValue(entity, "rendermode", "10");
				DispatchKeyValue(entity, "rendercolor", "255 255 255 0");
				DispatchKeyValue(entity, "model", sMaterial);
				DispatchSpawn(entity);
				.261848.AttachTrail(entity, client, 5.0);
				decl iColor[4];
				.7696.TE_SetupBeamFollow(entity, iMaterialID, 0, 1.0, fInitialWidth, fFinalWidth, iFadeTime, iColor);
				.6632.TE_SendToAll(0.0);
			}
			else
			{
				SetEntPropFloat(entity, PropType:0, "m_flTextureRes", 0.05, 0);
				DispatchKeyValue(entity, "renderamt", "255");
				DispatchKeyValue(entity, "rendercolor", "255 255 255 255");
				DispatchKeyValue(entity, "lifetime", "1.0");
				DispatchKeyValue(entity, "rendermode", "5");
				DispatchKeyValue(entity, "spritename", sMaterial);
				DispatchKeyValueFloat(entity, "startwidth", fInitialWidth);
				DispatchKeyValueFloat(entity, "endwidth", fFinalWidth);
				DispatchSpawn(entity);
				.261848.AttachTrail(entity, client, 5.0);
			}
			18148[client] = EntIndexToEntRef(entity);
		}
		return 0;
	}
	return 0;
}

.261540.RemoveTrailEntity(client)
{
	new entity = EntRefToEntIndex(18148[client]);
	new var1;
	if (entity != -1 && IsValidEntity(entity))
	{
		AcceptEntityInput(entity, "Kill", -1, -1, 0);
		18148[client] = -1;
		19732[client] = 0;
	}
	return 0;
}

.261848.AttachTrail(ent, client, Float:fOffset)
{
	new Float:m_fAngle[3] = 0.0;
	GetEntPropVector(client, PropType:1, "m_angAbsRotation", m_fAngle, 0);
	new Float:m_fTemp[3] = {0.0,6.4664E-41};
	SetEntPropVector(client, PropType:1, "m_angAbsRotation", m_fTemp, 0);
	new Float:m_fOrigin[3] = 0.0;
	GetClientAbsOrigin(client, m_fOrigin);
	m_fOrigin[2] += fOffset;
	TeleportEntity(ent, m_fOrigin, m_fTemp, NULL_VECTOR);
	SetVariantString("!activator");
	AcceptEntityInput(ent, "SetParent", client, ent, 0);
	SetEntPropVector(client, PropType:1, "m_angAbsRotation", m_fAngle, 0);
	return 0;
}

public OnGameFrame()
{
	new var1;
	if (!g_var326c || !g_Game || GetGameTickCount() % 6)
	{
		return 0;
	}
	new Float:m_fTime = GetEngineTime();
	new Float:m_fPosition[3] = 0.0;
	new i = 1;
	while (i <= MaxClients)
	{
		new entity = EntRefToEntIndex(18148[i]);
		new var2;
		if (IsClientInGame(i) && IsPlayerAlive(i) && !IsFakeClient(i) && entity != -1)
		{
			GetClientAbsOrigin(i, m_fPosition);
			if (GetVectorDistance(18676[i], m_fPosition, false) <= 5.0)
			{
				if (!19732[i])
				{
					if (m_fTime - 18412[i] >= 1065353216 / 2)
					{
						19732[i] = 1;
					}
				}
			}
			if (19732[i])
			{
				19732[i] = 0;
				new var3;
				if (entity != -1 && IsValidEntity(entity))
				{
					TE_Start("KillPlayerAttachments");
					TE_WriteNum("m_nPlayer", i);
					.6632.TE_SendToAll(0.0);
					18148[i] = -1;
				}
				new String:sTrail[256];
				new var4;
				if (41860[i] && GetTrieString(41860[i], "Trails", sTrail, 256, 0))
				{
					.259788.CreateTrailEntity(i, sTrail, false);
					PrintToServer("Remaking trail.");
				}
			}
			else
			{
				18412[i] = m_fTime;
			}
		}
		i++;
	}
	return 0;
}

.263964.SetPlayerModel(client, iTeam, bool:bRemove)
{
	new var1;
	if (!g_var3270 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return 0;
	}
	if (bRemove)
	{
		.265276.ResetPlayerModel(client);
	}
	if (!iTeam)
	{
		iTeam = GetClientTeam(client);
	}
	new var2;
	if (iTeam && GetClientTeam(client) != iTeam)
	{
		return 0;
	}
	new var3;
	if (iTeam < 2 || !IsPlayerAlive(client) || IsFakeClient(client) || 41860[client])
	{
		return 0;
	}
	new Handle:hTrie;
	GetTrieValue(41860[client], "Player Models", hTrie);
	if (hTrie)
	{
		new String:sTeam[12];
		IntToString(iTeam, sTeam, 12);
		new String:sName[256];
		GetTrieString(hTrie, sTeam, sName, 256, 0);
		new iIndex;
		if (GetTrieValue(g_vara808, sName, iIndex))
		{
			new Handle:hTrie2 = GetArrayCell(g_vara804, iIndex, 0, false);
			new String:sModel[256];
			new var4;
			if (hTrie2 && GetTrieString(hTrie2, "model", sModel, 256, 0) && strlen(sModel))
			{
				GetClientModel(client, 19996[client], 256);
				if (IsModelPrecached(sModel))
				{
					SetEntityModel(client, sModel);
				}
				LogError("Error equipping model '%s' to client '%L'.", sModel, client);
			}
		}
		return 0;
	}
	return 0;
}

.265276.ResetPlayerModel(client)
{
	if (strlen(19996[client]))
	{
		SetEntityModel(client, 19996[client]);
		19996[client] = 0;
	}
	return 0;
}

public OnEntityCreated(entity, String:classname[])
{
	if (StrContains(classname, "_projectile", true) == -1)
	{
		return 0;
	}
	new client = GetEntPropEnt(entity, PropType:0, "m_hOwnerEntity", 0);
	new var1;
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client) || IsFakeClient(client) || 41860[client])
	{
		return 0;
	}
	new String:sClassname[64];
	.5356.GetEntityClassname(entity, sClassname, 64);
	new String:sName[256];
	new Handle:hTrie;
	new var2;
	if (g_var3238 && GetTrieValue(41860[client], "Grenade Models", hTrie) && hTrie && GetTrieString(hTrie, sClassname, sName, 256, 0))
	{
		new iIndex;
		GetTrieValue(g_vara7c0, sName, iIndex);
		new Handle:hTrie2 = GetArrayCell(g_vara7bc, iIndex, 0, false);
		if (hTrie2)
		{
			new String:sModel[256];
			GetTrieString(hTrie2, "model", sModel, 256, 0);
			if (IsModelPrecached(sModel))
			{
				SetEntityModel(entity, sModel);
			}
			else
			{
				LogError("Error equipping model '%s' to client '%L' grenade models.", sModel, client);
			}
		}
	}
	new String:sName2[256];
	new Handle:hTrie3;
	new var3;
	if (g_var3228 && 16300[client] && GetTrieValue(41860[client], "Grenade Trails", hTrie3) && hTrie3 && GetTrieString(hTrie3, sClassname, sName2, 256, 0))
	{
		new iIndex;
		GetTrieValue(g_vara7d0, sName2, iIndex);
		new Handle:hTrie4 = GetArrayCell(g_vara7cc, iIndex, 0, false);
		if (hTrie4)
		{
			new iColor[4];
			GetTrieArray(hTrie4, "color", iColor, 4, 0);
			.7696.TE_SetupBeamFollow(entity, g_var35f0, 0, 2.0, 1.0, 1.0, 10, iColor);
			.6632.TE_SendToAll(0.0);
		}
	}
	return 0;
}

public OnWeaponEquip(client, weapon)
{
	new var1;
	if (g_var321c && !g_Game && 41860[client])
	{
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, GetClientUserId(client));
		WritePackCell(hPack, weapon);
		CreateTimer(1.0, OnUpdateWeaponColor, hPack, 0);
	}
	return 0;
}

public OnUpdateWeaponColor(Handle:timer, any:data)
{
	ResetPack(data, false);
	new userid = ReadPackCell(data);
	new weapon = ReadPackCell(data);
	CloseHandle(data);
	new client = GetClientOfUserId(userid);
	new var1;
	if (client < 1 || client > MaxClients || !IsValidEntity(weapon))
	{
		return 0;
	}
	new String:sName[256];
	new iIndex;
	new var2;
	if (16036[client] && GetTrieString(41860[client], "Weapon Colors", sName, 256, 0) && GetTrieValue(g_vara7c8, sName, iIndex))
	{
		new Handle:hTrie = GetArrayCell(g_vara7c4, iIndex, 0, false);
		if (hTrie)
		{
			new iColor[4];
			GetTrieArray(hTrie, "color", iColor, 4, 0);
			.5432.SetEntityRenderMode(weapon, RenderMode:1);
			.5736.SetEntityRenderColor(weapon, iColor[0], iColor[1], iColor[2], iColor[3]);
		}
	}
	return 0;
}

public OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	new var1;
	if (IsFakeClient(client) || !IsValidEntity(weapon))
	{
		return 0;
	}
	new String:sClassname[256];
	.5356.GetEntityClassname(weapon, sClassname, 256);
	new var2;
	if (g_var31e4 && 14452[client] && 38428[client] && g_WeaponEntities.FindString(sClassname) != -1)
	{
		SetEntProp(client, PropType:0, "m_iShotsFired", any:0, 4, 0);
	}
	new String:sName[256];
	new var3;
	if (g_var3230 && 41860[client] && 16828[client] && GetTrieString(41860[client], "Laser Sights", sName, 256, 0))
	{
		new m_unFOV = GetEntProp(client, PropType:1, "m_iFOV", 4, 0);
		new var4;
		if (m_unFOV && m_unFOV == 90 && g_WeaponNames.FindString(sClassname[1]) == -1)
		{
			return 0;
		}
		new iIndex;
		if (GetTrieValue(g_vara7e0, sName, iIndex))
		{
			new Handle:hTrie = GetArrayCell(g_vara7dc, iIndex, 0, false);
			if (hTrie)
			{
				new iColor[4];
				GetTrieArray(hTrie, "color", iColor, 4, 0);
				new Float:m_fOrigin[3] = 0.0;
				GetClientEyePosition(client, m_fOrigin);
				new Float:m_fImpact[3] = 0.0;
				.36360.GetClientSightEnd(client, m_fImpact);
				.7088.TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_var35f0, 0, 0, 0, 0.1, 0.12, 0.0, 1, 0.0, iColor, 0);
				.6632.TE_SendToAll(0.0);
				.6888.TE_SetupGlowSprite(m_fImpact, g_var35f4, 0.1, 0.25, iColor[3]);
				.6632.TE_SendToAll(0.0);
			}
		}
	}
	return 0;
}

.269948.LogTransaction(String:sFile[], bool:bPrint, String:format[])
{
	if (bPrint)
	{
		new String:sLog[1024];
		VFormat(sLog, 1024, format, 4);
		new String:sPath[256];
		BuildPath(PathType:0, sPath, 256, sFile);
		LogToFileEx(sPath, sLog);
	}
	return 0;
}

public Native_GetClientCredits(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return 14188[client];
}

public Native_AddClientCredits(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new credits = GetNativeCell(2);
	return .81756.GiveClientCredits(client, credits, false);
}

public Native_RemoveClientCredits(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new credits = GetNativeCell(2);
	return .82392.RemoveClientCredits(client, credits, false);
}

public Native_TagEquipped(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new String:sBuffer[4];
	new var1;
	return 41860[client] && GetTrieString(41860[client], "Custom Tags", sBuffer, 1, 0);
}

public Native_NameEquipped(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new String:sBuffer[256];
	new var1;
	return 41860[client] && GetTrieString(41860[client], "Name Colors", sBuffer, 256, 0);
}

public Native_ChatEquipped(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new String:sBuffer[256];
	new var1;
	return 41860[client] && GetTrieString(41860[client], "Chat Colors", sBuffer, 256, 0);
}

/*
.2920.RoundFloat(Float:value)
{
	return RoundToNearest(value);
}

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

Float:operator/(Float:,_:)(Float:oper1, oper2)
{
	return oper1 / float(oper2);
}

Float:operator/(Float:,_:)(Float:oper1, oper2)
{
	return oper1 / float(oper2);
}

.3076.StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

.3128.CharToLower(chr)
{
	if (IsCharUpper(chr))
	{
		return chr | 32;
	}
	return chr;
}

.3212.FindCharInString(String:str[], String:c, bool:reverse)
{
	new len = strlen(str);
	if (!reverse)
	{
		new i;
		while (i < len)
		{
			if (c == str[i])
			{
				return i;
			}
			i++;
		}
	}
	else
	{
		new i = len + -1;
		while (0 <= i)
		{
			if (c == str[i])
			{
				return i;
			}
			i--;
		}
	}
	return -1;
}

.3640.StrCat(String:buffer[], maxlength, String:source[])
{
	new len = strlen(buffer);
	if (len >= maxlength)
	{
		return 0;
	}
	return Format(buffer[len], maxlength - len, "%s", source);
}

.3816.ExplodeString(String:text[], String:split[], String:buffers[][], maxStrings, maxStringLength, bool:copyRemainder)
{
	new reloc_idx;
	new idx;
	new total;
	new var1;
	if (maxStrings < 1 || !split[0])
	{
		return 0;
	}
	while ((idx = SplitString(text[reloc_idx], split, buffers[total], maxStringLength)) != -1)
	{
		reloc_idx = idx + reloc_idx;
		total++;
		if (maxStrings == total)
		{
			if (copyRemainder)
			{
				strcopy(buffers[total + -1], maxStringLength, text[reloc_idx - idx]);
			}
			return total;
		}
	}
	total++;
	strcopy(buffers[total], maxStringLength, text[reloc_idx]);
	return total;
}

.4420.ReadFileCell(Handle:hndl, &data, size)
{
	new ret;
	new array[1];
	if ((ret = ReadFile(hndl, array, 1, size)) == 1)
	{
		data = array[0];
	}
	return ret;
}

.4592.StartMessageOne(String:msgname[], client, flags)
{
	new players[1];
	players[0] = client;
	return StartMessage(msgname, players, 1, flags);
}

.4716.PrintToChatAll(String:format[])
{
	decl String:buffer[256];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			SetGlobalTransTarget(i);
			VFormat(buffer, 254, format, 2);
			PrintToChat(i, "%s", buffer);
		}
		i++;
	}
	return 0;
}

.4968.ByteCountToCells(size)
{
	if (!size)
	{
		return 1;
	}
	return size + 3 / 4;
}

.5056.GetEntSendPropOffs(ent, String:prop[], bool:actual)
{
	new String:cls[64];
	if (!GetEntityNetClass(ent, cls, 64))
	{
		return -1;
	}
	new local = -1;
	new offset = FindSendPropInfo(cls, prop, 0, 0, local);
	if (actual)
	{
		return offset;
	}
	return local;
}

.5356.GetEntityClassname(entity, String:clsname[], maxlength)
{
	return !!GetEntPropString(entity, PropType:1, "m_iClassname", clsname, maxlength, 0);
}

.5432.SetEntityRenderMode(entity, RenderMode:mode)
{
	static bool:gotconfig;
	static String:prop[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_nRenderMode", prop, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(prop, 32, "m_nRenderMode");
		}
		gotconfig = true;
	}
	SetEntProp(entity, PropType:0, prop, mode, 1, 0);
	return 0;
}

.5736.SetEntityRenderColor(entity, r, g, b, a)
{
	static bool:gotconfig;
	static String:prop[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_clrRender", prop, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(prop, 32, "m_clrRender");
		}
		gotconfig = true;
	}
	new offset = .5056.GetEntSendPropOffs(entity, prop, false);
	if (0 >= offset)
	{
		ThrowError("SetEntityRenderColor not supported by this mod");
	}
	SetEntData(entity, offset, r, 1, true);
	SetEntData(entity, offset + 1, g, 1, true);
	SetEntData(entity, offset + 2, b, 1, true);
	SetEntData(entity, offset + 3, a, 1, true);
	return 0;
}

.6336.AddFileToDownloadsTable(String:filename[])
{
	static table = -1;
	if (table == -1)
	{
		table = FindStringTable("downloadables");
	}
	new bool:save = LockStringTables(false);
	AddToStringTable(table, filename, "", -1);
	LockStringTables(save);
	return 0;
}

.6532.TE_WriteEncodedEnt(String:prop[], value)
{
	new encvalue = value & 4095 | 4096;
	return TE_WriteNum(prop, encvalue);
}

.6632.TE_SendToAll(Float:delay)
{
	new total;
	new clients[MaxClients];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			total++;
			clients[total] = i;
		}
		i++;
	}
	return TE_Send(clients, total, delay);
}

.6888.TE_SetupGlowSprite(Float:pos[3], Model, Float:Life, Float:Size, Brightness)
{
	TE_Start("GlowSprite");
	TE_WriteVector("m_vecOrigin", pos);
	TE_WriteNum("m_nModelIndex", Model);
	TE_WriteFloat("m_fScale", Size);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteNum("m_nBrightness", Brightness);
	return 0;
}

.7088.TE_SetupBeamPoints(Float:start[3], Float:end[3], ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:EndWidth, FadeLength, Float:Amplitude, Color[4], Speed)
{
	TE_Start("BeamPoints");
	TE_WriteVector("m_vecStartPoint", start);
	TE_WriteVector("m_vecEndPoint", end);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", StartFrame);
	TE_WriteNum("m_nFrameRate", FrameRate);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", EndWidth);
	TE_WriteFloat("m_fAmplitude", Amplitude);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	TE_WriteNum("m_nSpeed", Speed);
	TE_WriteNum("m_nFadeLength", FadeLength);
	return 0;
}

.7696.TE_SetupBeamFollow(EntIndex, ModelIndex, HaloIndex, Float:Life, Float:Width, Float:EndWidth, FadeLength, Color[4])
{
	TE_Start("BeamFollow");
	.6532.TE_WriteEncodedEnt("m_iEntIndex", EntIndex);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", 0);
	TE_WriteNum("m_nFrameRate", 0);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", EndWidth);
	TE_WriteNum("m_nFadeLength", FadeLength);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	return 0;
}

.8200.Downloader_GetMaterialsFromMDL(String:model[], String:files[][], maxsize, maxlen)
{
	if (!FileExists(model, false, "GAME"))
	{
		return 0;
	}
	new m_iNum;
	new Handle:m_hFile = OpenFile(model, "rb", false, "GAME");
	FileSeek(m_hFile, 204, 0);
	.4420.ReadFileCell(m_hFile, m_iNum, 4);
	FileSeek(m_hFile, 0, 2);
	decl m_cChar;
	decl m_iPos;
	do {
		FileSeek(m_hFile, -2, 1);
		.4420.ReadFileCell(m_hFile, m_cChar, 1);
	} while (m_cChar);
	FileSeek(m_hFile, 1, 1);
	decl String:m_szPath[256];
	do {
		FileSeek(m_hFile, -2, 1);
		.4420.ReadFileCell(m_hFile, m_cChar, 1);
	} while (m_cChar);
	m_iPos = FilePosition(m_hFile);
	ReadFileString(m_hFile, m_szPath, 256, -1);
	FileSeek(m_hFile, m_iPos, 0);
	decl m_iRet;
	decl String:m_szFile[256];
	m_iRet = 0;
	while (m_iRet < m_iNum)
	{
		if (!(maxsize == m_iNum))
		{
			FileSeek(m_hFile, -1, 1);
			do {
				FileSeek(m_hFile, -2, 1);
				.4420.ReadFileCell(m_hFile, m_cChar, 1);
			} while (m_cChar);
			m_iPos = FilePosition(m_hFile);
			ReadFileString(m_hFile, m_szFile, 256, -1);
			Format(files[m_iRet], maxlen, "materials\%s%s.vmt", m_szPath, m_szFile);
			FileSeek(m_hFile, m_iPos, 0);
			m_iRet++;
		}
		return m_iRet;
	}
	return m_iRet;
}

.9340.Downloader_GetModelFiles(String:model[], String:files[][], maxsize, maxlen)
{
	decl String:m_szRawPath[256];
	strcopy(m_szRawPath, 256, model);
	new m_iDot = .3212.FindCharInString(m_szRawPath, String:46, true);
	if (m_iDot == -1)
	{
		return 0;
	}
	m_szRawPath[m_iDot] = MissingTAG:0;
	new m_iNum;
	new i;
	while (i < 7)
	{
		if (!(maxsize == m_iNum))
		{
			Format(files[m_iNum], maxlen, "%s%s", m_szRawPath, 3108[i]);
			if (FileExists(files[m_iNum], false, "GAME"))
			{
				m_iNum++;
			}
			i++;
		}
		return m_iNum;
	}
	return m_iNum;
}

.9892.Downloader_GetMaterialsFromVMT(String:vmt[], String:materials[][], maxsize, maxlen)
{
	if (!FileExists(vmt, false, "GAME"))
	{
		return 0;
	}
	decl String:m_szLine[512];
	new Handle:m_hFile = OpenFile(vmt, "r", false, "GAME");
	new bool:m_bFound[3];
	decl m_iPos;
	decl m_iLast;
	new m_iNum;
	while (ReadFileLine(m_hFile, m_szLine, 512))
	{
		new var1;
		if (!(m_iNum == 3 || m_iNum != maxsize))
		{
			new i;
			while (i < 3)
			{
				if (!m_bFound[i])
				{
					if (0 < (m_iPos = StrContains(m_szLine, 3256[i], false)))
					{
						m_bFound[i] = true;
						while (m_szLine[m_iPos] != '"' && m_szLine[m_iPos] != ' ' && m_szLine[m_iPos] != '\x09')
						{
							m_iPos++;
						}
						while (m_szLine[m_iPos] == ' ' || m_szLine[m_iPos] == '\x09' || m_szLine[m_iPos] == '"')
						{
							m_iPos++;
						}
						m_iLast = m_iPos;
						while (m_szLine[m_iLast] != '"' && m_szLine[m_iLast] != '
' && m_szLine[m_iLast] != '\n' && m_szLine[m_iLast] != ' ' && m_szLine[m_iLast] != '\x09' && m_szLine[m_iLast])
						{
							m_iLast++;
						}
						m_szLine[m_iLast] = MissingTAG:0;
						strcopy(materials[m_iNum], maxlen, m_szLine[m_iPos]);
						m_iNum++;
					}
				}
				i++;
			}
		}
		CloseHandle(m_hFile);
		return m_iNum;
	}
	CloseHandle(m_hFile);
	return m_iNum;
}

.11516.Downloader_AddFileToDownloadsTable(String:filename[])
{
	if (!FileExists(filename, false, "GAME"))
	{
		return 0;
	}
	if (!g_vard8c)
	{
		g_vard8c = CreateTrie();
		g_vard88 = CreateArray(256, 0);
	}
	.6336.AddFileToDownloadsTable(filename);
	decl m_iValue;
	if (GetTrieValue(g_vard8c, filename, m_iValue))
	{
		new m_iStart = FindStringInArray(g_vard88, filename) + 1;
		decl String:m_szFile[256];
		new i = m_iStart - m_iValue + -1;
		while (m_iStart + -1 > i)
		{
			GetArrayString(g_vard88, i, m_szFile, 256);
			.6336.AddFileToDownloadsTable(m_szFile);
			i++;
		}
		return 1;
	}
	decl String:m_szExt[16];
	new m_iDot = .3212.FindCharInString(filename, String:46, true);
	if (m_iDot == -1)
	{
		return 1;
	}
	new m_iNumFiles;
	strcopy(m_szExt, 16, filename[m_iDot]);
	new String:m_szMaterials[16][256] = {
		".mdl",
		"ssor.smx",
		"",
		"",
		"",
		"%s",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	};
	decl m_iNum;
	if (strcmp(m_szExt, ".mdl", true))
	{
		if (!(strcmp(m_szExt, ".vmt", true)))
		{
			m_iNum = .9892.Downloader_GetMaterialsFromVMT(filename, m_szMaterials, 16, 256);
			decl String:m_szMaterial[256];
			new i;
			while (i < m_iNum)
			{
				Format(m_szMaterial, 256, "materials\%s.vtf", m_szMaterials[i]);
				if (FileExists(m_szMaterial, false, "GAME"))
				{
					m_iNumFiles = .11516.Downloader_AddFileToDownloadsTable(m_szMaterial) + 1 + m_iNumFiles;
				}
				else
				{
					PrintToServer("Unable to find 2: %s - source: %s", m_szMaterial, filename);
				}
				i++;
			}
		}
	}
	else
	{
		new String:m_szFiles[7][256] = {
			"Unable to find 1: %s - source: %s",
			"",
			"",
			"",
			"",
			"\x01",
			"H"
		};
		m_iNum = .9340.Downloader_GetModelFiles(filename, m_szFiles, 7, 256);
		new i;
		while (i < m_iNum)
		{
			m_iNumFiles = .11516.Downloader_AddFileToDownloadsTable(m_szFiles[i]) + 1 + m_iNumFiles;
			i++;
		}
		m_iNum = .8200.Downloader_GetMaterialsFromMDL(filename, m_szMaterials, 16, 256);
		new i;
		while (i < m_iNum)
		{
			if (FileExists(m_szMaterials[i], false, "GAME"))
			{
				m_iNumFiles = .11516.Downloader_AddFileToDownloadsTable(m_szMaterials[i]) + 1 + m_iNumFiles;
			}
			else
			{
				PrintToServer("Unable to find 1: %s - source: %s", m_szMaterials[i], filename);
			}
			i++;
		}
	}
	PushArrayString(g_vard88, filename);
	SetTrieValue(g_vard8c, filename, m_iNumFiles, true);
	return m_iNumFiles;
}

.13512.CSetPrefix(String:sPrefix[])
{
	VFormat("", 64, sPrefix, 2);
	return 0;
}

.13572.CPrintToChat(iClient, String:sMessage[])
{
	new var1;
	if (iClient < 1 || iClient > MaxClients)
	{
		ThrowError("Invalid client index %d", iClient);
	}
	if (!IsClientInGame(iClient))
	{
		ThrowError("Client %d is not in game", iClient);
	}
	decl String:sBuffer[1024];
	SetGlobalTransTarget(iClient);
	VFormat(sBuffer, 1024, sMessage, 3);
	.34576.AddPrefixAndDefaultColor(sBuffer, 1024, "default", "prefix");
	g_var1130 = 0;
	.15332.CProcessVariables(sBuffer, 1024, false);
	.19000.CAddWhiteSpace(sBuffer, 1024);
	.34788.SendPlayerMessage(iClient, sBuffer, g_var1134);
	g_var1134 = 0;
	return 0;
}

.14112.CPrintToChatAll(String:sMessage[])
{
	decl String:sBuffer[1024];
	new iClient = 1;
	while (iClient <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(iClient) || 4408[iClient])
		{
			4408[iClient] = 0;
		}
		else
		{
			SetGlobalTransTarget(iClient);
			VFormat(sBuffer, 1024, sMessage, 2);
			.34576.AddPrefixAndDefaultColor(sBuffer, 1024, "default", "prefix");
			g_var1130 = 0;
			.15332.CProcessVariables(sBuffer, 1024, false);
			.19000.CAddWhiteSpace(sBuffer, 1024);
			.34788.SendPlayerMessage(iClient, sBuffer, g_var1134);
		}
		iClient++;
	}
	g_var1134 = 0;
	return 0;
}

.14692.CReplyToCommand(iClient, String:sMessage[])
{
	new var1;
	if (iClient < 0 || iClient > MaxClients)
	{
		ThrowError("Invalid client index %d", iClient);
	}
	new var2;
	if (iClient && !IsClientInGame(iClient))
	{
		ThrowError("Client %d is not in game", iClient);
	}
	decl String:sBuffer[1024];
	SetGlobalTransTarget(iClient);
	VFormat(sBuffer, 1024, sMessage, 3);
	.34576.AddPrefixAndDefaultColor(sBuffer, 1024, "reply2cmd", "prefix");
	g_var1130 = 0;
	if (GetCmdReplySource())
	{
		.13572.CPrintToChat(iClient, "%s", sBuffer);
	}
	else
	{
		.15276.CRemoveColors(sBuffer, 1024);
		PrintToConsole(iClient, "%s", sBuffer);
	}
	return 0;
}

.15276.CRemoveColors(String:sMsg[], iSize)
{
	.15332.CProcessVariables(sMsg, iSize, true);
	return 0;
}

.15332.CProcessVariables(String:sMsg[], iSize, bool:bRemoveColors)
{
	if (!.19092.Init())
	{
		return 0;
	}
	new sOut[iSize];
	new sCode[iSize];
	new sColor[iSize];
	new iOutPos;
	new iCodePos = -1;
	new iMsgLen = strlen(sMsg);
	new i;
	while (i < iMsgLen)
	{
		if (sMsg[i] == '{')
		{
			iCodePos = 0;
		}
		if (iCodePos > -1)
		{
			sCode[iCodePos] = sMsg[i];
			sCode[iCodePos + 1] = MissingTAG:0;
			new var1;
			if (sMsg[i] == '}' || iMsgLen + -1 != i)
			{
				strcopy(sCode, strlen(sCode) + -1, sCode[0]);
				.25720.StringToLower(sCode);
				if (.16564.CGetColor(sCode, sColor, iSize))
				{
					if (!bRemoveColors)
					{
						.3640.StrCat(sOut, iSize, sColor);
						iOutPos = strlen(sColor) + iOutPos;
					}
				}
				else
				{
					Format(sOut, iSize, "%s{%s}", sOut, sCode);
					iOutPos = strlen(sCode) + 2 + iOutPos;
				}
				iCodePos = -1;
				strcopy(sCode, iSize, "");
				strcopy(sColor, iSize, "");
			}
			else
			{
				iCodePos++;
			}
		}
		else
		{
			sOut[iOutPos] = sMsg[i];
			iOutPos++;
			sOut[iOutPos] = MissingTAG:0;
		}
		i++;
	}
	strcopy(sMsg, iSize, sOut);
	return 0;
}

.16564.CGetColor(String:sName[], String:sColor[], iColorSize)
{
	if (sName[0])
	{
		if (sName[0] == '@')
		{
			new iSpace;
			new String:sData[64];
			new String:m_sName[64];
			strcopy(m_sName, 64, sName[0]);
			new var1;
			if ((iSpace = .3212.FindCharInString(m_sName, String:32, false)) != -1 && iSpace + 1 < strlen(m_sName))
			{
				strcopy(m_sName, iSpace + 1, m_sName);
				strcopy(sData, 64, m_sName[iSpace + 1]);
			}
			Call_StartForward(g_var1240);
			Call_PushString(m_sName);
			Call_PushStringEx(sData, 64, 3, 0);
			Call_PushCell(any:64);
			Call_PushStringEx(sColor, iColorSize, 3, 1);
			Call_PushCell(iColorSize);
			Call_Finish(0);
			if (sColor[0])
			{
				return 1;
			}
		}
		else
		{
			if (sName[0] == '#')
			{
				if (strlen(sName) == 7)
				{
					Format(sColor, iColorSize, "\x07%s", sName[0]);
					return 1;
				}
				if (strlen(sName) == 9)
				{
					Format(sColor, iColorSize, "\x08%s", sName[0]);
					return 1;
				}
			}
			new var2;
			if (StrContains(sName, "player ", false) && strlen(sName) > 7)
			{
				new iClient = StringToInt(sName[1], 10);
				new var3;
				if (iClient < 1 || iClient > MaxClients || !IsClientInGame(iClient))
				{
					strcopy(sColor, iColorSize, "\x01");
					LogError("Invalid client index %d", iClient);
					return 0;
				}
				strcopy(sColor, iColorSize, "\x01");
				switch (GetClientTeam(iClient))
				{
					case 1:
					{
						GetTrieString(g_vareec, "team0", sColor, iColorSize, 0);
					}
					case 2:
					{
						GetTrieString(g_vareec, "team1", sColor, iColorSize, 0);
					}
					case 3:
					{
						GetTrieString(g_vareec, "team2", sColor, iColorSize, 0);
					}
					default:
					{
					}
				}
				return 1;
			}
			return GetTrieString(g_vareec, sName, sColor, iColorSize, 0);
		}
		return 0;
	}
	return 0;
}

.18436.CSayText2(iClient, String:sMessage[], iAuthor)
{
	new Handle:hMsg = .4592.StartMessageOne("SayText2", iClient, 132);
	new var1;
	if (GetFeatureStatus(FeatureType:0, "GetUserMessageType") && GetUserMessageType() == 1)
	{
		PbSetInt(hMsg, "ent_idx", iAuthor, -1);
		PbSetBool(hMsg, "chat", true, -1);
		PbSetString(hMsg, "msg_name", sMessage, -1);
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
	}
	else
	{
		BfWriteByte(hMsg, iAuthor);
		BfWriteByte(hMsg, 1);
		BfWriteString(hMsg, sMessage);
	}
	EndMessage();
	return 0;
}

.19000.CAddWhiteSpace(String:sBuffer[], iSize)
{
	if (!.34328.IsSource2009())
	{
		Format(sBuffer, iSize, " %s", sBuffer);
	}
	return 0;
}

.19092.Init()
{
	if (g_varee8)
	{
		.23064.LoadColors();
		return 1;
	}
	new String:sPluginName[256];
	new String:sDirectoryPath[256];
	new Handle:hConfig;
	GetPluginFilename(Handle:0, sPluginName, 256);
	ReplaceStringEx(sPluginName, 256, "\", "/", -1, -1, true);
	new iSlash = .3212.FindCharInString(sPluginName, String:47, true);
	if (iSlash > -1)
	{
		strcopy(sPluginName, 256, sPluginName[iSlash + 1]);
	}
	ReplaceStringEx(sPluginName, 256, ".smx", "", -1, -1, true);
	BuildPath(PathType:0, sDirectoryPath, 256, "%s/", "configs/colorvariables");
	if (!DirExists(sDirectoryPath, false, "GAME"))
	{
		CreateDirectory(sDirectoryPath, 511, false, "DEFAULT_WRITE_PATH");
	}
	new String:sGlobalVariableList[15][2][64] = {
		{
			"prefix",
			"{engine 2}"
		},
		{
			"default",
			"{engine 1}"
		},
		{
			"reply2cmd",
			"{engine 1}"
		},
		{
			"showactivity",
			"{engine 1}"
		},
		{
			"",
			""
		},
		{
			"error",
			"{engine 3}"
		},
		{
			"",
			""
		},
		{
			"highlight",
			"{engine 2}"
		},
		{
			"player",
			"{engine 2}"
		},
		{
			"settings",
			"{engine 2}"
		},
		{
			"command",
			"{engine 2}"
		},
		{
			"",
			""
		},
		{
			"team0",
			"{engine 8}"
		},
		{
			"team1",
			"{engine 9}"
		},
		{
			"team2",
			"{engine 11}"
		}
	};
	if (.34328.IsSource2009())
	{
		strcopy(sGlobalVariableList[12][1], 64, "{#cccccc}");
		strcopy(sGlobalVariableList[13][1], 64, "{#ff4040}");
		strcopy(sGlobalVariableList[14][1], 64, "{#4d7942}");
	}
	BuildPath(PathType:0, "", 256, "%s/global.cfg", "configs/colorvariables");
	if (!FileExists("", false, "GAME"))
	{
		hConfig = OpenFile("", "w", false, "GAME");
		if (hConfig)
		{
			WriteFileLine(hConfig, "// Version: %s", "1.3");
			WriteFileLine(hConfig, "\"colorvariables\"");
			WriteFileLine(hConfig, "{");
			new i;
			while (i < 15)
			{
				if (sGlobalVariableList[i][0][0])
				{
					WriteFileLine(hConfig, "\x09\"%s\" \"%s\"", sGlobalVariableList[i][0], sGlobalVariableList[i][1]);
				}
				else
				{
					WriteFileLine(hConfig, "");
				}
				i++;
			}
			WriteFileLine(hConfig, "}");
			CloseHandle(hConfig);
			hConfig = MissingTAG:0;
		}
		LogError("Cannot create file '%s' !", "");
		return 0;
	}
	else
	{
		hConfig = OpenFile("", "r", false, "GAME");
		if (hConfig)
		{
			new String:sVersionLine[64];
			ReadFileLine(hConfig, sVersionLine, 64);
			CloseHandle(hConfig);
			TrimString(sVersionLine);
			strcopy(sVersionLine, 64, sVersionLine[.3212.FindCharInString(sVersionLine, String:58, false) + 2]);
			if (StringToFloat(sVersionLine) < StringToFloat("1.3"))
			{
				new Handle:hKV = CreateKeyValues("colorvariables", "", "");
				new var1;
				if (!FileToKeyValues(hKV, "") || !KvGotoFirstSubKey(hKV, false))
				{
					CloseHandle(hKV);
					LogError("Cannot read variables from file '%s' !", "");
					return 0;
				}
				new i;
				while (i < 15)
				{
					if (sGlobalVariableList[i][0][0])
					{
						if (!KvJumpToKey(hKV, sGlobalVariableList[i][0], false))
						{
							KvSetString(hKV, sGlobalVariableList[i][0], sGlobalVariableList[i][1]);
						}
					}
					i++;
				}
				hConfig = OpenFile("", "w", false, "GAME");
				if (hConfig)
				{
					WriteFileLine(hConfig, "// Version: %s", "1.3");
					WriteFileLine(hConfig, "\"colorvariables\"");
					WriteFileLine(hConfig, "{");
					new String:sCode[64];
					new String:sColor[64];
					KvGotoFirstSubKey(hKV, false);
					do {
						KvGetSectionName(hKV, sCode, 64);
						KvGetString(hKV, NULL_STRING, sColor, 64, "");
						.25720.StringToLower(sCode);
						.25720.StringToLower(sColor);
						WriteFileLine(hConfig, "\x09\"%s\" \"%s\"", sCode, sColor);
					} while (KvGotoNextKey(hKV, false));
					WriteFileLine(hConfig, "}");
					CloseHandle(hConfig);
					CloseHandle(hKV);
				}
				LogError("Cannot write to file '%s' !", "");
				return 0;
			}
		}
		LogError("Cannot read from file '%s' !", "");
		return 0;
	}
	BuildPath(PathType:0, "", 256, "%s/plugin.%s.cfg", "configs/colorvariables", sPluginName);
	if (!FileExists("", false, "GAME"))
	{
		hConfig = OpenFile("", "w", false, "GAME");
		if (hConfig)
		{
			WriteFileLine(hConfig, "\"colorvariables\"\n{\n}");
			CloseHandle(hConfig);
			hConfig = MissingTAG:0;
		}
		LogError("Cannot create file '%s' !", "");
		return 0;
	}
	new iClient = 1;
	while (iClient <= MaxClients)
	{
		4408[iClient] = 0;
		iClient++;
	}
	g_var1240 = CreateGlobalForward("COnForwardedVariable", ExecType:0, 7, 7, 2, 7, 2);
	.23064.LoadColors();
	g_varee8 = 1;
	return 1;
}

.23064.LoadColors()
{
	if (!g_vareec)
	{
		g_vareec = CreateTrie();
		new Handle:hRedirect = CreateArray(64, 0);
		AddColors(g_vareec);
		.23368.LoadConfigFile(g_vareec, "", hRedirect, true);
		.23368.LoadConfigFile(g_vareec, "", hRedirect, true);
		.24492.SolveRedirects(g_vareec, hRedirect);
		CloseHandle(hRedirect);
	}
	return 0;
}

.23368.LoadConfigFile(Handle:hTrie, String:sPath[], Handle:hRedirect, bool:bAllowPrefix)
{
	if (!FileExists(sPath, false, "GAME"))
	{
		LogError("Cannot load color variables from file '%s' - file doesn't exist!", sPath);
		return 0;
	}
	new Handle:hKV = CreateKeyValues("colorvariables", "", "");
	if (!FileToKeyValues(hKV, sPath))
	{
		CloseHandle(hKV);
		LogError("Cannot load color variables from file '%s' !", sPath);
		return 0;
	}
	if (!KvGotoFirstSubKey(hKV, false))
	{
		CloseHandle(hKV);
		return 0;
	}
	new String:sCode[64];
	new String:sColor[64];
	do {
		KvGetSectionName(hKV, sCode, 64);
		KvGetString(hKV, NULL_STRING, sColor, 64, "");
		new var1;
		if (bAllowPrefix && .3076.StrEqual(sCode, "&prefix", false))
		{
			.13512.CSetPrefix(sColor);
		}
		else
		{
			.25720.StringToLower(sCode);
			new var2;
			if (.25580.HasBrackets(sColor) && sColor[0] == '@')
			{
				LogError("Variables cannot be redirected to forwarded variables! (variable '%s')", sCode);
			}
			if (.25580.HasBrackets(sColor))
			{
				if (sColor[0] == '#')
				{
					Format(sColor, 64, "\x07%s", sColor[0]);
				}
				PushArrayString(hRedirect, sCode);
			}
			SetTrieString(hTrie, sCode, sColor, true);
		}
	} while (KvGotoNextKey(hKV, false));
	CloseHandle(hKV);
	return 0;
}

.24492.SolveRedirects(Handle:hTrie, Handle:hRedirect)
{
	new String:sCode[64];
	new String:sRedirect[64];
	new String:sColor[64];
	new String:sFirstColor[64];
	new iRedirectLife;
	new bool:bHasBrackets;
	new i;
	while (GetArraySize(hRedirect) > i)
	{
		GetArrayString(hRedirect, i, sRedirect, 64);
		strcopy(sCode, 64, sRedirect);
		bHasBrackets = true;
		GetTrieString(hTrie, sRedirect, sColor, 64, 0);
		strcopy(sFirstColor, 64, sRedirect);
		iRedirectLife = 10;
		while (!.25580.HasBrackets(sColor))
		{
			strcopy(sRedirect, 64, sColor);
			bHasBrackets = false;
			if (bHasBrackets)
			{
				Format(sRedirect, 64, "{%s}", sRedirect);
			}
			.25720.StringToLower(sCode);
			.25720.StringToLower(sRedirect);
			SetTrieString(hTrie, sCode, sRedirect, true);
			i++;
		}
		strcopy(sColor, strlen(sColor) + -1, sColor[0]);
		if (0 < iRedirectLife)
		{
			strcopy(sRedirect, 64, sColor);
			iRedirectLife--;
			if (GetTrieString(hTrie, sRedirect, sColor, 64, 0))
			{
			}
			if (bHasBrackets)
			{
				Format(sRedirect, 64, "{%s}", sRedirect);
			}
			.25720.StringToLower(sCode);
			.25720.StringToLower(sRedirect);
			SetTrieString(hTrie, sCode, sRedirect, true);
			i++;
		}
		strcopy(sRedirect, 64, sFirstColor);
		LogError("Too many redirects for variable '%s' !", sCode);
		if (bHasBrackets)
		{
			Format(sRedirect, 64, "{%s}", sRedirect);
		}
		.25720.StringToLower(sCode);
		.25720.StringToLower(sRedirect);
		SetTrieString(hTrie, sCode, sRedirect, true);
		i++;
	}
	return 0;
}

.25580.HasBrackets(String:sSource[])
{
	new var1;
	return sSource[0] == '{' && sSource[strlen(sSource) + -1] == '}';
}

.25720.StringToLower(String:sSource[])
{
	new i;
	while (strlen(sSource) > i)
	{
		if (sSource[i])
		{
			sSource[i] = .3128.CharToLower(sSource[i]);
			i++;
		}
		return 0;
	}
	return 0;
}

AddColors(Handle:hTrie)
{
	if (.34328.IsSource2009())
	{
		SetTrieString(hTrie, "default", "\x01", true);
		SetTrieString(hTrie, "teamcolor", "\x03", true);
		SetTrieString(hTrie, "aliceblue", "\x07F0F8FF", true);
		SetTrieString(hTrie, "allies", "\x074D7942", true);
		SetTrieString(hTrie, "ancient", "\x07EB4B4B", true);
		SetTrieString(hTrie, "antiquewhite", "\x07FAEBD7", true);
		SetTrieString(hTrie, "aqua", "\x0700FFFF", true);
		SetTrieString(hTrie, "aquamarine", "\x077FFFD4", true);
		SetTrieString(hTrie, "arcana", "\x07ADE55C", true);
		SetTrieString(hTrie, "axis", "\x07FF4040", true);
		SetTrieString(hTrie, "azure", "\x07007FFF", true);
		SetTrieString(hTrie, "beige", "\x07F5F5DC", true);
		SetTrieString(hTrie, "bisque", "\x07FFE4C4", true);
		SetTrieString(hTrie, "black", "\x07000000", true);
		SetTrieString(hTrie, "blanchedalmond", "\x07FFEBCD", true);
		SetTrieString(hTrie, "blue", "\x0799CCFF", true);
		SetTrieString(hTrie, "blueviolet", "\x078A2BE2", true);
		SetTrieString(hTrie, "brown", "\x07A52A2A", true);
		SetTrieString(hTrie, "burlywood", "\x07DEB887", true);
		SetTrieString(hTrie, "cadetblue", "\x075F9EA0", true);
		SetTrieString(hTrie, "chartreuse", "\x077FFF00", true);
		SetTrieString(hTrie, "chocolate", "\x07D2691E", true);
		SetTrieString(hTrie, "collectors", "\x07AA0000", true);
		SetTrieString(hTrie, "common", "\x07B0C3D9", true);
		SetTrieString(hTrie, "community", "\x0770B04A", true);
		SetTrieString(hTrie, "coral", "\x07FF7F50", true);
		SetTrieString(hTrie, "cornflowerblue", "\x076495ED", true);
		SetTrieString(hTrie, "cornsilk", "\x07FFF8DC", true);
		SetTrieString(hTrie, "corrupted", "\x07A32C2E", true);
		SetTrieString(hTrie, "crimson", "\x07DC143C", true);
		SetTrieString(hTrie, "cyan", "\x0700FFFF", true);
		SetTrieString(hTrie, "darkblue", "\x0700008B", true);
		SetTrieString(hTrie, "darkcyan", "\x07008B8B", true);
		SetTrieString(hTrie, "darkgoldenrod", "\x07B8860B", true);
		SetTrieString(hTrie, "darkgray", "\x07A9A9A9", true);
		SetTrieString(hTrie, "darkgrey", "\x07A9A9A9", true);
		SetTrieString(hTrie, "darkgreen", "\x07006400", true);
		SetTrieString(hTrie, "darkkhaki", "\x07BDB76B", true);
		SetTrieString(hTrie, "darkmagenta", "\x078B008B", true);
		SetTrieString(hTrie, "darkolivegreen", "\x07556B2F", true);
		SetTrieString(hTrie, "darkorange", "\x07FF8C00", true);
		SetTrieString(hTrie, "darkorchid", "\x079932CC", true);
		SetTrieString(hTrie, "darkred", "\x078B0000", true);
		SetTrieString(hTrie, "darksalmon", "\x07E9967A", true);
		SetTrieString(hTrie, "darkseagreen", "\x078FBC8F", true);
		SetTrieString(hTrie, "darkslateblue", "\x07483D8B", true);
		SetTrieString(hTrie, "darkslategray", "\x072F4F4F", true);
		SetTrieString(hTrie, "darkslategrey", "\x072F4F4F", true);
		SetTrieString(hTrie, "darkturquoise", "\x0700CED1", true);
		SetTrieString(hTrie, "darkviolet", "\x079400D3", true);
		SetTrieString(hTrie, "deeppink", "\x07FF1493", true);
		SetTrieString(hTrie, "deepskyblue", "\x0700BFFF", true);
		SetTrieString(hTrie, "dimgray", "\x07696969", true);
		SetTrieString(hTrie, "dimgrey", "\x07696969", true);
		SetTrieString(hTrie, "dodgerblue", "\x071E90FF", true);
		SetTrieString(hTrie, "exalted", "\x07CCCCCD", true);
		SetTrieString(hTrie, "firebrick", "\x07B22222", true);
		SetTrieString(hTrie, "floralwhite", "\x07FFFAF0", true);
		SetTrieString(hTrie, "forestgreen", "\x07228B22", true);
		SetTrieString(hTrie, "frozen", "\x074983B3", true);
		SetTrieString(hTrie, "fuchsia", "\x07FF00FF", true);
		SetTrieString(hTrie, "fullblue", "\x070000FF", true);
		SetTrieString(hTrie, "fullred", "\x07FF0000", true);
		SetTrieString(hTrie, "gainsboro", "\x07DCDCDC", true);
		SetTrieString(hTrie, "genuine", "\x074D7455", true);
		SetTrieString(hTrie, "ghostwhite", "\x07F8F8FF", true);
		SetTrieString(hTrie, "gold", "\x07FFD700", true);
		SetTrieString(hTrie, "goldenrod", "\x07DAA520", true);
		SetTrieString(hTrie, "gray", "\x07CCCCCC", true);
		SetTrieString(hTrie, "grey", "\x07CCCCCC", true);
		SetTrieString(hTrie, "green", "\x073EFF3E", true);
		SetTrieString(hTrie, "greenyellow", "\x07ADFF2F", true);
		SetTrieString(hTrie, "haunted", "\x0738F3AB", true);
		SetTrieString(hTrie, "honeydew", "\x07F0FFF0", true);
		SetTrieString(hTrie, "hotpink", "\x07FF69B4", true);
		SetTrieString(hTrie, "immortal", "\x07E4AE33", true);
		SetTrieString(hTrie, "indianred", "\x07CD5C5C", true);
		SetTrieString(hTrie, "indigo", "\x074B0082", true);
		SetTrieString(hTrie, "ivory", "\x07FFFFF0", true);
		SetTrieString(hTrie, "khaki", "\x07F0E68C", true);
		SetTrieString(hTrie, "lavender", "\x07E6E6FA", true);
		SetTrieString(hTrie, "lavenderblush", "\x07FFF0F5", true);
		SetTrieString(hTrie, "lawngreen", "\x077CFC00", true);
		SetTrieString(hTrie, "legendary", "\x07D32CE6", true);
		SetTrieString(hTrie, "lemonchiffon", "\x07FFFACD", true);
		SetTrieString(hTrie, "lightblue", "\x07ADD8E6", true);
		SetTrieString(hTrie, "lightcoral", "\x07F08080", true);
		SetTrieString(hTrie, "lightcyan", "\x07E0FFFF", true);
		SetTrieString(hTrie, "lightgoldenrodyellow", "\x07FAFAD2", true);
		SetTrieString(hTrie, "lightgray", "\x07D3D3D3", true);
		SetTrieString(hTrie, "lightgrey", "\x07D3D3D3", true);
		SetTrieString(hTrie, "lightgreen", "\x0799FF99", true);
		SetTrieString(hTrie, "lightpink", "\x07FFB6C1", true);
		SetTrieString(hTrie, "lightsalmon", "\x07FFA07A", true);
		SetTrieString(hTrie, "lightseagreen", "\x0720B2AA", true);
		SetTrieString(hTrie, "lightskyblue", "\x0787CEFA", true);
		SetTrieString(hTrie, "lightslategray", "\x07778899", true);
		SetTrieString(hTrie, "lightslategrey", "\x07778899", true);
		SetTrieString(hTrie, "lightsteelblue", "\x07B0C4DE", true);
		SetTrieString(hTrie, "lightyellow", "\x07FFFFE0", true);
		SetTrieString(hTrie, "lime", "\x0700FF00", true);
		SetTrieString(hTrie, "limegreen", "\x0732CD32", true);
		SetTrieString(hTrie, "linen", "\x07FAF0E6", true);
		SetTrieString(hTrie, "magenta", "\x07FF00FF", true);
		SetTrieString(hTrie, "maroon", "\x07800000", true);
		SetTrieString(hTrie, "mediumaquamarine", "\x0766CDAA", true);
		SetTrieString(hTrie, "mediumblue", "\x070000CD", true);
		SetTrieString(hTrie, "mediumorchid", "\x07BA55D3", true);
		SetTrieString(hTrie, "mediumpurple", "\x079370D8", true);
		SetTrieString(hTrie, "mediumseagreen", "\x073CB371", true);
		SetTrieString(hTrie, "mediumslateblue", "\x077B68EE", true);
		SetTrieString(hTrie, "mediumspringgreen", "\x0700FA9A", true);
		SetTrieString(hTrie, "mediumturquoise", "\x0748D1CC", true);
		SetTrieString(hTrie, "mediumvioletred", "\x07C71585", true);
		SetTrieString(hTrie, "midnightblue", "\x07191970", true);
		SetTrieString(hTrie, "mintcream", "\x07F5FFFA", true);
		SetTrieString(hTrie, "mistyrose", "\x07FFE4E1", true);
		SetTrieString(hTrie, "moccasin", "\x07FFE4B5", true);
		SetTrieString(hTrie, "mythical", "\x078847FF", true);
		SetTrieString(hTrie, "navajowhite", "\x07FFDEAD", true);
		SetTrieString(hTrie, "navy", "\x07000080", true);
		SetTrieString(hTrie, "normal", "\x07B2B2B2", true);
		SetTrieString(hTrie, "oldlace", "\x07FDF5E6", true);
		SetTrieString(hTrie, "olive", "\x079EC34F", true);
		SetTrieString(hTrie, "olivedrab", "\x076B8E23", true);
		SetTrieString(hTrie, "orange", "\x07FFA500", true);
		SetTrieString(hTrie, "orangered", "\x07FF4500", true);
		SetTrieString(hTrie, "orchid", "\x07DA70D6", true);
		SetTrieString(hTrie, "palegoldenrod", "\x07EEE8AA", true);
		SetTrieString(hTrie, "palegreen", "\x0798FB98", true);
		SetTrieString(hTrie, "paleturquoise", "\x07AFEEEE", true);
		SetTrieString(hTrie, "palevioletred", "\x07D87093", true);
		SetTrieString(hTrie, "papayawhip", "\x07FFEFD5", true);
		SetTrieString(hTrie, "peachpuff", "\x07FFDAB9", true);
		SetTrieString(hTrie, "peru", "\x07CD853F", true);
		SetTrieString(hTrie, "pink", "\x07FFC0CB", true);
		SetTrieString(hTrie, "plum", "\x07DDA0DD", true);
		SetTrieString(hTrie, "powderblue", "\x07B0E0E6", true);
		SetTrieString(hTrie, "purple", "\x07800080", true);
		SetTrieString(hTrie, "rare", "\x074B69FF", true);
		SetTrieString(hTrie, "red", "\x07FF4040", true);
		SetTrieString(hTrie, "rosybrown", "\x07BC8F8F", true);
		SetTrieString(hTrie, "royalblue", "\x074169E1", true);
		SetTrieString(hTrie, "saddlebrown", "\x078B4513", true);
		SetTrieString(hTrie, "salmon", "\x07FA8072", true);
		SetTrieString(hTrie, "sandybrown", "\x07F4A460", true);
		SetTrieString(hTrie, "seagreen", "\x072E8B57", true);
		SetTrieString(hTrie, "seashell", "\x07FFF5EE", true);
		SetTrieString(hTrie, "selfmade", "\x0770B04A", true);
		SetTrieString(hTrie, "sienna", "\x07A0522D", true);
		SetTrieString(hTrie, "silver", "\x07C0C0C0", true);
		SetTrieString(hTrie, "skyblue", "\x0787CEEB", true);
		SetTrieString(hTrie, "slateblue", "\x076A5ACD", true);
		SetTrieString(hTrie, "slategray", "\x07708090", true);
		SetTrieString(hTrie, "slategrey", "\x07708090", true);
		SetTrieString(hTrie, "snow", "\x07FFFAFA", true);
		SetTrieString(hTrie, "springgreen", "\x0700FF7F", true);
		SetTrieString(hTrie, "steelblue", "\x074682B4", true);
		SetTrieString(hTrie, "strange", "\x07CF6A32", true);
		SetTrieString(hTrie, "tan", "\x07D2B48C", true);
		SetTrieString(hTrie, "teal", "\x07008080", true);
		SetTrieString(hTrie, "thistle", "\x07D8BFD8", true);
		SetTrieString(hTrie, "tomato", "\x07FF6347", true);
		SetTrieString(hTrie, "turquoise", "\x0740E0D0", true);
		SetTrieString(hTrie, "uncommon", "\x07B0C3D9", true);
		SetTrieString(hTrie, "unique", "\x07FFD700", true);
		SetTrieString(hTrie, "unusual", "\x078650AC", true);
		SetTrieString(hTrie, "valve", "\x07A50F79", true);
		SetTrieString(hTrie, "vintage", "\x07476291", true);
		SetTrieString(hTrie, "violet", "\x07EE82EE", true);
		SetTrieString(hTrie, "wheat", "\x07F5DEB3", true);
		SetTrieString(hTrie, "white", "\x07FFFFFF", true);
		SetTrieString(hTrie, "whitesmoke", "\x07F5F5F5", true);
		SetTrieString(hTrie, "yellow", "\x07FFFF00", true);
		SetTrieString(hTrie, "yellowgreen", "\x079ACD32", true);
	}
	else
	{
		SetTrieString(hTrie, "default", "\x01", true);
		SetTrieString(hTrie, "teamcolor", "\x03", true);
		SetTrieString(hTrie, "red", "\x07", true);
		SetTrieString(hTrie, "lightred", "\x0F", true);
		SetTrieString(hTrie, "darkred", "\x02", true);
		SetTrieString(hTrie, "bluegrey", "\n", true);
		SetTrieString(hTrie, "blue", "\x0B", true);
		SetTrieString(hTrie, "darkblue", "\x0C", true);
		SetTrieString(hTrie, "purple", "\x03", true);
		SetTrieString(hTrie, "orchid", "\x0E", true);
		SetTrieString(hTrie, "yellow", "\x09", true);
		SetTrieString(hTrie, "gold", "\x10", true);
		SetTrieString(hTrie, "lightgreen", "\x05", true);
		SetTrieString(hTrie, "green", "\x04", true);
		SetTrieString(hTrie, "lime", "\x06", true);
		SetTrieString(hTrie, "grey", "\x08", true);
		SetTrieString(hTrie, "grey2", "\r", true);
	}
	SetTrieString(hTrie, "engine 1", "\x01", true);
	SetTrieString(hTrie, "engine 2", "\x02", true);
	SetTrieString(hTrie, "engine 3", "\x03", true);
	SetTrieString(hTrie, "engine 4", "\x04", true);
	SetTrieString(hTrie, "engine 5", "\x05", true);
	SetTrieString(hTrie, "engine 6", "\x06", true);
	SetTrieString(hTrie, "engine 7", "\x07", true);
	SetTrieString(hTrie, "engine 8", "\x08", true);
	SetTrieString(hTrie, "engine 9", "\x09", true);
	SetTrieString(hTrie, "engine 10", "\n", true);
	SetTrieString(hTrie, "engine 11", "\x0B", true);
	SetTrieString(hTrie, "engine 12", "\x0C", true);
	SetTrieString(hTrie, "engine 13", "\r", true);
	SetTrieString(hTrie, "engine 14", "\x0E", true);
	SetTrieString(hTrie, "engine 15", "\x0F", true);
	SetTrieString(hTrie, "engine 16", "\x10", true);
	return 0;
}

.34328.IsSource2009()
{
	if (g_var1244 == -1)
	{
		new EngineVersion:iEngineVersion = GetEngineVersion();
		new var1;
		if (iEngineVersion == EngineVersion:13 || iEngineVersion == EngineVersion:17 || iEngineVersion == EngineVersion:15 || iEngineVersion == EngineVersion:16)
		{
			var2 = 1;
		}
		else
		{
			var2 = 0;
		}
		g_var1244 = var2;
	}
	return g_var1244;
}

.34576.AddPrefixAndDefaultColor(String:sMessage[], iSize, String:sDefaultColor[], String:sPrefixColor[])
{
	new var1;
	if (4336/* ERROR unknown load Constant */ && !g_var1130)
	{
		Format(sMessage, iSize, "{%s}[%s]{%s} %s", sPrefixColor, "", sDefaultColor, sMessage);
	}
	else
	{
		Format(sMessage, iSize, "{%s}%s", sDefaultColor, sMessage);
	}
	return 0;
}

.34788.SendPlayerMessage(iClient, String:sMessage[], iAuthor)
{
	new var1;
	if (iAuthor < 1 || iAuthor > MaxClients || !IsClientInGame(iAuthor))
	{
		PrintToChat(iClient, sMessage);
		if (iAuthor)
		{
			LogError("Client %d is not valid or in game", iAuthor);
		}
	}
	else
	{
		.18436.CSayText2(iClient, sMessage, iAuthor);
	}
	return 0;
}

public __pl_HoE_store_SetNTVOptional()
{
	MarkNativeAsOptional("HoE_Store_GetClientCredits");
	MarkNativeAsOptional("HoE_Store_AddClientCredits");
	MarkNativeAsOptional("HoE_Store_RemoveClientCredits");
	MarkNativeAsOptional("HoE_Store_TagEquipped");
	MarkNativeAsOptional("HoE_Store_NameEquipped");
	MarkNativeAsOptional("HoE_Store_ChatEquipped");
	return 0;
}

.35208.PushMenuCell(Handle:hndl, String:id[], data)
{
	new String:DataString[64];
	IntToString(data, DataString, 64);
	AddMenuItem(hndl, id, DataString, 6);
	return 0;
}

.35348.GetMenuCell(Handle:hndl, String:id[], DefaultValue)
{
	new ItemCount = GetMenuItemCount(hndl);
	new String:info[64];
	new String:data[64];
	new i;
	while (i < ItemCount)
	{
		GetMenuItem(hndl, i, info, 64, 0, data, 64);
		if (.3076.StrEqual(info, id, true))
		{
			return StringToInt(data, 10);
		}
		i++;
	}
	return DefaultValue;
}

.35744.AddMenuItemFormat(&Handle:menu, String:info[], style, String:format[])
{
	new String:display[128];
	VFormat(display, 128, format, 5);
	return AddMenuItem(menu, info, display, style);
}

.35896.PushMenuString(Handle:hndl, String:id[], String:data[])
{
	AddMenuItem(hndl, id, data, 6);
	return 0;
}

.35952.GetMenuString(Handle:hndl, String:id[], String:Buffer[], size)
{
	new ItemCount = GetMenuItemCount(hndl);
	new String:info[64];
	new String:data[64];
	new i;
	while (i < ItemCount)
	{
		GetMenuItem(hndl, i, info, 64, 0, data, 64);
		if (.3076.StrEqual(info, id, true))
		{
			strcopy(Buffer, size, data);
			return 1;
		}
		i++;
	}
	return 0;
}

.36360.GetClientSightEnd(client, Float:out[3])
{
	new Float:m_fEyes[3] = 0.0;
	GetClientEyePosition(client, m_fEyes);
	new Float:m_fAngles[3] = 0.0;
	GetClientEyeAngles(client, m_fAngles);
	TR_TraceRayFilter(m_fEyes, m_fAngles, 33636363, RayType:1, TraceRayDontHitPlayers, any:0);
	if (TR_DidHit(Handle:0))
	{
		TR_GetEndPosition(out, Handle:0);
	}
	return 0;
}

public TraceRayDontHitPlayers(entity, mask, any:data)
{
	if (0 < entity <= MaxClients)
	{
		return 0;
	}
	return 1;
}

.36728.CheckAdminFlagsByString(client, String:flagString[])
{
	new AdminId:admin = GetUserAdmin(client);
	if (admin != AdminId:-1)
	{
		new count;
		new found;
		new flags = ReadFlagString(flagString, 0);
		new i;
		while (i <= 20)
		{
			if (1 << i & flags)
			{
				count++;
				if (GetAdminFlag(admin, i, AdmAccessMode:1))
				{
					found++;
				}
			}
			i++;
		}
		if (found == count)
		{
			return 1;
		}
	}
	return 0;
}

.37172.SQL_TFastQuery(Handle:database, String:query[], DBPriority:prio)
{
	new Handle:hPack = CreateDataPack();
	WritePackString(hPack, query);
	SQL_TQuery(database, VoidCallback, query, hPack, prio);
	return 0;
}

public VoidCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	ResetPack(data, false);
	new String:sQuery[4096];
	ReadPackString(data, sQuery, 4096);
	CloseHandle(data);
	if (!hndl)
	{
		LogError("Error on voided SQL query callback: %s\nQuery: %s", error, sQuery);
	}
	return 0;
}

.37520.KvGetBool(Handle:hKV, String:sKey[], bool:bDefaultValue)
{
	return KvGetNum(hKV, sKey, bDefaultValue);
}

.37564.SQL_FetchBool(Handle:query, field, &DBResult:result)
{
	return SQL_FetchInt(query, field, result);
}

.37608.ClearHandle(&Handle:handle)
{
	if (handle)
	{
		CloseHandle(handle);
		handle = 0;
	}
	return 0;
}

public __pl_HoE_tags_admin_SetNTVOptional()
{
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingTag");
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingName");
	MarkNativeAsOptional("HOE_Tags_Admin_IsUsingChat");
	return 0;
}
*/