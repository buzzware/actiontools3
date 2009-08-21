package au.com.buzzware.actiontools3.design {
	import au.com.buzzware.actiontools3.code.MiscUtils;
	
	import mx.containers.Form;
	import mx.events.FlexEvent;
	import flash.events.Event;

	public class XMLForm extends Form
	{
		public static const DataRootChangeEvent: String = "DataRootChangeEvent";

		protected var _DataRoot:XML = new XML();
		public function set DataRoot(aValue: XML):void {
			_DataRoot = aValue;
			dispatchEvent(new Event(DataRootChangeEvent));
		}
	
		[Bindable(event="DataRootChangeEvent")]
		public function get DataRoot():XML {
			return _DataRoot;
		}   

		public var FieldNamePattern: String = ".+?_(.+)"

		protected function CommitField(aEvent: FlexEvent): void {
			MiscUtils.CommitField(aEvent,DataRoot,FieldNamePattern)
			dispatchEvent(new Event(DataRootChangeEvent));	// help binding along for nested fields
		}
	}
}