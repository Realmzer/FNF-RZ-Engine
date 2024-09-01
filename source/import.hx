#if !macro
//Discord API
#if DISCORD_ALLOWED
import backend.api.Discord;
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

//3D shit
//import away3d.core.managers.Stage3DProxy;
//import flx3D.Flx3DUtil;
//import flx3D.FlxView3D;
//import openfl.display3D.utils.UInt8Buff;
//import openfl.display3D.Context3D;

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
//import backend.Language;

// Backend Utils
import backend.utils.BitmapUtil;
import backend.utils.CoolUtil;
import backend.utils.CppAPI;
import backend.utils.CryptoUtils;
import backend.utils.EtternaFunctions;
import backend.utils.FileAttributeWrapper;
import backend.utils.FlxInterpolateColor;
import backend.utils.HiddenProcess;
import backend.utils.HttpUtil;
import backend.utils.IniUtil;
import backend.utils.Linux;
import backend.utils.Mac;
import backend.utils.MarkdownUtil;
import backend.utils.MemoryUtil;
import backend.utils.NativeAPI;
import backend.utils.NdllUtil;
import backend.utils.ShaderResizeFix;
import backend.utils.SortedArrayUtil;
import backend.utils.SysZip;
import backend.utils.Transparency;
import backend.utils.Wallpaper;
import backend.utils.Windows;
import backend.utils.WindowsData;
import backend.utils.WindowsSystem;
import backend.utils.WindowUtils;
import backend.utils.ZipUtil;

// System
import backend.system.CommandLineHandler;
import backend.system.net.Socket;
import backend.system.macros.Utils;
import backend.system.macros.GitCommitMacro;
import backend.system.macros.HashLinkFixer;

import objects.Alphabet;
import objects.BGSprite;

import states.PlayState;
import states.LoadingState;

import backend.math.Vector3;
import backend.math.VectorHelpers;

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
