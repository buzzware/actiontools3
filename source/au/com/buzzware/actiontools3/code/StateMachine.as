package {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class StateMachine extends EventDispatcher {
		
		protected var _queue: Array = [];
		protected var _state: String;
		protected var stateHandler: Function;
		
		public function StateMachine(aParent: Object = null, aHandler: Function = null) {
			addEventListener(StateEvent.PROCESS,processQueueEvent)
			for each (var e:* in StateEvent.NORMAL_EVENTS) {
				addEventListener(e,receiveStateEvent);
			}
			stateHandler = aHandler;
		}
		
		// this gets called with every incoming state event
		public function receiveStateEvent(aStateEvent: StateEvent): void {
			_queue.push(aStateEvent)
			StateEvent.Process(this);
		}
		
		public function processQueueEvent(aEvent: Event): void {
			var event: StateEvent = _queue.shift() as StateEvent;
			if (event)
				processStateEvent(event);
		}
		
		public function processStateEvent(aEvent: StateEvent): void {
			switch (aEvent.type) {
				case StateEvent.CHANGE:
					if (aEvent.prerequisiteState && (aEvent.prerequisiteState != _state))
						return;
					var sc: StateControl = new StateMachineControl();
					sc.previousState = _state;
					sc.state = aEvent.state;
					sc.parameters = aEvent.parameters;
					stateHandler(sc);
					_state = aEvent.state;
					if (sc.nextState) {
						var ev: StateEvent = new StateEvent(StateEvent.CHANGE)
						ev.state = sc.nextState;
						_queue.unshift(ev)
						StateEvent.Process(this);
					}				
					break;
			}
		}
	}
}