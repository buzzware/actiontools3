package au.com.buzzware.actiontools3.design
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.Container;

	public class ExpandBox extends Container
	{
		public var headerLabel 			: String;
		public var expandHeight			: int;
		public var contractHeight		: int;
		public var labelWidth			: int;
		public var autoSizeChild		: Boolean = false;
		public var transitionDuration	: Number = 0.2;
		private var lbl 				: Label;
		private var summaryLbl			: Label;
		private var isExpanded 			: Boolean = false;
		private var contents			: Container = new Container();
		private var sprite				: Sprite;
		private var co					: int = 0xfb771f;
		private var triangleHeight		: Number = 12;
		
		
		public function get labelSummary() : String
		{
			return summaryLbl.text;
		}
		
		public function set labelSummary( s : String ) : void
		{
			summaryLbl.text = s;
		}
		
		
		public function ExpandBox()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.lbl = new Label();
			this.summaryLbl = new Label();
			this.sprite = new Sprite();
			
				
			lbl.setStyle( "textAlign", "right" );
			
			super.addChild( lbl );
			super.addChild( contents );
			super.addChild( summaryLbl );
			super.rawChildren.addChild( sprite );
			
			contents.visible = false;
			sprite.addEventListener( MouseEvent.ROLL_OVER, spriteOverHandler );
			sprite.addEventListener( MouseEvent.ROLL_OUT, spriteOutHandler );
			sprite.addEventListener( MouseEvent.CLICK, btnModClickHandler );
		}
		
		private function spriteOverHandler( event : MouseEvent ) : void
		{
			co = 0xb44e0a;
			this.invalidateDisplayList();
		}
		
		private function spriteOutHandler( event : MouseEvent ) : void
		{
			co = 0xfb771f;
			this.invalidateDisplayList();
		}
		
		private function btnModClickHandler( event : MouseEvent ) : void
		{
			if( ! isExpanded )
			{
				expand();
			}
			else
			{
				contract();
			}
		}
		
		public function expand() : void
		{
			contents.visible = true;
			summaryLbl.visible = false; 
			caurina.transitions.Tweener.addTween( this, { height : this.expandHeight, time : transitionDuration, transition : "linear" } );
			isExpanded = true;
		}
		
		public function contract() : void
		{
			caurina.transitions.Tweener.addTween( this, { height : this.contractHeight, time : transitionDuration, 
						transition : "linear",
						onComplete : function():void{contents.visible = false; summaryLbl.visible = true; } } );
			isExpanded = false;
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			lbl.move( 0, 0 );
			lbl.setActualSize( labelWidth - 30, 25 );
			
			summaryLbl.move( labelWidth + 20, 0 );
			summaryLbl.setActualSize( unscaledWidth - labelWidth - 20 , 25 );
			
			contents.move( labelWidth + 20 , 0 );
			contents.setActualSize( unscaledWidth - labelWidth - 20 , unscaledHeight );
			
			if( this.autoSizeChild && contents.getChildren().length > 0 )
				contents.getChildren()[0].setActualSize( unscaledWidth - labelWidth - 20 , unscaledHeight );
			
			lbl.text = this.headerLabel;
			
			sprite.height = 20;
			sprite.width = 20;
			sprite.x = labelWidth - 20;
			sprite.y = 0;
			
			drawTriangle( sprite.graphics );
			sprite.scaleX = sprite.scaleY = 1;
		}
		
		private function drawTriangle( g : Graphics ) : void
		{
			g.clear();
			if( ! isExpanded )
			{
				g.beginFill( co, 1 );
				g.lineStyle( 1, 0x000000, 1 );
				g.moveTo( 5, 2 + triangleHeight );
				g.lineTo( 5 + triangleHeight, 2 + triangleHeight/2 );
				g.lineTo( 5, 2 );
				g.lineTo( 5, 2 + triangleHeight );
				g.endFill();
			}
			else
			{
				g.beginFill( co, 1 );
				g.lineStyle( 1, 0x000000, 1 ); 
				g.moveTo( 2, 3 );
				g.lineTo( 2 + triangleHeight, 3 );
				g.lineTo( 2 + triangleHeight/2, 3 + triangleHeight );
				g.lineTo( 2, 3 );
				g.endFill();
			}
		}
		
		override public function addChild( child : DisplayObject) : DisplayObject
		{
			return contents.addChild( child );	
		}
		
		
	}
}