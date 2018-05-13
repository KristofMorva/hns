echoNextMap(map)
{
	level.players[randomInt(level.players.size)] sayAll("^3Next map: ^2" + map);
}

getVoteMaps()
{
	maps\mp\gametypes\_main::getVoteMapsRandom();
}

handleVoteResult() { }

isFriendlyBlock()
{
	return true;
}

checkProtected()
{
	return true;
}