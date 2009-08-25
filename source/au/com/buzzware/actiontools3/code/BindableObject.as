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
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import mx.core.IUID;
    import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;use namespace flash_proxy;
    
    [Bindable("propertyChange")]  
    dynamic public class BindableObject extends Proxy implements IEventDispatcher, IUID
    {
        
        protected var strings:Object;
        protected var eventDispatcher:EventDispatcher;
        
        public function BindableObject(aDefault: Object = null)
        {
            strings = {};
            if (aDefault!=null) {
            	for (var p:String in aDefault)
								strings[p] = aDefault[p];
            }
            eventDispatcher = new EventDispatcher(this);
        }
        
        flash_proxy override function getProperty(name:*):*
        {
            return strings[name];
        }
        
        flash_proxy override function setProperty(name:*, value:*):void
        {
            var oldValue:* = strings[name];
            strings[name] = value;
            var kind:String = PropertyChangeEventKind.UPDATE;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, value, this));
        }
        
        public function get uid():String {
        	return strings.uid;
        }
    		public function set uid(value:String):void {
    			strings.uid = value;
    		}
        
        //public function toString(): String {
        //	return strings.toString();
        //}
                
	      protected var _item:Array; // array of object's properties
	     	override flash_proxy function nextNameIndex (index:int):int {
	         // initial call
	         if (index == 0) {
	             _item = new Array();
	             for (var x:* in strings) {
	                _item.push(x);
	             }
	         }
	     
	         if (index < _item.length) {
	             return index + 1;
	         } else {
	             return 0;
	         }
	     	}
	     	
	     	override flash_proxy function nextName(index:int):String {
	         return _item[index - 1];
	     	}
	 
        public function hasEventListener(type:String):Boolean
        {
            return eventDispatcher.hasEventListener(type);
        }
        
        public function willTrigger(type:String):Boolean
        {
            return eventDispatcher.willTrigger(type);
        }
        
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
        {
            eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
        {
            eventDispatcher.removeEventListener(type, listener, useCapture);
        }
        
        public function dispatchEvent(event:Event):Boolean
        {
            return eventDispatcher.dispatchEvent(event);
        }
    }
}