/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

	import flash.events.Event
	import mx.events.DynamicEvent
	

	public class RoleSecurity {

		public static var userRolesFunction: Function

		// either provide a userRolesFunction to retrieve user roles, or set the userRoles property when they log in
		protected static var _userRoles: Array = []
		// central list of roles for current user
		public static function get userRoles(): Array {
			if (userRolesFunction != null) {
				return userRolesFunction()
			} else {
				return _userRoles
			}
		}
		public static function set userRoles(aStringArray: Array): void {
			_userRoles = aStringArray
		}

		public static function RolesArrayFromString(aRolesString: String): Array {
			return aRolesString ? aRolesString.split(',') : null
		}

		// test for whether we have the 1 or more roles required for some operation
		// aRoles is the roles we require - can be CSV string, or an array of strings of individual roles.
		public static function has_roles(aReqdRoles: Object, aUserRoles: Array = null): Boolean {
			var reqd_roles: Array = (aReqdRoles as Array) || RoleSecurity.RolesArrayFromString(aReqdRoles as String) 

			if (!aUserRoles)
				aUserRoles = userRoles;

			for (var r:String in reqd_roles) {
				for (var u:String in aUserRoles)
					if (r==u)
						return true;
			}
			return false
		}
	}	
}
