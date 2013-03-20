package com.darcey.gfx
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class BitmapSplit
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		
		private var bmpData:BitmapData;
		private var divisionsX:Number = 0;
		private var divisionsY:Number = 0;
		
		private var tileW:Number = 0;
		private var tileH:Number = 0;
		
		private var bmpDataArray:Array;
		public function getBitmapDataArray():Array { return bmpDataArray; }
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function BitmapSplit(bmpData:BitmapData,divisionsX:Number,divisionsY:Number)
		{
			// Setup class specific tracer
			t = new Ttrace(false);
			t.ttrace("BitmapSplit(bmpData, divisionsX:"+divisionsX+", divisionsY:"+divisionsY+"): use getBitmapDataArray() to retrieve 2D dimensional array");
			
			// Var ini
			this.bmpData = bmpData;
			this.divisionsX = divisionsX;
			this.divisionsY = divisionsY;
			
			tileW = bmpData.width / divisionsX;
			tileH = bmpData.height / divisionsY;
			
			bmpDataArray = new Array();
			
			// Chop it up
			for (var x:int = 0; x < divisionsX; x++) 
			{
				bmpDataArray[x] = new Array();
				
				for (var y:int = 0; y < divisionsY; y++) 
				{
					var tempData:BitmapData = new BitmapData(tileW,tileH);
					var tempRect:Rectangle = new Rectangle((tileW * x),(tileH * y),tileW,tileH);
					tempData.copyPixels(bmpData,tempRect,new Point(0,0));
					bmpDataArray[x][y] = tempData;
					//trace("["+x+"]["+x+"]: w:" + tempData.width + " h:" + tempData.height);
					//bmp = new Bitmap(tempData);
					//addChild(bmp);
				}
			}			
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}