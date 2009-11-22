package au.com.buzzware.actiontools3.code {

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class StateEvent extends Event {
		
		public static const CHANGE: String = 'change';
		public static const PROCESS: String = 'process';
		public static const NORMAL_EVENTS: Array = [CHANGE];
		
		public var state: String;
		public var parameters: Object;
		public var prerequisiteState: String;
				
		public function StateEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true) {
			super(type, bubbles, cancelable);
		}
		
		public static function Change(aTarget: IEventDispatcher,aState: String,aParameters: Object = null,aPrerequisiteState: String=null): void {
			var event: StateEvent = new StateEvent(CHANGE)
			event.state = aState;
			event.parameters = aParameters;
			event.prerequisiteState = aPrerequisiteState;
			aTarget.dispatchEvent(event);
		}

		public static function Process(aTarget: IEventDispatcher): void {
			aTarget.dispatchEvent(new StateEvent(PROCESS));
		}
	}
}