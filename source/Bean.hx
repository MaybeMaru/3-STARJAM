package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

class Bean extends FlxSprite
{
    public static var count:Int = 0;
    public var targetPos:FlxPoint = null;
    public var moveSpeed:Float = 0.1;

    public function new(x:Float, y:Float)
    {
        super(x,y);
        loadGraphic(Paths.sprite('bean'), true, 16, 16);
        scale.set(3,3);
        updateHitbox();
        animation.add('idle', [0,1,2,3,4], 12);
        animation.play('idle');
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(targetPos != null)
        {
            x = FlxMath.lerp(x, targetPos.x, moveSpeed);
            y = FlxMath.lerp(y, targetPos.y, moveSpeed);

            var finished:Bool = FlxMath.roundDecimal(x, 0) == FlxMath.roundDecimal(targetPos.x, 0);

            if(finished)
            {
                count++;
                Mission.beanCount++;
                Quick.sound('minigame1/pickup_'+FlxG.random.int(1,3), 0.5);
                visible = false;
                kill();
                destroy();
            }
        }
    }
}