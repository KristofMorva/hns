#include "ui/menudef.h"
#include "ui_mp/common_macro.inc"

#define CHOICE_X_START			175
#define CHOICE_Y_START			60

#define CURPAGE 0

#define STYLE_PC	1
#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			180

#define BTN(id, caption, model) \
CHOICE_BUTTON_FOCUS_VIS(id, "@MENUS_" + caption + dvarString("lang"), close self; scriptMenuResponse model, setLocalVarString img model, setLocalVarString img "", when(localVarBool(nextpage) == CURPAGE))

/*#define PIC(img) \
itemDef \
{ \
	name			img \
	style			WINDOW_STYLE_SHADER \
	rect			15 CHOICE_Y_START 92 92 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		img \
	visible			0 \
	decoration \
}*/

rect			0 0 640 480
focusColor		COLOR_FOCUSED
style			WINDOW_STYLE_EMPTY
blurWorld		7.0
onOpen
{
	setLocalVarBool nextpage 0;
	setLocalVarString img "";
}
onClose
{
	setLocalVarBool nextpage 0;
	setLocalVarString img "";
}
onEsc
{
	scriptMenuResponse "back";
}

// background overlay
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	backcolor		0 0 0 0.75 //0 0.05 0.15 0.5
	visible			1
	decoration
}

// gradient_top
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
	background		"gradient_top"
	visible			1
	decoration
}

// gradient_bottom
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 405 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
	background		"gradient_bottom"
	visible			1
	decoration
}

CHOICE_MENU_TITLE("@MENUS_CHOOSE_MODEL" + dvarString("lang"))	

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			15 CHOICE_Y_START 92 92 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp				material(localVarString(img))
	visible			when(localVarString(img) != "")
	decoration
}

#define BACK_OPEN;
#include "ui_mp/navcontrols.inc"