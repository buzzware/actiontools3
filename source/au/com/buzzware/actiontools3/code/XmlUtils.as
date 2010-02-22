/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

	//import mx.xpath.XPathAPI;	
	import memorphic.xpath.XPathQuery;
	
	import mx.utils.ObjectProxy;
		
	public class XmlUtils {

		public static function AsNode(aObject: Object): XML {
			if (aObject is XML)
				return XML(aObject);
			else if (aObject is XMLList) {
				var list: XMLList = XMLList(aObject)
				return list.length() > 0 ? list[0] : null;
			} else if (aObject is String)
				return XML(aObject);
			else
				return null;
		}
		
		public static function AsArray(aObject: Object): Array {
			if (aObject is Array) {
				return aObject as Array;
			} else if (aObject is XML) {
				return AsArray(XML(aObject).children())
			} else if (aObject is XMLList) {
				var list: XMLList = XMLList(aObject)
				var result: Array = []
				for (var i:int = 0; i<list.length(); i++) {
					result.push(list[i])
				}
				return result
			} else {
				return null
			}
		}
		
		public static function NodeText(aObject: Object): String {
			var node: XML = AsNode(aObject)
			return node ? node.text() : null;
		}
		
		// like as, returns null or valid XML node (excluding HTML etc loaded as XML nodes)
		public static function AsXmlNode(aObject: Object): XML {
			var x:XML = AsNode(aObject)
			return IsReallyXML(x) ? x : null;		
		}

		// returns given XML node if it is really XML, or null
		public static function IsReallyXML(aXML: XML): XML {
			return (aXML!=null && !IsHTML(aXML)) ? aXML : null;
		}

		public static function Attr(aXML: XML,aAttr: String,aDefault: String=null): String {
			if (!aXML)
				return aDefault;
			var atts: XMLList = aXML.attribute(aAttr)
			return (atts.length() > 0) ? atts[0].toString() : aDefault
		}

		// given a string or XML node, returns the root element.
		// HTML-like documents will return null		
		public static function GetRoot(aDocOrString: Object,aExpectedTag: String = null): XML {
			var root: XML = AsXmlNode(aDocOrString);
			if (root==null)
				return null;
			if (!(root is XML) || ((aExpectedTag!=null) && (root.name() != aExpectedTag))) {
				throw new Error("XML document corrupt or root tag not what was expected");
			}
			return root;
		}
		
		public static function ensureChild(aNode: XML, aName: String): XML {
			var child: XML = AsNode(aNode.child(aName))
			if (!child) {
				child = XML('<'+aName+ '/>')
				aNode.appendChild(child)
			}
			return child
		}
		
		public static function nextSibling(aNode: XML): XML {
			var parent: XML = aNode.parent();
			if (!parent)
				return null;
			var i:int = aNode.childIndex()+1;
			if ( (i==0) || (i>=parent.children().length()) )
				return null
			else
				return parent.children()[i]; 
		}
		
		// why is this so hard ?
		public static function removeNode(node:XML):void {
		    if (!node || !node.parent())
		    	return
		    delete node.parent().children()[node.childIndex()]
		}		
		
		public static function nextNested(aCurrTag: XML, aFilter: Function = null): XML {
			if (!aCurrTag)
				return null;
			var curr: XML = aCurrTag
			do {
				if (((aFilter==null) || aFilter(curr)) && (curr.children().length() > 0)) {
					curr = XmlUtils.AsNode(curr.children()[0])
				} else {
					var sibling: XML = XmlUtils.nextSibling(curr)
					curr = (sibling ? sibling : XmlUtils.nextSibling(curr.parent()))				
				}
			} while (curr && aFilter && !aFilter(curr));
			return curr;
		}


		// determines whether given root node is the root XML object of a HTML document loaded into XML objects. returns given node or null
		public static function IsHTML(aRoot: XML): XML {
			if (aRoot==null)
				return null;
			if (aRoot.parent()!=null)
				return null;
			if (StringUtils.Contains(aRoot.name(),'html')>=0)
				return aRoot;
			return null;
		}
		
		public static function addFromString(aParent: XML, aXml: String): XML {
			var result: XML = null;
			if (StringUtils.beginsWith(aXml,'<?xml ')) {
				// whole doc, single root 
				result = aParent.appendChild(XML(aXml));
			} else {	// fragment, potentially multiple roots
				aXml = '<?xml version="1.0" encoding="utf-8" standalone="yes" ?><root>'+aXml+'</root>';
				var xmlNew: XML = XML(aXml)
				for each (var c:XML in xmlNew.*) {
					aParent.appendChild(c);
					if (!result)
						result = AsNode(c);
				}
			}
			return result;
		}
		
		// Gets a node selected by aXPath or null. So long as aXPath is valid,
		// exceptions will not be thrown. If the node (or any part of the given path to it)
		// doesn't exit, null is returned. 
		// This function is meant to allow the developer to get a node from a string
		// without fear of null nodes.
		// Note that if aStartNode is null, null is returned.
		public static function SelectNode(aStartNode: XML, aXPath: String): XML {
			if (aStartNode==null)
				return null;

			var myQuery:XPathQuery = new XPathQuery(aXPath);
			var xnods:XMLList = myQuery.exec(aStartNode);
			if (xnods==null || xnods.length==0)
				return null;
			else
				return xnods[0];
		}
		
		public static function SelectNodes(aStartNode: XML, aXPath: String): XMLList {
			var myQuery:XPathQuery = new XPathQuery(aXPath);
			var xnods:XMLList = myQuery.exec(aStartNode);
			return xnods;
		}		

		// Returns the string value of a single node selected by aXPath from aStartNode, or the default value.
		// This function is meant to allow the developer to get a value from XML.
		// The 'string value' of the node is the content of a simple node, or the whole tree of a complex node 
		// eg. XPathValue(XML('<x>abc</x>'),'.') returns 'abc'
		// eg. XPathValue(XML('<x><y>def</y><z>ghi</z></x>'),'.') returns ''<x><y>def</y><z>ghi</z></x>'
		// without fear of null nodes.
		// see http://www.zrinity.com/developers/xml/xpath/
		public static function XPathValue(aStartNode: XML, aXPath: String, aDefault: String = null): String {
			var xnod:XML = SelectNode(aStartNode,aXPath);
			var result: String = xnod==null ? aDefault : xnod.toString();
			return result;
		}

		public static function ParseDate(aString:String,aDefault:Date = null): Date {
			var result:Date = null;
			try {
				result = parseW3CDTF(aString);
			}
			catch (e:Error) {
			}
			return result is Date ? result : aDefault;
		}

	/* From http://as3corelib.googlecode.com/svn/trunk/src/com/adobe/utils/DateUtil.as

		Note that ActionScript doesn't appear to store a timezone in its Date object, so if you parse a 
		date with a non-zero timezone, the resulting Date is held in UTC, but toString() will report 
		in the local timezone (regardless of the original timezone). However toW3CDTF() below will 
		report in UTC. It would be nice to add an optional timezone parameter to toW3CDTF().
	*/
	
	/**
		* Parses dates that conform to the W3C Date-time Format into Date objects.
		*
		* This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		*
		* @param str
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://www.w3.org/TR/NOTE-datetime
		*/		     
		public static function parseW3CDTF(str:String):Date
		{
            var finalDate:Date;
			try
			{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);
	
				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
            return finalDate;
		}

	  // this will report in UTC, unlike Date.toString() which reports in the local timezone.
		// An optional timezone parameter would be good here.
		/**
		* Returns a date string formatted according to W3CDTF.
		*
		* @param d
		* @param includeMilliseconds Determines whether to include the
		* milliseconds value (if any) in the formatted string.
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://www.w3.org/TR/NOTE-datetime
		*/		     
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean=false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}
		
