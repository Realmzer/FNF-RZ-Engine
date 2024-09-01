package states;

import flixel.addons.display.FlxBackdrop;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var checker:FlxBackdrop;
	var bg:FlxSprite;
	var textBG:FlxSprite;
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		super.create();

		var yScroll:Float = 0.25;
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		checker = new FlxBackdrop(Paths.image('microphonewhite'));
		checker.velocity.set(22, 20);
		checker.updateHitbox();
		checker.scrollFactor.set(0, 0);
		checker.alpha = 0.4;
		checker.scale.x = 0.15; 
		checker.scale.y = 0.15;
		checker.screenCenter(X);
		add(checker);

		textBG = new FlxSprite(-200).makeGraphic(780, 520, FlxColor.BLACK);
		//textBG.x = 500;
		//textBG.y = 500;
		textBG.alpha = 0.4;
		textBG.screenCenter(X);
		textBG.screenCenter(Y);
		add(textBG);

		warnText = new FlxText(20, 0, FlxG.width,
			"Hey bro, looks like you're running an   \n
			outdated version of RZ Engine (" + MainMenuState.rzEngineVersion + "),\n
			please update to " + TitleState.updateVersion + "!\n
			Press ESCAPE to proceed anyway.\n
			\n
			Thank you for using RZ Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

	//	FlxTween.tween(warnText, { x: 0, alpha: 1}, 1.5, {ease: FlxEase.circInOut});
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/Realmzer/FNF-RZ-Engine");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			//checker.x += .5*(elapsed/(1/120)); checker.y -= 0.16 / (ClientPrefs.data.framerate / 60); 

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(bg, {alpha: 0}, 1);
				FlxTween.tween(checker, {alpha: 0}, 0.6);
				FlxTween.tween(textBG, {alpha: 0}, 1);
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
