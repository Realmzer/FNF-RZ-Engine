package options;

class FPSSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('fps_visual_settings', 'FPS Visual Settings');
		rpcTitle = 'FPS Visual Settings'; //for Discord Rich Presence

		var option:Option = new Option('Frame Counter', 
			'If checked, shows the amount of frames the program has been ran. \n Only starts frame counting when is turned on.', //Description
			'showFramesRan', 
			BOOL); 
		addOption(option);
        option.onChange = onChangeFPSCounter;

        var option:Option = new Option('Add Current OS',
        'If checked, adds a OS indicator to the FPS Counter.',
        'showOSonFPS',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

        
        var option:Option = new Option('Show Clock',
        'If checked, adds a clock to the FPS Counter.',
        'showClock',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

        var option:Option = new Option('Show Psych Engine Version',
        'If checked, adds the current Psych Engine version to the FPS Counter.',
        'showPsyEngineVer',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

        var option:Option = new Option('Show RZ Engine Version',
        'If checked, adds the current RZ Engine version to the FPS Counter.',
        'showRZEngineVer',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

        var option:Option = new Option('Show FNF Version',
        'If checked, adds the current FNF version to the FPS Counter.',
        'showFNFEngineVer',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

        var option:Option = new Option('Show Used VRAM',
        'If checked, used VRAM will appear on the FPS Counter.',
        'usedVramCounter',
        BOOL);
        addOption(option);
        option.onChange = onChangeFPSCounter;

     //   var option:Option = new Option('Show Peak Memory',
       // 'If checked, will show the peak memory.',
        //'showPeakMem',
       // BOOL);
       // addOption(option);
       // option.onChange = onChangeFPSCounter;

		super();
	}

    #if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end

}