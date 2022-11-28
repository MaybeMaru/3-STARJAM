package;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.FlxG;

//Unholywanderer was here
class ConveyorBean extends FlxSprite
{
    public var beanHealth:Int = 2;
    public var isDone:Bool = false;

    public function new()
    {
        super(-40, 400);
        loadGraphic(Paths.sprite('minigame2/beanDust'), true, 22, 15);
        scale.set(3.5,3.5);
        animation.add('bean', [0], 1);
        animation.add('dust', [1], 1);
        animation.play('bean', true);
        //Dont make it so boring
        y+= FlxG.random.int(-10,5);
        x+= FlxG.random.int(-5,5);
    }

    public function startMovement(speed:Float)
    {
        velocity.x = speed;
    }

    public function hitCheck()
    {
        if (x >= 270 && x <= 360)
        {
            beanHealth--;
            if (beanHealth<1 && !isDone)
            {
                isDone = true;
                animation.play('dust', true);
                Mission.coffeeCount++;
            }
            else
            {
                scale.set(5,2.5);
            }
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        scale.x = FlxMath.lerp(scale.x, 3.5, elapsed*4);
        scale.y = FlxMath.lerp(scale.y, 3.5, elapsed*4);
    }
}