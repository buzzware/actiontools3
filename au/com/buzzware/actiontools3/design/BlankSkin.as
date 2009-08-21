package au.com.buzzware.actiontools3.design {

import flash.display.Graphics;
import mx.skins.ProgrammaticSkin;

	public class BlankSkin extends ProgrammaticSkin {
		//include "../../core/Version.as";
	
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
	
			var g:Graphics = graphics;
	
			g.clear();
			//g.lineStyle(1.0, getStyle("borderColor"));
			g.drawRect(0, 0, w, h);
		}
	}
}
