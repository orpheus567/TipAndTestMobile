package com.darcey.gfx
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	import com.darcey.utils.RemoveAllChildrenIn;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class VideoPlayer extends Sprite
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		
		private var nc:NetConnection = new NetConnection();
		public var ns:NetStream;
		public var vid:Video;
		
		public var url:String = "assets/videos/v1.mp4";
		private var vw:Number = 640;
		private var vh:Number = 480;
		
		private var autoPlay:Boolean = true;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function VideoPlayer(url:String,videoW:Number=640,videoH:Number=480,autoPlay:Boolean=false,repeat:Boolean=true)
		{
			// Setup class specific tracer
			t = new Ttrace(true);
			t.ttrace("VideoPlayer(url:"+url+", videoW:"+videoW+", videoH:"+videoH+",autoPlay:" + autoPlay + ",repeat:" + repeat + ")");
			
			
			// Var ini
			this.url = url;
			vw = videoW;
			vh = videoH;
			this.autoPlay = autoPlay;
			
			vid = new Video(vw,vh);
			
			// Ini
			nc = new NetConnection();
			nc.addEventListener("netStatus", onNCStatus);
			nc.connect(null);
			addChild(vid); 
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		private var vpcc:VideoPlayerCustomClient;
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function onNCStatus(e:NetStatusEvent):void
		{
			t.ttrace("");
			t.ttrace("VideoPlayer.onNCStatus(e): " + e.type + "  " + e.info);
			
			
			t.ttrace("### e.info.code: " + e.info.code);
			
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					trace("You've connected successfully");
					ns = new NetStream(nc);
					//ns.client.onMetaData = onMetaDataHandler;
					//ns.client.onCuePoint = onCuePointHandler;
					vpcc = new VideoPlayerCustomClient();
					ns.client = vpcc;
					vpcc.addEventListener(Event.COMPLETE,playbackComplete);
					vid.attachNetStream(ns);
					ns.play(url);
					if (!autoPlay){
						ns.pause();
					}
					break;
				
				case "NetStream.Publish.BadName":
					trace("");
					trace("### VideoPlayer ERROR: Please check the name of the publishing stream [NetStream.Publish.BadName] url = [" + url + "]");
					trace("");
					break;
			}   
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function playbackComplete(e:Event):void
		{
			t.ttrace("##### VIDEO PLAYBACK COMPLETE #####");
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function onMetaDataHandler(o:Object):void
		{
			t.ttrace("VideoPlayer.onMetaDataHandler(o): " + o);
			
			/*
			// Resize video instance.
			video.width = item.width;
			video.height = item.height;
			// Center video instance on Stage.
			video.x = (stage.stageWidth - video.width) / 2;
			video.y = (stage.stageHeight - video.height) / 2;
			*/
		}  
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function onCuePointHandler(o:Object):void
		{
			t.ttrace("VideoPlayer.onCuePointHandler(o): " + o);
			//t.ttrace(o.name + "\t" + o.time);
		}  
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		public function play():void
		{
			t.ttrace("VideoPlayer.play()");
			ns.resume();
		}
		
		
		public function seek(time:Number):void
		{
			t.ttrace("VideoPlayer.seek(time:"+time+")");
			ns.seek(time);
		}
		
		public function resume():void
		{
			t.ttrace("VideoPlayer.resume()");
			ns.resume();
		}
		
		public function stop():void
		{
			t.ttrace("VideoPlayer.stop()");
			ns.pause();
			ns.seek(0);
		}
		
		public function dispose():void
		{
			t.ttrace("VideoPlayer.dispose()");
			new RemoveAllChildrenIn(this);
			
			try {
				ns.close();
				ns = null;
			} catch (e:Error) {}
			
			try {
				nc.close();
				nc = null;
			} catch (e:Error) {}
			
			try {
				vid.clear();
				vid = null;
			} catch (e:Error) {}
			
			
			try {
				vpcc.removeEventListener("playback complete",playbackComplete);
				vpcc = null;
			} catch (e:Error) {}
		}
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}