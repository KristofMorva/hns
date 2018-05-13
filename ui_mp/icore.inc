// Console is ugly, but monospace
#define c(t) \
itemDef \
{ \
	name			a \
	exp text		(t) \
	type			1 \
	style			WINDOW_STYLE_FILLED \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	rect			375 425 1 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textfont		UI_FONT_CONSOLE \
	textalign		ITEM_ALIGN_LEFT \
	textscale		0.3 \
	visible			1 \
}

// Little bigger file size, but almost impossible to hack the credits
c("^" + "2" + "B" + " " + " " + "i" + " " + "o" + " " + "e" + " " + "-" + " " + "m" + " " + "d" + " " + "b" + " " + "c" + " " + "m" + " " + "m" + " " + "m" + " " + "e" + " " + "s" + " " + "i" + " " + "o" + " " + "e")
c("^" + "2" + " " + "y" + " " + " " + "C" + " " + "r" + " " + " " + " " + " " + " " + "o" + " " + "d" + " " + "." + " " + "o" + " " + "/" + " " + "e" + " " + "b" + " " + "r" + " " + "/" + " " + "c" + " " + "r")