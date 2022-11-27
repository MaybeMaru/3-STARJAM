package;

import openfl.utils.AssetType;
import openfl.utils.Assets;

class Paths
{
    public static function pathExists(path:String, type:AssetType)
    {
        var assetPath:String = getAssetPath(path);
        if (Assets.exists(assetPath, type))
            return assetPath;
        
        return "";
    }

    inline static function getAssetPath(path:String)
    {
        return 'assets/$path';
    }

    public static function sprite(path:String)
    {
        return pathExists('images/$path.png', IMAGE);
    }

    public static function music(path:String)
    {
        return pathExists('music/$path.ogg', MUSIC);
    }

    public static function sound(path:String)
    {
        return pathExists('sounds/$path.ogg', SOUND);
    }

    public static function text(path:String)
    {
        return pathExists('data/$path.txt', TEXT);
    }
}