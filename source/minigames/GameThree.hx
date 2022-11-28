package minigames;

import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

//ONLY A FEW HOURS LEFT, SUPER RUSHED
class GameThree extends CoffeeState
{
    private var UI:Mission;
    private var canType:Bool = true;

    private var knightHead:FlxSprite;

    private var textDisplay:FlxText;
    private var textInput:FlxText;

    private var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    private var randomWords:Array<String> = ['COFFEE', 'DRINK', 'BEANS', 'AMERICANO', 'CAPPUCCINO', 'LATTE', 'SIPHON', 'CORTADO', 'ROAST', 'CUP'];
    private var curWords:String = '';

    private var targetWord:String = '';

    override public function create()
    {
        FlxG.sound.playMusic(Paths.music('Minigame1_speedUp'), 1, true);

        var gradient1:FlxSprite = FlxGradient.createGradientFlxSprite(640, 480, [FlxColor.fromRGB(222,170,60), FlxColor.fromRGB(222,120,111)], 40); //Yellow --> Orange
		add(gradient1);

        knightHead = new FlxSprite().loadGraphic(Paths.sprite('minigame3/knightHead'));
        knightHead.flipX = true;
        knightHead.scale.set(3,3);
        knightHead.updateHitbox();
        knightHead.x = 300;
        knightHead.y = 125;
        add(knightHead);
        FlxTween.tween(knightHead, {y: knightHead.y + 25}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});

        textDisplay = new FlxText(0,0,0, 'coolswag', 32);
        textDisplay.setFormat(null, 32, FlxColor.BROWN, LEFT, OUTLINE, FlxColor.BLACK);
        textDisplay.borderSize = 5;
        textDisplay.screenCenter();
        add(textDisplay);
        textDisplay.x -= 100;
        textDisplay.y -= 50;

        textInput = new FlxText(textDisplay.x,textDisplay.y,0, 'coolswag', 32);
        textInput.setFormat(null, 32, FlxColor.ORANGE, LEFT, OUTLINE, FlxColor.BLACK);
        textInput.borderSize = 5;
        add(textInput);

        Mission.setupMissions();
        UI = new Mission();
		add(UI);
		UI.startMission(3);
		UI.endMissionCallback = endStage;

        makeRandomWord();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (canType)
        {
            if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
                {
                    var pressedKey:FlxKey = FlxG.keys.firstJustPressed();
                    var stringKey:String = Std.string(pressedKey);
                    if(allowedKeys.contains(stringKey))
                    {
                        stringKey = stringKey.toUpperCase();
                        curWords += stringKey;
        
                        if(curWords == targetWord)
                        {
                            correctWord();
                        }
                    }
                }
        
                if(!targetWord.startsWith(curWords))
                    fuckUpWord();
        }

        textInput.text = curWords;
        Mission.showVar = Mission.cupsCount;
    }

    function getRandomWord()
    {
        var newWord:String = randomWords[FlxG.random.int(0, randomWords.length-1)];
        if (newWord != targetWord)
            return newWord;
        else
            return getRandomWord(); //REPEAT UNTIL IT GETS A DIFFERENT ONE
    }

    function fuckUpWord()
    {
        curWords = '';
        Quick.sound('factClick');
    }

    function correctWord()
    {
        add(new ThrowHand());
        Mission.cupsCount++;
        Quick.sound('logoClick');
        makeRandomWord();
    }

    function makeRandomWord()
    {
        targetWord = getRandomWord();
        textDisplay.text = targetWord;
        curWords = '';
    }

    function endStage():Void
    {
        canType = false;
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            switchState(new ResultState());
        });
    }
}