// HNS: The big part of it is totally useless!
// But I have no patience to rewrite everything.

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	// hack to allow maps with no scripts to run correctly
	if ( !isDefined( level.tweakablesInitialized ) )
		maps\mp\gametypes\_tweakables::init();

	if ( getDvar( "scr_player_sprinttime" ) == "" )
		setDvar( "scr_player_sprinttime", getDvar( "player_sprintTime" ) );

	level.splitscreen = isSplitScreen();
	level.xenon = (getdvar("xenonGame") == "true");
	level.ps3 = (getdvar("ps3Game") == "true");
	level.onlineGame = true;
	level.console = (level.xenon || level.ps3); 

	level.rankedMatch = ( level.onlineGame && getDvarInt( "sv_pure" ) );
	/#
	if ( getdvarint( "scr_forcerankedmatch" ) == 1 )
		level.rankedMatch = true;
	#/

	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );

	level.otherTeam["allies"] = "axis";
	level.otherTeam["axis"] = "allies";

	level.teamBased = true;

	level.overrideTeamScore = false;
	level.overridePlayerScore = false;

	level.endGameOnScoreLimit = true;
	level.endGameOnTimeLimit = true;

	if ( level.splitScreen )
		precacheString( &"MP_ENDED_GAME" );
	else
		precacheString( &"MP_HOST_ENDED_GAME" );

	level.lastStatusTime = 0;
	level.wasWinning = "none";

	level.lastSlowProcessFrame = 0;

	level.placement["allies"] = [];
	level.placement["axis"] = [];
	level.placement["all"] = [];

	level.postRoundTime = 8.0;

	level.inOvertime = false;

	level.dropTeam = getdvarint( "sv_maxclients" );

	registerDvars();
	//maps\mp\gametypes\_class::initPerkDvars();

	precacheModel( "tag_origin" );	

	deletePickups();

	// HNS
	deletePlacedEntity("misc_turret");
	deletePlacedEntity("trigger_hurt");

	self thread maps\mp\gametypes\_main::startMap();
}

registerDvars()
{
	if ( getDvar( "scr_intermission_time" ) == "" )
		setDvar( "scr_intermission_time", 20.0 );
}

SetupCallbacks()
{
	level.spawnPlayer = ::spawnPlayer;
	level.spawnClient = ::spawnClient;
	level.spawnSpectator = ::spawnSpectator;
	level.spawnIntermission = ::spawnIntermission;
	level.onPlayerScore = ::default_onPlayerScore;
	level.onTeamScore = ::default_onTeamScore;

	level.onXPEvent = ::onXPEvent;
	//level.waveSpawnTimer = ::waveSpawnTimer;

	level.onSpawnPlayer = ::blank;
	level.onSpawnSpectator = ::default_onSpawnSpectator;
	level.onSpawnIntermission = ::default_onSpawnIntermission;
	level.onRespawnDelay = ::blank;

	level.onTimeLimit = ::default_onTimeLimit;
	level.onScoreLimit = ::default_onScoreLimit;
	level.giveTeamScore = ::giveTeamScore;
	level.givePlayerScore = ::givePlayerScore;

	level._setTeamScore = ::_setTeamScore;
	level._setPlayerScore = ::_setPlayerScore;

	level._getTeamScore = ::_getTeamScore;
	level._getPlayerScore = ::_getPlayerScore;

	level.onPrecacheGametype = ::blank;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;

	level.onEndGame = ::blank;

	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
}


// to be used with things that are slow.
// unfortunately, it can only be used with things that aren't time critical.
WaitTillSlowProcessAllowed()
{
	// wait only a few frames if necessary
	// if we wait too long, we might get too many threads at once and run out of variables
	// i'm trying to avoid using a loop because i don't want any extra variables
	if ( level.lastSlowProcessFrame == gettime() )
	{
		wait .05;
		if ( level.lastSlowProcessFrame == gettime() )
		{
		wait .05;
			if ( level.lastSlowProcessFrame == gettime() )
			{
				wait .05;
				if ( level.lastSlowProcessFrame == gettime() )
				{
					wait .05;
				}
			}
		}
	}

	level.lastSlowProcessFrame = gettime();
}

blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

default_onTimeLimit()
{
	winner = undefined;

	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";

	logString( "time limit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

	makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );

	thread endGame( winner, game["strings"]["time_limit_reached"] );
}


forceEnd()
{
	if ( level.hostForcedEnd || level.forcedEnd )
		return;

	winner = undefined;

	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	logString( "host ended game, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

	level.forcedEnd = true;
	level.hostForcedEnd = true;

	if ( level.splitscreen )
		endString = &"MP_ENDED_GAME";
	else
		endString = &"MP_HOST_ENDED_GAME";

	makeDvarServerInfo( "ui_text_endreason", endString );
	setDvar( "ui_text_endreason", endString );
	thread endGame( winner, endString );
}


default_onScoreLimit()
{
	if ( !level.endGameOnScoreLimit )
		return;

	winner = undefined;

	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );

	level.forcedEnd = true; // no more rounds if scorelimit is hit
	thread endGame( winner, game["strings"]["score_limit_reached"] );
}


matchStartTimerSkip()
{
	visionSetNaked( getDvar( "mapname" ), 0 );
}


spawnPlayer()
{
	prof_begin( "spawnPlayer_preUTS" );

	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	self.sessionteam = self.team;

	hadSpawned = self.hasSpawned;

	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	if ( level.hardcoreMode )
		self.maxhealth = 30;
	else
		self.maxhealth = 100;
	self.health = self.maxhealth;

	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
//	if ( self.pers["lives"] )
	//	self.pers["lives"]--;
//	self.lastStand = undefined;

	if ( !self.wasAliveAtMatchStart )
	{
		acceptablePassedTime = 20;
		if ( level.timeLimit > 0 && acceptablePassedTime < level.timeLimit * 60 / 4 )
			acceptablePassedTime = level.timeLimit * 60 / 4;
		
		if ( level.inGracePeriod || getTimePassed() < acceptablePassedTime * 1000 )
			self.wasAliveAtMatchStart = true;
	}

	[[level.onSpawnPlayer]]();

	//self maps\mp\gametypes\_missions::playerSpawned();

	prof_end( "spawnPlayer_preUTS" );



	level thread updateTeamStatus();

	prof_begin( "spawnPlayer_postUTS" );

	assert( isValidClass( self.class ) );

	//self maps\mp\gametypes\_class::setClass( self.class );
	self.curClass = self.class;

	self freezeControls( false );
	self enableWeapons();
	if ( !hadSpawned && game["state"] == "playing" )
	{
		team = self.team;

		self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );			
		thread maps\mp\gametypes\_hud::showClientScoreBar( 5.0 );

	}
	prof_end( "spawnPlayer_postUTS" );

	waittillframeend;
	self notify( "spawned_player" );

	self logstring( "S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] );

//	self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter();

	if ( game["state"] == "postgame" )
	{
		assert( !level.intermission );
		// We're in the victory screen, but before intermission
		self freezePlayerForRoundEnd();
	}

	// HNS
	self maps\mp\gametypes\_main::spawnPlayer();
}

spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator( origin, angles );
}

// spawnSpectator clone without notifies for spawning between respawn delays
respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

// spawnSpectator helper
in_spawnSpectator( origin, angles )
{
	self setSpawnVariables();

	// don't clear lower message if not actually a spectator,
	// because it probably has important information like when we'll spawn
	if ( self.pers["team"] == "spectator" )
		self clearLowerMessage();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	else
		self.statusicon = "hud_status_dead";

	//maps\mp\gametypes\_spectating::setSpectatePermissions(); // HNS

	[[level.onSpawnSpectator]]( origin, angles );

	if ( level.teamBased && !level.splitscreen )
		self thread spectatorThirdPersonness();

	level thread updateTeamStatus();
}

spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");

	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");

	self.spectatingThirdPerson = false;

	self setThirdPerson( true );
}

getPlayerFromClientNum( clientNum )
{
	if ( clientNum < 0 )
		return undefined;

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[i] getEntityNumber() == clientNum )
			return level.players[i];
	}
	return undefined;
}

setThirdPerson( value )
{
	if ( value != self.spectatingThirdPerson )
	{
		self.spectatingThirdPerson = value;
		if ( value )
		{
			//self setClientDvar( "cg_thirdPerson", "1" );
			//self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
			//self setClientDvar( "cg_fov", "40" );
		}
		else
		{
			//self setClientDvar( "cg_thirdPerson", "0" );
			//self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
			//self setClientDvar( "cg_fov", "65" );
		}
	}
}

/*waveSpawnTimer()
{
	level endon( "game_ended" );

	while ( game["state"] == "playing" )
	{
		time = getTime();
		
		if ( time - level.lastWave["allies"] > (level.waveDelay["allies"] * 1000) )
		{
			level notify ( "wave_respawn_allies" );
			level.lastWave["allies"] = time;
			level.wavePlayerSpawnIndex["allies"] = 0;
		}

		if ( time - level.lastWave["axis"] > (level.waveDelay["axis"] * 1000) )
		{
			level notify ( "wave_respawn_axis" );
			level.lastWave["axis"] = time;
			level.wavePlayerSpawnIndex["axis"] = 0;
		}
		
		wait ( 0.05 );
	}
}*/


