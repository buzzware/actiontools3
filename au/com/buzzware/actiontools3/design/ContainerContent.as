package au.com.buzzware.actiontools3.design {

	import mx.core.Container;

	// this class is used in MXML to provide components to be inserted into the container given by containerId	
	public class ContainerContent extends Container {
		[Inspectable]
		public var containerId: String;
	}
}
