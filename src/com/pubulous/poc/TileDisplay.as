package com.pubulous.poc
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.Scroller;
	import org.josht.starling.foxhole.controls.renderers.IListItemRenderer;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	
	import starling.display.Quad;
	
	/**
	 * A Display Container that sliced up large content (images, or any DisplayObject) into multiple tiles 
	 * so it's more efficient GPU-wise.
	 * 
	 * Please note this is prototype quality of code, thrown together in 5 hours during the weekend, 
	 * report bugs if you find one. 
	 * 
	 * @author Jeremy Lu <jeremy@pubulous.com>
	 */
	public class TileDisplay extends FoxholeControl
	{
		public function TileDisplay()
		{
			super();
		}
		
		private var list:List;
		private var tileManager:TileManager;
		
		private var contentWidth:int;
		private var contentHeight:int;
		
		/**
		 * making a queue out of 2D Vector for List
		 */
		private var dp:Vector.<String>;
		
		private var layout:TiledOmniLayout;
		
		private var vTiles:Vector.<Array>;

		/**
		 * 
		 */
		override protected function initialize():void
		{
			//
			list = new List();
			list.isSelectable = false;
			//用 renderer factory 才能指定 renderer w, h
			list.itemRendererFactory = itemFactory;
			//list.onScroll.add( listScrollHandler );
			addChild( list );
			
			//scroller
			list.scrollerProperties.hasElasticEdges = false;
			list.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			list.scrollerProperties.snapToPages = false;
			list.scrollerProperties.clipContent = true;
			
			//layout
			layout = new TiledOmniLayout();
			layout.gap = 0;
			layout.useSquareTiles = true;
			
			
			//debug: draw an outline around the list
//			var g:Graphics = Starling.current.nativeOverlay.graphics;
//			g.lineStyle(2, 0xff0000 );
//			g.drawRect( list.x, list.y, list.width, list.height );

			
		}
		
		
		/**
		 * there used be a bug that a 1px space will appear between tiles if hsp/vsp is not integer,
		 * we make it an integer, but it's gone later in the cycle so this is not needed anymore
		 */
		private function listScrollHandler( t:List ):void
		{
			//trace("scroll h: ", list.horizontalScrollPosition, "\t", list.verticalScrollPosition );
			list.horizontalScrollPosition = int( list.horizontalScrollPosition );
			list.verticalScrollPosition = int( list.verticalScrollPosition );
		}

		/**
		 * set 
		 */
		private function itemFactory():IListItemRenderer
		{
			var renderer:TileRenderer;
			renderer = new TileRenderer();
			renderer.width = tileSize;
			renderer.height = tileSize;
			renderer.tileManager = tileManager;
			return renderer;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const selectedInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
			
			if( dataInvalid )
			{
				if( source )
				{
					//dispose old manager and vector
					if( tileManager )
						tileManager.dispose();
					
					//create a new tileManager for new image
					tileManager = new TileManager();
					tileManager.source = this.source;
					
					//create a new tile map
					createTileMap();
					
					//layout need tileMap to look up which items are visible, pass it in
					layout.arrTiles = vTiles;

					//
					list.layout = layout;
					list.dataProvider = new ListCollection( dp );
					
					//fit viewPort size to content size so we can scroll the list
					list.dataViewPort.width = contentWidth;
					list.dataViewPort.height = contentHeight;
					
					//trace("viewPort w/h: ", list.dataViewPort.width, " : ", list.dataViewPort.height );
				}
				
			}
			
			//
			if( sizeInvalid )
			{
				list.x = 0;
				list.y = 0;
				list.width = this.width;
				list.height = this.height;
				
				//debug: draw bg color
//				if( !bgSkin && width>0 )
//				{
//					bgSkin = new Quad(list.width, list.height, 0xd9e6ff );	// 0xd9e6ff
//					list.backgroundSkin = bgSkin;
//					bgSkin.width = width;
//					bgSkin.height = height;
//				}
			}
			
			
		}
		
		private var bgSkin:Quad;
		
		/**
		 * 
		 */
		private function createTileMap():void
		{
			var start:int = 0;
			
			vTiles = new <Array>[];
			
			dp = new <String>[];
			
			//decide how many rows and columns we need for the source content
			numRows = Math.ceil( contentHeight / tileSize );		//note: it's dividing the contentHeight by tileSize
			numColumns = Math.ceil( contentWidth / tileSize ); 
			
			
			var arr:Array;
			var row:int;
			var column:int;
			var tileKey:String;
			var tileData:TileData;
			
			//build a 2D array as the tile map
			for( row=0; row<numRows; row++ )	//rows
			{
				arr = [];
				vTiles.push( arr );
				for(column=0; column< numColumns; column++ ) //columns in each row
				{
					//tile = String(start++);
					tileKey = "tile_" + start++;
					vTiles[row].push( tileKey );
					dp.push( tileKey );	//放進拉直的 array 裏
					
					//每個 tile 依 key 放入 tileManager
					tileData = new TileData();
					tileData.rect = new Rectangle( column * tileSize, row * tileSize, tileSize, tileSize );
					tileManager.dict[ tileKey ] = tileData;
				}
				//trace( row, ":", arrTiles[row] );
			}
		}
		
		//===================================
		//
		// getter/setters
		
		private var _source:DisplayObject;
		private var _tileSize:int = 512;

		private var numRows:int;

		private var numColumns:int;

		
		/**
		 * tileSize should have same value for width and height, and should be 128, 256, 512... and so on
		 */
		public function get tileSize():int
		{
			return _tileSize;
		}
		
		public function set tileSize(value:int):void
		{
			if( _tileSize == value )
				return;
			
			_tileSize = value;
			
			invalidate( INVALIDATION_FLAG_SIZE );
		}
		
		/**
		 * the image this tileDisplay is showing
		 */
		public function get source():DisplayObject
		{
			return _source;
		}
		
		public function set source(value:DisplayObject):void
		{
			if( _source == value )
				return;
			
			_source = value;
			
			//
			contentWidth = source.width;
			contentHeight = source.height;
			
			this.invalidate( INVALIDATION_FLAG_DATA );
		}
		
	}
}