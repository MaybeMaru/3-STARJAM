package minigames;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxGradient;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

class GameTwo extends CoffeeState
{
    private var UI:Mission;

    private var punchHand:FlxSprite;
    private var conveyorBelt:FlxSprite;
    private var conveyorSpeed:Int = 6;

    private var punchPress:Bool = false;
    private var beanGroup:FlxTypedGroup<ConveyorBean>;

    private var beansLeft:Int;
    private var timePerBean:Float;

    override public function create()
	{
        FlxG.sound.playMusic(Paths.music('Minigame1'), 1, true);

        //BG Shitz
        var gradient1:FlxSprite = FlxGradient.createGradientFlxSprite(640, 480, [FlxColor.fromRGB(222,170,60), FlxColor.fromRGB(222,120,111)], 40); //Yellow --> Orange
		add(gradient1);

        //Gamin
        conveyorBelt = new FlxSprite(0,390).loadGraphic(Paths.sprite('minigame2/conveyor'), true, 203,26);
        conveyorBelt.animation.add('move', [0, 1, 2], 1);
        conveyorBelt.animation.play('move');
        conveyorBelt.scale.set(3.5,3.5);
        conveyorBelt.updateHitbox();
        conveyorBelt.screenCenter(X);
        add(conveyorBelt);

        //Make BEANS
		beanGroup = new FlxTypedGroup<ConveyorBean>();
		add(beanGroup);
        
        punchHand = new FlxSprite().loadGraphic(Paths.sprite('minigame2/hand'));
        punchHand.scale.set(3,3);
        punchHand.updateHitbox();
        punchHand.screenCenter(X);
        add(punchHand);
        //FlxTween.tween(punchHand, {y: punchHand.y + 25}, 0.3, {ease: FlxEase.quadInOut, type: PINGPONG});

		//MAKE UI
		Mission.setupMissions();
		UI = new Mission();
		add(UI);
		UI.startMission(2);
		UI.endMissionCallback = endStage;

        beansLeft = Mission.beanCount;
        timePerBean = UI.timeLeft / Mission.beanCount;

        updateDifficulty();

		super.create();
        Mission.coffeeCount = 0;
	}

    var countShit:Float = 0;
    var countBalls:Float = 0;
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        punchPress = FlxG.keys.anyJustPressed(['X', 'SPACE']);
        if (punchPress)
        {
            Quick.sound('minigame2/punch_'+FlxG.random.int(1,3));
            punchHand.offset.y = -125;
            for (bean in beanGroup)
                bean.hitCheck();
        }
        else
        {
            punchHand.offset.y = FlxMath.lerp(punchHand.offset.y, 0, elapsed*4);
        }

        countShit += elapsed;
        countBalls += elapsed;

        if (countShit >= 0.5+(elapsed*(beansLeft/5)))
        {
            countShit = 0;
            conveyorSpeed += 1;
            updateDifficulty(conveyorSpeed);
        }

        if (countBalls >= timePerBean*0.935)//Give a bit of time to relax
        {
            countBalls = 0;
            makeConveyorBean();
        }

        for (bean in beanGroup)
        {
            if (bean.x > 700)
            {
                bean.visible = false;
                bean.kill();
                bean.destroy();
                beanGroup.remove(bean);
            }    
        }
        Mission.showVar = Mission.coffeeCount;
    }

    function makeConveyorBean()
    {
        if (beansLeft > 0)
        {
            beansLeft--;
            var newBean:ConveyorBean = new ConveyorBean();
            newBean.startMovement(conveyorSpeed*10);
            beanGroup.add(newBean);
        }
    }

    function updateDifficulty(diffLevel:Int = 6)
    {
        conveyorBelt.animation.curAnim.frameRate = diffLevel/2;
        //beanGroup.add(new ConveyorBean());
        for (bean in beanGroup)
			bean.startMovement(diffLevel*10);
    }

    function endStage():Void
    {
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            switchState(new GameThree());
        });
    }
}