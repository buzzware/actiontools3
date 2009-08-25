package au.com.buzzware.actiontools3.design
{
	import au.com.buzzware.actiontools3.code.StringUtils;
	
	import mx.controls.Button;
	import mx.controls.ButtonPhase;
	import mx.core.IFlexDisplayObject;
	import mx.core.IStateClient;
	import mx.core.mx_internal;
    
  use namespace mx_internal;

	/*
	1) can set skin="mx.skins.halo.ButtonSkin" in MXML tag or 
	skin: ClassReference("mx.skins.halo.ButtonSkin");
	in mx:Style CSS. This actually works for any component
	2) hasIcon shows or hides icon
	3) skinSelectFunction enables remapping the skin states arbitrarily.
	4) text color styles :
			state							use style
			------------------------------------
			over							textRollOverColor
			down|selected			textSelectedColor
			up|disabled|other	color
	*/

	public class HackableButton extends Button
	{
	
    public var skinSelectFunction:Function;

		public function HackableButton()
		{
			super();
		}
		
		public static function skinSelect2State(aHackableButton: HackableButton, aValues: Object): void {
			switch(aValues.skin) {
				case "upSkin":								break;
				case "overSkin":							aValues.skin = "upSkin";	break;
				case "downSkin":							break;
				case "disabledSkin":					aValues.skin = "upSkin";	break;
				case "selectedUpSkin":				aValues.skin = "downSkin";	break;
				case "selectedOverSkin":			aValues.skin = "downSkin";	break;
				case "selectedDownSkin":			aValues.skin = "downSkin";	break;
				case "selectedDisabledSkin":	aValues.skin = "downSkin";	break;
				default:     
			}	
		}

		public static function skinSelect1State(aHackableButton: HackableButton, aValues: Object): void {
			aValues.skin = "upSkin";
		}
		
/* 		

		
		[Bindable]
		protected var _hasIcon: Boolean = true;
		public function get hasIcon(): Boolean {
			return _hasIcon;
		}
		public function set hasIcon(aValue: Boolean): void {
			_hasIcon = aValue;
			use namespace mx_internal;
			
			if (aValue) {
				mx_internal::iconName = 'icon';
			} else {
				mx_internal::iconName = '';
			}
			
		}
		
 		override mx_internal function viewIconForPhase(tempIconName:String):IFlexDisplayObject {
			if (skinSelectFunction==null) {
				return super.viewIconForPhase(tempIconName);
			}
			var values: Object = {
				'icon': StringUtils.chop(tempIconName,'Icon')
			}
		
	
			skinSelectFunction(this,values);
			
			var withPrefix: String = (values.icon==undefined || values.icon==null || values.icon=='') ? '' : values.icon+'Icon';
			var result:IFlexDisplayObject = super.viewIconForPhase(withPrefix);
			
			if (defaultIconUsesStates && currentIcon is IStateClient)
			{
					IStateClient(currentIcon).currentState = values.icon;
			}

			return result;
		}
		*/

			/* translate between these values of icon	
			"upIcon"
		  "overIcon"
		  "downIcon"
		  "disabledIcon"
		  "selectedUpIcon"
		  "selectedOverIcon"
		  "selectedDownIcon"
		 	"selectedDisabledIcon"
			*/		

		override mx_internal function viewSkinForPhase(tempSkinName:String, stateName:String):void {
			var labelColor: Number = 0;
			var labelState: int;
			if (skinSelectFunction==null) {
				super.viewSkinForPhase(tempSkinName,stateName);
				/*
				if (selected || phase == ButtonPhase.DOWN) {
					labelColor = textField.getStyle("textSelectedColor");	
				} else if (phase == ButtonPhase.OVER) {
					labelColor = textField.getStyle("textRollOverColor");
				} else {
					labelColor = textField.getStyle("color");
				}
				*/
			} else {
				var values: Object = {
					'skin': tempSkinName,
					'state': stateName
				}
				skinSelectFunction(this,values);
				super.viewSkinForPhase(values.skin,values.state);
		    
		    if (enabled) {
		    	switch(values.state) {
		    		case 'over':	labelColor = textField.getStyle("textRollOverColor"); break;
		   			case 'down':
		   			case 'selectedUp':
		   			case 'selectedOver':
		   			case 'selectedDown':
		   			case 'selectedDisabled': labelColor = textField.getStyle("textSelectedColor"); break;
		   			default: labelColor = textField.getStyle("color");
		    	}
		    }
		    			
			}			
		  textField.setColor(labelColor);
		}
	}
}