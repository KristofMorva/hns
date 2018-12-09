///////////////////////////////////////////////////////////
//            HNS Mod - Morva 'iCore' Kristóf            //
//                moddb.com/members/icore                //
//    Using without permission is strictly forbidden!    //
//     Data stealing is rated as a criminal offence!     //
///////////////////////////////////////////////////////////

// PROBABLY FREE STATS IF NEEDED: 2300, 2328-2349 (3158-3165 are also, but those can be also non-0, & 2000, 2001, 2002)
// ALSO MANY MORE FREE BEFORE 2000 (0-255 values)!!!

// NOTE: The code of this mod is really unoptimized, ugly, and sometimes buggy, since it's my first mod. Sorry.
// If you find a bug, or you have fixed something, please contact me so it can be included in the next version!

#include maps\mp\gametypes\_models;

startMap()
{
	// Restriction
	if (getDvar("fs_game") != "mods/hns")
		error("fs_game must be mods/hns!");

	// Team textures
	preCacheShader("hiders");
	preCacheShader("seekers");

	// Items
	preCacheItem("radar_mp");
	preCacheItem("airstrike_mp");

	// Schnappi HUD Image
	preCacheShader("schnappi");

	// Knife HUD Image
	preCacheShader("waypoint_knife");

	// Fade
	preCacheShader("$black");

	// Spawn protect HUD Image
	preCacheShader("protect");

	// Clock HUD Image
	preCacheShader("hudstopwatch");

	// Shell shock
	preCacheShellShock("poison");

	// Status Icons
	preCacheStatusIcon("hud_status_pro");
	preCacheStatusIcon("hud_status_vip");
	preCacheStatusIcon("hud_status_provip");
	preCacheStatusIcon("hud_status_ready");
	preCacheStatusIcon("hud_status_unready");

	// Head icons
	preCacheHeadIcon("schnappi_head");
	preCacheHeadIcon("protect_head");

	// Care package
	preCacheShader("waypoint_hider");
	preCacheShader("waypoint_seeker");
	preCacheModel("vehicle_mig29_desert");
	preCacheModel("com_plasticcase_black_big");

	// Precache attachments ~ should check if belonging model is on the map
	preCacheModel("com_trashcan_metallid");
	preCacheModel("com_pan_metal");
	preCacheModel("com_pan_copper");
	preCacheModel("com_trashbag1_black");
	preCacheModel("com_red_toolbox");
	preCacheModel("com_paintcan");
	preCacheModel("com_propane_tank");
	preCacheModel("me_plastic_crate5");
	preCacheModel("com_plastic_bucket");
	preCacheModel("com_cardboardboxshortclosed_2");
	//preCacheModel("com_cardboardbox_decal");
	preCacheModel("com_junktire");

	// It's an ugly way to define these
	if (level.script == "mp_countdown")
	{
		preCacheModel("projectile_sa6_missile_woodland");
	}
	// These are only for round TV table, and these are not in mod.ff, only in the ff of the map (except com_tv1_testpattern, Vacant doesn't have that).
	else if (level.script == "mp_broadcast" || level.script == "mp_vacant")
	{
		if (level.script == "mp_broadcast")
		{
			//preCacheModel("com_tv1_testpattern");
			preCacheModel("com_tv1_d");
			preCacheModel("com_tv1_screen");
		}

		preCacheModel("com_widescreen_monitor");
		preCacheModel("com_computer_keyboard");
		preCacheModel("com_computer_case");
	}
	// Needed for Wooden table as an attachment
	else if (level.script == "mp_cluster")
	{
		preCacheModel("com_cardboardbox01");
	}
	else if (level.script == "mp_crossfire")
	{
		preCacheModel("com_steel_ladder");
	}

	// Enable melons
	level.melons = !getDvarInt("scr_hns_nomelons");

	// Fake player model
	preCacheModel("fake");

	// Dog
	preCacheModel("german_sheperd_dog");
	preCacheModel("viewhands_dog");
	preCacheItem("helicopter_mp");
	preCacheItem("briefcase_bomb_mp");

	// Effects
	if (level.melons)
		level.fallFX = loadFX("hns/fall"); // Watermelons at map-end

	level.dustFX = loadFX("hns/dust"); // Map-end
	level.rainFX = loadFX("hns/rain"); // With lvl 113
	level.rain2FX = loadFX("hns/rain2"); // With lvl 114
	level.rain3FX = loadFX("hns/rain3"); // With lvl 115
	level.rain4FX = loadFX("hns/rain4"); // With lvl 116
	level.moneyFX = loadFX("misc/light_glow_white"); // Player killed reward
	level.count5FX = loadFX("hns/count5"); // Count back #5
	level.count4FX = loadFX("hns/count4"); // Count back #4
	level.count3FX = loadFX("hns/count3"); // Count back #3
	level.count2FX = loadFX("hns/count2"); // Count back #2
	level.count1FX = loadFX("hns/count1"); // Count back #1
	level.teleFX = loadFX("explosions/flashbang"); // Teleport
	level.rayFX = loadFX("hns/ray"); // Area ray

	// Lights
	level.lightFX = [];
	level.lightFX["white"]["small"] = loadFX("hns/light_white");
	level.lightFX["white"]["big"] = loadFX("hns/light_white_big");
	level.lightFX["yellow"]["small"] = loadFX("hns/light_yellow");
	level.lightFX["yellow"]["big"] = loadFX("hns/light_yellow_big");

	// Death effects
	level.deathFX = [];
	level.deathFX[0] = loadFX("misc/flare_end");
	level.deathFX[1] = loadFX("props/crateExp_dust");
	level.deathFX[2] = loadFX("explosions/grenadeExp_blacktop");
	level.deathFX[3] = loadFX("hns/flower");
	level.deathFX[4] = loadFX("hns/money");
	level.deathFX[5] = loadFX("hns/bear");

	// Define small maps for voting
	level.smallMap["mp_shipment"] = true;
	level.smallMap["mp_killhouse"] = true;

	// Enemy teams
	level.enemyTeam["allies"] = "axis";
	level.enemyTeam["axis"] = "allies";

	// Set default variables - many of this wouldn't be required if the mod didn't use default scripts
	setDvar("sv_floodProtect", 1);
	setDvar("sv_maxRate", 25000);
	setDvar("sv_pure", 1);
	setDvar("g_antilag", 1);
	setDvar("sv_allowAnonymous", 0);
	setDvar("class_assault_limit", 64);
	setDvar("class_sniper_limit", 64);
	setDvar("class_assault_allowdrop", 0);
	setDvar("class_sniper_allowdrop", 0);
	setDvar("scr_enable_nightvision", 0);
	setDvar("scr_enable_music", 1);
	setDvar("scr_enable_hiticon", 0);
	setDvar("scr_game_allowkillcam", 0);
	setDvar("scr_game_hardpoints", 0);
	setDvar("scr_intermission_time", 15);
	setDvar("scr_team_fftype", 0);
	setDvar("ui_hud_obituaries", 1);
	setDvar("ui_hud_showobjicons", 1);
	setDvar("scr_teambalance", 0);
	setDvar("g_allowvote", 0);
	setDvar("scr_game_playerwaittime", 0);
	setDvar("scr_game_matchstarttime", 0);
	setDvar("sv_reconnectlimit", 3);
	//setDvar("scr_game_spectatetype", 1);

	level.guidlength = getDvarInt("scr_hns_guidlength");
	if (level.guidlength < 4 || level.guidlength > 24)
	{
		logPrint("HNS warning: scr_hns_guidlength must be between 4 and 24! Set to default: 4");
		level.guidlength = 4;
	}

	// Array for models
	level.models = [];

	// Plugin
	maps\_hns::main();

	// Money
	//preCacheModel("com_golden_brick");

	// Kill streaks
	/*game["dialog"]["radar_mp"] = "uavrecon";
	game["dialog"]["airstrike_mp"] = "airstrike";*/

	if (getDvar("scr_hns_model1_" + level.script) != "")
	{
		i = 1;
		while (true)
		{
			d = getDvar("scr_hns_model" + i + "_" + level.script);
			if (d != "")
				addObj(d);
			else
				break;

			i++;
		}
	}
	else
	{
		switch (level.script)
		{
			case "mp_backlot":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_barrel_white_rust");
				addObj("com_barrel_blue_rust");
				addObj("bc_hesco_barrier_med");
				addObj("ch_bedframemetal_gray");
				addObj("com_bike");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_bulldozer");
				addObj("com_cafe_table2");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_furniture_couch01");
				addObj("ch_dinerboothchair");
				addObj("ch_dinercounterchair");
				addObj("ch_dinerboothtable");
				addObj("com_dresser_d");
				addObj("me_dumpster_close");
				addObj("com_folding_chair");
				addObj("me_gas_pump");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_3_static");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator2");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("me_streetlight");
				addObj("com_trashcan_metal");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("me_market_umbrella_6");
				addObj("ch_washer_01");
				addObj("com_wheelbarrow");
				addObj("com_cafe_chair");
			break;
			case "mp_bog":
				addObj("me_ac_big");
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_fire");
				addObj("com_barrel_green");
				addObj("com_barrel_white_rust");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_bulldozer");
				addObj("com_cafe_table1");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("me_concrete_barrier");
				addObj("cargocontainer_20ft_red");
				addObj("ch_crate48x64");
				addObj("ch_dinercounterchair");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("me_market_stand4");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_1_static");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantsink_1comp");
				addObj("com_restaurantstove");
				addObj("me_streetlight_on");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("ch_washer_01");
				addObj("bc_militarytent_wood_table");
				addObj("com_wagon_donkey");
				addObj("com_cafe_chair");
			break;
			case "mp_farm":
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("ch_bedframemetal_gray");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_bulldozer");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("ch_furniture_couch02");
				addObj("ch_crate64x64");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("ch_hayroll_03");
				addObj("com_lamp_ornate_on");
				addObj("ch_lawnmower");
				addObj("ch_mattress_3");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("bc_militarytent_wood_table");
				addObj("com_powerpole1");
				addObj("com_propane_tank02");
				addObj("com_restaurantsink_2comps");
				addObj("com_stove_d");
				addObj("me_streetlight");
				addObj("vehicle_tractor_2");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("foliage_dead_pine_med");
				addObj("com_tv2");
				addObj("ch_washer_01");
				addObj("com_wheelbarrow");
				addObj("com_woodlog_24_192_d");
				addObj("com_cafe_chair");
			break;
			case "mp_killhouse":
				addObj("me_ac_big");
				addObj("ch_snack_machine_big_russia");
				addObj("com_barrel_green_dirt");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("ch_furniture_couch01");
				addObj("ch_crate48x64");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("me_dumpster_close");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("com_pallet_stack");
				addObj("com_powerpole1");
				addObj("com_plasticcase_beige_big");
				addObj("mil_sandbag_desert_long");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_trashcan_metal_with_trash");
				addObj("bc_militarytent_wood_table");
				addObj("foliage_red_pine_lg");
			break;
			case "mp_overgrown":
				addObj("com_armoire_d");
				addObj("com_barrel_white_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_fire");
				addObj("com_bomb_objective");
				addObj("com_bookshelveswide");
				addObj("com_barrier_tall1");
				addObj("ch_furniture_couch02");
				addObj("ch_furniture_couch01");
				addObj("ch_crate48x64");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_dresser_d");
				addObj("me_dumpster_close");
				addObj("me_gas_pump");
				addObj("ch_hayroll_02");
				addObj("ch_street_light_01_off");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator_d");
				addObj("prop_misc_rock_boulder_04");
				addObj("ch_russian_table");
				addObj("mil_sandbag_desert_long");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_1comp");
				addObj("com_stove_d");
				addObj("vehicle_bmp_dsty_static");
				addObj("vehicle_tanker_truck_d");
				addObj("vehicle_tractor");
				addObj("com_powerpole1");
				addObj("vehicle_uaz_hardtop_dsr");
				addObj("foliage_tree_river_birch_lg_a");
				addObj("com_woodlog_24_192_d");
				addObj("com_cafe_chair");
				addObj("com_ladder_wood");
			break;
			case "mp_pipeline":
				addObj("me_ac_big");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green_dirt");
				addObj("com_barrel_white_rust");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_bulldozer");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_delivery_truck");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("me_concrete_barrier");
				addObj("cargocontainer_20ft_red");
				addObj("ch_crate48x64");
				addObj("ch_furniture_teachers_desk1");
				addObj("me_dumpster_close");
				addObj("com_electrical_transformer");
				addObj("com_filecabinetblackclosed");
				addObj("com_folding_table");
				addObj("ch_gas_pump");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("com_propane_tank02");
				addObj("me_refrigerator");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("me_streetlight");
				addObj("com_powerpole1");
				addObj("foliage_tree_grey_oak_lg_a");
				addObj("com_ladder_wood");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_shipment":
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green_rust");
				addObj("com_barrel_biohazard_rust");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("cargocontainer_20ft_red");
				addObj("ch_crate32x48");
				addObj("vehicle_delivery_truck");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("me_corrugated_metal8x8");
				addObj("me_streetlight");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_showdown":
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("me_basket_rattan01");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_bulldozer");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("me_construction_dumpster_open");
				addObj("ch_crate64x64");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_1_static");
				addObj("com_plasticcase_beige_big");
				addObj("me_telegraphpole");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("com_tv2");
				addObj("com_wagon_donkey");
				addObj("com_wheelbarrow");
			break;
			case "mp_strike":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("bc_hesco_barrier_med");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("cargocontainer_20ft_red");
				addObj("ch_furniture_couch01");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("com_folding_table");
				addObj("ch_gas_pump");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_2");
				addObj("me_phonebooth");
				addObj("com_plasticcase_beige_big");
				addObj("me_basket_wicker05");
				addObj("me_refrigerator");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_2comps");
				addObj("com_restaurantstovewithburner");
				addObj("me_streetlightdual");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("ch_washer_01");
				addObj("com_cafe_chair");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_vacant":
				addObj("me_ac_big");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("mil_bunker_bed3");
				addObj("com_bench");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_80s_sedan1_brn");
				addObj("me_concrete_barrier");
				addObj("com_conference_table1");
				addObj("cargocontainer_20ft_red");
				addObj("ch_furniture_couch01");
				addObj("ch_crate48x64");
				addObj("vehicle_delivery_truck");
				addObj("ch_furniture_teachers_desk1");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("ch_furniture_school_lunch_table");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("com_filecabinetblackclosed");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("com_photocopier");
				addObj("com_plasticcase_beige_big");
				addObj("com_propane_tank02");
				addObj("me_refrigerator");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_stove");
				addObj("me_streetlight");
				addObj("me_telegraphpole");
				addObj("vehicle_tanker_truck_d");
				addObj("com_trashcan_metal_with_trash");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("foliage_dead_pine_sm");
				addObj("com_tv2");
				addObj("tvs_cubicle_round_1");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_crash":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green");
				addObj("com_barrel_white_rust");
				addObj("bc_hesco_barrier_med");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("vehicle_pickup_technical_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("me_dumpster_close");
				addObj("com_dresser_d");
				addObj("com_restaurantchair_2");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_3_static");
				addObj("com_plasticcase_beige_big");
				addObj("me_phonebooth");
				addObj("me_refrigerator");
				addObj("com_restaurantkitchentable_1");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantstovewithburner");
				addObj("me_streetlight");
				addObj("bc_militarytent_wood_table");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("com_tv2");
				addObj("me_market_umbrella_3");
				addObj("com_cafe_chair");
			break;
			case "mp_crash_snow":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green");
				addObj("com_barrel_white_rust");
				addObj("bc_hesco_barrier_med");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("candy_cane");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("vehicle_pickup_technical_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("me_dumpster_close");
				addObj("com_dresser_d");
				addObj("com_restaurantchair_2");
				addObj("giftbox_01");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("me_phonebooth");
				addObj("me_refrigerator");
				addObj("com_restaurantkitchentable_1");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("snowman");
				addObj("com_restaurantstovewithburner");
				addObj("me_streetlight");
				addObj("bc_militarytent_wood_table");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("snow_tree_lights01");
				addObj("com_tv2");
				addObj("me_market_umbrella_3");
				addObj("com_cafe_chair");
			break;
			case "mp_broadcast":
				addObj("com_northafrica_armoire_short");
				addObj("com_barrel_white_rust");
				addObj("com_water_heater");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("com_conference_table1");
				addObj("ch_furniture_couch01");
				addObj("me_dumpster_close");
				addObj("com_folding_chair");
				addObj("com_filecabinetblackclosed");
				addObj("com_stepladder_large");
				addObj("com_lamp_ornate_on");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_2");
				addObj("com_photocopier");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("me_satellitedish");
				addObj("com_server_rack_sid");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_stove");
				addObj("me_streetlightdual");
				addObj("vehicle_tanker_truck_d");
				addObj("bathroom_toilet");
				addObj("com_trashcan_metal");
				addObj("com_trashcan");
				addObj("foliage_tree_river_birch_lg_a");
				addObj("com_tv2");
				addObj("tvs_cubicle_round_1");
				addObj("com_ladder_wood");
				addObj("com_cafe_chair");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_bloc":
				addObj("com_armoire_d");
				addObj("com_bomb_objective");
				addObj("ch_baby_carriage");
				addObj("com_barrel_fire");
				addObj("com_barrel_white_rust");
				addObj("ch_bedframemetal_gray");
				addObj("com_bench");
				addObj("com_metalbench");
				addObj("com_bookshelves1_d");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("com_plainchair");
				addObj("me_concrete_barrier");
				addObj("com_barrier_tall1");
				addObj("ch_furniture_couch01");
				addObj("ch_crate48x64");
				addObj("com_dresser_d");
				addObj("com_folding_table");
				addObj("com_restaurantchair_2");
				addObj("ch_mattress_3");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("com_playpen");
				addObj("me_refrigerator");
				addObj("me_refrigerator_d");
				addObj("prop_misc_rock_boulder_snow_05");
				addObj("ch_russian_table");
				addObj("mil_sandbag_desert_long");
				addObj("com_stove");
				addObj("me_streetlight");
				addObj("foliage_red_pine_lg");
				addObj("com_cafe_chair");
			break;
			case "mp_cargoship":
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("mil_bunker_bed2");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("cargocontainer_20ft_red");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("com_restaurantchair_2");
				addObj("cs_monitor1");
				addObj("com_pallet_stack");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_2comps");
				addObj("cs_tow_hook");
				addObj("vehicle_uaz_hardtop");
				addObj("com_tv1");
			break;
			case "mp_countdown":
				addObj("me_ac_big");
				addObj("vehicle_sa6_static_woodland");
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green_rust");
				addObj("com_barrel_white_rust");
				addObj("com_bomb_objective");
				addObj("vehicle_pickup_technical_destroyed");
				addObj("com_barrier_tall1");
				addObj("me_construction_dumpster_close");
				addObj("cargocontainer_20ft_red");
				addObj("ch_crate64x64");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("mil_sandbag_desert_long");
				addObj("com_restaurantstainlessteelshelf_01");
				addObj("vehicle_tanker_truck");
			break;
			case "mp_citystreets":
				addObj("me_ac_window");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("ch_bedframemetal_gray");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("me_wood_cage_large");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_crate32x48");
				addObj("vehicle_delivery_truck");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("me_dumpster_close");
				addObj("me_gas_pump");
				addObj("com_mannequin3");
				addObj("ch_mattress_3");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_1");
				addObj("com_plasticcase_beige_big");
				addObj("me_basket_wicker05");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_2comps");
				addObj("com_restaurantstovewithburner");
				addObj("me_streetlight");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("me_market_umbrella_5");
				addObj("com_wagon_donkey_nohandle");
				addObj("com_cafe_chair");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_convoy":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_northafrica_armoire_short");
				addObj("com_barrel_white_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_fire");
				addObj("com_bomb_objective");
				addObj("vehicle_bulldozer");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_table2");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("me_dumpster_close");
				addObj("vehicle_humvee_camo_static");
				addObj("com_lamp_ornate_on");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_1");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_stove");
				addObj("me_telegraphpole2");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("foliage_dead_pine_sm");
				addObj("vehicle_uaz_light_dsr");
				addObj("com_cafe_chair");
				addObj("com_ladder_wood");
			break;
			case "mp_carentan":
				addObj("me_ac_big");
				addObj("com_barrel_tan_rust");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_table2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch01");
				addObj("vehicle_delivery_truck");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("com_restaurantchair_2");
				addObj("ct_street_lamp_on");
				addObj("ct_statue_chinese_lion");
				addObj("com_pallet_stack");
				addObj("com_plasticcase_beige_big");
				addObj("me_refrigerator2");
				addObj("com_restaurantstainlessteelshelf_01");
				addObj("com_stove");
				addObj("me_telegraphpole2");
				addObj("com_restaurantsink_2comps");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("com_tv2");
				addObj("ct_china_vase");
				addObj("ch_washer_01");
			break;
			case "mp_creek":
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_white_rust");
				addObj("ch_bedframemetal_gray");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cafe_table1");
				addObj("vehicle_80s_sedan1_brn");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_crate48x64");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("ch_gas_pump");
				addObj("com_pallet_stack");
				addObj("me_refrigerator");
				addObj("me_refrigerator_d");
				addObj("ch_russian_table");
				addObj("mil_sandbag_desert_long");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_1comp");
				addObj("com_stove");
				addObj("me_streetlight");
				addObj("vehicle_bmp_woodland_dsty_static");
				addObj("com_plasticcase_beige_big");
				addObj("me_telegraphpole2");
				addObj("com_propane_tank02");
				addObj("vehicle_tractor");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("foliage_dead_pine_xl");
				addObj("vehicle_uaz_hardtop_dsr");
				addObj("ch_washer_01");
				addObj("com_wheelbarrow");
				addObj("com_ladder_wood");
				addObj("com_walltable2");
			break;
			case "mp_crossfire":
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("bc_hesco_barrier_med");
				addObj("me_basket_rattan01");
				addObj("ch_bedframemetal_gray");
				addObj("com_bike");
				addObj("com_water_heater");
				addObj("com_bomb_objective");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table2");
				addObj("com_cafe_table1");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("ch_furniture_couch02");
				addObj("ch_furniture_couch01");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("ch_mattress_3");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_1");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("ch_russian_table");
				addObj("me_satellitedish");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantstovewithburner");
				addObj("me_streetlight");
				addObj("me_telegraphpole");
				addObj("com_restaurantsink_2comps");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("com_tv2");
				addObj("ch_washer_01");
				addObj("com_cafe_chair");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_cluster":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_barrel_white_rust");
				addObj("com_barrel_black_rust");
				addObj("bc_hesco_barrier_med");
				addObj("com_bike");
				addObj("com_water_heater");
				addObj("com_cafe_table2");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("com_dresser_d");
				addObj("me_dumpster_close");
				addObj("com_folding_table");
				addObj("ch_gas_pump");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_2");
				addObj("me_basket_rattan01");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("mil_sandbag_desert_long");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_2comps");
				addObj("me_telegraphpole");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("foliage_tree_river_birch_xl_a");
				addObj("ch_washer_01");
				addObj("com_cafe_chair");
				addObj("bc_militarytent_wood_table");
			break;
			case "mp_backyard":
				addObj("me_ac_big");
				addObj("me_ac_window");
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_green_rust");
				addObj("bc_hesco_barrier_med");
				addObj("mil_bunker_bed1");
				addObj("com_bookshelves1_d");
				addObj("com_cafe_table1");
				addObj("vehicle_80s_sedan1_brn");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("com_cafe_chair2");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_furniture_couch01");
				addObj("ch_crate64x64");
				addObj("ch_furniture_teachers_desk1");
				addObj("ch_dinercounterchair");
				addObj("ch_dinerboothchair");
				addObj("ch_dinerboothtable");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("com_filecabinetblackclosed");
				addObj("com_folding_chair");
				addObj("com_folding_table");
				addObj("com_lamp_ornate_on");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				//addObj("mil_sandbag_desert_curved");
				addObj("me_satellitedish");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_2comps");
				addObj("com_stove");
				addObj("bathroom_toilet");
				addObj("foliage_dead_pine_med");
				addObj("com_ladder_wood");
			break;
			case "mp_fav":
				addObj("me_ac_big");
				addObj("com_barrel_black_rust");
				addObj("com_barrel_blue_rust");
				addObj("com_barrel_fire");
				addObj("com_barrel_green_rust");
				addObj("com_barrel_white_rust");
				addObj("com_metalbench");
				addObj("com_bike");
				addObj("com_water_heater");
				addObj("com_cardboardbox01");
				addObj("com_cafe_table1");
				addObj("vehicle_small_hatchback_blue_static");
				addObj("vehicle_small_wagon_d_white");
				addObj("me_concrete_barrier");
				addObj("ch_furniture_couch02");
				addObj("ch_furniture_couch01");
				addObj("ch_crate32x48");
				addObj("ch_dinercounterchair");
				addObj("com_dresser");
				addObj("me_dumpster_close");
				addObj("me_dumpster");
				addObj("com_folding_chair");
				addObj("com_restaurantchair_2");
				addObj("ch_mattress_2");
				addObj("com_pallet_stack");
				addObj("foliage_tree_palm_bushy_3");
				addObj("me_refrigerator");
				addObj("me_refrigerator2");
				addObj("me_corrugated_metal8x8");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("com_restaurantsink_1comp");
				addObj("com_stove");
				addObj("me_streetlight");
				addObj("com_powerpole3");
				addObj("bathroom_toilet");
				addObj("com_trashcan_metal");
				addObj("com_trashcan_metal_with_trash");
				addObj("foliage_tree_grey_oak_sm_a");
				addObj("com_tv1");
				addObj("ch_washer_01");
				addObj("com_cafe_chair");
				addObj("com_ladder_wood");
				addObj("bc_militarytent_wood_table");
			break;
			// By Haris
			case "mp_uprise":
				addObj("me_dumpster_close");
				addObj("me_satellitedish");
				addObj("com_metalbench");
				addObj("me_ac_big");
				addObj("ch_washer_01");
				addObj("ap_couch01");
				addObj("com_steel_ladder");
				addObj("com_pallet_stack");
				addObj("com_barrel_white_rust");
				addObj("ch_furniture_couch01");
				addObj("com_folding_table");
				addObj("com_folding_chai");
				addObj("com_tv2");
				addObj("com_restaurantchair_2");
				addObj("ch_furniture_teachers_desk1");
				addObj("me_concrete_barrier");
				addObj("vehicle_80s_hatch1_brn_destroyed");
				addObj("vehicle_80s_sedan1_silv");
				addObj("me_corrugated_metal8x8");
				addObj("com_cafe_chair");
				addObj("com_restaurantstainlessteelshelf_02");
				addObj("mil_sandbag_desert_long");
				addObj("me_telegraphpole");
				addObj("com_newspaperbox_red");
				addObj("com_newspaperbox_blue");
				addObj("com_dresser");
				addObj("com_ladder_wood");
				addObj("ch_furniture_couch02");
				addObj("ch_crate32x48");
				addObj("com_stove");
				addObj("me_refrigerator");
				addObj("com_trashcan_metal_with_trash");
				addObj("com_trashcan_metal");
				addObj("com_tv1");
				addObj("com_dresser_d");
				addObj("com_water_heater");
				addObj("com_shopping_cart");
				addObj("com_cardboardbox01");
				addObj("com_plasticcase_beige_big");
				addObj("com_bomb_objective");
				addObj("me_antenna");
				addObj("me_market_umbrella_6");
				addObj("ch_mattress_2");
				addObj("me_streetlight");
				addObj("ch_bedframemetal_gray");
			break;
			/*case "mp_hns_impact":
				level.models[0] = "me_ac_window";
				level.models[1] = "com_barrel_black_rust";
				level.models[2] = "ch_bedframemetal_gray";
				level.models[3] = "com_metalbench";
				level.models[4] = "com_water_heater";
				level.models[5] = "com_cardboardbox01";
				level.models[6] = "vehicle_80s_sedan1_brn";
				level.models[7] = "ch_furniture_couch02";
				level.models[8] = "ch_crate64x64";
				level.models[9] = "vehicle_delivery_truck";
				level.models[10] = "vehicle_80s_hatch1_brn_destroyed";
				level.models[11] = "ch_furniture_school_lunch_table";
				level.models[12] = "me_dumpster_close";
				level.models[13] = "com_filecabinetblackclosed";
				level.models[14] = "com_folding_chair";
				level.models[15] = "com_folding_table";
				level.models[16] = "ch_mattress_3";
				level.models[17] = "com_pallet_stack";
				level.models[18] = "me_phonebooth";
				level.models[19] = "me_refrigerator";
				level.models[20] = "com_restaurantstainlessteelshelf_02";
				level.models[21] = "com_restaurantsink_1comp";
				level.models[22] = "com_restaurantstovewithburner";
				level.models[23] = "me_streetlight";
				level.models[24] = "com_trashcan_metal";
				level.models[25] = "com_trashcan_metal_with_trash";
				level.models[26] = "foliage_tree_river_birch_xl_a";
				level.models[27] = "com_tv2";
				level.models[28] = "ch_washer_01";
			break;*/
		}
	}

	level.visratio = regGlobalFloat("scr_hns_visratio", 1); // Ratio of object prices

	// Extra models.
	// Do not modify the order, or insert (or delete) any between them! Just paste to the end when a new one is needed.
	level.ext = [];

	addExtModel("mp_crash", "mil_sandbag_desert_end_left", 5000);
	addExtModel("mp_crash", "com_steel_ladder", 8000);
	addExtModel("mp_crash", "me_sign_stop", 10000);
	addExtModel("mp_crash", "ch_bedframemetal_gray", 11500);
	addExtModel("mp_crash", "me_antenna", 12000);

	addExtModel("mp_crash_snow", "mil_sandbag_desert_end_left", 5000);
	addExtModel("mp_crash_snow", "com_steel_ladder", 8000);
	addExtModel("mp_crash_snow", "foliage_dead_pine_med", 9000);
	addExtModel("mp_crash_snow", "me_sign_stop", 10000);
	addExtModel("mp_crash_snow", "ch_bedframemetal_gray", 11500);
	addExtModel("mp_crash_snow", "me_antenna", 12000);

	addExtModel("mp_bog", "vehicle_bus_destructable", 3500);
	addExtModel("mp_bog", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_bog", "vehicle_80s_hatch1_greendest", 5000);
	addExtModel("mp_bog", "vehicle_80s_sedan1_silv_destroyed", 5000);
	addExtModel("mp_bog", "vehicle_pickup_nodoor_static", 5500);
	addExtModel("mp_bog", "vehicle_m1a1_abrams_dmg", 6000);
	addExtModel("mp_bog", "me_market_stand1", 10000);
	addExtModel("mp_bog", "me_ac_window", 11000);

	addExtModel("mp_backlot", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_backlot", "vehicle_80s_sedan1_yel_destructible_mp", 4000);
	addExtModel("mp_backlot", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_backlot", "com_steel_ladder", 6000);
	addExtModel("mp_backlot", "me_antenna", 7500);
	addExtModel("mp_backlot", "ch_sign_noentry", 12000);

	addExtModel("mp_bloc", "vehicle_80s_hatch1_reddest", 5000);
	addExtModel("mp_bloc", "vehicle_80s_wagon1_tandest", 5000);
	addExtModel("mp_bloc", "vehicle_80s_sedan1_yeldest", 5000);
	addExtModel("mp_bloc", "mil_sandbag_desert_end_left", 6500);
	addExtModel("mp_bloc", "mil_sandbag_desert_curved", 7500);
	addExtModel("mp_bloc", "ch_sign_nopedestrians", 9500);

	addExtModel("mp_broadcast", "vehicle_80s_sedan1_green_destructible_mp", 4000);
	addExtModel("mp_broadcast", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_broadcast", "vehicle_80s_sedan1_silv_destroyed", 5000);
	addExtModel("mp_broadcast", "me_market_stand1", 5500);
	addExtModel("mp_broadcast", "com_office_chair_black", 7250);
	addExtModel("mp_broadcast", "me_antenna", 8000);
	addExtModel("mp_broadcast", "com_tv2_d", 9250);

	addExtModel("mp_carentan", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_carentan", "vehicle_80s_sedan1_silv_destroyed", 5000);
	addExtModel("mp_carentan", "ct_statue_chinese_lion_gold", 5250);
	addExtModel("mp_carentan", "ct_statue_chineselionstonebase", 10000);
	addExtModel("mp_carentan", "prop_fishmarket_lobster_box", 12500);

	addExtModel("mp_cargoship", "me_corrugated_metal8x8", 4000);
	addExtModel("mp_cargoship", "cs_steeringwheel", 8000);

	addExtModel("mp_convoy", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_convoy", "vehicle_80s_wagon1_yel_destructible_mp", 4000);
	addExtModel("mp_convoy", "vehicle_80s_hatch1_tandest", 5000);
	addExtModel("mp_convoy", "vehicle_80s_wagon1_silvdest", 5000);
	addExtModel("mp_convoy", "vehicle_80s_wagon1_yel_destroyed", 5000);

	addExtModel("mp_citystreets", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_citystreets", "vehicle_80s_sedan1_yel_destructible_mp", 4000);
	addExtModel("mp_citystreets", "vehicle_80s_sedan1_red_destructible_mp", 4000);
	addExtModel("mp_citystreets", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_citystreets", "com_clothing_rack_1", 6500);
	addExtModel("mp_citystreets", "me_antenna", 8000);

	addExtModel("mp_countdown", "vehicle_bmp_dsty_static", 6500);
	addExtModel("mp_countdown", "me_antenna3", 6750);
	addExtModel("mp_countdown", "mil_sandbag_desert_curved", 7000);
	addExtModel("mp_countdown", "ch_missle_rack", 9750);

	addExtModel("mp_creek", "vehicle_pickup_nodoor_static", 4500);
	addExtModel("mp_creek", "mil_sandbag_desert_curved", 5500);
	addExtModel("mp_creek", "wetwork_grave3", 6250);
	addExtModel("mp_creek", "com_rowboat", 8000);
	addExtModel("mp_creek", "com_lamp_ornate_off", 9500);

	addExtModel("mp_crossfire", "vehicle_bus_destructable", 3500);
	addExtModel("mp_crossfire", "vehicle_80s_sedan1_green_destructible_mp", 4000);
	addExtModel("mp_crossfire", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_crossfire", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_crossfire", "vehicle_80s_sedan1_tandest", 5000);
	addExtModel("mp_crossfire", "me_corrugated_metal8x8", 5500);
	addExtModel("mp_crossfire", "com_steel_ladder", 6000);
	addExtModel("mp_crossfire", "me_market_stand1", 6500);
	addExtModel("mp_crossfire", "me_sign_noentry", 6750);
	addExtModel("mp_crossfire", "com_clothing_rack_1", 7750);
	addExtModel("mp_crossfire", "me_antenna", 8250);

	addExtModel("mp_farm", "vehicle_80s_hatch1_silvdest", 5000);
	addExtModel("mp_farm", "vehicle_80s_sedan1_tandest", 5000);
	addExtModel("mp_farm", "me_market_stand1", 5500);
	addExtModel("mp_farm", "com_steel_ladder", 6500);
	addExtModel("mp_farm", "vehicle_uaz_fabric_dsr", 7750);
	addExtModel("mp_farm", "vehicle_bm21_mobile_cover_dstry_static", 8500);
	addExtModel("mp_farm", "me_antenna", 8750);

	addExtModel("mp_killhouse", "vehicle_80s_sedan1_yeldest", 3500);
	addExtModel("mp_killhouse", "com_steel_ladder", 3750);
	addExtModel("mp_killhouse", "mil_sandbag_desert_end_left", 4000);

	addExtModel("mp_overgrown", "vehicle_80s_sedan1_yeldest", 5000);
	addExtModel("mp_overgrown", "vehicle_80s_wagon1_tandest", 5000);
	addExtModel("mp_overgrown", "mil_sandbag_desert_end_left", 5500);
	addExtModel("mp_overgrown", "mil_sandbag_desert_curved", 5500);
	addExtModel("mp_overgrown", "me_antenna2", 9750);
	addExtModel("mp_overgrown", "mil_razorwire_long_static", 10250);

	addExtModel("mp_pipeline", "vehicle_80s_sedan1_green_destructible_mp", 4000);
	addExtModel("mp_pipeline", "vehicle_80s_hatch1_red_destructible_mp", 4000);
	addExtModel("mp_pipeline", "vehicle_80s_hatch1_red_destroyed", 5000);
	addExtModel("mp_pipeline", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_pipeline", "vehicle_80s_hatch1_tandest", 5000);
	addExtModel("mp_pipeline", "com_steel_ladder", 6000);
	addExtModel("mp_pipeline", "vehicle_pickup_roobars", 8500);
	addExtModel("mp_pipeline", "ch_sign_stopsign", 9750);

	addExtModel("mp_shipment", "vehicle_tanker_truck_civ", 3000);
	addExtModel("mp_shipment", "vehicle_80s_sedan1_red", 3500);
	addExtModel("mp_shipment", "vehicle_pickup_roobars", 4000);
	addExtModel("mp_shipment", "com_bike", 8000);

	addExtModel("mp_showdown", "vehicle_80s_sedan1_silv", 3500);
	addExtModel("mp_showdown", "vehicle_uaz_van", 4250);
	addExtModel("mp_showdown", "vehicle_pickup_nodoor_static", 5750);
	addExtModel("mp_showdown", "me_antenna", 6250);

	addExtModel("mp_strike", "vehicle_80s_sedan1_green_destructible_mp", 4000);
	addExtModel("mp_strike", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_strike", "mil_sandbag_desert_corner", 5250);
	addExtModel("mp_strike", "mil_sandbag_desert_end_left", 5500);
	addExtModel("mp_strike", "me_sign_stop", 8500);
	addExtModel("mp_strike", "ch_bedframemetal_gray", 9000);
	addExtModel("mp_strike", "me_antenna", 9250);
	addExtModel("mp_strike", "ch_mattress_2", 9500);

	addExtModel("mp_vacant", "vehicle_80s_sedan1_green_destructible_mp", 4000);
	addExtModel("mp_vacant", "vehicle_80s_sedan1_red_destructible_mp", 4000);
	addExtModel("mp_vacant", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_vacant", "vehicle_80s_sedan1_yel_destructible_mp", 4000);
	addExtModel("mp_vacant", "vehicle_80s_hatch1_green_destroyed", 5000);
	addExtModel("mp_vacant", "vehicle_80s_sedan1_yeldest", 5000);
	addExtModel("mp_vacant", "vehicle_uaz_hardtop_static", 5250);
	addExtModel("mp_vacant", "vehicle_uaz_van", 5250);
	addExtModel("mp_vacant", "vehicle_semi_truck_cargo", 5250);
	addExtModel("mp_vacant", "me_antenna", 5500);
	addExtModel("mp_vacant", "com_shopping_cart", 6750);
	addExtModel("mp_vacant", "com_bike", 7500);
	addExtModel("mp_vacant", "ch_sign_stopsign", 8750);

	//addExtModel("mp_cluster", "vehicle_bus", 3500);
	addExtModel("mp_cluster", "vehicle_80s_sedan1_green", 5000);
	addExtModel("mp_cluster", "vehicle_80s_sedan1_green_destroyed", 5000);
	addExtModel("mp_cluster", "vehicle_80s_sedan1_red", 5000);
	addExtModel("mp_cluster", "vehicle_80s_sedan1_reddest", 5000);
	//addExtModel("mp_cluster", "vehicle_bulldozer", 6000);
	addExtModel("mp_cluster", "vehicle_humvee_camo_static", 6000);
	addExtModel("mp_cluster", "vehicle_pickup_technical_destroyed_static", 6000);
	//addExtModel("mp_cluster", "cargocontainer_20ft_white", 6000);
	addExtModel("mp_cluster", "com_industrialtrashbin", 6250);
	addExtModel("mp_cluster", "mil_sandbag_desert_end_left", 6250);
	addExtModel("mp_cluster", "me_antenna", 7000);
	addExtModel("mp_cluster", "me_sign_noentry", 8000);
	addExtModel("mp_cluster", "ch_bedframemetal_dark", 8500);

	addExtModel("mp_backyard", "vehicle_80s_sedan1_silv_destructible_mp", 4000);
	addExtModel("mp_backyard", "vehicle_80s_sedan1_red_destructible_mp", 4000);
	addExtModel("mp_backyard", "vehicle_80s_sedan1_silv_destroyed", 5000);
	addExtModel("mp_backyard", "vehicle_80s_wagon1_red_destroyed", 5000);
	addExtModel("mp_backyard", "vehicle_zpu4_burn_static", 5500);
	addExtModel("mp_backyard", "mil_sandbag_desert_curved", 6000);
	addExtModel("mp_backyard", "com_office_chair_black", 6250);
	addExtModel("mp_backyard", "ch_furniture_teachers_chair1", 6750);
	addExtModel("mp_backyard", "vehicle_pickup_technical_destroyed", 7250);
	addExtModel("mp_backyard", "ap_couch01", 7500);
	addExtModel("mp_backyard", "ch_furniture_kids_chair1", 8000);
	addExtModel("mp_backyard", "ch_furniture_kids_desk1", 8250);
	addExtModel("mp_backyard", "com_cardboardbox01", 8750);
	addExtModel("mp_backyard", "me_antenna", 9000);
	addExtModel("mp_backyard", "com_tv1", 10000);
	addExtModel("mp_backyard", "ch_bedframemetal_dark", 10500);

	addExtModel("mp_fav", "com_steel_ladder", 5500);
	addExtModel("mp_fav", "com_basketball_goal", 6000);
	addExtModel("mp_fav", "vehicle_pickup_roobars", 6500);
	addExtModel("mp_fav", "ch_tombstone2", 7500);
	addExtModel("mp_fav", "com_newspaperbox_blue", 8500);
	addExtModel("mp_fav", "com_newspaperbox_red", 8500);
	addExtModel("mp_fav", "com_shopping_cart", 10000);
	addExtModel("mp_fav", "me_antenna3", 12000);

	// By Haris
	addExtModel("mp_uprise", "me_antenna", 12000);
	addExtModel("mp_uprise", "me_market_umbrella_6", 10000);
	addExtModel("mp_uprise", "ch_mattress_2", 8000);
	addExtModel("mp_uprise", "me_streetlight", 6000);
	addExtModel("mp_uprise", "ch_bedframemetal_gray", 5000);

	level.curext = [];
	s = 0;
	c = level.ext.size;
	for (i = 0; i < c; i++)
	{
		if (level.ext[i].map == level.script)
		{
			level.curext[s] = i;
			preCacheModel(level.ext[i].model);
			s++;
		}
	}

	// Models ~ now they are moved from localized strings to GSC, because of the exceeded limit
	level.modelName["com_barrel_white_rust"] = "BARREL";
	level.modelName["com_barrel_biohazard_rust"] = "BARREL";
	level.modelName["me_dumpster_close"] = "DUMPSTER";
	level.modelName["com_trashcan_metal"] = "TRASHCAN";
	level.modelName["bc_hesco_barrier_med"] = "BARRIER";
	level.modelName["me_ac_big"] = "AERATOR";
	level.modelName["me_concrete_barrier"] = "CONCRETE_BARRIER";
	level.modelName["ch_mattress_2"] = "MATTRESS";
	level.modelName["ch_mattress_3"] = "MATTRESS";
	level.modelName["ch_washer_01"] = "WASHER";
	level.modelName["vehicle_80s_sedan1_brn"] = "CAR";
	level.modelName["vehicle_small_hatchback_blue_static"] = "CAR";
	level.modelName["vehicle_small_wagon_d_white"] = "DESTROYED_CAR";
	level.modelName["com_pallet_stack"] = "PALLET_STACK";
	level.modelName["com_restaurantstainlessteelshelf_01"] = "SHELF";
	level.modelName["com_restaurantstainlessteelshelf_02"] = "SHELF";
	level.modelName["com_water_heater"] = "BOILER";
	level.modelName["me_corrugated_metal8x8"] = "SHEETMETAL";
	level.modelName["com_wheelbarrow"] = "WHEELBARROW";
	level.modelName["ch_crate48x64"] = "CRATE";
	level.modelName["ch_crate64x64"] = "CRATE";
	level.modelName["ch_crate32x48"] = "CRATE";
	level.modelName["vehicle_80s_hatch1_brn_destroyed"] = "DESTROYED_CAR";
	level.modelName["vehicle_pickup_technical_destroyed"] = "PICKUP_CAR";
	level.modelName["me_streetlightdual"] = "STREETLIGHT";
	level.modelName["me_streetlight"] = "STREETLIGHT";
	level.modelName["me_streetlight_on"] = "STREETLIGHT";
	level.modelName["cargocontainer_20ft_red"] = "CONTAINER";
	//level.modelName["cargocontainer_20ft_white"] = "CONTAINER";
	level.modelName["com_plasticcase_beige_big"] = "CASE";
	level.modelName["com_tv1"] = "TV";
	level.modelName["com_tv2"] = "TV";
	level.modelName["com_filecabinetblackclosed"] = "FILE_CABINET";
	level.modelName["mil_sandbag_desert_long"] = "SANDBAGS";
	level.modelName["com_photocopier"] = "COPIER";
	level.modelName["me_refrigerator"] = "REFRIGERATOR";
	level.modelName["me_refrigerator2"] = "REFRIGERATOR_BLUE";
	level.modelName["foliage_tree_palm_bushy_1"] = "PALM";
	level.modelName["foliage_tree_palm_bushy_1_static"] = "PALM";
	level.modelName["foliage_tree_palm_bushy_2"] = "PALM";
	level.modelName["foliage_tree_palm_bushy_3"] = "PALM";
	level.modelName["foliage_tree_palm_bushy_3_static"] = "PALM";
	level.modelName["foliage_tree_river_birch_xl_a"] = "TREE";
	level.modelName["foliage_tree_river_birch_lg_a"] = "TREE";
	level.modelName["foliage_red_pine_lg"] = "TREE";
	level.modelName["foliage_tree_grey_oak_lg_a"] = "TREE";
	level.modelName["snow_tree_lights01"] = "TREE";
	level.modelName["ch_bedframemetal_gray"] = "BED_FRAME";
	level.modelName["ch_bedframemetal_dark"] = "BED_FRAME";
	level.modelName["ch_furniture_couch02"] = "COUCH";
	level.modelName["com_dresser"] = "DRESSER";
	level.modelName["com_dresser_d"] = "DRESSER";
	level.modelName["com_bomb_objective"] = "BOMB";
	level.modelName["me_satellitedish"] = "SATELLITE_DISH";
	level.modelName["com_cafe_chair"] = "WOODEN_CHAIR";
	level.modelName["com_cafe_chair2"] = "CHAIR";
	level.modelName["bc_militarytent_wood_table"] = "TABLE";
	level.modelName["com_woodlog_24_192_d"] = "LOG";
	level.modelName["com_bike"] = "BIKE";
	level.modelName["ch_furniture_teachers_desk1"] = "DESK";
	level.modelName["me_basket_rattan01"] = "BASKET";
	level.modelName["me_basket_wicker05"] = "BASKET";
	level.modelName["me_telegraphpole"] = "POLE";
	level.modelName["me_telegraphpole2"] = "POLE";
	level.modelName["com_powerpole1"] = "POLE";
	level.modelName["com_powerpole3"] = "POLE";
	level.modelName["com_cardboardbox01"] = "BOX";
	level.modelName["com_barrel_blue_rust"] = "BARREL_BLUE";
	level.modelName["com_barrel_tan_rust"] = "BARREL";
	level.modelName["com_folding_chair"] = "FOLDING_CHAIR";
	level.modelName["ch_dinercounterchair"] = "DINER_CHAIR";
	level.modelName["ch_dinerboothchair"] = "DINER_BENCH";
	level.modelName["ch_furniture_school_lunch_table"] = "DINER_TABLE";
	level.modelName["ch_dinerboothtable"] = "DINER_TABLE";
	level.modelName["me_gas_pump"] = "GAS_PUMP";
	level.modelName["ch_gas_pump"] = "GAS_PUMP";
	level.modelName["com_barrel_fire"] = "BARREL_BURNT";
	level.modelName["com_barrel_black_rust"] = "BARREL_BLACK";
	level.modelName["me_dumpster"] = "DUMPSTER_OPEN";
	level.modelName["com_trashcan_metal_with_trash"] = "TRASHCAN_FULL";
	level.modelName["me_market_stand4"] = "MARKET_STAND";
	level.modelName["com_lamp_ornate_on"] = "LAMP";
	level.modelName["com_lamp_ornate_off"] = "LAMP";
	level.modelName["ct_street_lamp_on"] = "LAMP";
	level.modelName["ch_street_light_01_off"] = "LAMP";
	level.modelName["ch_lawnmower"] = "LAWNMOWER";
	level.modelName["com_bookshelves1_d"] = "BOOKSHELVES";
	level.modelName["com_bookshelveswide"] = "BOOKSHELVES";
	level.modelName["vehicle_tractor"] = "TRACTOR";
	level.modelName["vehicle_tractor_2"] = "TRACTOR";
	level.modelName["foliage_dead_pine_med"] = "TREE_BURNT";
	level.modelName["foliage_dead_pine_sm"] = "TREE_BURNT";
	level.modelName["foliage_dead_pine_xl"] = "TREE_BURNT";
	level.modelName["com_folding_table"] = "FOLDING_TABLE";
	level.modelName["com_barrel_green_dirt"] = "BARREL_GREEN";
	level.modelName["com_barrel_green_rust"] = "BARREL_GREEN";
	level.modelName["com_barrel_green"] = "BARREL_GREEN";
	level.modelName["vehicle_bulldozer"] = "BULLDOZER";
	level.modelName["vehicle_bmp_dsty_static"] = "TANK";
	level.modelName["vehicle_bmp_woodland_dsty_static"] = "TANK";
	level.modelName["vehicle_m1a1_abrams_d_static"] = "TANK";
	level.modelName["vehicle_uaz_light_dsr"] = "TRUCK";
	level.modelName["vehicle_uaz_hardtop_dsr"] = "TRUCK";
	level.modelName["vehicle_uaz_hardtop"] = "TRUCK";
	level.modelName["ch_russian_table"] = "RUSSIAN_TABLE";
	level.modelName["ch_hayroll_02"] = "HAYROLL";
	level.modelName["ch_hayroll_03"] = "HAYROLL";
	level.modelName["com_plainchair"] = "CHAIR_OLD";
	level.modelName["com_playpen"] = "PLAYPEN";
	level.modelName["prop_misc_rock_boulder_snow_05"] = "ROCK";
	level.modelName["prop_misc_rock_boulder_04"] = "ROCK";
	level.modelName["com_restaurantstove"] = "STOVE";
	level.modelName["com_restaurantstovewithburner"] = "STOVE";
	level.modelName["com_stove"] = "STOVE";
	level.modelName["com_stove_d"] = "STOVE";
	level.modelName["vehicle_tanker_truck_d"] = "TANKER";
	level.modelName["vehicle_tanker_truck"] = "TANKER";
	level.modelName["ch_furniture_couch01"] = "COUCH_YELLOW";
	level.modelName["vehicle_delivery_truck"] = "DELIVERY_TRUCK";
	level.modelName["com_electrical_transformer"] = "TRANSFORMER";
	level.modelName["com_propane_tank02"] = "PROPANE";
	level.modelName["com_bench"] = "BENCH";
	level.modelName["com_metalbench"] = "BENCH_METAL";
	level.modelName["ch_baby_carriage"] = "CARRIAGE";
	level.modelName["com_wagon_donkey"] = "WAGON";
	level.modelName["com_wagon_donkey_nohandle"] = "WAGON";
	level.modelName["com_restaurantchair_2"] = "RESTAURANT_CHAIR";
	level.modelName["mil_bunker_bed2"] = "BED";
	level.modelName["mil_bunker_bed3"] = "BED";
	level.modelName["com_conference_table1"] = "CONFERENCE_TABLE";
	level.modelName["com_ladder_wood"] = "WOODEN_LADDER";
	level.modelName["com_server_rack_sid"] = "SERVER_RACK";
	level.modelName["com_mannequin3"] = "MANNEQUIN";
	level.modelName["me_market_umbrella_3"] = "UMBRELLA";
	level.modelName["me_market_umbrella_5"] = "UMBRELLA";
	level.modelName["me_market_umbrella_6"] = "UMBRELLA";
	level.modelName["com_cafe_table1"] = "CAFE_TABLE_ROUND";
	level.modelName["com_cafe_table2"] = "CAFE_TABLE";
	level.modelName["me_refrigerator_d"] = "REFRIGERATOR_DESTROYED";
	level.modelName["com_barrier_tall1"] = "CONCRETE_BARRIER_BIG";
	level.modelName["com_armoire_d"] = "ARMOIRE";
	level.modelName["com_northafrica_armoire_short"] = "ARMOIRE";
	level.modelName["me_construction_dumpster_close"] = "CONSTRUCTION_DUMPSTER";
	level.modelName["me_construction_dumpster_open"] = "CONSTRUCTION_DUMPSTER";
	level.modelName["com_industrialtrashbin"] = "CONSTRUCTION_DUMPSTER";
	level.modelName["me_phonebooth"] = "PHONEBOOTH";
	level.modelName["vehicle_sa6_static_woodland"] = "AIR_DEFENCE";
	level.modelName["com_restaurantsink_1comp"] = "SINK";
	level.modelName["com_restaurantsink_2comps"] = "SINK";
	//level.modelName["bathroom_sink"] = "SINK";
	level.modelName["me_ac_window"] = "AERATOR_WINDOW";
	level.modelName["com_restaurantkitchentable_1"] = "RESTAURANT_TABLE";
	level.modelName["com_stepladder_large"] = "LADDER";
	level.modelName["com_trashcan"] = "TRASHCAN_STONE";
	level.modelName["vehicle_humvee_camo_static"] = "HUMVEE";
	level.modelName["me_wood_cage_large"] = "CAGE";
	level.modelName["ct_statue_chinese_lion"] = "STATUE";
	level.modelName["ct_china_vase"] = "VASE";
	level.modelName["tvs_cubicle_round_1"] = "TV_TABLE";
	level.modelName["ch_snack_machine_big_russia"] = "AUTOMAT";
	level.modelName["giftbox_01"] = "GIFT";
	level.modelName["candy_cane"] = "CANDY";
	level.modelName["bathroom_toilet"] = "TOILET";
	level.modelName["mil_bunker_bed1"] = "BED";
	level.modelName["mil_sandbag_desert_curved"] = "SANDBAGS_CURVED";
	level.modelName["cs_tow_hook"] = "TOW_HOOK";
	level.modelName["cs_monitor1"] = "MONITOR";
	level.modelName["snowman"] = "SNOWMAN";
	level.modelName["seeker"] = "SEEKER";
	level.modelName["foliage_tree_grey_oak_sm_a"] = "TREE";
	level.modelName["me_antenna"] = "ANTENNA";
	level.modelName["me_antenna2"] = "ANTENNA";
	level.modelName["me_antenna3"] = "ANTENNA";
	level.modelName["com_steel_ladder"] = "STEEL_LADDER";
	level.modelName["me_sign_stop"] = "SIGN";
	level.modelName["mil_sandbag_desert_end_left"] = "SANDBAGS_END";
	level.modelName["vehicle_80s_hatch1_greendest"] = "DESTROYED_CAR_GREEN";
	level.modelName["vehicle_80s_sedan1_silv_destroyed"] = "DESTROYED_CAR_SILVER";
	level.modelName["vehicle_80s_sedan1_silv_destructible_mp"] = "CAR_SILVER";
	level.modelName["vehicle_bus_destructable"] = "BUS";
	//level.modelName["vehicle_bus"] = "BUS";
	level.modelName["vehicle_m1a1_abrams_dmg"] = "TANK";
	level.modelName["vehicle_pickup_nodoor_static"] = "PICKUP_CAR";
	level.modelName["vehicle_pickup_technical_destroyed_static"] = "PICKUP_CAR";
	level.modelName["ch_sign_noentry"] = "SIGN";
	level.modelName["vehicle_80s_sedan1_green_destroyed"] = "DESTROYED_CAR_GREEN";
	level.modelName["vehicle_80s_sedan1_yel_destructible_mp"] = "CAR_YELLOW";
	level.modelName["ch_sign_nopedestrians"] = "SIGN";
	level.modelName["vehicle_80s_hatch1_reddest"] = "DESTROYED_CAR_RED";
	level.modelName["vehicle_80s_sedan1_yeldest"] = "DESTROYED_CAR_YELLOW";
	level.modelName["vehicle_80s_wagon1_tandest"] = "DESTROYED_CAR_TAN";
	level.modelName["com_tv2_d"] = "TV_DESTROYED";
	level.modelName["me_market_stand1"] = "MARKET_STAND_SMALL";
	level.modelName["vehicle_80s_sedan1_green_destructible_mp"] = "CAR_GREEN";
	level.modelName["vehicle_80s_sedan1_green"] = "CAR_GREEN";
	level.modelName["ct_statue_chineselionstonebase"] = "STATUE_BASE";
	level.modelName["ct_statue_chinese_lion_gold"] = "STATUE_GOLD";
	level.modelName["prop_fishmarket_lobster_box"] = "LOBSTER_BOX";
	level.modelName["cs_steeringwheel"] = "STEERING_WHEEL";
	level.modelName["vehicle_80s_hatch1_tandest"] = "DESTROYED_CAR_TAN";
	level.modelName["vehicle_80s_wagon1_yel_destroyed"] = "DESTROYED_CAR_YELLOW";
	level.modelName["vehicle_80s_wagon1_yel_destructible_mp"] = "CAR_YELLOW";
	level.modelName["vehicle_80s_wagon1_silvdest"] = "DESTROYED_CAR_SILVER";
	level.modelName["com_clothing_rack_1"] = "CLOTHING_RACK";
	level.modelName["vehicle_80s_sedan1_red_destructible_mp"] = "CAR_RED";
	level.modelName["ch_missle_rack"] = "MISSILE_RACK";
	level.modelName["com_rowboat"] = "ROW_BOAT";
	level.modelName["wetwork_grave3"] = "GRAVE";
	level.modelName["me_sign_noentry"] = "SIGN";
	level.modelName["vehicle_80s_sedan1_tandest"] = "DESTROYED_CAR_TAN";
	level.modelName["vehicle_80s_hatch1_silvdest"] = "DESTROYED_CAR_SILVER";
	level.modelName["vehicle_uaz_fabric_dsr"] = "TRUCK";
	level.modelName["vehicle_bm21_mobile_cover_dstry_static"] = "SUPPLIER_TRUCK";
	level.modelName["ch_sign_noparking"] = "SIGN";
	level.modelName["ch_sign_stopsign"] = "SIGN";
	level.modelName["vehicle_80s_hatch1_red_destroyed"] = "DESTROYED_CAR_RED";
	level.modelName["vehicle_80s_sedan1_reddest"] = "DESTROYED_CAR_RED";
	level.modelName["vehicle_80s_hatch1_red_destructible_mp"] = "CAR_RED";
	level.modelName["vehicle_pickup_roobars"] = "PICKUP_CAR";
	level.modelName["vehicle_80s_sedan1_red"] = "CAR_RED";
	level.modelName["vehicle_tanker_truck_civ"] = "TANKER";
	level.modelName["vehicle_80s_sedan1_silv"] = "CAR_SILVER";
	level.modelName["vehicle_uaz_van"] = "VAN";
	level.modelName["mil_sandbag_desert_corner"] = "SANDBAGS_CORNER";
	level.modelName["com_shopping_cart"] = "SHOPPING_CART";
	level.modelName["vehicle_80s_hatch1_green_destroyed"] = "DESTROYED_CAR_GREEN";
	level.modelName["vehicle_uaz_hardtop_static"] = "TRUCK";
	level.modelName["vehicle_semi_truck_cargo"] = "SEMI_TRUCK";
	level.modelName["vehicle_zpu4_burn_static"] = "ZPU";
	level.modelName["com_office_chair_black"] = "OFFICE_CHAIR";
	level.modelName["ch_furniture_teachers_chair1"] = "CHAIR_OLD";
	level.modelName["ch_furniture_kids_chair1"] = "KID_CHAIR";
	level.modelName["ch_furniture_kids_desk1"] = "KID_DESK";
	level.modelName["ch_tombstone2"] = "TOMBSTONE";
	level.modelName["com_basketball_goal"] = "BASKETBALL_GOAL";
	level.modelName["com_newspaperbox_blue"] = "NEWSBOX_BLUE";
	level.modelName["com_newspaperbox_red"] = "NEWSBOX_RED";
	level.modelName["ap_couch01"] = "LEATHER_COUCH";
	level.modelName["vehicle_80s_wagon1_red_destroyed"] = "DESTROYED_CAR_RED";
	level.modelName["mil_razorwire_long_static"] = "BARBED_WIRE";
	level.modelName["com_walltable2"] = "TABLE";

	// Barrel fire ~ can't check if it's on the map or not, because can't load FX after waittillframeend
	//if (modelOnMap("com_barrel_fire"))
	level.barrelFX = loadFX("hns/barrel"); // fire/firelp_barrel_pm

	// Wait for map script to complete ~ that can contain addObj functions
	//waittillframeend;

	if (!level.models.size)
		error("Models for " + level.script + " are not configured!");

	// Store model names
	/*level.allowedModels = [];
	for (i = 0; i < data.size; i++)
	{
		level.allowedModels[data[i]] = true;
	}*/

	// Timer
	level.counter = newHudElem();
	level.counter.font = "default";
	level.counter.fontscale = 2;
	level.counter.x = 0;
	level.counter.y = 64;
	level.counter.hideWhenInMenu = true;
	level.counter.archived = true;
	level.counter.alignX = "center";
	level.counter.alignY = "middle";
	level.counter.horzAlign = "center";
	level.counter.vertAlign = "top";
	level.counter.alpha = 0.85;
	level.counter.glowAlpha = 0.1;
	level.counter.glowColor = (1, 0.2, 0.2);
	level.counter.alpha = 0;

	level.timertext = newHudElem();
	level.timertext.elemType = "font";
	level.timertext.font = "default";
	level.timertext.fontscale = 1.6;
	level.timertext.x = 0;
	level.timertext.y = 42;
	level.timertext.hideWhenInMenu = true;
	level.timertext.archived = true;
	level.timertext.alignX = "center";
	level.timertext.alignY = "middle";
	level.timertext.horzAlign = "center";
	level.timertext.vertAlign = "top";
	level.timertext.alpha = 0;
	level.timertext.glowAlpha = 0.1;
	level.timertext.glowColor = (1, 0.2, 0.2);

	// Listen server for developing
	level.listen = getDvar("dedicated") == "listen server";
	level.dev = level.listen && getDvarInt("hns_developer") > 0;

	// Jumps, glitches
	/#
	if (level.dev)
	{
		level.blocks = [];
		level.blockCount = 0;
		thread debugBlock();
	}
	#/

	// Safearea is deprecated
	//level.areaCount = 0;
	//level.areas = [];

	data = [];
	origo = (0, 0, 0);
	switch (level.script)
	{
		case "mp_strike":
			addBlock((-226, 712, 220.125), 30, 70); // Satellite
			addJump((-2363, -477, 290.125), 65, 70); // Balcony #1
			addJump((-2153, -481, 290.125), 65, 70); // Balcony #2
			addBlock((790, -150, 160.125), 50, 128); // Plant B, balcony #1
			addBlock((760, -400, 160.125), 35, 128); // Plant B, balcony #2
			addBlock((790, -495, 160.125), 50, 128); // Plant B, balcony #3
			//data[0] = spawn("trigger_radius", (385, 600, 220.125), 0, 100, 100); // Hard-strafe next to plant B
			//data[1] = spawn("trigger_radius", (-2300, 185, 230.125), 0, 100, 100); // Jump from balcony frame
			//data[2] = spawn("trigger_radius", (730, -72.8749, 156.125), 0, 2, 2); // House frame to defend balcony
			//data[3] = spawn("trigger_radius", (910, 255, 196.125), 0, 20, 20); // Bounce to balcony, point #1
			//data[4] = spawn("trigger_radius", (910, 190, 196.125), 0, 20, 20); // Bounce to balcony, point #2
			//data[5] = spawn("trigger_radius", (440, -1065, 362.125), 0, 50, 50); // From fence to pole
			//data[6] = spawn("trigger_radius", (650, 835, 294.125), 0, 15, 15); // Stack to roof
			//data[7] = spawn("trigger_radius", (-265, 342, 220.125), 0, 10, 10); // Two players next to flag B
		break;
		case "mp_countdown":
			addJump((-660, 1040, -900), 800); // Rocket #1
			addJump((575, 1040, -900), 800); // Rocket #2
			addJump((600, 85, -900), 800); // Rocket #3
			addJump((-660, 85, -900), 800); // Rocket #4
			//data[0] = spawn("trigger_radius", (-660, 1040, -900), 0, 800, 800); // Rocket #1
			//data[1] = spawn("trigger_radius", (575, 1040, -900), 0, 800, 800); // Rocket #2
			//data[2] = spawn("trigger_radius", (600, 85, -900), 0, 800, 800); // Rocket #3
			//data[3] = spawn("trigger_radius", (-660, 85, -900), 0, 800, 800); // Rocket #4
		break;
		case "mp_overgrown":
			addJump((550, -2775, -335), 50, 30); // Rock
			//data[0] = spawn("trigger_radius", (510, -2760, -335), 0, 15, 15); // Rock
			//data[1] = spawn("trigger_radius", (510, -2790, -335), 0, 15, 15); // Rock, point2
			//data[2] = spawn("trigger_radius", (-72, -1240, -193.176), 0, 30, 30); // Under the truck #1 - DEPRECATED
			//data[3] = spawn("trigger_radius", (65, -1345, -191.875), 0, 35, 35); // Under the truck #2 - DEPRECATED
			//data[4] = spawn("trigger_radius", (120, -1390, -187.206), 0, 40, 40); // Under the truck #3 - DEPRECATED
			//data[5] = spawn("trigger_radius", (-1775, -4150, 15), 0, 50, 50); // Roof stack
		break;
		case "mp_crossfire":
			addBlock((3443, -1134, 194.125), 10); // Aerator
			addJump((3475, -3225, 28.125), 20); // Red board
			addJump((4450, -2530, 134.625), 20); // Balcony
			addJump((4530, -2515, 169.125), 20); // Satellite
			//data[2] = spawn("trigger_radius", (3475, -3225, 28.125), 0, 20, 20); // Rare-used balcony
			//data[3] = spawn("trigger_radius", (4450, -2530, 134.625), 0, 20, 20); // Balcony with red table
			//data[4] = spawn("trigger_radius", (3443, -1135, 194.125), 0, 20, 20); // Balcony at attack spawn
			//data[0] = spawn("trigger_radius", (6320, -1480, 181.125), 0, 50, 50); // Right balcony
			//data[1] = spawn("trigger_radius", (6425, -1325, 181.125), 0, 40, 40); // Left balcony
			//data[6] = spawn("trigger_radius", (4400, -2980, 208.125), 0, 15, 15); // Stack to the roof

			addArea((3472, -4737, -135), 165, 62, 120, "climb", 25, 20); // Parking lot #1
			spawnLadder((3483, -4735, 0), (0, -15, 0));
			spawnLadder((3465, -4735, 0), (0, 165, 0));

			addArea((3209, -3115, -135), -120, 48, 120, "climb", 15, 20); // Parking lot #2
			spawnLadder((3206, -3120, 0), (0, -120, 0));
			spawnLadder((3211, -3112, 0), (0, 60, 0));

			// Fix stucking behind the car in the new area
			addBlock((3115, -4565, -134), 20, 40); // Right point
			addBlock((3140, -4580, -134), 20, 40); // Left point
			addBlock((4212, -2395, 134.625), 16, 32); // Red board from the stairs
		break;
		case "mp_convoy":
			addJump((1530, 495, -58), 15); // Tall palm
			addJump((1490, 390, -58), 15); // Wide palm
			addBlock((2275, 390, 120), 24, 64); // North house jump
			//data[0] = spawn("trigger_radius", (-2080, 250, 120), 0, 80, 80); // Roof, point 1
			//data[1] = spawn("trigger_radius", (-2080, 330, 120), 0, 80, 80); // Roof, point 2
			//data[2] = spawn("trigger_radius", (1530, 495, -58), 0, 15, 15); // Tall palm
			//data[3] = spawn("trigger_radius", (1490, 390, -58), 0, 15, 15); // Wide palm
			//data[4] = spawn("trigger_radius", (2715, -525, 32.125), 0, 15, 15); // Two players
			//data[5] = spawn("trigger_radius", (1100, -870, 152.125), 0, 150, 150); // Car bounce to roof (250)
			//data[6] = spawn("trigger_radius", (2365, 460, 116.125), 0, 10, 10); // Stack to the window
		break;
		case "mp_citystreets":
			addJump((6110, -1575, 0.125), 2); // Pillar #1
			addJump((5705, -1905, 0.125), 2); // Pillar #2
			addJump((5705, -2120, 0.125), 2); // Pillar #3
			addJump((5705, -2340, 0.125), 2); // Pillar #4
			addJump((5650, 50, -1271.88), 500); // Bottom of the well
			addJump((2320, 495, 136.125), 50); // Strafe house next to plant B, Window #1
			addJump((2320, 625, 136.125), 50); // Strafe house next to plant B, Window #2
			//data[0] = spawn("trigger_radius", (5650, 50, -1271.88), 0, 500, 500); // Bottom of the well
			//data[1] = spawn("trigger_radius", (4770, -125, 48.125), 0, 40, 40); // Balcony
			//data[2] = spawn("trigger_radius", (2320, 495, 136.125), 0, 10, 10); // Hard-strafe house next to plant B, Window #1
			//data[3] = spawn("trigger_radius", (2320, 625, 136.125), 0, 10, 10); // Hard-strafe house next to plant B, Window #2
			//data[4] = spawn("trigger_radius", (6110, -1575, 0.125), 0, 2, 2); // Pillar #1
			//data[5] = spawn("trigger_radius", (5705, -1905, 0.125), 0, 2, 2); // Pillar #2
			//data[6] = spawn("trigger_radius", (5705, -2120, 0.125), 0, 2, 2); // Pillar #3
			//data[7] = spawn("trigger_radius", (5705, -2340, 0.125), 0, 2, 2); // Pillar #4

			addArea((4255, 1342, 0), 90, 50, 48, "high", 40, 32); // Behind defense spawn
			addArea((5085, 1440, 0), 90, 50, 48, "high", 40, 32);
			addBlock((4575, 1785, -50), 20, 256); // Palm #1
			addBlock((4642, 2077, -50), 20, 256); // Palm #2
			addBlock((4704, 2266, -50), 20, 256); // Palm #3
			addBlock((4835, 1870, -50), 20, 256); // Palm #4

			addArea((3820, 420, 0), 0, 40, 75, "high", 35, 10); // Store
			addBlock((3815, 295, 0), 10, 75);
			addBlock((3815, 257, 0), 10, 75);
			addBlock((3577, 158, -86.125), 10, 75);
			addBlock((3655, -105, -86.125), 10, 75);
			addBlock((3605, -105, -86.125), 10, 75);
		break;
		case "mp_backlot":
		case "mp_backlot_snow":
			addJump((-797, -1097, 212.125), 20, 200); // Out of the map on the attack side
			addJump((1055, -1160, 320), 10); // Jumping from bricks onto roof (Gossip)
			addJump((713, 1111, 236.125), 25); // Buggy balcony
			addJump((575, -815, 345.125), 50); // Left pillar
			addJump((5, -815, 345.125), 50); // Right pillar
			addJump((1600, 970, 198.125), 50); // Gas station
			addJump((245, -975, 336.845), 20); // Tree
			addJump((1090, 775, 256.125), 20); // Top of the fence
			addJump((-755, -530, 370), 50, 10); // Top of the main building
			//data[0] = spawn("trigger_radius", (-342.874, -1432, 197.125), 0, 20, 20); // Balcony next to attack spawn
			//data[1] = spawn("trigger_radius", (490, 1415, 255), 0, 25, 25); // House corner next to defense spawn
			//data[2] = spawn("trigger_radius", (1340, 505, 282.125), 0, 50, 50); // No-out(333 FPS) Balcony #1
			//data[3] = spawn("trigger_radius", (1340, 235, 282.125), 0, 50, 50); // No-out(333 FPS) Balcony #2
			//data[4] = spawn("trigger_radius", (575, -815, 345.125), 0, 50, 50); // Most used pillar
			//data[5] = spawn("trigger_radius", (5, -815, 345.125), 0, 50, 50); // Right pillar
			//data[6] = spawn("trigger_radius", (1600, 970, 198.125), 0, 20, 20); // Gas station
			//data[7] = spawn("trigger_radius", (-744, -925, 285), 0, 20, 20); // Multi leveled building to balcony and then to the ledge
			//data[8] = spawn("trigger_radius", (1055, -1160, 320), 0, 10, 10); // Jumping on bricks onto roof (Gossip)
			//data[9] = spawn("trigger_radius", (335, 224.875, 301.125), 0, 20, 20); // First node of 5 to a balcony on the middle
		break;
		case "mp_creek":
			addBlock((390, 6725, -85), 30, 70); // Big rock ~ Radius 10 to prevent teleporting when proning under the rock. That way however, players can go around it
			addJump((-1265, 6560, -110), 15); // Small rock #1
			addJump((-1030, 6435, -80), 30, 15); // Small rock #2
			//data[0] = spawn("trigger_radius", (410, 6740, -55), 0, 10, 10); // Big rock
			//data[1] = spawn("trigger_radius", (-1265, 6560, -110), 0, 15, 15); // Smaller rock
			//data[2] = spawn("trigger_radius", (-1030, 6435, -80), 0, 30, 15); // Third rock
			//data[3] = spawn("trigger_radius", (-960, 6350, -50), 0, 40, 15); // Third rock, another half

			addArea((-3095, 7780, 177), 30, 45, 48, "high", 32, 32); // Cemetery facade
			addBlock((-2480, 8315, 150), 20, 256); // Tree
			addBlock((-2100, 8190, 150), 35, 150); // Fence
			addBlock((-2025, 8230, 150), 35, 150); // Fence
			addBlock((-1950, 8275, 150), 35, 150); // Fence
			addBlock((-2580, 8470, 100), 90, 512); // Propane
			addBlock((-2640, 8545, 100), 90, 512); // Propane
			addBlock((-2680, 8630, 100), 90, 512); // Propane
			addBlock((-760, 9110, 150), 35, 250); // Concrete barricade
			addBlock((-800, 8200, 100), 225, 750); // Rock balcony
		break;
		case "mp_backyard":
			addJump((-1342, 545, 169.125), 30); // Balcony for jumping behind the sheetmetal
			addJump((-860, 230, 16.1216), 20); // Balcony for jumping behind the sheetmetal
			addJump((-1545, -210, 107.024), 30); // Balcony for jumping behind the sheetmetal
			//data[0] = spawn("trigger_radius", (-865, 475, 8.125), 0, 5, 5); // Behind the sheetmetal #1
			//data[0] = spawn("trigger_radius", (-865, 230, 16), 0, 5, 5); // Behind the sheetmetal #2
			//data[1] = spawn("trigger_radius", (-525, -375, 160.125), 0, 105, 105); // Roof

			addArea((-1660, 1105, 16.125), 0, 20, 110, "high", 10, 10); // Behind the fence
		break;
		case "mp_fav":
			addBlock((1575, -1060, 304.125), 15); // Proning to the burnt area
			addBlock((1915, 165, 161.625), 20, 80); // Refrigerator
			addBlock((605, -1136, 194.125), 8, 55); // Wall point #1
			addBlock((575, -1136, 194.125), 8, 60); // Wall point #2
			addBlock((670, -1136, 194.125), 8, 35); // Wall point #3
		break;
		case "mp_broadcast":
			// White office doors
			addArea((-303, 647, -31.875), -150, 25, 0, "door", 16, 20);
			addArea((-657, 128, -30.125), 120, 25, 0, "door", 16, 20);
			addArea((-330, 790, -30.125), 120, 25, 0, "door", 16, 20);
			addArea((225, 870, -30.125), 30, 25, 0, "door", 16, 20);
			addArea((355, 870, 136.125), -150, 25, 0, "door", 16, 20);
			addArea((-365, 980, 138.875), -60, 25, 0, "door", 16, 20);
			addArea((-410, 835, 138.875), 30, 25, 0, "door", 16, 20);
			addArea((625, 700, 136.125), -60, 25, 0, "door", 16, 20);
			addArea((180, -585, 136.125), 30, 25, 0, "door", 16, 20);
		break;
		case "mp_pipeline":
			/*data[0] = spawn("trigger_radius", (0, 900, 470.125), 0, 200, 200); // Roof bounce
			data[1] = spawn("trigger_radius", (0, 1200, 470.125), 0, 100, 100); // Roof bounce, point 2
			data[2] = spawn("trigger_radius", (-880, 1235, 340.125), 0, 15, 15); // 2 players, first corner
			data[3] = spawn("trigger_radius", (-65, 1235, 340.125), 0, 15, 15); // 2 players, second corner*/

			addArea((-1020, 2657, 0.125), 180, 20, 128, "high", 10, 10); // Fenced area
		break;
		case "mp_crash":
		case "mp_crash_snow":
			addBlock((240, -550, 405), 20, 105); // Satellite
			addBlock((320, -559, 405), 2, 128); // Antenna
			addBlock((-280, 1060, 419.125), 110, 256); // Attack balcony

			//data[0] = spawn("trigger_radius", (1365, -1320, 362.625), 0, 20, 20); // Sandbag roof to aerator
			//data[1] = spawn("trigger_radius", (505, -277.125, 405.125), 0, 25, 25); // To heli bounce
			//data[2] = spawn("trigger_radius", (1792.87, 1100, 560.125), 0, 200, 200); // From stacked roof to another house
		break;
		case "mp_bog":
			addArea((6135, 700, 23), -60, 35, 48, "high", 20, 20); // Barricaded area
			addBlock((7485, 500, -1500), 1200, 3000); // Under the bridge
			addBlock((6000, -27, 30), 4, 400); // Streetlight
		break;
		/*case "mp_showdown":
			data[0] = spawn("trigger_radius", (411.875, 1440, 164.54), 0, 10, 10); // Small bounce on the plank
			data[1] = spawn("trigger_radius", (-595, -330, 375), 0, 10, 10); // Stack to roof
		break;
		case "mp_vacant":
			data[0] = spawn("trigger_radius", (1110, 700, 125), 0, 30, 30); // Roof corner 1
			data[1] = spawn("trigger_radius", (1200, 700, 125), 0, 30, 30); // Roof corner 2
			data[2] = spawn("trigger_radius", (185, -50, 126.125), 0, 20, 20); // Bench to roof
		break;
		case "mp_bloc":
			data[0] = spawn("trigger_radius", (-1150, -4420, 74.125), 0, 15, 15); // Stair next to the swimming pool
			data[1] = spawn("trigger_radius", (-530, -6145, 74.125), 0, 15, 15); // Stair near the previous
			data[2] = spawn("trigger_radius", (3355, -7230, 74.125), 0, 15, 15); // Stair on another spawn
			data[3] = spawn("trigger_radius", (2735, -5500, 74.125), 0, 15, 15); // Stair near the previous
		break;
		case "mp_farm":
			data[0] = spawn("trigger_radius", (-535, -860, 424.125), 0, 10, 10); // Stack onto the top of the house
		break;
		case "mp_cargoship":
			data[0] = spawn("trigger_radius", (-320, -235, 344.125), 0, 30, 30); // Top of the ship, side #1
			data[1] = spawn("trigger_radius", (-3020, 235, 344.125), 0, 30, 30); // Top of the ship, side #2
		break;*/
	}

	// Player restrictions
	thread watchPlayer();

	// Check jumps
	/*for (i = 0; i < data.size; i++)
	{
		data[i] thread checkJumper();
	}*/

	// Default Team names - should be set for clients
	setDvar("g_teamname_axis", "Seekers");
	setDvar("g_teamname_allies", "Hiders");

	// Add models ordered, so we can generate a sprite for them
	level.modelID = 0;
	level.modelOrder = [];
	addOrderedModel("ap_couch01");
	addOrderedModel("bathroom_toilet");
	addOrderedModel("bc_hesco_barrier_med");
	addOrderedModel("bc_militarytent_wood_table");
	addOrderedModel("candy_cane");
	addOrderedModel("cargocontainer_20ft_red");
	addOrderedModel("ch_baby_carriage");
	addOrderedModel("ch_bedframemetal_dark");
	addOrderedModel("ch_bedframemetal_gray", "ch_bedframemetal_dark");
	addOrderedModel("ch_crate32x48");
	addOrderedModel("ch_crate48x64");
	addOrderedModel("ch_crate64x64");
	addOrderedModel("ch_dinerboothchair");
	addOrderedModel("ch_dinerboothtable");
	addOrderedModel("ch_dinercounterchair");
	addOrderedModel("ch_furniture_couch01");
	addOrderedModel("ch_furniture_couch02");
	addOrderedModel("ch_furniture_kids_chair1");
	addOrderedModel("ch_furniture_kids_desk1");
	addOrderedModel("ch_furniture_school_lunch_table");
	addOrderedModel("ch_furniture_teachers_chair1");
	addOrderedModel("ch_furniture_teachers_desk1");
	addOrderedModel("ch_gas_pump");
	addOrderedModel("ch_hayroll_02");
	addOrderedModel("ch_hayroll_03");
	addOrderedModel("ch_lawnmower");
	addOrderedModel("ch_mattress_2");
	addOrderedModel("ch_mattress_3");
	addOrderedModel("ch_missle_rack");
	addOrderedModel("ch_russian_table");
	addOrderedModel("ch_sign_noentry");
	addOrderedModel("ch_sign_noparking");
	addOrderedModel("ch_sign_nopedestrians");
	addOrderedModel("ch_sign_stopsign");
	addOrderedModel("ch_snack_machine_big_russia");
	addOrderedModel("ch_street_light_01_off");
	addOrderedModel("ch_tombstone2");
	addOrderedModel("ch_washer_01");
	addOrderedModel("com_armoire_d");
	addOrderedModel("com_barrel_biohazard_rust");
	addOrderedModel("com_barrel_black_rust");
	addOrderedModel("com_barrel_blue_rust");
	addOrderedModel("com_barrel_fire");
	addOrderedModel("com_barrel_green");
	addOrderedModel("com_barrel_green_dirt");
	addOrderedModel("com_barrel_green_rust");
	addOrderedModel("com_barrel_tan_rust");
	addOrderedModel("com_barrel_white_rust");
	addOrderedModel("com_barrier_tall1");
	addOrderedModel("com_basketball_goal");
	addOrderedModel("com_bench");
	addOrderedModel("com_bike");
	addOrderedModel("com_bomb_objective");
	addOrderedModel("com_bookshelves1_d");
	addOrderedModel("com_bookshelveswide");
	addOrderedModel("com_cafe_chair");
	addOrderedModel("com_cafe_chair2");
	addOrderedModel("com_cafe_table1");
	addOrderedModel("com_cafe_table2");
	addOrderedModel("com_cardboardbox01");
	addOrderedModel("com_clothing_rack_1");
	addOrderedModel("com_conference_table1");
	addOrderedModel("com_dresser");
	addOrderedModel("com_dresser_d");
	addOrderedModel("com_electrical_transformer");
	addOrderedModel("com_filecabinetblackclosed");
	addOrderedModel("com_folding_chair");
	addOrderedModel("com_folding_table");
	addOrderedModel("com_industrialtrashbin");
	addOrderedModel("com_ladder_wood");
	addOrderedModel("com_lamp_ornate_off");
	addOrderedModel("com_lamp_ornate_on", "com_lamp_ornate_off");
	addOrderedModel("com_mannequin3");
	addOrderedModel("com_metalbench");
	addOrderedModel("com_newspaperbox_blue");
	addOrderedModel("com_newspaperbox_red");
	addOrderedModel("com_northafrica_armoire_short");
	addOrderedModel("com_office_chair_black");
	addOrderedModel("com_pallet_stack");
	addOrderedModel("com_photocopier");
	addOrderedModel("com_plainchair");
	addOrderedModel("com_plasticcase_beige_big");
	addOrderedModel("com_playpen");
	addOrderedModel("com_powerpole1");
	addOrderedModel("com_powerpole3", "com_powerpole1");
	addOrderedModel("com_propane_tank02");
	addOrderedModel("com_restaurantchair_2");
	addOrderedModel("com_restaurantkitchentable_1");
	addOrderedModel("com_restaurantsink_1comp");
	addOrderedModel("com_restaurantsink_2comps");
	addOrderedModel("com_restaurantstainlessteelshelf_01");
	addOrderedModel("com_restaurantstainlessteelshelf_02");
	addOrderedModel("com_restaurantstove");
	addOrderedModel("com_restaurantstovewithburner");
	addOrderedModel("com_rowboat");
	addOrderedModel("com_server_rack_sid");
	addOrderedModel("com_shopping_cart");
	addOrderedModel("com_steel_ladder");
	addOrderedModel("com_stepladder_large");
	addOrderedModel("com_stove");
	addOrderedModel("com_stove_d");
	addOrderedModel("com_trashcan");
	addOrderedModel("com_trashcan_metal");
	addOrderedModel("com_trashcan_metal_with_trash");
	addOrderedModel("com_tv1");
	addOrderedModel("com_tv2");
	addOrderedModel("com_tv2_d");
	addOrderedModel("com_wagon_donkey");
	addOrderedModel("com_wagon_donkey_nohandle");
	addOrderedModel("com_water_heater");
	addOrderedModel("com_wheelbarrow");
	addOrderedModel("com_woodlog_24_192_d");
	addOrderedModel("cs_monitor1");
	addOrderedModel("cs_steeringwheel");
	addOrderedModel("cs_tow_hook");
	addOrderedModel("ct_china_vase");
	addOrderedModel("ct_statue_chinese_lion");
	addOrderedModel("ct_statue_chinese_lion_gold");
	addOrderedModel("ct_statue_chineselionstonebase");
	addOrderedModel("ct_street_lamp_on");
	addOrderedModel("foliage_dead_pine_med");
	addOrderedModel("foliage_dead_pine_sm");
	addOrderedModel("foliage_dead_pine_xl");
	addOrderedModel("foliage_red_pine_lg");
	addOrderedModel("foliage_tree_grey_oak_lg_a");
	addOrderedModel("foliage_tree_grey_oak_sm_a");
	addOrderedModel("foliage_tree_palm_bushy_1");
	addOrderedModel("foliage_tree_palm_bushy_1_static", "foliage_tree_palm_bushy_1");
	addOrderedModel("foliage_tree_palm_bushy_2");
	addOrderedModel("foliage_tree_palm_bushy_3");
	addOrderedModel("foliage_tree_palm_bushy_3_static", "foliage_tree_palm_bushy_3");
	addOrderedModel("foliage_tree_river_birch_lg_a");
	addOrderedModel("foliage_tree_river_birch_xl_a");
	addOrderedModel("giftbox_01");
	addOrderedModel("me_ac_big");
	addOrderedModel("me_ac_window");
	addOrderedModel("me_antenna");
	addOrderedModel("me_antenna2");
	addOrderedModel("me_antenna3");
	addOrderedModel("me_basket_rattan01");
	addOrderedModel("me_basket_wicker05");
	addOrderedModel("me_concrete_barrier");
	addOrderedModel("me_construction_dumpster_close");
	addOrderedModel("me_construction_dumpster_open");
	addOrderedModel("me_corrugated_metal8x8");
	addOrderedModel("me_dumpster");
	addOrderedModel("me_dumpster_close");
	addOrderedModel("me_gas_pump");
	addOrderedModel("me_market_stand1");
	addOrderedModel("me_market_stand4");
	addOrderedModel("me_market_umbrella_3");
	addOrderedModel("me_market_umbrella_5");
	addOrderedModel("me_market_umbrella_6");
	addOrderedModel("me_phonebooth");
	addOrderedModel("me_refrigerator");
	addOrderedModel("me_refrigerator2");
	addOrderedModel("me_refrigerator_d");
	addOrderedModel("me_satellitedish");
	addOrderedModel("me_sign_noentry");
	addOrderedModel("me_sign_stop");
	addOrderedModel("me_streetlight");
	addOrderedModel("me_streetlight_on");
	addOrderedModel("me_streetlightdual");
	addOrderedModel("me_telegraphpole");
	addOrderedModel("me_telegraphpole2");
	addOrderedModel("me_wood_cage_large");
	addOrderedModel("mil_bunker_bed1");
	addOrderedModel("mil_bunker_bed2");
	addOrderedModel("mil_bunker_bed3");
	addOrderedModel("mil_sandbag_desert_corner");
	addOrderedModel("mil_sandbag_desert_curved");
	addOrderedModel("mil_sandbag_desert_end_left");
	addOrderedModel("mil_sandbag_desert_long");
	addOrderedModel("prop_fishmarket_lobster_box");
	addOrderedModel("prop_misc_rock_boulder_04");
	addOrderedModel("prop_misc_rock_boulder_snow_05");
	addOrderedModel("seeker");
	addOrderedModel("snow_tree_lights01");
	addOrderedModel("snowman");
	addOrderedModel("tvs_cubicle_round_1");
	addOrderedModel("vehicle_80s_hatch1_brn_destroyed");
	addOrderedModel("vehicle_80s_hatch1_green_destroyed");
	addOrderedModel("vehicle_80s_hatch1_greendest");
	addOrderedModel("vehicle_80s_hatch1_red_destroyed");
	addOrderedModel("vehicle_80s_hatch1_red_destructible_mp");
	addOrderedModel("vehicle_80s_hatch1_reddest");
	addOrderedModel("vehicle_80s_hatch1_silvdest");
	addOrderedModel("vehicle_80s_hatch1_tandest");
	addOrderedModel("vehicle_80s_sedan1_brn");
	addOrderedModel("vehicle_80s_sedan1_green");
	addOrderedModel("vehicle_80s_sedan1_green_destroyed");
	addOrderedModel("vehicle_80s_sedan1_green_destructible_mp", "vehicle_80s_sedan1_green");
	addOrderedModel("vehicle_80s_sedan1_red");
	addOrderedModel("vehicle_80s_sedan1_red_destructible_mp", "vehicle_80s_sedan1_red");
	addOrderedModel("vehicle_80s_sedan1_reddest");
	addOrderedModel("vehicle_80s_sedan1_silv");
	addOrderedModel("vehicle_80s_sedan1_silv_destroyed");
	addOrderedModel("vehicle_80s_sedan1_silv_destructible_mp", "vehicle_80s_sedan1_silv");
	addOrderedModel("vehicle_80s_sedan1_tandest");
	addOrderedModel("vehicle_80s_sedan1_yel_destructible_mp");
	addOrderedModel("vehicle_80s_sedan1_yeldest");
	addOrderedModel("vehicle_80s_wagon1_red_destroyed");
	addOrderedModel("vehicle_80s_wagon1_silvdest");
	addOrderedModel("vehicle_80s_wagon1_tandest");
	addOrderedModel("vehicle_80s_wagon1_yel_destroyed");
	addOrderedModel("vehicle_80s_wagon1_yel_destructible_mp");
	addOrderedModel("vehicle_bm21_mobile_cover_dstry_static");
	addOrderedModel("vehicle_bmp_dsty_static");
	addOrderedModel("vehicle_bmp_woodland_dsty_static");
	addOrderedModel("vehicle_bulldozer");
	addOrderedModel("vehicle_bus_destructable");
	addOrderedModel("vehicle_delivery_truck");
	addOrderedModel("vehicle_humvee_camo_static");
	addOrderedModel("vehicle_m1a1_abrams_d_static");
	addOrderedModel("vehicle_m1a1_abrams_dmg", "vehicle_m1a1_abrams_d_static");
	addOrderedModel("vehicle_pickup_nodoor_static");
	addOrderedModel("vehicle_pickup_roobars");
	addOrderedModel("vehicle_pickup_technical_destroyed");
	addOrderedModel("vehicle_pickup_technical_destroyed_static", "vehicle_pickup_technical_destroyed");
	addOrderedModel("vehicle_sa6_static_woodland");
	addOrderedModel("vehicle_semi_truck_cargo");
	addOrderedModel("vehicle_small_hatchback_blue_static");
	addOrderedModel("vehicle_small_wagon_d_white");
	addOrderedModel("vehicle_tanker_truck");
	addOrderedModel("vehicle_tanker_truck_civ");
	addOrderedModel("vehicle_tanker_truck_d");
	addOrderedModel("vehicle_tractor");
	addOrderedModel("vehicle_tractor_2");
	addOrderedModel("vehicle_uaz_fabric_dsr");
	addOrderedModel("vehicle_uaz_hardtop");
	addOrderedModel("vehicle_uaz_hardtop_dsr");
	addOrderedModel("vehicle_uaz_hardtop_static", "vehicle_uaz_hardtop");
	addOrderedModel("vehicle_uaz_light_dsr");
	addOrderedModel("vehicle_uaz_van");
	addOrderedModel("vehicle_zpu4_burn_static");
	addOrderedModel("wetwork_grave3");
	addOrderedModel("mil_razorwire_long_static");
	addOrderedModel("com_walltable2");

	// Localized strings
	maps\mp\gametypes\_str::main();

	// Hardcoded strings
	level.s["seek_time"] = "Seeking time";
	level.s["map_time"] = "Starting new map...";
	level.s["round_time"] = "New round";
	level.s["hide_time"] = "Hiding time";
	/*level.s["seek_time"] = &"MENUS_SEEK_TIME";
	level.s["map_time"] = &"MENUS_MAP_TIME";
	level.s["round_time"] = &"MENUS_ROUND_TIME";
	level.s["hide_time"] = &"MENUS_HIDE_TIME";*/

	// English
	level.s["killstreak"] = &"MENUS_KILLSTREAK";
	level.s["mis_last"] = &"MISSIONS_LAST";
	level.s["mis_fast"] = &"MISSIONS_FAST";
	level.s["mis_streak"] = &"MISSIONS_STREAK";
	level.s["mis_close"] = &"MISSIONS_CLOSE";
	level.s["mis_kill"] = &"MISSIONS_KILL";
	level.s["mis_rev"] = &"MISSIONS_REV";
	level.s["mis_first"] = &"MISSIONS_FIRST";
	level.s["mis_knife"] = &"MISSIONS_KNIFE";
	level.s["mis_hide"] = &"MISSIONS_HIDE";
	level.s["mis_map"] = &"MISSIONS_MAP";
	level.s["mis_stun"] = &"MISSIONS_STUN";
	level.s["mis_rock"] = &"MISSIONS_ROCK";
	level.s["mis_time"] = &"MISSIONS_TIME";
	level.s["mis_vis"] = &"MISSIONS_VIS";

	// Hungarian
	level.s["killstreak_hu"] = &"MENUS_KILLSTREAK_HU";
	level.s["mis_last_hu"] = &"MISSIONS_LAST_HU";
	level.s["mis_fast_hu"] = &"MISSIONS_FAST_HU";
	level.s["mis_streak_hu"] = &"MISSIONS_STREAK_HU";
	level.s["mis_close_hu"] = &"MISSIONS_CLOSE_HU";
	level.s["mis_kill_hu"] = &"MISSIONS_KILL_HU";
	level.s["mis_rev_hu"] = &"MISSIONS_REV_HU";
	level.s["mis_first_hu"] = &"MISSIONS_FIRST_HU";
	level.s["mis_knife_hu"] = &"MISSIONS_KNIFE_HU";
	level.s["mis_hide_hu"] = &"MISSIONS_HIDE_HU";
	level.s["mis_map_hu"] = &"MISSIONS_MAP_HU";
	level.s["mis_stun_hu"] = &"MISSIONS_STUN_HU";
	level.s["mis_rock_hu"] = &"MISSIONS_ROCK_HU";
	level.s["mis_time_hu"] = &"MISSIONS_TIME_HU";
	level.s["mis_vis_hu"] = &"MISSIONS_VIS_HU";

	// Dutch
	level.s["killstreak_nl"] = &"MENUS_KILLSTREAK_NL";
	level.s["mis_last_nl"] = &"MISSIONS_LAST_NL";
	level.s["mis_fast_nl"] = &"MISSIONS_FAST_NL";
	level.s["mis_streak_nl"] = &"MISSIONS_STREAK_NL";
	level.s["mis_close_nl"] = &"MISSIONS_CLOSE_NL";
	level.s["mis_kill_nl"] = &"MISSIONS_KILL_NL";
	level.s["mis_rev_nl"] = &"MISSIONS_REV_NL";
	level.s["mis_first_nl"] = &"MISSIONS_FIRST_NL";
	level.s["mis_knife_nl"] = &"MISSIONS_KNIFE_NL";
	level.s["mis_hide_nl"] = &"MISSIONS_HIDE_NL";
	level.s["mis_map_nl"] = &"MISSIONS_MAP_NL";
	level.s["mis_stun_nl"] = &"MISSIONS_STUN_NL";
	level.s["mis_rock_nl"] = &"MISSIONS_ROCK_NL";
	level.s["mis_time_nl"] = &"MISSIONS_TIME_NL";
	level.s["mis_vis_nl"] = &"MISSIONS_VIS_NL";

	// Slovak
	level.s["killstreak_sk"] = &"MENUS_KILLSTREAK_SK";
	level.s["mis_last_sk"] = &"MISSIONS_LAST_SK";
	level.s["mis_fast_sk"] = &"MISSIONS_FAST_SK";
	level.s["mis_streak_sk"] = &"MISSIONS_STREAK_SK";
	level.s["mis_close_sk"] = &"MISSIONS_CLOSE_SK";
	level.s["mis_kill_sk"] = &"MISSIONS_KILL_SK";
	level.s["mis_rev_sk"] = &"MISSIONS_REV_SK";
	level.s["mis_first_sk"] = &"MISSIONS_FIRST_SK";
	level.s["mis_knife_sk"] = &"MISSIONS_KNIFE_SK";
	level.s["mis_hide_sk"] = &"MISSIONS_HIDE_SK";
	level.s["mis_map_sk"] = &"MISSIONS_MAP_SK";
	level.s["mis_stun_sk"] = &"MISSIONS_STUN_SK";
	level.s["mis_rock_sk"] = &"MISSIONS_ROCK_SK";
	level.s["mis_time_sk"] = &"MISSIONS_TIME_SK";
	level.s["mis_vis_sk"] = &"MISSIONS_VIS_SK";

	// Croatian
	level.s["killstreak_hr"] = &"MENUS_KILLSTREAK_HR";
	level.s["mis_last_hr"] = &"MISSIONS_LAST_HR";
	level.s["mis_fast_hr"] = &"MISSIONS_FAST_HR";
	level.s["mis_streak_hr"] = &"MISSIONS_STREAK_HR";
	level.s["mis_close_hr"] = &"MISSIONS_CLOSE_HR";
	level.s["mis_kill_hr"] = &"MISSIONS_KILL_HR";
	level.s["mis_rev_hr"] = &"MISSIONS_REV_HR";
	level.s["mis_first_hr"] = &"MISSIONS_FIRST_HR";
	level.s["mis_knife_hr"] = &"MISSIONS_KNIFE_HR";
	level.s["mis_hide_hr"] = &"MISSIONS_HIDE_HR";
	level.s["mis_map_hr"] = &"MISSIONS_MAP_HR";
	level.s["mis_stun_hr"] = &"MISSIONS_STUN_HR";
	level.s["mis_rock_hr"] = &"MISSIONS_ROCK_HR";
	level.s["mis_time_hr"] = &"MISSIONS_TIME_HR";
	level.s["mis_vis_hr"] = &"MISSIONS_VIS_HR";

	// Turkish
	level.s["killstreak_tr"] = &"MENUS_KILLSTREAK_TR";
	level.s["mis_last_tr"] = &"MISSIONS_LAST_TR";
	level.s["mis_fast_tr"] = &"MISSIONS_FAST_TR";
	level.s["mis_streak_tr"] = &"MISSIONS_STREAK_TR";
	level.s["mis_close_tr"] = &"MISSIONS_CLOSE_TR";
	level.s["mis_kill_tr"] = &"MISSIONS_KILL_TR";
	level.s["mis_rev_tr"] = &"MISSIONS_REV_TR";
	level.s["mis_first_tr"] = &"MISSIONS_FIRST_TR";
	level.s["mis_knife_tr"] = &"MISSIONS_KNIFE_TR";
	level.s["mis_hide_tr"] = &"MISSIONS_HIDE_TR";
	level.s["mis_map_tr"] = &"MISSIONS_MAP_TR";
	level.s["mis_stun_tr"] = &"MISSIONS_STUN_TR";
	level.s["mis_rock_tr"] = &"MISSIONS_ROCK_TR";
	level.s["mis_time_tr"] = &"MISSIONS_TIME_TR";
	level.s["mis_vis_tr"] = &"MISSIONS_VIS_TR";

	// German
	level.s["killstreak_de"] = &"MENUS_KILLSTREAK_DE";
	level.s["mis_last_de"] = &"MISSIONS_LAST_DE";
	level.s["mis_fast_de"] = &"MISSIONS_FAST_DE";
	level.s["mis_streak_de"] = &"MISSIONS_STREAK_DE";
	level.s["mis_close_de"] = &"MISSIONS_CLOSE_DE";
	level.s["mis_kill_de"] = &"MISSIONS_KILL_DE";
	level.s["mis_rev_de"] = &"MISSIONS_REV_DE";
	level.s["mis_first_de"] = &"MISSIONS_FIRST_DE";
	level.s["mis_knife_de"] = &"MISSIONS_KNIFE_DE";
	level.s["mis_hide_de"] = &"MISSIONS_HIDE_DE";
	level.s["mis_map_de"] = &"MISSIONS_MAP_DE";
	level.s["mis_stun_de"] = &"MISSIONS_STUN_DE";
	level.s["mis_rock_de"] = &"MISSIONS_ROCK_DE";
	level.s["mis_time_de"] = &"MISSIONS_TIME_DE";
	level.s["mis_vis_de"] = &"MISSIONS_VIS_DE";

	// French
	level.s["killstreak_fr"] = &"MENUS_KILLSTREAK_FR";
	level.s["mis_last_fr"] = &"MISSIONS_LAST_FR";
	level.s["mis_fast_fr"] = &"MISSIONS_FAST_FR";
	level.s["mis_streak_fr"] = &"MISSIONS_STREAK_FR";
	level.s["mis_close_fr"] = &"MISSIONS_CLOSE_FR";
	level.s["mis_kill_fr"] = &"MISSIONS_KILL_FR";
	level.s["mis_rev_fr"] = &"MISSIONS_REV_FR";
	level.s["mis_first_fr"] = &"MISSIONS_FIRST_FR";
	level.s["mis_knife_fr"] = &"MISSIONS_KNIFE_FR";
	level.s["mis_hide_fr"] = &"MISSIONS_HIDE_FR";
	level.s["mis_map_fr"] = &"MISSIONS_MAP_FR";
	level.s["mis_stun_fr"] = &"MISSIONS_STUN_FR";
	level.s["mis_rock_fr"] = &"MISSIONS_ROCK_FR";
	level.s["mis_time_fr"] = &"MISSIONS_TIME_FR";
	level.s["mis_vis_fr"] = &"MISSIONS_VIS_FR";

	// Polish
	level.s["killstreak_pl"] = &"MENUS_KILLSTREAK_PL";
	level.s["mis_last_pl"] = &"MISSIONS_LAST_PL";
	level.s["mis_fast_pl"] = &"MISSIONS_FAST_PL";
	level.s["mis_streak_pl"] = &"MISSIONS_STREAK_PL";
	level.s["mis_close_pl"] = &"MISSIONS_CLOSE_PL";
	level.s["mis_kill_pl"] = &"MISSIONS_KILL_PL";
	level.s["mis_rev_pl"] = &"MISSIONS_REV_PL";
	level.s["mis_first_pl"] = &"MISSIONS_FIRST_PL";
	level.s["mis_knife_pl"] = &"MISSIONS_KNIFE_PL";
	level.s["mis_hide_pl"] = &"MISSIONS_HIDE_PL";
	level.s["mis_map_pl"] = &"MISSIONS_MAP_PL";
	level.s["mis_stun_pl"] = &"MISSIONS_STUN_PL";
	level.s["mis_rock_pl"] = &"MISSIONS_ROCK_PL";
	level.s["mis_time_pl"] = &"MISSIONS_TIME_PL";
	level.s["mis_vis_pl"] = &"MISSIONS_VIS_PL";

	// Czech
	level.s["killstreak_cs"] = &"MENUS_KILLSTREAK_CS";
	level.s["mis_last_cs"] = &"MISSIONS_LAST_CS";
	level.s["mis_fast_cs"] = &"MISSIONS_FAST_CS";
	level.s["mis_streak_cs"] = &"MISSIONS_STREAK_CS";
	level.s["mis_close_cs"] = &"MISSIONS_CLOSE_CS";
	level.s["mis_kill_cs"] = &"MISSIONS_KILL_CS";
	level.s["mis_rev_cs"] = &"MISSIONS_REV_CS";
	level.s["mis_first_cs"] = &"MISSIONS_FIRST_CS";
	level.s["mis_knife_cs"] = &"MISSIONS_KNIFE_CS";
	level.s["mis_hide_cs"] = &"MISSIONS_HIDE_CS";
	level.s["mis_map_cs"] = &"MISSIONS_MAP_CS";
	level.s["mis_stun_cs"] = &"MISSIONS_STUN_CS";
	level.s["mis_rock_cs"] = &"MISSIONS_ROCK_CS";
	level.s["mis_time_cs"] = &"MISSIONS_TIME_CS";
	level.s["mis_vis_cs"] = &"MISSIONS_VIS_CS";

	// Snipers (r700 & m40a3 & m14 with different ammo)
	level.weapons = [];
	level.weapons[0][0] = "remington700_mp";
	level.weapons[0][1] = "dragunov_mp";
	level.weapons[0][2] = "m21_mp";
	level.weapons[1][0] = "m40a3_mp";
	level.weapons[1][1] = "barrett_mp";
	level.weapons[1][2] = "rpd_mp";
	level.weapons[2][0] = "m14_reflex_mp";
	level.weapons[2][1] = "m14_mp";
	level.weapons[2][2] = "m14_silencer_mp";

	// Map
	level.map = 0;
	switch (level.script)
	{
		case "mp_backlot":
			level.map = 1;
		break;
		case "mp_bloc":
			level.map = 2;
		break;
		case "mp_bog":
			level.map = 4;
		break;
		case "mp_broadcast":
			level.map = 8;
		break;
		case "mp_carentan":
			level.map = 16;
		break;
		case "mp_cargoship":
			level.map = 32;
		break;
		case "mp_citystreets":
			level.map = 64;
		break;
		case "mp_convoy":
			level.map = 128;
		break;
		case "mp_countdown":
			level.map = 256;
		break;
		case "mp_crash":
			level.map = 512;
		break;
		case "mp_crash_snow":
			level.map = 1024;
		break;
		case "mp_creek":
			level.map = 2048;
		break;
		case "mp_crossfire":
			level.map = 4096;
		break;
		case "mp_farm":
			level.map = 8192;
		break;
		case "mp_killhouse":
			level.map = 16384;
		break;
		case "mp_overgrown":
			level.map = 32768;
		break;
		case "mp_pipeline":
			level.map = 65536;
		break;
		case "mp_shipment":
			level.map = 131072;
		break;
		case "mp_showdown":
			level.map = 262144;
		break;
		case "mp_strike":
			level.map = 524288;
		break;
		case "mp_vacant":
			level.map = 1048576;
		break;
		/*case "mp_cluster":
			level.map = 2097152;
		break;
		case "mp_backyard":
			level.map = 4194304;
		break;*/
		/*case "mp_hns_impact":
			level.map = 8388608;
		break;*/
	}

	// Active players
	level.activePlayers = [];

	// Dropped moneys
	level.money = [];

	// Care packages
	level.care = [];
	level.pack = [];
	level.pack["allies"] = [];
	level.pack["axis"] = [];
	level.pack["allies"][0] = ::giveSmoke;
	level.pack["allies"][1] = ::giveXP;
	level.pack["axis"][0] = ::seekerPackage;
	level.pack["axis"][1] = ::giveXP;

	// IP
	level.ip = getDvar("net_ip") + ":" + getDvar("net_port");

	// Stat
	if (!isDefined(level.stat))
	{
		level.statID = getDvarInt("stat");

		if (level.statID < 1 || level.statID > 1121)
			error("stat dvar must be between 1 and 1121!");

		// It is needed, because stats are defined abnormally, and since it is set to many players, I cant modify it.
		// There are many more free stat slots between the used ones if needed!
		if (level.statID < 800)
			level.stat = level.statID + 2354;
		else
			level.stat = level.statID + 2377;

		// Probably Ninja serverfile ignores the generated error, so I patch it for [AR51]
		if (!level.statID)
			level.statID = -1;
	}

	// Admin password
	level.admin = [];
	a = getDvar("admin1_pass");
	for (i = 1; a != ""; i++)
	{
		level.admin[a] = getDvar("admin" + i + "_perm");
		a = getDvar("admin" + (i + 1) + "_pass");
	}

	// Encoding algorithm
	level.code = strTok(toLower(getDvar("code")), ".");

	// Game variables
	level.alreadyPlay = false;
	level.gameStarted = false;
	level.oneLeft = false;
	level.jammer = false;
	level.voting = false;

	// Avoid reconnecters
	level.reconnect = [];

	// Check if friendly players are blocking us
	level.friendlyBlock = maps\mp\gametypes\_ext::isFriendlyBlock();

	// Max jump height - There are bigger differences above,
	// that's why we must measure the first 46.1 separated.
	level.maxJump = 46.1 + (getDvarInt("jump_height") - 39) * 1.2;

	// No last model displayed when one hider left
	level.lastModel = getDvarInt("scr_hns_nolastmodel") <= 0;

	// Ready-Up system
	level.readyUp = getDvarInt("scr_hns_readyup") > 0;

	// Clan name defense
	a = getDvar("namedefend");
	if (a != "")
	{
		b = strTok(toLower(a), " ");
		c = b.size;
		for (i = 0; i < c; i++)
			level.nameDefend[b[i]] = true;

		level.nameProtect = getDvar("nameprotect");
	}

	if (getDvar("redirectfull") != "")
		level.redirect = getDvar("redirectfull");

	// Configurable map-specific settings
	level.defaults["maxtime_mp_backlot"] = 390;
	level.defaults["mintime_mp_backlot"] = 270;
	level.defaults["difftime_mp_backlot"] = 3;

	level.defaults["maxtime_mp_backyard"] = 420;
	level.defaults["mintime_mp_backyard"] = 292;
	level.defaults["difftime_mp_backyard"] = 4;

	level.defaults["maxtime_mp_bloc"] = 390;
	level.defaults["mintime_mp_bloc"] = 270;
	level.defaults["difftime_mp_bloc"] = 3;

	level.defaults["maxtime_mp_bog"] = 300;
	level.defaults["mintime_mp_bog"] = 236;
	level.defaults["difftime_mp_bog"] = 2;

	level.defaults["maxtime_mp_broadcast"] = 390;
	level.defaults["mintime_mp_broadcast"] = 270;
	level.defaults["difftime_mp_broadcast"] = 3;

	level.defaults["maxtime_mp_carentan"] = 330;
	level.defaults["mintime_mp_carentan"] = 298;
	level.defaults["difftime_mp_carentan"] = 1;

	level.defaults["maxtime_mp_cargoship"] = 200;
	level.defaults["mintime_mp_cargoship"] = 168;
	level.defaults["difftime_mp_cargoship"] = 1;

	level.defaults["maxtime_mp_citystreets"] = 420;
	level.defaults["mintime_mp_citystreets"] = 292;
	level.defaults["difftime_mp_citystreets"] = 4;

	level.defaults["maxtime_mp_cluster"] = 300;
	level.defaults["mintime_mp_cluster"] = 236;
	level.defaults["difftime_mp_cluster"] = 2;

	level.defaults["maxtime_mp_convoy"] = 330;
	level.defaults["mintime_mp_convoy"] = 266;
	level.defaults["difftime_mp_convoy"] = 2;

	level.defaults["maxtime_mp_countdown"] = 300;
	level.defaults["mintime_mp_countdown"] = 236;
	level.defaults["difftime_mp_countdown"] = 2;

	level.defaults["maxtime_mp_crash"] = 360;
	level.defaults["mintime_mp_crash"] = 264;
	level.defaults["difftime_mp_crash"] = 3;

	level.defaults["maxtime_mp_crash_snow"] = 360;
	level.defaults["mintime_mp_crash_snow"] = 236;
	level.defaults["difftime_mp_crash_snow"] = 3;

	level.defaults["maxtime_mp_creek"] = 390;
	level.defaults["mintime_mp_creek"] = 270;
	level.defaults["difftime_mp_creek"] = 3;

	level.defaults["maxtime_mp_crossfire"] = 390;
	level.defaults["mintime_mp_crossfire"] = 294;
	level.defaults["difftime_mp_crossfire"] = 3;

	level.defaults["maxtime_mp_farm"] = 330;
	level.defaults["mintime_mp_farm"] = 266;
	level.defaults["difftime_mp_farm"] = 2;

	level.defaults["maxtime_mp_fav"] = 420;
	level.defaults["mintime_mp_fav"] = 292;
	level.defaults["difftime_mp_fav"] = 4;

	level.defaults["maxtime_mp_overgrown"] = 480;
	level.defaults["mintime_mp_overgrown"] = 384;
	level.defaults["difftime_mp_overgrown"] = 3;

	level.defaults["maxtime_mp_strike"] = 330;
	level.defaults["mintime_mp_strike"] = 236;
	level.defaults["difftime_mp_strike"] = 2;

	level.defaults["maxtime_mp_vacant"] = 300;
	level.defaults["mintime_mp_vacant"] = 236;
	level.defaults["difftime_mp_vaccant"] = 2;

	level.defaults["maxtime_mp_pipeline"] = 390;
	level.defaults["mintime_mp_pipeline"] = 360;
	level.defaults["difftime_mp_pipeline"] = 1;

	level.defaults["maxtime_mp_showdown"] = 180;
	level.defaults["mintime_mp_showdown"] = 160;
	level.defaults["difftime_mp_showdown"] = 1;

	level.defaults["maxtime_mp_killhouse"] = 120;
	level.defaults["mintime_mp_killhouse"] = 80;
	level.defaults["hidetime_mp_killhouse"] = 45;

	level.defaults["maxtime_mp_shipment"] = 60;
	level.defaults["mintime_mp_shipment"] = 45;
	level.defaults["difftime_mp_shipment"] = 1;
	level.defaults["hidetime_mp_shipment"] = 30;

	// Get map specific settings
	level.mapTime = regDvar(level.mapTime, "maptime", 20); // Map loading time
	level.roundTime = regDvar(level.roundTime, "roundtime", 4); // Round time
	level.timer = regDvar(level.timer, "maxtime", 360); // Seeking time
	level.mintime = regDvar(level.mintime, "mintime", 180); // Minimum seeking time
	level.difftime = regDvar(level.difftime, "difftime", 5); // How many seconds a player matters in seeking time
	level.hidetimer = regDvar(level.hidetimer, "hidetime", 60); // Hiding time
	level.hurryTime = regDvar(level.hurryTime, "hurrytime", 60); // Hurry time (Beep and last hider alert)
	level.defaultModel = regDvar(level.defaultModel, "defaultmodel", "com_pallet_stack", true); // Default model
	level.scoreLimit = regDvar(level.scoreLimit, "scorelimit", 3); // Score limit

	// Get non-zero global settings
	level.AFKTime = regGlobal("afktime", 30); // AFK Time
	level.kickWarn = regGlobal("warnkick", 3); // Kick player after # warns

	// Get boolean global settings
	level.statProtect = getDvarInt("scr_hns_statprotect") > 0; // Stat transport protection
	level.stealProtect = getDvarInt("scr_hns_stealprotect") > 0; // Against file downloading

	// Start!
	thread stratTime();
}

addOrderedModel(s, src)
{
	if (isDefined(src))
	{
		level.modelOrder[s] = level.modelOrder[src];
	}
	else
	{
		level.modelOrder[s] = level.modelID;
		level.modelID++;
	}
}

modelOnMap(s)
{
	return isDefined(level.hasModel[s]);
}

spawnLadder(origin, angles)
{
	level.ladder = spawn("script_model", origin);
	level.ladder.angles = angles;
	level.ladder setModel("com_steel_ladder");
}

// 248 models can be in stats (8 stats).
addExtModel(map, model, price)
{
	id = level.ext.size;

	level.ext[id] = spawnStruct();
	level.ext[id].map = map;
	level.ext[id].model = model;
	level.ext[id].price = int(price * level.visratio);

	if (id) // Not the first
	{
		if (level.ext[id - 1].statval == 1073741824) // Max
		{
			level.ext[id].stat = level.ext[id - 1].stat + 1;
			level.ext[id].statval = 1;
		}
		else // Free space left
		{
			level.ext[id].stat = level.ext[id - 1].stat;
			level.ext[id].statval = level.ext[id - 1].statval * 2;
		}
	}
	else // First
	{
		level.ext[id].stat = 0; // 3158
		level.ext[id].statval = 1;
	}

	level.hasModel[model] = true;
}

// Origin, angles, distance, elevation, width, height
addArea(o, a, d, e, s, w, h)
{
	if (!isDefined(h))
		h = w;

	t = createArea(o, w, h, a, d, e, s);

	/#
	if (level.dev)
		addDebugArea(t, o, w, h, a, d, e, s);
	#/
}

goToArea()
{
	while (true)
	{
		self waittill("trigger", p);

		if (vectorDot(p.origin - self.origin, anglesToForward(p.angles)) < 0 && !p.climbing && p getStance() == "stand" && (p.team != "allies" || p.showmodel != "seeker" || p.modelID != 5))
		{
			a = p.angles[1] - self.angle;
			if (a > 180)
				a -= 360;
			else if (a < -180)
				a += 360;

			forward = abs(a) <= 20;
			if ((forward || abs(invertAngle(a)) <= 20))
			{
				if (p useButtonPressed())
					p thread climbToArea(self, forward);
				else
					p thread areaMessage();
			}
		}
	}
}

areaMessage()
{
	self notify("areamessage");
	self endon("areamessage");

	if (!isDefined(self.areamessage))
	{
		self.areamessage = true;
		self setClientDvar("trigger_msg", level.s["CLIMB_TRIGGER" + self.lang]);
	}

	wait 0.05;
	self.areamessage = undefined;
	self setClientDvar("trigger_msg", "");
}

invertAngle(a)
{
	if (a > 0)
		return a - 180;
	else
		return a + 180;
}

#using_animtree("multiplayer");
climbToArea(t, forward)
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn");

	if (self.team == "axis")
		self protectPlayer();

	self.climbing = true;
	self.climbanim = self.team == "axis" || self.showmodel == "seeker";

	if (self.climbanim)
	{
		if (!self.thirdperson)
			self setClientDvar("cg_thirdperson", 1);

		self.climb_w = self getCurrentWeapon();
		if (self.climb_w != "none")
		{
			self.climb_clip = self getWeaponAmmoClip(self.climb_w);
			self.climb_stock = self getWeaponAmmoStock(self.climb_w);
			self takeWeapon(self.climb_w);
		}
		self.tempw = "hns_" + t.style + "_mp";
		self giveWeapon(self.tempw);
		self switchToWeapon(self.tempw);
	}

	if (forward)
		ang = t.angle;
	else
		ang = invertAngle(t.angle);

	forward = undefined;

	self setPlayerAngles((self getPlayerAngles()[0], ang, 0));
	self freezeControls(true);

	obj = spawn("script_model", self.origin);
	obj setModel("tag_origin");
	self linkTo(obj);

	switch (t.style)
	{
		case "climb": 
			len = getAnimLength(%pb_climbup);
			obj moveTo(self.origin + (0, 0, t.elevation), len);
			wait len;
			self endClimbing();
			obj moveTo(t.origin + (0, 0, t.elevation) + anglesToForward((0, ang, 0)) * t.dist, 0.2);
			wait 0.2;
		break;
		case "high":
			len = getAnimLength(%mp_mantle_over_high) / 2;
			obj moveTo(t.origin + (0, 0, t.elevation), len);
			wait len;
			obj moveTo(t.origin + anglesToForward((0, ang, 0)) * t.dist, len);
			wait len;
			self endClimbing();
		break;
		case "door":
			len = getAnimLength(%pb_stumble_forward) / 2;
			obj moveTo(t.origin + (0, 0, t.elevation), len);
			wait len;
			obj moveTo(t.origin + anglesToForward((0, ang, 0)) * t.dist, len);
			wait len;
			self endClimbing();
		break;
	}

	self.climbing = false;

	if (!isDefined(level.fade) || !isDefined(level.fade.owner) || level.fade.owner != self)
		self freezeControls(false);

	self unLink();
	obj delete();

	if (self.team == "axis")
	{
		wait 2;
		self unProtectPlayer();
	}
}

endClimbing()
{
	if (self.climbanim)
	{
		self takeWeapon(self.tempw);
		self.tempw = undefined;

		if (self.climb_w != "none")
		{
			if (self.team == "axis" || self.showmodel != "seeker")
			{
				self giveWeapon(self.climb_w, self getCamo());
				self setWeaponAmmoClip(self.climb_w, self.climb_clip);
				self setWeaponAmmoStock(self.climb_w, self.climb_stock);
				self switchToWeapon(self.climb_w);
			}

			self.climb_w  = undefined;
			self.climb_clip  = undefined;
			self.climb_stock  = undefined;
		}

		if (!self.thirdperson)
		{
			wait 0.05;
			self setClientDvar("cg_thirdperson", 0);
		}
	}
	self.climbanim = undefined;
}

createArea(o, w, h, a, d, e, s)
{
	t = spawn("trigger_radius", o, 0, w, h);
	t.angle = a;
	t.dist = d;
	t.elevation = e;
	t.style = s;

	t.fx = playLoopedFX(level.rayFX, 4, t.origin);

	// If we are in real game, we need triggers to check,
	// if the knifed seeker is in one of these or not
	// Safeareas won't work in hns_developer with bots
	/*if (!level.dev) // Safearea is deprecated
	{
		level.areas[level.areaCount] = spawn("trigger_radius", o, 0, 75, 8);
		level.areaCount++;
	}*/

	t thread goToArea();

	return t;
}

createBlock(o, w, h)
{
	t = spawn("trigger_radius", o, 0, w, h);
	t setContents(1);

	return t;
}

createJump(o, w, h)
{
	t = spawn("trigger_radius", o, 0, w, h);
	t thread checkJumper();

	return t;
}

addJump(o, w, h)
{
	if (!isDefined(h))
		h = w;

	a = createJump(o, w, h);

	/#
	if (level.dev)
		addDebugBlock(a, o, w, h, true);
	#/
}

addBlock(o, w, h)
{
	if (!isDefined(h))
		h = w;

	a = createBlock(o, w, h);

	/#
	if (level.dev)
		addDebugBlock(a, o, w, h, false);
	#/
}

/#
addDebugBlock(t, o, w, h, jump)
{
	level.blockCount++;
	level.blocks[level.blockCount] = spawnStruct();
	level.blocks[level.blockCount].o = o;
	level.blocks[level.blockCount].w = w;
	level.blocks[level.blockCount].h = h;
	level.blocks[level.blockCount].t = t;
	level.blocks[level.blockCount].jump = jump;
	level.blocks[level.blockCount].area = false;
}

addDebugArea(t, o, w, h, a, d, e, s)
{
	level.blockCount++;
	level.blocks[level.blockCount] = spawnStruct();
	level.blocks[level.blockCount].o = o;
	level.blocks[level.blockCount].w = w;
	level.blocks[level.blockCount].h = h;
	level.blocks[level.blockCount].a = a;
	level.blocks[level.blockCount].d = d;
	level.blocks[level.blockCount].e = e;
	level.blocks[level.blockCount].t = t;
	level.blocks[level.blockCount].s = s;
	level.blocks[level.blockCount].area = true;
}

float(n)
{
	if (isSubStr(n, "."))
	{
		a = strTok(n, ".");

		sub = int(a[1]);
		while (sub >= 1)
			sub /= 10;

		return int(a[0]) + sub;
	}

	return int(n);
}

debugBlock()
{
	setDvar("hns_radius_del", 0);
	setDvar("hns_radius_addblock", "");
	setDvar("hns_radius_addarea", "");
	setDvar("hns_radius_change_x", "");
	setDvar("hns_radius_change_y", "");
	setDvar("hns_radius_change_z", "");
	setDvar("hns_radius_change_width", "");
	setDvar("hns_radius_change_height", "");
	setDvar("hns_radius_change_jump", ""); // Block / Jump
	setDvar("hns_radius_change_angle", ""); // Area
	setDvar("hns_radius_change_distance", ""); // Area
	setDvar("hns_radius_change_elevation", ""); // Area
	setDvar("hns_radius_change_style", ""); // Area
	setDvar("hns_radius_save", 0);

	while (true)
	{
		wait 0.05;

		// Save
		if (getDvarInt("hns_radius_save"))
		{
			log = getDvarInt("logfile");
			setDvar("logfile", 2);

			printLn("<---------- HNS: " + level.script + " BLOCKS ---------->");
			for (i = 1; i <= level.blockCount; i++)
			{
				b = level.blocks[i];

				if (b.area)
				{
					printLn("addArea(" + b.o + ", " + b.a + ", " + b.d + ", " + b.e + ", \"" + b.s + "\", " + b.w + ", " + b.h + ");");
				}
				else
				{
					if (b.jump)
						type = "Jump";
					else
						type = "Block";

					printLn("add" + type + "(" + b.o + ", " + b.w + ", " + b.h + ");");
				}
			}
			printLn("<---------- HNS END ---------->");

			setDvar("logfile", log);
			setDvar("hns_radius_save", 0);
		}

		// Delete (id)
		e = getDvarInt("hns_radius_del");
		if (e > 0 && e <= level.blockCount)
		{
			if (level.blocks[e].area)
				level.blocks[e].t.fx delete();

			level.blocks[e].t delete();

			if (e != level.blockCount)
				level.blocks[e] = level.blocks[level.blockCount];

			level.blocks[level.blockCount] = undefined;
			level.blockCount--;
			setDvar("hns_radius_del", 0);
		}

		// Add block (x,y,z width height isjump)
		e = getDvar("hns_radius_addblock");
		if (e != "")
		{
			e = strTok(e, " ");
			s = e.size;
			if (s == 3 || s == 4)
			{
				here = e[0] == "here" && isDefined(level.players[0]);
				if (here)
					a = level.players[0].origin;
				else
					a = strTok(e[0], ",");

				if (here || a.size == 3)
				{
					o = (float(a[0]), float(a[1]), float(a[2]));
					w = float(e[1]);
					h = float(e[2]);

					if (s == 4 && int(e[3]))
						addJump(o, w, h);
					else
						addBlock(o, w, h);

					setDvar("hns_radius_addblock", "");
				}
			}
		}

		// Add area (x,y,z angle distance elevation style width height)
		e = getDvar("hns_radius_addarea");
		if (e != "")
		{
			e = strTok(e, " ");
			if (e.size == 7)
			{
				here = e[0] == "here" && isDefined(level.players[0]);

				if (here)
					a = level.players[0].origin;
				else
					a = strTok(e[0], ",");

				if (here || a.size == 3)
				{
					if (e[4] == "climb" || e[4] == "door" || e[4] == "high")
					{
						addArea((float(a[0]), float(a[1]), float(a[2])), float(e[1]), float(e[2]), float(e[3]), e[4], float(e[5]), float(e[6]));
						setDvar("hns_radius_addarea", "");
					}
					else
					{
						iPrintLn("^1Area style can only be: climb, door, high");
					}
				}
			}
		}

		// Change attrs (id, value)
		changeBlock("x");
		changeBlock("y");
		changeBlock("z");
		changeBlock("width");
		changeBlock("height");
		changeBlock("jump");
		changeBlock("angle");
		changeBlock("distance");
		changeBlock("elevation");
		changeBlock("style");

		// Draw
		if (!level.players.size)
			continue;

		for (c = 1; c <= level.blockCount; c++)
		{
			e = level.blocks[c];

			displayText = distanceSquared(e.o, level.players[0].origin) < 147456; // 384x384
			if (displayText)
			{
				print3d(e.o + (0, e.w, e.h / 2), e.h + "h", (1, 1, 1), 1, 0.5);
				print3d(e.o + (e.w / 2, 0, 0), e.w + "w", (1, 1, 1), 1, 0.5);
				print3d(e.o, e.o, (1, 1, 1), 1, 0.25);
			}

			if (e.area)
			{
				arrow = anglesToForward((0, e.a, 0));
				o = e.o + (0, 0, e.h / 2);
				o2 = o + arrow * e.d;

				// Angle arrow
				line(o, o2);
				line(o2, o2 + anglesToForward((0, e.a + 145, 0)) * e.d / 3);
				line(o2, o2 + anglesToForward((0, e.a - 145, 0)) * e.d / 3);
				if (displayText)
					print3d(o + arrow * e.d / 2, e.a + "a," + e.d + "d", (1, 1, 1), 1, 0.5);

				// Elevation
				line(o, o + (0, 0, e.e));
				if (displayText)
					print3d(o + (0, 0, e.e / 2), e.e + "e", (1, 1, 1), 1, 0.5);
			}

			for (i = 0; i < 18; i++)
			{
				if (e.area)
					col = (1, 0.5, 0.5);
				else if (e.jump)
					col = (0.5, 0.5, 1);
				else
					col = (0, 1, 0);

				x = e.o[0] + cos(i * 20) * e.w;
				y = e.o[1] + sin(i * 20) * e.w;
				line((x, y, e.o[2]), (x, y, e.o[2] + e.h), col);

				if (distanceSquared(e.o, level.players[0].origin) < 1048576) // 1024x1024
					print3d(e.o + (0, 0, e.h / 2), "#" + c, (1, 1, 0), 1, 1);
			}
		}
	}
}

changeBlock(a)
{
	e = getDvar("hns_radius_change_" + a);
	if (e != "")
	{
		e = strTok(e, " ");
		if (e.size == 2)
		{
			id = int(e[0]);
			if (id > 0 && id <= level.blockCount)
			{
				setDvar("hns_radius_change_" + a, "");
				val = e[1];

				e = level.blocks[id];
				switch (a)
				{
					case "x": e.o = (float(val), e.o[1], e.o[2]); break;
					case "y": e.o = (e.o[0], float(val), e.o[2]); break;
					case "z": e.o = (e.o[0], e.o[1], float(val)); break;
					case "width": e.w = float(val); break;
					case "height": e.h = float(val); break;
					case "jump": e.jump = float(val) != 0; break;
					case "angle": e.a = float(val); break;
					case "distance": e.d = float(val); break;
					case "elevation": e.e = float(val); break;
					case "style": e.s = val; break;
				}

				// Recreate radius
				if (e.area)
					e.t.fx delete();

				e.t delete();

				if (e.area)
					e.t = createArea(e.o, e.w, e.h, e.a, e.d, e.e, e.s);
				else if (e.jump)
					e.t = createJump(e.o, e.w, e.h);
				else
					e.t = createBlock(e.o, e.w, e.h);
			}
		}
	}
}
#/

regGlobal(var, def)
{
	a = getDvarInt("scr_hns_" + var);
	if (!a)
		a = def;

	return a;
}

regGlobalFloat(var, def)
{
	a = getDvarFloat("scr_hns_" + var);
	if (!a)
		a = def;

	return a;
}

// Check map-specific dvar -> check global dvar -> read map/mod settings -> read map-specific default -> set default
regDvar(old, var, def, str)
{
	str = isDefined(str) && str;
	if (str)
		t = getDvar("scr_hns_" + var + "_" + level.script);
	else
		t = getDvarInt("scr_hns_" + var + "_" + level.script);

	if ((str && t != "") || (!str && t))
	{
		// Map-specific definition
		return t;
	}
	else
	{
		// Global definition
		if (str)
			t = getDvar("scr_hns_" + var);
		else
			t = getDvarInt("scr_hns_" + var);

		if ((str && t != "") || (!str && t))
			return t;
		else if (isDefined(old))
			return old;
		else if (isDefined(level.defaults[var + "_" + level.script]))
			return level.defaults[var + "_" + level.script];
		else
			return def;
	}
}

// Assert is not working in dedicated mode ~ we generate an error
error(s)
{
	//maps\mp\_utility::error(s);
	s = "^1" + s + "^7";
	s /= "";
}

giveXP()
{
	self thread [[level.onXPEvent]]("bonus");

	// Message
	return level.s["gotxp" + self.lang];
}

giveSmoke()
{
	// Allow run
	self.allowRun = true;

	// Give smoke grenade
	self.smokeGrenade++;
	if (self hasWeapon("smoke_grenade_mp"))
	{
		self setWeaponAmmoClip("smoke_grenade_mp", self.smokeGrenade);
	}

	// Message
	return level.s["gotsmoke" + self.lang];
}

checkJumper()
{
	while (true)
	{
		self waittill("trigger", player);
		player thread jumper("glitch");
	}
}

spawnPlayer()
{
	self takeAllWeapons();
	self clearPerks();
	self setClientDvar("g_compassShowEnemies", 0);
	self.streak = 0;
	//self.rankUpdateTotal = 0;

	// First spawn
	if (!isDefined(self.killed))
	{
		// Check played maps
		if (!(level.map & self.maps))
		{
			self.maps |= level.map;
			self setStat(3166, self.maps);
			/*if (self.maps == 8388607) // 16777215
			{
				// Explorer Challenge
				self checkStat(512);
			}*/
		}

		// Explorer Challenge ~ We check it always, cause it may be bugged for someone, or they were playing with an older version
		if (self.maps & 2097151 == 2097151) { // 2097151 = every default map is played
			self checkStat(512);
		}

		// Stolen Time challenge
		if (self getStat(2311) + self getStat(2312) >= 604800)
			self checkStat(4096);
	}

	if (!isDefined(self.knifed)) // If a seeker is knifed, we shouldn't reset everything
	{
		// Stat
		self.cur_streak = 0;

		// Set team names
		if (self.team == "allies")
		{
			alliesc = 8;
			axisc = 9;
		}
		else
		{
			alliesc = 9;
			axisc = 8;
		}

		self setClientDvars(
			"g_teamname_axis", "^1" + level.s["seekers" + self.lang] + "^" + axisc,
			"g_teamname_allies", "^2" + level.s["hiders" + self.lang] + "^" + alliesc,
			"lastmodel", "" // Set title for last object
		);
	}
	else
	{
		self.knifed = undefined;
		self thread spawnProtect();
	}

	// Alive - probably useless
	self.killed = false;

	// Climbing to another area
	self.climbing = false;

	// Protected (spawn protect / area-enter protect)
	self.protect = false;

	/*self.lastModelTitle.label = level.s["last" + self.lang];
	self.lastModel.alpha = 0;
	self.lastModelTitle.alpha = 0;*/

	// Money
	if (!isDefined(self.money))
	{
		self.money = 0;
	}

	// Markers
	if (!isDefined(self.markers))
		self.markers = 0;
	else if (self.markers)
		self giveMarker();

	self thread mark();

	// Give points from the previous round
	if (isDefined(self.plusscore))
	{
		self addScore(self.plusscore);
		self.plusscore = undefined;
	}

	// Specials
	self thread checkSpecial();

	// Against level hack
	// (2308 = Headshots - Against EasyAccount)
	// (2311 + 2312 + 2313 = Player time must be minimum 10 hours)
	// (1678475989 = 1678475970 [Max XP] + 19 against bug)
	// 3175 is a second stored value against Stat Editor
	// (rankxp - 1614807542 to prevent searching for this value)
	//sec = self getStat(3175);  || (sec > 0 && self.pers["rankxp"] != sec + 1614807542)
	/*l = self getStat(2308) || (self.pers["rank"] >= 99 && self getStat(2311) + self getStat(2312) + self getStat(2313) < 36000);
	if (!self.pers["rankxp"] || l)
	{
		// Check hackers
		if (player.invalid || l)
		{
			for (i = 0; i < level.players.size; i++)
			{
				level.players[i] iPrintLn(level.s["tryhack" + level.players[i].lang], self.name);
			}
			self setStat(2308, 0);
		}
		self.pers["rank"] = 0;
		self.pers["rankxp"] = 1678452056;
		self setStat(level.stat, maps\mp\gametypes\rank::encodeStat(1678452056));
		//self setStat(3175, 63644514);
		//self maps\mp\gametypes\_persistence::statSet("rankxp", 1678452056);
	}*/

	// Third person info
	/*if (!isDefined(self.thirdPersonInfo))
	{
		// [{+smoke}] was replaced because of the special grenades
		self.thirdPersonInfo = infoText(265, level.s["thirdperson" + self.lang]);
	}*/

	// Ready-Up
	if (level.readyUp && !level.alreadyPlay && self.team == "allies")
	{
		self.statusicon = "hud_status_unready";
		self.ready = false;
		self thread beReady();
	}
	else
	{
		// Pro Player
		self setStatusIcon();
	}

	// Stop shell shock
	self stopShellShock();

	// Default sprint scale
	self setMoveSpeedScale(1);

	// Head icon
	self.headiconteam = self.team;

	// Time site statistics
	/*if (self.playTime > getDvarInt("max_time"))
	{
		setDvar("max_time", self.playTime);
		setDvar("max_time_owner", self.name);
		self thread freshStat();
	}*/

	// Validate death FX
	self getFX();

	// Team specified settings
	if (self.team == "axis")
	{
		// Give jammer
		if (isDefined(self.jammer))
		{
			self giveJammer();
		}

		// Give sensor
		if (isDefined(self.sensor))
		{
			self giveSensor();
		}

		// Default weapon
		wpn = self getWeapon();
		self.weapon = level.weapons[wpn][0];
		self.secondaryWeapon = undefined; // May be awarded from a care package, so must be nulled

		// Selected secondary weapon
		secondary = self getStat(3169);
		if (secondary < 0 || secondary > 3)
		{
			secondary = 0;
			self setStat(3169, 0);
		}

		// Enemy names
		self setClientDvar("cg_drawCrosshairNames", 0);

		// Ranks ~ we don't reset many things before this, so rank reseted players may still have special items
		if (self.pers["rank"] >= 2) // Rank 3
		{
			self setPerk("specialty_fastreload"); // Fast reload
			if (self.pers["rank"] >= 9) // Rank 10
			{
				self.weapon = level.weapons[wpn][1]; // 5 Bullets
				if (self.pers["rank"] >= 19) // Rank 20
				{
					self setPerk("specialty_longersprint"); // Longer sprint
					if (self.pers["rank"] >= 29) // Rank 30
					{
						self.weapon = level.weapons[wpn][2]; // 6 Bullets
						if (self.pers["rank"] >= 49) // Rank 50
						{
							if (secondary == 1)
								self.secondaryWeapon = "winchester1200_mp"; // Give shotgun

							if (self.pers["rank"] >= 74) // Rank 75
							{
								if (!isDefined(self.flashGrenade))
								{
									self giveWeapon("flash_grenade_mp"); // Phosphorus grenade
									self thread checkExpNade();
								}
								if (self.pers["rank"] >= 110) // Rank 111
								{
									self.penetrate = true; // Penetration
									if (self.pers["rank"] >= 111) // Rank 112
									{
										if (secondary == 2)
											self.secondaryWeapon = "m1014_grip_mp"; // Faster shotgun

										if (self.pers["rank"] >= 112) // Rank 113
										{
											self.rain = level.rainFX;
											if (self.pers["rank"] >= 113) // Rank 114
											{
												self.rain = level.rain2FX;
												if (self.pers["rank"] >= 114) // Rank 115
												{
													self.rain = level.rain3FX;
													if (self.pers["rank"] >= 115) // Rank 116
													{
														if (secondary == 3)
															self.secondaryWeapon = "deserteaglegold_mp"; // Desert Eagle

														self.rain = level.rain4FX;
													}
												}
											}

											// Check if moth effect is enabled
											if (!self getStat(3170))
											{
												self thread rainWay(self.rain);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}

		// Shotgun
		if (isDefined(self.secondaryWeapon))
			self giveWeapon(self.secondaryWeapon, self getCamo());

		// Last model
		if (level.oneLeft && isDefined(level.alivePlayers["allies"][0]))
			self createModelInfo(level.alivePlayers["allies"][0].showmodel);

		// Validate music
		if (self.pers["rank"] < self getStat(3174) * 50 - 1)
			self setStat(3174, 0);

		self enableAds(true);
		self.canKill = true;
		self setTP(false);
		self.shock = false;
		self allowSprint(true);
		self getModel();
		self playerModel();
		self giveWeapon(self.weapon, self getCamo());
		self setSpawnWeapon(self.weapon);

		// Ammo
		if (isDefined(self.ammo))
		{
			clip = int(min(weaponClipSize(self.weapon), self.ammo));
			self setWeaponAmmoClip(self.weapon, clip);
			self setWeaponAmmoStock(self.weapon, self.ammo - clip);

			if (isDefined(self.secondaryAmmo))
			{
				if (isDefined(self.secondaryWeapon))
				{
					clip = int(min(weaponClipSize(self.secondaryWeapon), self.secondaryAmmo));
					self setWeaponAmmoClip(self.secondaryWeapon, clip);
					self setWeaponAmmoStock(self.secondaryWeapon, self.secondaryAmmo - clip);
				}
				else
				{
					// They have been reseted
					self.secondaryWeapon = undefined;
				}
			}
		}
		else
		{
			self maxSeekerAmmo();
		}

		self switchToWeapon(self.weapon);
		self show();
	}
	else if (self.team == "allies")
	{
		// Information
		self setClientDvars(
			"fix", "FIX",
			"rotation", "ROTATIONZ",
			"list", "",
			"vis_cur", 0,
			"cg_drawCrosshairNames", 1 // Enemy names
		);

		/*self.rotation = infoText(150, level.s["rotationz" + self.lang]);
		self.rotationInfo = infoText(170, level.s["rotate" + self.lang]);
		self.rotationSetInfo = infoText(185, level.s["axis" + self.lang]);
		self.resetInfo = infoText(200, level.s["resetmodel" + self.lang]);
		self.fixInfo = infoText(215, level.s["fix" + self.lang]);
		self.runInfo = infoText(230, level.s["run" + self.lang]);*/

		// There are two binds for the ADS ([{+speed_throw}] too), but we can't put here both,
		// because we can't check, if something is Unbound with == "Unbound", and it's ugly
		//self.fastInfo = infoText(245, level.s["fastmodel" + self.lang]);

		// Default kill method
		self.canKill = false;

		// Default run method
		self.allowRun = false;

		// Fixed model
		self.fixed = false;

		// Restore seeker ammo
		self.ammo = undefined;

		// Restore seeker ammo
		self.secondaryAmmo = undefined;

		// Restore teleport permission
		if (self.vip)
			self.teleport = true;
		else
			self.teleport = undefined;

		// Weapon
		self.hiderWeapon = level.weapons[self getWeapon()][0];

		// Default grenade
		self.smokeGrenade = 0;

		// Current visibility points
		self.vis_cur = 0;

		// Ranks
		if (self.pers["rank"] >= 4) // Rank 5
		{
			self.quiet = true;
			self setPerk("specialty_quieter"); // Quiet
			if (self.pers["rank"] >= 14) // Rank 15
			{
				self.allowRun = true; // Allow run
				if (self.pers["rank"] >= 24) // Rank 25
				{
					if (!level.jammer)
					{
						self setClientDvar("g_compassShowEnemies", 1); // Compass
					}
					if (self.pers["rank"] >= 39) // Rank 40
					{
						self.canKill = true; // Able to knife seekers
						if (self.pers["rank"] >= 55) // Rank 56
						{
							self.hiderAmmo = 1; // Stun pistol ammo
							if (self.pers["rank"] >= 99) // Rank 100
							{
								self.smokeGrenade = 1; // Smoke grenade
								if (self.pers["rank"] >= 113) // Rank 114
								{
									self.teleport = true;
									if (self.pers["rank"] >= 114) // Rank 115
									{
										self.prevent = true; // Immunity
									}
								}
							}
						}
					}
				}
			}
		}

		self thread checkSmokeNade(); // Care package can give it too
		self setModel("fake");
		self getModel(); // We query it, because voice commands needs to check it
		self.rotateType = "Z";
		self thread ownModel();
		self thread rotateModel();

		// Set third person
		// Info text is in spawnPlayer, because players will change the language there
		self setTP(true);
		self thread setThirdPerson();

		if (!isDefined(self.pers["isBot"]))
		{
			//self openMenu("model_" + level.script);
			self openMenu("model");
		}
	}

	// Player restrictions
	if (!isDefined(self.active))
	{
		self.active = level.activePlayers.size;
		level.activePlayers[level.activePlayers.size] = self;
	}

	// Bad name
	if (!level.listen && isDefined(level.nameDefend) && isDefined(level.nameDefend[self.name]) && !isSubStr(level.nameProtect, self.guid))
	{
		self setClientDvar("name", "badName" + randomInt(1000));
	}

	// [[level._setTeamScore]]("axis", level.scoreLimit); Fake map-end
}

enableAds(e)
{
	self.canAds = e;
	self allowAds(e);
}

rainWay(fx)
{
	self notify("endrain");
	self endon("endrain"); // Just to be sure it is stopped ~ "spawn" would be for it basically, not working...
	level endon("game_ended");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn");

	o = (0, 0, 0);
	while (true)
	{
		wait 0.3;
		if (self.origin != o)
		{
			o = self.origin;
			playFX(fx, o);
		}
	}
}

beReady()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn");
	level endon("play");

	while (true)
	{
		if (self useButtonPressed())
		{
			time = 0;
			while (self useButtonPressed())
			{
				time += addTime(0.05);

				if (time == 0.5)
				{
					self.ready = !self.ready;
					if (self.ready)
						self.statusicon = "hud_status_ready";
					else
						self.statusicon = "hud_status_unready";
				}
			}
		}
		wait 0.05;
	}
}

isPro()
{
	return self.pers["rank"] >= 99 && self.ch == 16383;
}

setStatusIcon()
{
	pro = self isPro();
	if (pro)
		self setActionSlot(1, "nightvision"); // Nightvision

	if (self.vip && pro)
		self.statusicon = "hud_status_provip";
	else if (self.vip)
		self.statusicon = "hud_status_vip";
	else if (pro)
		self.statusicon = "hud_status_pro";
	else if (self.statusicon != "")
		self.statusicon = "";
}

getCamo()
{
	camo = self getStat(3176);
	if (camo < 0 || camo > 5 || (camo != 5 && self.pers["rank"] < camo * 25 - 1) || (camo == 5 && !self.vip))
	{
		self setStat(3176, 0);
		return 0;
	}
	return camo;
}

getWeapon()
{
	wpn = self getStat(3172);
	if (wpn < 0 || wpn > 2 || (wpn != 2 && self.pers["rank"] < wpn * 50 - 1) || (wpn == 2 && !self.vip))
	{
		self setStat(3172, 0);
		return 0;
	}
	return wpn;
}

getModel()
{
	self.modelID = self getStat(3173);
	if (self.modelID < 0 || self.modelID > 5 || (self.modelID != 5 && self.pers["rank"] < self.modelID * 20 - 1) || (self.modelID == 5 && !self.vip))
	{
		self.modelID = 0;
		self setStat(3173, 0);
	}
}

checkExpNade()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn"); // joined_team

	while (true)
	{
		self waittill("grenade_fire", g, name);
		if (name == "flash_grenade_mp")
		{
			self.flashGrenade = true;
			self takeWeapon("flash_grenade_mp");
		}
	}
}

checkSmokeNade()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn"); // joined_team

	while (true)
	{
		self waittill("grenade_fire", g, name);
		if (name == "smoke_grenade_mp")
		{
			self.smokeGrenade--;
		}
	}
}

giveMarker()
{
	if (!self hasWeapon("frag_grenade_mp"))
	{
		self giveWeapon("frag_grenade_mp");
	}
	self setWeaponAmmoClip("frag_grenade_mp", self.markers);
}

mark()
{
	self notify("endmark"); // "spawn" should do its job instead of it, no idea dafaq is CoD4 doing!
	self endon("endmark");
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	while (true)
	{
		self waittill("grenade_fire", g, name);

		if (name == "frag_grenade_mp")
		{
			self.markers--;
			//level.plane = true;
			thread startPlane(g);
			//waittillframeend;
			//self switchToWeapon(self.weapon);
		}
	}
}

startPlane(g)
{
	org = (0, 0, 0);
	while (isDefined(g))
	{
		org = g.origin;
		wait 0.05;
	}

	p = getTrace(org + (0, 0, 1100), org - (0, 0, 1100));

	p2 = getTrace(org + (24, 0, 1100), org + (24, 0, -1100));
	p3 = getTrace(org + (-24, 0, 1100), org + (-24, 0, -1100));
	p4 = getTrace(org + (0, 16, 1100), org + (0, 16, -1100));
	p5 = getTrace(org + (0, -16, 1100), org + (0, -16, -1100));

	o = p[2];
	if (p2[2] > o)
		o = p2[2];
	if (p3[2] > o)
		o = p3[2];
	if (p4[2] > o)
		o = p4[2];
	if (p5[2] > o)
		o = p5[2];

	p = (p[0], p[1], o);

	n = level.care.size;
	level.care[n] = [];
	level.care[n]["plane"] = spawn("script_model", p + (-24000, -24000, 1100));
	level.care[n]["plane"] thread doPlane(org, p, self, n);
}

doPlane(org, p, player, n)
{
	level endon("endround");

	self setModel("vehicle_mig29_desert");
	self.angles = (0, 45, 0);
	self moveTo(p + (24000, 24000, 1100), 15);

	team = player.team;

	wait 5.75;

	level.care[n]["snd"] = spawn("script_origin", org);
	level.care[n]["snd"] playSound("veh_mig29_sonic_boom");

	wait 1.75;

	level.care[n]["box"] = spawn("script_model", org + (0, 0, 1100));
	level.care[n]["box"] setModel("com_plasticcase_black_big");
	level.care[n]["box"] moveTo(p, 2);

	org = undefined;
	wait 2;

	if (team == "allies")
		hnsteam = "hider";
	else
		hnsteam = "seeker";

	level.care[n]["sign"] = newHudElem();
	level.care[n]["sign"].x = p[0];
	level.care[n]["sign"].y = p[1];
	level.care[n]["sign"].z = p[2] + 16;
	level.care[n]["sign"].isFlashing = false;
	level.care[n]["sign"].isShown = true;
	level.care[n]["sign"] setShader("waypoint_" + hnsteam, 8, 8);
	level.care[n]["sign"] setWaypoint(true);

	level.care[n]["trigger"] = spawn("trigger_radius", p, 0, 32, 32);
	level.care[n]["trigger"] thread givePack(team, player, n);

	level.care[n]["fx"] = spawn("script_model", p + (0, 0, 8));
	level.care[n]["fx"] setModel("tag_origin");
	level.care[n]["fx"] thread timerBack();

	//thread careClock(p, level.care[n]["trigger"]);

	hnsteam = undefined;
	player = undefined;
	p = undefined;
	team = undefined;
	wait 5.5;

	//level.plane = undefined;

	if (level.care[n].size)
	{
		level.care[n]["snd"] delete();
		level.care[n]["snd"] = undefined;
		level.care[n]["plane"] delete();
		level.care[n]["plane"] = undefined;
		level.care[n]["fx"] delete();
		level.care[n]["fx"] = undefined;
	}
}

// Care package count back
timerBack()
{
	self endon("end");

	wait 0.5;
	playFXOnTag(level.count5FX, self, "tag_origin");
	wait 1;
	playFXOnTag(level.count4FX, self, "tag_origin");
	wait 1;
	playFXOnTag(level.count3FX, self, "tag_origin");
	wait 1;
	playFXOnTag(level.count2FX, self, "tag_origin");
	wait 1;
	playFXOnTag(level.count1FX, self, "tag_origin");
}

// Deprecated - print3D is developer only
/*careClock(o, trigger)
{
	iPrintLn(0);
	// Frame Per Second
	// It's always 20
	//fps = getDvarInt("sv_fps");

	// Count back from 11 is nicer than from 5.5
	time = 11; // 5.5
	while (isDefined(trigger) && time)
	{
		print3D(o + (0, 0, 8), time, (0.8, 0.8, 0.3), 0.8, 0.75, 5); // int(fps / 4)
		//time -= addTime(0.5);
		time -= 1;
		wait 0.25;
	}
}*/

givePack(team, owner, n)
{
	level endon("endround");
	self endon("remove");

	while (true)
	{
		self waittill("trigger", player);
		if (player.team == team && (!isDefined(owner) || player == owner || !isDefined(level.care[n]["plane"])))
		{
			player iPrintLnBold(player [[level.pack[player.team][randomInt(level.pack[player.team].size)]]]());
			thread delPack(n); // If not threaded then the "remove" notify will stop removePack()
			return; // Just to be sure it is not going forward
		}
	}
}

delPack(n)
{
	if (isDefined(n))
	{
		removePack(n);
	}
	else
	{
		for (i = 0; i < level.care.size; i++)
		{
			if (level.care[i].size)
			{
				removePack(i);
			}
		}
		level.care = [];
	}
}

removePack(i)
{
	// snd, plane, fx, box, sign, trigger
	if (level.care[i].size == 6)
	{
		level.care[i]["snd"] delete();
		level.care[i]["plane"] delete();
		level.care[i]["fx"] notify("end");
		level.care[i]["fx"] delete();
	}

	if (isDefined(level.care[i]["box"]))
	{
		level.care[i]["box"] delete();
		if (isDefined(level.care[i]["sign"]))
		{
			level.care[i]["sign"] destroy();
			level.care[i]["trigger"] notify("remove");
			level.care[i]["trigger"] delete();
		}
	}

	level.care[i] = [];
}

getTrace(from, to)
{
	return bulletTrace(from, to, false, undefined)["position"];
}

setupAttachment(model, rotate)
{
	self.attachments["model_" + model] = 0;
	self setClientDvar("model_" + model, 0);
	if (!isDefined(rotate) || rotate)
	{
		self.attachments["rotate_" + model] = 0;
		self setClientDvar("rotate_" + model, 0);
	}
}

restoreAttachments(dvars)
{
	if (!isDefined(dvars) || (isDefined(dvars) && dvars))
	{
		if (modelOnMap("com_trashcan_metal") || modelOnMap("com_trashcan_metal_with_trash"))
		{
			self setupAttachment("lid", false); // Trashcan lid
			self setupAttachment("trashbag"); // Trashcan trashbag
		}
		if (modelOnMap("com_stove"))
		{
			self setupAttachment("pan"); // Stove pan
			self setupAttachment("pan2"); // Stove copper pan
		}
		if (modelOnMap("com_restaurantstainlessteelshelf_01") || modelOnMap("com_restaurantstainlessteelshelf_02"))
		{
			self setupAttachment("toolbox"); // Shelf toolbox
			self setupAttachment("paintcan"); // Shelf paint can
			self setupAttachment("lowbox"); // Shelf low box
			self setupAttachment("plasticcrate2"); // Shelf plastic crate
			self setupAttachment("tire"); // Shelf tire
		}
		if (modelOnMap("com_cardboardbox01"))
		{
			self setupAttachment("box"); // Box
		}
		if (modelOnMap("com_plasticcase_beige_big"))
		{
			self setupAttachment("case"); // Plastic case
		}
		if (modelOnMap("ch_crate32x48") || modelOnMap("ch_crate48x64") || modelOnMap("ch_crate64x64"))
		{
			self setupAttachment("crate"); // Crate
		}
		if (modelOnMap("bc_militarytent_wood_table"))
		{
			self setupAttachment("paintcan2"); // Wood table paint can
			self setupAttachment("propane"); // Wood table propane tank
			self setupAttachment("plasticcrate"); // Wood table plastic crate
			self setupAttachment("box2"); // Wood table box
			self setupAttachment("propane2"); // Wood table propane tank
			self setupAttachment("tire2"); // Wood table tire
		}
		if (modelOnMap("com_restaurantsink_2comps"))
		{
			self setupAttachment("paintcan3"); // Sink paintcan
			self setupAttachment("bucket"); // Sink bucket
			self setupAttachment("bucket2"); // Sink down bucket
		}
		if (modelOnMap("tvs_cubicle_round_1"))
		{
			self setupAttachment("tv"); // TV-table tv
			self setupAttachment("comps", false); // TV-table Computers
		}
		if (modelOnMap("com_barrel_fire"))
		{
			self setupAttachment("fire"); // Barrel fire
		}
		if (modelOnMap("ct_street_lamp_on"))
		{
			self setupAttachment("glow"); // Light glow
		}
		if (modelOnMap("ct_statue_chineselionstonebase"))
		{
			self setupAttachment("statue"); // Lion statue
		}
		if (modelOnMap("ch_missle_rack"))
		{
			self setupAttachment("rockets", false); // Missile rack's projectiles
		}
	}

	if (isDefined(self.models))
	{
		for (i = 0; i < self.models.size; i++)
		{
			self.models[i] delete();
		}
	}
	if (isDefined(self.effect))
	{
		self.effect delete();
	}

	self.models = [];
}

beep(count)
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	time = 0;
	for (i = 1; i <= count; i++)
	{
		self playLocalSound("sensor");
		if (i < count)
		{
			time += addTime(0.2);
		}
	}
	return time;
}

addTime(time)
{
	wait time;
	return time;
}

/*infoText(y, text)
{
	info = newClientHudElem(self);
	info.elemType = "font";
	info.font = "default";
	info.fontscale = 1.4;
	info.x = -10;
	info.y = y;
	info.hideWhenInMenu = true;
	info.archived = true;
	info.alignX = "right";
	info.alignY = "top";
	info.horzAlign = "right";
	info.vertAlign = "top";
	info.color = (1, 1, 1);
	info.alpha = 0.85;
	info.label = text;
	return info;
}*/

setThirdPerson()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	while (true)
	{
		wait 0.1;
		if (self fragButtonPressed())
		{
			time = 0;
			while (self fragButtonPressed() && time < 0.5)
			{
				time += addTime(0.05);
			}

			if (time == 0.5)
			{
				if (self.thirdPerson)
				{
					self setTP(false);
				}
				else
				{
					self setTP(true);
				}
				while (self fragButtonPressed())
				{
					wait 0.05;
				}
			}
		}
	}
}

setTP(b)
{
	self.thirdPerson = b;
	self setClientDvar("cg_thirdPerson", b);
}

cheater(s1, s2)
{
	fade = newClientHudElem(self);
	fade.width = 960;
	fade.height = 480;
	fade.alignX = "left";
	fade.alignY = "top";
	fade.horzAlign = "left";
	fade.vertAlign = "top";
	fade setShader("$black", 960, 480);
	fade.alpha = 1;
	fade.sort = -1;

	fadetext = newClientHudElem(self);
	fadetext.elemType = "font";
	fadetext.font = "default";
	fadetext.fontscale = 2;
	fadetext.x = 0;
	fadetext.y = -10;
	fadetext.hideWhenInMenu = false;
	fadetext.archived = true;
	fadetext.alignX = "center";
	fadetext.alignY = "middle";
	fadetext.horzAlign = "center";
	fadetext.vertAlign = "middle";
	fadetext.glowAlpha = 0.1;
	fadetext.glowColor = (1, 0.2, 0.2);
	fadetext.sort = 0;
	fadetext setText("^1" + s1);

	if (isDefined(s2))
	{
		fadetext_desc = newClientHudElem(self);
		fadetext_desc.elemType = "font";
		fadetext_desc.font = "default";
		fadetext_desc.fontscale = 1.5;
		fadetext_desc.x = 0;
		fadetext_desc.y = 10;
		fadetext_desc.hideWhenInMenu = false;
		fadetext_desc.archived = true;
		fadetext_desc.alignX = "center";
		fadetext_desc.alignY = "middle";
		fadetext_desc.horzAlign = "center";
		fadetext_desc.vertAlign = "middle";
		fadetext_desc.glowAlpha = 0.1;
		fadetext_desc.glowColor = (1, 0.2, 0.2);
		fadetext_desc.sort = 0;
		fadetext_desc setText("^1" + s2);
	}

	self setClientDvar("cheater", 1);
	self.cheater = true;
}

playerConnect()
{
	// Set language
	self.lang = ""; // English
	self setClientDvars(
		"lang", "", // Language
		"trigger_msg", "", // Clear trigger message
		"r_lodscalerigid", "1", // Against PB kick
		"r_lodscaleskinned", "1", // Against PB kick
		"cl_maxPackets", "100", // Against PB kick
		"cg_scoreBoardWidth", "550", // Score board width
		"ui_favoriteAddress", level.ip, // For adding favorites
		"ad", getDvar("scr_hns_ad"), // Advertisement
		"motd", getDvar("scr_hns_motd"), // MOTD,
		"hns_reason", "", // Kick reason
		"r_fullbright", "", // For dvar protect
		"r_lodscalerigid", "", // For dvar protect
		"r_lodscaleskinned", "", // For dvar protect
		"dev", level.dev // Developer
	); // Needed for menus

	if (getDvarInt("scr_hns_newmelee"))
	{
		self setClientDvars(
			"aim_automelee_enabled", 0, // Disable auto-aim for knife
			"aim_automelee_range", 0 // It is needed for it too
		);
	}
	// If we store the last X characters instead of the whole 32,
	// it won't reach some string limits easily.
	// It is not super secure, but there are 1679616 combinations for the last 4 already.
	self.realguid = self getGuid();
	self.guid = getSubStr(self.realguid, 32 - level.guidlength);

	// Allow seeker spectating
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", false);

	// Is the player a cheater?
	if (!level.listen && isSubStr(getDvar("banned"), self.guid))
	{
		self cheater("You are banned!", "Contact an admin for further information!");

		for (i = 0; i < level.players.size; i++)
		{
			level.players[i] iPrintLn(level.s["cheater" + level.players[i].lang], self.name);
		}
	}
	else
	{
		if (level.statProtect && !level.listen && !isDefined(self.pers["isBot"]))
		{
			if (self.realguid.size != 32)
			{
				self cheater("Stop GUID spoofing!");
				return;
			}
			else
			{
				s = 0;
				z = 0;
				t = 0;
				v = 1;
				for (i = 0; i < 32; i++)
				{
					if (isSubStr("0123456789", self.realguid[i]))
					{
						q = int(self.realguid[i]);
						if (q)
						{
							s += q;
							if (v < 1000)
							{
								t += q * v;
								v *= 10;
							}
						}
					}
					else if (isSubStr("abcdef", self.realguid[i]))
					{
						switch (self.realguid[i])
						{
							case "a": z += 10; break;
							case "b": z += 11; break;
							case "c": z += 12; break;
							case "d": z += 13; break;
							case "e": z += 14; break;
							case "f": z += 15; break;
						}
					}
					else
					{
						self cheater("Stop GUID spoofing!");
						return;
					}
				}

				self.hashguid = int("" + t + s + z);
				v = hashVal(self.hashguid);
				s = self getStat(2327);
				if (!s)
				{
					self setStat(2327, v);
				}
				else if (s != v)
				{
					self cheater("Your stat is corrupted!");
					return;
				}
			}
		}

		level notify("joined", self);

		// Grenade class
		self setOffhandSecondaryClass("smoke");

		// Last Model title
		/*self.lastModelTitle = newClientHudElem(self);
		self.lastModelTitle.elemType = "font";
		self.lastModelTitle.font = "objective";
		self.lastModelTitle.fontscale = 1.4;
		self.lastModelTitle.x = 0;
		self.lastModelTitle.y = 400;
		self.lastModelTitle.hideWhenInMenu = false;
		self.lastModelTitle.archived = true;
		self.lastModelTitle.alignX = "right";
		self.lastModelTitle.alignY = "middle";
		self.lastModelTitle.horzAlign = "center";
		self.lastModelTitle.vertAlign = "top";
		self.lastModelTitle.alpha = 0;
		self.lastModelTitle.glowAlpha = 0.1;
		self.lastModelTitle.glowColor = (0.6, 0.2, 0.2);

		// Last object
		self.lastModel = newClientHudElem(self);
		self.lastModel.elemType = "font";
		self.lastModel.font = "objective";
		self.lastModel.fontscale = 1.4;
		self.lastModel.x = 0;
		self.lastModel.y = 400;
		self.lastModel.hideWhenInMenu = false;
		self.lastModel.archived = true;
		self.lastModel.alignX = "left";
		self.lastModel.alignY = "middle";
		self.lastModel.horzAlign = "center";
		self.lastModel.vertAlign = "top";
		self.lastModel.alpha = 0;
		self.lastModel.color = (1, 0.4, 0.4);
		self.lastModel.glowAlpha = 0.1;
		self.lastModel.glowColor = (0.6, 0.2, 0.2);*/

		// Refresh statistics
		/*self.freshstat = newClientHudElem(self);
		self.freshstat.elemType = "font";
		self.freshstat.font = "default";
		self.freshstat.fontscale = 1.4;
		self.freshstat.x = -5;
		self.freshstat.y = 5;
		self.freshstat.hideWhenInMenu = false;
		self.freshstat.archived = true;
		self.freshstat.alignX = "right";
		self.freshstat.alignY = "top";
		self.freshstat.horzAlign = "right";
		self.freshstat.vertAlign = "top";
		self.freshstat.alpha = 0.9;
		self.freshstat.color = (0.2, 1, 0.2);
		self.freshstat.glowAlpha = 0.3;
		self.freshstat.glowColor = (0.1, 0.2, 0.1);*/

		// Is he iCore?
		//self.icore = self getStat(2349) == 168;

		// Needed for Revenge Challenge
		self.killer = self;

		// Schnappi
		self.schnappi = false;

		// Schnappi say
		self.extra = false;

		// Vote
		self.allowVote = true;

		// Debugging
		self.debug = false;

		// Warns
		self.warn = 0;

		// VIP
		self.vip = level.dev || isSubStr(getDvar("vip"), self.guid);

		// Get music
		self getMusic();

		// Played maps
		self.maps = self getStat(3166);

		// Load client settings
		// Music
		if (!self getStat(3168))
		{
			// 0 is the on, because that's the default
			self thread playMusic("main" + self.music);
		}

		// Third person
		if (!self getStat(3150))
		{
			self setStat(3150, 120);
		}

		// Statistics & Challenges
		self.stat_streak = self getStat(3153);

		if (level.stealProtect)
			self thread stopSteal();

		/*
		// Remove it after a time (ie when we need these stats)
		// Here we check if someone has earned the achievements in the old version or not
		a[0] = 3158;
		a[1] = 3159;
		a[2] = 3160;
		a[3] = 3161;
		a[4] = 3162;
		a[5] = 3163;
		a[6] = 3164;
		a[7] = 3165;
		a[8] = 3167;
		a[9] = 3169;
		a[10] = 3170;
		s = 0;
		k = 2;
		for (i = 0; i < 11; i++)
		{
			if (self getStat(a[i]))
			{
				s += k;
			}
			k *= 2;
		}
		if (s)
		{
			for (i = 0; i < 11; i++)
			{
				self setStat(a[i], 0);
			}

			if (self getStat(3157))
				s++;

			self setStat(3157, s);
		}
		// Due to a bug, this stat can be almost any big. It is fixed, but we must reset it for some old players.
		if (self getStat(3157) > 4095)
		{
			self setStat(3157, 0);
		}
		// TILL HERE
		*/

		// Be sure to have challenges in the range ~ No, I don't want anyone lose their challenges
		//if (self getStat(3157) < 0 || self getStat(3157) > 16383)
			//self setStat(3157, 0);

		// Challenges
		self.ch = self getStat(3157);

		self setClientDvars(
			"cheater", 0, // Clear
			"lastmodel", "", // Last model
			"vip", self.vip, // VIP
			"readyup", level.readyUp, // Ready-Up
			"cg_thirdPersonRange", self getStat(3150), // Third person range
			"cg_thirdPersonAngle", self getStat(3151) // Third person angle
		);
	}
}

setVis(val, total)
{
	self.vis = val;
	self setStat(self.visStat, maps\mp\gametypes\_rank::encodeStat(self.vis + level.defaultXP)); // Current
	//self setStat(3170, val); // Current
	//self setStat(3169, hash(val)); // Hash
	self setClientDvar("vis", val);

	if (isDefined(total))
	{
		self.totalvis = total;
		self setStat(3167, total); // Total
		self setClientDvar("vis_total", total);

		// The Invisible challenge
		if (total >= 100000)
		{
			self checkStat(8192);
		}
	}
}

// val is self getStat(3170)
/*hash(val)
{
	// Be affected by server stat val
	val += level.stat;

	// Merge with stats
	temp = 2;
	for (i = 3158; i <= 3165; i++)
	{
		val += (val % temp) * self getStat(i);
		temp++;
	}

	return hashVal(val);
}*/

hashVal(val)
{
	//t = abs(val) % 5 + 2;
	//for (i = 0; i < t; i++)
	//{
		// Shift
		temp = val;
		s = 0;
		while (temp)
		{
			s += temp % 10;
			temp = int(temp / 10);
		}
		if (s >= 0)
			val <<= s;
		else if (s)
			val >>= s;

		// Hash
		temp = val;
		s = val;
		for (j = 1; temp; j++)
		{
			s += (temp % 10) * j;
			temp = int(temp / 10);
		}
		if (s) // Do not make it 0
			return s;
		else // It shouldn't return here, but since too many stats are saved this way, for() must be commented out
			return val * -1;
	//}
}

// Steal defend
stopSteal()
{
	self endon("disconnect");

	while (true)
	{
		wait 0.05;
		self setClientDvar("cl_wwwDownload", 1);
	}
}

// We have to get it at playerConnect and change too
getMusic()
{
	if (self getStat(3174) && self getStat(252) >= 49)
		self.music = "2";
	else
		self.music = "";
}

// Anti-glitch
watchPlayer()
{
	level endon("game_ended");
	/*self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn"); // joined_team*/

	while (true)
	{
		wait 0.1;

		ps = level.activePlayers;
		c = ps.size;
		for (i = 0; i < c; i++)
		{
			p = ps[i];
			if (isDefined(p) && p.sessionstate == "playing")
			{
				if (!isDefined(p.watch))
				{
					p.watch = spawnStruct();
					p.watch.point = p.origin;
					p.watch.angle = p.angles;
					p.watch.height = 0;
					p.watch.time = 0;
					p.watch.name = p.name;
					p.watch.names = 0;

					if (level.dev)
					{
						p setClientDvars(
							"origin", p.origin,
							"angles", p.angles[1]
						);
					}
				}
				else
				{
					ladder = p isOnLadder();
					mantle = p isMantling() || p.climbing; // Climbing is for added areas
					ground = p isOnGround();

					if (!level.dev)
					{
						// Elevator
						if (p.origin[0] == p.watch.point[0] && p.origin[1] == p.watch.point[1] && p.origin[2] > p.watch.point[2] && !ladder && !mantle)
						{
							p.watch.height += p.origin[2] - p.watch.point[2];

							if (p.watch.height >= level.maxJump)
							{
								// Elevator jumper
								p thread jumper("elevator");
								p.watch.height = 0;
							}
							else
							{
								// Reset time
								if (p.watch.time)
								{
									p.watch.time = 0;
								}
							}
						}
						// Bounce & Head jump alert
						else if (p.origin[2] > p.watch.point[2] && !ladder && !mantle && !ground)
						{
							// Head jump
							if (isDefined(p.wasOnHead))
							{
								p thread jumper("head");
							}

							p.watch.height += p.origin[2] - p.watch.point[2];

							// Max bounce height
							// Small bounces should be still usable
							if (p.watch.height >= 100)
							{
								// Big bounce jumper
								p thread jumper("bounce");
								p.watch.height = 0;
							}
							else
							{
								// Reset time
								if (p.watch.time)
								{
									p.watch.time = 0;
								}
							}
						}
						else if (p.origin == p.watch.point && p.angles[1] == p.watch.angle)
						{
							// Ping command
							if (!ground && !ladder && !mantle)
							{
								// Increase time
								p.watch.time += 0.1;

								// Maybe client is lagging, so we will only kill him, if he does it longer
								if (p.watch.time >= 2) // ~2.5, but security is important
								{
									p thread jumper("lag");

									p.watch.time = 0;
								}
								/*else
								{
									// Reset jump height
									if (p.watch.height)
									{
										p.watch.height = 0;
									}
								}*/
							}
							// AFK
							else if (p.team == "axis" && level.alreadyPlay)
							{
								// Increase time
								p.watch.time += 0.1;

								// AFK time
								if (p.watch.time >= level.AFKTime)
								{
									// AFK
									p [[level.spectator]]();

									// Do not let them join to hiders
									level.reconnect[p.guid] = true;

									if (level.playerCount["axis"] == 1 && level.playerCount["allies"])
										level.preserveRec = true;

									// Message
									for (i = 0; i < level.players.size; i++)
									{
										level.players[i] iPrintLn(level.s["afk" + level.players[i].lang], p.name);
									}
									continue;
								}
								else
								{
									// Reset jump height
									if (p.watch.height)
									{
										p.watch.height = 0;
									}
								}
							}
						}
						else
						{
							// Reset
							// p.origin != p.watch.point is needed, because if someone is elevating with 1 FPS,
							// their origin will be same for 20 server FPS...
							if (p.origin != p.watch.point && p.watch.height)
								p.watch.height = 0;

							if (p.watch.time)
								p.watch.time = 0;

							if (isDefined(p.wasOnHead))
								p.wasOnHead = undefined;
						}

						// Head jump check
						// It would be saftier with 0.05 wait, but that isn't worth it probably + bounce check requires more wait, since a jumper may have the same origin for 2 frames
						if (ground)
						{
							a = bulletTrace(p.origin, p.origin - (0, 0, 100), true, p);
							if (isPlayer(a["entity"]) && (level.friendlyBlock || p.team != a["entity"].team))
							{
								p.wasOnHead = true;
							}
						}

						// Kick if name changed too many times ~ it is at the end due to kick()!
						if (p.name != p.watch.name)
						{
							if (p.watch.names == 20)
							{
								p clientKick("Stop changing your name!");
							}
							else
							{
								p.watch.name = p.name;
								p.watch.names++;
							}
						}
					}

					// On a ladder with a dog
					if (p.team == "allies" && ladder && p.modelID == 5 && p.showmodel == "seeker")
					{
						p clientExec("+gostand; -gostand");
					}

					// Display origin and angles for developers
					if (level.dev)
					{
						if (p.watch.point != p.origin)
							p setClientDvar("origin", p.origin);
						if (p.watch.angle != p.angles[1])
							p setClientDvar("angles", p.angles[1]);
					}

					// Refresh data
					p.watch.point = p.origin;
					if (isDefined(p.angles)) // May be undefined
					{
						p.watch.angle = p.angles[1];
					}
				}
			}
		}
	}
}

clientKick(reason)
{
	self endon("disconnect");
	self setClientDvar("hns_reason", reason);
	reason = undefined;
	wait 0.5;
	kick(self getEntityNumber());
}

clientExec(cmd)
{
	self setClientDvar("command", cmd);
	self openMenuNoMouse("cmd");

	// All the other menus are closed even if it is not here...
	// Need solution for checking ui_active() via script for that
	self closeMenu();
}

jumper(type)
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn"); // joined_team

	self iPrintLnBold(level.s["jump_" + type + self.lang]);

	// As a punishment, we force them to stay there for 2.5 seconds
	spawn = level.spawnpoints[randomInt(level.spawnpoints.size)];
	self setOrigin(spawn.origin);
	self setPlayerAngles(spawn.angles);

	type = undefined;

	waittillframeend;
	time = 0;
	while (time < 2.5)
	{
		self setOrigin(spawn.origin);
		time += addTime(0.1);
	}
}

ownModel()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	self.bmodel = spawn("script_model", self.origin);
	self.bmodel hide();
	self.bmodel showToPlayer(self);
	//self.bmodel.owner = self;
	self.showmodel = level.defaultModel;
	self setClientDvar("modelid", "model0");
	self freshModel();

	level waittill("play");

	self.bmodel show();
	self.bmodel setCanDamage(true);
	self.bmodel thread damageModel(self);

	// Attachments
	for (i = 0; i < self.models.size; i++)
	{
		self.models[i] show();
		self.models[i] setCanDamage(true);
		self.models[i] thread damageModel(self);
	}

	if (isDefined(self.effect))
		self.effect show();

	self waittill("caught");
	self.killed = true;
	//waitStatusUpdate();
	if (level.playerCount["allies"] > 1)
	{
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			if (isDefined(level.alivePlayers["allies"][i]) && level.alivePlayers["allies"][i] != self)
			{
				level.alivePlayers["allies"][i] addScore("surv");
			}
		}
		self thread [[level.axis]]();
	}
	else
	{
		thread addPoint("axis"); // Must be threaded, so moving the client to other team won't stop it due to endon
	}
}

waitStatusUpdate()
{
	if (isDefined(level.updatingStatus))
		level waittill("statusupdated");
}

eyeContacts()
{
	level endon("endround");

	while (true)
	{
		wait 0.25;
		waitStatusUpdate();
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			h = level.alivePlayers["allies"][i];
			list = "";
			c = 0;
			for (j = 0; j < level.playerCount["axis"]; j++)
			{
				s = level.alivePlayers["axis"][j];
				if (acos(vectorDot(anglesToForward(s getPlayerAngles()), vectorNormalize(s.origin - h.origin))) > 150) // 60 deg on 1024 px
				{
					if (h.showmodel != "seeker")
						b = h.bmodel;
					else
						b = h;

					if (b sightConeTrace(s.origin, s) > 0)
					{
						if (c)
							list += "\n";

						list += "^7" + s.name;
						c++;
					}
				}
			}

			if (c)
			{
				if (isDefined(h.vis))
					h setVis(h.vis + c, h.totalvis + c);

				h.vis_cur += c;
				h setClientDvars(
					"list", level.s["seekers" + h.lang] + " (" + c + "):\n" + list,
					"vis_cur", h.vis_cur
				);
			}
			else
			{
				h setClientDvar("list", "");
			}
		}
	}

	/*while (level.alreadyPlay && !level.forcedEnd)
	{
		for (i = 0; i < level.playerCount["axis"]; i++)
		{
			p = level.alivePlayers["axis"][i];
			if (isDefined(p) && !p.watch.time)
			{
				p iprintln("^6 0");
				start = p.origin;
				switch (p getStance()) {
					case "prone":
						start += (0, 0, 11);
					break;
					case "crouch":
						start += (0, 0, 40);
					break;
					case "stand":
						start += (0, 0, 60);
					break;
				}

				vec = anglesToForward(p getPlayerAngles());
				trace = bulletTrace(start, start + (10000 * vec[0], 10000 * vec[1], 10000 * vec[2]), true, p);
				if (isDefined(trace["entity"]))
				{
					if (isPlayer(trace["entity"]))
					{
						if (trace["entity"].team == "allies")
						{
							trace["entity"].eyes[p.clientid] = true;
							trace["entity"] setClientDvar("seen", trace["entity"].eyes.size);
						}
					}
					else if (isDefined(trace["entity"].owner))
					{
						trace["entity"].owner.eyes[p.clientid] = true;
						trace["entity"] setClientDvar("seen", trace["entity"].eyes.size);
					}
				}
			}
		}
		wait 0.25;
	}
	for (i = 0; i < level.players.size; i++)
	{
		if (isDefined(level.players[i].eyes))
		{
			level.players[i].eyes = undefined;
		}
	}*/
}

addScore(type)
{
	if (isDefined(self) && maps\mp\gametypes\_rank::getScoreInfoValue(type))
	{
		self [[level.givePlayerScore]](type, self);
		self thread [[level.onXPEvent]](type);
	}
}

checkStat(id)
{
	if (!(id & self.ch))
	{
		self.ch |= id;

		// Challenge completed
		self setStat(3157, self.ch);

		// Notify
		team = "";
		mis = "";
		switch (id)
		{
			case 1:
				mis = "last";
				team = "hiders";
			break;
			case 2:
				mis = "fast";
				team = "mixed";
			break;
			case 4:
				mis = "streak";
				team = "mixed";
			break;
			case 8:
				mis = "close";
				team = "seekers";
			break;
			case 16:
				mis = "kill";
				team = "mixed";
			break;
			case 32:
				mis = "rev";
				team = "seekers";
			break;
			case 64:
				mis = "first";
				team = "mixed";
			break;
			case 128:
				mis = "knife";
				team = "hiders";
			break;
			case 256:
				mis = "hide";
				team = "hiders";
			break;
			case 512:
				mis = "map";
				team = "mixed";
			break;
			case 1024:
				mis = "stun";
				team = "hiders";
			break;
			case 2048:
				mis = "rock";
				team = "seekers";
			break;
			case 4096:
				mis = "time";
				team = "mixed";
			break;
			case 8192:
				mis = "vis";
				team = "hiders";
			break;
		}

		msg = spawnStruct();
		msg.titleText = level.s["challenge" + self.lang];
		msg.notifyText = level.s["mis_" + mis + self.lang];
		msg.notifyText2 = level.s[team + self.lang];
		msg.sound = "mp_challenge_complete";
		self maps\mp\gametypes\_hud_message::notifyMessage(msg);

		// Give XP
		self thread [[level.onXPEvent]]("ch");
	}
}

endRound(removeLast)
{
	level notify("endround");

	// Remove care packages
	//level.plane = undefined;
	delPack();

	for (i = 0; i < level.money.size; i++)
	{
		if (isDefined(level.money[i]["model"]))
		{
			level.money[i]["model"] delete();
			level.money[i]["fx"] delete();
			level.money[i]["trigger"] delete();
		}
	}
	level.money = [];

	// Remove 'Last object' title
	if (isDefined(removeLast) && removeLast)
	{
		for (i = 0; i < level.players.size; i++)
		{
			level.players[i] setClientDvar("lastmodel", "");
			/*if (isDefined(level.players[i].lastModel))
			{
				level.players[i].lastModel.alpha = 0;
				level.players[i].lastModelTitle.alpha = 0;
			}*/
		}
	}

	// Remove black screen
	if (isDefined(level.fade))
	{
		if (isDefined(level.fade.owner))
		{
			level.fade.owner freezeControls(false);
		}
		level.fade destroy();
	}

	// Reset reconnecters
	// Only, if the new round was not called because of an only-one seeker
	if (!isDefined(level.preserveRec))
		level.reconnect = [];
	else
		level.preserveRec = undefined;
}

addPoint(team)
{
	// Very rarely addPoint is called two times, and make the game buggy, so I've made this against the bug...
	// It must be a good defence, but I still don't know what caused this bug
	if (team == "axis" && !level.alivePlayers["allies"][0].killed)
	{
		return;
	}

	// Round end
	endRound();

	// Add points to players
	if (team == "axis")
	{
		type = "seek";
	}
	else
	{
		type = "hide";
	}

	[[level._setTeamScore]](team, game["teamScores"][team] + 1);

	if (level.oneLeft)
	{
		if (team == "allies")
		{
			// Last One Challenge
			level.alivePlayers["allies"][0] checkStat(1);
		}
	}

	//waitStatusUpdate();
	for (i = 0; i < level.playerCount[team]; i++)
	{
		if (isDefined(level.alivePlayers[team][i]))
		{
			if (!level.forcedEnd)
			{
				level.alivePlayers[team][i].plusscore = type;
			}
			else
			{
				level.alivePlayers[team][i] addScore(type);
			}
			if (team == "allies" && isDefined(level.alivePlayers[team][i].hide) && level.alivePlayers[team][i].hide)
			{
				// Perfect Hideout Challenge
				level.alivePlayers[team][i] checkStat(256);
			}
		}
	}

	if (!level.forcedEnd)
	{
		// Reset player variables
		for (i = 0; i < level.players.size; i++)
		{
			level.players[i].ammo = undefined;
			level.players[i].secondaryAmmo = undefined;
			level.players[i].flashGrenade = undefined;
			level.players[i].jammer = undefined;
			level.players[i].sensor = undefined;
			level.players[i].penetrate = undefined;
			level.players[i].rain = undefined;
			level.players[i].money = 0;
			level.players[i].markers = 0;
		}

		// Order players
		if (team == "axis")
		{
			for (i = 0; i < level.players.size; i++)
			{
				if (level.players[i].team == "allies")
				{
					level.players[i] [[level.axis]]();
				}
				else if (level.players[i].team == "axis")
				{
					level.players[i] [[level.allies]]();
				}
			}
		}
		else
		{
			// Order teams
			if (level.playerCount["allies"])
			{
				// Choose a random player from allies
				opti = [];
				n = 0;
				max = 0;
				for (i = 0; i < level.playerCount["allies"]; i++)
				{
					if (level.alivePlayers["allies"][i].pers["rank"] >= 19) // At least level 20
					{
						opti[n] = i;
						n++;
					}
					else if (!n && level.alivePlayers["allies"][i].pers["rank"] > level.alivePlayers["allies"][max].pers["rank"])
					{
						max = i;
					}
				}
				// seeker = level.alivePlayers["allies"][randomInt(level.playerCount["allies"])];
				if (opti.size)
					seeker = level.alivePlayers["allies"][opti[randomInt(n)]];
				else
					seeker = level.alivePlayers["allies"][max];

				// We put the hiders to allies too, because
				// we have to reset their stats
				for (i = 0; i < level.players.size; i++)
				{
					if (level.players[i] != seeker && level.players[i].team != "spectator")
					{
						level.players[i] [[level.allies]]();
					}
				}
				// Put the random hider player to axis
				seeker [[level.axis]]();
			}
			else if (level.playerCount["axis"])
			{
				// Choose a random player from axis and put the others in allies
				seeker = randomInt(level.playerCount["axis"]);
				for (i = 0; i < level.playerCount["axis"]; i++)
				{
					if (i != seeker)
					{
						level.alivePlayers["axis"][i] [[level.allies]]();
					}
				}
			}
		}
		thread newRound();
	}
}

waitStreak()
{
	self endon("disconnect");
	self endon("streak");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	wait 2;
	self.streak = 0;
}

knifeSeeker(hider)
{
	if (self.killed)
		return;

	self.killed = true;

	hider addScore("knife");

	// Extra points - currently not given to hiders, but possible by removing the comments
	//if (self isPro())
		//hider addScore("killpro");

	// Extra point for friends and for the knifer too
	if (maps\mp\gametypes\_rank::getScoreInfoValue("friendknife"))
	{
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			if (isDefined(level.alivePlayers["allies"][i]))
			{
				level.alivePlayers["allies"][i] addScore("friendknife");
			}
		}
	}

	// Test
	self.statusicon = "hud_status_dead";

	// Seeker death
	self addDeath();

	// Hider kill
	// with site statistics
	hider.assists++;
	sum = hider getStat(3155) + 1;
	hider setStat(3155, sum);
	/*if (sum > getDvarInt("max_knife"))
	{
		setDvar("max_knife", sum);
		setDvar("max_knife_owner", hider.name);
		hider thread freshStat();
	}*/

	if (hider getStat(3155) >= 25) // == should be, but game/mod can make it buggy
	{
		// Spy Challenge
		hider checkStat(128);
	}

	// Streaks
	// with site statistics
	hider addStreak();

	// Kill Streak
	if (!(hider.cur_streak % 3) && isDefined(hider.hiderAmmo))
	{
		// Sensor
		hider.hiderAmmo++;
		hider setWeaponAmmoStock("colt45_silencer_mp", hider getWeaponAmmoStock("colt45_silencer_mp") + 1);
		hider thread killStreak("pistolammo", hider.cur_streak);
	}

	if (hider getStat(3154) + hider getStat(3155) >= 100)
	{
		// Hardcore Challenge
		hider checkStat(16);
	}

	// Shocked
	if (self.shock)
	{
		// Stunner Challenge
		hider checkStat(1024);
	}

	// 2 seconds streaks
	hider notify("streak");
	hider.streak++;
	if (hider.streak == 2)
	{
		// Double Kill Challenge
		hider checkStat(2);
	}
	hider thread waitStreak();

	// Knifed sign
	self thread knifeSign();

	// Effect
	playFX(level.deathFX[self getFX()], self.origin + (0, 0, 32));

	if (hider.modelID == 5) // Dog
		mod = "MOD_HEAD_SHOT";
	else
		mod = "MOD_MELEE";

	obituary(self, hider, hider getCurrentWeapon(), mod);

	// Put money
	thread money(self.origin);

	// Needed in spawnPlayer()
	self.knifed = true;

	// Put back to seekers
	self [[level.axis]]();
}

getFX()
{
	fx = self getStat(3171);
	if (fx < 0 || fx > 5 || (fx != 5 && self.pers["rank"] < fx * 25 - 1) || (fx == 5 && !self.vip))
	{
		self setStat(3171, 0);
		return 0;
	}
	return fx;
}

catchHider(seeker, mod)
{
	if (self.killed)
		return;

	self.killed = true;

	// Add a death to the hider
	// with site statistics
	self addDeath();

	// Not defined on vote
	if (isDefined(seeker))
	{
		// Add score
		seeker addScore("kill");

		// Extra points
		if (self isPro())
			seeker addScore("killpro");

		// Get weapon
		if (mod == "MOD_GRENADE_SPLASH")
		{
			weapon = "flash_grenade_mp";
		}
		else
		{
			weapon = seeker getCurrentWeapon();

			// Give ammo to seeker
			seeker maxAmmo(seeker.weapon);
		}

		// Set killers
		if (seeker.killer == self)
		{
			// Revenge Challenge
			seeker checkStat(32);
		}
		self.killer = seeker;

		// Seeker kills
		// with site statistics
		seeker.kills++;
		sum = seeker getStat(3154) + 1;
		seeker setStat(3154, sum);
		/*if (sum > getDvarInt("max_catch"))
		{
			setDvar("max_catch", sum);
			setDvar("max_catch_owner", seeker.name);
			seeker thread freshStat();
		}*/

		// Streaks
		// with site statistics
		seeker addStreak();

		// 3 Kill Streak
		if (seeker.cur_streak == 3)
		{
			// Jammer
			seeker.jammer = true;
			seeker giveJammer();
			seeker thread killStreak("jammer", 3);
		}
		else if (seeker.cur_streak == 5)
		{
			// Terminator Challenge
			seeker checkStat(4);

			// Sensor
			seeker.sensor = true;
			seeker giveSensor();
			seeker thread killStreak("radar", 5);
		}

		// Last 10 seconds
		if (level.time < 10 && level.playerCount["allies"] == 1)
		{
			// Close Shave Challenge
			seeker checkStat(8);
		}

		// 100 kills
		if (seeker getStat(3154) + seeker getStat(3155) >= 100)
		{
			// Hardcore Challenge
			seeker checkStat(16);
		}

		// Shocked
		if (seeker.shock)
		{
			// Indestructible Challenge
			seeker checkStat(2048);
		}

		// 2 seconds streaks
		seeker notify("streak");
		seeker.streak++;
		if (seeker.streak == 2)
		{
			// Double Kill Challenge
			seeker checkStat(2);
		}
		seeker thread waitStreak();

		obituary(self, seeker, weapon, mod);
	}

	// Effect
	playFX(level.deathFX[self getFX()], self.origin + (0, 0, 32));

	// Put money
	thread money(self.origin + (0, 0, 24));

	// Play notify sound - not played if not threaded
	self thread catchSound();

	/*if (mod == "MOD_GRENADE_SPLASH")
		sWeapon = "flash_grenade_mp";
	else
		sWeapon = seeker getCurrentWeapon();

	perks[0] = "specialty_null";
	perks[1] = "specialty_null";
	perks[2] = "specialty_null";
	self thread maps\mp\gametypes\_globallogic::cancelKillCamOnUse();
	self thread maps\mp\gametypes\_killcam::killcam(seeker getEntityNumber(), -1, sWeapon, 1.75, 5, true, undefined, perks, seeker);*/

	// Caught
	self notify("caught");
}

catchSound()
{
	self endon("disconnect");
	wait 0.1;
	self playLocalSound("mp_obj_returned");
}

addStreak()
{
	self.cur_streak++;

	// isDefined against bots
	if (isDefined(self.stat_streak) && self.cur_streak > self.stat_streak)
	{
		self.stat_streak = self.cur_streak;
		self setStat(3153, self.stat_streak);
	}
}

addDeath()
{
	self.deaths++;
	//sum = self getStat(3156) + 1;
	self setStat(3156, self getStat(3156) + 1);

	// Site statistics
	/*if (sum > getDvarInt("max_death"))
	{
		setDvar("max_death", sum);
		setDvar("max_death_owner", self.name);
		self thread freshStat();
	}*/
}

giveSensor()
{
	self giveWeapon("radar_mp"); // Give weapon
	self setActionSlot(4, "weapon", "radar_mp"); // Set to action slot
}

giveJammer()
{
	self giveWeapon("airstrike_mp"); // Give weapon
	self setActionSlot(3, "weapon", "airstrike_mp"); // Set to action slot
}

money(org)
{
	level endon("endround");

	n = level.money.size;
	level.money[n] = [];
	level.money[n]["model"] = spawn("script_model", org);
	level.money[n]["model"] setModel("com_red_toolbox"); // com_golden_brick
	level.money[n]["model"] rotateVelocity((0, 10, 0), 600);

	level.money[n]["fx"] = spawn("script_model", org);
	level.money[n]["fx"] setModel("tag_origin");

	level.money[n]["trigger"] = spawn("trigger_radius", org, 0, 32, 32);

	org = undefined;
	wait 0.05;
	playFxOnTag(level.moneyFX, level.money[n]["fx"], "tag_origin");

	while (true)
	{
		level.money[n]["trigger"] waittill("trigger", player);

		if (!isDefined(player) || !isPlayer(player) || !isAlive(player))
			continue;

		player.money++;
		player iPrintLn(level.s["gotmoney" + player.lang] + " [" + player.money + "/4]");

		if (player.money == 4)
		{
			player.money = 0;
			player.markers++;
			if (player.team == "axis" || player.modelID != 5) // Dogs can't get marker
			{
				player giveMarker();
			}
			player iPrintLnBold(level.s["gotmarker" + player.lang]);
		}

		level.money[n]["model"] delete();
		level.money[n]["fx"] delete();
		level.money[n]["trigger"] delete();
		level.money[n] = [];

		break;
	}
}

seekerPackage()
{
	// Primary weapon
	self maxAmmo(self.weapon);
	self.ammo = weaponMaxAmmo(self.weapon);

	// Secondary weapon
	if (!isDefined(self.secondaryWeapon))
	{
		self.secondaryWeapon = "winchester1200_mp";
		self giveWeapon(self.secondaryWeapon, self getCamo());
	}
	self maxAmmo(self.secondaryWeapon);
	self.secondaryAmmo = weaponMaxAmmo(self.secondaryWeapon);

	// Phosphorous grenade
	self giveWeapon("flash_grenade_mp");
	if (!isDefined(self.flashGrenade))
		self thread checkExpNade();

	// Message
	return level.s["gotammo" + self.lang];
}

maxSeekerAmmo()
{
	self maxAmmo(self.weapon);
	self.ammo = weaponMaxAmmo(self.weapon);

	if (isDefined(self.secondaryWeapon))
	{
		self maxAmmo(self.secondaryWeapon);
		self.secondaryAmmo = weaponMaxAmmo(self.secondaryWeapon);
	}

	if (isDefined(self.flashGrenade))
	{
		self giveWeapon("flash_grenade_mp"); // Phosphorus grenade
	}
}

maxAmmo(weapon)
{
	self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
	self setWeaponAmmoStock(weapon, weaponMaxAmmo(weapon) - weaponClipSize(weapon));
}

killStreak(text, streak)
{
	// Against "g_configFindStringIndex(309): Overflow" error
	/*self iPrintLnBold(level.s["killstreak" + self.lang], streak);
	self iPrintLnBold(level.s[text + self.lang]);
	self playLocalSound("mp_killstreak_radar");*/

	self endon("disconnect");

	msg = spawnStruct();
	msg.titleLabel = level.s["killstreak" + self.lang];
	msg.titleText = streak;
	msg.notifyText = level.s[text + self.lang];
	msg.sound = "mp_killstreak_radar";
	self maps\mp\gametypes\_hud_message::notifyMessage(msg);
}

checkSpecial()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	while (true)
	{
		realWeapon = self getCurrentWeapon();
		self waittill("weapon_change");
		wpn = self getCurrentWeapon();

		if (wpn == "radar_mp" || wpn == "airstrike_mp")
		{
			self thread [[level.onXPEvent]]("spec");

			self takeWeapon(wpn);
			if (wpn == "radar_mp")
			{
				self.sensor = undefined;
				self thread sensor();
				self setActionSlot(4, "");
				for (i = 0; i < level.players.size; i++)
				{
					level.players[i] iPrintLn("^1" + self.name + " " + level.s["hassensor" + level.players[i].lang]);
				}
			}
			else
			{
				self.jammer = undefined;
				thread jammer();
				self setActionSlot(3, "");
				for (i = 0; i < level.players.size; i++)
				{
					level.players[i] iPrintLn("^1" + self.name + " " + level.s["hasjammer" + level.players[i].lang]);
				}
			}
			if (realWeapon != "none")
			{
				self switchToWeapon(realWeapon);
			}
			else
			{
				self switchToWeapon(self.weapon);
			}
		}
		/*else if (wpn == "frag_grenade_mp")
		{
			if (isDefined(level.plane))
			{
				self iPrintLnBold(level.s["fullair" + self.lang]);
				self switchToWeapon(realWeapon);
			}
		}*/
		else
		{
			realWeapon = wpn;
		}
	}
}

jammer()
{
	level notify("jammer");

	level endon("endround");
	level endon("jammer");

	level.jammer = true;

	for (i = 0; i < level.players.size; i++)
	{
		if (level.players[i].team == "allies")
		{
			//if (level.players[i].pers["rank"] >= 24)
			//{
			if (!isDefined(level.players[i].prevent))
			{
				level.players[i] setClientDvar("g_compassShowEnemies", 0);
				level.players[i] playLocalSound("jammer_enemy" + randomIntRange(1, 3)); // 1 to 2
			}
			//}
		}
		else if (level.players[i].team == "axis")
		{
			level.players[i] playLocalSound("jammer" + randomIntRange(1, 3)); // 1 to 2
		}
	}

	wait 10;

	level.jammer = false;

	waitStatusUpdate();
	for (i = 0; i < level.playerCount["allies"]; i++)
	{
		if (level.alivePlayers["allies"][i].pers["rank"] >= 24 && !isDefined(level.players[i].prevent))
		{
			level.alivePlayers["allies"][i] setClientDvar("g_compassShowEnemies", 1);
		}
	}
}

newClock()
{
	clock = newClientHudElem(self);
	clock.width = 64;
	clock.height = 64;
	clock.alignX = "left";
	clock.alignY = "bottom";
	clock.horzALign = "left";
	clock.vertAlign = "bottom";
	clock.x = 10;
	clock.y = -175;
	clock setClock(10, 60, "hudstopwatch", 64, 64);
	return clock;
}

sensor()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	// Clock
	self.sensclock = self newClock();

	time = 0;
	while (time < 10)
	{
		waitStatusUpdate();
		if (level.playerCount["allies"])
		{
			// 0. Player is undefined if player disconnects this time
			if (!isDefined(level.alivePlayers["allies"][0]))
			{
				waittillframeend;
				continue;
			}

			dis = 1000; // Set it bigger than the radius of sensor
			for (i = 0; i < level.playerCount["allies"]; i++)
			{
				if (!isDefined(level.alivePlayers["allies"][i].prevent)) // self != level.alivePlayers["allies"][i] && 
				{
					cur = distance(self.origin, level.alivePlayers["allies"][i].origin);
					if (cur < dis)
					{
						dis = cur;
					}
				}
			}
			if (dis <= 650)
			{
				if (dis <= 450)
				{
					if (dis <= 250)
					{
						time += self beep(3);
					}
					else
					{
						time += self beep(2);
					}
				}
				else
				{
					time += self beep(1);
				}
				time += addTime(0.75);
			}
		}
		time += addTime(0.1);
	}
	self.sensclock destroy();
}

knifeSign()
{
	sign = newTeamHudElem("axis");
	sign.x = self.origin[0];
	sign.y = self.origin[1];
	sign.z = self.origin[2] + 64;
	sign.isFlashing = false;
	sign.isShown = true;
	sign setShader("waypoint_knife", 8, 8);
	sign setWaypoint(true);

	wait 4;

	sign fadeOverTime(1);
	sign.alpha = 0;

	wait 1;

	sign destroy();
}

end()
{
	if (level.players.size)
	{
		// Remove counter
		counterOff();

		// Get the first player
		player = level.players[0];
		two = false;
		for (i = 1; i < level.players.size; i++)
		{
			if (level.players[i].score > player.score)
			{
				two = false;
				player = level.players[i];
			}
			else if (level.players[i].score == player.score)
			{
				two = true;
			}
		}
		if (!two && player.score > 55)
		{
			// Dominator Challenge
			player checkStat(64);
		}

		// Next map
		if (!getDvarInt("scr_hns_mapvote"))
		{
			mode = getDvarInt("scr_hns_nextmapmode");
			if (mode > 0)
				iPrintLn("^3Next map: ^2" + getNextMap());
			else if (!mode)
				maps\mp\gametypes\_ext::echoNextMap(getNextMap());
		}
	}
}

intermission()
{
	if (getDvarInt("scr_hns_mapvote") && level.players.size)
	{
		level.settime = true;
		setGameEndTime(getTime() + int((getDvarFloat("scr_intermission_time") + 10) * 1000));
		level.maps = [];
		level.mapCount = 0;
		maps = strTok(getDvar("sv_mapRotation"), " ");
		for (i = 1; i < maps.size; i += 2)
		{
			if (maps[i - 1] == "map" && maps[i] != level.script && (!isDefined(level.smallMap[maps[i]]) || level.players.size < 15)) // not "gametype", not the current map, and not small map with many players
			{
				level.maps[level.mapCount] = spawnStruct();
				level.maps[level.mapCount].map = maps[i];
				level.maps[level.mapCount].mapname = mapName(maps[i]);
				level.maps[level.mapCount].vote = 0;
				level.mapCount++;
			}
		}
		// Minimum 1 map is required for a valid vote
		if (level.mapCount > 1)
		{
			if (getDvarInt("scr_hns_freevote"))
				getVoteMapsRandom();
			else
				maps\mp\gametypes\_ext::getVoteMaps();

			for (i = 0; i < level.players.size; i++)
			{
				for (j = 0; j < level.mapCount; j++)
				{
					level.players[i] setClientDvars(
						"map" + j, level.maps[j].map,
						"map" + j + "_name", level.maps[j].mapname,
						"map" + j + "_count", 0
					);
				}
				level.players[i] setClientDvar("mapcount", level.mapCount);
				level.players[i].vote = -1;
				level.players[i] openMenu("vote");
			}

			wait 10;

			// Winner
			w = 0;
			for (i = 1; i < level.mapCount; i++)
			{
				if (level.maps[i].vote > level.maps[w].vote)
				{
					w = i;
				}
			}
			level.nextMap = level.maps[w].map;
			level.maps = undefined;

			if (!getDvarInt("scr_hns_freevote"))
				maps\mp\gametypes\_ext::handleVoteResult();

			mode = getDvarInt("scr_hns_nextmapmode");
			if (mode > 0)
				iPrintLn("^3Next map: ^2" + mapName(level.nextMap));
			else if (!mode)
				maps\mp\gametypes\_ext::echoNextMap(mapName(level.nextMap));
		}
	}

	if (level.melons)
		thread melons();
}

getVoteMapsRandom() {
	while (level.mapCount > 5)
	{
		id = randomInt(level.mapCount);
		level.mapCount--;

		if (id != level.mapCount)
			level.maps[id] = level.maps[level.mapCount];

		level.maps[level.mapCount] = undefined;
	}
}

getNextMap()
{
	maps = strTok(getDvar("sv_mapRotation"), " ");
	nextMap = "";
	for (i = 1; i < maps.size && nextMap == ""; i += 2)
	{
		if (maps[i] == level.script)
		{
			// Last map
			if (i + 1 == maps.size)
			{
				if (maps[0] == "gametype")
					nextMap = mapName(maps[3]) + " (" + maps[1] + ")";
				else
					nextMap = mapName(maps[1]);
			}
			else
			{
				if (maps[i + 1] == "gametype")
					nextMap = mapName(maps[i + 4]) + " (" + maps[i + 2] + ")";
				else
					nextMap = mapName(maps[i + 2]);
			}
		}
	}
	if (nextMap == "")
		nextMap = "Unknown";

	return nextMap;
}

mapName(map)
{
	switch (map)
	{
		case "mp_backlot":
			map = "Backlot";
		break;
		case "mp_bloc":
			map = "Bloc";
		break;
		case "mp_bog":
			map = "Bog";
		break;
		case "mp_broadcast":
			map = "Broadcast";
		break;
		case "mp_carentan":
			map = "Chinatown";
		break;
		case "mp_cargoship":
			map = "Wet Work";
		break;
		case "mp_citystreets":
			map = "District";
		break;
		case "mp_convoy":
			map = "Ambush";
		break;
		case "mp_countdown":
			map = "Countdown";
		break;
		case "mp_crash":
			map = "Crash";
		break;
		case "mp_crash_snow":
			map = "Winter Crash";
		break;
		case "mp_creek":
			map = "Creek";
		break;
		case "mp_crossfire":
			map = "Crossfire";
		break;
		case "mp_farm":
			map = "Downpour";
		break;
		case "mp_killhouse":
			map = "Killhouse";
		break;
		case "mp_overgrown":
			map = "Overgrown";
		break;
		case "mp_pipeline":
			map = "Pipeline";
		break;
		case "mp_shipment":
			map = "Shipment";
		break;
		case "mp_showdown":
			map = "Showdown";
		break;
		case "mp_strike":
			map = "Strike";
		break;
		case "mp_vacant":
			map = "Vacant";
		break;
		case "mp_cluster":
			map = "Cluster";
		break;
		case "mp_backyard":
			map = "Backyard";
		break;
		case "mp_fav":
			map = "Favela";
		break;
		/*case "mp_hns_impact":
			map = "Impact";
		break;*/
		default:
			m = getDvar("hns_mapname_" + map);
			if (m != "")
				map = m;
		break;
	}
	return map;
}

melons()
{
	// There can be more mp_global_intermission entities too
	o = getEntArray("mp_global_intermission", "classname")[0].origin;
	playFx(level.dustFX, o);

	while (true)
	{
		playFX(level.fallFX, o + (randomIntRange(-1000, 1000), randomIntRange(-1000, 1000), 1000));
		wait 0.05;
	}
}

damageModel(player)
{
	player endon("disconnect");
	player endon("caught");
	player endon("spawn"); // joined_team
	player endon("joined_spectators");

	if (isDefined(self.attachment) && self.attachment)
	{
		player endon("freshmodel");
	}

	while (!player.killed)
	{
		self waittill("damage", damage, attacker, dir, point, mod, model, tag, part, iDFlags);

		if ((iDFlags & level.iDFLAGS_PENETRATION && !isDefined(attacker.penetrate)) || !isDefined(attacker.team) || attacker.team != "axis" || (mod != "MOD_RIFLE_BULLET" && mod != "MOD_PISTOL_BULLET" && mod != "MOD_MELEE" && mod != "MOD_GRENADE_SPLASH"))
			continue;

		player deathLog(attacker, model, damage, mod, tag);
		player catchHider(attacker, mod);
	}
}

deathLog(attacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc)
{
	logPrint("K;" + self.realguid + ";" + self getEntityNumber() + ";" + self.team + ";" + self.name + ";" + attacker.realguid + ";" + attacker getEntityNumber() + ";" + attacker.team + ";" + attacker.name + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
}

freshModel(restore)
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	if (isDefined(self.bmodel))
	{
		self notify("freshmodel");
		self restoreAttachments(restore);
		self setClientDvar("model", self.showmodel);

		// Remove light
		if (isDefined(self.light))
			self.light delete();

		if (self.showmodel != "seeker")
		{
			// Restore model fix
			self.fixed = false;
			self setClientDvar("rotation", "ROTATION" + self.rotateType);
			//self.rotation.label = level.s["rotation" + toLower(self.rotateType) + self.lang];

			// If someone is using dog under level 5, nor can they run silently with object!
			if (isDefined(self.modelID) && self.modelID == 5 && !isDefined(self.quiet))
				self clearPerks();

			// Pistol
			if (isDefined(self.hiderAmmo) && self hasWeapon("colt45_silencer_mp"))
			{
				self.hiderAmmo = self getAmmoCount("colt45_silencer_mp");
			}

			// Save current weapon
			if (self getCurrentWeapon() != "none")
			{
				self.hiderWeapon = self getCurrentWeapon();
			}

			self enableAds(false);
			self takeAllWeapons();
			self detachAll();
			self setModel("fake");
			self.bmodel.xangle = 0;
			self.bmodel unLink();
			self.bmodel setModel(self.showmodel);
			self.bmodel.angles = self.angles;
			self optimizeOrigin(self.bmodel, self.showmodel);
			switch (self.showmodel)
			{
				case "me_gas_pump":
				case "me_corrugated_metal8x8":
				case "ch_dinercounterchair":
				case "me_concrete_barrier":
				case "com_cafe_chair":
				case "com_cafe_chair2":
				case "cargocontainer_20ft_red":
				//case "cargocontainer_20ft_white":
				case "ch_bedframemetal_gray":
				case "ch_bedframemetal_dark":
				case "ch_lawnmower":
				case "ch_mattress_2":
				case "ch_mattress_3":
				case "com_plasticcase_beige_big":
				case "com_barrier_tall1":
				case "vehicle_delivery_truck":
				case "com_bench":
				case "me_construction_dumpster_open":
				case "me_ac_window":
				case "me_telegraphpole":
				case "snowman":
				case "mil_bunker_bed1":
				case "mil_bunker_bed2":
				case "mil_bunker_bed3":
				case "com_mannequin3":
				case "ct_statue_chineselionstonebase":
				case "me_market_stand1":
				case "com_office_chair_black":
				case "com_industrialtrashbin":
				case "com_server_rack_sid":
					self.bmodel.angles += (0, 90, 0);
				break;

				case "me_sign_stop":
				case "me_sign_noentry":
				case "ch_sign_noentry":
				case "ch_sign_nopedestrians":
				case "ch_sign_noparking":
				case "ch_sign_stopsign":
				case "ch_washer_01":
				case "com_water_heater":
				case "com_bookshelveswide":
				case "com_stove":
				case "com_stove_d":
				case "ch_gas_pump":
				case "ch_baby_carriage":
				case "com_northafrica_armoire_short":
				case "ct_statue_chinese_lion":
				case "ct_statue_chinese_lion_gold":
				case "cs_monitor1":
				case "me_market_stand4":
				case "com_restaurantchair_2":
				case "cs_steeringwheel":
					self.bmodel.angles += (0, 270, 0);
				break;

				case "com_bike":
				case "com_dresser":
				case "com_dresser_d":
				case "me_dumpster":
				case "me_dumpster_close":
				case "com_filecabinetblackclosed":
				case "ch_furniture_teachers_desk1":
				case "com_armoire_d":
				case "bathroom_toilet":
				case "com_shopping_cart":
					self.bmodel.angles += (0, 180, 0);
				break;
				case "com_rowboat":
					self.bmodel.angles += (0, 270, 180);
					self.bmodel.xangle = 180;
				break;
				case "com_steel_ladder":
					self.bmodel.angles += (0, 180, 180);
					self.bmodel.xangle = 180;
				break;
			}
			self.bmodel linkTo(self);

			// Save the current model for fast-reloading
			self.saveModel = self.showmodel;

			self hide();
		}
		else
		{
			self.bmodel setModel("tag_origin");

			self getModel();
			if (self.modelID == 5)
			{
				self setModel("german_sheperd_dog");
				self setViewmodel("viewhands_dog");

				if (self.pers["rank"] >= 110) // Rank 111
				{
					// Angry dog
					self giveWeapon("briefcase_bomb_mp");
					self switchToWeapon("briefcase_bomb_mp");
				}
				else
				{
					// Normal dog
					self giveWeapon("helicopter_mp");
					self switchToWeapon("helicopter_mp");
				}

				self enableAds(false);
				self setPerk("specialty_quieter");
				//self setTP(true); // Deprecated switching to TPS when using a dog
			}
			else
			{
				self enableAds(true);
				self giveWeapon(level.weapons[self getWeapon()][0], self getCamo());

				self playerModel();

				// Give pistol
				if (isDefined(self.hiderAmmo))
				{
					self giveWeapon("colt45_silencer_mp");
					if (self.hiderAmmo)
					{
						self setWeaponAmmoClip("colt45_silencer_mp", 1);
						self setWeaponAmmoStock("colt45_silencer_mp", self.hiderAmmo - 1);
					}
					else
					{
						self setWeaponAmmoClip("colt45_silencer_mp", 0);
						self setWeaponAmmoStock("colt45_silencer_mp", 0);
					}
				}

				// Give markers
				if (self.markers)
				{
					self giveMarker();
				}

				// Grenade
				self giveWeapon("smoke_grenade_mp");
				self setWeaponAmmoClip("smoke_grenade_mp", self.smokeGrenade);

				// Switch weapon
				self switchToWeapon(self.hiderWeapon);
			}

			self show();
		}
	}
}

setZOrigin(z)
{
	self.origin += (0, 0, z);
}

setXYOrigin(p, x, y)
{
	angle = self.angles[1];

	if (y)
		angle += asin(y / sqrt(x * x + y * y)); // Sinus theorem with Pythagoras

	self.origin = p.origin + (x * cos(angle), x * sin(angle), 0);
}

optimizeOrigin(model, modelname)
{
	model.origin = self.origin;
	switch (modelname)
	{
		case "com_woodlog_24_192_d":
			model setZOrigin(8);
		break;
		case "com_playpen":
			model setZOrigin(16);
		break;
		case "mil_bunker_bed1":
		case "com_rowboat":
			model setZOrigin(24);
		break;
		case "me_corrugated_metal8x8":
			model setZOrigin(48);
		break;
		case "com_propane_tank02":
			model setZOrigin(54);
		break;
		case "me_refrigerator":
		case "me_refrigerator2":
		case "me_refrigerator_d":
		case "com_restaurantsink_1comp":
		case "com_restaurantsink_2comps":
			model setXYOrigin(self, -16, 0);
		break;
		case "mil_razorwire_long_static":
			model setXYOrigin(self, -160, 0);
		break;
		/*case "foliage_red_pine_lg":
			model.origin += (0, 0, 16);
		break;*/
		/*case "bathroom_sink":
			model setZOrigin(32);
		break;*/
	}
}

getXDegrees()
{
	if (!self.bmodel.xangle)
		return self.bmodel.angles[2];

	a = self.bmodel.angles[2] - self.bmodel.xangle;

	if (a > 180)
		return a - 360;
	else if (a < -180)
		return a + 360;

	return a;
}

rotateModel()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	while (true)
	{
		wait 0.05;
		if (self attackButtonPressed())
		{
			time = 0;
			while (self attackButtonPressed() && time < 0.5)
			{
				time += addTime(0.05);
			}

			if (time == 0.5 && self.allowRun && level.alreadyPlay)
			{
				self thread sprint();
			}
			else
			{
				self.fixed = false;
				switch (self.rotateType)
				{
					case "X" : self.rotateType = "RX"; break;
					case "RX" : self.rotateType = "Y"; break;
					case "Y" : self.rotateType = "RY"; break;
					case "RY" : self.rotateType = "Z"; break;
					case "Z" : self.rotateType = "X"; break;
				}
				self setClientDvar("rotation", "ROTATION" + self.rotateType);
				//self.rotation.label = level.s["rotation" + toLower(self.rotateType) + self.lang];
			}
			while (self attackButtonPressed())
			{
				wait 0.05;
			}
		}
		else if (self meleeButtonPressed())
		{
			self.fixed = false;
			self.bmodel unLink();

			// Check angle limitation defined in the config file
			m = getDvarInt("scr_hns_maxangle_" + self.showmodel);
			if (m > 0 && m <= 180 && !(m % 5))
			{
				degrees = m;
			}
			else
			{
				// Default rotation angle
				degrees = 20;

				// Map specific limitations
				if (level.script == "mp_creek")
				{
					switch (self.showmodel)
					{
						case "mil_sandbag_desert_curved":
						case "com_lamp_ornate_off":
						//case "com_lamp_ornate_on":
							degrees = 5;
						break;
					}
				}

				// Global limitations
				switch (self.showmodel)
				{
					case "ch_mattress_2":
					case "ch_mattress_3":
					case "com_restaurantstainlessteelshelf_01":
					case "com_restaurantstainlessteelshelf_02":
					case "ch_bedframemetal_gray":
					case "ch_bedframemetal_dark":
					case "com_restaurantsink_1comp":
					case "com_restaurantsink_2comps":
					case "com_folding_table":
					case "me_telegraphpole":
					case "me_telegraphpole2":
					case "com_powerpole1":
					case "com_powerpole3":
					case "me_streetlight":
					case "me_streetlight_on":
					case "me_streetlightdual":
					case "com_cafe_chair":
					case "com_cafe_chair2":
					case "com_restaurantkitchentable_1":
					case "me_market_umbrella_3":
					case "me_market_umbrella_5":
					case "me_market_umbrella_6":
					case "com_ladder_wood":
					case "mil_bunker_bed1":
					case "com_steel_ladder":
					case "com_water_tank1":
					case "me_antenna":
					case "me_antenna2":
					case "me_antenna3":
					case "me_sign_stop":
					case "me_sign_noentry":
					case "ch_sign_noentry":
					case "ch_sign_nopedestrians":
					case "ch_sign_noparking":
					case "ch_sign_stopsign":
					case "com_newspaperbox_blue":
					case "com_newspaperbox_red":
					case "com_basketball_goal":
					case "mil_razorwire_long_static":
						degrees = 5;
					break;
					case "com_cafe_table1":
					case "com_cafe_table2":
						degrees = 10;
					break;
					case "com_barrel_white_rust":
					case "com_barrel_blue_rust":
					case "com_barrel_black_rust":
					case "com_barrel_fire":
					case "com_barrel_green_dirt":
					case "com_barrel_biohazard_rust":
					case "com_barrel_green":
					case "com_barrel_tan_rust":
					case "me_corrugated_metal8x8":
						degrees = 30;
					break;
				}
			}

			switch (self.rotateType)
			{
				case "X":
					if (self getXDegrees() < degrees)
					{
						self.bmodel.angles += (0, 0, 5);
					}
				break;
				case "RX":
					if (self getXDegrees() > -1 * degrees)
					{
						self.bmodel.angles -= (0, 0, 5);
					}
				break;
				case "Y":
					newY = getRealY(self.bmodel.angles[0]);
					if (newY < degrees)
					{
						self.bmodel.angles = (newY + 5, self.bmodel.angles[1], self.bmodel.angles[2]);
					}
				break;
				case "RY":
					newY = getRealY(self.bmodel.angles[0]);
					if (newY > -1 * degrees)
					{
						self.bmodel.angles = (newY - 5, self.bmodel.angles[1], self.bmodel.angles[2]);
					}
				break;
				case "Z":
					self.bmodel.angles += (0, 10, 0);
				break;
			}

			self optimizeOrigin(self.bmodel, self.showmodel);
			self.bmodel linkTo(self);
		}
		else if (self fragButtonPressed())
		{
			time = 0;
			while (self fragButtonPressed() && time < 0.5)
			{
				time += addTime(0.05);
			}

			// 'if 0.5' is checked in setThirdPerson
			if (time != 0.5)
			{
				if (self.showmodel != "seeker")
				{
					self.fixed = false;
					self freshModel();
				}
			}
			else
			{
				while (self fragButtonPressed())
				{
					wait 0.05;
				}
			}
		}
		else if (self useButtonPressed() && !isDefined(self.pers["isBot"]))
		{
			time = 0;
			while (self useButtonPressed())
			{
				time += addTime(0.05);

				// Hold to teleport
				if (time == 0.5 && level.alreadyPlay && isDefined(self.teleport))
				{
					self.teleport = undefined;
					playFX(level.teleFX, self.origin);
					spawn = level.spawnpoints[randomInt(level.spawnpoints.size)];
					self setOrigin(spawn.origin);
					self setPlayerAngles(spawn.angles);
					playFX(level.deathFX[self getFX()], spawn.origin + (0, 0, 32));
				}
			}

			// Change ready-up state when holding it (in hiding time)
			if (time < 0.5 && self.showmodel != "seeker")
			{
				if (self.fixed)
				{
					self.fixed = false;
				}
				else
				{
					self.fixed = true;
					self setClientDvars(
						"rotation", "ROTATIONFIXED",
						"fix", "UNFIX"
					);
					//self.rotation.label = level.s["rotationfixed" + self.lang];
					//self.fixInfo.label = level.s["unfix" + self.lang];

					self thread fixModel();
				}
			}
		}
		else if (self adsButtonPressed())
		{
			time = 0;
			while (self adsButtonPressed() && time < 0.25)
			{
				time += addTime(0.05);
			}

			if (time != 0.25)
			{
				self fastSwitchModel();
			}
			else if (self.canAds)
			{
				while (self adsButtonPressed())
				{
					wait 0.05;
				}
			}
			else
			{
				// It is already false, but calling it will stop the player adsing
				self allowAds(false);
			}
		}
	}
}

fastSwitchModel()
{
	if (self.showmodel == "seeker")
	{
		self maps\mp\gametypes\_weapons::detach_all_weapons();
		if (isDefined(self.saveModel))
		{
			self.showmodel = self.saveModel;
		}
	}
	else
	{
		self.showmodel = "seeker";
	}

	self freshModel();
}

sprint()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");

	self.allowRun = false;
	self setMoveSpeedScale(1.5);

	// Clock
	self.clock = self newClock();

	wait 10;

	self setMoveSpeedScale(1);

	// Sometimes it is undefined - reason is unknown
	if (isDefined(self.clock))
	{
		self.clock destroy();
	}
}

fixModel()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	saveAngle = self.bmodel.angles;

	while (self.fixed)
	{
		self.bmodel unLink();
		self.bmodel.angles = saveAngle;
		self optimizeOrigin(self.bmodel, self.showmodel);
		self.bmodel linkTo(self);

		wait 0.05;
	}
	self setClientDvars(
		"rotation", "ROTATION" + self.rotateType,
		"fix", "FIX"
	);
	//self.rotation.label = level.s["rotation" + toLower(self.rotateType) + self.lang];
	//self.fixInfo.label = level.s["fix" + self.lang];
}

getRealY(y)
{
	if (y >= 180)
	{
		return y - 360;
	}
	else
	{
		return y;
	}
}

newRound()
{
	level endon("endround");

	level.alreadyPlay = false;
	level.gameStarted = false;
	level.oneLeft = false;

	if (level.jammer)
	{
		level.jammer = false;
		waitStatusUpdate();
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			if (level.alivePlayers["allies"][i].pers["rank"] >= 24)
			{
				level.alivePlayers["allies"][i] setClientDvar("g_compassShowEnemies", 1);
			}
		}
	}

	waittillframeend;

	// Waiting for other players...
	if (level.playerCount["allies"] + level.playerCount["axis"] < 2)
	{
		counterOff();
		while (level.playerCount["allies"] + level.playerCount["axis"] < 2)
		{
			for (i = 0; i < level.players.size; i++)
			{
				level.players[i] iPrintLnBold(level.s["waiting" + level.players[i].lang]);
			}
			wait 10;
		}
	}

	// Start
	level.gameStarted = true;

	// New round
	level roundTime();

	// We have to avoid seekers, who have connected in the same frame
	for (i = 1; i < level.playerCount["axis"]; i++)
	{
		level.alivePlayers["axis"][i] [[level.allies]]();
	}
	seeker = level.alivePlayers["axis"][0];

	// Seeker is undefined if player disconnects this time
	if (!isDefined(seeker))
	{
		thread newRound();
		return;
	}

	level.fade = newClientHudElem(seeker);
	level.fade.width = 960;
	level.fade.height = 480;
	level.fade.alignX = "left";
	level.fade.alignY = "top";
	level.fade.horzAlign = "left";
	level.fade.vertAlign = "top";
	level.fade setShader("$black", 960, 480);
	//level.fade.alpha = 1;
	level.fade.sort = -1;
	level.fade.hideWhenInMenu = false;
	level.fade.owner = seeker;
	seeker freezeControls(true);
	seeker setPlayerAngles((-85, 0, 0));
	seeker thread restoreSeeker();

	//if (!(seeker getStat(3175)))
	seeker thread notifySeeking();

	level countBack(seeker);

	counterOff();

	if (!level.forcedEnd)
	{
		if (isDefined(seeker))
		{
			seeker freezeControls(false);
		}

		// Reset sprint
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			level.alivePlayers["allies"][i] allowSprint(true);
		}
	}
}

notifySeeking()
{
	self endon("disconnect");
	level endon("endround");

	self iPrintLnBold(level.s["alert1" + self.lang]);
	wait 2;
	self iPrintLnBold(level.s["alert2" + self.lang]);
	//self setStat(3175, 1);
}

// If every hider disconnect, we must unfreeze the seeker
restoreSeeker()
{
	self endon("disconnect");
	level endon("play");

	level waittill("endround");
	self freezeControls(false);
}

roundTime()
{
	level endon("endround");

	// New round
	counterOn(level.roundTime, level.s["round_time"]);
	wait level.roundTime;
}

countBack(seeker)
{
	level endon("endround");

	// Hiding time
	counterOn(level.hidetimer, level.s["hide_time"]);
	if (level.readyUp)
	{
		for (i = 0; i < level.hidetimer; i++)
		{
			wait 1;

			l = true;
			for (j = 0; l && j < level.playerCount["allies"]; j++)
			{
				if (isDefined(level.playerCount["allies"]) && !level.alivePlayers["allies"][j].ready)
				{
					l = false;
				}
			}

			if (l)
				break;
		}
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			if (isDefined(level.alivePlayers["allies"][i]))
			{
				level.alivePlayers["allies"][i] setStatusIcon();
			}
		}
	}
	else
	{
		wait level.hidetimer;
	}

	level.fade destroy();

	seeker maxSeekerAmmo();
	seeker freezeControls(false);

	waitStatusUpdate();
	for (i = 0; i < level.playerCount["allies"]; i++)
	{
		// Ammo
		if (isDefined(level.alivePlayers["allies"][i].hiderAmmo))
		{
			level.alivePlayers["allies"][i].hiderAmmo = 1;
			if (level.alivePlayers["allies"][i].showmodel == "seeker")
			{
				level.alivePlayers["allies"][i] setWeaponAmmoClip("colt45_silencer_mp", 1);
				level.alivePlayers["allies"][i] setWeaponAmmoStock("colt45_silencer_mp", 0);
			}
		}

		level.alivePlayers["allies"][i] allowSprint(false);
		level.alivePlayers["allies"][i] thread watchHideout();
	}

	// Start real palying
	level notify("play");
	level.alreadyPlay = true;

	// Reaper horn
	for (i = 0; i < level.players.size; i++)
	{
		level.players[i] playLocalSound("start");
		level.players[i] thread showFlash();
	}

	// Seeking
	level.time = int(max(level.timer - (level.playerCount["allies"] - 1) * level.difftime, level.mintime));
	counterOn(level.time, level.s["seek_time"]);

	// Check if there is one one hider
	thread oneHider();

	// Seeker is invincible for 5 seconds (spawn protect)
	seeker thread spawnProtect();
	seeker = undefined;

	thread eyeContacts();

	// Timer for last hider will be always 1 minute
	while (level.time)
	{
		if (level.time == level.hurryTime)
		{
			for (j = 0; j < level.activePlayers.size; j++)
			{
				level.activePlayers[j] playLocalSound("ui_mp_suitcasebomb_timer");
			}
		}
		level.time--;
		wait 1;
	}

	// Hiders won ~ Must be threaded, so "endround" notify wont stop it
	thread addPoint("allies");
}

