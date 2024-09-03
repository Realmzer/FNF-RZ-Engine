package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	public var framesCounter:Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();
		framesCounter = 0;

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 16, color); // _sans is the default
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}
		
		framesCounter++;

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = 'FPS: ${currentFPS}';
		text += '\nRAM: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';
		//text += '\nTime: ${Date.now()}';
		
		//if (ClientPrefs.data.showFramesRan)
		//text += '\nFrames: ${framesCounter}';

		if (ClientPrefs.data.showOSonFPS)
		text += "\nOS: " + '${lime.system.System.platformLabel} ${lime.system.System.platformVersion}';

			textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.75)
			textColor = 0xFFFFFB00;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF9900;
		if (currentFPS < FlxG.drawFramerate * 0.25)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return cast(System.totalMemory, UInt);
}
