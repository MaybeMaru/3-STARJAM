package;

import flixel.FlxSprite;
using StringTools;

class UIelement extends FlxSprite
{
    public function new(type:String = 'bean')
    {
        super(440,20);
        loadGraphic(Paths.sprite('UIthing'), true, 16, 16);
        scale.set(3,3);
        updateHitbox();

        animation.add('bean',   [0,1,2,3,4], 12);
        animation.add('clock',  [5,6,7,8,9], 12);
        animation.add('coffee', [10,11,12,13,14], 12);
        animation.add('cup',    [15,16,17,18,19], 12);

        animation.play(type.toLowerCase().trim(), true);
    }
}