showFlash()
{
	self endon("disconnect");

	flash = newClientHudElem(self);
	flash.width = 960;
	flash.height = 480;
	flash.alignX = "left";
	flash.alignY = "top";
	flash.horzAlign = "left";
	flash.vertAlign = "top";
	flash setShader("white", 960, 480);
	flash.alpha = 1;
	flash.sort = -1;
	wait 0.25;
	flash fadeOverTime(1.5);
	flash.alpha = 0;
	wait 1.5;
	flash destroy();
}

protectPlayer()
{
	// Protection
	self.protect = true;

	// HUD image
	self.protectPic = newClientHudElem(self);
	self.protectPic.width = 48;
	self.protectPic.height = 48;
	self.protectPic setShader("protect", 48, 48);
	self.protectPic.alignX = "left";
	self.protectPic.alignY = "bottom";
	self.protectPic.horzALign = "left";
	self.protectPic.vertAlign = "bottom";
	self.protectPic.x = 10;
	self.protectPic.y = -150;

	self.headiconteam = level.enemyTeam[self.team];
	self.headicon = "protect_head";
}

unProtectPlayer()
{
	// Stop protection
	self.protect = false;

	// Sometimes it is 'undefined'
	if (isDefined(self.protectPic))
	{
		self.protectPic destroy();
	}

	// Put back Schnappi icon
	self.headiconteam = self.team;
	if (self.schnappi)
		self.headicon = "schnappi_head";
	else
		self.headicon = "";
}

