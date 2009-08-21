/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {
	import flash.display.DisplayObject;
	
	import mx.containers.ViewStack;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.utils.ObjectProxy;
	import mx.core.mx_internal;
	
	
	
	public class ComponentUtils {
		public static function BringToFront(aDisplayObject: DisplayObject): void {
			if (!aDisplayObject.parent)
				return;
			aDisplayObject.parent.setChildIndex(aDisplayObject,aDisplayObject.parent.numChildren-1)
		}

		public static function SendToBack(aDisplayObject: DisplayObject): void {
			if (!aDisplayObject.parent)
				return;
			aDisplayObject.parent.setChildIndex(aDisplayObject,0)
		}

		public static function getChildIndexByName(aViewStack: ViewStack,aPageId: String): int {
			if (!aPageId || aPageId=='')
				return -1;
			var c:UIComponent = aViewStack.getChildByName(aPageId) as UIComponent
			return c ? aViewStack.getChildIndex(c) : -1
		}
		
		public static function getComponentChildByClass(
			aParent: UIComponent, 
			aClass: Class,
			aAfter: DisplayObject = null
		): DisplayObject {
			var i:int = 0;
			if (aAfter) {
				i = aParent.getChildIndex(aAfter);
				if (i==-1)
					return null;
				i++;
			}
			for (i;i<aParent.numChildren;i++) {
				var c: DisplayObject = aParent.getChildAt(i);
				if (c is aClass)
					return c;
			}
			return null;
		}
		
		public static function setStyleOnChildByClass(
			aParent: UIComponent,
			aChildClass: Class, 
			aStyle: String,
			aValue: Object
		): void {			
			var c:UIComponent = ComponentUtils.getComponentChildByClass(aParent,aChildClass) as UIComponent;
			if (!c)
				return;
			c.setStyle(aStyle,aValue);
		}
		
		public static function getLabelUITextField(aLabel: Label): UITextField {
			use namespace mx_internal;
			return aLabel.mx_internal::getTextField() as UITextField;
		}
	}
}

