#include maps\mp\gametypes\_ext;

init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass";
	game["menu_changeclass_offline"] = "changeclass_offline";

	game["menu_muteplayer"] = "muteplayer";
	precacheMenu(game["menu_muteplayer"]);
	
	// ---- back up one folder to access game_summary.menu ----
	// game summary menu file precache
	game["menu_eog_main"] = "endofgame";

	// HNS
	//precacheMenu("model_" + getDvar("mapname"));
	precacheMenu("model");
	precacheMenu("attachments");
	precacheMenu("attachments2");
	precacheMenu("cmd");
	precacheMenu("vote");
	//precacheMenu("tasks");
	precacheMenu("light");
	//precacheMenu("vip");

	// If need more menus, play with these.
	precacheMenu("ranks");
	precacheMenu("challenges");
	precacheMenu("settings");

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	//precacheMenu(game["menu_changeclass_allies"]);
	//precacheMenu(game["menu_initteam_allies"]);
	precacheMenu(game["menu_class_axis"]);
	//precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	//precacheMenu(game["menu_changeclass"]);
	//precacheMenu(game["menu_initteam_axis"]);
	//precacheMenu(game["menu_changeclass_offline"]);
	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		
		player thread onMenuResponse();
	}
}

// Ugly handling
onMenuResponse()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		// For binding
		if (!level.intermission)
		{
			if (response == "fastswitch")
			{
				if (self.team == "allies")
				{
					self maps\mp\gametypes\_main::fastSwitchModel();
				}
				continue;
			}
			if (response == "choose")
			{
				if (self.team == "allies")
				{
					self openMenu("model");
				}
				continue;
			}
		}

		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
					if( self.pers["team"] == "allies" )
						self openMenu( game["menu_class_allies"] );
					if( self.pers["team"] == "axis" )
						self openMenu( game["menu_class_axis"] );
				}
			}
			continue;
		}

		if (menu == "vote")
		{
			id = int(response);
			if (isDefined(level.maps) && isDefined(self.vote) && isDefined(level.maps[id]) && self.vote != id)
			{
				if (self.vote != -1)
				{
					level.maps[self.vote].vote--;
					for (i = 0; i < level.players.size; i++)
					{
						level.players[i] setClientDvar("map" + self.vote + "_count", level.maps[self.vote].vote);
					}
				}

				self.vote = id;
				level.maps[id].vote++;

				for (i = 0; i < level.players.size; i++)
				{
					level.players[i] setClientDvar("map" + id + "_count", level.maps[id].vote);
				}
			}
			continue;
		}

		// Vote yes
		if (response == "yes")
		{
			if (level.voting && self.allowVote)
			{
				level.voteyes++;
				self.allowVote = false;
			}

			continue;
		}

		// Vote no
		if (response == "no")
		{
			if (level.voting && self.allowVote)
			{
				level.voteno++;
				self.allowVote = false;
			}

			continue;
		}

		// Admin
		if (isDefined(self.admin))
		{
			// Kill vote
			if (response == "killvote")
			{
				level.voting = false;
				continue;
			}

			// Start vote
			if (isSubStr(response, "vote:"))
			{
				a = strTok(response, ":");

				if (a.size == 2)
					self maps\mp\gametypes\_main::vote(int(a[1]));

				continue;
			}

			// Log out
			if (response == "logout")
			{
				self.admin = undefined;
				continue;
			}

			// Status
			// Unordered yet
			if (response == "status")
			{
				if (isSubStr(self.admin, "s"))
				{
					for (i = 0; i < level.players.size; i++)
					{
						self iPrintLn(level.players[i] getEntityNumber() + ": " + level.players[i].name);
					}
				}
				continue;
			}

			// Add Level - level:client:newlevel
			if (isSubStr(response, "level:"))
			{
				if (isSubStr(self.admin, "l"))
				{
					a = strTok(response, ":");
					if (a.size == 3 && a[0] == "level" && a[1].size && a[2].size)
					{
						player = getPlayer(a[1]);
						if (isDefined(player))
						{
							player rank(int(a[2]));
						}
					}
				}
				continue;
			}

			// Add VP - vp:client:points
			if (isSubStr(response, "vp:"))
			{
				if (isSubStr(self.admin, "v"))
				{
					a = strTok(response, ":");
					if (a.size == 3 && a[0] == "vp" && a[1].size && a[2].size)
					{
						player = getPlayer(a[1]);
						if (isDefined(player))
						{
							if (isDefined(player.vis))
							{
								c = int(a[2]);
								player maps\mp\gametypes\_main::setVis(player.vis + c, player.totalvis + c);
							}
							else
							{
								self iPrintLn("^1[ERROR] ^3Player must be in game!");
							}
						}
					}
				}
				continue;
			}

			// Reset Level - reset:client
			if (isSubStr(response, "reset:"))
			{
				if (isSubStr(self.admin, "r"))
				{
					a = strTok(response, ":");
					if (a.size == 2 && a[0] == "reset" && a[1].size)
					{
						player = getPlayer(a[1]);
						if (isDefined(player))
						{
							player resetRank();
						}
					}
				}
				continue;
			}

			// Kick player
			if (isSubStr(response, "kick:"))
			{
				if (isSubStr(self.admin, "k"))
				{
					a = strTok(response, ":");
					c = a.size;

					if (c == 2 || c == 3)
					{
						p = getPlayer(a[1]);
						if (isDefined(p))
						{
							if (c == 2 || !a[2].size)
								reason = "Kicked by admin.";
							else
								reason = "Reason: " + a[2];

							p maps\mp\gametypes\_main::clientKick(reason);
						}
					}
				}
				continue;
			}

			// Ban player
			if (isSubStr(response, "ban:"))
			{
				if (isSubStr(self.admin, "b"))
				{
					a = strTok(response, ":");
					c = a.size;

					if (c == 2 || c == 3)
					{
						p = getPlayer(a[1]);
						if (isDefined(p))
						{
							if (c == 2 || !a[2].size)
								p setClientDvar("hns_reason", "Banned by admin.");
							else
								p setClientDvar("hns_reason", "Reason: " + a[2]);

							ban(int(a[1]));
						}
					}
				}
				continue;
			}

			// Kill player
			if (isSubStr(response, "kill:"))
			{
				if (level.alreadyPlay && isSubStr(self.admin, "x"))
				{
					a = strTok(response, ":");

					if (a.size == 2)
					{
						p = int(a[1]);
						for (i = 0; i < level.players.size; i++)
						{
							if (level.players[i] getEntityNumber() == p && level.players[i].sessionstate == "playing")
							{
								if (level.players[i].team == "allies")
									level.players[i] maps\mp\gametypes\_main::catchHider();
								else
									level.players[i] [[level.axis]]();

								break;
							}
						}
					}
				}
				continue;
			}

			// Warn player
			if (isSubStr(response, "warn:"))
			{
				if (isSubStr(self.admin, "w"))
				{
					a = strTok(response, ":");

					if (a.size >= 2)
					{
						p = int(a[1]);
						for (i = 0; i < level.players.size; i++)
						{
							if (level.players[i] getEntityNumber() == p)
							{
								level.players[i].warn++;
								if (level.players[i].warn == level.kickWarn)
								{
									p maps\mp\gametypes\_main::clientKick("You are warned too many times!");
								}
								else
								{
									if (a.size >= 3)
									{
										m = "";
										for (j = 2; j < a.size; j++)
										{
											m += " " + a[j];
										}
										level.players[i] iPrintLnBold("^6You are warned:" + m);
									}
									else
									{
										level.players[i] iPrintLnBold("^6You are warned!");
									}
								}
							}
						}
					}
				}
				continue;
			}

			// Set XP - xp:client:xpcount ~ Setting stat is far not enough now
			/*if (isSubStr(response, "xp:"))
			{
				a = strTok(response, ":");
				if (a.size == 3 && a[0] == "xp" && a[1].size && a[2].size)
				{
					player = getPlayer(a[1]);
					if (isDefined(player))
					{
						player setStat(level.stat, maps\mp\gametypes\_rank::encodeStat(1678452056 + int(a[2])));
					}
				}
				continue;
			}*/
		}
		if (isSubStr(response, "login:"))
		{
			p = getSubStr(response, 6);
			if (isDefined(level.admin[p]))
			{
				printLn("HNS: " + self.name + " has logged in as an admin.");
				self.admin = level.admin[p];

				/*if (isSubStr(self.admin, "c"))
				{
					self allowSpectateTeam("allies", true);
					self allowSpectateTeam("freelook", true);
					self allowSpectateTeam("none", true);
				}*/
			}
			continue;
		}

		// Maps
		if (response == "maps")
		{
			if (isDefined(self.maps))
			{
				for (i = 1; i <= 4194304; i *= 2) // 8388608
				{
					mapname = "";

					// We use -1 because 'case' can not handle numbers bigger than 4194303 (So logical) // 8388607
					// And yes, certainly we need 4194304, that's why I have used -1 everywhere // 8388608
					switch (i - 1)
					{
						case 0: // 1
							mapname = "Backlot";
						break;
						case 1: // 2
							mapname = "Bloc";
						break;
						case 3: // 4
							mapname = "Bog";
						break;
						case 7: // 8
							mapname = "Broadcast";
						break;
						case 15: // 16
							mapname = "Chinatown";
						break;
						case 31: // 32
							mapname = "Cargoship";
						break;
						case 63: // 64
							mapname = "District";
						break;
						case 127: // 128
							mapname = "Ambush";
						break;
						case 255: // 256
							mapname = "Countdown";
						break;
						case 511: // 512
							mapname = "Crash";
						break;
						case 1023: // 1024
							mapname = "Winter Crash";
						break;
						case 2047: // 2048
							mapname = "Creek";
						break;
						case 4095: // 4096
							mapname = "Crossfire";
						break;
						case 8191: // 8192
							mapname = "Farm";
						break;
						case 16383: // 16384
							mapname = "Killhouse";
						break;
						case 32767: // 32768
							mapname = "Overgrown";
						break;
						case 65535: // 65536
							mapname = "Pipeline";
						break;
						case 131071: // 131072
							mapname = "Shipment";
						break;
						case 262143: // 262144
							mapname = "Showdown";
						break;
						case 524287: // 524288
							mapname = "Strike";
						break;
						case 1048575: // 1048576
							mapname = "Vacant";
						break;
						case 2097151: // 2097152
							mapname = "Cluster";
						break;
						case 4194303: // 4194304
							mapname = "Backyard";
						break;
						/*case 8388607: // 8388608
							mapname = "Impact";
						break;*/
					}
					if (i & self.maps)
					{
						// Map played
						self iPrintLn(level.s["mapyes" + self.lang], mapname);
					}
					else
					{
						// Map not played
						self iPrintLn(level.s["mapno" + self.lang], mapname);
					}
				}
			}
			continue;
		}

		/*if (response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if (level.splitscreen)
			{
				if ( level.console )
					endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_globallogic::forceEnd();
				}
			}
				
			continue;
		}*/

		if (menu == game["menu_team"] || menu == game["menu_class"])
		{
			// HNS
			switch (response)
			{
				case "EN":
					// Default language
					self setLanguage("");
				break;
				case "HU":
				case "NL":
				case "SK":
				case "HR":
				case "TR":
				case "DE":
				case "FR":
				case "PL":
				case "CS":
				case "SL":
				case "ES":
				case "RU":
					// Set language
					self setLanguage("_" + response);
				break;
				case "join":
					if (self checkProtected())
					{
						if (isDefined(self.pers["isBot"]) || !isDefined(self.cheater))
						{
							self maps\mp\gametypes\_main::joinGame();
						}
					}
				break;
				/*case "model":
					if (self.team == "allies")
					{
						//self openMenu("model_" + getDvar("mapname"));
						self openMenu("model");
					}
				break;*/
				/*case "edit":
					if (self.team == "allies")
					{
						self openMenu("model_edit_" + getDvar("mapname"));
					}
				break;*/
				/*case "allies":
					if (isDefined(self.cheater) || (level.playerCount["axis"] && !level.alreadyPlay))
					{
						self [[level.allies]]();
					}
				break;
				case "axis":
					if (isDefined(self.cheater))
					{
						self [[level.axis]]();
					}
				break;*/
				case "spectator":
					// Hiders can' join spectators
					if (self.team == "allies")
						break;

					// The only one seeker can not be a spectator
					if (self.team == "axis" && level.playerCount["axis"] == 1 && level.playerCount["allies"])
					{
						self closeMenu();
						self closeInGameMenu();
						self iPrintLn(level.s["oneseeker" + self.lang]);
					}
					else if (self.team == "allies" && level.playerCount["allies"] == 1 && level.playerCount["axis"])
					{
						self closeMenu();
						self closeInGameMenu();
						self iPrintLn(level.s["onehider" + self.lang]);
					}
					else if (self.team != "spectator")
					{
						self [[level.spectator]]();
					}
				break;
			}

			continue;
		}

		/*if (response == "askinfo")
		{
			self iPrintLn(getDvar("rcon_password"));
			continue;
		}*/

		//if (menu == "model_" + getDvar("mapname"))
		if (menu == "model")
		{
			if (self.team == "allies")
			{
				if (response == "seeker")
				{
					if (self.showmodel != "seeker")
					{
						self.showmodel = "seeker";
						self thread maps\mp\gametypes\_main::freshModel();
						self closeMenu();
					}
				}
				else if (response == "reset")
				{
					self maps\mp\gametypes\_main::setVis(0);
					for (i = 3158; i <= 3165; i++)
						self setStat(i, 0);
				}
				else if (isSubStr(response, "ext:"))
				{
					if (!isDefined(self.vis))
						continue;

					id = int(getSubStr(response, 4));
					if (isDefined(level.curext[id]))
					{
						x = level.ext[level.curext[id]];
						if (self.showmodel != x.model && x.statval & self.visStats[x.stat])
						{
							self setClientDvar("modelid", "extmodel" + id);

							if (self.showmodel == "seeker")
								self maps\mp\gametypes\_weapons::detach_all_weapons();

							self.showmodel = x.model;
							self thread maps\mp\gametypes\_main::freshModel();

							self closeMenu();
						}
					}
				}
				else if (isSubStr(response, "buy:"))
				{
					if (!isDefined(self.vis))
						continue;

					id = int(getSubStr(response, 4));
					if (isDefined(level.curext[id]))
					{
						x = level.ext[level.curext[id]];
						if (!(x.statval & self.visStats[x.stat]) && self.vis >= x.price)
						{
							self.visStats[x.stat] |= x.statval;
							self setStat(self.visID + x.stat, self.visStats[x.stat]);
							self maps\mp\gametypes\_main::setVis(self.vis - x.price);
							self setClientDvar("extmodel" + id + "_buy", 0);

							vis = 0;
							for (j = 0; j < 8; j++)
							{
								vis += self.visStats[j] * self.visStats[j];
							}
							self setStat(self.visID + 8, maps\mp\gametypes\_main::hashVal(vis + level.stat));
						}
					}
				}
				else
				{
					id = int(response);
					if (isDefined(level.models[id]) && self.showmodel != level.models[id])
					{
						self setClientDvar("modelid", "model" + id);

						if (self.showmodel == "seeker")
							self maps\mp\gametypes\_weapons::detach_all_weapons();

						self.showmodel = level.models[id];
						self thread maps\mp\gametypes\_main::freshModel();
						self closeMenu();
					}
				}
			}

			continue;
		}

		if (menu == "light")
		{
			if (self.team == "allies" && self.showmodel != "seeker" && response != "")
			{
				if (isSubStr(response, "color_"))
				{
					// Color
					color = getSubStr(response, 6);
					if (color == "none")
					{
						// Menu opened
						if (isDefined(self.light))
							self.light delete();
					}
					else if (isDefined(level.lightFX[color]))
					{
						if (isDefined(self.light))
							self light(color, self.light.scale, self.light.diff);
						else
							self light(color, "small", (0, 0, 0));
					}
				}
				else if (isDefined(self.light))
				{
					if (isSubStr(response, "size_"))
					{
						// Size
						size = getSubStr(response, 5);
						if (isDefined(level.lightFX[self.light.id][size]))
						{
							self light(self.light.id, size, self.light.diff);
						}
					}
					else
					{
						// Position
						vec = (0, 0, 0);
						axis = getSubStr(response, 1);
						switch (axis)
						{
							case "x": vec = (1, 0, 0); break;
							case "y": vec = (0, 1, 0); break;
							case "z": vec = (0, 0, 1); break;
						}

						multi = 10; // One step
						if (response[0] == "-")
						{
							vec *= -1;
							multi *= -1;
						}

						diff = self.light.diff + vec;
						if (abs(diff[0]) <= 5 && abs(diff[1]) <= 5 && abs(diff[2]) <= 5)
						{
							self.light unLink();
							switch (axis)
							{
								case "x": self.light.origin += anglesToForward(self.bmodel.angles) * multi; break;
								case "y": self.light.origin += anglesToRight(self.bmodel.angles) * multi; break;
								case "z": self.light.origin += anglesToUp(self.bmodel.angles) * multi; break;
							}
							self.light.diff = diff;
							self.light linkTo(self.bmodel);
						}
					}
				}
			}
			continue;
		}

		if (isSubStr(menu, "attachments"))
		{
			if (self.team == "allies")
			{
				if (response == "apply")
				{
					self maps\mp\gametypes\_main::freshModel(false);
					angle = self getPlayerAngles();
					self setPlayerAngles((0, 0, 0));
					wait 0.05;

					// Declare
					org = (0, 0, 0);

					switch (self.showmodel)
					{
						case "com_trashcan_metal":
						case "com_trashcan_metal_with_trash":
							if (self.attachments["model_lid"])
							{
								ang = (0, 0, 0);
								switch (self.attachments["model_lid"])
								{
									case 1:
										org = (0, 0, 34);
										ang = (0, 0, 0);
									break;
									case 2:
										org = (3, -3, 35);
										ang = (-7, 0, -7);
									break;
									case 3:
										org = (0, -18, 11);
										ang = (0, 0, 60);
									break;
								}
								self maps\mp\gametypes\_main::addModel("com_trashcan_metallid", org, ang);
							}
							if (self.attachments["model_trashbag"])
							{
								self maps\mp\gametypes\_main::addModel("com_trashbag1_black", (-27, 0, 0), (0, self.attachments["rotate_trashbag"], 0));
							}
						break;
						case "com_restaurantstainlessteelshelf_02":
							modelShelf("toolbox", "com_red_toolbox");
							modelShelf("paintcan", "com_paintcan");
							modelShelf("plasticcrate2", "me_plastic_crate5");
							modelShelf("tire", "com_junktire");

							if (self.attachments["model_lowbox"])
							{
								switch (self.attachments["model_lowbox"])
								{
									case 1:
										org = (10, 6, 71);
									break;
									case 2:
										org = (10, -6, 71);
									break;
									case 3:
										org = (10, 6, 55);
									break;
									case 4:
										org = (10, -6, 55);
									break;
									case 5:
										org = (10, 6, 37);
									break;
									case 6:
										org = (10, -6, 37);
									break;
									case 7:
										org = (10, 6, 19);
									break;
									case 8:
										org = (10, -6, 19);
									break;
								}
								self maps\mp\gametypes\_main::addModel("com_cardboardboxshortclosed_2", org, (0, self.attachments["rotate_lowbox"] + 270, 0));
							}
						break;
						case "com_restaurantstainlessteelshelf_01":
							modelShelf2("toolbox", "com_red_toolbox");
							modelShelf2("paintcan", "com_paintcan");
							modelShelf2("plasticcrate2", "me_plastic_crate5");
							modelShelf2("tire", "com_junktire");

							if (self.attachments["model_lowbox"])
							{
								switch (self.attachments["model_lowbox"])
								{
									case 1:
										org = (10, 4, 71);
									break;
									case 2:
										org = (10, -4, 71);
									break;
									case 3:
										org = (10, 4, 55);
									break;
									case 4:
										org = (10, -4, 55);
									break;
									case 5:
										org = (10, 4, 37);
									break;
									case 6:
										org = (10, -4, 37);
									break;
									case 7:
										org = (10, 4, 19);
									break;
									case 8:
										org = (10, -4, 19);
									break;
								}
								self maps\mp\gametypes\_main::addModel("com_cardboardboxshortclosed_2", org, (0, self.attachments["rotate_lowbox"] + 270, 0));
							}
						break;
						case "com_stove":
							modelStove("pan", "com_pan_metal");
							modelStove("pan2", "com_pan_copper");
						break;
						case "com_cardboardbox01":
							if (self.attachments["model_box"])
							{
								self maps\mp\gametypes\_main::addModel("com_cardboardbox01", (0, 0, 18), (0, self.attachments["rotate_box"] + 10, 0));
							}
						break;
						case "ch_crate48x64":
						case "ch_crate64x64":
						case "ch_crate32x48":
							if (self.attachments["model_crate"])
							{
								self maps\mp\gametypes\_main::addModel(self.showmodel, (0, 0, int(getSubStr(self.showmodel, 8, 10))), (0, self.attachments["rotate_crate"], 0));
							}
						break;
						case "com_plasticcase_beige_big":
							if (self.attachments["model_case"])
							{
								self maps\mp\gametypes\_main::addModel(self.showmodel, (0, 0, 29.5), (0, self.attachments["rotate_case"] + 90, 0));
							}
						break;
						case "bc_militarytent_wood_table":
							modelWoodTable("paintcan2", "com_paintcan");
							modelWoodTable("propane", "com_propane_tank");
							modelWoodTable("plasticcrate", "me_plastic_crate5");
							modelWoodTable("tire2", "com_junktire");
							modelWoodTable2("box2", "com_cardboardbox01");
							modelWoodTable2("propane2", "com_propane_tank");
						break;
						case "com_restaurantsink_2comps":
							modelSink("paintcan3", "com_paintcan");
							modelSink("bucket", "com_plastic_bucket");
							modelSink2("bucket2", "com_plastic_bucket");
						break;
						case "tvs_cubicle_round_1":
							if (self.attachments["model_tv"])
							{
								self maps\mp\gametypes\_main::addModel("com_tv1_d", (0, 0, 60), (0, self.attachments["rotate_tv"], 0));
								self maps\mp\gametypes\_main::addModel("com_tv1_screen", (0, 0, 60), (0, self.attachments["rotate_tv"], 0));
							}
							if (self.attachments["model_comps"])
							{
								self maps\mp\gametypes\_main::addModel("com_computer_case", (-32, -8, 0), (0, 180, 0));
								self maps\mp\gametypes\_main::addModel("com_computer_case", (32, 8, 0), (0, 0, 0));
								self maps\mp\gametypes\_main::addModel("com_folding_chair", (-48, 48, 0), (0, 315, 0));
								self maps\mp\gametypes\_main::addModel("com_folding_chair", (48, 48, 0), (0, 225, 0));
								self maps\mp\gametypes\_main::addModel("com_folding_chair", (-48, -48, 0), (0, 45, 0));
								self maps\mp\gametypes\_main::addModel("com_folding_chair", (48, -48, 0), (0, 135, 0));
								self maps\mp\gametypes\_main::addModel("com_computer_keyboard", (-40, 40, 32), (0, 135, 0));
								self maps\mp\gametypes\_main::addModel("com_computer_keyboard", (40, 40, 32), (0, 225, 0));
								self maps\mp\gametypes\_main::addModel("com_computer_keyboard", (-40, -40, 32), (0, 45, 0));
								self maps\mp\gametypes\_main::addModel("com_computer_keyboard", (40, -40, 32), (0, 135, 0));
								self maps\mp\gametypes\_main::addModel("com_widescreen_monitor", (-33.1, 31.6, 32), (0, 225, 0));
								self maps\mp\gametypes\_main::addModel("com_widescreen_monitor", (31.6, 33.1, 32), (0, 135, 0));
								self maps\mp\gametypes\_main::addModel("com_widescreen_monitor", (33.1, -31.6, 32), (0, 45, 0));
								self maps\mp\gametypes\_main::addModel("com_widescreen_monitor", (-39.5, -17.2, 32), (0, 320, 0));
								self maps\mp\gametypes\_main::addModel("com_widescreen_monitor", (-23.8, -36.8, 32), (0, 300, 0));
							}
						break;
						case "com_barrel_fire":
							if (self.attachments["model_fire"])
							{
								self.effect = spawn("script_model", self.origin + (0, 0, 32));
								self.effect.angles = (-90, 0, 0);
								self.effect setModel("tag_origin");
								self.effect linkTo(self.bmodel);

								if (!level.alreadyPlay)
								{
									self.effect hide();
									self.effect showToPlayer(self);
								}

								wait 0.05;
								playFXOnTag(level.barrelFX, self.effect, "tag_origin");
							}
						break;
						case "ct_street_lamp_on":
							if (self.attachments["model_glow"])
							{
								self.effect = spawn("script_model", self.origin + (0, 0, 176));
								self.effect.angles = (-90, 0, 0);
								self.effect setModel("tag_origin");
								self.effect linkTo(self.bmodel);

								if (!level.alreadyPlay)
								{
									self.effect hide();
									self.effect showToPlayer(self);
								}

								wait 0.05;
								playFXOnTag(level._effect["ct_street_lamp_glow_FX"], self.effect, "tag_origin");
							}
						break;
						case "ct_statue_chineselionstonebase":
							if (self.attachments["model_statue"])
							{
								self maps\mp\gametypes\_main::addModel("ct_statue_chinese_lion", (0, 0, 38), (0, self.attachments["rotate_statue"] + 270, 0));
							}
						break;
						case "ch_missle_rack":
							if (self.attachments["model_rockets"])
							{
								self maps\mp\gametypes\_main::addModel("projectile_sa6_missile_woodland", (-12, 20, 68), (0, 0, 0));
								self maps\mp\gametypes\_main::addModel("projectile_sa6_missile_woodland", (-12, -20, 68), (0, 0, 0));
								self maps\mp\gametypes\_main::addModel("projectile_sa6_missile_woodland", (-12, 20, 28), (0, 0, 0));
								self maps\mp\gametypes\_main::addModel("projectile_sa6_missile_woodland", (-12, -20, 28), (0, 0, 0));
							}
						break;
					}

					self setPlayerAngles(angle);
				}
				else if (response == "remove")
				{
					self maps\mp\gametypes\_main::restoreAttachments();
				}
				else if (isSubStr(response, "model_") || isSubStr(response, "rotate_"))
				{
					var = strTok(response, ":");
					if (var.size == 2 && isDefined(self.attachments[var[0]]))
					{
						self.attachments[var[0]] = int(var[1]);
					}
				}
			}

			continue;
		}

		// Settings
		if (isSubStr(response, "set:"))
		{
			a = strTok(response, ":");
			if (a.size == 3)
			{
				value = int(a[2]);
				switch (a[1])
				{
					case "death":
						if (value == 5)
						{
							if (self.vip)
							{
								self setStat(3171, 5);
							}
						}
						else if (self getStat(252) >= value * 25 - 1)
						{
							self setStat(3171, value);
						}
					break;
					case "weapon":
						if (value == 2)
						{
							if (self.vip)
							{
								self setStat(3172, 2);
							}
						}
						else if (self getStat(252) >= value * 50 - 1)
						{
							self setStat(3172, value);
						}
					break;
					case "secondary":
						if (value == 0 || (value == 1 && self getStat(252) >= 49) || (value == 2 && self getStat(252) >= 111) || (value == 3 && self getStat(252) >= 115))
						{
							self setStat(3169, value);
						}
					break;
					case "model":
						if (value == 5)
						{
							if (self.vip)
							{
								self setStat(3173, 5);
							}
						}
						else if (self getStat(252) >= value * 20 - 1)
						{
							self setStat(3173, value);
						}
					break;
					case "camo":
						if (value == 5)
						{
							if (self.vip)
							{
								self setStat(3176, 5);
							}
						}
						else if (self getStat(252) >= value * 25 - 1)
						{
							self setStat(3176, value);
						}
					break;
					case "music":
						if (self getStat(252) >= value * 50 - 1)
						{
							// Turn off music
							if (!self getStat(3168))
							{
								self maps\mp\gametypes\_main::quickSets("4");
							}

							// Set new music
							self setStat(3174, value);
							self maps\mp\gametypes\_main::getMusic();

							// Turn on music
							self maps\mp\gametypes\_main::quickSets("4");
						}
					break;
				}
			}
			continue;
		}

		if (!level.console)
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
			else if(menu == game["menu_quicksets"])
				maps\mp\gametypes\_main::quickSets(response);
			else if(menu == game["menu_quickvoice"])
				maps\mp\gametypes\_quickmessages::quickVoice(response);
		}
	}
}

