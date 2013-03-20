package com.darcey.io.AIRPreloader
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class AIRPreloaderVO
	{
		public var fileType:String = "";
		public var localPath:String = "";
		public var fileName:String = "";
		public var name:String = "";
		
		public var loaded:Boolean = false;
		
		//public var fileStream:FileStream;
		public var string:String = "";
		public var byteArray:ByteArray = new ByteArray();
		public var bmp:Bitmap;
		public var bmpData:BitmapData;
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}