package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import orpheus.movieclip.TestButton;
	
	public class LoadImgLocalFile extends Sprite
	{
		private var $testBtn:MovieClip;
		private var $loader:Loader;
		public function LoadImgLocalFile()
		{
			
			super();
			trace("stage.stageWidth: ",stage.stageWidth);
			trace("stage.stageHeight: ",stage.stageHeight);
			$testBtn = TestButton.btn(500,375,0x666666);
			addChild($testBtn);
			$loader = new Loader
			var f:File=File.applicationDirectory.resolvePath("./assets/img/suji.jpg");
			trace("f.url: ",f.url);
			$loader.load(new URLRequest(f.url));
			addChild($loader);
		}
	}
}