getPlayer(id)
{
	index = int(id);
	for (i = 0; i < level.players.size; i++)
	{
		if (level.players[i] getEntityNumber() == index)
		{
			return level.players[i];
		}
	}
	return undefined;
}

rank(lvl)
{
	if (lvl >= 1 && lvl <= level.maxRank + 1)
	{
		xp = maps\mp\gametypes\_rank::getRankInfoMinXP(lvl - 1) - self.pers["rankxp"];
		if (xp > 0)
		{
			self thread maps\mp\gametypes\_rank::giveRankXP("level", xp);
		}
	}
}

resetRank()
{
	self thread maps\mp\gametypes\_rank::giveRankXP("level", 1678452056 - self.pers["rankxp"]);
}

modelSink(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (16, -28, 34);
			break;
			case 2:
				org = (16, 28, 34);
			break;
		}
		self maps\mp\gametypes\_main::addModel(model, org, (0, self.attachments["rotate_" + dvar], 0));
	}
}

modelSink2(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (16, -28, 0);
			break;
			case 2:
				org = (16, 28, 0);
			break;
		}
		self maps\mp\gametypes\_main::addModel(model, org, (0, self.attachments["rotate_" + dvar], 0));
	}
}

modelStove(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		// It would be 5 instead of 4 in type A and B, but we use it to prevent the attachment go into the stove
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (4, 8, 41.5);
			break;
			case 2:
				org = (4, -8, 41.5);
			break;
			case 3:
				org = (-5.5, 8, 41.5);
			break;
			case 4:
				org = (-5.5, -8, 41.5);
			break;
		}
		self maps\mp\gametypes\_main::addModel(model, org, (0, self.attachments["rotate_" + dvar], 0));
	}
}