spawnProtect()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	self protectPlayer();
	origin = self.origin;

	// Initial protection
	wait 5;

	// We won't check angles
	while (origin == self.origin && !self.hasDoneCombat)
	{
		wait 1;
	}

	self unProtectPlayer();
}

watchHideout()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	self.hide = true;
	pos = self.origin;
	while (pos == self.origin)
	{
		wait 0.25;
	}
	self.hide = false;
}

counterOn(time, label)
{
	level.counter.alpha = 0.85;
	level.counter setTimer(time);
	level.timertext.alpha = 0.85;
	//level.timertext.label = label;
	level.timertext setText(label);
}

counterOff()
{
	level.timertext.alpha = 0;
	level.counter.alpha = 0;
}

stratTime()
{
	counterOn(level.mapTime, level.s["map_time"]);
	wait level.mapTime;

	thread newRound();
}

changeClass()
{
	self notify("spawn");

	self removeFromTeam();

	if (self.team == "allies")
	{
		self.showmodel = "seeker";
		self [[level.class]]("CLASS_ASSAULT");
	}
	else if (self.team == "axis")
	{
		self [[level.class]]("CLASS_SNIPER");
	}
}

removeFromTeam()
{
	if (isDefined(self.bmodel))
	{
		self.bmodel delete();

		// Light
		if (isDefined(self.light))
			self.light delete();

		// Attachments
		self restoreAttachments();
	}

	/*if (isDefined(self.rotation))
	{
		self.rotation destroy();
		self.rotationInfo destroy();
		self.rotationSetInfo destroy();
		self.resetInfo destroy();
		self.fixInfo destroy();
		self.fastInfo destroy();
		self.runInfo destroy();
	}*/

	/*self setClientDvars(
		"rotation", "",
		"fix", ""
	);*/

	// Last one message
	if (isDefined(self.lastMessage))
	{
		self.lastMessage destroy();
	}

	// Spawn protect image
	if (isDefined(self.protectPic))
	{
		self.protectPic destroy();
	}

	// Clock
	if (isDefined(self.clock))
	{
		self.clock destroy();
	}

	// Sensor clock
	if (isDefined(self.sensclock))
	{
		self.sensclock destroy();
	}

	if (isDefined(self.eyes))
	{
		self.eyes = undefined;
	}

	// Last model
	self setClientDvar("lastmodel", "");

	// Last model (not defined in disconnect)
	/*if (isDefined(self.lastModel))
	{
		self.lastModel.alpha = 0;
		self.lastModelTitle.alpha = 0;
	}*/
}

