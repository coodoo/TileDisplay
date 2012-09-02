package
{
	import justpinegames.Logi.Console;
		
		/**
		 * Helper package-level function. Usage is the same as for the trace statemen.
		 * 
		 * For data sent to the log function to be displayed, you need to first create a LogConsole instance, and add it to the Starling stage.
		 * 
		 * @param	... arguments   Variable number of arguments, which will be displayed in the log
		 */
		public function log(... arguments):void 
		{
			//jx: 正式 release 時，可能根本不放 console，因此 log 要判斷，並將訊息轉成 trace
			//也有可能我不想用 logi，只要用原本的 trace()，也一樣是這裏判斷
			if( Console.getMainConsoleInstance() == null )
				trace( arguments.join(" ") );
			
			//asc2.0，隨便傳個 obj 過去讓它可以跑
			Console.staticLogMessage.apply(this, arguments);
		}
		

}