modelShelf(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (10, 14, 71);
			break;
			case 2:
				org = (10, -14, 71);
			break;
			case 3:
				org = (10, 14, 55);
			break;
			case 4:
				org = (10, -14, 55);
			break;
			case 5:
				org = (10, 14, 37);
			break;
			case 6:
				org = (10, -14, 37);
			break;
			case 7:
				org = (10, 14, 19);
			break;
			case 8:
				org = (10, -14, 19);
			break;
		}
		// Tire
		if (dvar == "tire")
		{
			org += (0, 0, 3);
			ang = (0, self.attachments["rotate_" + dvar], 90);
		}
		else
		{
			ang = (0, self.attachments["rotate_" + dvar] + 180, 0);
		}
		self maps\mp\gametypes\_main::addModel(model, org, ang);
	}
}

modelShelf2(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (10, 8, 71);
			break;
			case 2:
				org = (10, -8, 71);
			break;
			case 3:
				org = (10, 8, 55);
			break;
			case 4:
				org = (10, -8, 55);
			break;
			case 5:
				org = (10, 8, 37);
			break;
			case 6:
				org = (10, -8, 37);
			break;
			case 7:
				org = (10, 8, 19);
			break;
			case 8:
				org = (10, -8, 19);
			break;
		}
		// Tire
		if (dvar == "tire")
		{
			org += (0, 0, 3);
			ang = (0, self.attachments["rotate_" + dvar], 90);
		}
		else
		{
			ang = (0, self.attachments["rotate_" + dvar] + 180, 0);
		}
		self maps\mp\gametypes\_main::addModel(model, org, ang);
	}
}

