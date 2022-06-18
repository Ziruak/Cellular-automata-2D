import h2d.Interactive;
import h2d.Tile;
import h2d.Bitmap;

class CellZ {
    public var alive:Bool;
    public var nextState:Bool;
    public var sprite:Bitmap;
    public var parent:h2d.Object;
    public var inter:Interactive;
    public var i:Int;
    public var j:Int;

    public function new(i:Int,j:Int,living:Bool = false,scene:h2d.Object) {
        alive = living;
        nextState = alive;
        parent = scene;
        this.i = i;
        this.j = j;
        updateSprite();
    }

    public function copy(cell:CellZ) {
        i = cell.i;
        j = cell.j;
        parent = cell.parent;
        alive = cell.alive;
        nextState = cell.nextState;
        updateSprite();
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

    public function updateSprite() {
        var tile:Tile;
        if (alive) tile = hxd.Res.cell_alive.toTile();
        else tile = hxd.Res.cell_dead.toTile();
        tile.scaleToSize(Values.cellSize,Values.cellSize);
        inter.remove();
        sprite.remove();
        sprite = new Bitmap(tile,parent);
        sprite.x = j*Values.cellSize;
        sprite.y = i*Values.cellSize + Values.tollBarLength;
        inter = new Interactive(Values.cellSize,Values.cellSize);
        inter.onOver = function(event : hxd.Event) {
            sprite.alpha = 0.8;
        }
        inter.onOut = function(event : hxd.Event) {
            sprite.alpha = 1;
        }
        inter.onClick = function(event : hxd.Event) {
            updateState(!alive);
        }
        sprite.addChild(inter);
        // var shdr = new CellShader();
        // shdr.red = 1;
        // sprite.filter = new h2d.filter.Shader(shdr);
        
        var shader = new SineDeformShader();
        shader.speed = 9;
        shader.amplitude = .3;
        shader.frequency = .1;
        shader.texture = sprite.tile.getTexture();
        sprite.addShader(shader);
    }

    public function remove() {
        inter.remove();
        sprite.remove();
    }
}

class CellShader extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var texture : Sampler2D;
        @param var red : Float;
        
        function fragment() {
            pixelColor = texture.get(input.uv);
            pixelColor.r = red; // change red channel
        }
    }
}

class SineDeformShader extends hxsl.Shader {
    static var SRC = {
        @:import h3d.shader.Base2d;
        
        @param var texture : Sampler2D;
        @param var speed : Float;
        @param var frequency : Float;
        @param var amplitude : Float;
        
        function fragment() {
            calculatedUV.y += sin(calculatedUV.y * frequency + time * speed) * amplitude; // wave deform
            calculatedUV.x += cos(calculatedUV.x * frequency + time * speed*0.7) * amplitude;
            pixelColor = texture.get(calculatedUV);
        }
    }
}