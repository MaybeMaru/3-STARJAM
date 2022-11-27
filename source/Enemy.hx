package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Enemy extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y);
        scrollFactor.set();

        loadGraphic(Paths.sprite('beanEnemy'), true, 90, 72);
        animation.add('run', [0, 1, 2, 3], 12);
		animation.play('run');
        this.y -= height;
        //makeGraphic(50, 50, FlxColor.RED);
    }

    public function startCycle()
    {
        velocity.x = FlxG.random.int(50, 100);
        if (flipX)
            velocity.x *= -1;
    }
}