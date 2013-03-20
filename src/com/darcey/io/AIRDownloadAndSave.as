package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	import com.darcey.utils.AIRTools;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class AIRDownloadAndSave extends EventDispatcher
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		
		private var cacheEnabled:Boolean = true;
		
		private var file:File;
		private var path:String;
		private var fileName:String;
		private var targetDir:String;
		
		private var urlStream:URLStream;  
		private var fileData:ByteArray = new ByteArray(); 
		private var fileLocal:File;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function AIRDownloadAndSave(cacheEnabled:Boolean)
		{
			// Setup class specific tracer
			t = new Ttrace(true);
			t.ttrace("AIRDownloadAndSave(cacheEnabled:"+cacheEnabled+")");
			
			this.cacheEnabled = cacheEnabled;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function start(path:String,fileName:String,targetDir:String):void
		{
			t.ttrace("AIRDownloadAndSave.start(path, fileName, targetDir)");
			
			this.path = path;
			this.fileName = fileName;
			this.targetDir = targetDir;
			
			if (!cacheEnabled){
				this.path += "?r=" + getRandomNumber();
			}
			
			downloadFile();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function downloadFile():void
		{
			t.ttrace("AIRDownloadAndSave.downloadFile(): cacheEnabled = " + cacheEnabled);
			t.ttrace("AIRDownloadAndSave.downloadFile(): path = " + path);
			t.ttrace("AIRDownloadAndSave.downloadFile(): fileName = " + fileName);
			t.ttrace("AIRDownloadAndSave.downloadFile(): targetDir = " + targetDir);
			
			urlStream = new URLStream();
			var urlReq:URLRequest = new URLRequest(path); 
			urlStream.addEventListener(ProgressEvent.PROGRESS,downloadProgressHandler);
			urlStream.addEventListener(Event.COMPLETE, loaded); 
			urlStream.load(urlReq);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function downloadProgressHandler(e:ProgressEvent):void
		{
			var p:Number = (100/e.bytesTotal) * e.bytesLoaded;
			p *= 100;
			p = Math.round(p);
			p /= 100;
			//t.ttrace("AIRDownloadAndSave.downloadProgressHandler(e): Downloaded " + p + "%");
			//txt.text = "Downloading file [" + downloadFile + "] - " + p + "%";
			
			dispatchEvent(e);
		}
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function loaded(event:Event):void  
		{  
			t.ttrace("AIRDownloadAndSave.loaded(event)");
			
			try {
				urlStream.removeEventListener(ProgressEvent.PROGRESS,downloadProgressHandler);
			} catch (e:Error) {}
			
			try {
				urlStream.removeEventListener(Event.COMPLETE, loaded);
			} catch (e:Error) {}
			
			urlStream.readBytes (fileData, 0, urlStream.bytesAvailable);  
			saveFile();  
		}  
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function saveFile():void  
		{  
			t.div();
			t.ttrace("AIRDownloadAndSave.saveFile()");
			
			var fullTargetPathAndName:String = (targetDir + "/" + fileName);
			t.ttrace("AIRDownloadAndSave.saveFile(): targetDir = " + targetDir);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileName = " + fileName);
			t.ttrace("AIRDownloadAndSave.saveFile(): fullTargetPathAndName = " + fullTargetPathAndName);
			
			fileLocal = File.applicationStorageDirectory.resolvePath(fullTargetPathAndName);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal = " + fileLocal);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal.exists = " + fileLocal.exists);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal.isDirectory = " + fileLocal.isDirectory);
			
			var fileStream:FileStream = new FileStream();  
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.openAsync(fileLocal, FileMode.WRITE);  
			fileStream.writeBytes(fileData, 0, fileData.length);  
			fileStream.close();  
			
			/*
			var dirToCreate:String = File.documentsDirectory.nativePath + "/Presentation/assets/images";
			var directoryToCreate:File = File.documentsDirectory.resolvePath(dirToCreate);
			t.ttrace("#### CREATING: " + directoryToCreate.nativePath);
			directoryToCreate.createDirectory();
			
			

			
			//var dir:File = new File;
			//var dir:File = new File(targetDir);
			var dir:File = File.applicationStorageDirectory.resolvePath(targetDir);
			t.ttrace("AIRDownloadAndSave.saveFile(): Directory check for: " + targetDir);
			t.ttrace("AIRDownloadAndSave.saveFile(): dir.exists = " + dir.exists);
			t.ttrace("AIRDownloadAndSave.saveFile(): dir.isDirectory = " + dir.isDirectory);
			if (dir.exists == false){
				t.ttrace("AIRDownloadAndSave.saveFile(): Attempting to create directory: " + targetDir);
				//dir.createDirectory();
				File.applicationDirectory.resolvePath(targetDir);
			}
			
			t.ttrace("--------------: Attempting to create dir2 Resources/assets/images");
			var dir2:File = File.applicationStorageDirectory.resolvePath("/Applications/Presnetation.app/Contents/Resources/assets/images");
			dir2.createDirectory();
			
			
			fileLocal = File.applicationStorageDirectory.resolvePath(fullTargetPathAndName);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal = " + fileLocal);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal.exists = " + fileLocal.exists);
			t.ttrace("AIRDownloadAndSave.saveFile(): fileLocal.isDirectory = " + fileLocal.isDirectory);
			
			
			
			
			var fileStream:FileStream = new FileStream();  
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.openAsync(fileLocal, FileMode.WRITE);  
			fileStream.writeBytes(fileData, 0, fileData.length);  
			fileStream.close();  
			*/
		} 
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function fileClosed(e:Event):void  
		{  
			t.ttrace("AirTest.fileClosed(e)");
			dispatchEvent( new Event(Event.COMPLETE) );
			dispose();
		}
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function dispose():void
		{
			t.ttrace("AIRDownloadAndSave.dispose()");
			
			file = null;
			urlStream = null;  
			fileData = null; 
			fileLocal =  null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function getRandomNumber():Number
		{
			return Math.round(Math.random()*999999999999);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}