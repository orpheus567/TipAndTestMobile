package
{
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	import com.darcey.debug.Ttrace;
	import com.darcey.gfx.VideoPlayer;
	import com.darcey.ui.Signature;
	import com.darcey.utils.AIRTools;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	[SWF(frameRate="30",backgroundColor="#000000")]
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	public class AIRMobile2DVideoTest2 extends Sprite
	{
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		private var t:Ttrace;
		private var txt:TextField;
		private var videoPlayer:VideoPlayer;
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		public function AIRMobile2DVideoTest2()
		{
			// Setup class specific tracer
			t = new Ttrace(true,"DEBUG",true,false,"DEBUG: Email Darcey@AllForTheCode.co.uk",980,700);
			t.ttrace("AIRMobile2DVideoTest2()");
			t.ttrace("AIR:" + NativeApplication.nativeApplication.runtimeVersion);
			t.ttrace("APP VERSION: " + AIRTools.getAppVersion() );
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
		private function addedToStageHandler(e:Event):void
		{
			t.ttrace("AIRMobile2DVideoTest2.addedToStageHandler(e)");
			
			// Clean up added to stage listener
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			
			// Stage scaling and pos
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Video player
			videoPlayer = new VideoPlayer("http://www.allforthecode.co.uk/dev/air/AIRMobile2DVideoPlaybackStreamed/video.f4v",stage.stageWidth,stage.stageHeight,true,true);
			addChild(videoPlayer);
			videoPlayer.play();
			
			// Signature
			txt = new TextField();
			txt.width = stage.stageWidth;
			txt.height = 24;
			txt.background = true;
			txt.text = "Darcey@AllForTheCode.co.uk - AIR Android Mobile 2D (mp4) Video streamed playback.";
			addChild(txt);
		}
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		
	}
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}