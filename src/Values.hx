class Values {
    public static var cells:Array<CellZ>;
    public static var cellsI:Int = 11;
    public  static  var cellsJ:Int = 11;
    public static var cellSize:Int = 64;

    public static var refreshTime:Float = 0.7;
    public static var stay:Array<Int> = [4,1] ;
    public static var live:Array<Int> = [1] ;
    public static var countMyself:Bool = false;
    public static var autoSteps:Bool = true;

    public static var tollBarLength:Int = 32;

    public static function setRefreshTime(str:String) : Void {
        var flt = Std.parseFloat(str);
        if (!Math.isNaN(flt) && flt > 0) refreshTime = flt;
    }

    public static function setRules(str:String) : Void {
        if (str.length>0) {
            var nStay:Array<Int> =[];
            var nLive:Array<Int> =[];
            var nCountSelf:Null<Int> = null;
            var rulelist = str.split("/");
            for (i in 0...rulelist.length) {
                var nums = rulelist[i].split(",");
                for (j in nums) {
                    var pj = Std.parseInt(j);
                    if( pj != null) {
                        if (i == 0) nStay.push(pj);
                        else if (i == 1) nLive.push(pj);
                        else if (i == 2 && [0,1].contains(pj)) nCountSelf = pj;
                    }
                }
            }
            if (rulelist.length >= 2) {
                stay = nStay.copy();
                live = nLive.copy();
            }
            if (nCountSelf != null) countMyself = nCountSelf==1;
        }
    }

    public static function setSize(str:String,parent:h2d.Object):Void {
        var strlist = str.split("x");
        if (strlist.length == 2) {
            var nI = Std.parseInt(strlist[0]);
            var nJ = Std.parseInt(strlist[1]);
            if (nI != null && nJ != null && (nI != cellsI || nJ != cellsJ) && nI >0 && nJ > 0) {
                updateSize(nI,nJ,parent);
            }
        }
    }

    static function updateSize(nI:Int,nJ:Int,parent:h2d.Object) {
        if (nI*nJ != cells.length) {
            autoSteps = false;
            var ncells = new Array<CellZ>();
            for (i in 0...nI) {
                for (j in 0...nJ) {
                    if (i < cellsI && j < cellsJ) {
                        ncells.push(new CellZ(i,j,cells[i*cellsJ+j].alive,parent));
                    }
                    else 
                        ncells.push(new CellZ(i,j,false,parent));
                }
            }
            for (i in cells) i.remove();
            cells = ncells.copy();
            cellsI = nI;
            cellsJ = nJ;
        }
    }

    static public function updateCellSize(str:String) {
        var pi = Std.parseInt(str);
        if (pi != null && pi != cellSize) {
            cellSize = pi;
            for (i in cells) i.updateSprite();
        }
    }

	static public function step() {
        //trace("Refrshing");
        for (i in 0...(cellsI)) {
           for (j in 0...(cellsJ)) {
               var neighbours = 0;
               for (ik in -1...2)
                   for (jk in -1...2)
                       if ((countMyself || ik!=0 || jk !=0) &&
                           cells[(cellsI+i+ik)%cellsI*
                           cellsJ+(Values.cellsJ+j+jk)%cellsJ].alive)
                           neighbours++;
               if (!cells[i*cellsJ+j].alive && live.contains(neighbours)) cells[i*cellsJ+j].changeState(true);
               else if (!stay.contains(neighbours)) cells[i*cellsJ + j].changeState(false);
           }
       }
       for (i in cells) i.updateState();
   }
}