default_onSpawnSpectator( origin, angles)
{
	if( isDefined( origin ) && isDefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	self clearLowerMessage();

	self freezeControls( false );

	self setClientDvar( "cg_everyoneHearsEveryone", 1 );

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	[[level.onSpawnIntermission]]();
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}


default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
//	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	spawnpoint = spawnPoints[0];

	if( isDefined( spawnpoint ) )
		self spawn( spawnpoint.origin, spawnpoint.angles );
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

// returns the best guess of the exact time until the scoreboard will be displayed and player control will be lost.
// returns undefined if time is not known
timeUntilRoundEnd()
{
	if ( level.gameEnded )
	{
		timePassed = (getTime() - level.gameEndTime) / 1000;
		timeRemaining = level.postRoundTime - timePassed;
		
		if ( timeRemaining < 0 )
			return 0;
		
		return timeRemaining;
	}

	if ( level.inOvertime )
		return undefined;

	if ( level.timeLimit <= 0 )
		return undefined;

	if ( !isDefined( level.startTime ) )
		return undefined;

	timePassed = (getTime() - level.startTime)/1000;
	timeRemaining = (level.timeLimit * 60) - timePassed;

	return timeRemaining + level.postRoundTime;
}

freezePlayerForRoundEnd()
{
	self clearLowerMessage();

	self closeMenu();
	self closeInGameMenu();

	self freezeControls( true );
//	self disableWeapons();
}


logXPGains()
{
	if ( !isDefined( self.xpGains ) )
		return;

	xpTypes = getArrayKeys( self.xpGains );
	for ( index = 0; index < xpTypes.size; index++ )
	{
		gain = self.xpGains[xpTypes[index]];
		if ( !gain )
			continue;
			
		self logString( "xp " + xpTypes[index] + ": " + gain );
	}
}

freeGameplayHudElems()
{
	// free up some hud elems so we have enough for other things.

	// perk icons
	if ( isdefined( self.perkicon ) )
	{
		if ( isdefined( self.perkicon[0] ) )
		{
			self.perkicon[0] destroyElem();
			self.perkname[0] destroyElem();
		}
		if ( isdefined( self.perkicon[1] ) )
		{
			self.perkicon[1] destroyElem();
			self.perkname[1] destroyElem();
		}
		if ( isdefined( self.perkicon[2] ) )
		{
			self.perkicon[2] destroyElem();
			self.perkname[2] destroyElem();
		}
	}
	self notify("perks_hidden"); // stop any threads that are waiting to hide the perk icons

	// lower message
	self.lowerMessage destroyElem();
	self.lowerTimer destroyElem();

	// progress bar
	if ( isDefined( self.proxBar ) )
		self.proxBar destroyElem();
	if ( isDefined( self.proxBarText ) )
		self.proxBarText destroyElem();
}


getHostPlayer()
{
	players = getEntArray( "player", "classname" );

	for ( index = 0; index < players.size; index++ )
	{
		if ( players[index] getEntityNumber() == 0 )
			return players[index];
	}
}


hostIdledOut()
{
	hostPlayer = getHostPlayer();

	// host never spawned
	if ( isDefined( hostPlayer ) && !hostPlayer.hasSpawned && !isDefined( hostPlayer.selectedClass ) )
		return true;

	return false;
}


endGame( winner, endReasonText )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" || level.gameEnded )
		return;

	if ( isDefined( level.onEndGame ) )
		[[level.onEndGame]]( winner );

	visionSetNaked( "mpOutro", 2.0 );

	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended" );

	setGameEndTime( 0 ); // stop/hide the timers

	if ( level.rankedMatch )
	{
		setXenonRanks();
		
		if ( hostIdledOut() )
		{
			level.hostForcedEnd = true;
			logString( "host idled out" );
			endLobby();
		}
	}

	updatePlacement();
	//updateMatchBonusScores( winner );
	updateWinLossStats( winner );

	setdvar( "g_deadChat", 1 );

	// freeze players
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player freezePlayerForRoundEnd();
		player thread roundEndDoF( 4.0 );
		
		player freeGameplayHudElems();
		
		player setClientDvars( "cg_everyoneHearsEveryone", 1 );

		if( level.rankedMatch )
		{
			if ( isDefined( player.setPromotion ) )
				player setClientDvar( "ui_lobbypopup", "promotion" );
			else
				player setClientDvar( "ui_lobbypopup", "summary" );
		}

		// HNS
		player maps\mp\gametypes\_main::removeFromTeam();
	}

    // end round
    /*if ( (level.roundLimit > 1 || (!level.roundLimit && level.scoreLimit != 1)) && !level.forcedEnd )
    {
		if ( level.displayRoundEndText )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];
				
				if ( level.teamBased )
					player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, true, endReasonText );
				else
					player thread maps\mp\gametypes\_hud_message::outcomeNotify( winner, endReasonText );
		
				player setClientDvars( "ui_hud_hardcore", 1,
									   "cg_drawSpectatorMessages", 0,
									   "g_compassShowEnemies", 0 );
			}

			if ( level.teamBased && !(hitRoundLimit() || hitScoreLimit()) )
				thread announceRoundWinner( winner, level.roundEndDelay / 4 );
			
			if ( hitRoundLimit() || hitScoreLimit() )
				roundEndWait( level.roundEndDelay / 2, false );
			else
				roundEndWait( level.roundEndDelay, true );
		}

		game["roundsplayed"]++;
		roundSwitching = false;
		if ( !hitRoundLimit() && !hitScoreLimit() )
			roundSwitching = checkRoundSwitch();

		if ( roundSwitching && level.teamBased )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];
				
				if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
				{
					player [[level.spawnIntermission]]();
					player closeMenu();
					player closeInGameMenu();
					continue;
				}
				
				switchType = level.halftimeType;
				if ( switchType == "halftime" )
				{
					if ( level.roundLimit )
					{
						if ( (game["roundsplayed"] * 2) == level.roundLimit )
							switchType = "halftime";
						else
							switchType = "intermission";
					}
					else if ( level.scoreLimit )
					{
						if ( game["roundsplayed"] == (level.scoreLimit - 1) )
							switchType = "halftime";
						else
							switchType = "intermission";
					}
					else
					{
						switchType = "intermission";
					}
				}
				switch( switchType )
				{
					case "halftime":
						player leaderDialogOnPlayer( "halftime" );
						break;
					case "overtime":
						player leaderDialogOnPlayer( "overtime" );
						break;
					default:
						player leaderDialogOnPlayer( "side_switch" );
						break;
				}
				player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchType, true, level.halftimeSubCaption );
				player setClientDvar( "ui_hud_hardcore", 1 );
			}
			
			roundEndWait( level.halftimeRoundEndDelay, false );
		}
		else if ( !hitRoundLimit() && !hitScoreLimit() && !level.displayRoundEndText && level.teamBased )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];

				if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
				{
					player [[level.spawnIntermission]]();
					player closeMenu();
					player closeInGameMenu();
					continue;
				}
				
				switchType = level.halftimeType;
				if ( switchType == "halftime" )
				{
					if ( level.roundLimit )
					{
						if ( (game["roundsplayed"] * 2) == level.roundLimit )
							switchType = "halftime";
						else
							switchType = "roundend";
					}
					else if ( level.scoreLimit )
					{
						if ( game["roundsplayed"] == (level.scoreLimit - 1) )
							switchType = "halftime";
						else
							switchTime = "roundend";
					}
				}
				switch( switchType )
				{
					case "halftime":
						player leaderDialogOnPlayer( "halftime" );
						break;
					case "overtime":
						player leaderDialogOnPlayer( "overtime" );
						break;
				}
				player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchType, true, endReasonText );
				player setClientDvar( "ui_hud_hardcore", 1 );
			}			

			roundEndWait( level.halftimeRoundEndDelay, !(hitRoundLimit() || hitScoreLimit()) );
		}

        if ( !hitRoundLimit() && !hitScoreLimit() )
        {
        	level notify ( "restarting" );
            game["state"] = "playing";
            map_restart( true );
            return;
        }
        
		if ( hitRoundLimit() )
			endReasonText = game["strings"]["round_limit_reached"];
		else if ( hitScoreLimit() )
			endReasonText = game["strings"]["score_limit_reached"];
		else
			endReasonText = game["strings"]["time_limit_reached"];
	}*/

	//thread maps\mp\gametypes\_missions::roundEnd( winner );

	// HNS
	thread maps\mp\gametypes\_main::end();

	// catching gametype, since DM forceEnd sends winner as player entity, instead of string
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
		{
			player [[level.spawnIntermission]]();
			player closeMenu();
			player closeInGameMenu();
			continue;
		}

		player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, false, endReasonText );

		player setClientDvars( "ui_hud_hardcore", 1,
							   "cg_drawSpectatorMessages", 0,
							   "g_compassShowEnemies", 0 );
	}

	thread announceGameWinner( winner, level.postRoundTime / 2 );

	if ( level.splitscreen )
	{
		if ( winner == "allies" )
			playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
		else if ( winner == "axis" )
			playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
		else
			playSoundOnPlayers( game["music"]["defeat"] );
	}
	else
	{
		if ( winner == "allies" )
		{
			playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
			playSoundOnPlayers( game["music"]["defeat"], "axis" );
		}
		else if ( winner == "axis" )
		{
			playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
			playSoundOnPlayers( game["music"]["defeat"], "allies" );
		}
		else
		{
			playSoundOnPlayers( game["music"]["defeat"] );
		}
	}

	roundEndWait( level.postRoundTime, false );

	maps\mp\gametypes\_main::intermission(); // HNS

	level.intermission = true;

	//regain players array since some might've disconnected during the wait above
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
		player notify ( "reset_outcome" );
		player thread spawnIntermission();
		player setClientDvar( "ui_hud_hardcore", 0 );
		player setclientdvar( "g_scriptMainMenu", game["menu_eog_main"] );
	}

	logString( "game ended" );
	//wait getDvarFloat( "scr_show_unlock_wait" );

	if( level.console )
	{
		exitLevel( false );
		return;
	}

	// popup for game summary
/*	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		//iPrintLnBold( "opening eog summary!" );
		//player.sessionstate = "dead";
		player openMenu( game["menu_eog_unlock"] );
	}*/

	thread timeLimitClock_Intermission( getDvarFloat( "scr_intermission_time" ) );
	wait getDvarFloat( "scr_intermission_time" );

	// Close menus
	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] closeMenu();
		level.players[index] closeInGameMenu();
	}

	// HNS
	if (isDefined(level.nextMap))
		setDvar("sv_mapRotationCurrent", "map " + level.nextMap);

	exitLevel(false);
}


getWinningTeam()
{
	if ( getGameScore( "allies" ) == getGameScore( "axis" ) )
		winner = "tie";
	else if ( getGameScore( "allies" ) > getGameScore( "axis" ) )
		winner = "allies";
	else
		winner = "axis";
}


roundEndWait( defaultDelay, matchBonus )
{
	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}

	if ( !matchBonus )
	{
		wait ( defaultDelay );
		return;
	}

    wait ( defaultDelay / 2 );
	level notify ( "give_match_bonus" );
	wait ( defaultDelay / 2 );

	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}
}


roundEndDOF( time )
{
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}


/*updateMatchBonusScores( winner )
{
	if ( !game["timepassed"] )
		return;

	if ( !level.rankedMatch )
		return;

	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = getTimePassed() / 1000;		
		// cap it at 20 minutes to avoid exploiting
		gameLength = min( gameLength, 1200 );
	}
	else
	{
		gameLength = level.timeLimit * 60;
	}
		
	if ( level.teamBased )
	{
		if ( winner == "allies" )
		{
			winningTeam = "allies";
			losingTeam = "axis";
		}
		else if ( winner == "axis" )
		{
			winningTeam = "axis";
			losingTeam = "allies";
		}
		else
		{
			winningTeam = "tie";
			losingTeam = "tie";
		}

		if ( winningTeam != "tie" )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}

			// no bonus for hosts who force ends
			if ( level.hostForcedEnd && player getEntityNumber() == 0 )
				continue;

			spm = player maps\mp\gametypes\_rank::getSPM();				
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined(player.pers["team"] ) && player.pers["team"] == losingTeam )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
	else
	{
		if ( isDefined( winner ) )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}
			
			spm = player maps\mp\gametypes\_rank::getSPM();

			isWinner = false;
			for ( pIdx = 0; pIdx < min( level.placement["all"][0].size, 3 ); pIdx++ )
			{
				if ( level.placement["all"][pIdx] != player )
					continue;
				isWinner = true;				
			}
			
			if ( isWinner )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
}


giveMatchBonus( scoreType, score )
{
	self endon ( "disconnect" );

	level waittill ( "give_match_bonus" );

	self maps\mp\gametypes\_rank::giveRankXP( scoreType, score );
	logXPGains();

	self maps\mp\gametypes\_rank::endGameUpdate();
}*/


