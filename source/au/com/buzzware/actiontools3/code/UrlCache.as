package
{
	import au.com.buzzware.actiontools3.code.MiscUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.events.DynamicEvent;
	
	public class UrlCache extends EventDispatcher {
		
		protected var contents: Array = [];
		
		public function UrlCache()
		{
		}
		
		public function preload(
			aUrl: String,
			aResultHandler: Function = null,
			aFaultHandler: Function = null
		): void {
			var loader: URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			var request: URLRequest = new URLRequest(aUrl);
			loader.addEventListener(
				Event.COMPLETE,
				function(aEvent: Event): void {
					contents.push({
						url: aUrl,
						data: loader.data		
					})
					announceAvailable(aUrl,aResultHandler);
				}
			);
			loader.load(request);
		}
		
		protected function announceAvailable(aUrl: String,aResultHandler: Function=null): void {
			var event: DynamicEvent = new DynamicEvent(Event.COMPLETE,true,true);
			event.url = aUrl;
			if (aResultHandler)
				aResultHandler(event);
			dispatchEvent(event);			
		}
		
		public function request(
			aUrl: String,
			aResultHandler: Function = null,
			aFaultHandler: Function = null
		): void {
			if (getImmediate(aUrl)) {
				announceAvailable(aUrl,aResultHandler);
			} else {
				preload(aUrl,aResultHandler,aFaultHandler);
			}
		} 
		
		public function getImmediate(aUrl: String): Object {
			if (!aUrl)
				return null;
			var item: Object = MiscUtils.ArrayFindFirst(
				contents,
				function(i: Object): Boolean {
					return i.url==aUrl
				}
			);
			return item ? item.data : null;
		}
	}
}