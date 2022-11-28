package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
using StringTools;

class Enemy extends FlxSprite
{
    public var dieCallback:Void->Void;
    public var enemyHealth:Int = 3;
    public var canBeHit:Bool = true;

    public function new(x:Float = 0, y:Float = 0, type:String = "default", ?dieCallback:Void->Void)
    {
        super(x,y);
        this.dieCallback = dieCallback;
        enemyHealth = 3;
        scrollFactor.set();

        switch(type.toLowerCase().trim())
        {
            case 'air':
                this.y -= 150;
                loadGraphic(Paths.sprite('beanEnemyAIR'), true, 122,87);
                animation.add('fly', [0, 1, 2], 12);
                animation.play('fly');

            default:
                loadGraphic(Paths.sprite('beanEnemy'), true, 90, 72);
                animation.add('run', [0, 1, 2, 3], 12);
                animation.play('run');
        }

        this.y -= height;
        //makeGraphic(50, 50, FlxColor.RED);
    }

    public function getHit()
    {
        if (canBeHit)
        {
            enemyHealth--;
            Quick.sound('minigame1/enemy_hurt', 0.5);
            if(enemyHealth > 0)
            {
                color = FlxColor.RED;
                new FlxTimer().start(0.3, function(tmr:FlxTimer)
                {
                    color = FlxColor.WHITE;
                });
            }
            else
            {
                dieCallback();

                visible = false;
				kill();
				destroy();
            }

        }
    }

    public function startCycle(flipped:Bool = false, diffLevel:Null<Float> = null)
    {
        if (diffLevel == null)
            velocity.x = FlxG.random.int(75, 200);
        else
            velocity.x = FlxG.random.float(diffLevel*2, diffLevel*4);
        if (flipped)
        {
            flipX = true;
            velocity.x *= -1;
        }
    }
}