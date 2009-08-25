/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code
{
	import mx.formatters.DateFormatter;
import mx.core.mx_internal;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.formatters.DateBase;
import mx.formatters.StringFormatter;
	
	public class DateFormatterPatched extends DateFormatter
	{
		
		private static const VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S";
		
		public function DateFormatterPatched()
		{
			super();
		}
		
			mx_internal static function extractTokenDate(date:Date,
											tokenInfo:Object):String
	{
		//initialize();

		//var result:String = "";
		
		var key:int = int(tokenInfo.end) - int(tokenInfo.begin);
		
		//var day:int;
		//var hours:int;
		
		switch (tokenInfo.token) {
			case "M":
			{
				// month in year
				var month:int = int(date.getMonth());
				if (key < 3)
				{
					return DateBase.mx_internal::extractTokenDate(date,tokenInfo)				
				}
				else if (key == 3)
				{
					return DateBase.monthNamesShort[month-1];
				}
				else
				{
					return DateBase.monthNamesLong[month-1];
				}
			}
		}
		return DateBase.mx_internal::extractTokenDate(date,tokenInfo)
	}
		
    override public function format(value:Object):String
    {       
        // Reset any previous errors.
        if (error)
            error = null;

        // If value is null, or empty String just return "" 
        // but treat it as an error for consistency.
        // Users will ignore it anyway.
        if (!value || value == "")
        {
            error = defaultInvalidValueError;
            return "";
        }

        // -- value --

        if (value is String)
        {
            value = DateFormatter.parseDateString(String(value));
            if (!value)
            {
                error = defaultInvalidValueError;
                return "";
            }
        }
        else if (!(value is Date))
        {
            error = defaultInvalidValueError;
            return "";
        }

        // -- format --

        var letter:String;
        var nTokens:int = 0;
        var tokens:String = "";
        
        var n:int = formatString.length;
        for (var i:int = 0; i < n; i++)
        {
            letter = formatString.charAt(i);
            if (VALID_PATTERN_CHARS.indexOf(letter) != -1 && letter != ",")
            {
                nTokens++;
                if (tokens.indexOf(letter) == -1)
                {
                    tokens += letter;
                }
                else
                {
                    if (letter != formatString.charAt(Math.max(i - 1, 0)))
                    {
                        error = defaultInvalidFormatError;
                        return "";
                    }
                } 
            }
        }

        if (nTokens < 1)
        {
            error = defaultInvalidFormatError;
            return "";
        }

        var dataFormatter:StringFormatter = new StringFormatter(
            formatString, VALID_PATTERN_CHARS,
            DateFormatterPatched.mx_internal::extractTokenDate);
            //DateBase.mx_internal::extractTokenDate);

        return dataFormatter.formatValue(value);
    }
	}
}