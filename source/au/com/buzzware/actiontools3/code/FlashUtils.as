package au.com.buzzware.actiontools3.code {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class FlashUtils {
	
		public static var Events: Array = [
			Event.ACTIVATE,Event.ADDED,Event.ADDED_TO_STAGE,Event.CANCEL,Event.CHANGE,Event.CLEAR,Event.CLOSE,
			Event.CLOSING,Event.COMPLETE,Event.CONNECT,Event.COPY,Event.CUT,Event.DEACTIVATE,Event.DISPLAYING,
			Event.ENTER_FRAME,Event.EXIT_FRAME,Event.EXITING,Event.FRAME_CONSTRUCTED,Event.FULLSCREEN,
			Event.HTML_BOUNDS_CHANGE,Event.HTML_DOM_INITIALIZE,Event.HTML_RENDER,Event.INIT,Event.LOCATION_CHANGE,
			Event.MOUSE_LEAVE,Event.NETWORK_CHANGE,Event.OPEN,Event.PASTE,Event.REMOVED,Event.REMOVED_FROM_STAGE,
			Event.RENDER,Event.RESIZE,Event.SCROLL,Event.SELECT,Event.SELECT_ALL,
			Event.SOUND_COMPLETE,Event.TAB_CHILDREN_CHANGE,Event.TAB_ENABLED_CHANGE,Event.TAB_INDEX_CHANGE,
			Event.UNLOAD,Event.USER_IDLE,Event.USER_PRESENT
		]
		
		public static function attachFlashEventTracer(aTarget: IEventDispatcher): void {
			EventUtils.AddMultiListener(
				aTarget,
				Events,
				function(aEvent:Event): void {
					MiscUtils.TraceEvent(aEvent);
				}
			);
		}


		// This was developed for detecting loaded SWFs having finished playing
	  /*
	  Attaches handler of the form 
	  function(aMainTimeline: MovieClip): void {
	  
	  }
	  */
	  public static function attachHandlerForFinishedPlaying(
	  	aMainTimeline: MovieClip,
	  	aHandler: Function,
	  	aWaitForLastFrame: Boolean = true
	  ): Function {
	  	MiscUtils.TraceObject(aMainTimeline);
			//if (!aHandler)
			//	return;  	
	  	var lastFrame: int = -1;
	  	var lastEventFrame: int = -1;
	  	trace('addEventListener');
			var result: Function = function(aEvent: Event): void {
				if ((!aWaitForLastFrame || (aMainTimeline.currentFrame==aMainTimeline.totalFrames)) && (lastFrame != -1) && (aMainTimeline.currentFrame==lastFrame)) {
					if (lastEventFrame==-1 || lastEventFrame!=aMainTimeline.currentFrame) {
						lastEventFrame = aMainTimeline.currentFrame;
						trace('stopped');
						aHandler(aMainTimeline);			
					}
				} else {
					lastEventFrame = -1;
				}
				lastFrame = aMainTimeline.currentFrame;
			}
	  	aMainTimeline.addEventListener(Event.ENTER_FRAME,result); //useWeakReferences would make sense here, but breaks event (don't know why)
			return result
	  }
		

		public static function attachFrameRepeatHandler(aMovieClip: MovieClip,aFrameRepeatHandler: Function): Function {
			var lastFrame: int = -1;
			var hasMoved: Boolean = false
			var result: Function = function(aEvent: Event): void {
				if (lastFrame != -1) {
					if (hasMoved && (aMovieClip.currentFrame==lastFrame)) {
						aFrameRepeatHandler(aEvent);			
					}
					if (aMovieClip.currentFrame != lastFrame)
						hasMoved = true;					
				}
				lastFrame = aMovieClip.currentFrame
			}
			aMovieClip.addEventListener(Event.ENTER_FRAME,result)
			return result
		}
		
		public static function callLater(aTime: Number,aHandler: Function): Timer {
			var result: Timer = new Timer(aTime);
			result.addEventListener(
				TimerEvent.TIMER,
				function(aEvent: Event): void {
					result.stop()
					result.removeEventListener(TimerEvent.TIMER,arguments.callee);
					aHandler(aEvent)
				}
			)
			result.start()
			return result;
		}
	
		public static function stopAllMovieClips(aMovieClip: MovieClip): void {
			aMovieClip.stop();
			for (var i:int = 0; i < aMovieClip.numChildren; i++) {
				var dobj: DisplayObject = aMovieClip.getChildAt(i);
				if (dobj is MovieClip) 
					stopAllMovieClips(MovieClip(dobj));
			}
		}

		public static function playAllMovieClips(aMovieClip: MovieClip): void {
			aMovieClip.play();
			for (var i:int = 0; i < aMovieClip.numChildren; i++) {
				var dobj: DisplayObject = aMovieClip.getChildAt(i);
				if (dobj is MovieClip) 
					playAllMovieClips(MovieClip(dobj));
			}
		}
	}
}