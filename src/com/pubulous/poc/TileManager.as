package com.pubulous.poc
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class TileManager
	{
		public function TileManager()
		{
			
			isIpad1 = Capabilities.os.indexOf("iPad1") != -1;
			
			//debug
//			source.alpha = 0.2;
//			Starling.current.nativeOverlay.addChild( source );
		}
		
		/**
		 * if it's ipad1, we do aggresive gc for each unused bitmapData
		 */
		public var isIpad1:Boolean;
		
		/**
		 * 
		 */
		public var tileCount:int = 1;
		
		
		/**
		 * the image to draw bitmapData from
		 */
		public var source:DisplayObject;
		
		/**
		 * type = TileData
		 */
		public var dict:Dictionary = new Dictionary();
		
		/**
		 * get tileData obj by key (ie: tile_02)
		 */
		public function getBD( key:String ):BitmapData
		{
			var bd:BitmapData;
			var tileData:TileData = dict[ key ];
			
			if( tileData.bd )
			{
				//trace("bd exists = ", key );
				bd = tileData.bd;
			}
			else
			{
				bd = createBD( tileData );
			}
			
			return bd;
		}
		
		
		
		private static var matrix:Matrix = new Matrix();
		
		
		/**
		 * 這裏決定抓取的 bd 大小，0.5 就是原圖的 1/2，這樣體積就省很多了 ← 注意最小要為 64，再小反而會變慢
		 * 重點在：將來要靠 Image 去去 scale-up 這個 bd
		 * 可改成 1/4 這樣的寫法，但目前發現小於 1/2 的都會讓 fps 大幅下降，時間都花在 starling.render() 上
		 * 
		 * TODO: explore more on this one, ie: blurry preview and on-demand high-res viewer 
		 */
		public var captureScale:Number = 1;
		
		/**
		 * 
		 */
		private var pt:Point = new Point(0, 0);
		
		/**
		 * 
		 */
		private function createBD( tileData:TileData ):BitmapData
		{
			var rect:Rectangle = tileData.rect;
			
			tileData.bd = new BitmapData( rect.width * captureScale, rect.height * captureScale, true, 0x0 );
			
			//reset matrix
			matrix.identity();
			
			//定位到我想要的方塊 - 它是用詭異的負向偏移來想
			matrix.translate( -rect.x, -rect.y );
			
			//jxtest: 縮小 bd 為 1/2，以節省體積
			matrix.scale( captureScale, captureScale );
			
			//開始擷圖
			if( false/*source is Bitmap*/ )
			{
				//如果 source 本身是一個 bitmap，可用 copyPixels() 更快速
				tileData.bd.copyPixels( Bitmap(source).bitmapData, rect, pt );
			}
			else
			{
				//如果是一般的 displayObject，使用 draw()
				tileData.bd.draw( source, matrix );
			}
				
			
			
			
			return tileData.bd;
		}
		
		/**
		 * 
		 */
		public function dispose():void
		{
			var tileData:TileData;
			for each( tileData in dict )
			{
				tileData.bd.dispose();
				tileData.bd = null;
				
				dict = new Dictionary();
			}
			
		}
		
		
		//===================================
		//
		// Singleton 
		
//		static private var _instance:TileManager;
//		
//		public static function getInstance():TileManager
//		{
//			if( !_instance )
//				_instance = new TileManager();
//			
//			return _instance;
//		}
	}
}