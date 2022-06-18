import h2d.Text;
import hxd.fmt.grd.Data.Color;
import hxd.res.DefaultFont;
import format.swf.Data.FontData;
import h2d.Font;
import hxd.Event;
import h3d.scene.Interactive;
import format.amf.Value;
import h2d.Tile;
import h2d.TileGroup;
import h2d.Bitmap;
import hxd.Res;
import CellZ;
import Values;

class Main extends hxd.App {

var time : Float = 0;
var cells:Array<CellZ>;
var txtInpTime:h2d.TextInput;

	function initToolBar() {
		var toolBar = new Bitmap(h2d.Tile.fromColor(0x808080,s2d.width,Values.tollBarLength),s2d);

		var btnStepTile = Res.playBtn1.toTile();
		btnStepTile.scaleToSize(Values.tollBarLength,Values.tollBarLength);
		var btnStep = new Bitmap(btnStepTile,toolBar);
		var bntStepInteract = new h2d.Interactive(Values.tollBarLength,Values.tollBarLength,btnStep);
        bntStepInteract.onClick = function(event : hxd.Event) {
            step();
        }
		btnStepTile = Res.playBtn2.toTile();
		var btnAutoStep = new Bitmap(btnStepTile,s2d);
		btnAutoStep.x += Values.tollBarLength + 5;
		var bntAutoStepInteract = new h2d.Interactive(Values.tollBarLength,Values.tollBarLength,btnAutoStep);
        bntAutoStepInteract.onClick = function(event : hxd.Event) {
            Values.autoSteps = !Values.autoSteps;

		}
		
		var txtInpBg = new Bitmap(Tile.fromColor(0xffffff,32,Std.int(Values.tollBarLength/2)),toolBar);
		txtInpBg.x = btnAutoStep.x + Values.tollBarLength + 5;
		txtInpBg.y = Values.tollBarLength/3;
		txtInpTime = new h2d.TextInput(DefaultFont.get(),txtInpBg);
		//txtInpTime.backgroundColor = 0xffffff;
		txtInpTime.inputWidth = 32;
		txtInpTime.textColor = 0x000000;
		txtInpTime.text = "1";

		var updateBtnBg = new Bitmap(Tile.fromColor(0xffffff,64,Std.int(Values.tollBarLength/2)),toolBar);
		updateBtnBg.x = s2d.width - 64 - 5;
		updateBtnBg.y = Values.tollBarLength/3;
		var updateBtnTxt = new Text(DefaultFont.get(),updateBtnBg);
		updateBtnTxt.text = "UPDATE";
		updateBtnTxt.textColor = 0x000000;
		var updateBtnInteract = new h2d.Interactive(64,Std.int(Values.tollBarLength/2),updateBtnBg);
		updateBtnInteract.onClick = function(event:hxd.Event) {
			Values.refreshTime = Std.parseFloat(txtInpTime.text);
			time = 0;
		}
	}

    override function init() {
        cells = new Array();
        for (i in 0...Values.cellsI) {
            for (j in 0...Values.cellsJ) {
                cells.push(new CellZ(i,j,false,s2d));
            }
        }
        var aliveAtStart:Array<Array<Int>> = [[1,1],[2,1],[1,3],[2,3],[3,2],[0,3]];
        for (i in aliveAtStart)
            cells[i[0]*Values.cellsJ+i[1]].updateState(true);

		initToolBar();
        }

    override  function update(dt:Float) {
		if (Values.autoSteps) {
			time += dt;
			if (time >= Values.refreshTime) {
				step();
				time = 0;
			}
		}
    }

	function step() {
		 //trace("Refrshing");
		 for (i in 0...(Values.cellsI)) {
			for (j in 0...(Values.cellsJ)) {
				var neighbours = 0;
				for (ik in -1...2)
					for (jk in -1...2)
						if ((Values.countMyself || ik!=0 || jk !=0) &&
							cells[(Values.cellsI+i+ik)%Values.cellsI*
							Values.cellsJ+(Values.cellsJ+j+jk)%Values.cellsJ].alive)
							neighbours++;
				if (!cells[i*Values.cellsJ+j].alive && Values.live.contains(neighbours)) cells[i*Values.cellsJ+j].changeState(true);
				else if (!Values.stay.contains(neighbours)) cells[i*Values.cellsJ + j].changeState(false);
			}
		}
		for (i in cells) i.updateState();
	}

    static function  main() {
        hxd.Res.initEmbed();
        new Main();
    }
}