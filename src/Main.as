package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	
	/**
	 * 
	 */
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#333333")]
	public class Main extends Sprite
	{
		
		private var _starling:Starling;
		
		public function Main()
		{
			log("air= ", NativeApplication.nativeApplication.runtimeVersion, " | version= ", Capabilities.version, " | os= ", Capabilities.os );
			log("screenDPI= ", Capabilities.screenDPI );
			
			//
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			//
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		/**
		 * 
		 */
		private function loaderInfo_completeHandler(event:Event):void
		{
			
			this.stage.quality = StageQuality.LOW;
			
			//this.stage.frameRate = 60;
			//log("fps: ", this.stage.frameRate );
			var isAndroid:Boolean = Capabilities.version.split(" ")[0].toLowerCase() == "and";
			var isWin:Boolean = Capabilities.os.split(" ")[0].toLowerCase() == "windows";
				
			//only handle lostContext on android and windows, the price is doubled mem consumption
			Starling.handleLostContext = isAndroid || isWin;
			Starling.multitouchEnabled = true;
			
			//
			this._starling = new Starling( Test1, this.stage);
			this._starling.showStatsAt( "left", "bottom" );
			this._starling.enableErrorChecking = false;
			this._starling.antiAliasing = 1;
			this._starling.start();
			
			//
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			
			//
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
			
			//
//			initGesture();
		}
		
		/**
		 * 啟動 Gestouch library
		 */
		private function initGesture():void
		{
//			//Initialize native (default) input adapter. Needed for non-DisplayList usage.
//			Gestouch.inputAdapter ||= new NativeInputAdapter( stage ) as IInputAdapter;
//			
//			//Register instance of StarlingDisplayListAdapter to be used for objects of type starling.display.DisplayObject.
//			//What it does: helps to build hierarchy (chain of parents) for any Starling display object and
//			//acts as a adapter for gesture target to provide strong-typed access to methods like globalToLocal() and contains().
//			Gestouch.addDisplayListAdapter( starling.display.DisplayObject, new StarlingDisplayListAdapter() );
//			
//			// Initialize and register StarlingTouchHitTester.
//			
//			// What it does: finds appropriate target for the new touches (uses Starling Stage#hitTest() method)
//			// What does “-1” mean: priority for this hit-tester. Since Stage3D layer sits behind native DisplayList
//			// we give it lower priority in the sense of interactivity.
//			Gestouch.addTouchHitTester(new StarlingTouchHitTester( _starling ), -1 );
		}
		
		//
		private function stage_resizeHandler(event:Event):void
		{
			//
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;
			
			//
			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {log(error.getStackTrace())}
		}
		
		/**
		 * 
		 */
		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		/**
		 * 
		 */
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
		
	}
}