setXenonRanks( winner )
{
	players = level.players;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( !isdefined(player.score) || !isdefined(player.pers["team"]) )
			continue;

	}

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( !isdefined(player.score) || !isdefined(player.pers["team"]) )
			continue;		
		
		setPlayerTeamRank( player, i, player.score - 5 * player.deaths );
		player logString( "team: score " + player.pers["team"] + ":" + player.score );
	}
	sendranks();
}


/*getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;

	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}

	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}*/


checkTimeLimit()
{
	if ( isDefined( level.timeLimitOverride ) && level.timeLimitOverride )
		return;

	if ( game["state"] != "playing" )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.timeLimit <= 0 )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.inPrematchPeriod )
	{
		setGameEndTime( 0 );
		return;
	}

	if ( !isdefined( level.startTime ) )
		return;

	timeLeft = getTimeRemaining();

	// want this accurate to the millisecond
	setGameEndTime( getTime() + int(timeLeft) );

	if ( timeLeft > 0 )
		return;

	[[level.onTimeLimit]]();
}

getTimeRemaining()
{
	return level.timeLimit * 60 * 1000 - getTimePassed();
}

checkScoreLimit()
{
	if ( game["state"] != "playing" )
		return;

	if ( level.scoreLimit <= 0 )
		return;

	if( game["teamScores"]["allies"] < level.scoreLimit && game["teamScores"]["axis"] < level.scoreLimit )
		return;

	[[level.onScoreLimit]]();
}


/*hitRoundLimit()
{
	if( level.roundLimit <= 0 )
		return false;

	return ( game["roundsplayed"] >= level.roundLimit );
}*/

hitScoreLimit()
{
	if( level.scoreLimit <= 0 )
		return false;

	if( game["teamScores"]["allies"] >= level.scoreLimit || game["teamScores"]["axis"] >= level.scoreLimit )
		return true;

	return false;
}

// These must stay here, except we can get a script compile error when it isn't started with hns immeditally
registerRoundSwitchDvar( dvarString, defaultValue, minValue, maxValue )
{
/*	dvarString = ("scr_" + dvarString + "_roundswitch");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		

	level.roundswitchDvar = dvarString;
	level.roundswitchMin = minValue;
	level.roundswitchMax = maxValue;
	level.roundswitch = getDvarInt( level.roundswitchDvar );*/
}

registerRoundLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
/*	dvarString = ("scr_" + dvarString + "_roundlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		

	level.roundLimitDvar = dvarString;
	level.roundlimitMin = minValue;
	level.roundlimitMax = maxValue;
	level.roundLimit = getDvarInt( level.roundLimitDvar );*/
}


registerScoreLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
/*	dvarString = ("scr_" + dvarString + "_scorelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.scoreLimitDvar = dvarString;	
	level.scorelimitMin = minValue;
	level.scorelimitMax = maxValue;
	level.scoreLimit = getDvarInt( level.scoreLimitDvar );

	setDvar( "ui_scorelimit", level.scoreLimit );*/
}


registerTimeLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
/*	dvarString = ("scr_" + dvarString + "_timelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarFloat( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarFloat( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.timeLimitDvar = dvarString;	
	level.timelimitMin = minValue;
	level.timelimitMax = maxValue;
	level.timelimit = getDvarFloat( level.timeLimitDvar );

	setDvar( "ui_timelimit", level.timelimit );*/
}

registerNumLivesDvar( dvarString, defaultValue, minValue, maxValue )
{
/*	dvarString = ("scr_" + dvarString + "_numlives");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.numLivesDvar = dvarString;	
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
	level.numLives = getDvarInt( level.numLivesDvar );*/
}

// HNS
registerHideTimeDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_hidetime");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.hideTimeDvar = dvarString;	
	level.hideTimeMin = minValue;
	level.hideTimeMax = maxValue;
	level.hideTime = getDvarInt( level.hideTimeDvar );

	setDvar( "ui_hidetime", level.hideTime );
}

getValueInRange( value, minValue, maxValue )
{
	if ( value > maxValue )
		return maxValue;
	else if ( value < minValue )
		return minValue;
	else
		return value;
}

/*updateGameTypeDvars()
{
	level endon ( "game_ended" );

	while ( game["state"] == "playing" )
	{
		roundlimit = getValueInRange( getDvarInt( level.roundLimitDvar ), level.roundLimitMin, level.roundLimitMax );
		if ( roundlimit != level.roundlimit )
		{
			level.roundlimit = roundlimit;
			level notify ( "update_roundlimit" );
		}

		timeLimit = getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
		if ( timeLimit != level.timeLimit )
		{
			level.timeLimit = timeLimit;
			setDvar( "ui_timelimit", level.timeLimit );
			level notify ( "update_timelimit" );
		}
		thread checkTimeLimit();

		scoreLimit = getValueInRange( getDvarInt( level.scoreLimitDvar ), level.scoreLimitMin, level.scoreLimitMax );
		if ( scoreLimit != level.scoreLimit )
		{
			level.scoreLimit = scoreLimit;
			setDvar( "ui_scorelimit", level.scoreLimit );
			level notify ( "update_scorelimit" );
		}
		thread checkScoreLimit();
		
		// make sure we check time limit right when game ends
		if ( isdefined( level.startTime ) )
		{
			if ( getTimeRemaining() < 3000 )
			{
				wait .1;
				continue;
			}
		}
		wait 1;
	}
}*/


/*menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = teams[randomInt(2)];

	self closeMenus();

	if ( level.teamBased )
	{
		if ( getDvarInt( "party_autoteams" ) == 1 )
		{
			teamNum = getAssignedTeam( self );
			switch ( teamNum )
			{			
				case 1:
					assignment = teams[1];
					break;
					
				case 2:
					assignment = teams[0];
					break;
					
				default:
					assignment = "";
			}
		}
		
		if ( assignment == "" || getDvarInt( "party_autoteams" ) == 0 )
		{	
			playerCounts = self maps\mp\gametypes\_teams::CountPlayers();
					
			// if teams are equal return the team with the lowest score
			if ( playerCounts["allies"] == playerCounts["axis"] )
			{
				if( getTeamScore( "allies" ) == getTeamScore( "axis" ) )
					assignment = teams[randomInt(2)];
				else if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
					assignment = "allies";
				else
					assignment = "axis";
			}
			else if( playerCounts["allies"] < playerCounts["axis"] )
			{
				assignment = "allies";
			}
			else
			{
				assignment = "axis";
			}
		}
		
		if ( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
			self beginClassChoice();
			return;
		}
	}

	if ( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.class = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
	}

	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";

	self notify("joined_team");
	self notify("end_respawn");

	self beginClassChoice();

	self setclientdvar( "g_scriptMainMenu", game[ "menu_class_" + self.pers["team"] ] );
}*/


updateObjectiveText()
{
	if ( self.pers["team"] == "spectator" )
	{
		self setClientDvar( "cg_objectiveText", "" );
		return;
	}

	if( level.scorelimit > 0 )
	{
		if ( level.splitScreen )
			self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ) );
		else
			self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ), level.scorelimit );
	}
	else
	{
		self setclientdvar( "cg_objectiveText", getObjectiveText( self.pers["team"] ) );
	}
}

closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}

beginClassChoice( forceNewChoice )
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );

	// HNS
	self thread maps\mp\gametypes\_main::changeClass();
}

showMainMenuForTeam()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );

	team = self.pers["team"];

	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.

	self openMenu( game[ "menu_class_" + team ] );
}

menuAllies()
{
//	self closeMenus();

	if(!isDefined(self.pers["team"]) || self.pers["team"] != "allies")
	{
		self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

//		self updateObjectiveText();

		self.sessionteam = "allies";

		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	self beginClassChoice();
}


menuAxis()
{
//	self closeMenus();
	if(!isDefined(self.pers["team"]) || self.pers["team"] != "axis")
	{
		self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.team = "axis";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "axis";

		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	self beginClassChoice();
}


menuSpectator()
{
	self closeMenus();

	// HNS
	self maps\mp\gametypes\_main::removeFromTeam();
	self maps\mp\gametypes\_main::spectator();

	if (isDefined(self.thirdPersonInfo))
	{
		self.thirdPersonInfo destroy();
	}

	if(!isDefined(self.pers["team"]) || self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();

		self setclientdvar("g_scriptMainMenu", game["menu_team"]);

		self notify("joined_spectators");
	}
}

// HNS Re-written
menuClass( class )
{
	self closeMenus();

	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;
	//class = self maps\mp\gametypes\_class::getClassChoice( response );
	//primary = self maps\mp\gametypes\_class::getWeaponChoice( response );
/*	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

//		if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
//		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_main::spawnPlayer();
//		}
	}
	else
	{*/

	self.pers["class"] = class;
	self.class = class;
	//self.pers["primary"] = primary;
	//self.pers["weapon"] = undefined;

	if ( game["state"] == "postgame" )
		return;

	if ( game["state"] == "playing" )
		self thread [[level.spawnClient]]();

/*	}*/

	level thread updateTeamStatus();

	//self thread maps\mp\gametypes\_spectating::setSpectatePermissions(); // HNS
}

/#
assertProperPlacement()
{
	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers - 1; i++ )
	{
		if ( level.placement["all"][i].score < level.placement["all"][i + 1].score )
		{
			println("^1Placement array:");
			for ( i = 0; i < numPlayers; i++ )
			{
				player = level.placement["all"][i];
				println("^1" + i + ". " + player.name + ": " + player.score );
			}
			assertmsg( "Placement array was not properly sorted" );
			break;
		}
	}
}
#/


removeDisconnectedPlayerFromPlacement()
{
	offset = 0;
	numPlayers = level.placement["all"].size;
	found = false;
	for ( i = 0; i < numPlayers; i++ )
	{
		if ( level.placement["all"][i] == self )
			found = true;
		
		if ( found )
			level.placement["all"][i] = level.placement["all"][ i + 1 ];
	}
	if ( !found )
		return;

	level.placement["all"][ numPlayers - 1 ] = undefined;
	assert( level.placement["all"].size == numPlayers - 1 );

	/#
	// no longer calling this here because it's possible, due to delayed assist credit,
	// for someone's score to change after updatePlacement() is called.
	//assertProperPlacement();
	#/

	updateTeamPlacement();

	if ( level.teamBased )
		return;
		
	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers; i++ )
	{
		player = level.placement["all"][i];
		player notify( "update_outcome" );
	}

}

