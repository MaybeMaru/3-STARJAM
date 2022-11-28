package;

import flixel.FlxSprite;
import flixel.FlxG;

class ThrowHand extends FlxSprite
{
    private var didSound:Bool = false;

    public function new()
    {
        super(-300,300);
        loadGraphic(Paths.sprite('minigame3/cupHand'));
        scale.set(4,4);
        updateHitbox();


        acceleration.y = 700;
		velocity.y -= FlxG.random.int(300, 400);
		velocity.x += FlxG.random.int(400, 600);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (x >= 50 && !didSound)
        {
            Quick.sound('minigame3/slurp');
            didSound = true;
        }
        if (y >= 600 && didSound)
        {
            kill();
            destroy();
        }
    }
}