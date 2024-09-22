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

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import backend.Paths;
import backend.Controls;
import backend.CoolUtil;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.CustomFadeTransition;
import backend.ClientPrefs;
import backend.Conductor;
import backend.BaseStage;
import backend.Difficulty;
import backend.Mods;
import backend.Language;

import backend.utils.BitmapUtil;
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

import backend.system.CommandLineHandler;
import backend.system.net.Socket;
import backend.system.macros.Utils;
import backend.system.macros.GitCommitMacro;
import backend.system.macros.HashLinkFixer;

import backend.ui.*; //Psych-UI

import objects.Alphabet;
import objects.BGSprite;

import states.PlayState;
import states.LoadingState;

#if flxanimate
import flxanimate.*;
import flxanimate.PsychFlxAnimate as FlxAnimate;
#end

// Mobile Controls
import mobile.objects.MobileControls;
import mobile.objects.IMobileControls;
import mobile.objects.Hitbox;
import mobile.objects.TouchPad;
import mobile.objects.TouchButton;
import mobile.input.MobileInputID;
import mobile.backend.MobileData;
import mobile.input.MobileInputManager;

// Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
import android.os.BatteryManager as AndroidBatteryManager;
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
import shaders.flixel.system.FlxShader;

using StringTools;
#end
