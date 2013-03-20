package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	import com.darcey.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class LoadXMLFile extends EventDispatcher
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		private var urlLoader:URLLoader;
		private var file:String;
		public var xmlData:XML;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function LoadXMLFile()
		{
			// Setup class specific tracer
			t = new Ttrace(true);
			t.ttrace("LoadXMLFile()");
			
			// Setup the loader
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			//_loader.addEventListener(IOErrorEvent.IO_ERROR, onDataFiledToLoad);
			//_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onDataFiledToLoad);
			//_loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onDataFiledToLoad);
			//_loader.addEventListener(IOErrorEvent.DISK_ERROR, onDataFiledToLoad);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function load(file:String,showTrace:Boolean):void
		{
			if (showTrace){
				t.enable();
			}
			t.ttrace("com.darcey.io.LoadXMLFile.load(file"+file+")");			
			
			this.file = file;
			urlLoader.load(new URLRequest(file));			
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function onIOError(e:IOErrorEvent):void
		{
			t.error("LoadXMLFile(): ERROR unable to load file [" + file + "]");
			dispatchEvent( e );
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function onCompleteHandler(e:Event):void
		{
			t.ttrace("com.darcey.io.LoadXMLFile.onCompleteHandler(e)");
			
			xmlData = new XML(e.target.data);
			
			urlLoader = null;
			file = null;
			
			dispatchEvent(e);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function dispose():void
		{
			urlLoader = null;
			file = null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}