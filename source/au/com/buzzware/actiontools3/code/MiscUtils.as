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
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.*;
	
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.rpc.events.ResultEvent; use namespace mx_internal;	// should be last import

	public class MiscUtils {
		public static function DumpPars(): void {
			trace("DumpPars")
 			for (var i:String in mx.core.Application.application.parameters) {
 				trace(i + ":" + mx.core.Application.application.parameters[i]);
 			}
		}

		public static function param(aName: String, aDefault: String = null): String {
			var result:String = mx.core.Application.application.parameters[aName];
			return result!=null ? result : aDefault;
		}

		public static function RandomString(aLength: int): String {
			var chars:String = "23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ";
			var result:String = '';
			var iChar:int;
			
			for (var i:int = 0; i<aLength; i++) {
				iChar = Math.round(Math.random()*chars.length)
				result += chars.charAt(iChar)
			}
			return result		
		}

		public static function HideComponent(aComponent: UIComponent): UIComponent {
			var result:UIComponent = null
			var parent:DisplayObjectContainer = aComponent.parent
			parent.removeChild(aComponent);
			aComponent.visible = false;
			//aComponent.data.last_parent = parent
			return result;
		}
	
		public static function UnhideComponent(aComponent: UIComponent): void {
			throw new Error("Not yet implemented");
			//aComponent.visible = true;
			//var parent:DisplayObjectContainer = DisplayObjectContainer(aComponent.data.last_parent)
			//parent.addChild(aComponent);
		}

		import mx.events.FlexEvent;
		import mx.core.UIComponent;
		import mx.controls.CheckBox;
		import mx.controls.TextInput;

		public static function ValueFromComponent(aComponent: Object): String {
			if (aComponent==null) {
				return null
			} else if (aComponent is mx.controls.CheckBox) {
				return mx.controls.CheckBox(aComponent).selected.toString();
			} else if (aComponent is mx.controls.TextInput) {
				return TextInput(aComponent).text;
			} else {
				throw new Error("Unknown component class");
			}
		}
		
		public static function AttributeFromComponent(aComponent: Object,aNamePattern: Object): String {
			var name:String = UIComponent(aComponent).name;
			var re:RegExp = new RegExp(aNamePattern);
			var result:String = re.exec(name)[1]
			return result;
		}

		public static function CommitField(aEvent: FlexEvent ,aXmlParent: Object,aNamePattern: Object): void {
			if (aEvent.target==null)
				return;
		
			var attribute:String = AttributeFromComponent(aEvent.target,aNamePattern)
			var value:String = ValueFromComponent(aEvent.target)
			XML(aXmlParent)[attribute] = value;
		}

		public static function NextDisplayObject(aDisplayObject: DisplayObject): DisplayObject {
			var iCurr:int = aDisplayObject.parent.getChildIndex(aDisplayObject)
			return (iCurr >= 0 && iCurr < aDisplayObject.parent.numChildren-1) ? aDisplayObject.parent.getChildAt(iCurr+1) : null;
		}

		/*
		Iterates through a tree of components, calling aHandler(component) on each.
		If aHandler returns true, it will descend to the components children, otherwise it wont.
		*/
		public static function IterateDisplayObjects(aDObject: DisplayObject, aHandler:Function): void {
			if (aDObject && aHandler(aDObject)) {
				var parent: Container = aDObject as Container;
				var curr: DisplayObject = parent ? parent.getChildAt(0) : null;
				var next: DisplayObject;
				while (curr) {
					next = NextDisplayObject(curr)
					IterateDisplayObjects(curr,aHandler);
					curr = next
				}
			}
		}

		public static function MoveContainerChildren(aSourceContainer: Container, aTargetContainer: Container): void {
			while(aSourceContainer.numChildren) {
				var child: DisplayObject = aSourceContainer.getChildAt(0)
				aSourceContainer.removeChild(child);
				aTargetContainer.addChild(child);
			}
		}

		public static function ClassName(aObject: Object): String {
			return shortName(flash.utils.getQualifiedClassName(aObject));
		}

		//getQualifiedSuperclassName(aObjectOrClass): String			
		//getQualifiedClassName(aObject): String
		//getDefinitionByName(aClassName:String): Class

		
		public static function getSuperclass(aClass: Class): Class {
			var nameSuper: String = getQualifiedSuperclassName(aClass);
			var classSuper: Class = getDefinitionByName(nameSuper) as Class;
			return classSuper;
		}

		public static function getClass(aObject: Object): Class {
			var name: String = getQualifiedClassName(aObject);
			var c: Class = getDefinitionByName(name) as Class;
			return c;
		}

		public static function getSuperclasses(aClass: Class): Array {
			var currClass: Class = aClass;
			var currName: String;
			var result: Array = [];
			
			result.push(currClass);
			while (currClass!=Object) {
				currClass = getSuperclass(currClass);
				result.push(currClass);
			}
			return result;			
		}

		public static function superclassesAsString(aClass: Class, aShort: Boolean = false): String {
			var sc: Array = getSuperclasses(aClass);
			if (sc.length==0)
				return null;
			sc = sc.map(
   			function(c:*, i:int, a:Array):String {
        	return aShort ? MiscUtils.shortName(getQualifiedClassName(c)) : getQualifiedClassName(c);
        }
      );			
			return sc.join(' > ');
		}
		
		public static function isSubclassOf(aChildClass:Class, aAncestorClass:Class):Boolean {
			return aAncestorClass.prototype.isPrototypeOf(aChildClass.prototype)
		}

		public static function isObjectOfClass(aObject: Object, aClass: Class): Boolean {
			return isSubclassOf(getClass(aObject),aClass)
		}
		
/* 		public static function ClassOfObject(aObject: Object): Class {
			
			var clazz : Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
		}
 */    	
   	public static function shortName(aName: String): String {
			// If there is a package, strip it off.
      var index:int = aName.indexOf("::");
			if (index != -1)
				aName = aName.substr(index + 2);
			var iLastDot:int = aName.lastIndexOf('.')
			if (iLastDot >= 0)
				aName = aName.substring(iLastDot+1);
			return aName;    		
    }

		public static function EventToString(aEvent: Event): String {
			var tgt:Object = aEvent.target;
			var result: String = (tgt!=null) ? shortName(tgt.toString()) : 'null';
			result += ' '+MiscUtils.ClassName(aEvent)+' on '
			tgt = aEvent.currentTarget
			if (tgt)
				result += tgt==aEvent.target ? 'self' : shortName(tgt.toString());
			else
				result += 'null';
			result += ' type='+aEvent.type
			result += ' bubbles='+aEvent.bubbles.toString()
			if (aEvent is ResultEvent) {
				if (ResultEvent(aEvent).result)
					result += "\n"+ResultEvent(aEvent).result.toString();
			}
			return result;
			//return MiscUtils.ClassName(aEvent)+': '+MiscUtils.ClassName(aEvent.currentTarget)+':"'+aEvent.currentTarget.id+'"'+' => '+aEvent.target;
		}

		public static function TraceEvent(aEvent: Event, aPrefix: String = null): void	{
			var result: String = ''
			if (aPrefix)
				result += aPrefix
			result += EventToString(aEvent)			
			trace(result)
		}
		
		// call attachEventTracer(someComponent) to have all events dispatched by that component traced
		public static function attachEventTracer(aTarget: IEventDispatcher=null): void {
			UIComponent.mx_internal::dispatchEventHook = function(aEvent:Event, aComponent:UIComponent): void {
				if (aTarget && (aComponent != aTarget))
					return;
				TraceEvent(aEvent);
			}
		}
		

		public static function ObjectToString(aObject: Object): String {
			return dump(aObject);
		}

		public static function TraceObject(aObject: Object): void	{
			trace(ObjectToString(aObject))
		}
		
		public static function DynamicPropertiesToString(aObject: Object, aNewLines: Boolean = true): String {
        	var result: String = ''
        	for (var p:String in aObject) {
        		result += p + ": " + aObject[p] + (aNewLines ? "\n" : '');
        	}
        	return result
		}
		
		public static function TraceDynamicProperties(aObject: Object, aNewLines: Boolean = true, aPrefix: String = null): void	{
			var result: String = ''
			if (aPrefix)
				result += aPrefix + (aNewLines ? '\n' : '') 
			result += DynamicPropertiesToString(aObject)
			trace(result)
		}
	
		public static function TraceIntValue(aValue: int, aName: String): int {
			trace(aName+': '+aValue)
			return aValue
		}

		// copies the dynamic properties from an object. If null, returns an empty object
		public static function clone_dynamic_properties(aSource: Object): Object {
			if (aSource==null)
				return {};
			var result: Object = {}
			for (var p:String in aSource)
				result[p] = aSource[p];
			return result
		}
		
		public static function cloneArray(aArray: Array): Array {
			return aArray.map(function(e:*, ...r):* { return e });			
		}

		// merges dynamic properties of aSource into aDest and returns the result
		// always returns at least an empty object
		// never returns aSource, at least a clone
		public static function merge_dynamic_properties(aDest: Object, aSource: Object, aOverwrite: Boolean = true): Object {
			if (aDest==null)
				return clone_dynamic_properties(aSource);
			if (aSource==null)
				return clone_dynamic_properties(aDest);

			var result: Object = clone_dynamic_properties(aDest);
			merge_dynamic_properties_inplace(result,aSource,aOverwrite);
			return result
		}

		public static function merge_dynamic_properties_inplace(aDest: Object, aSource: Object, aOverwrite: Boolean = true): Object {
			for (var p:String in aSource) {
				if (aOverwrite || (aDest[p]==undefined || aDest[p]==null))
					aDest[p] = aSource[p];
			}
			return aDest;		
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//  Debug
		//  *****
		//
		//  Copyright (C) 2008 Andrei Ionescu
		//  http://www.flexer.info/
		//  
		//  Permission is hereby granted, free of charge, to any person
		//  obtaining a copy of this software and associated documentation
		//  files (the "Software"), to deal in the Software without
		//  restriction, including without limitation the rights to use, misuse,
		//  copy, modify, merge, publish, distribute, love, hate, sublicense, 
		//  and/or sell copies of the Software, and to permit persons to whom the
		//  Software is furnished to do so, subject to no conditions whatsoever.
		// 
		//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
		//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
		//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
		//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
		//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
		//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
		//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
		//  OTHER DEALINGS IN THE SOFTWARE. DON'T SUE ME FOR SOMETHING DUMB
		//  YOU DO. 
		//
		//  PLEASE DO NOT DELETE THIS NOTICE.
		//
		////////////////////////////////////////////////////////////////////////////////
		
		// these two static variables will be emptied when 
		// the method recursiveDump is called with false 
		// as isInside parameter
		
		// static string that will contain the dump
		private static var _dumpString:String = ""; 
		// static string that will contain the indent
		private static var _dumpIndent:String = "";
		
		// internal function to get the number of children
		// from the object - getting only the first level
		internal static function getLength(o:Object):uint
		{
			var len:uint = 0;
			for (var item:* in o)
				len++;
			return len;
		}
				
		// internal recursive dump method
		// called by dump
		internal static function recursiveDump(o:Object,isInside:Boolean = true):String
		{
			// check if is not called by itself which means
			// is called from the first time and from here
			// it will be called recursivelly 
			if (!isInside)
			{
				// reinitializing the static dump strings
				_dumpString = "";
				_dumpIndent = "";
			}
			
			// type of the object
			var type:String = typeof(o);
			// another way to get the type more accuratelly
			// used for display
			var className:String = flash.utils.getQualifiedClassName(o);
			// starting from here we create the dump string
			_dumpString += _dumpIndent + className;
			if (className=='Date') {
				_dumpString += " = " + StringUtils.UniDateFormat(o as Date,'null') + "\n";	
			} else if (type == "string") {
				_dumpString += " (" + o.length + ") = \"" + o + "\"\n";
			} else if (type == "number") {
				_dumpString += " = " + o.toString() + "\n";
			} else if (type == "object") {
				_dumpString += " (" + getLength(o) + ")";
				_dumpString += " {\n";
				_dumpIndent += "    ";
				for (var i:Object in o) {
					_dumpString += _dumpIndent + "[" +i+ "] => "; //\n";
					// recursive call
					// by default isInside parameter is true
					// so the dump string will NOT be reinitialized
					recursiveDump(o[i]);
				}
				_dumpIndent = _dumpIndent.substring(0,_dumpIndent.length-4);
				_dumpString += _dumpIndent + "}\n";
			} else if (type == "date") {
				_dumpString += "(" + o + ")\n";
			}
			// returning the dump string
			return _dumpString;			
		}
	
		// our dump function
		// using ...rest parameter to have at least one
		// parameter and accept as many as needed
		public static function dump(o:Object,...rest):String
		{
			var tmpStr:String = "";
			var len:uint = rest.length;
			// call for the first parameter (object)
			tmpStr += recursiveDump(o,false);
			// if we have more than one parameter 
			// at method call we display them
			if (len > 0)
			{
				// looping through the ...rest array
				for (var i:uint = 0; i < len; i++)
				{
					// call internal recursive dump
					tmpStr += recursiveDump(rest[i],false);
				}
			}
			return tmpStr;
		}
	
		// find all dynamic objects in an array that have matching values for the contents of aAndCriteria
		public static function ObjectArrayFind(aArray: Array, aAndCriteria: Object): Array {
			return aArray.filter(
				function(item:*, index:int, array:Array): Boolean {
					// for all items in aAndCriteria, aItem has matching values
					for (var i:String in aAndCriteria) {
						if (aAndCriteria[i]!=item[i])
							return false;
					}
					return true;
				}
			);
		}
		
		// like ObjectArrayFind except only returns one object. Could be optimised to quit searching when one is found
		public static function ObjectArrayFindOne(aArray: Array, aAndCriteria: Object): Object {
			var results: Array = ObjectArrayFind(aArray,aAndCriteria);
			return results[0];
		}

		public static function ObjectArrayLookup(aArray: Array, aAndCriteria: Object, aProperty: String): Object {
			var results: Array = ObjectArrayFind(aArray,aAndCriteria);
			var item: Object = results[0];
			if (!item)
				return null;
			return item[aProperty];
		}
		
		public static function ArrayFindFirst(aArray: Array, aCriteria: Function): Object {
			for each (var i:Object in aArray) {
				if (aCriteria(i))
					return i;
			}
			return null;
		}
		
		public static function randomInt(aRange: int): int {
			return Math.floor(Math.random()*aRange)
		}
		
		public static function randomIntRange(aFrom: int,aTo: int): int {
			return aFrom+randomInt(aTo-aFrom+1)
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
		
		// adds listener and removes on first occurrence
		public static function addOnceListener(aTarget: IEventDispatcher, aEventType: String, aEventHandler: Function): void {
			aTarget.addEventListener(
				aEventType,
				function(aEvent: Event): void {
					aTarget.removeEventListener(aEventType,arguments.callee)
					aEventHandler(aEvent)
				}
			)
		}
		
		// aTime is in milliseconds
		// aHandler is like function(aEvent: TimerEvent): Boolean {} and is called until it returns true 
		public static function callUntil(aTime: Number,aHandler: Function): Timer {
			var result: Timer = new Timer(aTime);
			result.addEventListener(
				TimerEvent.TIMER,
				function(aEvent: TimerEvent): void {
					if (!result.running)
						return;
					var stop: Boolean = aHandler(aEvent)
					if (stop) {
						result.stop()
						result.removeEventListener(TimerEvent.TIMER,arguments.callee);
					}
				}
			)
			result.start()
			return result;
		}
	}
}
