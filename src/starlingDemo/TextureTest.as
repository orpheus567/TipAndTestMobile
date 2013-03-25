package starlingDemo
{
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import starlingDemo.utils.ProgressBar;
	
	public class TextureTest extends Sprite
	{
		private static var sAssets:AssetManager;
		private var mLoadingProgress:ProgressBar;
		private var mMovie:MovieClip;
		public function TextureTest()
		{
			trace("xxxxxxxxxxxxxxxxx");
			super();
		}
		public function start(background:Texture, assets:AssetManager):void
		{
			trace("start");
			sAssets = assets;
			
			
			// The AssetManager contains all the raw asset data, but has not created the textures
			// yet. This takes some time (the assets might be loaded from disk or even via the
			// network), during which we display a progress indicator. 
			
			mLoadingProgress = new ProgressBar(175, 20);
			mLoadingProgress.x = (background.width  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (background.height - mLoadingProgress.height) / 2;
			mLoadingProgress.y = background.height * 0.7;
			addChild(mLoadingProgress);
			trace("aaaa");
			assets.loadQueue(function(ratio:Number):void
			{
			trace("bbbbbb");
				mLoadingProgress.ratio = ratio;
				
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						mLoadingProgress.removeFromParent(true);
						mLoadingProgress = null;
						showMainMenu();
					}
						, 0.15);
			});
			
			addEventListener(Event.TRIGGERED, onButtonTriggered);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}		
		public static function get assets():AssetManager { return sAssets; }		
		protected function onKey(event:KeyboardEvent):void
		{
			
		}
		
		protected function onButtonTriggered(event:Event):void
		{
			
		}
		private function showMainMenu():void
		{
			trace("showMainMenu");
			var frames:Vector.<Texture> = TextureTest.assets.getTextures("flight");
			mMovie = new MovieClip(frames, 15);
			
			mMovie.x = Constants.CenterX - int(mMovie.width / 2);
			mMovie.y = Constants.CenterY - int(mMovie.height / 2);
			addChild(mMovie);
			
			// like any animation, the movie needs to be added to the juggler!
			// this is the recommended way to do that.
			Starling.juggler.add(mMovie);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage():void
		{
		}
		
		private function onRemovedFromStage():void
		{
			Starling.juggler.remove(mMovie);
		}
	}
}