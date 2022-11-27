package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

//The milkman's milk is delicious
class Player extends FlxSpriteGroup
{
    //Gameplay
    public var canMove:Bool = true;
    
    //Hitboxes
    public var playerHitbox:FlxSprite;
    public var attackHitbox:FlxSprite;

    //Display
    public var playerSprite:FlxSprite;

    //Player variables
    var leOffset:Float = 0;
    var jumping:Bool = false;
    var falling:Bool = true;

    // Controls shit
    var left:Bool;
    var right:Bool;
    public var resetP:Bool;
    public var jump:Bool;
    public var attack:Bool;

    public function new (x:Float = 0, y:Float = 0)
    {
        super(x,y);

        playerHitbox = new FlxSprite(0,0).makeGraphic(50, 75, FlxColor.WHITE);
        playerHitbox.alpha = 0;
        add(playerHitbox);

        attackHitbox = new FlxSprite(0,0).makeGraphic(125, 75, FlxColor.RED);
        attackHitbox.alpha = 0;
		add(attackHitbox);

        playerSprite = new FlxSprite(0,0).loadGraphic(Paths.sprite('coffeeKnightFINAL'), true, 154, 112);
        playerSprite.scale.set(0.5,0.5);
        playerSprite.updateHitbox();
        playerSprite.animation.add('idle', [0,1,2,3,4], 12);
        playerSprite.animation.add('attack', [5,6], 12, false);
        playerSprite.animation.add('jump', [7,8], 12, false);
        playerSprite.animation.add('victory', [9,10,11,12], 12);
        playerSprite.animation.add('walk', [13,14,15,16], 12);
        playerSprite.animation.add('fall', [17,18], 12);

        playerSprite.scale.set(1.5,1.5);
        add(playerSprite);

        maxVelocity.y = 500;
        maxVelocity.x = 350;
        scrollFactor.set();
        leOffset = -playerHitbox.height;

        playAnim('idle');
        this.y = 400+leOffset;
    }

    override function update(elapsed:Float)
    {        
        if(canMove)
        {
            left = FlxG.keys.anyPressed(['LEFT', 'A']);
            right = FlxG.keys.anyPressed(['RIGHT', 'D']);
            jump = FlxG.keys.anyJustPressed(['SPACE', 'Z']);
            attack = FlxG.keys.anyJustPressed(['X']);
            resetP = FlxG.keys.anyJustPressed(['R']);
        }
        else
        {
            left = false;
            right = false;
            jump = false;
            attack = false;
            resetP = false;
        }
        move();
        if (attack)
            doAttack();

        if(!falling)
        {
            animReplace('attack', 'idle');
            isGrounded();
        }
        else
        {
            animReplace('attack', 'fall');
            isFalling();
        }
        animReplace('jump', 'fall');

        addOffset(playerSprite, [95,40], [5,40]);
        addOffset(attackHitbox, [125,0], [-50,0], false);

        super.update(elapsed);
    }

    private function doAttack()
    {
        Quick.sound('minigame1/hit_'+FlxG.random.int(1,3));
        playAnim('attack', true);
    }

    public var worldLimits:Array<Int> = [0,640-65];

    private function move()
    {
        if (left || right)
        {
            if (!falling && playerSprite.animation.curAnim.name != 'attack')
                playAnim('walk');
            
            if (left && x > worldLimits[0])
            {
                flipX = true;
                velocity.x = -300;

            }
            else if (right && x < worldLimits[1])
            {
                flipX = false;
                velocity.x = 300;
            }
            else
                velocity.x = 0; 
        }
        else
        {
            if (!falling && !jumping && playerSprite.animation.curAnim != null)
            {
                if (playerSprite.animation.curAnim.name != 'attack')
                    playAnim('idle');
            }

            velocity.x = 0;
        }
    }

    private function isGrounded()
    {
        // JUMP
        if (jump)
        {
            Quick.sound('jump');
            playAnim('jump');
            y -= 10;
            velocity.y -= 400;
            jumping = true;
            falling = true;
        }
    }

    private function isFalling()
    {
        // GRAVITY
        velocity.y += 10;
        jumping = false;

        // "collision"
        if (y >= 400+leOffset)
        {
            hitFloor();
        }
    }

    private function hitFloor()
    {
        Quick.sound('land');
        playAnim('idle');
        y = 400+leOffset;
        velocity.y = 0;
        falling = false;
        jumping = false;
    }

    public function playAnim(anim:String, forced:Bool = false)
    {
        if (playerSprite.animation.curAnim == null)
            playerSprite.animation.play(anim, forced);
        else if (playerSprite.animation.curAnim.name != 'victory')
            playerSprite.animation.play(anim, forced);
    }
    
    public function animReplace(anim1:String, anim2:String)
    {
        if (playerSprite.animation.curAnim != null)
        {
            if (playerSprite.animation.curAnim.name == anim1 && playerSprite.animation.curAnim.finished)
                playAnim(anim2);
        }
    }

    public function addOffset(obj:FlxSprite, offset1:Array<Float>, offset2:Array<Float>, useOffs:Bool = true)
    {
        if (flipX)
        {
            if (useOffs)
                obj.offset.set(offset1[0], offset1[1]);
            else
                obj.setPosition(x-offset1[0], y-offset1[1]);
        }
        else
        {
            if (useOffs)
                obj.offset.set(offset2[0], offset2[1]);
            else
                obj.setPosition(x-offset2[0], y-offset2[1]);
        }

    }
}