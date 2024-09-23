package backend;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		//trace(snap);
		return (m / snap);
	}

	public static function coolLerp(base:Float, target:Float, ratio:Float):Float
		return base + cameraLerp(ratio) * (target - base);
	
	public static function cameraLerp(lerp:Float):Float
			return lerp * (FlxG.elapsed / (1 / 60));

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function formatMemory(num:UInt):String
		{
			var size:Float = num;
			var data = 0;
			var dataTexts = ["B", "KB", "MB", "GB"];
			while (size > 1024 && data < dataTexts.length - 1)
			{
				data++;
				size = size / 1024;
			}
	
			size = Math.round(size * 100) / 100;
			var formatSize:String = formatAccuracy(size);
			return '${formatSize} ${dataTexts[data]}';
		}

		public static function formatAccuracy(value:Float)
			{
				var conversion:Map<String, String> = [
					'0' => '0.00',
					'0.0' => '0.00',
					'0.00' => '0.00',
					'00' => '00.00',
					'00.0' => '00.00',
					'00.00' => '00.00', // gotta do these as well because lazy
					'000' => '000.00'
				]; // these are to ensure you're getting the right values, instead of using complex if statements depending on string length
		
				var stringVal:String = Std.string(value);
				var converVal:String = '';
				for (i in 0...stringVal.length)
				{
					if (stringVal.charAt(i) == '.')
						converVal += '.';
					else
						converVal += '0';
				}
		
				var wantedConversion:String = conversion.get(converVal);
				var convertedValue:String = '';
		
				for (i in 0...wantedConversion.length)
				{
					if (stringVal.charAt(i) == '')
						convertedValue += wantedConversion.charAt(i);
					else
						convertedValue += stringVal.charAt(i);
				}
		
				if (convertedValue.length == 0)
					return '$value';
		
				return convertedValue;
			}

			/**
	 * Equivalent of `Math.max`, except doesn't require a Int -> Float -> Int conversion.
	 * @param p1
	 * @param p2
	 * @return return p1 < p2 ? p2 : p1
	 */
	@:noUsing public static inline function maxInt(p1:Int, p2:Int)
		return p1 < p2 ? p2 : p1;

	/**
	 * Equivalent of `Math.floor`, except doesn't require a Int -> Float -> Int conversion.
	 * @param e Value to get the floor of.
	 */
	public static inline function floorInt(e:Float) {
		var r = Std.int(e);
		if (e < 0 && r != e)
			r--;
		return r;
	}

	@:noUsing public static inline function flxeaseFromString(mainEase:String, suffix:String)
		return Reflect.field(FlxEase, mainEase + (mainEase == "linear" ? "" : suffix));

	/*
	 * Returns the filename of a path, without the extension.
	 * @param path Path to get the filename from
	 * @return Filename
	 */
	 @:noUsing public static inline function getFilename(file:String) {
		var file = new haxe.io.Path(file);
		return file.file;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
		{
			var countByColor:Map<Int, Int> = [];
			for(col in 0...sprite.frameWidth)
			{
				for(row in 0...sprite.frameHeight)
				{
					var colorOfThisPixel:FlxColor = sprite.pixels.getPixel32(col, row);
					if(colorOfThisPixel.alphaFloat > 0.05)
					{
						colorOfThisPixel = FlxColor.fromRGB(colorOfThisPixel.red, colorOfThisPixel.green, colorOfThisPixel.blue, 255);
						var count:Int = countByColor.exists(colorOfThisPixel) ? countByColor[colorOfThisPixel] : 0;
						countByColor[colorOfThisPixel] = count + 1;
					}
				}
			}
	
			var maxCount = 0;
			var maxKey:Int = 0; //after the loop this will store the max color
			countByColor[FlxColor.BLACK] = 0;
			for(key => count in countByColor)
			{
				if(count >= maxCount)
				{
					maxCount = count;
					maxKey = key;
				}
			}
			countByColor = [];
			return maxKey;
		}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
			if(!absolute) folder =  Sys.getCwd() + '$folder';

			folder = folder.replace('/', '\\');
			if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

			#if linux
			var command:String = '/usr/bin/xdg-open';
			#else
			var command:String = 'explorer.exe';
			#end
			Sys.command(command, [folder]);
			trace('$command $folder');
		#else
			FlxG.error("Platform is not supported for CoolUtil.openFolder");
		#end
	}

	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = FlxG.stage.application.meta.get('company');
		// #if (flixel < "5.0.0") return company; #else
		return '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
		// #end
	}

	public static function setTextBorderFromString(text:FlxText, border:String)
	{
		switch(border.toLowerCase().trim())
		{
			case 'shadow':
				text.borderStyle = SHADOW;
			case 'outline':
				text.borderStyle = OUTLINE;
			case 'outline_fast', 'outlinefast':
				text.borderStyle = OUTLINE_FAST;
			default:
				text.borderStyle = NONE;
		}
	}

	public static function showPopUp(message:String, title:String):Void
		{
			#if android
			AndroidTools.showAlertDialog(title, message, {name: "OK", func: null}, null);
			#else
			FlxG.stage.window.alert(message, title);
			#end
		}
}
