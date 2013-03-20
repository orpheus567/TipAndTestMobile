package com.darcey.gfx
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class BitmapMerge
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		private var result:BitmapData;
		private var txt:TextField;
		private var tf:TextFormat;
		private var label:String = "";
		private var labelColor:Number = 0xFFCC00;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function merge(sourceBitmapData:BitmapData,bitmapDataToMerge:BitmapData):BitmapData
		{
			this.label = label;
			this.labelColor = labelColor;
			this.result = sourceBitmapData;
			
			result.draw(bitmapDataToMerge);
			return result;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function mergeWithTextLabel(sourceBitmapData:BitmapData,label:String="",labelColor:Number=0xFFFFFF):BitmapData
		{
			this.label = label;
			this.labelColor = labelColor;
			this.result = sourceBitmapData;
			
			createTextLabel();
			result.draw(txt);
			
			return result;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function createTextLabel():void
		{
			txt = new TextField();
			txt.text = label;
			txt.width = result.width;
			txt.height = result.height;
			
			tf = new TextFormat();
			tf.color = labelColor;
			txt.defaultTextFormat = tf;
			txt.setTextFormat(tf);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getMergedBitmapData():BitmapData
		{
			return result;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function dispose():void
		{
			result = null;
			txt = null;
			tf = null;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}