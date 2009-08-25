/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

	import mx.controls.Alert;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import flash.utils.describeType;

	import au.com.buzzware.actiontools3.code.XmlUtils;
	import au.com.buzzware.actiontools3.code.StringUtils;
	import au.com.buzzware.actiontools3.code.MiscUtils;

	// Represents a REST node
	public class ResourceNodeProxy {
	
		protected var name:String;
		protected var _URL:String;
		protected var xml:XML = new XML();
	
		public function ResourceNodeProxy(
			aName: String,
			aUrl: String = null,
			aRefreshResult:Function = null,
			aRefreshFault:Function = null,
			aSaveResult:Function = null,
			aSaveFault:Function = null
		) {
			Reset(aName);
			URL = aUrl;
			_refreshResult = aRefreshResult
			_refreshFault = aRefreshFault
			_saveResult = aSaveResult
			_saveFault = aSaveFault
		}

		public function Reset(aName: String = null): void {
			if (aName!=null)
				name = aName;
			_URL = null;
			xml = new XML();
		}

		protected function Receive(aResourceXml:Object):void {
			XMLRoot = XmlUtils.AsXmlNode(aResourceXml);
			if (XMLRoot && MiscUtils.param('debug_mods')=="true")
				trace("ResourceNodeProxy.Receive(): "+XMLRoot.name())
		}

		public var alertRefreshResult:Boolean = false;
		public var alertRefreshFault:Boolean = true;
		public var alertSaveResult:Boolean = true;
		public var alertSaveFault:Boolean = true;

		public function get Name(): String {
			return name;
		}
		public function set Name(aValue:String): void {
			if (aValue==name)
				return;
			Reset(aValue);
		}

		public function get BaseURL(): String {
			return _URL ? HttpUtils.GetResourceUrlBase(_URL) : null;
		}

		[Bindable]		
		public function get URL(): String {
			return _URL;
		}
		
		public function set URL(aValue:String): void {
			if (aValue==_URL)
				return;
			Reset(name);
			_URL = aValue;
		}

		[Bindable]		
		public function get XMLRoot(): XML {
			return xml;
		}
		protected function set XMLRoot(aValue:XML): void {
			xml = aValue;
		}

		// the signature of the following should be : function (aEvent:ResultEvent):void or function (aEvent:FaultEvent):void
		protected var _refreshResult: Function = null;
		public function get refreshResult(): Function 										{ return _refreshResult }
		public function set refreshResult(aHandler:Function): void 	{ _refreshResult = aHandler }
		protected var _refreshFault: Function = null;
		public function get refreshFault(): Function 										{ return _refreshFault }
		public function set refreshFault(aHandler:Function): void 		{ _refreshFault = aHandler }
		protected var _saveResult: Function = null;
		public function get saveResult(): Function 											{ return _saveResult }
		public function set saveResult(aHandler:Function): void 			{ _saveResult = aHandler }
		protected var _saveFault: Function = null;
		public function get saveFault(): Function 												{ return _saveFault }
		public function set saveFault(aHandler:Function): void 			{ _saveFault = aHandler }

		// for setting XML content before saving
		protected var _beforeSave: Function = null;
		public function get beforeSave(): Function 											{ return _beforeSave }
		public function set beforeSave(aHandler:Function): void 			{ _beforeSave = aHandler }

		public function Refresh(aUrl:String = null): void {
			if (aUrl)
				URL = aUrl;
			HttpUtils.RailsRequest(
				URL,
				"GET",
				null,
				function (aEvent:ResultEvent):void {
					Receive(aEvent.result);
					if (_refreshResult!=null)
						_refreshResult(aEvent);
					if (alertRefreshResult)
						Alert.show("Refreshed "+name+" succesfully");
				},
				function (aEvent:FaultEvent):void {
					Receive(null);
					if (_refreshFault!=null)
						_refreshFault(aEvent);
					if (alertRefreshFault)
						Alert.show("Failed Refreshing "+name);
				}
			);
		}

		// creates a FaultEvent from a ResultEvent. This is useful when a result handler is called by Flex, but the result is actually an error.
		// This method makes it easy to report such an event through a standard type FaultEvent handler.
		protected function SynthesizeRestFault(aEvent: ResultEvent): FaultEvent {
			var result:FaultEvent = null;
			var details:String = aEvent.toString();
			var fault:Fault = new Fault("SERVER_VALIDATION_ERROR","There were validation errors on the server", details);
			fault.rootCause = aEvent.result;
			result = new FaultEvent(aEvent.type,aEvent.bubbles,aEvent.cancelable,fault,aEvent.token,aEvent.message);
			return result
		}

		// Handle faults, whether due to transport or errors on server
		protected function InternalSaveFault(aEvent: FaultEvent): void {
			if (_saveFault!=null)
				_saveFault(aEvent);
			if (alertSaveFault) {
				var xml_errors:XML = (aEvent.fault.rootCause is XML) ? XML(aEvent.fault.rootCause) : null
				if (xml_errors!=null && xml_errors.name()=='errors' && xml_errors.@kind=='validation') {	// Rails validation errors
					var strErrors:String = xml_errors.@action+" failed for "+name+":\n\n";
					for each (var aMsg:XML in xml_errors.error) {
						strErrors += aMsg + "\n";
					}
					Alert.show(strErrors);
				} else {
					Alert.show("Failed Saving "+name);
				}
			}
		}

		protected function InternalSaveResult(aEvent: ResultEvent): void {
			if ((aEvent.result is XML) && (aEvent.result.name()=='errors')) {						// succesful transport but error(s) on server (probably validation)
				InternalSaveFault(SynthesizeRestFault(aEvent));
			} else {																	// fully succesful
				if (_saveResult!=null)
					_saveResult(aEvent);
				if (alertSaveResult)
					Alert.show("Saved "+name+" succesfully");
			}
		}

		public function Save(): void {
			if (_beforeSave!=null)
				_beforeSave(this);
			HttpUtils.RailsRequest(
				URL,
				"PUT",
				xml,
				InternalSaveResult,
				InternalSaveFault																// transport failure
			);
		}
	}
}

