package au.com.buzzware.actiontools3.design {
	
	import au.com.buzzware.actiontools3.code.ComponentUtils;
	
	import mx.controls.Label;
	import mx.core.UITextField;

	[Style(name="textAlignVertical", type="String", format="Length", inherit="yes")]

	public class SuperLabel extends Label {
		public function SuperLabel() {
			super();
		}
		
    override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
    	var verticalAlign: String = getStyle('textAlignVertical');
    	var tf: UITextField = ComponentUtils.getLabelUITextField(this);
 	    var backgroundColor:int = getStyle("backgroundColor");
	    var backgroundAlpha:Number = getStyle("backgroundAlpha");
   	if (tf) {
	    	switch (verticalAlign) {
	    		case 'center':
						setStyle('paddingTop',(unscaledHeight-tf.measuredHeight)/2);
						setStyle('paddingBottom',(unscaledHeight-tf.measuredHeight)/2);
						if (opaqueBackground) {
							drawRoundRect(
		    				0, 0, unscaledWidth, unscaledHeight, 
		    				0, 
		    				backgroundColor, backgroundAlpha
		    			);
	    			}
	    		break;
	    	}
    	}
    	super.updateDisplayList(unscaledWidth, unscaledHeight);	
    }
	}
}