updatePlacement()
{
	prof_begin("updatePlacement");

	if ( !level.players.size )
		return;

	level.placement["all"] = [];
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( level.players[index].team == "allies" || level.players[index].team == "axis" )
			level.placement["all"][level.placement["all"].size] = level.players[index];
	}
		
	placementAll = level.placement["all"];

	for ( i = 1; i < placementAll.size; i++ )
	{
		player = placementAll[i];
		playerScore = player.score;
		for ( j = i - 1; j >= 0 && (playerScore > placementAll[j].score || (playerScore == placementAll[j].score && player.deaths < placementAll[j].deaths)); j-- )
			placementAll[j + 1] = placementAll[j];
		placementAll[j + 1] = player;
	}

	level.placement["all"] = placementAll;

	/#
	assertProperPlacement();
	#/

	updateTeamPlacement();

	prof_end("updatePlacement");
}


updateTeamPlacement()
{
	placement["allies"]    = [];
	placement["axis"]      = [];
	placement["spectator"] = [];

	if ( !level.teamBased )
		return;

	placementAll = level.placement["all"];
	placementAllSize = placementAll.size;

	for ( i = 0; i < placementAllSize; i++ )
	{
		player = placementAll[i];
		team = player.pers["team"];
		
		placement[team][ placement[team].size ] = player;
	}

	level.placement["allies"] = placement["allies"];
	level.placement["axis"]   = placement["axis"];
}

onXPEvent( event )
{
	self maps\mp\gametypes\_rank::giveRankXP( event );
}


givePlayerScore( event, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );

	if ( score == player.pers["score"] )
		return;

	player maps\mp\gametypes\_persistence::statAdd( "score", (player.pers["score"] - score) );

	player.score = player.pers["score"];

	if ( !level.teambased )
		thread sendUpdatedDMScores();

	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


default_onPlayerScore( event, player, victim )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );

	assert( isDefined( score ) );
	/*
	if ( event == "assist" )
		player.pers["score"] += 2;
	else
		player.pers["score"] += 10;
	*/

	player.pers["score"] += score;
}


_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

	player.pers["score"] = score;
	player.score = player.pers["score"];

	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


_getPlayerScore( player )
{
	return player.pers["score"];
}


giveTeamScore( event, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;
		
	teamScore = game["teamScores"][team];
	[[level.onTeamScore]]( event, team, player, victim );

	if ( teamScore == game["teamScores"][team] )
		return;

	updateTeamScores( team );

	thread checkScoreLimit();
}

_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;

	updateTeamScores( team );

	thread checkScoreLimit();
}

updateTeamScores( team1, team2 )
{
	setTeamScore( team1, getGameScore( team1 ) );
	if ( isdefined( team2 ) )
		setTeamScore( team2, getGameScore( team2 ) );

	if ( level.teambased )
		thread sendUpdatedTeamScores();
}


_getTeamScore( team )
{
	return game["teamScores"][team];
}


default_onTeamScore( event, team, player, victim )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );

	assert( isDefined( score ) );

	otherTeam = level.otherTeam[team];

	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		level.wasWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		level.wasWinning = otherTeam;
		
	game["teamScores"][team] += score;

	isWinning = "none";
	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		isWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		isWinning = otherTeam;

	if ( !level.splitScreen && isWinning != "none" && isWinning != level.wasWinning && getTime() - level.lastStatusTime  > 5000 )
	{
		level.lastStatusTime = getTime();
		leaderDialog( "lead_taken", isWinning, "status" );
		if ( level.wasWinning != "none")
			leaderDialog( "lead_lost", level.wasWinning, "status" );		
	}

	if ( isWinning != "none" )
		level.wasWinning = isWinning;
}


sendUpdatedTeamScores()
{
	level notify("updating_scores");
	level endon("updating_scores");
	wait .05;

	WaitTillSlowProcessAllowed();

	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] updateScores();
	}
}

sendUpdatedDMScores()
{
	level notify("updating_dm_scores");
	level endon("updating_dm_scores");
	wait .05;

	WaitTillSlowProcessAllowed();

	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] updateDMScores();
		level.players[i].updatedDMScores = true;
	}
}

initPersStat( dataName )
{
	if( !isDefined( self.pers[dataName] ) )
		self.pers[dataName] = 0;
}


getPersStat( dataName )
{
	return self.pers[dataName];
}


incPersStat( dataName, increment )
{
	self.pers[dataName] += increment;
	self maps\mp\gametypes\_persistence::statAdd( dataName, increment );
}


updatePersRatio( ratio, num, denom )
{
	numValue = self maps\mp\gametypes\_persistence::statGet( num );
	denomValue = self maps\mp\gametypes\_persistence::statGet( denom );
	if ( denomValue == 0 )
		denomValue = 1;
		
	self maps\mp\gametypes\_persistence::statSet( ratio, int( (numValue * 1000) / denomValue ) );		
}


updateTeamStatus()
{
	// run only once per frame, at the end of the frame.
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon ( "game_ended" );
	level.updatingStatus = true; // HNS
	waittillframeend;

	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

	if ( game["state"] == "postgame" )
		return;

	resetTimeout();

	prof_begin( "updateTeamStatus" );

	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	level.alivePlayers["allies"] = [];
	level.alivePlayers["axis"] = [];

	//level.lastAliveCount["allies"] = level.aliveCount["allies"];
	//level.lastAliveCount["axis"] = level.aliveCount["axis"];
	//level.aliveCount["allies"] = 0;
	//level.aliveCount["axis"] = 0;
	//level.playerLives["allies"] = 0;
	//level.playerLives["axis"] = 0;
	//level.alivePlayers["allies"] = [];
	//level.alivePlayers["axis"] = [];
	//level.activePlayers = [];

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if ( !isDefined( player ) && level.splitscreen )
			continue;

		team = player.team;
		class = player.class;

		if ( team != "spectator" && (isDefined( class ) && class != "") )
		{
			level.playerCount[team]++;
			level.alivePlayers[team][level.alivePlayers[team].size] = player;

			/*if ( player.sessionstate == "playing" )
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;

				if ( isAlive( player ) )
				{
					level.alivePlayers[team][level.alivePlayers.size] = player;
					level.activeplayers[ level.activeplayers.size ] = player;
				}
			}
			else
			{
				if ( player maySpawn() )
					level.playerLives[team]++;
			}*/
		}
	}

	// HNS aliveCount -> playerCount
	if ( level.playerCount["allies"] + level.playerCount["axis"] > level.maxPlayerCount )
		level.maxPlayerCount = level.playerCount["allies"] + level.playerCount["axis"];

	if ( level.playerCount["allies"] )
		level.everExisted["allies"] = true;
	if ( level.playerCount["axis"] )
		level.everExisted["axis"] = true;

	prof_end( "updateTeamStatus" );

	// HNS
	thread maps\mp\gametypes\_main::orderTeams();

	level.updatingStatus = undefined; // HNS
	level notify("statusupdated");
}

isValidClass( class )
{
	return isdefined( class ) && class != "";
}

/*playTickingSound()
{
	self endon("death");
	self endon("stop_ticking");
	level endon("game_ended");

	while(1)
	{
		self playSound( "ui_mp_suitcasebomb_timer" );
		wait 1.0;
	}
}

stopTickingSound()
{
	self notify("stop_ticking");
}*/

/*timeLimitClock()
{
	level endon ( "game_ended" );

	wait .05;

	clockObject = spawn( "script_origin", (0,0,0) );

	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped && level.timeLimit )
		{
			timeLeft = getTimeRemaining() / 1000;
			timeLeftInt = int(timeLeft + 0.5); // adding .5 and flooring rounds it.
			
			if ( timeLeftInt >= 30 && timeLeftInt <= 60 )
				level notify ( "match_ending_soon" );
				
			if ( timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0) )
			{
				level notify ( "match_ending_very_soon" );
				// don't play a tick at exactly 0 seconds, that's when something should be happening!
				if ( timeLeftInt == 0 )
					break;
				
				clockObject playSound( "ui_mp_timer_countdown" );
			}
			
			// synchronize to be exactly on the second
			if ( timeLeft - floor(timeLeft) >= .05 )
				wait timeLeft - floor(timeLeft);
		}

		wait ( 1.0 );
	}
}*/

timeLimitClock_Intermission( waitTime )
{
	if (!isDefined(level.settime)) // HNS
		setGameEndTime( getTime() + int(waitTime*1000) );

	clockObject = spawn( "script_origin", (0,0,0) );

	if ( waitTime >= 10.0 )
		wait ( waitTime - 10.0 );
		
	for ( ;; )
	{
		clockObject playSound( "ui_mp_timer_countdown" );
		wait ( 1.0 );
	}	
}


gameTimer()
{
	level endon ( "game_ended" );

	level waittill("prematch_over");

	level.startTime = getTime();
	level.discardTime = 0;

	if ( isDefined( game["roundMillisecondsAlreadyPassed"] ) )
	{
		level.startTime -= game["roundMillisecondsAlreadyPassed"];
		game["roundMillisecondsAlreadyPassed"] = undefined;
	}

	prevtime = gettime();

	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped )
		{
			// the wait isn't always exactly 1 second. dunno why.
			game["timepassed"] += gettime() - prevtime;
		}
		prevtime = gettime();
		wait ( 1.0 );
	}
}

getTimePassed()
{
	if ( !isDefined( level.startTime ) )
		return 0;

	if ( level.timerStopped )
		return (level.timerPauseTime - level.startTime) - level.discardTime;
	else
		return (gettime()            - level.startTime) - level.discardTime;

}


pauseTimer()
{
	if ( level.timerStopped )
		return;

	level.timerStopped = true;
	level.timerPauseTime = gettime();
}


resumeTimer()
{
	if ( !level.timerStopped )
		return;

	level.timerStopped = false;
	level.discardTime += gettime() - level.timerPauseTime;
}


startGame()
{
	thread gameTimer();
	level.timerStopped = false;
	thread maps\mp\gametypes\_spawnlogic::spawnPerFrameUpdate();

	prematchPeriod();
	level notify("prematch_over");

	//thread timeLimitClock();
	thread gracePeriod();

	thread musicController();
	//thread maps\mp\gametypes\_missions::roundBegin();	
}


musicController()
{
	level endon ( "game_ended" );

	if ( !level.hardcoreMode )
		thread suspenseMusic();

	level waittill ( "match_ending_soon" );

	if ( level.roundLimit == 1 || game["roundsplayed"] == (level.roundLimit - 1) )
	{	
		if ( !level.splitScreen )
		{
			if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
			{
				if ( !level.hardcoreMode )
				{
					playSoundOnPlayers( game["music"]["winning"], "allies" );
					playSoundOnPlayers( game["music"]["losing"], "axis" );
				}
		
				leaderDialog( "winning", "allies" );
				leaderDialog( "losing", "axis" );
			}
			else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			{
				if ( !level.hardcoreMode )
				{
					playSoundOnPlayers( game["music"]["winning"], "axis" );
					playSoundOnPlayers( game["music"]["losing"], "allies" );
				}
					
				leaderDialog( "winning", "axis" );
				leaderDialog( "losing", "allies" );
			}
			else
			{
				if ( !level.hardcoreMode )
					playSoundOnPlayers( game["music"]["losing"] );

				leaderDialog( "timesup" );
			}

			level waittill ( "match_ending_very_soon" );
			leaderDialog( "timesup" );
		}
	}
	else
	{
		if ( !level.hardcoreMode )
			playSoundOnPlayers( game["music"]["losing"] );

		leaderDialog( "timesup" );
	}
}


