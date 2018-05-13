// Attachments are gay this way, but at least they are working!
#include "ui/menudef.h"
#include "ui_mp/common_macro.inc"

#define CHOICE_X_START			50
#define CHOICE_Y_START			60

#define STYLE_PC	1
#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			180

#undef	HIGHLIGHT_COLOR
#define HIGHLIGHT_COLOR			0.2 0.25 0.35 0.15

#define modelname	dvarString("model")

#define	allowedModel (modelname == "com_trashcan_metal" || modelname == "com_trashcan_metal_with_trash" || modelname == "com_stove" || modelname == "com_restaurantstainlessteelshelf_01" || modelname == "com_restaurantstainlessteelshelf_02" || modelname == "com_paintcan" || modelname == "com_cardboardbox01" || modelname == "com_plasticcase_beige_big" || modelname == "ch_crate48x64" || modelname == "ch_crate64x64" || modelname == "ch_crate32x48" || modelname == "bc_militarytent_wood_table" || modelname == "com_restaurantsink_2comps" || modelname == "tvs_cubicle_round_1" || modelname == "com_barrel_fire" || modelname == "ct_street_lamp_on" || modelname == "ct_statue_chineselionstonebase" || modelname == "ch_missle_rack")

#define hideall() \
hide stove; \
hide lid; \
hide trashbag; \
hide shelf; \
hide box; \
hide case; \
hide crate; \
hide woodtable; \
hide woodtable2; \
hide sink; \
hide sink2; \
hide tv; \
hide comps; \
hide base; \
hide rockets;

//#define title(string, model) \
//CHOICE_SECTION_TITLE_VIS(1, "@MENUS_"string + dvarString("lang"), when (modelname == model))

#define	a	"A" 1
#define	b	"B" 2
#define	c	"C" 3
#define	d	"D" 4
#define	e	"E" 5
#define	f	"F" 6
#define	g	"G" 7
#define	h	"H" 8

#define list(id, string, dvar, values, model, img) \
list_map(id, string, dvar, values, model, img, "")

#define list_map(id, string, dvar, values, model, img, map) \
CHOICE_DVARFLOATLIST_VIS(id, "@MENUS_"string + dvarString("lang"), "model_"dvar, { "0" 0 values }, hideall; show img; scriptMenuRespondOnDvarIntValue "model_"dvar 0 "model_"dvar":0"; scriptMenuRespondOnDvarIntValue "model_"dvar 1 "model_"dvar":1"; scriptMenuRespondOnDvarIntValue "model_"dvar 2 "model_"dvar":2"; scriptMenuRespondOnDvarIntValue "model_"dvar 3 "model_"dvar":3"; scriptMenuRespondOnDvarIntValue "model_"dvar 4 "model_"dvar":4"; scriptMenuRespondOnDvarIntValue "model_"dvar 5 "model_"dvar":5"; scriptMenuRespondOnDvarIntValue "model_"dvar 6 "model_"dvar":6"; scriptMenuRespondOnDvarIntValue "model_"dvar 7 "model_"dvar":7"; scriptMenuRespondOnDvarIntValue "model_"dvar 8 "model_"dvar":8", when (modelname == model && (map == "" || map == dvarString("mapname"))))

#define rotate(id, dvar, model, img) \
rotate_map(id, dvar, model, img, "")

#define rotate_map(id, dvar, model, img, map) \
CHOICE_DVARFLOATLIST_VIS(id, "@MENUS_ROTATE" + dvarString("lang"), "rotate_"dvar, { "0" 0 "45" 45 "90" 90 "135" 135 "180" 180 "225" 225 "270" 270 "315" 315 }, hideall; show img; scriptMenuRespondOnDvarIntValue "rotate_"dvar 0 "rotate_"dvar":0"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 45 "rotate_"dvar":45"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 90 "rotate_"dvar":90"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 135 "rotate_"dvar":135"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 180 "rotate_"dvar":180"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 225 "rotate_"dvar":225"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 270 "rotate_"dvar":270"; scriptMenuRespondOnDvarIntValue "rotate_"dvar 315 "rotate_"dvar":315", when (modelname == model && (map == "" || map == dvarString("mapname"))))