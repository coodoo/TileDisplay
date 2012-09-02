package
{
	import com.pubulous.poc.TileDisplay;
	
	import flash.ui.Mouse;
	
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.themes.AzureTheme;
	import org.josht.starling.foxhole.themes.IFoxholeTheme;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.events.Event;

	public class Test1 extends Sprite
	{
		
		[Embed(source="run.jpeg")]
		private var img:Class;
		
		/**
		 * 
		 */
		public function Test1()
		{
			super();			
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * theme for foxhole controls
		 */
		private var _theme:IFoxholeTheme;
		
		/**
		 *
		 */
		private function onAddedToStage( evt:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			const isDesktop:Boolean = Mouse.supportsCursor;
			this._theme = new AzureTheme( this.stage, !isDesktop );
			
			this.stage.color = 0xFFFFFF;
			
			this.stage.addEventListener( Event.RESIZE, resizeHanlder );
			
			createChildren();
		}
		
		
		private var sizeChanged:Boolean = false;
		private function resizeHanlder( e:Event ):void
		{
			//mark dirty to trigger next round of draw
			sizeChanged = true;
		}
		
		/**
		 * 
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			super.render( support, alpha );
			
			if( sizeChanged )
			{
				sizeChanged = false;
				//
				tileDisplay.width =  Starling.current.nativeStage.fullScreenWidth;
				tileDisplay.height = Starling.current.nativeStage.fullScreenHeight;
				tileDisplay.x = 0;
				tileDisplay.y = 0;
			}
		}
		
		private var tileDisplay:TileDisplay;

		/**
		 * 
		 */
		private function createChildren():void
		{			
			tileDisplay = new TileDisplay();
			addChild( tileDisplay );
			
			//kick start by feeding in an image
			tileDisplay.source = new img();

			//
			sizeChanged = true;
		}
		
		
		
//		//這裏決定抓取的 bd 大小，0.5 就是原圖的 1/2，這樣體積就省很多了
//		//重點在：將來要靠 Image 去去 scale-up 這個 bd
//		private var captureScale:Number = 0.1;
//		
//		private function foo():void
//		{
////			return;
//			
//			trace("fooo");
//			
//			var captureBD:BitmapData = new BitmapData(128*captureScale, 128*captureScale, true, 0 );
//			
//			//
//			var matrix:Matrix = new Matrix();
//				
//			//定位到我需要的格子
//			matrix.translate( -1024, -1200 );
//			
//			//jxtest: 縮小 bd 為 1/2，以節省體積
//			matrix.scale( captureScale, captureScale );
//			
//			//開始擷圖
////			captureBD.draw( tileManager.source, matrix );
//			
//			var flashBitmap:Bitmap = new Bitmap( captureBD );
//			Starling.current.nativeStage.addChild( flashBitmap );
//			flashBitmap.x = 300;
//			flashBitmap.y = 300;
//			
//			//----------------------------------------------------------------
//
//			//然後上傳剛擷取的小 bd
//			flash.display3D.textures.Texture(displayTexture.base).uploadFromBitmapData( captureBD );
//			
//			trace("before w: ", ConcreteTexture(displayTexture).width );
//			
//			//因為 Image 元件會進來問 texture.width，而 width 是參考 mScale 換算出縮放後的值，因此只要能設定新的 scale 值進來就可達到不同縮放效果
//			//這樣比改變 image.scaleX 好
//			ConcreteTexture(displayTexture).scale = captureScale;
//			
//			trace("scale = ", ConcreteTexture(displayTexture).scale, " >w: ", ConcreteTexture(displayTexture).width );
//			
//			//餵入 Image 顯示出來
//			//原理是：catpure bd 可以是各種縮小的版本，image 元件顯示時，會再放大自已，讓它永遠填滿 128*128 這個範圍
//			var sBitmap:Image = new Image( displayTexture );
//			addChild( sBitmap );
//			
//		}
//		
//		//debug
//		private var displayTexture:starling.textures.Texture;
//		
//		
//		//debug
//		private function prepareTexture():void
//		{
//			//
//			var textureScale:Number =1;
//			
//			//這個 bd 建立時就要框出正確的 texture width/height，如果太小，將來 captureBD 抓大圖，塞進去會被 crop
//			var textureBD:BitmapData = new BitmapData(128, 128, false, 0 );
//			
//			//建立 texture 時用 full size bd
//			//這個 scale 是將來小版 captureBD 要被放大的倍數，這樣就能抓小的 bd 但看到大圖
//			displayTexture = starling.textures.Texture.fromBitmapData( textureBD, false, false, 1 );	//這裏永遠是 1
//		}
		
	}
}