suspenseMusic()
{
	level endon ( "game_ended" );
	level endon ( "match_ending_soon" );

	numTracks = game["music"]["suspense"].size;
	for ( ;; )
	{
		wait ( randomFloatRange( 60, 120 ) );
		
		playSoundOnPlayers( game["music"]["suspense"][randomInt(numTracks)] ); 
	}
}


waitForPlayers( maxTime )
{
	endTime = gettime() + maxTime * 1000 - 200;

	if ( level.teamBased )
		while( (!level.everExisted[ "axis" ] || !level.everExisted[ "allies" ]) && gettime() < endTime )
			wait ( 0.05 );
	else
		while ( level.maxPlayerCount < 2 && gettime() < endTime )
			wait ( 0.05 );
}


prematchPeriod()
{
	makeDvarServerInfo( "ui_hud_hardcore", 1 );
	setDvar( "ui_hud_hardcore", 1 );
	level endon( "game_ended" );

	matchStartTimerSkip();

	level.inPrematchPeriod = false;

	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] freezeControls( false );
		level.players[index] enableWeapons();

		hintMessage = getObjectiveHintText( level.players[index].pers["team"] );
		if ( !isDefined( hintMessage ) || !level.players[index].hasSpawned )
			continue;

		level.players[index] setClientDvar( "scr_objectiveText", hintMessage );
		level.players[index] thread maps\mp\gametypes\_hud_message::hintMessage( hintMessage );

	}

	leaderDialog( "offense_obj", game["attackers"], "introboost" );
	leaderDialog( "defense_obj", game["defenders"], "introboost" );

	if ( game["state"] != "playing" )
		return;

	setDvar( "ui_hud_hardcore", level.hardcoreMode );
}


gracePeriod()
{
	level endon("game_ended");

	wait ( level.gracePeriod );

	level notify ( "grace_period_ending" );
	wait ( 0.05 );

	level.inGracePeriod = false;

	if ( game["state"] != "playing" )
		return;

/*	if ( level.numLives )
	{
		// Players on a team but without a weapon show as dead since they can not get in this round
		players = level.players;
		
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( !player.hasSpawned && player.sessionteam != "spectator" && !isAlive( player ) )
				player.statusicon = "hud_status_dead";
		}
	}*/

	level thread updateTeamStatus();
}


/*announceRoundWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "round_success", "allies" );
		leaderDialog( "round_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "round_success", "axis" );
		leaderDialog( "round_failure", "allies" );
	}
	else
	{
//		leaderDialog( "mission_draw" );
	}
}*/


announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "mission_success", "allies" );
		leaderDialog( "mission_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "mission_success", "axis" );
		leaderDialog( "mission_failure", "allies" );
	}
	else
	{
		leaderDialog( "mission_draw" );
	}
}


updateWinStats( winner )
{
	winner maps\mp\gametypes\_persistence::statAdd( "losses", -1 );

	println( "setting winner: " + winner maps\mp\gametypes\_persistence::statGet( "wins" ) );
	winner maps\mp\gametypes\_persistence::statAdd( "wins", 1 );
	winner updatePersRatio( "wlratio", "wins", "losses" );
	winner maps\mp\gametypes\_persistence::statAdd( "cur_win_streak", 1 );

	cur_win_streak = winner maps\mp\gametypes\_persistence::statGet( "cur_win_streak" );
	if ( cur_win_streak > winner maps\mp\gametypes\_persistence::statGet( "win_streak" ) )
		winner maps\mp\gametypes\_persistence::statSet( "win_streak", cur_win_streak );
}


updateLossStats( loser )
{	
	loser maps\mp\gametypes\_persistence::statAdd( "losses", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );	
}


updateTieStats( loser )
{	
	loser maps\mp\gametypes\_persistence::statAdd( "losses", -1 );

	loser maps\mp\gametypes\_persistence::statAdd( "ties", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );	
}


updateWinLossStats( winner )
{
//	if ( level.roundLimit > 1 && !hitRoundLimit() )
	//	return;
		
	players = level.players;

	if ( !isDefined( winner ) || ( isDefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] getEntityNumber() == 0 )
				return;
				
			updateTieStats( players[i] );
		}		
	} 
	else if ( isPlayer( winner ) )
	{
		if ( level.hostForcedEnd && winner getEntityNumber() == 0 )
			return;
				
		updateWinStats( winner );
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] getEntityNumber() == 0 )
				return;

			if ( winner == "tie" )
				updateTieStats( players[i] );
			else if ( players[i].pers["team"] == winner )
				updateWinStats( players[i] );
		}
	}
}


/*TimeUntilWaveSpawn( minimumWait )
{
	// the time we'll spawn if we only wait the minimum wait.
	earliestSpawnTime = gettime() + minimumWait * 1000;

	lastWaveTime = level.lastWave[self.pers["team"]];
	waveDelay = level.waveDelay[self.pers["team"]] * 1000;

	// the number of waves that will have passed since the last wave happened, when the minimum wait is over.
	numWavesPassedEarliestSpawnTime = (earliestSpawnTime - lastWaveTime) / waveDelay;
	// rounded up
	numWaves = ceil( numWavesPassedEarliestSpawnTime );

	timeOfSpawn = lastWaveTime + numWaves * waveDelay;

	// avoid spawning everyone on the same frame
	if ( isdefined( self.waveSpawnIndex ) )
		timeOfSpawn += 50 * self.waveSpawnIndex;

	return (timeOfSpawn - gettime()) / 1000;
}

TeamKillDelay()
{
	teamkills = self.pers["teamkills"];
	if ( level.minimumAllowedTeamKills < 0 || teamkills <= level.minimumAllowedTeamKills )
		return 0;
	exceeded = (teamkills - level.minimumAllowedTeamKills);
	return maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillspawndelay" ) * exceeded;
}


TimeUntilSpawn( includeTeamkillDelay )
{
	if ( level.inGracePeriod && !self.hasSpawned )
		return 0;

	respawnDelay = 0;
	if ( self.hasSpawned )
	{
		result = self [[level.onRespawnDelay]]();
		if ( isDefined( result ) )
			respawnDelay = result;
		else
			respawnDelay = getDvarInt( "scr_" + level.gameType + "_playerrespawndelay" );
			
		if ( level.hardcoreMode && !isDefined( result ) && !respawnDelay )
			respawnDelay = 10.0;
			
		if ( includeTeamkillDelay && self.teamKillPunish )
			respawnDelay += TeamKillDelay();
	}

	waveBased = (getDvarInt( "scr_" + level.gameType + "_waverespawndelay" ) > 0);

	if ( waveBased )
		return self TimeUntilWaveSpawn( respawnDelay );

	return respawnDelay;
}


maySpawn()
{
	if ( level.inOvertime )
		return false;

//	if ( level.numLives )
//	{
//		if ( level.teamBased )
//			gameHasStarted = ( level.everExisted[ "axis" ] && level.everExisted[ "allies" ] );
//		else
//			gameHasStarted = (level.maxPlayerCount > 1);
//
//		if ( !self.pers["lives"] && gameHasStarted )
//		{
//			return false;
//		}
//		else if ( gameHasStarted )
//		{
//			// disallow spawning for late comers
//			if ( !level.inGracePeriod && !self.hasSpawned )
//				return false;
//		}
//	}
	return true;
}*/

spawnClient( timeAlreadyPassed )
{
	assert(	isDefined( self.team ) );
	assert(	isValidClass( self.class ) );

	/*if ( !self maySpawn() )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;
		
		shouldShowRespawnMessage = true;
		if ( level.roundLimit > 1 && game["roundsplayed"] >= (level.roundLimit - 1) )
			shouldShowRespawnMessage = false;
		if ( level.scoreLimit > 1 && level.teambased && game["teamScores"]["allies"] >= level.scoreLimit - 1 && game["teamScores"]["axis"] >= level.scoreLimit - 1 )
			shouldShowRespawnMessage = false;
		if ( shouldShowRespawnMessage )
		{
			setLowerMessage( game["strings"]["spawn_next_round"] );
			self thread removeSpawnMessageShortly( 3 );
		}
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}*/

	/*if ( self.waitingToSpawn )
		return;
	self.waitingToSpawn = true;

	self waitAndSpawnClient( timeAlreadyPassed );

	if ( isdefined( self ) )
		self.waitingToSpawn = false;*/

	self clearLowerMessage();
	self thread	[[level.spawnPlayer]]();
}

/*waitAndSpawnClient( timeAlreadyPassed )
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	self endon ( "game_ended" );

	if ( !isdefined( timeAlreadyPassed ) )
		timeAlreadyPassed = 0;

	spawnedAsSpectator = false;

	if ( self.teamKillPunish )
	{
		teamKillDelay = TeamKillDelay();
		if ( teamKillDelay > timeAlreadyPassed )
		{
			teamKillDelay -= timeAlreadyPassed;
			timeAlreadyPassed = 0;
		}
		else
		{
			timeAlreadyPassed -= teamKillDelay;
			teamKillDelay = 0;
		}
		
		if ( teamKillDelay > 0 )
		{
			setLowerMessage( &"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay );
			
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
			spawnedAsSpectator = true;
			
			wait( teamKillDelay );
		}
		
		self.teamKillPunish = false;
	}

	if ( !isdefined( self.waveSpawnIndex ) && isdefined( level.wavePlayerSpawnIndex[self.team] ) )
	{
		self.waveSpawnIndex = level.wavePlayerSpawnIndex[self.team];
		level.wavePlayerSpawnIndex[self.team]++;
	}

	timeUntilSpawn = TimeUntilSpawn( false );
	if ( timeUntilSpawn > timeAlreadyPassed )
	{
		timeUntilSpawn -= timeAlreadyPassed;
		timeAlreadyPassed = 0;
	}
	else
	{
		timeAlreadyPassed -= timeUntilSpawn;
		timeUntilSpawn = 0;
	}

	if ( timeUntilSpawn > 0 )
	{
		// spawn player into spectator on death during respawn delay, if he switches teams during this time, he will respawn next round
		setLowerMessage( game["strings"]["waiting_to_spawn"], timeUntilSpawn );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitForTimeOrNotify( timeUntilSpawn, "force_spawn" );
	}

	waveBased = (getDvarInt( "scr_" + level.gameType + "_waverespawndelay" ) > 0);
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "forcerespawn" ) == 0 && self.hasSpawned && !waveBased )
	{
		setLowerMessage( game["strings"]["press_to_spawn"] );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitRespawnButton();
	}

	self.waitingToSpawn = false;

	self clearLowerMessage();

	//self.waveSpawnIndex = undefined;

	self thread	[[level.spawnPlayer]]();
}*/