// 		/**
// 		 * Converts a date into just after midnight.
// 		 */
// 		public static function makeMorning(d:Date):Date
// 		{
// 			var d:Date = new Date(d.time);
// 			d.hours = 0;
//             d.minutes = 0;
//             d.seconds = 0;
//             d.milliseconds = 0;
//             return d;
// 		}
//
// 		/**
// 		 * Converts a date into just befor midnight.
// 		 */
// 		public static function makeNight(d:Date):Date
// 		{
// 			var d:Date = new Date(d.time);
// 			d.hours = 23;
//             d.minutes = 59;
//             d.seconds = 59;
//             d.milliseconds = 999;
//             return d;
// 		}

		/**
		 * Sort of converts a date into UTC.
		 */
		public static function getUTCDate(d:Date):Date
		{
			var nd:Date = new Date();
			var offset:Number = d.getTimezoneOffset() * 60 * 1000; 
			nd.setTime(d.getTime() + offset);
			return nd;
		}
		
		/*
		This function takes a series of name/value pairs declared using dl,dt & dd HTML tags,
		given as an XML node tree. It returns an Object containing these pairs.
		*/
		public static function ObjectFromDefList(aDefList: Object): Object {
			trace("aDefList:"+aDefList.toString());
			aDefList = AsNode(aDefList);
			var result: Object = new Object();
			var key: String;
			var value: String;
			for each(var node: XML in aDefList.children()) {
				if (node.name()=='dt')
					key = node.text().toString()
				else if (node.name()=='dd') {
					result[key] = node.toString()
				}
			}
			return new ObjectProxy(result);
		}
		
		/*
		This function takes a HTML table given as an XML node tree.
		It returns an ArrayList containing an Object per table row.
		The Objects contain name/value pairs for each column.
		*/
		public static function ObjectListFromTable(aTable: XML): Array {
			var result: Array = new Array();
			var colNames: Array = new Array();
			for each(var node: XML in aTable.thead.tr.td) {
				colNames.push(node.text().toString())
			}
			// can now use colNames - list of column names
			
			for each(var row: XML in aTable.tbody.tr) {
				var objRow: Object = new Object();
				var tds: XMLList = row.td;
				for (var iCol:int=0; iCol<colNames.length; iCol++) {
					objRow[colNames[iCol]] = tds[iCol].text().toString();
				}
				result.push(new ObjectProxy(objRow));
			}
			return result;
		}
		
		public static function fixMissingAttributeQuotes(aSource: String): String {
			return aSource.replace(
				/( [a-z]+)=([^'"][^ >]*)/g , // '/
				"$1=\"$2\""
			)
		}		
		
		public static function upToRoot(aXML: XML): XML {
			var curr: XML = aXML;
			var result: XML = curr
			while (curr = curr.parent())
				result = curr;
			return result
		}
	}
}
