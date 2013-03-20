package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class LoadImage
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		
		public var loader:Loader;
		public var urlRequest:URLRequest;
		
		public var sprite:Sprite;
		public var mc:MovieClip;
		public var url:String;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function LoadImage()
		{
			// Setup class specific tracer
			t = new Ttrace(false);
			t.ttrace("LoadImage()");
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function intoSprite(sprite:Sprite,url:String):void
		{
			t.ttrace("LoadImage.intoSprite(sprite:"+sprite+", url:"+url+")");
			
			this.sprite = sprite;
			this.url = url;
			
			loader = new Loader();
			urlRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, intoSpriteImageLoadedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			loader.load(urlRequest);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function intoSpriteImageLoadedHandler(e:Event):void
		{
			t.ttrace("LoadImage.intoSpriteImageLoadedHandler(e)");
			
			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, intoSpriteImageLoadedHandler);
			} catch (e:Error) {}
			
			
			sprite.addChild(loader.content);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function intoMovieClip(mc:MovieClip,url:String):void
		{
			t.ttrace("LoadImage.intoMovieClip(mc:"+mc+", url:"+url+")");
			
			this.mc = mc;
			this.url = url;
			
			loader = new Loader();
			urlRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, intoSpriteImageLoadedHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, intoMovieClipImageLoadedHandler,false,0,true);
			loader.load(urlRequest);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function intoMovieClipImageLoadedHandler(e:Event):void
		{
			t.ttrace("LoadImage.intoSpriteImageLoadedHandler(e)");
			
			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, intoMovieClipImageLoadedHandler,false);
			} catch (e:Error) {}
			
			
			mc.addChild(loader.content);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function ioErrorEventHandler(e:IOErrorEvent):void
		{
			t.div();
			t.warn("LoadImage.ioErrorEventHandler(e:IOErrorEvent):\n" + e);
			
			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, intoSpriteImageLoadedHandler);
			} catch (e:Error) {}
			
			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, intoMovieClipImageLoadedHandler);
			} catch (e:Error) {}
			
			try {
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			} catch (e:Error) {}
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}