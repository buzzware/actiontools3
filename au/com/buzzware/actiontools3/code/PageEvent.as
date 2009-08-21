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

	// These event types are normally dispatched by PageStack, to be handled by the application page. 
	// RESET however, could be dispatched by an application page to reset itself
	public class PageEvent extends Event {

		public static const IN: String = 'pageIn'			// these constants must match the expected mxml property names declared in component eg. [Event(name="backPage", type='au.com.buzzware.actiontools3.code.PageEvent')]
		public static const OUT: String = 'pageOut'	
		public static const RESET: String = 'pageReset'	
		public var options: Object = {};

		public function PageEvent(aType: String, aOptions: Object = null, aBubbles: Boolean = false) {
			super(aType,aBubbles)
			if (aOptions)
				options = aOptions
		}

		override public function clone():Event {
			return new PageEvent(type,options,bubbles)
		}

		public static function Reset(aTarget: IEventDispatcher, aOptions: Object = null, aBubbles: Boolean = false): void {
			aTarget.dispatchEvent(new PageEvent(RESET,aOptions,aBubbles))
		}

		public static function In(aTarget: IEventDispatcher, aBubbles: Boolean = false): void {
			aTarget.dispatchEvent(new PageEvent(IN,null,aBubbles))
		}

		public static function Out(aTarget: IEventDispatcher, aBubbles: Boolean = false): void {
			aTarget.dispatchEvent(new PageEvent(OUT,null,aBubbles))
		}
	}	
}
