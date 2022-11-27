package;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;

class CoffeeState extends FlxState
{
    var coolTransition:CoffeeTransition;

    override function create()
    {
        coolTransition = new CoffeeTransition();
        super.create();
        add(coolTransition);
        coolTransition.endTrans();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function switchState(newState:CoffeeState)
    {
        coolTransition.startTrans();

        new FlxTimer().start(coolTransition.transTime*2, function(tmr:FlxTimer)
        {
            FlxG.switchState(newState);
        });
    }
}