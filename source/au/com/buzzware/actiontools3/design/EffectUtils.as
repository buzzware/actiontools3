package au.com.buzzware.actiontools3.design {

	public class EffectUtils {
		import mx.events.EffectEvent;
		import mx.containers.ViewStack;
		import mx.controls.Image;
		import mx.controls.VScrollBar;
		import mx.core.UIComponent;
		import mx.effects.Move;
		import mx.events.EffectEvent;
		import flash.display.BitmapData
		import flash.display.Bitmap
		import flash.geom.Rectangle;
		//import mx.events.ResizeEvent;
		import mx.managers.CursorManager;
		//import caurina.transitions.Tweener;

		import au.com.buzzware.actiontools3.code.ComponentUtils;
		import au.com.buzzware.actiontools3.code.GraphicsUtils;
		//import au.com.buzzware.actiontools3.code.HttpUtils;
		import au.com.buzzware.actiontools3.design.EffectUtils;

		public static function ViewStackSlide( 
			aViewStack: ViewStack,
			aPageIndex: int,
			aLeftDirection: Boolean = true,
			aEndFunction: Function = null
		):void {
			aViewStack.selectedChild.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START))
			// CaptureStageBitmapData and show on Image
			if (aViewStack.selectedChild.verticalScrollBar)
				aViewStack.selectedChild.verticalScrollBar.visible = false
			var bmdStageBefore: BitmapData = GraphicsUtils.CaptureStageBitmapData()
			if (aViewStack.selectedChild.verticalScrollBar)
				aViewStack.selectedChild.verticalScrollBar.visible = true
			var imgFrom: Image = new Image();
			imgFrom.source = new Bitmap( bmdStageBefore );
			aViewStack.parentApplication.addChild(imgFrom)
			imgFrom.x = 0;
			ComponentUtils.BringToFront(imgFrom);

			aViewStack.selectedIndex = aPageIndex
			aViewStack.validateNow()
			
			try
			{
				trace( "trying to draw" );
			var bmdViewStackAfter: BitmapData = new BitmapData(aViewStack.width,aViewStack.height,false)
			//trace('bmdViewStackAfter.draw')
			bmdViewStackAfter.draw(aViewStack,null,null,flash.display.BlendMode.NORMAL)
			aViewStack.visible = false;
			var bmdStageAfter:BitmapData = GraphicsUtils.CaptureStageBitmapData()
			aViewStack.visible = true;
			var rectVSOnStage: Rectangle = aViewStack.getRect(aViewStack.stage)
			bmdStageAfter.draw(bmdViewStackAfter,null,null,flash.display.BlendMode.NORMAL,rectVSOnStage);
			}
			catch( e : Error )
			{
				trace( "ERROR = " + e.message );
			}
			
			var imgTo: Image = new Image();
			imgTo.source = new Bitmap( bmdStageAfter );
			aViewStack.parentApplication.addChild(imgTo)
			imgTo.x = aLeftDirection ? bmdStageAfter.width : -bmdStageAfter.width;
			ComponentUtils.BringToFront(imgTo);
			aViewStack.visible = false;
			aViewStack.parentApplication.validateNow()
				
			var move:Move = new Move();
			move.xBy = aLeftDirection ? -bmdStageAfter.width : bmdStageAfter.width;
			move.targets.push( imgFrom, imgTo );
			
			//trace('Before: imgFrom:'+imgFrom.x+' imgTo:'+imgTo.x);
			
			move.addEventListener( 
				EffectEvent.EFFECT_END, 
				function( event:EffectEvent ):void {
					if (event.effectInstance.target!=move.targets[0]) //move.targets.length-1
						return;
					//trace('After: imgFrom:'+imgFrom.x+' imgTo:'+imgTo.x);
					aViewStack.visible = true;
					aViewStack.parentApplication.removeChild(imgTo)		
					aViewStack.parentApplication.removeChild(imgFrom)		
					aViewStack.selectedChild.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END))
					if (aEndFunction!=null)
						aEndFunction()
				}
			);
					
			move.duration = 1500;
			move.play();
		}
	}
}