joinGame()
{
	// Visibility points -> 2000-2030: ID&Points, -> Unlocked
	i = 2003;
	for (id = 0; id < 27; id++)
	{
		vis = self getStat(i);
		if (vis == level.statID || !vis)
		{
			self.visStat = i + 1;
			self.visID = 2057 + id * 9;
			if (!vis) // Not visited yet
			{
				self setStat(i, level.statID);
				self setStat(self.visStat, 0); // Just to be sure
				self.vis = 0;
				for (j = 0; j < 8; j++)
				{
					self.visStats[j] = 0;
				}
			}
			else // Already visited the server
			{
				vis = self getStat(self.visStat);
				if (vis)
				{
					vis = maps\mp\gametypes\_rank::decodeStat(vis);
					if (vis > level.defaultXP && vis < 1700000000)
					{
						self.vis = vis - level.defaultXP;
					}
					else
					{
						self.vis = 0;
						self setStat(self.visStat, 0);
					}
				}
				else
				{
					self.vis = 0;
				}
				vis = 0;
				for (j = 0; j < 8; j++)
				{
					self.visStats[j] = self getStat(self.visID + j);
					vis += self.visStats[j] * self.visStats[j];
				}
				if (hashVal(vis + level.stat) != self getStat(self.visID + 8))
				{
					for (j = 0; j < 8; j++)
					{
						self setStat(self.visID + j, 0);
						self.visStats[j] = 0;
					}
					self setStat(self.visID + 8, 0);
				}
			}
			break;
		}
		i += 2;
	}

	// Probably won't happen ever
	if (!isDefined(self.vis))
		self setClientDvar("vis", "ERROR");
	else
		self setClientDvar("vis", self.vis);

	self.totalvis = self getStat(3167);

	// Visibility points ~ If not equal, then cheater, or set by an other server
	/*vis = self getStat(3170);
	if (!vis || hash(vis) == self getStat(3169)) // Check checksum
	{
		self.vis = vis;
		self.totalvis = self getStat(3167);
		self setClientDvar("vis", vis);
	}
	else
	{
		self setClientDvar("vis", level.s["ERROR" + self.lang]);
	}*/

	// Get models
	m = level.models.size;
	for (i = 0; i < m; i++)
	{
		self setClientDvars(
			"model" + i, getModelID(level.models[i]),
			"model" + i + "_title", level.s[level.modelName[level.models[i]] + self.lang]
		);
	}

	hasstat = isDefined(self.vis);
	c = level.curext.size;
	for (i = 0; i < c; i++)
	{
		x = level.ext[level.curext[i]];
		buy = !hasstat || !(x.statval & self getStat(self.visID + x.stat));
		self setClientDvars(
			"extmodel" + i, getModelID(x.model),
			"extmodel" + i + "_title", level.s[level.modelName[x.model] + self.lang],
			"extmodel" + i + "_buy", buy
		);

		if (buy)
			self setClientDvar("extmodel" + i + "_price", x.price);
	}

	self setClientDvars(
		"vis_total", self.totalvis,
		"model_count", m,
		"seekerid", level.modelOrder["seeker"],
		"extmodel_count", c
	);

	//waitStatusUpdate();
	if (level.alreadyPlay || !level.playerCount["axis"])
		self [[level.axis]]();
	else if (level.listen || !isDefined(level.reconnect[self.guid]) || !level.playerCount["allies"])
		self [[level.allies]]();
	else
		self iPrintLnBold(level.s["later" + self.lang]);
}

