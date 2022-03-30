/*****************************/
//Pragma
#pragma semicolon 1
#pragma newdecls required

/*****************************/
//Defines
#define PLUGIN_NAME ""
#define PLUGIN_DESCRIPTION ""
#define PLUGIN_VERSION "1.0.0"

/*****************************/
//Includes
#include <sourcemod>

/*****************************/
//ConVars

/*****************************/
//Globals

Database g_Database;

/*****************************/
//Plugin Info
public Plugin myinfo = 
{
	name = PLUGIN_NAME, 
	author = "Drixevel", 
	description = PLUGIN_DESCRIPTION, 
	version = PLUGIN_VERSION, 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	//Start a threaded connection to the SQL database with the configuration key 'default'.
	Database.Connect(OnSQLConnect, "default");
}

public void OnSQLConnect(Database db, const char[] error, any data)
{
	//db being null means the connection was unsuccessful for some reason.
	if (db == null)
		ThrowError("Error while connecting to database: %s", error);
	
	//Make sure there's no duplicate SQL connections present.
	if (g_Database != null)
	{
		delete db;
		return;
	}
	
	//Connection made, cache it and point it out in logs.
	g_Database = db;
	LogMessage("Connected to database successfully.");
	
	//char sQuery[256];
	//g_Database.Format(sQuery, sizeof(sQuery), "");
	//g_Database.Query(OnQuery, sQuery);
}

public void OnQuery(Database db, DBResultSet results, const char[] error, any data)
{
	if (results == null)
		ThrowError("Error while executing query: %s", error);
}