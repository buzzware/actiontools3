/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {
	
	public class DateUtils {
		
		public static const msMinute:int = 1000 * 60; 
		public static const msHour:int = 1000 * 60 * 60; 
		public static const msDay:int = 1000 * 60 * 60 * 24;	
		
		public static function addDays(aDate: Date,aDays: Number): Date {
			return new Date(aDate.getTime() + (aDays*msDay));
		}
		
		public static function addSeconds(aDate: Date,aSeconds: Number): Date {
			return new Date(aDate.getTime() + (aSeconds*1000));
		}
		
		public static function daysDifference(aDate1: Date, aDate2: Date): int {
			//var diff: Number = aDate2.time - aDate1.time
			return Math.floor((aDate2.time - aDate1.time)/msDay); 		
		}
		
		public static function today(): Date {
			var result:Date = new Date();
			return new Date(result.fullYear,result.month,result.date);
		}
		
		public static function equals(aDate1: Date, aDate2: Date): Boolean {
			if (aDate1==null && aDate2==null)
				return true;
			if (aDate1==null || aDate2==null)
				return false;
			return (aDate1.getTime() == aDate2.getTime());
		}
		
		// year must be 4 digit, month must be 0-11
		public static function daysInMonth(aYear: int, aMonth: int): int {
			var d:Date = new Date(aYear, (aMonth+1)%12, 0);
			return d.date;
		}

	}
}