package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;

using StringTools;

typedef MissionType =
{
    title:String,
    description:String,
}

class Mission extends FlxSpriteGroup
{
    public static var missionMap:Map<Int, MissionType> = new Map<Int, MissionType>();
    public static var curMission:MissionType;

    public var missionStuff:Array<FlxText> = [];
    public var endMissionCallback:Void->Void;

    public var timeTxt:FlxText;
    public var timeSpr:FlxSprite;
    public var timeLeft:Int = 60;

    public var beanCounterTxt:FlxText;
    public var beanCounterSpr:Bean;

    public function addMissionUI()
    {
        beanCounterSpr = new Bean(440,20);
        add(beanCounterSpr);

        timeSpr = new FlxSprite(beanCounterSpr.x, beanCounterSpr.y + 17*3).loadGraphic(Paths.sprite('clock'), true, 16,16);
        timeSpr.scale.set(3,3);
        timeSpr.updateHitbox();
        timeSpr.animation.add('idle', [0,1,2,3,4], 12);
        timeSpr.animation.play('idle');
        add(timeSpr);

        timeTxt = new FlxText(timeSpr.x + 17*3, timeSpr.y, 0, 'coolswag', 32);
        timeTxt.setFormat(null, 32, FlxColor.GRAY, LEFT, OUTLINE, FlxColor.BLACK);
        timeTxt.borderSize = 5;
        add(timeTxt);

        beanCounterTxt = new FlxText(beanCounterSpr.x + 17*3, beanCounterSpr.y, 0, ': 0', 32);
        beanCounterTxt.setFormat(null, 32, FlxColor.BROWN, LEFT, OUTLINE, FlxColor.BLACK);
        beanCounterTxt.borderSize = 5;
        add(beanCounterTxt);
    }

    public function startMission(mission:Int)
    {
        missionStuff = [];
        curMission = missionMap[mission];

        var missionTitle:FlxText = new FlxText(525, 25, 0, curMission.title, 32);
        missionTitle.setFormat(null, 32, FlxColor.BROWN, LEFT, OUTLINE, FlxColor.BLACK);
        missionTitle.borderSize = 5;
        missionStuff.push(missionTitle);

        var missionDescription:FlxText = new FlxText(525, 75, 0, curMission.description, 16);
        missionDescription.setFormat(null, 16, FlxColor.ORANGE, LEFT, OUTLINE, FlxColor.BLACK);
        missionDescription.borderSize = 2.5;
        missionStuff.push(missionDescription);

        FlxTween.tween(missionTitle, {y: missionTitle.y + 25}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
        FlxTween.tween(missionDescription, {y: missionDescription.y + 20}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

        FlxTween.tween(missionTitle, {x: missionTitle.x -500}, 1, {ease: FlxEase.quadInOut});
        FlxTween.tween(missionDescription, {x: missionDescription.x -500}, 1, {ease: FlxEase.quadInOut});

        for (shit in missionStuff)
            add(shit);

        addMissionUI();
    }

    public static function addMission(index:Int, leTitle:String, leDescription:String)
    {
        missionMap.set(index, {title: leTitle, description: leDescription});
    }

    public static function setupMissions()
    {
        addMission(1, 'RIP AND BEAN', 'Destroy ENEMIES and obtain as many\nCOFFEE BEANS as possible!');
        addMission(2, 'COFFEE PUNCHER', 'Punch all the COFFEE BEANS into COFFEE!');
        addMission(3, 'DRINK! DRINK!', 'Quickly, DRINK all your COFFEE CUPS!!');
    }

    var leCount:Float = 0;
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        leCount += elapsed;
        if (leCount >= 1 && timeLeft>0)
        {
            leCount = 0;
            timeLeft--;

            if(timeLeft == 0)
                endMissionCallback();
        }
        updateUI();
    }

    function updateUI()
    {
        timeTxt.text = ': '+FlxStringUtil.formatTime(timeLeft, false);
        beanCounterTxt.text = ': '+Bean.count;
    }
}