/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

	import flash.events.Event;
	import flash.events.IEventDispatcher;


	// These event types are normally dispatched by the application, to be handled by PageStack																
	public class PageTrigger extends Event {

		public static const BACK: String = 'backPage'
		public static const GOTO: String = 'gotoPage'

		public var page: String;
		public var options: Object = {};

		public function PageTrigger(aType: String, aOptions: Object = null, aBubbles: Boolean = true) {
			super(aType,aBubbles)
			if (aOptions)
				options = aOptions
		}

		override public function clone():Event {
			var result: PageTrigger = new PageTrigger(type,options,bubbles)
			result.page = page
			return result
		}		

		public static function Back(aTarget: IEventDispatcher, aOptions: Object = null, aBubbles: Boolean = true): void {
			//trace('PageTrigger.Back {'+MiscUtils.DynamicPropertiesToString(aOptions,false)+'}')
			aTarget.dispatchEvent(new PageTrigger(BACK,aOptions,aBubbles))
		}

		public static function Goto(aTarget: IEventDispatcher, aPage: String, aOptions: Object = null, aBubbles: Boolean = true): void {
			//trace('PageTrigger.Goto '+aPage+' {'+MiscUtils.DynamicPropertiesToString(aOptions,false)+'}')
			var pt: PageTrigger = new PageTrigger(GOTO,aOptions,aBubbles)
			pt.page = aPage
			aTarget.dispatchEvent(pt)
		}
	}	
}