getModelID(s)
{
	if (isDefined(level.modelOrder[s]))
		return level.modelOrder[s];
	else
		return s;
}

createModelInfo(xmodel)
{
	self setClientDvar("lastmodel", level.s[level.modelName[xmodel] + self.lang]);
	/*self.lastModelTitle.alpha = 0.85;
	self.lastModel.alpha = 0.85;
	self.lastModel.label = level.s[xmodel + self.lang];*/
}

oneHider()
{
	//waitStatusUpdate();
	if (level.playerCount["allies"] == 1 && !level.oneLeft)
	{
		level.oneLeft = true;

		hider = level.alivePlayers["allies"][0];
		hider playLocalSound("mp_last_stand");

		// Last hider extra points
		if (level.playerCount["axis"] >= 15)
			hider addScore("lasthider");

		// Last one message
		hider thread lastMessage();

		if (level.lastModel)
		{
			// Reset timer
			if (level.time > level.hurryTime)
			{
				level.time = level.hurryTime;
				counterOn(level.hurryTime, level.s["seek_time"]);
			}

			xmodel = "";
			while (level.oneLeft && isDefined(hider))
			{
				if (xmodel != hider.showmodel)
				{
					xmodel = hider.showmodel;

					for (i = 0; i < level.playerCount["axis"]; i++)
					{
						// Valid player
						level.alivePlayers["axis"][i] createModelInfo(xmodel);
					}
				}
				wait 1;
			}
		}
	}
}

