#define PLAYERSTATS_WIDTH 		270

//#ifdef PC
	#define PLAYERSTATS_X			250 // ((-(PLAYERSTATS_WIDTH - RIGHTITEM_OFFSET))-80)
	#define PLAYERSTATS_Y			120
	#define FRAME_BG_COLOR			0.175 0.175 0.2 0.55
//#else
//	#define PLAYERSTATS_X			(-(PLAYERSTATS_WIDTH - RIGHTITEM_OFFSET))
//	#define PLAYERSTATS_Y			120
//	#define FRAME_BG_COLOR			1 1 1 0
//#endif	

#define ORIGIN_PLAYERSTATS 		PLAYERSTATS_X PLAYERSTATS_Y
	
#define LABEL_ITEM_SPACING		18
#define SUB_LABEL_INDENT		16
	
#define LABEL_START_X			12
#define LABEL_START_Y			LABEL_ITEM_SPACING
#define ORIGIN_LABEL			LABEL_START_X LABEL_START_Y

#define LABEL_TEXTCOLOR			1 1 1 0.75
#define LABEL_TITLECOLOR		1 0.85 0.5 0.8

#define ORIGIN_LABEL_ITEM( itemNumber ) \
		LABEL_START_X (LABEL_START_Y+(LABEL_ITEM_SPACING*(itemNumber-1))) 

#define ORIGIN_SUB_LABEL_ITEM( itemNumber ) \
		(LABEL_START_X+SUB_LABEL_INDENT) (LABEL_START_Y+(LABEL_ITEM_SPACING*(itemNumber-1))) 
		
#define ORIGIN_DIVIDER( itemNumber ) \
		0 (LABEL_START_Y+(LABEL_ITEM_SPACING/2)+(LABEL_ITEM_SPACING*(itemNumber-1))) 

#define PREPROC_LABEL( ptext, itemNumber ) \
itemDef { \
	text			ptext \
	rect			ORIGIN_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING 0 VERTICAL_ALIGN_TOP \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \ 
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	textscale		TEXTSIZE_SMALL \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	forecolor		LABEL_TITLECOLOR \
	visible			1 \
	decoration }
	
#define PREPROC_DIVIDER( itemNumber ) \
	PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_DIVIDER( itemNumber ) (PLAYERSTATS_WIDTH) 1 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "white", 1 1 1 0.1, 0, 0, 0 0 0 0 )

#define PREPROC_SUB_LABEL( ptext, itemNumber ) \
	PREPROC_SUB_LABEL_VIS( ptext, itemNumber, 1 )
	
#define PREPROC_SUB_LABEL_VIS( ptext, itemNumber, visArg ) \
itemDef { \
	text			ptext \
	rect			ORIGIN_SUB_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING 0 VERTICAL_ALIGN_TOP \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \ 
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	textscale		TEXTSIZE_SMALL \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	forecolor		LABEL_TEXTCOLOR \
	visible			visArg \
	decoration }
	
#define PREPROC_VALUE_TEXT( ptext, itemNumber, px_offset, pcolor ) \
		PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, 1, ITEM_ALIGN_MIDDLE_RIGHT )

#define PREPROC_VALUE_TEXT_LEFT_ALIGNED( ptext, itemNumber, px_offset, pcolor ) \
		PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, 1, ITEM_ALIGN_MIDDLE_LEFT )
		
#define PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, visArg, alignment ) \
itemDef { \
	exp				text( ptext ); \
	type			ITEM_TYPE_TEXT \
	rect			ORIGIN_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING 0 VERTICAL_ALIGN_TOP \
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \ 
	textalignx		px_offset \
	textscale		TEXTSIZE_SMALL \
	forecolor		pcolor \
	textalign		alignment \
	visible			visArg \
	decoration }
	
#define PREPROC_RANK_ICON( itemNumber, pshader, y_offset ) \
		PREPROC_RANK_ICON_VIS( itemNumber, pshader, y_offset, 1 )

#define PREPROC_RANK_ICON_VIS( itemNumber, pshader, y_offset, visArg ) \
	PREPROC_SHADER_DRAW_ALIGNED_VIS( (LABEL_START_X+PLAYERSTATS_WIDTH-85) (LABEL_START_Y+y_offset+(LABEL_ITEM_SPACING*(itemNumber-1))) 22 22 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, pshader, 1 1 1 1, 0, 0, 0 0 0 0, visArg )

