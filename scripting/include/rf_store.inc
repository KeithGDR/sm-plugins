#if defined _rf_store_included
	#endinput
#endif
#define _rf_store_included

native bool RFStore_HasBoss(int client, const char[] boss);
native bool RFStore_HasSkin(int client, const char[] skin);

public SharedPlugin __pl_rf_store =
{
	name = "rf-store",
	file = "rf-store.smx",
	#if defined REQUIRE_PLUGIN
		required = 1,
	#else
		required = 0,
	#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_rf_store_SetNTVOptional()
{
	MarkNativeAsOptional("RFStore_HasBoss");
	MarkNativeAsOptional("RFStore_HasSkin");
}
#endif
