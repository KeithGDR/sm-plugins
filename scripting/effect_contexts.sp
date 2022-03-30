/*
// Just a list of all the usable response rules for SourceMod plugins in TF2.
//
// Plugins that use Response Rules
// (what for if you don't know how to use these)
// - [TF2] Class is dead by ClassicGuzzi https://forums.alliedmods.net/showthread.php?t=236062
// - [TF2] Weapon Pickup Responses (2016-09-09) by nosoop https://forums.alliedmods.net/showthread.php?p=2437064
// - There's probably others, I just don't know of them.
//
// Why response rules over emitsoundtoall? I *think* (not 100% sure) sending voice clips with EmitSound/EmitSoundToAll doesn't make the player models use the appropriate facial flexes, whereas using response rules does cause facial flexes to be used appropriately.
//
// With a basic setup in place to play these response rules, you may find that most of them seemingly don't work.
// You'll need to look into additional variables you have to set in order to play some of the rules properly.
// The "Class is dead" plugin is a good starting point for learning how to set up response rules
// (even though I barely know how to do it, it's something I'm trying to learn)

HalloweenLongFall
TLK_MAGIC_BIGHEAD
TLK_MAGIC_SMALLHEAD
TLK_MAGIC_GRAVITY
TLK_MAGIC_GOOD
TLK_MAGIC_DANCE
TLK_PLAYER_TAUNT
TLK_PLAYER_THANKS
TLK_PLAYER_MEDIC
TLK_PLAYER_ASK_FOR_BALL
TLK_PLAYER_HELP
TLK_PLAYER_GO
TLK_PLAYER_MOVEUP
TLK_PLAYER_LEFT
TLK_PLAYER_RIGHT
TLK_PLAYER_YES
TLK_PLAYER_NO
TLK_PLAYER_INCOMING
TLK_PLAYER_CLOAKEDSPY
TLK_PLAYER_SENTRYAHEAD
TLK_PLAYER_TELEPORTERHERE
TLK_PLAYER_DISPENSERHERE
TLK_PLAYER_SENTRYHERE
TLK_PLAYER_ACTIVATECHARGE
TLK_PLAYER_CHARGEREADY
TLK_PLAYER_TAUNTS
TLK_PLAYER_BATTLECRY
TLK_PLAYER_CHEERS
TLK_PLAYER_JEERS
TLK_PLAYER_POSITIVE
TLK_PLAYER_NEGATIVE
TLK_PLAYER_NICESHOT
TLK_PLAYER_GOODJOB
TLK_SPY_SAPPER
TLK_PLAYER_PAIN
TLK_PLAYER_ATTACKER_PAIN
TLK_ONFIRE
TLK_CAPTURE_BLOCKED
TLK_MEDIC_CHARGEDEPLOYED
TLK_HEALTARGET_STOPPEDHEALING
TLK_PICKUP_BUILDING
TLK_REDEPLOY_BUILDING
TLK_CARRYING_BUILDING
TLK_GRAB_BALL
TLK_PLAYER_TAUNT2
TLK_PLAYER_SHOW_ITEM_TAUNT
TLK_PLAYER_HOLDTAUNT
TLK_CAPTURED_POINT
TLK_ROUND_START
TLK_ROUND_START_COMP
TLK_SUDDENDEATH_START
TLK_STALEMATE
TLK_BUILDING_OBJECT
TLK_DETONATED_OBJECT
TLK_LOST_OBJECT
TLK_KILLED_OBJECT
TLK_MEDIC_CHARGEREADY
TLK_TELEPORTED
TLK_DEAD
TLK_FLAGPICKUP         
TLK_FLAGCAPTURED         
TLK_CART_MOVING_FORWARD         
TLK_CART_STOP         
TLK_CART_MOVING_BACKWARD         
TLK_ATE_FOOD         
TLK_DOUBLE_JUMP
TLK_DODGING
TLK_DODGE_SHOT
TLK_GRAB_BALL
TLK_REGEN_BALL
TLK_DEFLECTED
TLK_BALL_MISSED
TLK_STUNNED
TLK_STUNNED_TARGET
TLK_TIRED
TLK_BAT_BALL
TLK_ACHIEVEMENT_AWARD
TLK_JARATE_LAUNCH
TLK_JARATE_HIT
TLK_TAUNT_REPLAY
TLK_TAUNT_LAUGH
TLK_TAUNT_HEROIC_POSE
TLK_TAUNT_PYRO_ARMAGEDDON
TLK_TAUNT_GUITAR_RIFF
TLK_TAUNT_EUREKA_EFFECT
TLK_PLAYER_EXPRESSION
TLK_LOST_CONTROL_POINT'
TLK_KILLED_PLAYER
TLK_FIREWEAPON
TLK_FIREMINIGUN
TLK_WINDMINIGUN
TLK_MINIGUN_FIREWEAPON
TLK_REQUEST_DUEL
TLK_DUEL_WAS_REJECTED
TLK_ACCEPT_DUEL
TLK_DUEL_WAS_ACCEPTED
TLK_ROCKET_DESTOYED
TLK_COMBO_KILLED 
TLK_MVM_BOMB_DROPPED 
TLK_MVM_BOMB_CARRIER_UPGRADE1 
TLK_MVM_BOMB_CARRIER_UPGRADE2 
TLK_MVM_BOMB_CARRIER_UPGRADE3 
TLK_MVM_DEFENDER_DIED 
TLK_MVM_FIRST_BOMB_PICKUP 
TLK_MVM_BOMB_PICKUP
TLK_MVM_SENTRY_BUSTER
TLK_MVM_SENTRY_BUSTER_DOWN
TLK_MVM_SNIPER_CALLOUT
TLK_MVM_LAST_MAN_STANDING
TLK_MVM_ENCOURAGE_MONEY
TLK_MVM_MONEY_PICKUP
TLK_MVM_ENCOURAGE_UPGRADE
TLK_MVM_UPGRADE_COMPLETE
TLK_MVM_GIANT_CALLOUT
TLK_MVM_GIANT_HAS_BOMB
TLK_MVM_GIANT_KILLED
TLK_MVM_GIANT_KILLED_TEAMMATE
TLK_MVM_SAPPED_ROBOT
TLK_MVM_CLOSE_CALL
TLK_MVM_TANK_CALLOUT
TLK_MVM_TANK_DEAD
TLK_MVM_TANK_DEPLOYING
TLK_MVM_ATTACK_THE_TANK
TLK_MVM_TAUNT
TLK_MVM_WAVE_START
TLK_MVM_WAVE_WIN
TLK_MVM_WAVE_LOSE
TLK_MVM_DEPLOY_RAGE
TLK_MANNHATTAN_GATE_ATK
TLK_MANNHATTAN_GATE_TAKE
TLK_RESURRECTED
TLK_MEDIC_HEAL_SHIELD
TLK_MVM_LOOT_COMMON
TLK_MVM_LOOT_RARE
TLK_MVM_LOOT_ULTRARARE
TLK_PLAYER_CAST_FIREBALL
TLK_PLAYER_CAST_MERASMUS_ZAP 
TLK_PLAYER_CAST_SELF_HEAL 
TLK_PLAYER_CAST_MIRV 
TLK_PLAYER_CAST_BLAST_JUMP 
TLK_PLAYER_CAST_STEALTH 
TLK_PLAYER_CAST_TELEPORT 
TLK_PLAYER_CAST_BOMB_HEAD_CURSE 
TLK_PLAYER_CAST_LIGHTNING_BALL 
TLK_PLAYER_CAST_MOVEMENT_BUFF 
TLK_PLAYER_CAST_MONOCULOUS 
TLK_PLAYER_CAST_METEOR_SWARM 
TLK_PLAYER_CAST_SKELETON_HORDE 
TLK_PLAYER_SPELL_FIREBALL
TLK_PLAYER_SPELL_MERASMUS_ZAP 
TLK_PLAYER_SPELL_SELF_HEAL 
TLK_PLAYER_SPELL_MIRV 
TLK_PLAYER_SPELL_BLAST_JUMP 
TLK_PLAYER_SPELL_STEALTH 
TLK_PLAYER_SPELL_TELEPORT 
TLK_PLAYER_SPELL_LIGHTNING_BALL 
TLK_PLAYER_SPELL_MOVEMENT_BUFF 
TLK_PLAYER_SPELL_MONOCULOUS 
TLK_PLAYER_SPELL_METEOR_SWARM 
TLK_PLAYER_SPELL_SKELETON_HORDE 
TLK_PLAYER_SPELL_PICKUP_COMMON 
TLK_PLAYER_SPELL_PICKUP_RARE
TLK_PLAYER_HELLTOWER_MIDNIGHT 
TLK_PLAYER_SKELETON_KING_APPEAR
TLK_GAME_OVER_COMP
TLK_MATCH_OVER_COMP
*/

