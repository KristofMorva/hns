// With this you can modify the mod, how you want.
// Please use this instead of rewriting the GSCs of the mod, since if a new version is released, you can easily paste this file instead of rewriting the mod again.
// If you need any notifies to complete your plugin properly, please contact me, and I'll add it.
// This function is called after mod preCache functions, so you are able to preCache, or listen to any events.

main()
{
	level.stat = 2301; // Stat ID

	// Debugging
	//level.debugFX = loadFX("debug");

	// Watch
	//thread onPlayerConnect();
	//thread onPlayerRank();
	//thread onPlayerXP();
}

/*onPlayerConnect()
{
	level waittill("connected", p);
	p setStat(level.stat, p getStat(2301));
	//self thread onPlayerResponse();
}*/

/*onPlayerRank()
{
	level waittill("rankcheck", p);
	if (!isDefined(p.invalid) && p getStat(3175) != p.pers["rankxp"] - 1614807542)
	{
		p maps\mp\gametypes\_rank::hacker();
	}
}

onPlayerXP()
{
	level waittill("rankxp", p);
	p setStat(3175, p.pers["rankxp"] - 1614807542);
}*/

// Waittill is not working here. Why the fuck?
/*onPlayerResponse()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("menuresponse", menu, response);

		if (self.admin)
		{
			// "Wallhack" ONLY for checking if a player is glitching or not...
			// Don't use it while playing, that's unfair!
			if (isSubStr(response, "debug"))
			{
				if (self.debug)
				{
					self.debug = false;
				}
				else
				{
					self.debug = true;

					// Only enemy
					if (response == "debugenemy")
					{
						enemy = 1;
					}
					else if (response == "debugteam")
					{
						enemy = -1;
					}
					else
					{
						enemy = 0;
					}

					self thread maps\mp\gametypes\_main::debug(enemy);
				}
			}
		}
	}
}*/