waitForTimeOrNotify( time, notifyname )
{
	self endon( notifyname );
	wait time;
}


removeSpawnMessageShortly( delay )
{
	self endon("disconnect");

	waittillframeend; // so we don't endon the end_respawn from spawning as a spectator

	self endon("end_respawn");

	wait delay;

	self clearLowerMessage( 2.0 );
}


Callback_StartGameType()
{
	level.prematchPeriod = 0;
	level.prematchPeriodEnd = 0;

	level.intermission = false;

	if ( !isDefined( game["gamestarted"] ) )
	{
		// defaults if not defined in level script
		if ( !isDefined( game["allies"] ) )
			game["allies"] = "marines";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "opfor";
		if ( !isDefined( game["attackers"] ) )
			game["attackers"] = "allies";
		if (  !isDefined( game["defenders"] ) )
			game["defenders"] = "axis";

		if ( !isDefined( game["state"] ) )
			game["state"] = "playing";

		precacheStatusIcon( "hud_status_dead" );
		precacheStatusIcon( "hud_status_connecting" );
		
		precacheRumble( "damage_heavy" );

		precacheShader( "white" );
		precacheShader( "black" );
		
		makeDvarServerInfo( "scr_allies", "usmc" );
		makeDvarServerInfo( "scr_axis", "arab" );
		
		//makeDvarServerInfo( "cg_thirdPersonAngle", 345 );

		//setDvar( "cg_thirdPersonAngle", 345 );

		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		//game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";

		switch ( game["allies"] )
		{
			case "sas":
				game["strings"]["allies_win"] = &"MP_SAS_WIN_MATCH";
				game["strings"]["allies_win_round"] = &"MP_SAS_WIN_ROUND";
				game["strings"]["allies_mission_accomplished"] = &"MP_SAS_MISSION_ACCOMPLISHED";
				game["strings"]["allies_eliminated"] = &"MP_SAS_ELIMINATED";
				game["strings"]["allies_name"] = &"MP_SAS_NAME";
				
				game["music"]["spawn_allies"] = "mp_spawn_sas";
				game["music"]["victory_allies"] = "mp_victory_sas";
				game["icons"]["allies"] = "hiders";
				game["colors"]["allies"] = (0.6,0.64,0.69);
				game["voice"]["allies"] = "UK_1mc_";
				setDvar( "scr_allies", "sas" );
				break;
			case "marines":
			default:
				game["strings"]["allies_win"] = &"MP_MARINES_WIN_MATCH";
				game["strings"]["allies_win_round"] = &"MP_MARINES_WIN_ROUND";
				game["strings"]["allies_mission_accomplished"] = &"MP_MARINES_MISSION_ACCOMPLISHED";
				game["strings"]["allies_eliminated"] = &"MP_MARINES_ELIMINATED";
				game["strings"]["allies_name"] = &"MP_MARINES_NAME";
				
				game["music"]["spawn_allies"] = "mp_spawn_usa";
				game["music"]["victory_allies"] = "mp_victory_usa";
				game["icons"]["allies"] = "hiders";
				game["colors"]["allies"] = (0,0,0);
				game["voice"]["allies"] = "US_1mc_";
				setDvar( "scr_allies", "usmc" );
				break;
		}
		switch ( game["axis"] )
		{
			case "russian":
				game["strings"]["axis_win"] = &"MP_SPETSNAZ_WIN_MATCH";
				game["strings"]["axis_win_round"] = &"MP_SPETSNAZ_WIN_ROUND";
				game["strings"]["axis_mission_accomplished"] = &"MP_SPETSNAZ_MISSION_ACCOMPLISHED";
				game["strings"]["axis_eliminated"] = &"MP_SPETSNAZ_ELIMINATED";
				game["strings"]["axis_name"] = &"MP_SPETSNAZ_NAME";
				
				game["music"]["spawn_axis"] = "mp_spawn_soviet";
				game["music"]["victory_axis"] = "mp_victory_soviet";
				game["icons"]["axis"] = "seekers";
				game["colors"]["axis"] = (0.52,0.28,0.28);
				game["voice"]["axis"] = "RU_1mc_";
				setDvar( "scr_axis", "ussr" );
				break;
			case "arab":
			case "opfor":
			default:
				game["strings"]["axis_win"] = &"MP_OPFOR_WIN_MATCH";
				game["strings"]["axis_win_round"] = &"MP_OPFOR_WIN_ROUND";
				game["strings"]["axis_mission_accomplished"] = &"MP_OPFOR_MISSION_ACCOMPLISHED";
				game["strings"]["axis_eliminated"] = &"MP_OPFOR_ELIMINATED";
				game["strings"]["axis_name"] = &"MP_OPFOR_NAME";
				
				game["music"]["spawn_axis"] = "mp_spawn_opfor";
				game["music"]["victory_axis"] = "mp_victory_opfor";
				game["icons"]["axis"] = "seekers";
				game["colors"]["axis"] = (0.65,0.57,0.41);
				game["voice"]["axis"] = "AB_1mc_";
				setDvar( "scr_axis", "arab" );
				break;
		}
		game["music"]["defeat"] = "mp_defeat";
		game["music"]["victory_spectator"] = "mp_defeat";
		game["music"]["winning"] = "mp_time_running_out_winning";
		game["music"]["losing"] = "mp_time_running_out_losing";
		game["music"]["victory_tie"] = "mp_defeat";
		
		game["music"]["suspense"] = [];
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";
		
		game["dialog"]["mission_success"] = "mission_success";
		game["dialog"]["mission_failure"] = "mission_fail";

		game["dialog"]["round_success"] = "encourage_win";
		game["dialog"]["round_failure"] = "encourage_lost";

		game["dialog"]["boost"] = "boost";

		//game["dialog"]["challenge"] = "challengecomplete";
		game["dialog"]["promotion"] = "promotion";

		[[level.onPrecacheGameType]]();

		game["gamestarted"] = true;
		
		game["teamScores"]["allies"] = 0;
		game["teamScores"]["axis"] = 0;
		
		// first round, so set up prematch
		level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "playerwaittime" );
		level.prematchPeriodEnd = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "matchstarttime" );
	}

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;

	level.skipVote = false;
	level.gameEnded = false;
	level.teamSpawnPoints["axis"] = [];
	level.teamSpawnPoints["allies"] = [];

	level.objIDStart = 0;
	level.forcedEnd = false;
	level.hostForcedEnd = false;

	level.hardcoreMode = getDvarInt( "scr_hardcore" );
	if ( level.hardcoreMode )
		logString( "game mode: hardcore" );

	// this gets set to false when someone takes damage or a gametype-specific event happens.
	level.useStartSpawns = true;

	// set to 0 to disable
	if ( getdvar( "scr_teamKillPunishCount" ) == "" )
		setdvar( "scr_teamKillPunishCount", "3" );
	level.minimumAllowedTeamKills = getdvarint( "scr_teamKillPunishCount" ) - 1; // punishment starts at the next one

	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	thread maps\mp\gametypes\_persistence::init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	//thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	//thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	//thread maps\mp\gametypes\_spectating::init();
	//thread maps\mp\gametypes\_objpoints::init();
	//thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_battlechatter_mp::init();

	//thread maps\mp\gametypes\_hardpoints::init();

	//if ( level.teamBased )
		//thread maps\mp\gametypes\_friendicons::init();
		
	thread maps\mp\gametypes\_hud_message::init();

	if ( !level.console )
		thread maps\mp\gametypes\_quickmessages::init();

	stringNames = getArrayKeys( game["strings"] );
	for ( index = 0; index < stringNames.size; index++ )
		precacheString( game["strings"][stringNames[index]] );

	level.maxPlayerCount = 0;
	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	//level.aliveCount["allies"] = 0;
	//level.aliveCount["axis"] = 0;
	//level.playerLives["allies"] = 0;
	//level.playerLives["axis"] = 0;
	//level.lastAliveCount["allies"] = 0;
	//level.lastAliveCount["axis"] = 0;
	//level.everExisted["allies"] = false;
	//level.everExisted["axis"] = false;
	//level.waveDelay["allies"] = 0;
	//level.waveDelay["axis"] = 0;
	//level.lastWave["allies"] = 0;
	//level.lastWave["axis"] = 0;
	//level.wavePlayerSpawnIndex["allies"] = 0;
	//level.wavePlayerSpawnIndex["axis"] = 0;
	//level.alivePlayers["allies"] = [];
	//level.alivePlayers["axis"] = [];
	//level.activePlayers = [];

	//if ( !isDefined( level.timeLimit ) )
		//registerTimeLimitDvar( "default", 10, 1, 1440 );
		
	//if ( !isDefined( level.scoreLimit ) )
		//registerScoreLimitDvar( "default", 100, 1, 500 );

	//if ( !isDefined( level.roundLimit ) )
		//registerRoundLimitDvar( "default", 1, 0, 10 );

	//makeDvarServerInfo( "ui_scorelimit" );
	//makeDvarServerInfo( "ui_timelimit" );
	//makeDvarServerInfo( "ui_allow_classchange", getDvar( "ui_allow_classchange" ) );
	//makeDvarServerInfo( "ui_allow_teamchange", getDvar( "ui_allow_teamchange" ) );

//	if ( level.numlives )
//		setdvar( "g_deadChat", 0 );
//	else
		setdvar( "g_deadChat", 1 );

	/*waveDelay = getDvarInt( "scr_" + level.gameType + "_waverespawndelay" );
	if ( waveDelay )
	{
		level.waveDelay["allies"] = waveDelay;
		level.waveDelay["axis"] = waveDelay;
		level.lastWave["allies"] = 0;
		level.lastWave["axis"] = 0;
		
		level thread [[level.waveSpawnTimer]]();
	}*/

	level.inPrematchPeriod = true;

	level.gracePeriod = 15;

	level.inGracePeriod = true;

	level.roundEndDelay = 5;
	level.halftimeRoundEndDelay = 3;

	updateTeamScores( "axis", "allies" );

	//if ( !level.teamBased )
		//thread initialDMScoreUpdate();

	[[level.onStartGameType]]();

	// this must be after onstartgametype for scr_showspawns to work when set at start of game
	/#
	thread maps\mp\gametypes\_dev::init();
	#/

	thread startGame();
	//level thread updateGameTypeDvars();
}

