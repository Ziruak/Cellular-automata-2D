import h2d.Interactive;
import h2d.Tile;
import h2d.Bitmap;

class CellZ {
    public var alive:Bool;
    public var nextState:Bool;
    public var sprite:Bitmap;
    public var parent:h2d.Scene;
    public var inter:Interactive;
    public var i:Int;
    public var j:Int;

    public function new(i:Int,j:Int,living:Bool = false,scene:h2d.Scene) {
        alive = living;
        nextState = alive;
        parent = scene;
        this.i = i;
        this.j = j;
        updateSprite();
        inter = new Interactive(Values.cellSize,Values.cellSize,sprite);
        inter.onOver = function(event : hxd.Event) {
            sprite.alpha = 0.8;
        }
        inter.onOut = function(event : hxd.Event) {
            sprite.alpha = 1;
        }
        inter.onClick = function(event : hxd.Event) {
            updateState(!alive);
        }
    }

    public function changeState(?state:Bool) {
        if (state == null) {
            nextState = !alive;
        } else {
            nextState = state;
        }
    }

    public function updateState(?state:Bool) {
        if (state!=null) changeState(state);
        if (nextState != alive) {
            alive = nextState;
            updateSprite();
        }
    }

    function updateSprite() {
        var tile:Tile;
        if (alive) tile = hxd.Res.cell_alive.toTile();
        else tile = hxd.Res.cell_dead.toTile();
        tile.scaleToSize(Values.cellSize,Values.cellSize);
        sprite = new Bitmap(tile,parent);
        sprite.x = j*Values.cellSize;
        sprite.y = i*Values.cellSize + Values.tollBarLength;
    }
}