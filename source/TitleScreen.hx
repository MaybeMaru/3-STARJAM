package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;
//haxelib run lime test html5 --port=3001
class TitleScreen extends FlxState
{
    var options:Array<String> = ['play', 'credits'];
    var optionsText:Array<FlxText> = [];

    var curOption:Int = 1;
    var clicked:Bool = false;

    override public function create()
	{
		super.create();
        //FlxG.sound.playMusic(Paths.music('Beanie'), 1, true);
        #if desktop
        options.push('exit');
        #end
		var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.sprite('titleScreen'), true, 415, 320);
		bg.animation.add('idle', [0, 1, 2], 5);
		bg.animation.play('idle');
		bg.screenCenter();
        bg.scale.set(1.55,1.55);
		add(bg);

        var optionLine:FlxSprite = new FlxSprite(0,0).makeGraphic(200, 800, FlxColor.BLACK);
        optionLine.alpha = 0.6;
        add(optionLine);

        var num:Int = 0;
        for (option in options)
        {
            num ++;
            var fuck:FlxText = new FlxText(25, num*100, 0, option.toUpperCase(), 32);
            fuck.setFormat(null, 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            fuck.borderSize = 5;
            fuck.ID = num;
            add(fuck);
            optionsText.push(fuck);
        }

        changeOption();
    }

    override public function update(elapsed:Float)
    {
        var up:Bool = FlxG.keys.anyJustPressed(['UP', 'W']);
        var down:Bool = FlxG.keys.anyJustPressed(['DOWN', 'S']);
        var click:Bool = FlxG.keys.anyJustPressed(['ENTER', 'SPACE']);

        if(up)
            changeOption(-1);
        if (down)
            changeOption(1);
        if(click)
            selectOption(curOption);
            
        super.update(elapsed);
    }

    function selectOption(id:Int = 1)
    {
        Quick.sound('menuSelect');
        var piss:String = options[id-1];
        switch(piss.toLowerCase().trim())
        {
            case 'play':
                FlxG.switchState(new PlayState());

            case 'credits':
                trace('fuck');
            
            case 'exit':
                #if desktop
                flash.system.System.exit(0);
                #end
        }
    }

    function changeOption(change:Int = 0)
    {
        if (change != 0)
            Quick.sound('menuClick');

        curOption += change;

        if (curOption > options.length)
            curOption = 1;

        if (curOption < 1)
            curOption = options.length;

        for (option in optionsText)
        {
            if (option.ID == curOption)
                option.color = FlxColor.BROWN;
            else
                option.color = FlxColor.ORANGE;
        }
    }
}