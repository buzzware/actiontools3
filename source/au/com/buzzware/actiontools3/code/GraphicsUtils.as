/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {
	import flash.display.BitmapData;
	import mx.core.Application;
	import flash.display.Stage;
	import mx.styles.StyleManager;	

	public class GraphicsUtils {

		/*
		Set application width and height to 100% so the stage doesn't grow with content that 
		is unlimited, and can be reasonably captured for rendering purposes.
		Flash scrollbars will appear, which are virtually the same as browser ones anyway
		*/
		public static function CaptureStageBitmapData(): BitmapData {
			var s:Stage = Application.application.stage
			var result:BitmapData = new BitmapData(s.stageWidth,s.stageHeight,false)
			result.draw(s,null,null,flash.display.BlendMode.NORMAL)
			return result;
		}
		
		public static function ColorFromString(aString: String, aDefault: String = '#000000'): uint {
			var result: uint = StyleManager.getColorName(aString);
			if (result == StyleManager.NOT_A_COLOR)
				result = StyleManager.getColorName(aDefault);
			return result;
		}
	}
}
