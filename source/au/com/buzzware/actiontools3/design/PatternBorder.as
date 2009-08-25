package au.com.buzzware.actiontools3.design {



	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	import mx.core.Container;
	import mx.core.FlexLoader;
	import mx.core.IChildList;
	import mx.core.mx_internal;
	import mx.resources.ResourceManager;
	import mx.skins.Border;
	import mx.styles.ISimpleStyleClient;
	import mx.utils.StringUtil;

	use namespace mx_internal;

	/**
	 * 
	 * The following usage works :
	 * <visual:SimplePanel 
	 *	width="300" height="200" 
	 *	backgroundColor="red" 
	 *	borderColor="white"
	 *	borderStyle="solid"
	 *	borderThickness="16"
	 *	borderSkin="au.com.buzzware.actiontools3.design.PatternBorder"
	 *	backgroundImage="@Embed(source='assets/border_pattern.png')"
	 * />
	 * 
	 * Don't forget to import au.com.buzzware.actiontools3.design.PatternBorder ! 
 	 *
 	 * The following is from http://goverla.googlecode.com/svn/trunk/goverla/src/org/goverla/skins/PatternRectangularBorder.as 
 	 * PatternRectangularBorder is "copy-paste" style extended class from 
	 * Adobe's mx.skins.RectangularBorder. Because of crap design of RectangularBorder class we can't extend it 
	 * by OOP nature =(.
	 * So we can see here a lot of unknown stuff. I havn't a lot of time to clear this class.
	 */
	public class PatternBorder extends Border {

		loadResources();
	
		private static var resourceNotLoaded:String;
	
		private static function loadResources() : void {
			resourceNotLoaded = ResourceManager.getInstance().getString("skins", "notLoaded");
		}
		
		mx_internal var loader:Loader;
		
		mx_internal function get hasBackgroundImage():Boolean {
			return backgroundImage != null;
		}
	
		mx_internal function get backgroundImageRect():Rectangle {
			return _backgroundImageRect;
		}
	
		mx_internal function set backgroundImageRect(value:Rectangle):void
		{
			_backgroundImageRect = value;
	
			invalidateDisplayList();
		}
		
		public function PatternBorder()
		{
			super();
			
			addEventListener(Event.REMOVED, removedHandler);
		}
	
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			if (!parent)
				return;
				
			var newStyle:Object = getStyle("backgroundImage");
			if (newStyle != backgroundImageStyle)
			{
				backgroundImageStyle = newStyle;
				backgroundImage = null;
	
				var cls:Class;
	
				if (newStyle && newStyle as Class)
				{
					cls = Class(newStyle);
					initBackgroundImage(new cls());
				}
				else if (newStyle && newStyle is String)
				{
					try
					{
						cls = Class(getDefinitionByName(String(newStyle)));
					}
					catch(e:Error)
					{
						// ignore
					}
	
					if (cls)
					{
						var newStyleObj:DisplayObject = new cls();
						initBackgroundImage(newStyleObj);
					}
					else
					{
						loader = new FlexLoader();
						loader.contentLoaderInfo.addEventListener(
							Event.COMPLETE, completeEventHandler);
						loader.contentLoaderInfo.addEventListener(
							IOErrorEvent.IO_ERROR, errorEventHandler);
						loader.contentLoaderInfo.addEventListener(
							ErrorEvent.ERROR, errorEventHandler);
						var loaderContext:LoaderContext = new LoaderContext();
						loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
						loader.load(new URLRequest(String(newStyle)), loaderContext);		
					}
				}
				else if (newStyle) 
				{
					throw new Error(StringUtil.substitute(resourceNotLoaded, newStyle));
				}
			} else {
				if (backgroundImage) 
				{
					initBackgroundImage(backgroundImage);
				}
			}
		}
	
		private function initBackgroundImage(image:DisplayObject):void
		{
			backgroundImage = image;
			
			if (image is Loader)
			{
				backgroundImageWidth = Loader(image).contentLoaderInfo.width;
				backgroundImageHeight = Loader(image).contentLoaderInfo.height;
			}
			else
			{
				backgroundImageWidth = backgroundImage.width;
				backgroundImageHeight = backgroundImage.height;
				
				if (image is ISimpleStyleClient)
				{
					ISimpleStyleClient(image).styleName = styleName;
				}
			}
 			
	    var cornerRadius:Number = getStyle("cornerRadius") || 0;
	    var backgroundColor:int = getStyle("backgroundColor");
	    var backgroundAlpha:Number = getStyle("backgroundAlpha");
	    var borderThickness: Number = getStyle("borderThickness") || 0;
	    var borderLeft: Number = getStyle("borderLeft") || borderThickness;
	    var borderTop: Number = getStyle("borderTop") || borderThickness;
	    var borderRight: Number = getStyle("borderRight") || borderThickness;
	    var borderBottom: Number = getStyle("borderBottom") || borderThickness;
	
		 	var backgroundImageData : BitmapData = new BitmapData(backgroundImageWidth, backgroundImageHeight);
			backgroundImageData.draw(backgroundImage);
	
	    graphics.clear();
	    if (this.hasBackgroundImage) {	      
				graphics.beginBitmapFill(backgroundImageData);
				var backgroundRepeat : String = getStyle("backgroundRepeat") as String;
				switch (backgroundRepeat) {
					case null :
					case "repeat" :
						graphics.drawRect(0, 0, this.width, this.height);
						break;
						
					case "repeat-y" : 
						graphics.drawRect(0, 0, backgroundImageWidth, this.height);
						break;
						
					case "repeat-x" : 
						graphics.drawRect(0, 0, this.width, backgroundImageHeight);
						break;
				}	
	    }
	    // Background
	    drawRoundRect(
	    	borderLeft, borderTop, this.width-borderLeft-borderRight, this.height-borderTop-borderBottom, 
	    	cornerRadius, 
	    	backgroundColor, backgroundAlpha
	    );
	    /*
	    drawRoundRect(
	    	0, 0, this.width, this.height, 
	    	cornerRadius, 
	    	backgroundColor, backgroundAlpha,null,null,null,
	    	{x: borderLeft, y: borderTop, w: this.width-borderLeft-borderRight, h: this.height-borderTop-borderBottom, r: cornerRadius }
	    );
	    */		
		}
	
		private function errorEventHandler(event : Event) : void 
		{
			// Ignore errors that occure during background image loading.	
		}
		
		private function completeEventHandler(event : Event) : void 
		{
			if (!parent)
				return;
				
			var target:DisplayObject = DisplayObject(LoaderInfo(event.target).loader);
			initBackgroundImage(target);
			dispatchEvent(event.clone());
		}
		
		private function removedHandler(event : Event) : void
		{
			var childrenList:IChildList = parent is Container ?
											 Container(parent).rawChildren :
											 IChildList(parent);
	
			if (backgroundImage)
			{
				childrenList.removeChild(backgroundImage);
				backgroundImage = null;
			}
			
			if (backgroundMask)
			{
				childrenList.removeChild(backgroundMask);
				backgroundMask = null;
			}
		}
		
		private var backgroundImageStyle:Object
							
		private var	backgroundImageWidth:Number;
	
		private var	backgroundImageHeight:Number;
					
		private var backgroundImage:DisplayObject;
		
		private var _backgroundImageRect:Rectangle;
		
		private var backgroundMask:Shape;
		
	}

}