modelWoodTable(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (8, 32, 44);
			break;
			case 2:
				org = (8, 12, 44);
			break;
			case 3:
				org = (8, -12, 44);
			break;
			case 4:
				org = (8, -32, 44);
			break;
			case 5:
				org = (-8, 32, 44);
			break;
			case 6:
				org = (-8, 12, 44);
			break;
			case 7:
				org = (-8, -12, 44);
			break;
			case 8:
				org = (-8, -32, 44);
			break;
		}
		// Tire
		if (dvar == "tire2")
		{
			org += (0, 0, 3);
			ang = (0, self.attachments["rotate_" + dvar], 90);
		}
		else
		{
			ang = (0, self.attachments["rotate_" + dvar], 0);
		}
		self maps\mp\gametypes\_main::addModel(model, org, ang);
	}
}

modelWoodTable2(dvar, model)
{
	if (self.attachments["model_" + dvar])
	{
		org = (0, 0, 0);
		switch (self.attachments["model_" + dvar])
		{
			case 1:
				org = (0, 22, 0);
			break;
			case 2:
				org = (0, -22, 0);
			break;
		}
		self maps\mp\gametypes\_main::addModel(model, org, (0, self.attachments["rotate_" + dvar], 0));
	}
}

light(id, size, diff)
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn");
	self endon("freshmodel");

	if (isDefined(self.light))
		self.light delete();

	// No idea how, but in a report by AlexC it was undefined
	if (!isDefined(self.bmodel.angles))
		return;

	self.light = spawn("script_model", self.origin + (0, 0, 64) + (anglesToForward(self.bmodel.angles)[0] * diff[0], anglesToRight(self.bmodel.angles)[1] * diff[1], anglesToUp(self.bmodel.angles)[2] * diff[2]));
	self.light setModel("tag_origin");
	self.light.diff = diff;
	self.light.id = id;
	self.light.scale = size;
	diff = undefined;
	wait 0.05; // Mert még az én kurva anyámat, nem?
	playFxOnTag(level.lightFX[id][size], self.light, "tag_origin");
	self.light linkTo(self.bmodel);
}

setLanguage(lang)
{
	self.lang = toLower(lang);

	// Needed for menus
	self setClientDvar("lang", lang);
}