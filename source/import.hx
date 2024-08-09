#if !macro
//Discord API
#if DISCORD_ALLOWED
import backend.Discord;
#end

//Psych
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

#if ACHIEVEMENTS_ALLOWED
import backend.Achievements;
#end

//Mobile Controls
/*import mobile.objects.MobileControls;
import mobile.objects.Hitbox;
import mobile.objects.TouchPad;
import mobile.input.MobileInputID;
import mobile.backend.MobileData;
import mobile.backend.StorageUtil;
import mobile.backend.SwipeUtil;

import mobile.flixel.input.FlxMobileInputManager;
import mobile.flixel.input.FlxMobileInputID;

//Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.BatteryManager as AndroidBatteryManager;
#end
*/

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Backend Stuff
import backend.Paths;
import backend.Controls;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.CustomFadeTransition;
import backend.ClientPrefs;
import backend.Conductor;
import backend.BaseStage;
import backend.Difficulty;
import backend.Mods;

// Backend Utils
import backend.utils.CppAPI;
import backend.utils.CoolUtil;
import backend.utils.FileAttributeWrapper;
import backend.utils.HiddenProcess;
import backend.utils.IniUtil;
import backend.utils.Linux;
import backend.utils.Mac;
import backend.utils.MemoryUtil;
import backend.utils.NativeAPI;
import backend.utils.NdllUtil;
import backend.utils.Transparency;
import backend.utils.Wallpaper;
import backend.utils.Windows;
import backend.utils.WindowsData;
import backend.utils.WindowsSystem;

// System
import backend.system.CommandLineHandler;
import backend.system.macros.Utils;

import objects.Alphabet;
import objects.BGSprite;

import states.PlayState;
import states.LoadingState;

#if flxanimate
import flxanimate.*;
//import flxanimate.PsychFlxAnimate as FlxAnimate;
#end

//Flixel
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;


using StringTools;
#end
