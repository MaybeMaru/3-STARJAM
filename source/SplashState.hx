package;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class SplashState extends FlxState
{
    var coffeeTrans:CoffeeTransition;
    var funfactArray:Array<String> = [];
    var factIndex:Int = 0;
    var offsetShit:Int = 100;

    override function create()
    {
        super.create();
        coffeeTrans = new CoffeeTransition();

        funfactArray = Quick.getText('funfacts');
        factIndex = FlxG.random.int(0, funfactArray.length-1);

        var funFact:FlxText = new FlxText(0,0,480, 'FUN FACT:\n'+funfactArray[factIndex], 32);
        funFact.alignment = CENTER;
        funFact.screenCenter();

        var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.sprite('logo'));
        logo.screenCenter();

        //LOGO
        new FlxTimer().start(0.5, function(tmr:FlxTimer)
        {
            Quick.sound('logoClick');
            add(logo);
            logo.y -= offsetShit;
        });

        //FUN FACT
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            Quick.sound('factClick');
            add(funFact);
            funFact.y += offsetShit;
        });

        //TRANSTITION
        new FlxTimer().start(4, function(tmr:FlxTimer)
        {
            add(coffeeTrans);
            coffeeTrans.startTrans();
        });

        //NEXT STATE
        new FlxTimer().start(4+(coffeeTrans.transTime*2), function(tmr:FlxTimer)
        {
            FlxG.switchState(new TitleScreen());
        });
    }
}