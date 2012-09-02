
package com.pubulous.poc
{
	import flash.geom.Point;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import org.josht.starling.foxhole.layout.ILayout;
	import org.josht.starling.foxhole.layout.IVirtualLayout;
	import org.josht.starling.foxhole.layout.LayoutBoundsResult;
	import org.josht.starling.foxhole.layout.ViewPortBounds;

	/**
	 * Positions items as tiles (equal width and height) from left to right
	 * in multiple rows. Constrained to the suggested width, the tiled rows
	 * layout will change in height as the number of items increases or
	 * decreases.
	 * 
	 * Based on foxhole's TiledRowsLayout
	 * 
	 * @author Jeremy Lu <jeremy@pubulous.com>
	 */
	public class TiledOmniLayout implements IVirtualLayout
	{
		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the top.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the middle.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the bottom.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the left.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the center.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the right.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the top edge of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the middle of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the bottom edge of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The item will be resized to fit the height of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the left edge of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the center of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the right edge of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The item will be resized to fit the width of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The items will be positioned in pages horizontally from left to right.
		 */
		public static const PAGING_HORIZONTAL:String = "horizontal";

		/**
		 * The items will be positioned in pages vertically from top to bottom.
		 */
		public static const PAGING_VERTICAL:String = "vertical";

		/**
		 * The items will not be paged. In other words, they will be positioned
		 * in a continuous set of rows without gaps.
		 */
		public static const PAGING_NONE:String = "none";

		/**
		 * Constructor.
		 */
		public function TiledOmniLayout()
		{
		}

		/**
		 * @private
		 */
		private var _gap:Number = 0;

		/**
		 * The space, in pixels, between tiles.
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The space, in pixels, above of items.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The space, in pixels, to the right of the items.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The space, in pixels, below the items.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The space, in pixels, to the left of the items.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		/**
		 * If the total column height is less than the bounds, the items in the
		 * column can be aligned vertically.
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		/**
		 * If the total row width is less than the bounds, the items in the row
		 * can be aligned horizontally.
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _tileVerticalAlign:String = TILE_VERTICAL_ALIGN_MIDDLE;

		/**
		 * If an item's height is less than the tile bounds, the position of the
		 * item can be aligned vertically.
		 */
		public function get tileVerticalAlign():String
		{
			return this._tileVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set tileVerticalAlign(value:String):void
		{
			if(this._tileVerticalAlign == value)
			{
				return;
			}
			this._tileVerticalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _tileHorizontalAlign:String = TILE_HORIZONTAL_ALIGN_CENTER;

		/**
		 * If the item's width is less than the tile bounds, the position of the
		 * item can be aligned horizontally.
		 */
		public function get tileHorizontalAlign():String
		{
			return this._tileHorizontalAlign;
		}

		/**
		 * @private
		 */
		public function set tileHorizontalAlign(value:String):void
		{
			if(this._tileHorizontalAlign == value)
			{
				return;
			}
			this._tileHorizontalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paging:String = PAGING_NONE;

		/**
		 * If the total combined height of the rows is larger than the height
		 * of the view port, the layout will be split into pages where each
		 * page is filled with the maximum number of rows that may be displayed
		 * without cutting off any items.
		 */
		public function get paging():String
		{
			return this._paging;
		}

		/**
		 * @private
		 */
		public function set paging(value:String):void
		{
			if(this._paging == value)
			{
				return;
			}
			this._paging = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _useSquareTiles:Boolean = true;

		/**
		 * Determines if the tiles must be square or if their width and height
		 * may have different values.
		 */
		public function get useSquareTiles():Boolean
		{
			return this._useSquareTiles;
		}

		/**
		 * @private
		 */
		public function set useSquareTiles(value:Boolean):void
		{
			if(this._useSquareTiles == value)
			{
				return;
			}
			this._useSquareTiles = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _useVirtualLayout:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get useVirtualLayout():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @private
		 */
		public function set useVirtualLayout(value:Boolean):void
		{
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _typicalItemWidth:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemWidth():Number
		{
			return this._typicalItemWidth;
		}

		/**
		 * @private
		 */
		public function set typicalItemWidth(value:Number):void
		{
			if(this._typicalItemWidth == value)
			{
				return;
			}
			this._typicalItemWidth = value;
		}

		/**
		 * @private
		 */
		private var _typicalItemHeight:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemHeight():Number
		{
			return this._typicalItemHeight;
		}

		/**
		 * @private
		 */
		public function set typicalItemHeight(value:Number):void
		{
			if(this._typicalItemHeight == value)
			{
				return;
			}
			this._typicalItemHeight = value;
		}

		/**
		 * @private
		 */
		protected var _onLayoutChange:Signal = new Signal(ILayout);

		/**
		 * @inheritDoc
		 */
		public function get onLayoutChange():ISignal
		{
			return this._onLayoutChange;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			const itemCount:int = items.length;
			var tileWidth:Number = this._useSquareTiles ? Math.max(0, this._typicalItemWidth, this._typicalItemHeight) : this._typicalItemWidth;
			var tileHeight:Number = this._useSquareTiles ? tileWidth : this._typicalItemHeight;
			//a virtual layout assumes that all items are the same size as
			//the typical item, so we don't need to measure every item in
			//that case
			if(!this._useVirtualLayout)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					tileWidth = this._useSquareTiles ? Math.max(tileWidth, item.width, item.height) : Math.max(tileWidth, item.width);
					tileHeight = this._useSquareTiles ? Math.max(tileWidth, tileHeight) : Math.max(tileHeight, item.height);
				}
			}
			var availableWidth:Number = NaN;
			var availableHeight:Number = NaN;

			var horizontalTileCount:int = itemCount;
			if(!isNaN(explicitWidth))
			{
				//jx: 算出一列 8 個 ←實際上可視為 4 個，因此這裏有被我改過的 bounds 騙到
				availableWidth = explicitWidth;
				//一列可放幾個 tiles : 8個
				horizontalTileCount = (explicitWidth - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			}
			else if(!isNaN(maxWidth))
			{
				availableWidth = maxWidth;
				horizontalTileCount = (maxWidth - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			}
			var verticalTileCount:int = 1;
			if(!isNaN(explicitHeight))
			{
				availableHeight = explicitHeight;
				//jx: 垂直方向可放幾個物件 = 6 個 ← 也會被加料後的 helperBounds.heigth 騙到
				verticalTileCount = (explicitHeight - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
			}
			else if(!isNaN(maxHeight))
			{
				availableHeight = maxHeight;
				verticalTileCount = (maxHeight - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
			}

			const totalPageWidth:Number = horizontalTileCount * (tileWidth + this._gap) - this._gap + this._paddingLeft + this._paddingRight;
			const totalPageHeight:Number = verticalTileCount * (tileHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
			const availablePageWidth:Number = isNaN(availableWidth) ? totalPageWidth : availableWidth;
			const availablePageHeight:Number = isNaN(availableHeight) ? totalPageHeight : availableHeight;

			var startX:Number = boundsX + this._paddingLeft;
			var startY:Number = boundsY + this._paddingTop;

			const perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartX:Number = startX;
			var positionX:Number = startX;
			var positionY:Number = startY;
			
			//debug: 找出真正可視的物件
//			for(i = 0; i < itemCount; i++)
//			{
//				if( items[i] != null )
//					trace(items[i].data);
//			}
			
			//jx: 每列幾個物件(此例為 8 個)
			var itemCnt:int = arrTiles[0].length;
			
			//總共多少 rows 要掃描 
			var rowCnt:int = arrTiles.length;
			
			//排版用的定位點
			var posX:int = 0;
			var posY:int = 0;
			
			var j:int;
			
			var limit:int;

//			trace("\n\n\n ↓↓ 新一輪 ↓↓\n");
			
			//量了，跑一輪才 1s 不到
			//Timing.getInstance().start("排一輪");
			
			//依每個 row 橫向掃描 8 個 items
			for(i = 0; i < rowCnt; i++)
			{
				j = i * itemCnt;
				limit = (i+1)*itemCnt - 1;
				
				//trace( j, " : ", limit );
				
				for( j; j<=limit; j++ )
				{
					item = items[j];
					
					//判斷換行
					if(j != 0 && (j % itemCnt == 0) )
					{
						posX = 0;
						posY = tileHeight*i;
						//trace("\n\t", i, " >換行 posX/Y: ", posX, " : ", posY, "\n");
					}
					
					//真正排 item
					if( item )
					{
						item.x = posX;
						item.y = posY;
						//
						posX += tileWidth;
						
//						trace( j, " >item y/x: ", item.y, " \t", item.x );
					}
					else
					{
						//該位置沒東西
						//trace(j, " : 沒東西" );
						posX += tileWidth
					}
				}
			}
			
			//Timing.getInstance().end("排一輪");
			
			/*
			for(i = 0; i < itemCount; i++)
			{
				
				item = items[i];
				
				//一列排完4個時會進這裏，目前排完 12，一列4個，mod 完等於 0 就知道要換行了
				if(i != 0 && i % horizontalTileCount == 0)
				{
					positionX = pageStartX;
					positionY += tileHeight + this._gap;//每次換行就加大一行的高(100)
					//trace("\n\n換行 posX/Y: ", positionX, " : ", positionY, " >itmCnt: ", itemCnt );
					
//					itemCnt = 0;
				}
				
//				if( itemCnt == ( 4+1 ) )
//					continue;
				
				//沒 paging，不會進來
				if(i == nextPageStartIndex)
				{
					//we're starting a new page, so handle alignment of the
					//items on the current page and update the positions
					if(this._paging != PAGING_NONE)
					{
						this.applyHorizontalAlign(items, i - perPage, i - 1, totalPageWidth, availablePageWidth);
						this.applyVerticalAlign(items, i - perPage, i - 1, totalPageHeight, availablePageHeight);
					}
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging == PAGING_HORIZONTAL)
					{
						positionX = pageStartX = startX + availableWidth * pageIndex;
						positionY = startY;
					}
					else if(this._paging == PAGING_VERTICAL)
					{
						positionY = startY + availableHeight * pageIndex;
					}
				}
				
				//重要：items 就是 dataProvider 內所有物件，但 ListDataViewPort() 裏會將 非可視 的物件設為 null
				//因此就算有 100 個 items，但只會有 20 個會被排，因為它們早先被運算為可視
				if(item)
				{
					
					//x
					switch(this._tileHorizontalAlign)
					{
						case TILE_HORIZONTAL_ALIGN_JUSTIFY:
						{
							item.x = positionX;
							item.width = tileWidth;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_LEFT:
						{
							item.x = positionX;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_RIGHT:
						{
							item.x = positionX + tileWidth - item.width;
							break;
						}
						default: //center or unknown
						{
							//jx: 一般都進這裏
							item.x = positionX + (tileWidth - item.width) / 2;
						}
					}
					
					//y
					switch(this._tileVerticalAlign)
					{
						case TILE_VERTICAL_ALIGN_JUSTIFY:
						{
							item.y = positionY;
							item.height = tileHeight;
							break;
						}
						case TILE_VERTICAL_ALIGN_TOP:
						{
							item.y = positionY;
							break;
						}
						case TILE_VERTICAL_ALIGN_BOTTOM:
						{
							item.y = positionY + tileHeight - item.height;
							break;
						}
						default: //middle or unknown
						{
							//jx: 一般都進這裏
							item.y = positionY + (tileHeight - item.height) / 2;
						}
					}
					trace("item y/x: ", item.y, " : ", item.x );
				}
				
				positionX += tileWidth + this._gap;//jx: 最後得出這個值
				
				//trace("\t預備下一物件 x= ", positionX );
			}	//jx: end for loop
			*/
			
			//align the last page
			if(this._paging != PAGING_NONE)
			{
				this.applyHorizontalAlign(items, nextPageStartIndex - perPage, i - 1, totalPageWidth, availablePageWidth);
				this.applyVerticalAlign(items, nextPageStartIndex - perPage, i - 1, totalPageHeight, availablePageHeight);
			}
			
			//jx: 一般都沒 paing, 會進這裏
			var totalWidth:Number = totalPageWidth;
			if(!isNaN(availableWidth) && this._paging == PAGING_HORIZONTAL)
			{
				totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
			}
			var totalHeight:Number = positionY + tileHeight + this._paddingBottom;
			if(!isNaN(availableHeight))	//no
			{
				if(this._paging == PAGING_HORIZONTAL)
				{
					totalHeight = availableHeight;
				}
				else if(this._paging == PAGING_VERTICAL)
				{
					totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
				}
			}
			if(isNaN(availableWidth))
			{
				availableWidth = totalWidth;
			}
			if(isNaN(availableHeight))
			{
				availableHeight = totalHeight;
			}
			availableWidth = Math.max(minWidth, availableWidth);
			availableHeight = Math.max(minHeight, availableHeight);

			if(this._paging == PAGING_NONE)//yes
			{
//				this.applyHorizontalAlign(items, 0, itemCount - 1, totalWidth, availableWidth);
//				this.applyVerticalAlign(items, 0, itemCount - 1, totalHeight, availableHeight);
			}

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = totalWidth;
			result.contentHeight = totalHeight;
			result.viewPortWidth = availableWidth;
			result.viewPortHeight = availableHeight;

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function measureViewPort(itemCount:int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			const explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			const explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			const needsWidth:Boolean = isNaN(explicitWidth);
			const needsHeight:Boolean = isNaN(explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				result.x = explicitWidth;
				result.y = explicitHeight;
				return result;
			}

			const boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			const boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

			const tileWidth:Number = this._useSquareTiles ? Math.max(0, this._typicalItemWidth, this._typicalItemHeight) : this._typicalItemWidth;
			const tileHeight:Number = this._useSquareTiles ? tileWidth : this._typicalItemHeight;

			var availableWidth:Number = NaN;
			var availableHeight:Number = NaN;

			var horizontalTileCount:int = itemCount;
			if(!isNaN(explicitWidth))
			{
				availableWidth = explicitWidth;
				horizontalTileCount = (explicitWidth - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			}
			else if(!isNaN(maxWidth))
			{
				availableWidth = maxWidth;
				horizontalTileCount = (maxWidth - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			}
			var verticalTileCount:int = 1;
			if(!isNaN(explicitHeight))
			{
				availableHeight = explicitHeight;
				verticalTileCount = (explicitHeight - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
			}
			else if(!isNaN(maxHeight))
			{
				availableHeight = maxHeight;
				verticalTileCount = (maxHeight - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
			}

			const totalPageWidth:Number = horizontalTileCount * (tileWidth + this._gap) - this._gap + this._paddingLeft + this._paddingRight;
			const totalPageHeight:Number = verticalTileCount * (tileHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
			const availablePageWidth:Number = isNaN(availableWidth) ? totalPageWidth : availableWidth;
			const availablePageHeight:Number = isNaN(availableHeight) ? totalPageHeight : availableHeight;

			const startX:Number = boundsX + this._paddingLeft;
			const startY:Number = boundsY + this._paddingTop;

			const perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartX:Number = startX;
			var positionX:Number = startX;
			var positionY:Number = startY;
			for(var i:int = 0; i < itemCount; i++)
			{
				if(i != 0 && i % horizontalTileCount == 0)
				{
					positionX = pageStartX;
					positionY += tileHeight + this._gap;
				}
				if(i == nextPageStartIndex)
				{
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging == PAGING_HORIZONTAL)
					{
						positionX = pageStartX = startX + availableWidth * pageIndex;
						positionY = startY;
					}
					else if(this._paging == PAGING_VERTICAL)
					{
						positionY = startY + availableHeight * pageIndex;
					}
				}
			}

			var totalWidth:Number = totalPageWidth;
			if(!isNaN(availableWidth) && this._paging == PAGING_HORIZONTAL)
			{
				totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
			}
			var totalHeight:Number = positionY + tileHeight + this._paddingBottom;
			if(!isNaN(availableHeight))
			{
				if(this._paging == PAGING_HORIZONTAL)
				{
					totalHeight = availableHeight;
				}
				else if(this._paging == PAGING_VERTICAL)
				{
					totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
				}
			}

			result.x = needsWidth ? Math.max(minWidth, totalWidth) : explicitWidth;
			result.y = needsHeight ? Math.max(minHeight, totalHeight) : explicitHeight;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>
		{
			if(!result)
			{
				result = new <int>[];
			}
			result.length = 0;

			//jx: 下列三個由 const 改成 var
			var tileWidth:Number = this._useSquareTiles ? Math.max(0, this._typicalItemWidth, this._typicalItemHeight) : this._typicalItemWidth;
			var tileHeight:Number = this._useSquareTiles ? tileWidth : this._typicalItemHeight;
			var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			
			//jxnote: 不會進這段
			if(this._paging != PAGING_NONE)
			{
				var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
				const perPage:Number = horizontalTileCount * verticalTileCount;
				if(this._paging == PAGING_HORIZONTAL)
				{
					var startPageIndex:int = Math.round(scrollX / width);
					var minimum:int = startPageIndex * perPage;
					var totalRowWidth:Number = horizontalTileCount * (tileWidth + this._gap) - this._gap;
					var leftSideOffset:Number = 0;
					var rightSideOffset:Number = 0;
					if(totalRowWidth < width)
					{
						if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
						{
							leftSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
							rightSideOffset = 0;
						}
						else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
						{
							leftSideOffset = rightSideOffset = (width - this._paddingLeft - this._paddingRight - totalRowWidth) / 2;
						}
						else if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
						{
							leftSideOffset = 0;
							rightSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
						}
					}
					var columnOffset:int = 0;
					var pageStartPosition:Number = startPageIndex * width;
					var partialPageSize:Number = scrollX - pageStartPosition;
					if(partialPageSize < 0)
					{
						partialPageSize = Math.max(0, -partialPageSize - this._paddingRight - rightSideOffset);
						columnOffset = -Math.floor(partialPageSize / (tileWidth + this._gap)) - 1;
						minimum += -perPage + horizontalTileCount + columnOffset;
					}
					else if(partialPageSize > 0)
					{
						partialPageSize = Math.max(0, partialPageSize - this._paddingLeft - leftSideOffset);
						columnOffset = Math.floor(partialPageSize / (tileWidth + this._gap));
						minimum += columnOffset;
					}
					if(minimum < 0)
					{
						minimum = 0;
						columnOffset = 0;
					}
					var rowIndex:int = 0;
					var columnIndex:int = (horizontalTileCount + columnOffset) % horizontalTileCount;
					var maxColumnIndex:int = columnIndex + horizontalTileCount + 2;
					var pageStart:int = int(minimum / perPage) * perPage;
					var i:int = minimum;
					do
					{
						result.push(i);
						rowIndex++;
						if(rowIndex == verticalTileCount)
						{
							rowIndex = 0;
							columnIndex++;
							if(columnIndex == horizontalTileCount)
							{
								columnIndex = 0;
								pageStart += perPage;
								maxColumnIndex -= horizontalTileCount;
							}
							i = pageStart + columnIndex - horizontalTileCount;
						}
						i += horizontalTileCount;
					}
					while(columnIndex != maxColumnIndex)
				}
				else
				{
					startPageIndex = Math.round(scrollY / height);
					minimum = startPageIndex * perPage;
					if(minimum > 0)
					{
						pageStartPosition = startPageIndex * height;
						partialPageSize = scrollY - pageStartPosition;
						if(partialPageSize < 0)
						{
							minimum -= horizontalTileCount * Math.ceil((-partialPageSize - this._paddingBottom) / (tileHeight + this._gap));
						}
						else if(partialPageSize > 0)
						{
							minimum += horizontalTileCount * Math.floor((partialPageSize - this._paddingTop) / (tileHeight + this._gap));
						}
					}
					var maximum:int = minimum + perPage + 2 * horizontalTileCount - 1;
					for(i = minimum; i <= maximum; i++)
					{
						result.push(i);
					}
				}
			}
			else
			{
				//jx: 不需 paging，會直接進這段
				var rowIndexOffset:int = 0;
				//jx: const 改成 var
				var totalRowHeight:Number = Math.ceil(itemCount / horizontalTileCount) * (tileHeight + this._gap) - this._gap;
				if(totalRowHeight < height)
				{	
					//jx: 不會進這裏
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						rowIndexOffset = Math.ceil((height - totalRowHeight) / (tileHeight + this._gap));
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						rowIndexOffset = Math.ceil((height - totalRowHeight) / (tileHeight + this._gap) / 2);
					}
				}
				
				//jx: 也不用管 align，直接看這裏
				
				//目前捲到第1列
				//這行是在找出目前捲到哪一列，要由它開始計算可視的 tile，取 floor 代表就算上方只露出一點的，也要算入
				rowIndex = -rowIndexOffset + Math.floor((scrollY - this._paddingTop + this._gap) / (tileHeight + this._gap));
				
				//每次可顯示3列
				//這是在算 List 可視範圍(h=300)，垂直方向可放幾個 row ？ height / tileHeight 就會得出 3 row
				verticalTileCount = Math.ceil( (height - this._paddingTop + this._gap) / (tileHeight + this._gap) ) + 1;
				
				//由上兩行可算出：目前我捲到第2 row，而 list 一次要顯示三個 row
				//TODO: 這裏目前不好的地方在於：它會一次將每 row 的 8 個 tile 都算進去
				//但實際上還要考慮水平方向一次也只可視四個，超出的不用管
//				minimum = rowIndex * horizontalTileCount;
//				maximum = minimum + horizontalTileCount * verticalTileCount;
				
//				trace("\n\nrow >start: ", rowIndex, " >end: ", verticalTileCount );
				
				//---------------------------------------------------------------
				//
				// jxtest  
				
				var columnIndexOffset:int = 0;
				
				//算出目前橫向捲到第幾欄？
				columnIndex = -columnIndexOffset + Math.floor((scrollX - this._paddingLeft + this._gap) / (tileWidth + this._gap));
				
				//算出 List 可視寬度(w=400) 內可放幾欄？width/tileWidth = 4 columns
				horizontalTileCount = Math.ceil((width - this._paddingLeft + this._gap) / (tileWidth + this._gap)) + 1;
				
//				trace("column >start: ", columnIndex, " >end: ", horizontalTileCount );
				
				//拉過頭露白時，這兩個值會是負的，要取正值，不然跟 tile map 取值就會炸掉
				rowIndex = Math.abs( rowIndex );
				columnIndex = Math.abs( columnIndex );
				
				//
				var rowLimit:Number = Math.min( rowIndex+verticalTileCount, arrTiles.length );
				var columnLimit:Number = Math.min(columnIndex+horizontalTileCount, arrTiles[0].length );
				
				//
				var rowIdx:int;
				var cIdx:int;
				
				//
				for( rowIdx = rowIndex; rowIdx < rowLimit; rowIdx++ )
				{
					//trace("可視row: ", rowIdx);
					for( cIdx = columnIndex; cIdx < columnLimit; cIdx++ )
					{
						result.push( arrTiles[rowIdx][cIdx].split("_")[1] );
//						trace("\tcolumn: ", cIdx, " >value: ", arrTiles[rowIdx][cIdx].split("_")[1] );
					}
				}

//				trace("總可視物件數量: ", result.length);
				
				
				// ↑ Aug 31, 2012
				//---------------------------------------------------------------
				
//				for(i = minimum; i <= maximum; i++)
//				{
//					//trace("放入 i: ", i);
//					result.push(i);
//				}
			}
			return result;
		}
		
		//jx: 外部傳入的 2維 tile map
		public var arrTiles:Vector.<Array>;

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForItemIndexAndBounds(index:int, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const tileWidth:Number = this._useSquareTiles ? Math.max(0, this._typicalItemWidth, this._typicalItemHeight) : this._typicalItemWidth;
			const tileHeight:Number = this._useSquareTiles ? tileWidth : this._typicalItemHeight;
			const horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._gap) / (tileWidth + this._gap);
			if(this._paging != PAGING_NONE)
			{
				const verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._gap) / (tileHeight + this._gap);
				const perPage:Number = horizontalTileCount * verticalTileCount;
				const pageIndex:int = index / perPage;
				if(this._paging == PAGING_HORIZONTAL)
				{
					result.x = pageIndex * width;
					result.y = 0;
				}
				else
				{
					result.x = 0;
					result.y = pageIndex * height;
				}
			}
			else
			{
				result.x = 0;
				result.y = this._paddingTop + ((tileHeight + this._gap) * index / horizontalTileCount) + (height - tileHeight) / 2;
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function applyHorizontalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemWidth:Number, availableWidth:Number):void
		{
			if(totalItemWidth >= availableWidth)
			{
				return;
			}
			var horizontalAlignOffsetX:Number = 0;
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				horizontalAlignOffsetX = availableWidth - totalItemWidth;
			}
			else if(this._horizontalAlign != HORIZONTAL_ALIGN_LEFT)
			{
				//we're going to default to center if we encounter an
				//unknown value
				horizontalAlignOffsetX = (availableWidth - totalItemWidth) / 2;
			}
			if(horizontalAlignOffsetX != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					item.x += horizontalAlignOffsetX;
				}
			}
		}

		/**
		 * @private
		 */
		protected function applyVerticalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemHeight:Number, availableHeight:Number):void
		{
			if(totalItemHeight >= availableHeight)
			{
				return;
			}
			var verticalAlignOffsetY:Number = 0;
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				verticalAlignOffsetY = availableHeight - totalItemHeight;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffsetY = (availableHeight - totalItemHeight) / 2;
			}
			if(verticalAlignOffsetY != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					item.y += verticalAlignOffsetY;
				}
			}
		}
	}
}
