package backend;

import flixel.FlxSubState;
import mobile.flixel.FlxVirtualPad as TouchPad;
import mobile.objects.MobileControls;

class MusicBeatSubstate extends FlxSubState
{	
	public static var instance:MusicBeatSubstate;

	public function new()
	{
		instance = this;
		controls.isInSubstate = true;
		super();
	}
	
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return Controls.instance;

	public var touchPad:TouchPad;
	public var mobileControls:MobileControls;

	public function addMobileControls(defaultDrawTarget:Bool = true):Void
		{
			mobileControls = new MobileControls();
	
			var camControls = new flixel.FlxCamera();
			camControls.bgColor.alpha = 0;
			FlxG.cameras.add(camControls, defaultDrawTarget);
	
			mobileControls.cameras = [camControls];
			mobileControls.visible = false;
			add(mobileControls);
		}

		public function removeMobileControls()
			{
				if (mobileControls != null)
					remove(mobileControls);
			}
	
		public function addTouchPad(DPad:String, Action:String)
		{
			touchPad = new TouchPad(DPad, Action);
			add(touchPad);
		}
	
		public function removeTouchPad()
		{
			if (touchPad != null)
				remove(touchPad);
		}
	
		public function addTouchPadCamera(defaultDrawTarget:Bool = true):Void
		{
			if (touchPad != null)
			{
				var camControls:FlxCamera = new FlxCamera();
				camControls.bgColor.alpha = 0;
				FlxG.cameras.add(camControls, defaultDrawTarget);
				touchPad.cameras = [camControls];
			}
		}

		override function destroy()
			{
				super.destroy();
		
				controls.isInSubstate = false;
				if (touchPad != null)
				{
					touchPad = FlxDestroyUtil.destroy(touchPad);
					touchPad = null;
				}
				if (mobileControls != null)
				{
					mobileControls = FlxDestroyUtil.destroy(mobileControls);
					mobileControls = null;
				}
			}
		

	override function update(elapsed:Float)
	{
		//everyStep();
		if(!persistentUpdate) MusicBeatState.timePassedOnState += elapsed;
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
	
	public function sectionHit():Void
	{
		//yep, you guessed it, nothing again, dumbass
	}
	
	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
