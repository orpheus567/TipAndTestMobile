package texture
{
	import flash.utils.ByteArray;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ATFTextureTest extends Sprite
	{
		public function ATFTextureTest()
		{
			super();
		}
		[Embed(source="../assets/textures/1x/compressed_texture.atf", mimeType="application/octet-stream")]
		public static const CompressedData:Class;
		
		public function start():void{
			
			var data:ByteArray = new CompressedData();
			var texture:Texture = Texture.fromAtfData(data);
			
			var image:Image = new Image(texture);
			image.x = image.y = 500;
			addChild(image);		
		}
	}
}