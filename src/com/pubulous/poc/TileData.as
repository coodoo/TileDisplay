package com.pubulous.poc
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class TileData
	{
		public function TileData()
		{
		}
		
		/**
		 * 這個 tile 真正的圖像
		 */
		public var bd:BitmapData;
		
		/**
		 * 這個 tile 的範圍
		 */
		public var rect:Rectangle;
	}
}