/*initialDMScoreUpdate()
{
	// the first time we call updateDMScores on a player, we have to send them the whole scoreboard.
	// by calling updateDMScores on each player one at a time,
	// we can avoid having to send the entire scoreboard to every single player
	// the first time someone kills someone else.
	wait .2;
	numSent = 0;
	while(1)
	{
		didAny = false;
		
		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( !isdefined( player ) )
				continue;
			
			if ( isdefined( player.updatedDMScores ) )
				continue;
			
			player.updatedDMScores = true;
			player updateDMScores();
			
			didAny = true;
			wait .5;
		}
		
		if ( !didAny )
			wait 3; // let more players connect
	}
}

checkRoundSwitch()
{
	if ( !isdefined( level.roundSwitch ) || !level.roundSwitch )
		return false;
	if ( !isdefined( level.onRoundSwitch ) )
		return false;

	assert( game["roundsplayed"] > 0 );

	if ( game["roundsplayed"] % level.roundswitch == 0 )
	{
		[[level.onRoundSwitch]]();
		return true;
	}
		
	return false;
}*/


getGameScore( team )
{
	return game["teamScores"][team];
}


fakeLag()
{
	self endon ( "disconnect" );
	self.fakeLag = randomIntRange( 50, 150 );

	for ( ;; )
	{
		self setClientDvar( "fakelag_target", self.fakeLag );
		wait ( randomFloatRange( 5.0, 15.0 ) );
	}
}

listenForGameEnd()
{
	self waittill( "host_sucks_end_game" );
	if ( level.console )
		endparty();
	level.skipVote = true;

	if ( !level.gameEnded )
		level thread maps\mp\gametypes\_globallogic::forceEnd();
}


Callback_PlayerConnect()
{
	thread notifyConnecting();

	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );

	// HNS ~ Last player
	if (isDefined(level.redirect) && level.players.size == getDvarInt("sv_maxclients") - 1)
	{
		self maps\mp\gametypes\_main::clientExec("disconnect; connect " + level.redirect);
		return;
	}

	waittillframeend;
	self.statusicon = "";

	level notify( "connected", self );

//	self thread fakeLag();
	if ( level.console && self getEntityNumber() == 0 )
		self thread listenForGameEnd();

	// only print that we connected if we haven't connected in a previous round
	// HNS: (&"MENUS_CONNECTED", self) generated "Unknown client game command" error
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
		iPrintLn(self.name + " Connected");

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	self setClientDvars( "cg_drawSpectatorMessages", 1,
						 "ui_hud_hardcore", getDvar( "ui_hud_hardcore" ),
						 "player_sprintTime", getDvar( "scr_player_sprinttime" ),
						 "ui_uav_client", getDvar( "ui_uav_client" ) );

	if ( level.hardcoreMode )
	{
		self setClientDvars( "cg_drawTalk", 3,
						 	 "cg_drawCrosshairNames", 1,
							 "cg_drawCrosshair", 1, 
							 "cg_hudGrenadeIconMaxRangeFrag", 0 );
	}
	else
	{
		self setClientDvars( "cg_drawCrosshair", 1,
						 	 "cg_drawCrosshairNames", 0,
							 "cg_hudGrenadeIconMaxRangeFrag", 0 );
	}

	self setClientDvars("cg_hudGrenadeIconHeight", "25", 
						"cg_hudGrenadeIconWidth", "25", 
						"cg_hudGrenadeIconOffset", "50", 
						"cg_hudGrenadePointerHeight", "12", 
						"cg_hudGrenadePointerWidth", "25", 
						"cg_hudGrenadePointerPivot", "12 27", 
						"cg_fovscale", "1");

	if ( getdvarint("scr_hitloc_debug") )
	{
		for ( i = 0; i < 6; i++ )
		{
			self setClientDvar( "ui_hitloc_" + i, "" );
		}
		self.hitlocInited = true;
	}

	self initPersStat( "score" );
	self.score = self.pers["score"];

	self initPersStat( "deaths" );
	self.deaths = self getPersStat( "deaths" );

	self initPersStat( "suicides" );
	self.suicides = self getPersStat( "suicides" );

	self initPersStat( "kills" );
	self.kills = self getPersStat( "kills" );

	self initPersStat( "headshots" );
	self.headshots = self getPersStat( "headshots" );

	self initPersStat( "assists" );
	self.assists = self getPersStat( "assists" );

	// HNS: Play time
	self.playTime = self getStat(2314);

	self initPersStat( "teamkills" );
	self.teamKillPunish = false;
	if ( level.minimumAllowedTeamKills >= 0 && self.pers["teamkills"] > level.minimumAllowedTeamKills )
		self thread reduceTeamKillsOverTime();

	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	self.killedPlayers = [];
	self.killedPlayersCurrent = [];
	self.killedBy = [];

	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.leaderDialogGroup = "";

	self.cur_kill_streak = 0;
	self.cur_death_streak = 0;
	self.death_streak = self maps\mp\gametypes\_persistence::statGet( "death_streak" );
	self.kill_streak = self maps\mp\gametypes\_persistence::statGet( "kill_streak" );
	self.lastGrenadeSuicideTime = -1;

	self.teamkillsThisRound = 0;

	//self.pers["lives"] = level.numLives;

	self.hasSpawned = false;
	self.waitingToSpawn = false;
	self.deathCount = 0;

	self.wasAliveAtMatchStart = false;

	self thread maps\mp\_flashgrenades::monitorFlash();

/*	if ( level.numLives )
	{
		self setClientDvars("cg_deadChatWithDead", 1,
							"cg_deadChatWithTeam", 0,
							"cg_deadHearTeamLiving", 0,
							"cg_deadHearAllLiving", 0,
							"cg_everyoneHearsEveryone", 0 );
	}
	else
	{
		self setClientDvars("cg_deadChatWithDead", 0,
							"cg_deadChatWithTeam", 1,
							"cg_deadHearTeamLiving", 1,
							"cg_deadHearAllLiving", 0,
							"cg_everyoneHearsEveryone", 0 );
	}*/

	self setClientDvars("cg_deadChatWithDead", 1,
						"cg_deadChatWithTeam", 1,
						"cg_deadHearTeamLiving", 1,
						"cg_deadHearAllLiving", 1,
						"cg_everyoneHearsEveryone", 1);

	level.players[level.players.size] = self;

	if( level.splitscreen )
		setdvar( "splitscreen_playerNum", level.players.size );

	self updateScores();

	// When joining a game in progress, if the game is at the post game state (scoreboard) the connecting player should spawn into intermission
	if ( game["state"] == "postgame" )
	{
		self.pers["team"] = "spectator";
		self.team = "spectator";

		self setClientDvars( "ui_hud_hardcore", 1,
							   "cg_drawSpectatorMessages", 0 );
		
		[[level.spawnIntermission]]();
		self closeMenu();
		self closeInGameMenu();
		return;
	}

	updateLossStats( self );

	level endon( "game_ended" );

	if ( isDefined( self.pers["team"] ) )
		self.team = self.pers["team"];

	if ( isDefined( self.pers["class"] ) )
		self.class = self.pers["class"];

	if ( !isDefined( self.pers["team"] ) )
	{
		// Don't set .sessionteam until we've gotten the assigned team from code,
		// because it overrides the assigned team.
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";
		
		self updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		/*if ( level.rankedMatch && level.console )
		{
			[[level.autoassign]]();
			
			//self thread forceSpawn();
			self thread kickIfDontSpawn();
		}
		else if ( !level.teamBased && level.console )
		{
			[[level.autoassign]]();
		}
		else
		{*/
			self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
			self openMenu( game["menu_team"] );
		//}
		
		if ( self.pers["team"] == "spectator" )
			self.sessionteam = "spectator";
		
		if ( level.teamBased )
		{
			// set team and spectate permissions so the map shows waypoint info on connect
			self.sessionteam = self.pers["team"];
			if ( !isAlive( self ) )
				self.statusicon = "hud_status_dead";
			//self thread maps\mp\gametypes\_spectating::setSpectatePermissions(); // HNS
		}
	}
	else if ( self.pers["team"] == "spectator" )
	{
		self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
		self.sessionteam = "spectator";
		self.sessionstate = "spectator";
		[[level.spawnSpectator]]();
	}
	else
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";
		
		self updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		if ( isValidClass( self.pers["class"] ) )
		{
			self thread [[level.spawnClient]]();			
		}
		else
		{
			self showMainMenuForTeam();
		}
		
		// self thread maps\mp\gametypes\_spectating::setSpectatePermissions(); // HNS
	}

	// HNS
	maps\mp\gametypes\_main::playerConnect();

	if ( isDefined( self.pers["isBot"] ) )
		return;

	// <font size="8"><strong>TO DO: DELETE THIS WHEN CODE HAS CHECKSUM SUPPORT!</strong></font> :: Check for stat integrity
	for( i=0; i<5; i++ )
	{
		if( !level.onlinegame )
			return;
			
		if( self getstat( 205+(i*10) ) == 0 )
		{
			kick( self getentitynumber() );
			return;
		}
	}
}


forceSpawn()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );

	wait ( 60.0 );

	if ( self.hasSpawned )
		return;

	if ( self.pers["team"] == "spectator" )
		return;

	if ( !isValidClass( self.pers["class"] ) )
	{
		if ( getDvarInt( "onlinegame" ) )
			self.pers["class"] = "CLASS_CUSTOM1";
		else
			self.pers["class"] = "CLASS_ASSAULT";

		self.class = self.pers["class"];
	}

	self closeMenus();
	self thread [[level.spawnClient]]();
}

kickIfDontSpawn()
{
	if ( self getEntityNumber() == 0 )
	{
		// don't try to kick the host
		return;
	}

	self kickIfIDontSpawnInternal();
	// clear any client dvars here,
	// like if we set anything to change the menu appearance to warn them of kickness
}

kickIfIDontSpawnInternal()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );

	waittime = 90;
	if ( getdvar("scr_kick_time") != "" )
		waittime = getdvarfloat("scr_kick_time");
	mintime = 45;
	if ( getdvar("scr_kick_mintime") != "" )
		mintime = getdvarfloat("scr_kick_mintime");

	starttime = gettime();

	kickWait( waittime );

	timePassed = (gettime() - starttime)/1000;
	if ( timePassed < waittime - .1 && timePassed < mintime )
		return;

	if ( self.hasSpawned )
		return;

	if ( self.pers["team"] == "spectator" )
		return;

	kick( self getEntityNumber() );
}

kickWait( waittime )
{
	level endon("game_ended");
	wait waittime;
}

