package;

import flixel.FlxG;
import lime.utils.Assets;
using StringTools;

class Quick
{
    public static function sound(leSound:String, volume:Float = 1)
    {
        var soundPath:String = Paths.sound(leSound);
        FlxG.sound.play(soundPath, volume);
    }

    public static function getText(path:String):Array<String>
    {
        var textArray:Array<String> = Assets.getText(Paths.text(path)).trim().split('\n');
        for (i in 0...textArray.length)
            textArray[i] = textArray[i].trim();
        return textArray;
    }
}