lastMessage()
{
	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	level endon("endround");

	// HUD Element
	self.lastMessage = newClientHudElem(self);
	self.lastMessage.horzAlign = "center";
	self.lastMessage.vertAlign = "middle";
	self.lastMessage.alignX = "center";
	self.lastMessage.alignY = "middle";
	self.lastMessage.x = 0;
	self.lastMessage.y = -100;
	self.lastMessage.font = "objective";
	self.lastMessage.fontscale = 2.0;
	self.lastMessage.archived = false;
	self.lastMessage.color = (0.75,1,0.5);
	self.lastMessage setText(level.s["lastone" + self.lang]);

	wait 2.5;

	self.lastMessage fadeOverTime(0.75);
	self.lastMessage.alpha = 0;

	wait 0.5;

	self.lastMessage destroy();
}

orderTeams()
{
	if (level.gameStarted)
	{
		waitStatusUpdate();
		if (level.playerCount["allies"] + level.playerCount["axis"] < 2)
		{
			if (level.playerCount["allies"] == 1)
			{
				level.alivePlayers["allies"][0] [[level.axis]]();
			}
			endRound(true);
			thread newRound();
		}
		else if (!level.playerCount["axis"] && level.playerCount["allies"] > 1)
		{
			// Respawn & find a seeker
			seeker = randomInt(level.playerCount["allies"]);
			for (i = 0; i < level.playerCount["allies"]; i++)
			{
				if (i != seeker)
				{
					level.alivePlayers["allies"][i] [[level.allies]]();
				}
			}
			level.alivePlayers["allies"][seeker] [[level.axis]]();

			endRound(true);
			thread newRound();
		}
		else if (!level.playerCount["allies"] && level.playerCount["axis"] > 1)
		{
			id = randomInt(level.playerCount["axis"]);
			for (i = 0; i < level.playerCount["axis"]; i++)
			{
				if (i != id)
				{
					level.alivePlayers["axis"][i] [[level.allies]]();
				}
				else
				{
					// Restore player
					level.alivePlayers["axis"][i] removeFromTeam();
				}
			}

			endRound(true);
			thread newRound();
		}
		else if (level.alreadyPlay)
		{
			thread oneHider();
		}
	}
}

