package mobile.substates;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

class MobileExtraControl extends MusicBeatSubstate
{
    var returnArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'],        
        ['SPACE', 'BACKSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var displayArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],        
        ['SPACE', 'BACK\nSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var titleTeam:FlxTypedGroup<ChooseButton>;           
    var optionTeam:FlxTypedGroup<ChooseButton>;   
    
    var isMain:Bool = true;
    
    var titleNum:Int = 0;
    var percent:Float = 0;
    var typeNum:Int = 0;
    var chooseNum:Int = 0;
    
    var titleWidth:Int = 200;
    var titleHeight:Int = 100;
    
    var optionWidth:Int = 80;
    var optionHeight:Int = 30;
    
    override function create()
	{
	    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	    
	    var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg.scrollFactor.set();
		bg.alpha = 0.5;
		add(bg);  
		
		titleTeam = new FlxTypedGroup<ChooseButton>();
		add(titleTeam);				
		
		for (i in 1...5){    
			var data:String = Reflect.field(ClientPrefs.data, "extraKeyReturn" + i);    	
			var _x = FlxG.width / 2 + 25 + (titleWidth + 50) * ((i-1) - 4 / 2);
	        var titleObject = new ChooseButton(_x, 150, titleWidth, titleHeight, data, "Key " + Std.string(i));    		    			 			
    		titleTeam.add(titleObject);	    		
	    }
	    
	    optionTeam = new FlxTypedGroup<ChooseButton>();
		add(optionTeam);			
	    
	    for (type in 0...returnArray.length){
	        var _length:Int = returnArray[type].length;
	        for (number in 0..._length){
	            var _x = FlxG.width / 2 + optionWidth * (number - _length / 2);
	            var titleObject = new ChooseButton(_x, 300 + (optionHeight + 20) * type, optionWidth, optionHeight, displayArray[type][number]);    		    			 			
    		    optionTeam.add(titleObject);	   	                
	        }	    	    	    
	    }        
	    
	    updateTitle(titleNum + 1, true, 0);   
	    
	    addVirtualPad(OptionStateC, OptionStateC);
		addVirtualPadCamera(false);
		
		super.create();
    }   
    
    override function update(elapsed:Float)
	{
	    super.update(elapsed);
	    
	    var accept = controls.ACCEPT;
		var right = controls.UI_RIGHT_P;
		var left = controls.UI_LEFT_P;
		var up = controls.UI_UP_P;
		var down = controls.UI_DOWN_P;
		var back = controls.BACK;
		var reset = controls.RESET || (virtualPad != null && virtualPad.buttonC.justPressed);
		
		if (left || right){		   
		    if (isMain){		        		
		        titleNum += left ? -1 : 1;
    		    if (titleNum > 3)
    		        titleNum = 0;
    		    if (titleNum < 0)
    		        titleNum = 3;
    		    updateTitle(titleNum + 1, true, 1);   
    		} else {
    		    chooseNum += left ? -1 : 1;
    		    if (chooseNum > displayArray[typeNum].length - 1)
    		        chooseNum = 0;
    		    if (chooseNum < 0)
    		        chooseNum = displayArray[typeNum].length - 1;
    		    updateChoose();    		    		    
    		}
		}
		
		if (up || down){
		    if (!isMain){		
    		    percent = chooseNum / (displayArray[typeNum].length - 1);
    		    typeNum += up ? -1 : 1;
    		    if (typeNum > displayArray.length - 1)
    		        typeNum = 0;
    		    if (typeNum < 0)
    		        typeNum = displayArray.length - 1;    
    		    chooseNum = Std.int(percent * (displayArray[typeNum].length - 1));
    		    updateChoose();
    		}
		}
		
		if (accept){
		    if (isMain){
		        isMain = false;		        
		        updateChoose();
		    } else {
		        switch(titleNum + 1){
		            case 1:
		                ClientPrefs.data.extraKeyReturn1 = returnArray[typeNum][chooseNum];
		            case 2:
		                ClientPrefs.data.extraKeyReturn2 = returnArray[typeNum][chooseNum];
		            case 3:
		                ClientPrefs.data.extraKeyReturn3 = returnArray[typeNum][chooseNum];
		            case 4:
		                ClientPrefs.data.extraKeyReturn4 = returnArray[typeNum][chooseNum];
		        }
		        ClientPrefs.saveSettings();
		        updateTitle(titleNum + 1, false, 2, true);
		    }					
		}
		
		if (back){
		    if (isMain){
		        ClientPrefs.saveSettings();
                FlxTransitionableState.skipNextTransIn = true;
    			FlxTransitionableState.skipNextTransOut = true;
    			MusicBeatState.switchState(new options.OptionsState());		    
		    } else {
		        isMain = true;
		        percent = chooseNum = typeNum = 0;
		        updateChoose();		    		        
		    }					          
        }
        if (reset){
            FlxG.sound.play(Paths.sound('cancelMenu'));
            ClientPrefs.data.extraKeyReturn1 = ClientPrefs.defaultData.extraKeyReturn1;
            ClientPrefs.data.extraKeyReturn2 = ClientPrefs.defaultData.extraKeyReturn2;
            ClientPrefs.data.extraKeyReturn3 = ClientPrefs.defaultData.extraKeyReturn3;
            ClientPrefs.data.extraKeyReturn4 = ClientPrefs.defaultData.extraKeyReturn4;
            resetTitle();
        }
	}	        
	
	function updateChoose(soundsType:Int = 0){	   
	    FlxG.sound.play(Paths.sound('scrollMenu'));	 
	            	    
	    var realNum = 0;
	    
	    for (type in 0...displayArray.length){
	        if (type < typeNum) realNum += displayArray[type].length;	      
	    }
	    realNum += chooseNum;
	    
	    for (i in 0...optionTeam.length)
		{
			var option:ChooseButton = optionTeam.members[i];
			
			if (i == realNum && !isMain)
			    option.changeColor(FlxColor.WHITE);
			else
			    option.changeColor(FlxColor.BLACK);
		}	
	}
	
	function updateTitle(number:Int = 0, changeBG:Bool = false, soundsType:Int = 0, needFlicker:Bool = false){
	    switch(soundsType)
	    {
	        case 0: //nothing happened
	        case 1:
	            FlxG.sound.play(Paths.sound('scrollMenu'));
	        case 2:
	            FlxG.sound.play(Paths.sound('confirmMenu'));
	    }
	    
	    for (i in 0...titleTeam.length)
		{
			var title:ChooseButton = titleTeam.members[i];
			
			if (i == titleNum){
			    title.changeExtraText(Reflect.field(ClientPrefs.data, "extraKeyReturn" + number));
			    if (needFlicker) FlxFlicker.flicker(title, 0.6, 0.075, true, true);
			    if (changeBG) title.changeColor(FlxColor.WHITE);
			} else {
			    if (changeBG) title.changeColor(FlxColor.BLACK);
			}
		}
	}
	
	function resetTitle(){	    
	    for (i in 0...titleTeam.length)
		{
			var title:ChooseButton = titleTeam.members[i];
			var number = i + 1;
			title.changeExtraText(Reflect.field(ClientPrefs.data, "extraKeyReturn" + number));
	    }
	}
}

class ChooseButton extends FlxSpriteGroup
{    
    public var bg:FlxSprite;
    public var titleObject:FlxText;
    public var extendTitleObject:FlxText;
    
    public function new(x:Float, y:Float, width:Int, height:Int, title:String, ?extendTitle:String = null)
	{
	    super(x, y);
	    
	    bg = new FlxSprite(0, 0).makeGraphic(width, height, FlxColor.WHITE);
	    bg.color = FlxColor.BLACK;
	    bg.alpha = 0.4;
		bg.scrollFactor.set();
		add(bg);
	
	    titleObject = new FlxText(0, 0, width, title);
		titleObject.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
		titleObject.x = bg.width / 2 - titleObject.width / 2;
		titleObject.y = bg.height / 2 - titleObject.height / 2;
		add(titleObject);
		
		if (extendTitle != null){ 
    		extendTitleObject = new FlxText(0, 0, width, extendTitle);
    		extendTitleObject.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		extendTitleObject.antialiasing = ClientPrefs.data.antialiasing;
    		extendTitleObject.borderSize = 2;
    		extendTitleObject.x = bg.width / 2 - extendTitleObject.width / 2;
		    extendTitleObject.y = 30;
    		add(extendTitleObject);
    		
    		titleObject.y = extendTitleObject.y + 30;
		}
	}
	
	public function changeColor(color:FlxColor){
	    bg.color = color;
		bg.alpha = 0.4;	    
	}
	
	public function changeExtraText(text:String){
	    titleObject.text = text;
	}
}