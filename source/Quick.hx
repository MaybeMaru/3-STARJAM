package;

import flixel.FlxG;

class Quick
{
    public static function sound(leSound:String)
    {
        var soundPath:String = Paths.sound(leSound);
        FlxG.sound.play(soundPath);
    }
}