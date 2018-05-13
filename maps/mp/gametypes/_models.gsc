addObj(s)
{
	level.models[level.models.size] = s;
	level.hasModel[s] = true;
	preCacheModel(s);
}