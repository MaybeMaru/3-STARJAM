package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class CreditsState extends CoffeeState
{
    var creditsArray:Array<String> = [];
    var creditLines:Array<FlxText> = [];
    var ngLogo:FlxSprite;

    var skipped:Bool = false;

    override public function create()
	{
        FlxG.sound.playMusic(Paths.music('Credits'), 1, false);
        creditsArray = Quick.getText('credits');

        ngLogo = new FlxSprite(0,0).loadGraphic(Paths.sprite('ngLogo'));
        ngLogo.scale.set(3,3);
        ngLogo.screenCenter();
        ngLogo.alpha = 0.4;
        add(ngLogo);

        var curLine:Int = 0;
        for (line in creditsArray)
        {
            curLine++;
            var creditLine:FlxText = new FlxText(25, 50*curLine, 0, line, 32);
            creditLine.y += 480;
            creditLines.push(creditLine);
            add(creditLine);
        }

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.anyJustPressed(['SPACE', 'ENTER']) && !skipped)
        {
            skipped = true;
            switchState(new TitleScreen());
        }

        for(line in creditLines)
        {
            line.y -= elapsed*20;
            if (line.y < -80)
            {
                line.visible = false;
                creditLines.remove(line);
                line.kill();
                line.destroy();

                switch (line.text)
                {
                    case 'Made for the 1st Newgrounds':
                        FlxTween.tween(ngLogo, {alpha: 1}, 3);

                    case 'Thanks for playing!':
                        switchState(new TitleScreen());
                }
            }
        }
        
    }
}