quickSets(response)
{
	switch (response)
	{
		// Camera distance
		case "1":
			dis = 256;
			switch (self getStat(3150))
			{
				case 1024:
					dis = 120;
				break;
				case 256:
					dis = 512;
				break;
				case 512:
					dis = 1024;
				break;
			}
			self setStat(3150, dis);
			self setClientDvar("cg_thirdPersonRange", dis);
		break;
		// Camera angle
		case "2":
			ang = 45;
			switch (self getStat(3151))
			{
				case 45:
					ang = 90;
				break;
				case 90:
					ang = 135;
				break;
				case 135:
					ang = 180;
				break;
				case 180:
					ang = 225;
				break;
				case 225:
					ang = 270;
				break;
				case 270:
					ang = 315;
				break;
				case 315:
					ang = 0;
				break;
			}
			self setStat(3151, ang);
			self setClientDvar("cg_thirdPersonAngle", ang);
		break;
		// Reset to defaults
		case "3":
			self setStat(3150, 120);
			self setClientDvar("cg_thirdPersonRange", 120);
			self setStat(3151, 0);
			self setClientDvar("cg_thirdPersonAngle", 0);
			self iPrintLnBold(level.s["resetsets" + self.lang]);
		break;
		// Music
		case "4":
			if (!self getStat(3168))
			{
				if (self.schnappi)
				{
					// Turn off Schnappi
					self stopSchnappi();

					self thread playMusic("main" + self.music);
				}
				else
				{
					self setStat(3168, 1);
					self stopMusic("main" + self.music);
					self iPrintLn(level.s["musicoff" + self.lang]);
				}
			}
			else
			{
				if (self.schnappi)
				{
					// Turn off Schnappi
					self stopSchnappi();
				}

				self setStat(3168, 0);
				self thread playMusic("main" + self.music);
				self iPrintLn(level.s["musicon" + self.lang]);
			}
		break;
		// Information
		case "5":
			self iPrintLnBold(&"MENUS_VERSION");
		break;
		// Schnappi
		case "6":
			if (self.schnappi)
			{
				self stopSchnappi();

				// Restore music
				if (!self getStat(3168))
				{
					self thread playMusic("main" + self.music);
				}
			}
			else
			{
				// Turn off music
				if (!self getStat(3168))
				{
					self stopMusic("main" + self.music);
				}

				self.schnappi = true;
				self thread playMusic("schnappi");

				if (!self.protect)
					self.headicon = "schnappi_head";

				self.schnappiPic = newClientHudElem(self);
				self.schnappiPic.width = 100;
				self.schnappiPic.height = 100;
				self.schnappiPic setShader("schnappi", 100, 100);
				self.schnappiPic.alignX = "right";
				self.schnappiPic.alignY = "top";
				self.schnappiPic.horzALign = "right";
				self.schnappiPic.vertAlign = "top";
			}
		break;
		// Moths
		case "7":
			if (!self getStat(3170))
			{
				self notify("endrain");
				self setStat(3170, 1);
				self iPrintLn(level.s["rainoff" + self.lang]);
			}
			else
			{
				if (isDefined(self.rain))
				{
					self thread rainWay(self.rain);
				}
				self setStat(3170, 0);
				self iPrintLn(level.s["rainon" + self.lang]);
			}
		break;
	}
}

