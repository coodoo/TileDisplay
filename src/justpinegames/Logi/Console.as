package justpinegames.Logi
{
	import com.gskinner.motion.GTweener;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import org.gestouch.core.GestureState;
	import org.gestouch.events.LongPressGestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.renderers.IListItemRenderer;
	import org.josht.starling.foxhole.controls.text.TextFieldTextRenderer;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;

	/**
	 * Main class, used to display console and handle its events.
	 */
	public class Console extends Sprite
	{
		private static var _console:Console;
		private static var _archiveOfUndisplayedLogs:Array = [];
		
		private var _consoleSettings:ConsoleSettings;
		private var _defaultFont:BitmapFont;
		
		private var _format:TextFormat;
//		private var _format:BitmapFontTextFormat;
		
		private var _formatBackground:TextFormat;
//		private var _formatBackground:BitmapFontTextFormat;
		
		private var _consoleContainer:Sprite;
//		private var _hudContainer:ScrollContainer;
		private var _consoleHeight:Number;
		private var _isShown:Boolean;
		private var copyButton:Button;
		private var _data:Array;
		private var quad:Quad;
		private var list:List;
		
		private const VERTICAL_PADDING: Number = 5;
		private const HORIZONTAL_PADDING: Number = 5;
		
		/**
		 * You need to create the instance of this class and add it to the stage in order to use this library.
		 * 
		 * @param	consoleSettings   Optional parameter which can specify the look and behaviour of the console.
		 */
		public function Console(consoleSettings:ConsoleSettings = null) 
		{
			_consoleSettings = consoleSettings ? consoleSettings : new ConsoleSettings();
			
			_console = _console ? _console : this;
			
			_data = [];
			
			_defaultFont = new BitmapFont();
//			_format = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textColor);
			_format = new TextFormat( "Arial", 16, _consoleSettings.textColor );
			_format.letterSpacing = 2;
			
			
//			_formatBackground = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textBackgroundColor);
			_formatBackground = new TextFormat( "Arial", 16, _consoleSettings.textBackgroundColor);
			_formatBackground.letterSpacing = 2;
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function get isShown():Boolean 
		{
			return _isShown;
		}
		
		public function set isShown(value:Boolean):void 
		{
			if (_isShown == value) 
			{
				return;
			}
			
			_isShown = value;
			
			if (_isShown) 
			{
				show();
			}
			else 
			{
				hide();
			}
		}
		
		private var downPoint:Point;
		
		private function longPressHandler( evt:LongPressGestureEvent ):void
		{
			//這樣可取得 gesture 物件
			var aGesture:Gesture = evt.target as Gesture;
			var xMove:Number;
			var yMove:Number;
			if( aGesture.state == GestureState.BEGAN )
			{
				downPoint = aGesture.location;
				
				flash();
			}
			else if( aGesture.state == GestureState.CHANGED )
			{
				xMove = aGesture.location.x - downPoint.x;
				yMove = aGesture.location.y - downPoint.y;
				
				downPoint = aGesture.location;
				this.x += xMove;
				this.y += yMove;
			}
			else if( aGesture.state == GestureState.ENDED )
			{
				downPoint = null;
			}
			
			//trace("\ngesture - ", aGesture.state, aGesture.location );
			
			//再下一層可取得目前操作的元件
//			var list:List = evt.target.target as List;
		}
		
		/**
		 * long press 成功時，閃一下提供視覺提示
		 */
		private function flash( b:Boolean = false ):void
		{
			this.alpha = b ? 1.0 : 0.1;
			
			setTimeout( flash, 30, true );
		}
		
		/**
		 * 進入點
		 */
		private function addedToStageHandler(e:starling.events.Event):void
		{
			var longTap:LongPressGesture = new LongPressGesture( this );
			longTap.addEventListener(LongPressGestureEvent.GESTURE_LONG_PRESS, longPressHandler, false, 0, true );
			
			//
			_consoleHeight = this.stage.stageHeight * _consoleSettings.consoleSize;
			
			_isShown = false;
			
			//ok
			_consoleContainer = new FoxholeControl();
			_consoleContainer.alpha = 0;
			_consoleContainer.y = -_consoleHeight;
			this.addChild(_consoleContainer);
			
			//這個是半透明底色
			quad = new Quad(this.stage.stageWidth, _consoleHeight, _consoleSettings.consoleBackground);
			quad.alpha = _consoleSettings.consoleTransparency;
			_consoleContainer.addChild(quad);
			
			//List
			list = new List();
			list.name = "fuck";
			list.scrollerProperties.horizontalScrollPolicy = "off";
			list.dataProvider = new ListCollection(_data);
			list.itemRendererFactory = function():IListItemRenderer 
			{
				var consoleItemRenderer:ConsoleItemRenderer = new ConsoleItemRenderer(_consoleSettings.textColor, _consoleSettings.highlightColor);
				consoleItemRenderer.width = list.width;
				consoleItemRenderer.height = 20;
				return consoleItemRenderer; 
			};
			
			_consoleContainer.addChild(list);
			
			//button
			copyButton = new Button();

			copyButton.label = "copy";
			copyButton.addEventListener(starling.events.Event.ADDED, function(e:starling.events.Event):void
			{
                copyButton.defaultLabelProperties.smoothing = TextureSmoothing.NONE;
                copyButton.downLabelProperties.smoothing = TextureSmoothing.NONE;

				copyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textColor);
				copyButton.downLabelProperties.textFormat = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.highlightColor);

                copyButton.stateToSkinFunction = function(target:Object, state:Object, oldValue:Object = null):Object
                {
                    return null;
                };

				copyButton.width = 60;
				copyButton.height = 20;
			});
			copyButton.onPress.add(copy);
			_consoleContainer.addChild(copyButton);
			
			//設定大小
			this.setScreenSize(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			
			for each (var undisplayedMessage:* in _archiveOfUndisplayedLogs) 
			{
				this.logMessage(undisplayedMessage);
			}
			
			_archiveOfUndisplayedLogs = [];
			
			Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, function(e:flash.events.Event):void 
			{
				setScreenSize(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			});
			
		}
		
		/**
		 * 這個等於 layout()
		 */
		private function setScreenSize(width:Number, height:Number):void 
		{
			_consoleContainer.width = width;
			_consoleContainer.height = height;
			
			//_consoleHeight = height * _consoleSettings.consoleSize;
			
			
			//list - jx
			list.width = 400//this.stage.stageWidth - HORIZONTAL_PADDING * 2;
			list.height = 150;//_consoleHeight - VERTICAL_PADDING * 2;
			list.x = width-list.width;
			list.y = height - list.height;
			//list.dataViewPort.setTypicalSize( list.width, 20 );
			
			//底色
			quad.width = list.width;
			quad.height = list.height;
			quad.x = list.x;
			quad.y = list.y;
			
			copyButton.x = list.x + list.width - copyButton.width - 4;
			copyButton.y = list.y + 2;
			
			if (!_isShown) 
			{
				_consoleContainer.y = -_consoleHeight;
			}
		}
		
		private function show():void 
		{
			//有可能 console 根本不存在
			try{
				_consoleContainer.visible = true;
				
				//jx: 對齊右下角
	//			GTweener.to(_consoleContainer, _consoleSettings.animationTime, { y: height -_consoleContainer.height, alpha: 1 } );
				GTweener.to(_consoleContainer, _consoleSettings.animationTime, { y: 0, alpha: 1 } );

			}catch(e:Error){}
			
			_isShown = true;
		}
		
		private function hide():void 
		{
			GTweener.to(_consoleContainer, _consoleSettings.animationTime, { y: -_consoleHeight, alpha: 0 }).onComplete = function():void 
			{
				_consoleContainer.visible = false;	
			};
			
			_isShown = false;
		}
		
//		private function copyLine(list:List):void
//		{
//			//Logi.log(list.selectedItem.data);
//		}
		
		/**
		 * You can use this data to save a log to the file.
		 * 
		 * @return  Log messages joined into a String with new lines.
		 */
		public function getLogData():String 
		{
			var text:String = "";
			
			for each (var object:Object in _data) 
			{
				text += object.data + "\n";
			}
			
			return text;
		}
		
		private function copy(button:Button):void
		{
			var text:String = this.getLogData();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}
		
		//jx: 移掉 msg 裏可能的 \n 之類
		private const removeSpace:RegExp = /\n|\t|\r/g;
		
		/**
		 * Displays the message string in the console, or on the HUD if the console is hidden.
		 * 
		 * @param	message   String to display
		 */
		public function logMessage(message:String):void 
		{
			
			if (_consoleSettings.traceEnabled)
			{
				trace(message);
			}
			
			//jx
			if( !stage )
				return;
			
//			var labelDisplay: String = (new Date()).toLocaleTimeString() + ": " + message;
			//jx: 我不要加時間，並且移除 \n 字元
			var stringToDisplay: String = message.replace(removeSpace, "");
			
			list.dataProvider.push({label: stringToDisplay, data: message});
			
			//jx: 改用 textfield，支援中文字
			var createLabel:Function = function(text:String, format:TextFormat):TextFieldTextRenderer
//			var createLabel:Function = function(text:String, format:BitmapFontTextFormat):BitmapFontTextRenderer
			{
				var label:TextFieldTextRenderer = new TextFieldTextRenderer();
				label.addEventListener(starling.events.Event.ADDED, function(e:starling.events.Event):void
				{
					label.textFormat = format;
				});
				label.text = text;
				label.validate();
				return label;
			};
			
			//捲到最下面
			list.verticalScrollPosition = list.maxVerticalScrollPosition;
		}
		
		/**
		 * Returns the fist created Console instance.
		 * 
		 * @return Console instance
		 */
		public static function getMainConsoleInstance():Console 
		{
			return _console;
		}
		
		/**
		* Main log function. Usage is the same as for the trace statement.
		* 
		* For data sent to the log function to be displayed, you need to first create a LogConsole instance, and add it to the Starling stage.
		* 
		* @param	... arguments   Variable number of arguments, which will be displayed in the log
		*/
		public static function staticLogMessage(... arguments):void 
		{
			var message:String = "";
			var firstTime:Boolean = true;
			
			for each (var argument:* in arguments)
			{
				var description:String;
				
				if (argument == null)
				{
					description = "[null]"
				}
				else if (!("toString" in argument)) 
				{
					description = "[object " + getQualifiedClassName(argument) + "]";
				}
				else 
				{
					description = argument;
				}
				
				if (firstTime)
				{
					message = description;
					firstTime = false;
				}
				else
				{
					message += " " + description;	//jx- 不想要 ,
//					message += ", " + description;
				}
			}
			
			if (Console.getMainConsoleInstance() == null ) 
			{
				_archiveOfUndisplayedLogs.push(message);
			}
			else
			{
				Console.getMainConsoleInstance().logMessage(message);
			}
		}
	}
}