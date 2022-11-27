package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxState;

import flixel.util.FlxGradient;
using flixel.util.FlxSpriteUtil;

import flixel.FlxSprite;

class PlayState extends FlxState
{
	private var UI:Mission;

	private var knight:Player;
	private var enemyGroup:FlxTypedGroup<Enemy>;

	private var gradient1:FlxSprite;

	override public function create()
	{
		super.create();
        FlxG.sound.playMusic(Paths.music('Minigame1'), 1, true);

		//Make BG
		var farBG:FlxSprite = new FlxSprite(0,0).makeGraphic(700,700, FlxColor.fromRGB(211,145,75));
		add(farBG);

		//var gradientBG = FlxGradient.createGradientFlxSprite(farBG.frameWidth, farBG.frameHeight, [FlxColor.BLACK, FlxColor.GREEN, FlxColor.WHITE]);
		//farBG.alphaMask(gradientBG.framePixels, farBG.framePixels);
		gradient1 = FlxGradient.createGradientFlxSprite(640, 480, [FlxColor.fromRGB(222,170,60), FlxColor.fromRGB(222,120,111)], 40); //Yellow --> Orange
		gradient1.alpha = 0.6;
		add(gradient1);

		var floor:FlxSprite = new FlxSprite(0,400).loadGraphic(Paths.sprite('floor'));
		add(floor);

		//Make Player
		knight = new Player();
		knight.screenCenter();
		add(knight);

		//Make Enemies
		enemyGroup = new FlxTypedGroup<Enemy>();
		add(enemyGroup);
		enemyGroup.add(new Enemy(0,400));

		for (enemy in enemyGroup)
			enemy.startCycle();

		//MAKE UI
		Mission.setupMissions();
		UI = new Mission();
		add(UI);
		UI.startMission(1);
		//Mission.startMission(1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		gradient1.offset.y = knight.y/4;

		for (enemy in enemyGroup)
		{
			if (FlxG.overlap(enemy, knight.attackHitbox) && knight.attack)
			{
				enemy.kill();
				enemy.destroy();
				enemyGroup.remove(enemy);
			}

			if (enemy.x > 640)
				enemy.x = -enemy.width;
		}
	}
}