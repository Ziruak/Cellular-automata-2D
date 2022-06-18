class Values {
    public static var cellsI:Int = 10;
    public  static  var cellsJ:Int = 10;
    public static var cellSize:Int = 64;

    public static var refreshTime:Float = 1;
    public static var stay:Array<Int> = [2,3] ;
    public static var live:Array<Int> = [3] ;
    public static var countMyself:Bool = true;
    public static var autoSteps:Bool = false;

    public static var tollBarLength:Int = 32;

    public static function setRefreshTime(str:String) : Void {
        var flt = Std.parseFloat(str);
        if (!Math.isNaN(flt) && flt > 0) refreshTime = flt;
    }

    public static function setRules(str:String) : Void {
        if (str.length>0) {
            var nStay:Array<Int> =[];
            var nLive:Array<Int> =[];
            var rulelist = str.split("/");
            for (i in 0...rulelist.length) {
                var nums = rulelist[i].split(",");
                for (j in nums) {
                    var pj = Std.parseInt(j);
                    if( pj != null) {
                        if (i == 0) nStay.push(pj);
                        else if (i == 1) nLive.push(pj);
                    }
                }
            }
            if (nStay.length >0 || nLive.length >0) {
                stay = nStay.copy();
                live = nLive.copy();
            }
        }
    }
}