// HNS modified to be easier
#define FRAME_HEIGHT	320
/*#ifdef PC
	#define FRAME_HEIGHT	358
#else
	#define FRAME_HEIGHT	342
#endif*/

	// UI art
	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (PLAYERSTATS_WIDTH+8) (FRAME_HEIGHT - 32) 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "white", FRAME_BG_COLOR, 0, 0, 0 0 0 0 )
	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (PLAYERSTATS_WIDTH+8) (FRAME_HEIGHT - 32) 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "gradient_center", 0.3 0.3 0.325 0.8, 0, 0, 0 0 0 0 )

	PREPROC_SHADER_DRAW_ALIGNED( -24 -4 -20 FRAME_HEIGHT 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )

	PREPROC_SHADER_DRAW_ALIGNED( (PLAYERSTATS_WIDTH+4) -4 20 FRAME_HEIGHT 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
	
	PREPROC_SHADER_DRAW_ALIGNED( -4 -4 (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "white", 0.2 0.2 0.225 1, 0, 0, 0 0 0 0 )
	PREPROC_SHADER_DRAW_ALIGNED( -4 -4 (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 )
	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "gradient_top", 1 1 1 0.2, 0, 0, 0 0 0 0 )

	PREPROC_SHADER_DRAW_ALIGNED( -4 (FRAME_HEIGHT - 20) (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "white", 0.2 0.2 0.225 1, 0, 0, 0 0 0 0 )
	PREPROC_SHADER_DRAW_ALIGNED( -4 (FRAME_HEIGHT - 20) (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 )
	PREPROC_SHADER_DRAW_ALIGNED( -4 (FRAME_HEIGHT - 36) (PLAYERSTATS_WIDTH+8) 16 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "gradient_bottom", 1 1 1 0.2, 0, 0, 0 0 0 0 )

#ifndef PC
	// player name with clan tag
	itemDef 
	{
		rect			0 12 270 28 0 VERTICAL_ALIGN_TOP
		origin			ORIGIN_PLAYERSTATS
		textfont		UI_FONT_NORMAL
		textstyle 		ITEM_TEXTSTYLE_SHADOWED
		textscale		TEXTSIZE_SMALL
		textalign		ITEM_ALIGN_MIDDLE_LEFT
		forecolor		LABEL_TITLECOLOR
		ownerdraw		UI_USERNAME
		visible			1
		decoration 
	}
#else
	itemDef 
	{
		rect			0 -7 270 20 0 VERTICAL_ALIGN_TOP
		origin			ORIGIN_PLAYERSTATS
		textfont		UI_FONT_NORMAL
		textstyle 		ITEM_TEXTSTYLE_SHADOWED
		textscale		TEXTSIZE_SMALL
		textalign		ITEM_ALIGN_MIDDLE_CENTER
		exp				text( dvarString( "name" ) );
		visible			1
		decoration 
	}
#endif

	//PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 12 270 28 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "["+dvarString( clanName) +"]"+ dvarString( name ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_CENTER, 1 1 1 0.8 visible when( dvarString( clanName ) != "" ) )
	//PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 12 270 28 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, dvarString( name ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_CENTER, 1 1 1 0.8 visible when( dvarString( clanName ) == "" ) )
	
	PREPROC_LABEL( "@MPUI_RANK_PRE", 1 )				
	PREPROC_VALUE_TEXT_LEFT_ALIGNED( "@"+tablelookup("mp/ranktable.csv",0,stat(252),5), 2, SUB_LABEL_INDENT, LABEL_TITLECOLOR )
	PREPROC_VALUE_TEXT( locString( "@MPUI_LEVEL_N", int(tablelookup("mp/ranktable.csv",0,stat(252),14)) ), 1, -24, LABEL_TITLECOLOR )
	PREPROC_RANK_ICON( 1, tablelookup( "mp/rankIconTable.csv", 0, stat(252), stat(2326)+1 ), -4 )
	
	PREPROC_SUB_LABEL( "@MPUI_XP_PRE", 3 )

	PREPROC_VALUE_TEXT( dvarString("realrankxp"), 3, -24, LABEL_TEXTCOLOR )
	
	PREPROC_DIVIDER( 4 )
	PREPROC_LABEL( "@MPUI_NEXT_RANK_PRE", 5 )
	/* rank name */
	PREPROC_VALUE_TEXT_VIS( "@"+tablelookup("mp/ranktable.csv",0,stat(252)+1,5), 6, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ), ITEM_ALIGN_MIDDLE_LEFT )
	PREPROC_VALUE_TEXT_VIS( "@MPUI_PRESTIGE", 6, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT ), ITEM_ALIGN_MIDDLE_LEFT )
	PREPROC_VALUE_TEXT_VIS( "@MPUI_NONE", 6, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP==0 ), ITEM_ALIGN_MIDDLE_LEFT )
	
	/* display level */
	PREPROC_VALUE_TEXT_VIS( locString( "@MPUI_LEVEL_N", int(tablelookup("mp/ranktable.csv",0,stat(252)+1,14)) ), 5, -24, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ), ITEM_ALIGN_MIDDLE_RIGHT )
	PREPROC_VALUE_TEXT_VIS( locString( "@MPUI_LEVEL_N", 1 ), 5, -24, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT ), ITEM_ALIGN_MIDDLE_RIGHT )
	
	/* next rank icon */
	PREPROC_RANK_ICON_VIS( 5, tablelookup( "mp/rankIconTable.csv", 0, stat(252)+1, stat(2326)+1 ), -4, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ) )
	PREPROC_RANK_ICON_VIS( 5, tablelookup( "mp/rankIconTable.csv", 0, 0, stat(2326)+2 ), -4, when( CAN_RANK_UP && PRESTIGE_NEXT ) )

	PREPROC_SUB_LABEL_VIS( "@MPUI_XP_REQUIRED_PRE", 7, when( CAN_RANK_UP ) )
	/* standard xp */
	PREPROC_VALUE_TEXT_VIS( int(tableLookup( "mp/rankTable.csv", 0, stat(252), 7) - dvarInt("rankxp")), 7, -86, LABEL_TEXTCOLOR, when( CAN_RANK_UP ), ITEM_ALIGN_MIDDLE_RIGHT )

	PREPROC_SHADER_DRAW_ALIGNED_VIS( 200 127 60 14 0 VERTICAL_ALIGN_TOP, ORIGIN_PLAYERSTATS, "white", 0.1 0.1 0.1 0.35, 1, 1, 1 1 1 0.2,  when( CAN_RANK_UP ) )
	PREPROC_SHADER_DRAW_ADV_VIS( (PLAYERSTATS_X+202), (PLAYERSTATS_Y+93+36), 58*((dvarInt("rankxp") - int(tableLookup( "mp/rankTable.csv", 0, stat(252), 2 ))) / int(tableLookup( "mp/rankTable.csv", 0, stat(252), 3 ))), 12, "gradient_fadein", 1 0.9 0.5 0.6, 0, 1, 1 1 1 1 rect 0 0 0 0  0 VERTICAL_ALIGN_TOP, when( CAN_RANK_UP ) )
	
	PREPROC_DIVIDER( 8 )

	// Kills
	PREPROC_LABEL( "@MENUS_KILLS", 9)
	PREPROC_VALUE_TEXT( stat(3154) + stat(3155), 9, -24, LABEL_TITLECOLOR )

	// As hider
	PREPROC_SUB_LABEL( "@MENUS_STREAK", 10 )	
	PREPROC_VALUE_TEXT( stat(3153), 10, -24, LABEL_TEXTCOLOR )

	// As seeker
	PREPROC_SUB_LABEL( "@MENUS_AS_SEEKER", 11 )	
	PREPROC_VALUE_TEXT( stat(3154), 11, -24, LABEL_TEXTCOLOR )

	// As hider
	PREPROC_SUB_LABEL( "@MENUS_AS_HIDER", 12 )	
	PREPROC_VALUE_TEXT( stat(3155), 12, -24, LABEL_TEXTCOLOR )

	// Deaths
	PREPROC_LABEL( "@MENUS_DEATHS", 13)
	PREPROC_VALUE_TEXT( stat(3156), 13, -24, LABEL_TITLECOLOR )

	PREPROC_DIVIDER( 14 )

	PREPROC_LABEL( "@MENUS_TIME", 15 )	
	PREPROC_VALUE_TEXT( secondsAsTime( stat( 2311 ) + stat( 2312 ) ), 15, -24, LABEL_TITLECOLOR )
	//  + stat( 2313 )