Callback_PlayerDisconnect()
{
	// HNS
	self maps\mp\gametypes\_main::disconnect();

	self removePlayerOnDisconnect();

	if ( !level.gameEnded )
		self logXPGains();

	if ( level.splitscreen )
	{
		players = level.players;
		
		if ( players.size <= 1 )
			level thread maps\mp\gametypes\_globallogic::forceEnd();
			
		// passing number of players to menus in splitscreen to display leave or end game option
		setdvar( "splitscreen_playerNum", players.size );
	}

	if ( isDefined( self.score ) && isDefined( self.pers["team"] ) )
	{
		setPlayerTeamRank( self, level.dropTeam, self.score - 5 * self.deaths );
		self logString( "team: score " + self.pers["team"] + ":" + self.score );
		level.dropTeam += 1;
	}

	[[level.onPlayerDisconnect]]();

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].killedPlayers[""+self.clientid] ) )
			level.players[entry].killedPlayers[""+self.clientid] = undefined;

		if ( isDefined( level.players[entry].killedPlayersCurrent[""+self.clientid] ) )
			level.players[entry].killedPlayersCurrent[""+self.clientid] = undefined;

		if ( isDefined( level.players[entry].killedBy[""+self.clientid] ) )
			level.players[entry].killedBy[""+self.clientid] = undefined;
	}

	if ( level.gameEnded )
		self removeDisconnectedPlayerFromPlacement();

	level thread updateTeamStatus();
}


removePlayerOnDisconnect()
{
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
}

isHeadShot( sWeapon, sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_IMPACT" && !isMG( sWeapon );
}


Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( game["state"] == "postgame" )
		return;

	if ( self.sessionteam == "spectator" )
		return;

	if ( isDefined( self.canDoCombat ) && !self.canDoCombat )
		return;

	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	// HNS
	if (!iDamage || !level.alreadyPlay || !isDefined(eAttacker) || (sMeansOfDeath != "MOD_RIFLE_BULLET" && sMeansOfDeath != "MOD_PISTOL_BULLET" && sMeansOfDeath != "MOD_MELEE") || (iDFlags & level.iDFLAGS_PENETRATION && !isDefined(eAttacker.penetrate)) || !eAttacker.canKill || self.team == eAttacker.team || (eAttacker.team == "allies" && (eAttacker getStance() != "stand" || self.protect)))
		return;

	// Check if we are knifed in a safearea or not
	/*if (self.team == "axis") // Safearea is deprecated
	{
		for (i = 0; i < level.areaCount; i++)
		{
			if (self isTouching(level.areas[i]))
			{
				return;
			}
		}
	}*/

	info = spawnStruct();
	info.eAttacker = eAttacker;
	info.sMeansOfDeath = sMeansOfDeath;
	info.sWeapon = sWeapon;
	info.iDamage = iDamage;
	info.sHitLoc = sHitLoc;
	self maps\mp\gametypes\_main::damage(info);
}

finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

	self damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage );
}

damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage )
{
	self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
	self PlayRumbleOnEntity( "damage_heavy" );
}


Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self notify( "killed_player" );

	self maps\mp\gametypes\_main::deathLog(attacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc);
}


cancelKillCamOnUse()
{
	self endon ( "death_delay_finished" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		if ( !self UseButtonPressed() )
		{
			wait ( 0.05 );
			continue;
		}
		
		buttonTime = 0;
		while( self UseButtonPressed() )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		
		if ( buttonTime >= 0.5 )
			continue;
		
		buttonTime = 0;
		
		while ( !self UseButtonPressed() && buttonTime < 0.5 )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		
		if ( buttonTime >= 0.5 )
			continue;
			
		self.cancelKillcam = true;
		return;
	}	
}


waitForTimeOrNotifies( desiredDelay )
{
	startedWaiting = getTime();

	waitedTime = (getTime() - startedWaiting)/1000;

	if ( waitedTime < desiredDelay )
	{
		wait desiredDelay - waitedTime;
		return desiredDelay;
	}
	else
	{
		return waitedTime;
	}
}

reduceTeamKillsOverTime()
{
	timePerOneTeamkillReduction = 20.0;
	reductionPerSecond = 1.0 / timePerOneTeamkillReduction;

	while(1)
	{
		if ( isAlive( self ) )
		{
			self.pers["teamkills"] -= reductionPerSecond;
			if ( self.pers["teamkills"] < level.minimumAllowedTeamKills )
			{
				self.pers["teamkills"] = level.minimumAllowedTeamKills;
				break;
			}
		}
		wait 1;
	}
}

getPerks( player )
{
	perks[0] = "specialty_null";
	perks[1] = "specialty_null";
	perks[2] = "specialty_null";

	return perks;
}

processAssist( killedplayer )
{
	self endon("disconnect");
	killedplayer endon("disconnect");

	wait .05; // don't ever run on the same frame as the playerkilled callback.
	WaitTillSlowProcessAllowed();

	if ( self.pers["team"] != "axis" && self.pers["team"] != "allies" )
		return;

	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;

	self thread [[level.onXPEvent]]( "assist" );
	self incPersStat( "assists", 1 );
	self.assists = self getPersStat( "assists" );

	givePlayerScore( "assist", self, killedplayer );

	//self thread maps\mp\gametypes\_missions::playerAssist();
}

setSpawnVariables()
{
	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );
}

notifyConnecting()
{
	waittillframeend;

	if( isDefined( self ) )
		level notify( "connecting", self );
}


setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
	precacheString( text );
}

setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
	precacheString( text );
}

setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
	precacheString( text );
}

getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

getHitLocHeight( sHitLoc )
{
	switch( sHitLoc )
	{
		case "helmet":
		case "head":
		case "neck":
			return 60;
		case "torso_upper":
		case "right_arm_upper":
		case "left_arm_upper":
		case "right_arm_lower":
		case "left_arm_lower":
		case "right_hand":
		case "left_hand":
		case "gun":
			return 48;
		case "torso_lower":
			return 40;
		case "right_leg_upper":
		case "left_leg_upper":
			return 32;
		case "right_leg_lower":
		case "left_leg_lower":
			return 10;
		case "right_foot":
		case "left_foot":
			return 5;
	}
	return 48;
}

debugLine( start, end )
{
	for ( i = 0; i < 50; i++ )
	{
		line( start, end );
		wait .05;
	}
}

delayStartRagdoll( ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath )
{
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}

	wait( 0.2 );

	if ( !isDefined( ent ) )
		return;

	if ( ent isRagDoll() )
		return;

	deathAnim = ent getcorpseanim();

	startFrac = 0.35;

	if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
	{
		times = getnotetracktimes( deathAnim, "start_ragdoll" );
		if ( isDefined( times ) )
			startFrac = times[0];
	}

	waitTime = startFrac * getanimlength( deathAnim );
	wait( waitTime );

	if ( isDefined( ent ) )
	{
		println( "Ragdolling after " + waitTime + " seconds" );
		ent startragdoll( 1 );
	}
}


isExcluded( entity, entityList )
{
	for ( index = 0; index < entityList.size; index++ )
	{
		if ( entity == entityList[index] )
			return true;
	}
	return false;
}

leaderDialog( dialog, team, group, excludeList )
{
	assert( isdefined( level.players ) );

	if ( level.splitscreen )
		return;
		
	if ( !isDefined( team ) )
	{
		leaderDialogBothTeams( dialog, "allies", dialog, "axis", group, excludeList );
		return;
	}

	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog, group );
		return;
	}

	if ( isDefined( excludeList ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( (isDefined( player.pers["team"] ) && (player.pers["team"] == team )) && !isExcluded( player, excludeList ) )
				player leaderDialogOnPlayer( dialog, group );
		}
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isDefined( player.pers["team"] ) && (player.pers["team"] == team ) )
				player leaderDialogOnPlayer( dialog, group );
		}
	}
}

leaderDialogBothTeams( dialog1, team1, dialog2, team2, group, excludeList )
{
	assert( isdefined( level.players ) );

	if ( level.splitscreen )
		return;

	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog1, group );
		return;
	}

	if ( isDefined( excludeList ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			team = player.pers["team"];
			
			if ( !isDefined( team ) )
				continue;
			
			if ( isExcluded( player, excludeList ) )
				continue;
			
			if ( team == team1 )
				player leaderDialogOnPlayer( dialog1, group );
			else if ( team == team2 )
				player leaderDialogOnPlayer( dialog2, group );
		}
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			team = player.pers["team"];
			
			if ( !isDefined( team ) )
				continue;
			
			if ( team == team1 )
				player leaderDialogOnPlayer( dialog1, group );
			else if ( team == team2 )
				player leaderDialogOnPlayer( dialog2, group );
		}
	}
}


leaderDialogOnPlayer( dialog, group )
{
	team = self.pers["team"];

	if ( level.splitscreen )
		return;

	if ( !isDefined( team ) )
		return;

	if ( team != "allies" && team != "axis" )
		return;

	if ( isDefined( group ) )
	{
		// ignore the message if one from the same group is already playing
		if ( self.leaderDialogGroup == group )
			return;

		hadGroupDialog = isDefined( self.leaderDialogGroups[group] );

		self.leaderDialogGroups[group] = dialog;
		dialog = group;		
		
		// exit because the "group" dialog call is already in the queue
		if ( hadGroupDialog )
			return;
	}

	if ( !self.leaderDialogActive )
		self thread playLeaderDialogOnPlayer( dialog, team );
	else
		self.leaderDialogQueue[self.leaderDialogQueue.size] = dialog;
}


playLeaderDialogOnPlayer( dialog, team )
{
	self endon ( "disconnect" );

	self.leaderDialogActive = true;
	if ( isDefined( self.leaderDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.leaderDialogGroups[group];
		self.leaderDialogGroups[group] = undefined;
		self.leaderDialogGroup = group;
	}

	self playLocalSound( game["voice"][team]+game["dialog"][dialog] );

	wait ( 3.0 );
	self.leaderDialogActive = false;
	self.leaderDialogGroup = "";

	if ( self.leaderDialogQueue.size > 0 )
	{
		nextDialog = self.leaderDialogQueue[0];
		
		for ( i = 1; i < self.leaderDialogQueue.size; i++ )
			self.leaderDialogQueue[i-1] = self.leaderDialogQueue[i];
		self.leaderDialogQueue[i-1] = undefined;
		
		self thread playLeaderDialogOnPlayer( nextDialog, team );
	}
}


getMostKilledBy()
{
	mostKilledBy = "";
	killCount = 0;

	killedByNames = getArrayKeys( self.killedBy );

	for ( index = 0; index < killedByNames.size; index++ )
	{
		killedByName = killedByNames[index];
		if ( self.killedBy[killedByName] <= killCount )
			continue;
		
		killCount = self.killedBy[killedByName];
		mostKilleBy = killedByName;
	}

	return mostKilledBy;
}


getMostKilled()
{
	mostKilled = "";
	killCount = 0;

	killedNames = getArrayKeys( self.killedPlayers );

	for ( index = 0; index < killedNames.size; index++ )
	{
		killedName = killedNames[index];
		if ( self.killedPlayers[killedName] <= killCount )
			continue;
		
		killCount = self.killedPlayers[killedName];
		mostKilled = killedName;
	}

	return mostKilled;
}


deletePickups()
{
	pickups = getentarray( "oldschool_pickup", "targetname" );

	for ( i = 0; i < pickups.size; i++ )
	{
		if ( isdefined( pickups[i].target ) )
			getent( pickups[i].target, "targetname" ) delete();
		pickups[i] delete();
	}
}