#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	// Force HNS
	setDvar("g_gametype", "hns");
	exitLevel(false);
}