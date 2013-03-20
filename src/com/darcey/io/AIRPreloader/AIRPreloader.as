package com.darcey.io.AIRPreloader
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.application.model.Variables;
	import com.darcey.debug.Ttrace;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class AIRPreloader extends EventDispatcher
	{
		// Singleton -----------------------------------------------------------------------------------------------------------------
		private static var Singleton:AIRPreloader;
		public static function getInstance():AIRPreloader { if ( Singleton == null ){ Singleton = new AIRPreloader(); } return Singleton;}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		public var items:Array;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function AIRPreloader()
		{
			// Setup class specific tracer
			t = new Ttrace(true);
			t.ttrace("AIRPreloader()");
			
			items = new Array(50);
			//items.push();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function addItem(fileType:String,localPath:String,fileName:String,name:String):void
		{
			t.ttrace("AIRPreloader.addItem(fileType:"+fileType+", localPath:"+localPath+", fileName:"+fileName+", name:"+name+")");
			
			
			var vo:AIRPreloaderVO = new AIRPreloaderVO();
			vo.fileType = fileType;
			vo.localPath = localPath;
			vo.fileName = fileName;
			vo.name = name;
			items.push(vo);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function start():void
		{
			t.ttrace("AIRPreloader.start()");
			
			loadQue();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		private var stringFile:File;
		private var activeVO:AIRPreloaderVO;
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function loadQue():void
		{
			
			var v:AIRPreloaderVO = getNextVOToLoad();
			var loader:Loader;
			var fulllocalPath:String = "";
			var file:File;
			
			if (v != null){
				activeVO = v;
				
				fulllocalPath = v.localPath + "/" + v.fileName;
				t.ttrace("AIRPreloader.loadQue(vo): Loading: name = " + v.name);
				t.ttrace("AIRPreloader.loadQue(vo): fileType = " + v.fileType + "   fulllocalPath = " + fulllocalPath);
				
				// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
				switch (v.fileType)
				{
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					case "std":
						loader = new Loader();
						var urlReq:URLRequest = new URLRequest(fulllocalPath);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, urlRequestLoaded,false,0,true);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,urlRequestIOError,false,0,true);
						loader.load(urlReq);
					break;
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					case "image":
						file = File.documentsDirectory.resolvePath(v.localPath + "/" + v.fileName);
						if (file.exists){
							var fsImage:FileStream = new FileStream();
							fsImage.open(file, FileMode.READ);
							fsImage.readBytes(v.byteArray);
							//v.byteArray.uncompress(CompressionAlgorithm.ZLIB); //uncompresses the byteArray
							loader = new Loader();
							fsImage.close();
							loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, urlRequestIOErrorHandler,false,0,true);
							loader.contentLoaderInfo.addEventListener(Event.COMPLETE, urlRequestLoaded,false,0,true);
							loader.loadBytes( v.byteArray );
							//v.loaded = true;
							//loadQue();
						} else {
							t.wdiv();
							t.ttrace("#### ERROR ##### AIRPreloader.loadQue(): File not found [" + file.nativePath + "]");
							t.wdiv();
							dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
						}
						break;
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					case "string":
						
						file = File.documentsDirectory.resolvePath(v.localPath + "/" + v.fileName);
						if (file.exists){
							var fsString:FileStream = new FileStream();
							fsString.open(file, FileMode.READ);
							v.string = fsString.readUTFBytes(fsString.bytesAvailable);
							fsString.close();
							v.string = v.string.replace(File.lineEnding, "\n");
							v.loaded = true;
							loadQue();
						} else {
							t.wdiv();
							t.ttrace("#### ERROR ##### AIRPreloader.loadQue(): File not found [" + file.nativePath + "]");
							t.wdiv();
							dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
						}
						
						break;
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					
					
					
					
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
					default: 
						file = File.documentsDirectory.resolvePath(v.localPath + "/" + v.fileName);
						if (file.exists){
							var fsDefault:FileStream = new FileStream();
							fsDefault.open(file, FileMode.READ);
							//v.fileStream = fs;
							v.byteArray = new ByteArray();
							fsDefault.readBytes(v.byteArray,0,fsDefault.bytesAvailable);
							fsDefault.close();
							
							v.loaded = true;
							loadQue();
						} else {
							t.wdiv();
							t.ttrace("#### ERROR ##### AIRPreloader.loadQue(): File not found [" + file.nativePath + "]");
							t.wdiv();
							dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
						}
					break;
					// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
				}
			} else {
				dispatchEvent( new Event(Event.COMPLETE) );
			}
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function stringFileLoadedHandler(e:Event):void
		{
			t.ttrace("AIRPreloader.stringFileLoadedHandler(e): e.data = " + e);
			
			
			/*
			var bytes:ByteArray = e.data; 
			str = bytes.readUTFBytes(bytes.length); 
			air.trace(str);
			
			activeVO.string = e.
			
			loadQue();
			*/
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function urlRequestIOErrorHandler(e:IOErrorEvent):void
		{
			t.wdiv();
			t.force("AIRPreloader.urlRequestIOErrorHandler(e)");
			t.force(e.text + " - " + e.type);
			t.wdiv();
			
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function urlRequestLoaded(e:Event):void
		{
			t.ttrace("AIRPreloader.urlRequestLoaded(e): " + activeVO.localPath + "/" + activeVO.fileName + " [LOADED]");
			
			var bmp:Bitmap = e.target.content as Bitmap;
			activeVO.bmp = bmp;
			activeVO.bmpData = bmp.bitmapData;
			activeVO.loaded = true;
			//Variables.stage.addChild(activeVO.bmp);
			loadQue();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function urlRequestIOError(e:IOErrorEvent):void
		{
			t.ttrace("AIRPreloader.urlRequestIOError(e): e.text = " + e.text);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function getNextVOToLoad():AIRPreloaderVO
		{
			for each (var v:AIRPreloaderVO in items)
			{
				if (!v.loaded){
					return v;
					break;
				}
			}
			return null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getVOByName(name:String):AIRPreloaderVO
		{
			for each (var v:AIRPreloaderVO in items)
			{
				if (v.name == name){
					return v;
					break;
				}
			}
			
			
			t.wdiv();
			t.force("AIRPreloader.getVOByName(name:"+name+"): NOT FOUND");
			t.wdiv();
			
			return null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getBitmapByItemName(name:String):Bitmap
		{
			var v:AIRPreloaderVO = getVOByName(name);
			return v.bmp;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getBitmapDataByItemName(name:String):BitmapData
		{
			var v:AIRPreloaderVO = getVOByName(name);
			return v.bmpData;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}