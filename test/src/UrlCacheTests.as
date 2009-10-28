package {
	
	import flash.events.Event;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	
	public class UrlCacheTests {

		[Test(async)]
		public function testBasicInsertRetrieve(): void {
			var cache: UrlCache = new UrlCache();  
			Async.handleEvent(
				this,
				cache,
				Event.COMPLETE,
				function(aEvent: Event, aData: Object): void {
					assertThat( cache.getImmediate('one.swf') != null );
				}
			);
			cache.request('one.swf');
		}
	}
}