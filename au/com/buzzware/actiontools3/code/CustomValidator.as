/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

/*
eg.

import mx.events.ValidationResultEvent;
private function validHandler(aEvent:ValidationResultEvent):void {
	// do something
}
private function invalidHandler(aEvent:ValidationResultEvent):void {
	// do something
}

// return null if OK or error string if error
private function validateFn(aCustomValidator: CustomValidator, aValue: Object):String {
		
}


<mx:TextInput id="username"/>
<mx:Validator 
	id="validator" 
	source="{username}" 
	property="text"
	invalid="invalidHandler(event)" 
	valid="validHandler(event)"
/>
*/

package au.com.buzzware.actiontools3.code {

   import mx.validators.Validator;
   import mx.validators.ValidationResult;

	public class CustomValidator extends Validator
	{
    private var results:Array;
		
    public var validateFunction:Function;
		
		public function CustomValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array {
			results = super.doValidation(value);
			if (results.length > 0)
				return results;

			if (validateFunction) {
				var fnResult: String = validateFunction(this,value)
				if (fnResult) {
					results.push(new ValidationResult(true, null, '', fnResult));
				}
			}
			return results;
		}
	}
}