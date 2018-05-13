///////////////////////////////
// IT IS TOTALLY USELESS !!! //
// BAD CODING, SORRY !!!!!!! //
///////////////////////////////

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	// Should NOT be in config file
	level.timelimit = 0;
	//maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 0, 0, 0 );
	//maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 1, 1 );
	//maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 0 );

	// HNS
	//maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 3, 1, 20 );
	//maps\mp\gametypes\_globallogic::registerHideTimeDvar( level.gameType, 60, 1, 600 );

	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
}

onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_WAR" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_WAR" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_WAR_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_WAR_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "hns";

	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
}

onSpawnPlayer()
{
	if ( level.inGracePeriod )
	{
		spawnPoints = getentarray("mp_tdm_spawn_" + self.pers["team"] + "_start", "classname");
		
		if ( !spawnPoints.size )
			spawnPoints = getentarray("mp_sab_spawn_" + self.pers["team"] + "_start", "classname");
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}

	self spawn( spawnPoint.origin, spawnPoint.angles );
}


onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}