package au.com.buzzware.actiontools3.code
{
	/*
	AIM: Class that can be attached to a validator like :
	
	<mx:Validator id="validator" source="{username}" property="text" invalid="invalidHandler(event)" valid="validHandler(event)"/>
		<mx:listener>
			<CustomValidatorListener listenerFunction="" />
		</mx:listener>
	</mx:Validator>
	
	but thought may not be necessary as CustomValidator may be able to do it alone
	*/
	
	
	public class CustomValidatorListener implements IValidatorListener
	{
		protected var _control:Object;
    protected var _passThroughEvent:Boolean;
		public var errorString: String;
		public var validationSubField: String;
		

    // The constructor accepts two parameters: the control with a text
    // property you want to target, and an optional parameter specifying
    // whether or not to pass through the event to the control if it
    // cannot auto-correct.		
    public function CustomValidatorListener(aControl:Object, aPassThroughEvent:Boolean = true) {
			super();
			_control = control;
      _passThroughEvent = passThroughEvent;			
			
		}
		
		// This method gets called when the validator dispatches an event. The code
    // auto-corrects the text if possible (in this case it only auto-corrects
    // one case). If it cannot auto-correct, it passes the event (if
    // applicable) to the control.		
    public function validationResultHandler(event:ValidationResultEvent):void {
        if(_control.text == "abc" || _control.text == "abcd") { // if can fix then fix
        	_control.text = "abcd";
        } else {
	        if(_passThroughEvent) {
	        	_control.validationResultHandler(event);
	        }
        }
    }
	}
}