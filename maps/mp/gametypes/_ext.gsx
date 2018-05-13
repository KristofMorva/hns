echoNextMap(map)
{
	exec("say ^3Next map: ^2" + map);
}

getVoteMaps() {
	level.playCount = 0;

	if (FS_TestFile("maps.hns"))
	{
		for (i = 0; i < level.mapCount; i++)
		{
			level.maps[i].plays = 0;
		}

		level.plays = [];

		// Load maps
		f = FS_FOpen("maps.hns", "read");
		while (true)
		{
			s = FS_ReadLine(f);
			if (!isDefined(s))
				break;

			s = strTok(s, " ");
			if (s.size == 2)
			{
				s[1] = int(s[1]);
				level.plays[level.playCount] = s;
				level.playCount++;

				for (i = 0; i < level.mapCount; i++)
				{
					if (level.maps[i].map == s[0])
					{
						level.maps[i].plays = s[1];
						break;
					}
				}
			}
		}
		FS_FClose(f);

		// Sort
		for (i = 0; i < level.mapCount - 1; i++)
		{
			k = i;
			for (j = i + 1; j < level.mapCount; j++)
			{
				if (level.maps[j].plays < level.maps[k].plays)
				{
					k = j;
				}
			}
			if (k != i)
			{
				temp = level.maps[i];
				level.maps[i] = level.maps[k];
				level.maps[k] = temp;
			}
		}
		/*for (i = 0; i < level.mapCount; i++)
		{
			iprintln("^1" + level.maps[i].map + ": " + level.maps[i].plays);
		}*/

		// Choose
		if (level.mapCount > 5)
		{
			// c = 1 2 2 6 6 6 6 6(<-this) 8 9
			for (c = 5; c < level.mapCount && level.maps[c - 1].plays == level.maps[c].plays; c++) { }
			if (c > 5)
			{
				// s = 1 2 2 (this->)6 6 6 6 6 8 9
				for (s = 5; s && level.maps[s - 1].plays == level.maps[s].plays; s--) { }
				while (c > 5)
				{
					id = randomInt(c - s + 1) + s;
					c--;

					if (id != c)
						level.maps[id] = level.maps[c];

					level.maps[c] = undefined;
				}
			}
			for (i = c; i < level.mapCount; i++)
			{
				level.maps[i] = undefined;
			}
			level.mapCount = 5;
		}
	}
	else
	{
		maps\mp\gametypes\_main::getVoteMapsRandom();
	}
}

handleVoteResult()
{
	fair = getDvarInt("scr_hns_fairvote") > 0; // Fair vote

	found = false;
	f = FS_FOpen("maps.hns", "write");
	for (i = 0; i < level.playCount; i++)
	{
		if (level.plays[i][0] == level.nextMap)
		{
			found = true;

			if (fair)
				level.plays[i][1]++;
			else
				level.plays[i][1] = getRealTime();
		}
		FS_WriteLine(f, level.plays[i][0] + " " + level.plays[i][1]);
	}
	if (!found)
	{
		if (fair)
			FS_WriteLine(f, level.nextMap + " " + 1);
		else
			FS_WriteLine(f, level.nextMap + " " + getRealTime());
	}
	FS_FClose(f);
}

isFriendlyBlock()
{
	return getDvarInt("g_friendlyPlayerCanBlock") != 0;
}

checkProtected()
{
	cheaterAsshole = self getUserInfo("a") == "" || self getUserInfo("b") == "" || self getUserInfo("c") == "";
	if (cheaterAsshole)
	{
		iPrintLn("^1" + self.name + " is kicked for using protected variables!");
		exec("kick " + self getEntityNumber() + " Stop using protected variables you asshole!");
	}

	return !cheaterAsshole;
}