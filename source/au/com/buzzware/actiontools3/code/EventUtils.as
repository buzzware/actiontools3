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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.*;
	
	import mx.events.ResizeEvent;

	public class EventUtils {
		public static function EventToString(aEvent: Event): String {
			var result: String;
			if (aEvent is ResizeEvent) {
				result = MiscUtils.EventToString(aEvent) +
					' OldW: '+ResizeEvent(aEvent).oldWidth +
					' OldH: '+ResizeEvent(aEvent).oldHeight +
					' W:'+(aEvent.target as DisplayObject).width +
					' H:'+(aEvent.target as DisplayObject).height +
					' cancelable: '+ResizeEvent(aEvent).cancelable
			} else {
				result = MiscUtils.EventToString(aEvent)
			}
			return result;
		}

		public static function TraceEvent(aEvent: Event): void {
			trace(EventToString(aEvent));
		}
		
		public static function AddMultiListener(
			aTarget: IEventDispatcher,
			aEvents: Array,
			aHandler: Function, 
			use_capture:Boolean = false, 
			priority:int = 0, 
			weakRef:Boolean = false
		): void {
			for each (var e:* in aEvents) {
				aTarget.addEventListener(e,aHandler,use_capture,priority,weakRef);
			}
		}
	}
}
