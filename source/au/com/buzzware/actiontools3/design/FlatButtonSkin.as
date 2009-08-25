package au.com.buzzware.actiontools3.design {
  // skins/ButtonStatesSkin.as

  import flash.display.Graphics;
  
  import mx.skins.ProgrammaticSkin;
  
  /*
  
  The following styles apply when this skin is used :
  
	backgroundUpColor (0xE0E0E0)
	backgroundOverColor (0xCCCCCC) 
	backgroundDownColor (0x404040)
	backgroundDisabledColor (0x808080)
  */
  

  public class FlatButtonSkin extends ProgrammaticSkin {
     
     public var lineThickness:Number;

     public function FlatButtonSkin() {
				//super();
        // Set default values.
        lineThickness = 1;
     }
     
    protected function getStyleDefault(aName: String, aDefault: Object = null): Object {
    	var result: Object = getStyle(aName);
    	if (result==null || result=='')
    		result = aDefault;
    	return result; 
    }

		override protected function updateDisplayList(w:Number, h:Number):void {
			//var fillColors:Array = getStyle("fillColors");
			//StyleManager.getColorNames(fillColors);
     	
     		var backgroundFillColor: Number;
     		//var borderColor: Number;
     		//var borderThickness: Number = 0; //getStyleDefault('borderThickness',1) as Number;
        // Depending on the skin's current name, set values for this skin.
        switch (name) {
           case "upSkin":
            //borderColor = getStyleDefault('borderUpColor',0xE0E0E0) as Number;
            backgroundFillColor = getStyleDefault('backgroundUpColor',0xE0E0E0) as Number; //0xFFFFFF;
            break;
           case "overSkin":
            //borderColor = getStyleDefault('borderOverColor',0xCCCCCC) as Number;
            backgroundFillColor = getStyleDefault('backgroundOverColor',0xCCCCCC) as Number; //0xCCCCCC;
            break;
           case "selectedOverSkin":
           case "selectedUpSkin":
           case "selectedDownSkin":
           case "selectedDisabledSkin":
           case "downSkin":
            //borderColor = getStyleDefault('borderDownColor',0x404040) as Number;
            backgroundFillColor = getStyleDefault('backgroundDownColor',0x404040) as Number;
            break;
           case "disabledSkin":
            //borderColor = getStyleDefault('borderDisabledColor',0x808080) as Number;
            backgroundFillColor = getStyleDefault('backgroundDisabledColor',0x808080) as Number;
            break;
           default:
           	trace('unhandled:'+name);
        }
					
				var r: Number = getStyle("cornerRadius") as Number;
				if (isNaN(r))
					r=0.0;
				graphics.clear();
        drawRoundRect(0,0,w,h,r,backgroundFillColor,1.0);
     }
  }
}