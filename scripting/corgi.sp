#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public Plugin myinfo = 
{
	name = "[ANY] Corgi",
	author = "Keith The Corgi",
	description = "Keith The Corgi's plugin that does specific things for the sole purpose of doing things.",
	version = "1.0.0",
	url = "https://github.com/keiththecorgi"
};

public void OnPluginStart()
{
	PrintToServer(" ::::: CORGI PLUGIN LOADED :::::");
}