package org.josht.starling.foxhole.themes
{
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	
	import org.josht.starling.display.Image;
	import org.josht.starling.display.Scale3Image;
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.Callout;
	import org.josht.starling.foxhole.controls.Check;
	import org.josht.starling.foxhole.controls.PickerList;
	import org.josht.starling.foxhole.controls.ProgressBar;
	import org.josht.starling.foxhole.controls.Radio;
	import org.josht.starling.foxhole.controls.ScreenHeader;
	import org.josht.starling.foxhole.controls.SimpleScrollBar;
	import org.josht.starling.foxhole.controls.Slider;
	import org.josht.starling.foxhole.controls.TextInput;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import org.josht.starling.foxhole.controls.popups.CalloutPopUpContentManager;
	import org.josht.starling.foxhole.controls.popups.VerticalCenteredPopUpContentManager;
	import org.josht.starling.foxhole.controls.renderers.BaseDefaultItemRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListItemRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
	import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
	import org.josht.starling.foxhole.controls.text.TextFieldTextRenderer;
	import org.josht.starling.foxhole.core.AddedWatcher;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.ITextRenderer;
	import org.josht.starling.foxhole.layout.VerticalLayout;
	import org.josht.starling.foxhole.skins.ImageStateValueSelector;
	import org.josht.starling.foxhole.skins.Scale9ImageStateValueSelector;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.textures.Scale3Textures;
	import org.josht.starling.textures.Scale9Textures;
	import org.josht.system.PhysicalCapabilities;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 注意：升上 asc2 後，static const 的執行時序改變了，它會太快運行，導致 Stage3D.context 還沒建立，
	 * 會在 Texture 裏炸掉，因此要改架構，等到 context 建立後才初始化所有 textures
	 */
	public class AzureTheme extends AddedWatcher implements IFoxholeTheme
	{
		[Embed(source="/assets/azure.png")]
		protected static const ATLAS_IMAGE:Class;
		
		[Embed(source="/assets/azure.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;
		
		[Embed(source="/assets/lato30.fnt",mimeType="application/octet-stream")]
		protected static const ATLAS_FONT_XML:Class;
		
		protected static var ATLAS:TextureAtlas;
		
		protected static const PROGRESS_BAR_SCALE_3_FIRST_REGION:Number = 12;
		protected static const PROGRESS_BAR_SCALE_3_SECOND_REGION:Number = 12;
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(8, 8, 15, 49);
		protected static const SLIDER_FIRST:Number = 16;
		protected static const SLIDER_SECOND:Number = 8;
		protected static const CALLOUT_SCALE_9_GRID:Rectangle = new Rectangle(8, 24, 15, 33);
		protected static const SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 4, 4);
		
		protected static const BACKGROUND_COLOR:uint = 0xFFFFFF;
		protected static const PRIMARY_TEXT_COLOR:uint = 0xe5e5e5;
		protected static const SELECTED_TEXT_COLOR:uint = 0xffffff;
		
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		
		protected static var BUTTON_UP_SKIN_TEXTURES:Scale9Textures;
		protected static var BUTTON_DOWN_SKIN_TEXTURES:Scale9Textures;
		protected static var BUTTON_DISABLED_SKIN_TEXTURES:Scale9Textures;
		
		protected static var HSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES:Scale3Textures;
		protected static var HSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES:Scale3Textures;
		protected static var HSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES:Scale3Textures;
		
		protected static var HSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES:Scale3Textures;
		protected static var HSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES:Scale3Textures;
		protected static var HSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES:Scale3Textures;
		
		protected static var VSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES:Scale3Textures;
		protected static var VSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES:Scale3Textures;
		protected static var VSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES:Scale3Textures;
		
		protected static var VSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES:Scale3Textures;
		protected static var VSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES:Scale3Textures;
		protected static var VSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES:Scale3Textures;
		
		protected static var SLIDER_THUMB_UP_SKIN_TEXTURE:Texture;
		protected static var SLIDER_THUMB_DOWN_SKIN_TEXTURE:Texture;
		protected static var SLIDER_THUMB_DISABLED_SKIN_TEXTURE:Texture;
		
		protected static var SCROLL_BAR_THUMB_SKIN_TEXTURES:Scale9Textures;
		
		protected static var PROGRESS_BAR_BACKGROUND_SKIN_TEXTURES:Scale3Textures;
		protected static var PROGRESS_BAR_BACKGROUND_DISABLED_SKIN_TEXTURES:Scale3Textures;
		protected static var PROGRESS_BAR_FILL_SKIN_TEXTURES:Scale3Textures;
		protected static var PROGRESS_BAR_FILL_DISABLED_SKIN_TEXTURES:Scale3Textures;
		
		protected static var INSET_BACKGROUND_SKIN_TEXTURES:Scale9Textures;
		protected static var INSET_BACKGROUND_DISABLED_SKIN_TEXTURES:Scale9Textures;
		
		protected static var PICKER_ICON_TEXTURE:Texture;
		
		protected static var LIST_ITEM_UP_TEXTURE:Texture;
		protected static var LIST_ITEM_DOWN_TEXTURE:Texture;
		
		protected static var GROUPED_LIST_HEADER_BACKGROUND_SKIN_TEXTURE:Texture;
		
		protected static var TOOLBAR_BACKGROUND_SKIN_TEXTURE:Texture;
		
		protected static var TAB_SELECTED_SKIN_TEXTURE:Texture;
		
		protected static var CALLOUT_BACKGROUND_SKIN_TEXTURES:Scale9Textures;
		protected static var CALLOUT_TOP_ARROW_SKIN_TEXTURE:Texture;
		protected static var CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE:Texture;
		protected static var CALLOUT_LEFT_ARROW_SKIN_TEXTURE:Texture;
		protected static var CALLOUT_RIGHT_ARROW_SKIN_TEXTURE:Texture;
		
		protected static var CHECK_UP_ICON_TEXTURE:Texture;
		protected static var CHECK_DOWN_ICON_TEXTURE:Texture;
		protected static var CHECK_DISABLED_ICON_TEXTURE:Texture;
		protected static var CHECK_SELECTED_UP_ICON_TEXTURE:Texture;
		protected static var CHECK_SELECTED_DOWN_ICON_TEXTURE:Texture;
		protected static var CHECK_SELECTED_DISABLED_ICON_TEXTURE:Texture;
		
		protected static var RADIO_UP_ICON_TEXTURE:Texture;
		protected static var RADIO_DOWN_ICON_TEXTURE:Texture;
		protected static var RADIO_DISABLED_ICON_TEXTURE:Texture;
		protected static var RADIO_SELECTED_UP_ICON_TEXTURE:Texture;
		protected static var RADIO_SELECTED_DISABLED_ICON_TEXTURE:Texture;
		
		protected static var BITMAP_FONT:BitmapFont;
		
		
		/**
		 * jx: starling.context 建好後，才能操作一系列的 Texture.fromBitmap() 之類的指令，
		 * 因此全部收納在這支下執行
		 */
		private function createTexture():void
		{
			if( Starling.context == null )
			{
				trace("context3D 還沒好，掛偵聽");
				Starling.current.addEventListener( Event.CONTEXT3D_CREATE, contextCreateHandler );
			}
			else
			{
				ATLAS = new TextureAtlas(Texture.fromBitmap(new ATLAS_IMAGE(), false), XML(new ATLAS_XML()));
				
				BUTTON_UP_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
				BUTTON_DOWN_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("button-down-skin"), BUTTON_SCALE_9_GRID);
				BUTTON_DISABLED_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
				
				HSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-minimum-track-up-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				HSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-minimum-track-down-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				HSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-minimum-track-disabled-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				
				HSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-maximum-track-up-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				HSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-maximum-track-down-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				HSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("hslider-maximum-track-disabled-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
				
				VSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-minimum-track-up-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				VSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-minimum-track-down-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				VSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-minimum-track-disabled-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				
				VSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-maximum-track-up-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				VSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-maximum-track-down-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				VSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("vslider-maximum-track-disabled-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
				
				SLIDER_THUMB_UP_SKIN_TEXTURE = ATLAS.getTexture("slider-thumb-up-skin");
				SLIDER_THUMB_DOWN_SKIN_TEXTURE = ATLAS.getTexture("slider-thumb-down-skin");
				SLIDER_THUMB_DISABLED_SKIN_TEXTURE = ATLAS.getTexture("slider-thumb-disabled-skin");
				
				SCROLL_BAR_THUMB_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("simple-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_SCALE_9_GRID);
				
				PROGRESS_BAR_BACKGROUND_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("progress-bar-background-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
				PROGRESS_BAR_BACKGROUND_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("progress-bar-background-disabled-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
				PROGRESS_BAR_FILL_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("progress-bar-fill-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
				PROGRESS_BAR_FILL_DISABLED_SKIN_TEXTURES = new Scale3Textures(ATLAS.getTexture("progress-bar-fill-disabled-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
				
				INSET_BACKGROUND_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("inset-skin"), BUTTON_SCALE_9_GRID);
				INSET_BACKGROUND_DISABLED_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("inset-disabled-skin"), BUTTON_SCALE_9_GRID);
				
				PICKER_ICON_TEXTURE = ATLAS.getTexture("picker-icon");
				
				LIST_ITEM_UP_TEXTURE = ATLAS.getTexture("list-item-up-skin");
				LIST_ITEM_DOWN_TEXTURE = ATLAS.getTexture("list-item-down-skin");
				
				GROUPED_LIST_HEADER_BACKGROUND_SKIN_TEXTURE = ATLAS.getTexture("grouped-list-header-background-skin");
				
				TOOLBAR_BACKGROUND_SKIN_TEXTURE = ATLAS.getTexture("toolbar-background-skin");
				
				TAB_SELECTED_SKIN_TEXTURE = ATLAS.getTexture("tab-selected-skin");
				
				CALLOUT_BACKGROUND_SKIN_TEXTURES = new Scale9Textures(ATLAS.getTexture("callout-background-skin"), CALLOUT_SCALE_9_GRID);
				CALLOUT_TOP_ARROW_SKIN_TEXTURE = ATLAS.getTexture("callout-arrow-top-skin");
				CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE = ATLAS.getTexture("callout-arrow-bottom-skin");
				CALLOUT_LEFT_ARROW_SKIN_TEXTURE = ATLAS.getTexture("callout-arrow-left-skin");
				CALLOUT_RIGHT_ARROW_SKIN_TEXTURE = ATLAS.getTexture("callout-arrow-right-skin");
				
				CHECK_UP_ICON_TEXTURE = ATLAS.getTexture("check-up-icon");
				CHECK_DOWN_ICON_TEXTURE = ATLAS.getTexture("check-down-icon");
				CHECK_DISABLED_ICON_TEXTURE = ATLAS.getTexture("check-disabled-icon");
				CHECK_SELECTED_UP_ICON_TEXTURE = ATLAS.getTexture("check-selected-up-icon");
				CHECK_SELECTED_DOWN_ICON_TEXTURE = ATLAS.getTexture("check-selected-down-icon");
				CHECK_SELECTED_DISABLED_ICON_TEXTURE = ATLAS.getTexture("check-selected-disabled-icon");
				
				RADIO_UP_ICON_TEXTURE = ATLAS.getTexture("radio-up-icon");
				RADIO_DOWN_ICON_TEXTURE = ATLAS.getTexture("radio-down-icon");
				RADIO_DISABLED_ICON_TEXTURE = ATLAS.getTexture("radio-disabled-icon");
				RADIO_SELECTED_UP_ICON_TEXTURE = ATLAS.getTexture("radio-selected-up-icon");
				RADIO_SELECTED_DISABLED_ICON_TEXTURE = ATLAS.getTexture("radio-selected-disabled-icon");
				
				BITMAP_FONT = new BitmapFont(ATLAS.getTexture("lato30_0"), XML(new ATLAS_FONT_XML()));
			}
		}
		
		/**
		 * 等 Sarling.context 有值後，才能安全的跑 createTexture()，不然一定炸
		 * 這是因為 asc2.0 有針對 static const 做特殊處理，它執行時間太快了
		 */
		private function contextCreateHandler( c:Context3D ):void
		{
			Starling.current.removeEventListener( Event.CONTEXT3D_CREATE, contextCreateHandler );
			createTexture();
		}
			
		
		
				
		/**
		 * 進入點
		 */
		public function AzureTheme(root:DisplayObject, scaleToDPI:Boolean = true)
		{
			super(root);
			
			//jx - 盡快跑 
			createTexture();
			
			//
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
			
			//
			if(root.stage)
			{
				root.stage.color = BACKGROUND_COLOR;
			}
			else
			{
				root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			this._scaleToDPI = scaleToDPI;
			
			//
			this.initialize();
		}
		
		protected var _originalDPI:int;
		
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		protected var _scaleToDPI:Boolean;
		
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}
		
		protected var _scale:Number;
		protected var _fontSize:int;
		
		protected function initialize():void
		{
			if(this._scaleToDPI)
			{
				//special case for ipad. should be same pixel size as iphone
				if(Capabilities.screenDPI % (ORIGINAL_DPI_IPAD_RETINA / 2) == 0)
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			else
			{
				this._originalDPI = Capabilities.screenDPI;
			}
			this._scale = Capabilities.screenDPI / this._originalDPI;
			
			this._fontSize = 30 * this._scale;
			
			
			this.setInitializerForClass(BitmapFontTextRenderer, labelInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, tabInitializer, "foxhole-tabbar-tab");
			this.setInitializerForClass(Button, headerButtonInitializer, "foxhole-header-item");
			this.setInitializerForClass(Button, scrollBarThumbInitializer, "foxhole-simple-scroll-bar-thumb");
			this.setInitializerForClass(Button, sliderThumbInitializer, "foxhole-slider-thumb");
			this.setInitializerForClass(Button, pickerListButtonInitializer, "foxhole-picker-list-button");
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, "foxhole-toggle-switch-on-track");
			this.setInitializerForClass(Button, nothingInitializer, "foxhole-slider-minimum-track");
			this.setInitializerForClass(Button, nothingInitializer, "foxhole-slider-maximum-track");
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(SimpleScrollBar, scrollBarInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);			
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(ScreenHeader, screenHeaderInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(Callout, calloutInitializer);
			
			//this.setInitializerForClass(PageRenderer, itemRendererInitializer); //jxtest
//			this.setInitializerForClass(JxRenderer, itemRendererInitializer); //jxtest
			
			this.setInitializerForClass(TextFieldTextRenderer , textlabelInitializer );
		
		}
		
		protected function nothingInitializer(nothing:FoxholeControl):void
		{
			
		}
		
		protected function labelInitializer(label:BitmapFontTextRenderer):void
		{
			if(label.name)
			{
				return;
			}
			label.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
		}
		
		protected function textlabelInitializer(label:TextFieldTextRenderer):void
		{
			var fontSize : int;
			if ( label.name == "sub_title" )
			{
				fontSize = this._fontSize *1.2 ; 
					
			}else if ( label.name == "title" )
			{
				fontSize = this._fontSize * 1.5 ;
			
			}else if ( label.name == "default" )
			{
				fontSize = this._fontSize;
				
			}else
			{
				return;
			}							
			label.textFormat = new TextFormat( null, fontSize, PRIMARY_TEXT_COLOR);
		}
		
		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = BUTTON_UP_SKIN_TEXTURES;
			skinSelector.defaultSelectedValue = BUTTON_DOWN_SKIN_TEXTURES;
			skinSelector.setValueForState(BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, false);
			skinSelector.setValueForState(BUTTON_DISABLED_SKIN_TEXTURES, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
				{
					width: 66 * this._scale,
						height: 66 * this._scale,
						textureScale: this._scale
				};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
			
			button.paddingTop = button.paddingBottom = 8 * this._scale;
			button.paddingLeft = button.paddingRight = 16 * this._scale;
			button.gap = 12 * this._scale;
			button.minWidth = button.minHeight = 66 * this._scale;
		}
		
		protected function pickerListButtonInitializer(button:Button):void
		{
			//styles for the pickerlist button come from above, and then we're
			//adding a little bit extra.
			this.buttonInitializer(button);
			
			const pickerListButtonDefaultIcon:Image = new Image(PICKER_ICON_TEXTURE);
			pickerListButtonDefaultIcon.scaleX = pickerListButtonDefaultIcon.scaleY = this._scale;
			button.defaultIcon = pickerListButtonDefaultIcon
			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
		}
		
		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			defaultSkin.width = 148 * this._scale;
			defaultSkin.height = 66 * this._scale;
			track.defaultSkin = defaultSkin;
			track.minTouchWidth = track.minTouchHeight = 88 * this._scale;
		}
		
		protected function scrollBarThumbInitializer(thumb:Button):void
		{
			const scrollBarDefaultSkin:Scale9Image = new Scale9Image(SCROLL_BAR_THUMB_SKIN_TEXTURES, this._scale);
			scrollBarDefaultSkin.width = 8 * this._scale;
			scrollBarDefaultSkin.height = 8 * this._scale;
			thumb.defaultSkin = scrollBarDefaultSkin;
			thumb.minTouchWidth = thumb.minTouchHeight = 12 * this._scale;
		}
		
		protected function sliderThumbInitializer(thumb:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = SLIDER_THUMB_UP_SKIN_TEXTURE;
			skinSelector.defaultSelectedValue = TAB_SELECTED_SKIN_TEXTURE;
			skinSelector.setValueForState(SLIDER_THUMB_DOWN_SKIN_TEXTURE, Button.STATE_DOWN, false);
			skinSelector.setValueForState(SLIDER_THUMB_DISABLED_SKIN_TEXTURE, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
				{
					width: 66 * this._scale,
						height: 66 * this._scale
				};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			
			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this._scale;
		}
		
		protected function tabInitializer(tab:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = TOOLBAR_BACKGROUND_SKIN_TEXTURE;
			skinSelector.defaultSelectedValue = TAB_SELECTED_SKIN_TEXTURE;
			skinSelector.setValueForState(TAB_SELECTED_SKIN_TEXTURE, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
				{
					width: 88 * this._scale,
						height: 88 * this._scale
				};
			tab.stateToSkinFunction = skinSelector.updateValue;
			
			tab.minWidth = tab.minHeight = 88 * this._scale;
			tab.minTouchWidth = tab.minTouchHeight = 88 * this._scale;
			tab.paddingTop = tab.paddingRight = tab.paddingBottom =
				tab.paddingLeft = 16 * this._scale;
			tab.gap = 12 * this._scale;
			tab.iconPosition = Button.ICON_POSITION_TOP;
			
			tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			tab.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
		}
		
		protected function headerButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = BUTTON_UP_SKIN_TEXTURES;
			skinSelector.defaultSelectedValue = BUTTON_DOWN_SKIN_TEXTURES;
			skinSelector.setValueForState(BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, false);
			skinSelector.setValueForState(BUTTON_DISABLED_SKIN_TEXTURES, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
				{
					width: 60 * this._scale,
						height: 60 * this._scale,
						textureScale: this._scale
				};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
			
			button.paddingTop = button.paddingBottom = 8 * this._scale;
			button.paddingLeft = button.paddingRight = 16 * this._scale;
			button.gap = 12 * this._scale;
			button.minWidth = button.minHeight = 60 * this._scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this._scale;
		}
		
		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_STRETCH;
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				var sliderMinimumTrackDefaultSkin:Scale3Image = new Scale3Image(VSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDefaultSkin.width *= this._scale;
				sliderMinimumTrackDefaultSkin.height = 198 * this._scale;
				var sliderMinimumTrackDownSkin:Scale3Image = new Scale3Image(VSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDownSkin.width *= this._scale;
				sliderMinimumTrackDownSkin.height = 198 * this._scale;
				var sliderMinimumTrackDisabledSkin:Scale3Image = new Scale3Image(VSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDisabledSkin.width *= this._scale;
				sliderMinimumTrackDisabledSkin.height = 198 * this._scale;
				slider.minimumTrackProperties.defaultSkin = sliderMinimumTrackDefaultSkin;
				slider.minimumTrackProperties.downSkin = sliderMinimumTrackDownSkin;
				slider.minimumTrackProperties.disabledSkin = sliderMinimumTrackDisabledSkin;
				
				var sliderMaximumTrackDefaultSkin:Scale3Image = new Scale3Image(VSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDefaultSkin.width *= this._scale;
				sliderMaximumTrackDefaultSkin.height = 198 * this._scale;
				var sliderMaximumTrackDownSkin:Scale3Image = new Scale3Image(VSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDownSkin.width *= this._scale;
				sliderMaximumTrackDownSkin.height = 198 * this._scale;
				var sliderMaximumTrackDisabledSkin:Scale3Image = new Scale3Image(VSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDisabledSkin.width *= this._scale;
				sliderMaximumTrackDisabledSkin.height = 198 * this._scale;
				slider.maximumTrackProperties.defaultSkin = sliderMaximumTrackDefaultSkin;
				slider.maximumTrackProperties.downSkin = sliderMaximumTrackDownSkin;
				slider.maximumTrackProperties.disabledSkin = sliderMaximumTrackDisabledSkin;
			}
			else //horizontal
			{
				sliderMinimumTrackDefaultSkin = new Scale3Image(HSLIDER_MINIMUM_TRACK_UP_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDefaultSkin.width = 198 * this._scale;
				sliderMinimumTrackDefaultSkin.height *= this._scale;
				sliderMinimumTrackDownSkin = new Scale3Image(HSLIDER_MINIMUM_TRACK_DOWN_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDownSkin.width = 198 * this._scale;
				sliderMinimumTrackDownSkin.height *= this._scale;
				sliderMinimumTrackDisabledSkin = new Scale3Image(HSLIDER_MINIMUM_TRACK_DISABLED_SKIN_TEXTURES, this._scale);
				sliderMinimumTrackDisabledSkin.width = 198 * this._scale;
				sliderMinimumTrackDisabledSkin.height *= this._scale;
				slider.minimumTrackProperties.defaultSkin = sliderMinimumTrackDefaultSkin;
				slider.minimumTrackProperties.downSkin = sliderMinimumTrackDownSkin;
				slider.minimumTrackProperties.disabledSkin = sliderMinimumTrackDisabledSkin;
				
				sliderMaximumTrackDefaultSkin = new Scale3Image(HSLIDER_MAXIMUM_TRACK_UP_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDefaultSkin.width = 198 * this._scale;
				sliderMaximumTrackDefaultSkin.height *= this._scale;
				sliderMaximumTrackDownSkin = new Scale3Image(HSLIDER_MAXIMUM_TRACK_DOWN_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDownSkin.width = 198 * this._scale;
				sliderMaximumTrackDownSkin.height *= this._scale;
				sliderMaximumTrackDisabledSkin = new Scale3Image(HSLIDER_MAXIMUM_TRACK_DISABLED_SKIN_TEXTURES, this._scale);
				sliderMaximumTrackDisabledSkin.width = 198 * this._scale;
				sliderMaximumTrackDisabledSkin.height *= this._scale;
				slider.maximumTrackProperties.defaultSkin = sliderMaximumTrackDefaultSkin;
				slider.maximumTrackProperties.downSkin = sliderMaximumTrackDownSkin;
				slider.maximumTrackProperties.disabledSkin = sliderMaximumTrackDisabledSkin;
			}
		}
		
		protected function scrollBarInitializer(scrollBar:SimpleScrollBar):void
		{
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom =
				scrollBar.paddingLeft = 2 * this._scale;
		}
		
		protected function checkInitializer(check:Check):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = CHECK_UP_ICON_TEXTURE;
			iconSelector.defaultSelectedValue = CHECK_SELECTED_UP_ICON_TEXTURE;
			iconSelector.setValueForState(CHECK_DOWN_ICON_TEXTURE, Button.STATE_DOWN, false);
			iconSelector.setValueForState(CHECK_DISABLED_ICON_TEXTURE, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(CHECK_SELECTED_DOWN_ICON_TEXTURE, Button.STATE_DOWN, true);
			iconSelector.setValueForState(CHECK_SELECTED_DISABLED_ICON_TEXTURE, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
				{
					scaleX: this._scale,
						scaleY: this._scale
				};
			check.stateToIconFunction = iconSelector.updateValue;
			
			check.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			check.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
			
			check.minTouchWidth = check.minTouchHeight = 88 * this._scale;
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}
		
		protected function radioInitializer(radio:Radio):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = RADIO_UP_ICON_TEXTURE;
			iconSelector.defaultSelectedValue = RADIO_SELECTED_UP_ICON_TEXTURE;
			iconSelector.setValueForState(RADIO_DOWN_ICON_TEXTURE, Button.STATE_DOWN, false);
			iconSelector.setValueForState(RADIO_DISABLED_ICON_TEXTURE, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(RADIO_SELECTED_DISABLED_ICON_TEXTURE, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
				{
					scaleX: this._scale,
						scaleY: this._scale
				};
			radio.stateToIconFunction = iconSelector.updateValue;
			
			radio.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			radio.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
			
			radio.minTouchWidth = radio.minTouchHeight = 88 * this._scale;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}
		
		protected function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			
			toggleSwitch.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			toggleSwitch.onLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
		}
		
		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			//jxtest - 這裏可以設定每個 renderer 的字體樣式
			//renderer.upTextFormat = new BitmapFontTextFormat(BITMAP_FONT, 90, 0xff0000);
			
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = LIST_ITEM_UP_TEXTURE;
			skinSelector.defaultSelectedValue = LIST_ITEM_DOWN_TEXTURE;
			skinSelector.setValueForState(LIST_ITEM_DOWN_TEXTURE, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
				{
					width: 88 * this._scale,
						height: 88 * this._scale,
						blendMode: BlendMode.NONE
				};
			renderer.stateToSkinFunction = skinSelector.updateValue;
			
			renderer.paddingTop = renderer.paddingBottom = 11 * this._scale;
			renderer.paddingLeft = renderer.paddingRight = 20 * this._scale;
			renderer.minWidth = 88 * this._scale;
			//renderer.minHeight = 88 * this._scale;
			//jx
			renderer.minHeight = 128 * this._scale;
			
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
					
		}
		
		private var textRendererFactory:Function = function():ITextRenderer
		{
			return new TextFieldTextRenderer();
		}
			
		
		private function transparentSkinFunc(target:Object, state:Object, oldValue:Object = null):Object
		{				
			//以下從skinSelector.updateValue抄來，可以減少new Image的次數，重覆使用舊的image
			var image:Image;
			return image;
		}	
		
		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const backgroundSkin:Image = new Image(GROUPED_LIST_HEADER_BACKGROUND_SKIN_TEXTURE);
			backgroundSkin.width = 44 * this._scale;
			backgroundSkin.height = 44 * this._scale;
			renderer.backgroundSkin = backgroundSkin;
			
			renderer.paddingTop = renderer.paddingBottom = 9 * this._scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this._scale;
			renderer.minWidth = renderer.minHeight = 44 * this._scale;
		}
		
		protected function pickerListInitializer(list:PickerList):void
		{
			if(PhysicalCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
					centerStage.marginLeft = 16 * this._scale;
				list.popUpContentManager = centerStage;
			}
			
			const layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = 0;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			list.listProperties.layout = layout;
			
			if(PhysicalCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = 264 * this._scale;
				list.listProperties.maxHeight = 352 * this._scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
				backgroundSkin.width = 20 * this._scale;
				backgroundSkin.height = 20 * this._scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = list.listProperties.paddingRight =
					list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this._scale;
			}
		}
		
		protected function screenHeaderInitializer(header:ScreenHeader):void
		{
			const backgroundSkin:Image = new Image(TOOLBAR_BACKGROUND_SKIN_TEXTURE);
			backgroundSkin.width = 88 * this._scale;
			backgroundSkin.height = 88 * this._scale;
			backgroundSkin.blendMode = BlendMode.NONE;
			header.backgroundSkin = backgroundSkin;			
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 14 * this._scale;
			header.minHeight = 88 * this._scale;
			
			header.titleFactory =  textRendererFactory;
			//因為ShelfListItemRenderer的labelFactory是用textRendererFactory，所以要設定字型時要用下面這個
			header.titleProperties.textFormat = new TextFormat( null,  this._fontSize, PRIMARY_TEXT_COLOR, true ); 
					
		}
		
		protected function textInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 66 * this._scale;
			input.minTouchWidth = input.minTouchHeight = 66 * this._scale;
			input.paddingTop = input.paddingBottom = 14 * this._scale;
			input.paddingLeft = input.paddingRight = 16 * this._scale;
			input.stageTextProperties.fontFamily = "Helvetica";
			input.stageTextProperties.fontSize = 30 * this._scale;
			input.stageTextProperties.color = 0xffffff;
			
			const backgroundSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = 264 * this._scale;
			backgroundSkin.height = 66 * this._scale;
			input.backgroundSkin = backgroundSkin;
			
			const backgroundDisabledSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_DISABLED_SKIN_TEXTURES, this._scale);
			backgroundDisabledSkin.width = 264 * this._scale;
			backgroundDisabledSkin.height = 66 * this._scale;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}
		
		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale3Image = new Scale3Image(PROGRESS_BAR_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 24) * this._scale;
			backgroundSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 24 : 264) * this._scale;
			progress.backgroundSkin = backgroundSkin;
			
			const backgroundDisabledSkin:Scale3Image = new Scale3Image(PROGRESS_BAR_BACKGROUND_DISABLED_SKIN_TEXTURES, this._scale);
			backgroundDisabledSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 24) * this._scale;
			backgroundDisabledSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 24 : 264) * this._scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;
			
			const fillSkin:Scale3Image = new Scale3Image(PROGRESS_BAR_FILL_SKIN_TEXTURES, this._scale);
			fillSkin.width = 24 * this._scale;
			fillSkin.height = 24 * this._scale;
			progress.fillSkin = fillSkin;
			
			const fillDisabledSkin:Scale3Image = new Scale3Image(PROGRESS_BAR_FILL_DISABLED_SKIN_TEXTURES, this._scale);
			fillDisabledSkin.width = 24 * this._scale;
			fillDisabledSkin.height = 24 * this._scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}
		
		protected function calloutInitializer(callout:Callout):void
		{
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 16 * this._scale;
			
			const backgroundSkin:Scale9Image = new Scale9Image(CALLOUT_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = 48 * this._scale;
			backgroundSkin.height = 48 * this._scale;
			callout.backgroundSkin = backgroundSkin;
			
			const topArrowSkin:Image = new Image(CALLOUT_TOP_ARROW_SKIN_TEXTURE);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this._scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = 0 * this._scale;
			
			const bottomArrowSkin:Image = new Image(CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this._scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -1 * this._scale;
			
			const leftArrowSkin:Image = new Image(CALLOUT_LEFT_ARROW_SKIN_TEXTURE);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this._scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = 0 * this._scale;
			
			const rightArrowSkin:Image = new Image(CALLOUT_RIGHT_ARROW_SKIN_TEXTURE);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this._scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -1 * this._scale;
		}
		
		protected function root_addedToStageHandler(event:Event):void
		{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
		}
		
	}
}


