package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class AIRFileDownloader extends EventDispatcher
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		
		private var cache:Boolean = false;
		private var localPath:String = "";
		private var fileName:String = "";
		private var remotePathWithFileName:String = "";
		
		private var urlStream:URLStream;  
		private var fileData:ByteArray = new ByteArray(); 
		private var localFile:File;
		
		private var fileStream:FileStream;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function AIRFileDownloader(cache:Boolean,localPath:String,fileName:String,remotePathWithFileName:String)
		{
			// Setup class specific tracer
			t = new Ttrace(false);
			t.ttrace("AIRFileDownloader(cache:"+cache+", localPath:"+localPath+", fileName:" + fileName + ", remotePathWithFileName:"+remotePathWithFileName+")");
			
			// var ini
			this.cache = cache;
			this.localPath = localPath;
			this.fileName = fileName;
			this.remotePathWithFileName = remotePathWithFileName;
			
			if (!cache){
				this.remotePathWithFileName += "?r=" + Math.random()*99999999999;
			}
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function download():void
		{
			t.ttrace("AIRFileDownloader.download(): Downloading [" + remotePathWithFileName + "]");
			
			urlStream = new URLStream();
			var urlReq:URLRequest = new URLRequest(remotePathWithFileName); 
			urlStream.addEventListener(ProgressEvent.PROGRESS,downloadProgressHandler);
			urlStream.addEventListener(Event.COMPLETE, fileDownloadedHandler);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR,downloadErrorHandler); 
			urlStream.load(urlReq);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function downloadErrorHandler(e:IOErrorEvent):void
		{
			t.wdiv();
			t.force("#### ERROR #### AIRFileDownloader.downloadErrorHandler(e):\n[" + e.text + "]");
			t.wdiv();
		}
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
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
		private function fileDownloadedHandler(e:Event):void  
		{  
			t.ttrace("AIRDownloadAndSave.fileDownloadedHandler(e)");
			
			try {
				urlStream.removeEventListener(ProgressEvent.PROGRESS,downloadProgressHandler);
			} catch (e:Error) {}
			
			try {
				urlStream.removeEventListener(Event.COMPLETE, fileDownloadedHandler);
			} catch (e:Error) {}
			
			try {
				urlStream.removeEventListener(IOErrorEvent.IO_ERROR,downloadErrorHandler);
			} catch (e:Error) {}
			
			urlStream.readBytes (fileData, 0, urlStream.bytesAvailable);  
			saveFile();  
		}  
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function saveFile():void  
		{  
			t.ttrace("AIRFileDownloader.saveFile(): Saving to [" + this.localPath + "/" + this.fileName + "]");
			
			localFile = File.documentsDirectory.resolvePath( this.localPath + "/" + this.fileName );
			
			fileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR,fileSaveErrorHandler);
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.openAsync(localFile, FileMode.WRITE);  
			fileStream.writeBytes(fileData, 0, fileData.length);  
			fileStream.close();  
		} 
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function fileSaveErrorHandler(e:IOErrorEvent):void
		{
			t.wdiv();
			t.force("#### ERROR #### AIRFileDownloader.fileSaveErrorHandler(e):\n[" + e.text + "]");
			t.wdiv();
		}
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		private function fileClosed(e:Event):void  
		{  
			t.ttrace("AIRFileDownloader.fileClosed(e)");
			
			fileStream.removeEventListener(IOErrorEvent.IO_ERROR,fileSaveErrorHandler);
			fileStream.removeEventListener(Event.CLOSE, fileClosed);
			
			dispatchEvent( new Event(Event.COMPLETE) );
			dispose();
		}
		// -------------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function dispose():void
		{
			t.ttrace("AIRFileDownloader.dispose()");
			
			localFile = null;
			fileStream = null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}