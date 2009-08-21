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
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.*;
	
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.rpc.events.ResultEvent;
	import mx.events.ResizeEvent;

	import au.com.buzzware.actiontools3.code.MiscUtils;

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
	}
}
