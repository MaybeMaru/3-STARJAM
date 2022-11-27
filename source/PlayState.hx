package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

import flixel.util.FlxGradient;
import flixel.math.FlxPoint;

import flixel.FlxSprite;

class PlayState extends CoffeeState
{
	private var UI:Mission;

	private var knight:Player;
	private var enemyGroup:FlxTypedGroup<Enemy>;
	private var beanGroup:FlxTypedGroup<Bean>;

	//Gameplay
	private var difficultyRise:Float = 0;

	private var gradient1:FlxSprite;

	override public function create()
	{
        FlxG.sound.playMusic(Paths.music('Minigame1'), 1, true);

		//Make BG
		var farBG:FlxSprite = new FlxSprite(0,0).makeGraphic(700,700, FlxColor.fromRGB(222,170,60));
		add(farBG);
		gradient1 = FlxGradient.createGradientFlxSprite(640, 480, [FlxColor.fromRGB(222,170,60), FlxColor.fromRGB(222,120,111)], 40); //Yellow --> Orange
		gradient1.alpha = 0.6;
		add(gradient1);

		var floor:FlxSprite = new FlxSprite(0,400).loadGraphic(Paths.sprite('floor'));
		add(floor);

		//Make Enemies
		enemyGroup = new FlxTypedGroup<Enemy>();
		add(enemyGroup);
		//enemyGroup.add(new Enemy(0,400, beanExplosion));

		//Make Player
		knight = new Player();
		knight.screenCenter();
		add(knight);

		//Make BEANS
		add(beanGroup);

		for (enemy in enemyGroup)
			enemy.startCycle();

		//MAKE UI
		Bean.count = 0;
		Mission.setupMissions();
		UI = new Mission();
		add(UI);
		UI.startMission(1);
		UI.endMissionCallback = endStage;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		difficultyRise+= elapsed;

		if (difficultyRise >=3 && FlxG.random.bool((difficultyRise+10)/20))
		{
			var isFlipped = FlxG.random.bool(50);

			var enemyType:String = "";
			if (FlxG.random.bool(50))
				enemyType = "air";

			var newEnemy:Enemy = new Enemy(-99,400, enemyType, beanExplosion);
			if(isFlipped)
				newEnemy.x += 798;
			newEnemy.startCycle(isFlipped);
			enemyGroup.add(newEnemy);
		}

		gradient1.offset.y = knight.y/4;

		if (knight.resetP)
		{
			FlxG.resetState();
		}

		for (enemy in enemyGroup)
		{
			if (FlxG.overlap(enemy, knight.attackHitbox) && knight.attack)
			{
				enemy.getHit();
				if(enemy.enemyHealth < 1)
					enemyGroup.remove(enemy);
			}

			if (enemy.x > 700 || enemy.x < -100)
			{
				enemy.visible = false;
				enemy.kill();
				enemy.destroy();
				enemyGroup.remove(enemy);
			}
		}
	}
	
	private function beanExplosion():Void
	{
		var beanX = knight.x;
		var beanY = knight.y;

		for (i in 0...FlxG.random.int(2,6))
		{
			var rX:Int = FlxG.random.int(-15,15);
			var rY:Int = FlxG.random.int(-15,15);

			var collectBean:Bean = new Bean (beanX+rX,beanY+rY);
			collectBean.scale.set(2,2);
			add(collectBean);
			collectBean.moveSpeed = FlxG.random.int(20,80)/100;
			collectBean.targetPos = new FlxPoint(440,20);
		}
	}

	function endStage():Void
	{
		knight.canMove = false;
		if(Bean.count >= 200)
			knight.playAnim('victory', true);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			switchState(new TitleScreen());
		});
	}
}