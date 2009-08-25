/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

/*

	This is a base class for application configuration objects. It is deisgned to meet the following requirements :
	+ quick simple access to configuration fields. <Item> tags that don'e have a matching property defined are still 
	accesible as dynamic properties of this object as Strings eg. config.UndefinedValueA 
	+ ability to formally define properties for faster access and to enable Flex Builder code completion to display 
	available values.
	+ ability to give default values for properties should they not appear or are not parseable in config file.
	+ ability to define type of properties, for speed of execution and consistency when using config values. 
	eg. its no good a integer property haveing a null value.
	+ a standard XML format is assumed (see below)
	+ configuration values are by design, intended to be read-only. Configuration is the set of values that enable an 
	application binary to be used in different environments or different circumstances without recompilation. It is 
	seperate from the application data structures, which may get initialized from the configuration. By making this 
	read-only, the application variables can be restored to their default state from the original configuration.

<?xml version="1.0" encoding="utf-8"?>
<Config>
	<SimpleItems>
		<Item Name="MyString">dfsddsfsdfsd</Item>
		<Item Name="MyInteger">1</Item>
		<Item Name="MyNumber">1.27</Item>
		<Item Name="MyBoolean">ON</Item>
		<Item Name="UndefinedValueA">Hello there</Item>
	</SimpleItems>
</Config>

	+ potentially another type of item could be defined - xmlItem. Giving a tag name, it would look below <Config>
	for a tag with that name.
 */

package au.com.buzzware.actiontools3.code {

	import flash.events.EventDispatcher;
	import au.com.buzzware.actiontools3.code.StringUtils;
	import au.com.buzzware.actiontools3.code.XmlUtils;
	
	public dynamic class BaseConfig extends EventDispatcher {

		protected var _valueCache: Object = new Object()
		protected var _source: XML;
		protected var _simpleItems: XML

		public function BaseConfig(aSource: XML) {
			super()
			_source = aSource
			var name: String
			var val: String
			_simpleItems = (aSource && XmlUtils.AsNode(aSource.SimpleItems))
			if (_simpleItems) {
				for each(var i: XML in _simpleItems.Item) {
					name = i.@Name
					val = i.text()
					if (this.hasOwnProperty(name)) {
						_valueCache[name] = val
					}
					/* not a dynamic object, so can't set here
					else {
						this[name] = val;
					}
					*/
				}
			}
		}

		public function stringItem(aName: String,aDefault: String = null,aEmptyAsDefault: Boolean = true): String {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value && !(value is String))
				throw new Error("Internal Error: property _valueCache type conflict");
			var result: String = String(value)
			return aEmptyAsDefault && result=='' ? aDefault : result;
		}

		protected function urlItem(aName: String,aDefault: String = null,aEmptyAsDefault: Boolean = true): String {
			return HttpUtils.RemoveSlash(stringItem(aName,aDefault,aEmptyAsDefault));
		}

		public function floatItem(aName: String,aDefault: Number = NaN): Number {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is Number)
				return Number(value);
			else if (value is String)
				return _valueCache[aName] = StringUtils.toFloat(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or Number");
		}

		public function intItem(aName: String,aDefault: int = 0): int {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is int)
				return int(value);
			else if (value is String)
				return _valueCache[aName] = StringUtils.toInt(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or int");
		}
		
		public function booleanItem(aName: String,aDefault: Boolean = false): Boolean {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is Boolean)
				return value;
			else if (value is String)
				return _valueCache[aName] = StringUtils.toBoolean(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or Boolean");
		}
		
		public function get root(): XML {
			return _source && XmlUtils.AsNode(_source as XML);	
		}
	}	
}
