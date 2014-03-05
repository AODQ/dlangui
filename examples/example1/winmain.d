module winmain;
pragma(lib, "dlangui.lib");

import dlangui.platforms.common.platform;
import dlangui.widgets.widget;
import dlangui.core.logger;
import dlangui.graphics.fonts;
import std.stdio;

version(Windows) {
    import win32.windows;
    import dlangui.platforms.windows.winapp;
    /// workaround for link issue when WinMain is located in library
    extern (Windows)
    int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                LPSTR lpCmdLine, int nCmdShow)
    {
        return DLANGUIWinMain(hInstance, hPrevInstance,
                       lpCmdLine, nCmdShow);
    }
}

class TestWidget : Widget {
	public override void onDraw(DrawBuf buf) {
		super.onDraw(buf);
		FontRef font1;
		FontRef font2;
		Log.d("Testing opAssign");
		font1 = font2;
		Log.d("Testing copy constructor");
		FontRef font3 = font2;
		Log.d("On draw: getting font");
		FontRef font = FontManager.instance.getFont(32, 400, false, FontFamily.SansSerif, "Arial");
		Log.d("Got font, drawing text");
		font.drawText(buf, _pos.left + 5, _pos.top + 5, "Text"d, 0x0000FF);
		Log.d("Text is drawn successfully");
	}
}

extern (C) int UIAppMain() {
	Log.d("Some debug message");
	Log.e("Sample error #", 22);

    Window window = Platform.instance().createWindow("My Window", null);
    Widget myWidget = new TestWidget();
    window.mainWidget = myWidget;
    window.show();
    window.windowCaption = "New Window Caption";



	Log.d("Before getFont");
	FontRef font = FontManager.instance.getFont(32, 400, false, FontFamily.SansSerif, "Arial");
	Log.d("After getFont");
	assert(!font.isNull);
	int[] widths;
	dchar[] text = cast(dchar[])"Test string"d;
	Log.d("Calling measureText");
	int charsMeasured = font.measureText(text, widths, 1000);
	assert(charsMeasured > 0);
	int w = widths[charsMeasured - 1];
	Log.d("Measured string: ", charsMeasured, " chars, width=", w);
	Glyph * g = font.getCharGlyph('A');
	Log.d("Char A glyph: ", g.blackBoxX, "x", g.blackBoxY);
    return Platform.instance().enterMessageLoop();
}