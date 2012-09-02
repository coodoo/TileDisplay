package com.pubulous.poc
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class TileRenderer extends DefaultListItemRenderer
	{
		public function TileRenderer()
		{
			
			super();
			
			//
			this.addEventListener( Event.REMOVED_FROM_STAGE, removeHandler );
			
//			trace("\nrenderer created" );
		}
		
		
		private function removeHandler( evt:Event ):void
		{
			//
			if( image )
				image.dispose();
		}
		
		/**
		 * each renderer has a built-in texture which will be reused
		 */
		private function createTexture():void
		{
			//這個 bd 建立時就要框出正確的 texture width/height，如果太小，將來 captureBD 抓大圖，塞進去會被 crop
			//這個 texture 的 scale 永遠是 1
			var bd:BitmapData = new BitmapData(width, height, false, 0);
			texture = starling.textures.Texture.fromBitmapData( bd, false, false, 1 );
			
			//once the texture is created, dispose the dummy bd
			//TODO: profile to see if this triggers gc() which may cause stuttering
			bd.dispose();
			bd = null;
		}
		
		public var tileManager:TileManager;
		
		private var texture:starling.textures.Texture;
		
		private var image:Image;
		
		private var quad:Quad;
		
		/**
		 * @param value a key (ie: tile_02) in tileManager.dict[]
		 */
		override public function set data(value:Object):void
		{
			if( value == super.data )
				return;
			
			//if we are on ipad1, we do aggresive gc to avoid crashing on low memory
			if( data && tileManager.isIpad1 )
			{
				//trace("gc");
				var tileData:TileData = tileManager.dict[ data ];
				tileData.bd.dispose();
				tileData.bd = null;
			}
			
			//assign new value
			super.data = value;
			
			//check texture exists
			if( !texture )
			{
				createTexture();
			}
			
			
			//upload the new bd
			flash.display3D.textures.Texture( texture.base ).uploadFromBitmapData( tileManager.getBD( String(value) ) );
			
			//因為 Image 元件會進來問 texture.width，而 width 是參考 mScale 換算出縮放後的值，因此只要能設定新的 scale 值進來就可達到不同縮放效果
			//這樣比改變 image.scaleX 好
			ConcreteTexture(texture).scale = tileManager.captureScale;
			
			//
			if(!image)
			{
				image = new Image( texture );
				image.touchable = false;
				image.smoothing = TextureSmoothing.NONE;
				addChild( image );
			}

			image.texture = texture;
			
			
			//debug: 畫底色
//			if( !quad )
//			{
//				//quad = new Quad(width-2, height-2, 0xfeffd9);
//				quad = new Quad(width, height, 0xfeffd9);
//				quad.alpha = 0.4;
//				addChild( quad );
//			}			
		}
		
		
	}
}