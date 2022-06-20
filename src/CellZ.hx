import h2d.filter.Shader;
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
    public var shdr:CellAlShader;

    public function new(i:Int,j:Int,living:Bool = false,scene:h2d.Object) {
        alive = living;
        nextState = alive;
        parent = scene;
        this.i = i;
        this.j = j;

        var tile:Tile = hxd.Res.cell_bnw.toTile();
        tile.scaleToSize(Values.cellSize,Values.cellSize);
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
        
        // var shader = new SineDeformShader();
        // shader.speed = 10;
        // shader.amplitude = .4;
        // shader.frequency = .1;
        // shader.texture = sprite.tile.getTexture();
        // sprite.addShader(shader);

        shdr = new CellAlShader();
        shdr.red = 0;
        shdr.green = 0;
        shdr.texture = sprite.tile.getTexture();
        sprite.addShader(shdr);

        updateSprite();
    }

    public function copy(cell:CellZ) {
        i = cell.i;
        j = cell.j;
        parent = cell.parent;
        alive = cell.alive;
        nextState = cell.nextState;
        sprite = cell.sprite;
        shdr = cell.shdr;
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
        sprite.tile.scaleToSize(Values.cellSize,Values.cellSize);
        sprite.x = j*Values.cellSize;
        sprite.y = i*Values.cellSize + Values.tollBarLength;
        if (alive) {
            shdr.red = 0;
            shdr.green = 0.8;
        }
        else {
            shdr.green = 0;
            shdr.red = 0.8;
        }
        
        // var shader = new SineDeformShader();
        // shader.speed = 10;
        // shader.amplitude = .4;
        // shader.frequency = .1;
        // shader.texture = sprite.tile.getTexture();
        // sprite.addShader(shader);
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
        @param var green : Float;
        
        function fragment() {
            pixelColor = texture.get(input.uv);
            pixelColor.r *= red; // change red channel
            pixelColor.g *= green;
            pixelColor.b = 0.25;
        }
    }
}

class CellAlShader extends hxsl.Shader {
    static var SRC = {
        @input var input: {uv:Vec2};
        var output : {color:Vec4};

        @param var texture : Sampler2D;
        @param var red : Float;
        @param var green : Float;
        
        function fragment() {
            output.color = texture.get(input.uv);
            output.color.r *= red;
            output.color.g *= green;
            output.color.b *= 0.3;
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
            pixelColor.r *= input.uv.x;
            pixelColor.b *= input.uv.y;
            pixelColor.g *= input.position.x+input.position.y;
        }
    }
}