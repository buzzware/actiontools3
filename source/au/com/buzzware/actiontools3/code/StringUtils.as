/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

	import au.com.buzzware.actiontools3.code.DateFormatterPatched;

	public class StringUtils {
		public static function UniDateFormat(aDate: Date, aDefault: String = null): String {
			if (aDate==null) {
				return "";
			} else {
				var df:DateFormatterPatched = new DateFormatterPatched();
				df.formatString = "YYYY-MM-DD JJ:NN:SS"
				return df.format(aDate)			
			}
		}

		public static function FormatDate(aDate: Date, aFormat: String="DD MMM YYYY"): String {
			if (aDate==null)  
				return "";
			var df:DateFormatterPatched = new DateFormatterPatched();
			df.formatString = aFormat;
			return df.format(aDate);
		}
		
		// Format a number to specified number of decimal places
		// Written by Robert Penner in May 2001 - www.robertpenner.com
		// Optimized by Ben Glazer - ben@blinkonce.com - on June 8, 2001
		// Optimized by Robert Penner on June 15, 2001
		public static function formatDecimals(num, digits): String {
			// If no decimal places needed, just use built-in Math.round
			if (digits <= 0)
				return String(Math.round(num));
		
			//temporarily make number positive, for efficiency
			if (num < 0) {
				var isNegative: Boolean = true;
				num *= -1;
			}
		
			// Round the number to specified decimal places
			// e.g. 12.3456 to 3 digits (12.346) -> mult. by 1000, round, div. by 1000
			var tenToPower = Math.pow(10, digits);
			var cropped = String(Math.round(num * tenToPower));
		
			// Prepend zeros as appropriate for numbers between 0 and 1
			if (num < 1) {
				while (cropped.length < digits+1)
					cropped = "0" + cropped;
			}
			//restore negative sign if necessary
			if (isNegative) cropped = "-" + cropped; 
		
			// Insert decimal point in appropriate place (this has the same effect
			// as dividing by tenToPower, but preserves trailing zeros)
			var roundedNumStr = cropped.slice(0, -digits) + "." + cropped.slice(-digits);
			return roundedNumStr;
		};


		public static function ShortDateFormat(aDate: Date, aDefault: String = null): String {
			if (aDate==null) {  
				return "";
			} else {
				var df:DateFormatterPatched = new DateFormatterPatched();
				df.formatString = "D MMM YYYY"
				return df.format(aDate)			
			}
		}

		// returns index if string contains case-insensitive substring		
		public static function Contains(aStringToSearch: String, aSubString: String): int {
			if (aStringToSearch==null || aSubString==null)
				return -1;
			return aStringToSearch.toLowerCase().indexOf(aSubString.toLowerCase());	
		}
		
		public static function toInt(aString: String, aDefault: int = 0): int {
			var temp: Number = parseInt(aString)
			return isNaN(temp) ? aDefault : int(temp)
		}
		
		public static function toFloat(aString: String, aDefault: Number = NaN): Number {
			var temp: Number = parseFloat(aString)
			return isNaN(temp) ? aDefault : temp
		}

		public static function toBoolean(aString: String, aDefault: Boolean = false): Boolean {
			if (aString==null || aString=='')
				return aDefault;
			aString = trim(aString)
			if (aString.length > 5)
				return aDefault;
			switch (aString.toLowerCase()) {
				case 'true':
				case 'on':
				case '1':
				case 'yes':
					return true;
				case 'false':
				case 'off':
				case '0':
				case 'no':
					return false;
				default:
					return aDefault;
			}
		}
		
		public static function toDateNumeric(aString: String, aDefault: Date = null): Date {
			var yyyy: int = toInt(aString.substr(0,4),0);
			var mm: int = toInt(aString.substr(4,2),0);
			var dd: int = toInt(aString.substr(6,2),0);
			if (yyyy && mm && dd)
				return new Date(yyyy,mm-1,dd)
			else
				return aDefault;
		}

		
		/** from com.adobe.utils.StringUtil
		*	Removes whitespace from the front and the end of the specified
		*	string.
		* 
		*	@param input The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns A String with whitespace removed from the begining and end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function trim(input:String):String
		{
			return ltrim(rtrim(input));
		}

		/** from com.adobe.utils.StringUtil
		*	Removes whitespace from the front of the specified string.
		* 
		*	@param input The String whose beginning whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the begining	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/** from com.adobe.utils.StringUtil
		*	Removes whitespace from the end of the specified string.
		* 
		*	@param input The String whose ending whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}
				
		public static function replaceAll(aString: String,aFind: String,aReplace: String): String {
			var result: String = aString;
			while(result.indexOf(aFind)>-1)
				result = result.replace(aFind,aReplace);
			return result;
		}
		
		/*
		
		0123456
		dsfsdxx
		
		*/
		
		public static function chop(aString: String, aSuffix: String): String {
			var i: int = aString.lastIndexOf(aSuffix);
			return (i==aString.length-aSuffix.length) ? aString.substring(0,i) : aString;
		}

		public static function bite(aString: String, aPrefix: String): String {
			var i: int = aString.indexOf(aPrefix);
			return (i==0) ? aString.substring(aPrefix.length) : aString;
		}
		
		public static function firstMatch(aString: String, aPattern: RegExp): String {
			var html: Array = aString.match(aPattern);//  /<HTML.*<\/HTML>/ms);
			return html.length==0 ? null : html[0];
		}
		
		public static function splitCsvWithWhitespace(aString: String): Array {
			var result: Array = aString.split(/\s*,\s*/);
			if (result.length>0) {
				result[0] = ltrim(result[0]);
				result[result.length-1] = rtrim(result[result.length-1]);
			}
			return result;
		}
	}
}
