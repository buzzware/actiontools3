/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.URLUtil;

	public class HttpUtils {
		
		//returns url of this swf, including params
		public static function get AppUrl(): String {
			var result: String = mx.core.Application.application.url;
			var pos: int;
			if ((pos = result.indexOf('/[[DYNAMIC]]'))!=-1)
				result = result.substr(0,pos);
			result = StringUtils.replaceAll(result,'\\','/')
			return result;
		}

		public static function get ServerUrl(): String {	
			var result: String = AppUrl;
			var pattern:RegExp = /^[a-zA-z]+:\/\/[^\/]*/;
		    var reResult:Object = pattern.exec(result);
			return String(reResult && reResult[0]);
		}

		// combines a path with a root url, dealing with slashes in between. 
		// If the path is absolute, it overrides the root.
		public static function CombineUrl(aRoot: String,aPath: String): String {
			if (!aPath)
				return aRoot;
			if (!aRoot)
				return aPath;
			var result: String;
			if (IsRelative(aPath)) {
				result = RemoveSlash(aRoot)+PrependSlash(aPath);
			} else {
				result = aPath
			}
			return result;
		}

		// returns path containing application swf. if a URL is given, it is combined with the application path, overriding it if it is absolute
		// this is used to expand urls on the server relative to the application swf
		public static function AppPath(aUrl: String = null): String {
			return aUrl ? CombineUrl(UrlPath(AppUrl),aUrl) : UrlPath(AppUrl);
		}

		//reduces url to just file/path. no params. does not return a trailing slash
		public static function CleanUrl(aURL:String): String {
			var pos: int;
			var result:String = aURL;
			if ((pos = result.indexOf("?"))!=-1) {	// strip off parameters if supplied
				result = result.substr(0,pos)
			}
			return result
		}

		// returns the path of the url, and no slash
		public static function UrlPath(aURL:String): String {
			var pos: int;
			var result:String = CleanUrl(aURL);
			if ((pos = result.lastIndexOf('/'))!=-1)
				result = result.substr(0,pos)
			return result;
		}

		// determines whether the given url is relative or absolute. 
		// The protocol is assumed to be present on absolute urls ie www.google.com is deemed relative (it could be a folder or file)
		public static function IsRelative(aURL:String): Boolean {
			var t: String = URLUtil.getProtocol(aURL)
			return t == '';
		}

		// appends a slash if not already the last char
		public static function AppendSlash(aURL:String): String {
			if (!aURL)
				return aURL;
			var result: String = aURL
			if (result.charAt(result.length-1)!='/')
				result = result + '/';
			return result;
		}

		// prepends a slash if not already the first char
		public static function PrependSlash(aURL:String): String {
			if (!aURL)
				return aURL;
			var result: String = aURL
			if (result.charAt(0)!='/')
				result = '/' + result;
			return result;
		}

		// removes a slash from the end if present
		public static function RemoveSlash(aURL:String): String {
			if (!aURL)
				return aURL;
			var result: String = aURL
			if (result.charAt(result.length-1)=='/')
				result = result.substr(0,result.length-1);
			return result;
		}
		
		public static function GetResourceUrlBase(aURL:String): String {
			var pos: int;
			var result:String = aURL;
			if ((pos = result.indexOf("?"))!=-1) {	// strip off parameters if supplied
				result = result.substr(0,pos)
			}
			if (result.slice(-4).toLowerCase()=='.xml') {
				result = result.slice(0,-4)
			}
			if (result.slice(-1)=='/') {
				result = result.slice(0,-1)
			}
			return result
		}

		public static function AddUrlParameter(aURL:String,aParam:String,aValue:String): String {
			var result:String = aURL;
			if (result.indexOf("?")==-1) {
				result += "?"
			}
			var last_char:String = result.charAt(result.length)
			if (last_char != "?" && last_char != "&") {
				result += "&"
			}
			result += aParam+"="+aValue;
			return result;
		}

		// This class provides an RPC specific implementation of mx.rpc.IResponder. It allows the creator to associate data (a token) and methods that should be called when a request is completed. The result method specified must have the following signature: 
		//      public function myResultFunction(result:Object, token:Object = null):void;
		//   The fault method specified must have the following signature: 
		//      public function myFaultFunction(error:Object, token:Object = null):void;
		//   Any other signature will result in a runtime error. 
		public static function RailsRequest(   
			aUrl:String,
			method:String = null,
			request:Object = null,
			aResultHandler:Function = null, // signature: public function ResultFunction(aEvent:ResultEvent, aToken:AsyncToken):void
			aFaultHandler:Function = null		// signature: public function ResultFunction(aEvent:FaultEvent, aToken:AsyncToken):void
		) : AsyncToken {

			// Checkout the following from rails prototype.js source (possible answer to annoying message in Firefox):
			//
			// headers :
			//
			// 'X-Requested-With': 'XMLHttpRequest',
			// 'X-Prototype-Version': Prototype.Version,
			// 'Accept': 'text/javascript, text/html, application/xml, text/xml, */*'
			//
			// // Force "Connection: close" for older Mozilla browsers to work
			// // around a bug where XMLHttpRequest sends an incorrect
			// // Content-length header. See Mozilla Bugzilla #246651.
			//
			// if (this.transport.overrideMimeType &&
			// 		(navigator.userAgent.match(/Gecko\/(\d{4})/) || [0,2005])[1] < 2005)
			// 			headers['Connection'] = 'close';

			
		
			var service:HTTPService = new HTTPService();
			service.url = aUrl
			service.resultFormat = "e4x";
			if (method == null) {//default sensibly
				service.method = (request == null) ? "GET" : "POST";
			} else if ((method == "PUT") || (method == "DELETE")) {
				//PUT and DELETE don't work in Flash yet
				service.method = "POST";
				service.url = AddUrlParameter(service.url,"_method",method);
			} else {
				service.method = method;
			}
			if (method == "GET")
				service.url = AddUrlParameter(service.url,"nocache",MiscUtils.RandomString(8));
			if (request!=null) {
				service.request = request;
				service.contentType = "application/xml";
			}
			service.useProxy = false;
			service.requestTimeout = 7;
			//service.headers['Connection'] = 'close';
			if (aResultHandler!=null)
				service.addEventListener(ResultEvent.RESULT,aResultHandler);
			if (aFaultHandler!=null)
				service.addEventListener(FaultEvent.FAULT,aFaultHandler);
			var token:AsyncToken = service.send();
		/* 	if (aResultHandler!=null) {
				token.addResponder(new AsyncResponder(aResultHandler, aFaultHandler, token));
			}
		 */	
		 return token
		}		
		
//	public static function HTTPXMLRequest(
//		URL : String,
//		params : Object = null,
//		aResultHandler : Function = null,
//		aFaultHandler : Function = null
//	) : AsyncToken
//	{
//		var http : HTTPService = new HTTPService();
//
//		http.resultFormat = "e4x";
//		http.url = URL;
//
//		mx.managers.CursorManager.setBusyCursor();
//		http.addEventListener( ResultEvent.RESULT, function( event : ResultEvent ) : void { mx.managers .CursorManager.removeBusyCursor(); } );
//		http.addEventListener( FaultEvent.FAULT, function( event : FaultEvent ) : void { mx.managers .CursorManager.removeBusyCursor(); } );
//
//		if( aResultHandler != null) http.addEventListener( ResultEvent.RESULT, aResultHandler );
//		if( aFaultHandler != null) http.addEventListener( FaultEvent.FAULT, aFaultHandler );
//
//		return http.send( params );
//	}
		
		public static function HTTPRequest(  
			aURL : String, 
			aContent : Object = null,	//cant be an XML or dynamic object
			aMethod : String = 'GET',
			aContentType: String = "application/x-www-form-urlencoded",
			aResultFormat: String = 'text',
			aResultHandler : Function = null, 
			aFaultHandler : Function = null   
		) : AsyncToken {
			var http : HTTPService = new HTTPService();
			
			http.resultFormat =  aResultFormat;
			http.url = aURL;
			if (aMethod=='GET')
				aContentType = null;
			http.method = aMethod;
			if (aContentType)
				http.contentType = aContentType;
			
			mx.managers.CursorManager.setBusyCursor();
			http.addEventListener( 
				ResultEvent.RESULT, 
				function( event : ResultEvent ) : void { 
					mx.managers.CursorManager.removeBusyCursor(); 
				} 
			);
			http.addEventListener( 
				FaultEvent.FAULT, 
				function(event : FaultEvent) : void { 
					mx.managers.CursorManager.removeBusyCursor(); 
				}
			);
			
			if( aResultHandler != null) http.addEventListener( ResultEvent.RESULT, aResultHandler );
			if( aFaultHandler != null) http.addEventListener( FaultEvent.FAULT, aFaultHandler );
					
			return http.send( aContent );
		}
	
		// Web-service style get 
		public static function HTTPXMLRequest(  
			aURL : String, 
			aContent : Object = null,	// normally XML but could be dynamic object
			aResultHandler : Function = null, 
			aFaultHandler : Function = null   
		) : AsyncToken {
			return HTTPRequest(aURL,aContent,'GET',HTTPService.CONTENT_TYPE_XML,'e4x',aResultHandler,aFaultHandler);
		}
	
		// like submitting an HTML form
		public static function FormSubmit(
			aURL : String, 
			aContent : Object = null,					// normally dynamic object but could by XML
			aResultFormat: String = 'text',
			aResultHandler : Function = null, 
			aFaultHandler : Function = null
		): AsyncToken {
			return HTTPRequest(aURL,aContent,'POST',HTTPService.CONTENT_TYPE_FORM,aResultFormat,aResultHandler,aFaultHandler);
		}
		
		public static function GetUrl(aURL : String, aParams: Object,aResultHandler : Function = null,aFaultHandler : Function = null): AsyncToken {
			return HTTPRequest(aURL,aParams,'GET',HTTPService.CONTENT_TYPE_FORM,'text',aResultHandler,aFaultHandler);			
		}
		
		public static function htmlEscape( url : String ) : String
		{
			return escape( XML( new XMLNode( XMLNodeType.TEXT_NODE, url ) ).toXMLString() );
		}
	
	}
	
	
	
	
	
	
	
	
}
