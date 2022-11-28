package;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class ResultState extends CoffeeState
{
    override public function create()
    {
        var gradient1:FlxSprite = FlxGradient.createGradientFlxSprite(640, 480, [FlxColor.fromRGB(222,170,60), FlxColor.fromRGB(222,120,111)], 40); //Yellow --> Orange
		add(gradient1);

        var finalPoints:Int = (Mission.beanCount) + (Mission.coffeeCount*5) + (Mission.cupsCount * 10);

        var ratingString:Array<String> = [
            'RESULTS',
            '',
            'COFFEE BEANS:  '   +Mission.beanCount+     ' x 1',
            'COFFEE DUST:   '   +Mission.coffeeCount+   ' x 5',
            'COFFEE CUPS:   '   +Mission.cupsCount+     ' x 10',
            '',
            'FINAL POINTS:  '   +finalPoints,
        ];

        var ratingText:FlxText = new FlxText(0,0,0, '', 32);
        ratingText.setFormat(null, 32, FlxColor.ORANGE, LEFT, OUTLINE, FlxColor.BLACK);
        ratingText.borderSize = 5;
        ratingText.x+= 50;
        ratingText.y+= 50;
        //ratingText.screenCenter();
        add(ratingText);

        var indexThing:Int = 0;
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            if (ratingString[indexThing] != "")
                Quick.sound('menuSelect');

            ratingText.text += '\n'+ratingString[indexThing];
            indexThing++;
            
            if (indexThing <= ratingString.length-1)
                tmr.reset(1);
            else
            {
                new FlxTimer().start(4, function(tmr:FlxTimer)
                {
                    switchState(new CreditsState());
                });
            }
        });

        super.create();
    }
}