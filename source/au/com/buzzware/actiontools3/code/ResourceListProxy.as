/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools3.code {

  import mx.rpc.events.ResultEvent;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.Fault;
	import mx.collections.XMLListCollection;

 	import au.com.buzzware.actiontools3.code.MiscUtils;
 	import au.com.buzzware.actiontools3.code.HttpUtils;

	// Represents a collection of XML items accessed via a REST web service
	public class ResourceListProxy extends ResourceNodeProxy {

		protected var xcol:XMLListCollection = new XMLListCollection();

		public function ResourceListProxy(
			aName: String,
			aUrl: String = null,
			aRefreshResult:Function = null,
			aRefreshFault:Function = null,
			aSaveResult:Function = null,
			aSaveFault:Function = null
		) {
			super(aName,aUrl,aRefreshResult,aRefreshFault,aSaveResult,aSaveFault)
		}

		override public function Reset(aName: String = null): void {
			super.Reset(aName);
			xcol.source = xml.children();
		}			

		override protected function Receive(aResourceXml:Object):void {
			super.Receive(aResourceXml);
			if (XMLRoot is XML) {
				xcol.source = xml.children();
			} else {
				xcol.source = null;
			}
			xcol.refresh();
		}

		[Bindable]		
		public function get Collection(): XMLListCollection {
			return xcol;
		}
		protected function set Collection(aValue:XMLListCollection): void {
			xcol = aValue;
		}	

		// curl -X POST -d "<customer><name>john</name></customer>" http://localhost:3000/ws/customers
		public function CreateItem(
			aXML: XML,
			aResultHandler:Function = null, // signature: public function ResultFunction(aEvent:ResultEvent, aToken:AsyncToken):void
			aFaultHandler:Function = null		// signature: public function ResultFunction(aEvent:FaultEvent, aToken:AsyncToken):void
		): void {
			HttpUtils.RailsRequest(
				BaseURL,
				"POST",
				aXML,
				aResultHandler!=null ? aResultHandler : InternalSaveResult,
				aFaultHandler!=null ? aFaultHandler : InternalSaveFault
			);
		}
	}
}