//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals

public Plugin myinfo = 
{
	name = "Contexts", 
	author = "Drixevel", 
	description = "Forces players to use speaker concepts.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_context", Command_Context, ADMFLAG_ROOT, "Causes player(s) to use a speaker response concept.");
	RegAdminCmd("sm_yes", Command_Yes, ADMFLAG_ROOT, "YES!");
	RegAdminCmd("sm_no", Command_No, ADMFLAG_ROOT, "NO!");
	RegAdminCmd("sm_scream", Command_Scream, ADMFLAG_ROOT, "SCREAM!");
}

public Action Command_Context(int client, int args)
{
	char sCommand[256];
	GetCommandName(sCommand, sizeof(sCommand));
	
	if (args == 0)
	{
		ReplyToCommand(client, "[Usage] %s <target> <concept> <context> <class>", sCommand);
		return Plugin_Handled;
	}
	
	char sTarget[MAX_TARGET_LENGTH];
	GetCmdArg(1, sTarget, sizeof(sTarget));
	
	char sConcept[256];
	GetCmdArg(2, sConcept, sizeof(sConcept));
	
	char sContext[256];
	GetCmdArg(3, sContext, sizeof(sContext));
	
	char sClass[256];
	GetCmdArg(4, sClass, sizeof(sClass));
	
	int iTargets[MAXPLAYERS];
	char sTargetName[MAX_TARGET_LENGTH];
	bool tn_is_ml;

	int found;
	if ((found = ProcessTargetString(sTarget, client, iTargets, sizeof(iTargets), COMMAND_FILTER_NO_IMMUNITY, sTargetName, sizeof(sTargetName), tn_is_ml)) <= COMMAND_TARGET_NONE)
	{
		ReplyToTargetError(client, found);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < found; i++)
		SpeakResponseConcept(iTargets[i], sConcept, sContext, sClass);
	
	ReplyToCommand(client, "Speaker Concept Sent to %s: %s", sTarget, sConcept);
	
	return Plugin_Handled;
}

public Action Command_Yes(int client, int args)
{
	SpeakResponseConceptAll("TLK_PLAYER_YES");
	ReplyToCommand(client, "Speaker Concept Sent: TLK_PLAYER_YES");
	return Plugin_Handled;
}

public Action Command_No(int client, int args)
{
	SpeakResponseConceptAll("TLK_PLAYER_NO");
	ReplyToCommand(client, "Speaker Concept Sent: TLK_PLAYER_NO");
	return Plugin_Handled;
}

public Action Command_Scream(int client, int args)
{
	SpeakResponseConceptAll("HalloweenLongFall");
	ReplyToCommand(client, "Speaker Concept Sent: HalloweenLongFall");
	return Plugin_Handled;
}