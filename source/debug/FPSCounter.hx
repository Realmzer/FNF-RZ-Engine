package debug;

import debug.Memory;
import debug.MemoryShit;
import haxe.macro.Compiler;
import flixel.util.FlxStringUtil;
import openfl.Lib;
import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import states.*;
import lime.app.Application;
import lime.system.System as LimeSystem;
enum GLInfo {
	RENDERER;
	SHADING_LANGUAGE_VERSION;
}

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if cpp
#if windows
@:cppFileCode('#include <windows.h>')
#elseif (ios || mac)
@:cppFileCode('#include <mach-o/arch.h>')
#else
@:headerInclude('sys/utsname.h')
#end
#end
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
	public var curMemory:Float;
	public var peakMemory:Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public var os:String = '';

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();
		framesCounter = 0;

		if (LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null)
			os = '\nOS: ${LimeSystem.platformLabel}' #if cpp + ' ${getArch() != 'Unknown' ? getArch() : ''}' #end;
		else
			os = '\nOS: ${LimeSystem.platformLabel}' #if cpp + ' ${getArch() != 'Unknown' ? getArch() : ''}' #end + ' - ${LimeSystem.platformVersion}';

		positionFPS(x, y);

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
		
		if(ClientPrefs.data.showFramesRan)
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
		//if (!ClientPrefs.data.showPeakMem)
		text += '\nRAM: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';
		
	//	if (ClientPrefs.data.showPeakMem)
	//	{
		//	curMemory = MemoryShit.obtainMemory();
	//	if (curMemory >= peakMemory)
	//		peakMemory = curMemory;
	//	text += '\nRAM: ${CoolUtil.formatMemory(Std.int(curMemory))} (${CoolUtil.formatMemory(Std.int(peakMemory))} peak)';
	//	}
	
		if (ClientPrefs.data.showFramesRan)
		text += '\nFrames: ${framesCounter}';

		if (ClientPrefs.data.showOSonFPS)
		text += os;

		if (ClientPrefs.data.showClock)
		text += '\nTime: ${Date.now()}';

		if (ClientPrefs.data.showPsyEngineVer)
		text += '\nPsych Engine Version: ${MainMenuState.psychEngineVersion}';

		if (ClientPrefs.data.showRZEngineVer)
		text += '\nRZ Engine Version:  ${MainMenuState.rzEngineVersion} ';

		if (ClientPrefs.data.showFNFEngineVer)
		text += '\nFNF Version:  ${Application.current.meta.get('version')} ';

		if (ClientPrefs.data.usedVramCounter)
		text += '\nUsed VRAM: ${CoolUtil.formatMemory(Std.int(FlxG.stage.context3D.totalGPUMemory))}';

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

	
	public function getGLInfo(info:GLInfo):String 
		{
			@:privateAccess
			var gl:Dynamic = Lib.current.stage.context3D.gl;
	
			switch (info) {
				case RENDERER:
					return Std.string(gl.getParameter(gl.RENDERER));
				case SHADING_LANGUAGE_VERSION:
					return Std.string(gl.getParameter(gl.SHADING_LANGUAGE_VERSION));
			}
			return '';
		}

		public inline function positionFPS(X:Float, Y:Float, ?scale:Float = 1){
			scaleX = scaleY = #if android (scale > 1 ? scale : 1) #else (scale < 1 ? scale : 1) #end;
			x = FlxG.game.x + X;
			y = FlxG.game.y + Y;
		}

	#if cpp
	#if windows
	@:functionCode('
		SYSTEM_INFO osInfo;

		GetSystemInfo(&osInfo);

		switch(osInfo.wProcessorArchitecture)
		{
			case 9:
				return ::String("x86_64");
			case 5:
				return ::String("ARM");
			case 12:
				return ::String("ARM64");
			case 6:
				return ::String("IA-64");
			case 0:
				return ::String("x86");
			default:
				return ::String("Unknown");
		}
	')
	#elseif (ios || mac)
	@:functionCode('
		const NXArchInfo *archInfo = NXGetLocalArchInfo();
    	return ::String(archInfo == NULL ? "Unknown" : archInfo->name);
	')
	#else
	@:functionCode('
		struct utsname osInfo{};
		uname(&osInfo);
		return ::String(osInfo.machine);
	')
	#end
	@:noCompletion
	private function getArch():String
	{
		return "Unknown";
	}
	#end
}
