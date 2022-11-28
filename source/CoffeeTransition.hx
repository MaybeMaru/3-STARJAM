package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class CoffeeTransition extends FlxSpriteGroup
{
    public var transTime:Float = 0.75;
    var fallCoffee:FlxSprite;
    var fillCoffee:FlxSprite;

    public function new()
    {
        super(0,0);

        fallCoffee = new FlxSprite().loadGraphic(Paths.sprite('coffeeFall'));
        fallCoffee.scale.set(4,4);
        fallCoffee.updateHitbox();
        add(fallCoffee);
        fallCoffee.screenCenter(X);
        fallCoffee.y = -580;

        fillCoffee = new FlxSprite().loadGraphic(Paths.sprite('coffeeLake'));
        fillCoffee.scale.set(4,4);
        fillCoffee.updateHitbox();
        add(fillCoffee);
        fillCoffee.y = 520;
    }

    public function startTrans()
    {
        if (FlxG.sound.music != null)
            FlxG.sound.music.fadeOut(transTime, 0);

        fallCoffee.y = -580;
        fillCoffee.y = 520;
        FlxTween.tween(fallCoffee, {y: 520}, transTime*2);
        FlxTween.tween(fillCoffee, {y: -80}, transTime, {ease: FlxEase.quadInOut, startDelay: transTime/2});
    }

    public function endTrans()
    {
        if (FlxG.sound.music != null)
            FlxG.sound.music.fadeIn(transTime, 0, 1);
        fallCoffee.y = -580;
        fillCoffee.y = -80;
        FlxTween.tween(fillCoffee, {y: 520}, transTime, {ease: FlxEase.quadInOut});
    }
}