stopSchnappi()
{
	self.schnappi = false;
	self stopMusic("schnappi");
	self.schnappiPic destroy();

	if (!self.protect)
		self.headicon = "";
}

playMusic(sound)
{
	self endon("disconnect");
	self endon(sound);

	while (true)
	{
		self playLocalSound(sound);
		switch (sound)
		{
			case "main":
				wait 710;
			break;
			case "main2":
				wait 131;
			break;
			case "schnappi":
				wait 129;
			break;
		}
	}
}

stopMusic(sound)
{
	self notify(sound);
	self stopLocalSound(sound);
}

damage(info)
{
	self deathLog(info.eAttacker, info.sWeapon, info.iDamage, info.sMeansOfDeath, info.sHitLoc);

	if (self.team == "allies")
	{
		self catchHider(info.eAttacker, info.sMeansOfDeath);
	}
	else
	{
		if (info.sMeansOfDeath == "MOD_MELEE")
		{
			self knifeSeeker(info.eAttacker);
		}
		else
		{
			self thread shock("poison", 5);

			// Damage feedback
			info.eAttacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback(false);
		}
	}
}

shock(shock, time)
{
	self notify("shock");

	self endon("disconnect");
	self endon("spawn"); // joined_team
	self endon("joined_spectators");
	self endon("shock");
	level endon("endround");

	self shellShock(shock, time);
	self.shock = true;
	shock = undefined;
	wait time;
	self.shock = false;
}

spectator()
{
	if (isDefined(self.active))
	{
		if (isDefined(self.ammo))
		{
			self.ammo = self getAmmoCount(self.weapon);
			if (isDefined(self.secondaryAmmo))
			{
				self.secondaryAmmo = self getAmmoCount(self.secondaryWeapon);
			}
		}
		if (isDefined(self.watch))
		{
			self.watch = undefined;
		}
		self inActive();

		// Turn off radar for sure
		self setClientDvars("g_compassShowEnemies", 0);
	}
}

inActive()
{
	last = level.activePlayers.size - 1;
	if (self.active != last)
	{
		level.activePlayers[last].active = self.active;
		level.activePlayers[self.active] = level.activePlayers[last];
	}

	level.activePlayers[last] = undefined;
	self.active = undefined;
}

addModel(model, org, ang)
{
	id = self.models.size;
	self.models[id] = spawn("script_model", self.origin);
	self.models[id] setModel(model);
	self.models[id].angles = ang;
	self.models[id].origin = self.origin + org;
	self.models[id] linkTo(self.bmodel);
	self.models[id].attachment = true;

	if (!level.alreadyPlay)
	{
		self.models[id] hide();
		self.models[id] showToPlayer(self);
	}
	else
	{
		self.models[id] setCanDamage(true);
		self.models[id] thread damageModel(self);
	}
}

disconnect()
{
	if (isDefined(self.active))
	{
		self removeFromTeam();

		// Maybe reconnecter
		if (!level.listen && !level.intermission && isDefined(self.team) && self.team == "axis" && level.playerCount["axis"] == 1 && level.playerCount["allies"])
		{
			level.reconnect[self.guid] = true;
			level.preserveRec = true;
		}
		self inActive();
	}
	if (isDefined(level.maps) && isDefined(self.vote) && self.vote != -1)
	{
		level.maps[self.vote].vote--;
	}
}

newVoteElem(x, y)
{
	voteElem = newHudElem();
	voteElem.elemType = "font";
	voteElem.font = "default";
	voteElem.fontscale = 1.4;
	voteElem.x = x;
	voteElem.y = y;
	voteElem.hideWhenInMenu = true;
	voteElem.archived = true;
	voteElem.alignX = "left";
	voteElem.alignY = "middle";
	voteElem.horzAlign = "left";
	voteElem.vertAlign = "middle";
	voteElem.color = (1, 1, 0);

	return voteElem;
}

vote(player)
{
	if (!level.voting)
	{
		for (i = 0; i < level.players.size && !level.voting; i++)
		{
			if (level.players[i] getEntityNumber() == player && level.players[i].sessionstate == "playing")
			{
				// HUD Elem
				level.vote = newVoteElem(5, -8);
				level.vote setText("Kill " + level.players[i].name + "...");

				level.votetrue = newVoteElem(5, 8);
				//level.votetrue.label = &"MENUS_VOTEYES";
				level.votetrue setText("YES(F1)");

				level.votetruecounter = newVoteElem(52, 8);
				level.votetruecounter setValue(0);

				level.votefalse = newVoteElem(70, 8);
				level.votetrue setText("NO(F2)");

				level.votefalsecounter = newVoteElem(113, 8);
				level.votefalsecounter setValue(0);

				level.voting = true;
				level.voteyes = 0;
				level.voteno = 0;

				level.players[i].allowVote = false;
				level.players[i] thread runVote();
			}
			else if (i == level.players.size - 1)
			{
				self iPrintLn(level.s["novote" + self.lang], player);
			}
		}
	}
	else
	{
		self iPrintLn(level.s["alreadyvote" + self.lang]);
	}
}

runVote()
{
	time = 0;
	while (time < 20)
	{
		// Check level.voting because of killvote command
		if (isDefined(self) && self.sessionstate == "playing" && level.voting)
		{
			level.votetruecounter setValue(level.voteyes);
			level.votefalsecounter setValue(level.voteno);
			time += addTime(0.5);
		}
		else
		{
			break;
		}
	}

	if (time == 20)
	{
		if (level.voteyes > level.voteno && level.voteyes > 1)
		{
			if (self.team == "allies")
			{
				self catchHider();
			}
			else
			{
				self [[level.axis]]();
			}
		}
	}

	// Stop vote
	level.vote destroy();
	level.votetrue destroy();
	level.votetruecounter destroy();
	level.votefalse destroy();
	level.votefalsecounter destroy();
	level.voting = false;

	for (i = 0; i < level.players.size; i++)
	{
		level.players[i].allowVote = true;
	}
}

/*debug(enemy)
{
	self endon("disconnect");

	while (self.debug)
	{
		wait 0.05;

		players = [];

		if (self.team == "allies" || self.team == "axis")
		{
			if (enemy == 1)
			{
				if (self.team == "allies")
				{
					players = level.alivePlayers["axis"];
				}
				else if (self.team == "axis")
				{
					players = level.alivePlayers["allies"];
				}
			}
			else if (enemy == -1)
			{
				players = level.alivePlayers[self.team];
			}
		}
		else
		{
			players = level.players;
		}

		for (i = 0; i < players.size; i++)
		{
			if (isDefined(players[i]) && players[i].sessionstate == "playing" && players[i] != self)
			{
				self thread point(players[i]);
			}
		}
	}
}

point(player)
{
	fx = spawn("script_model", player.origin);
	fx setmodel("tag_origin");
	player = undefined;
	wait 0.05;
	playFXOnTag(level.debugFX, fx, "tag_origin");
	fx hide();
	fx showToPlayer(self);
	wait 0.1;
	fx delete();
}*/

playerModel()
{
	self detachAll();

	switch (self.modelID)
	{
		case 0:
			[[game["axis_model"]["SNIPER"]]]();
		break;
		case 1:
			[[game["axis_model"]["ASSAULT"]]]();
		break;
		case 2:
			[[game["axis_model"]["SPECOPS"]]]();
		break;
		case 3:
			[[game["axis_model"]["RECON"]]]();
		break;
		case 4:
			[[game["axis_model"]["SUPPORT"]]]();
		break;
		case 5:
			[[game["axis_model"]["SNIPER"]]](); // Dog for hiders
		break;
		/*case 6:
			[[game["axis_model"]["GIRL"]]]();
		break;*/
	}
}

/*freshStat()
{
	self.freshstat setText(level.s["freshstat" + self.lang]);
	self.freshstat setPulseFX(40, 3500, 200);
}*/
