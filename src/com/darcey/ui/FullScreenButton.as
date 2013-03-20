package com.darcey.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// ------------------------------------------------------------------------------------------------
	public class FullScreenButton extends Sprite
	{
		// ------------------------------------------------------------------------------------------------
		private var bmp:Bitmap;
		private var txt:TextField;
		private var tf:TextFormat;
		
		private var color:Number = 0xFFFFFF;
		private var size:Number = 14;
		// ------------------------------------------------------------------------------------------------
		
		// ------------------------------------------------------------------------------------------------
		public function FullScreenButton(label:String="TOGGLE FULL SCREEN",bmp:Bitmap=null)
		{
			this.color = 0xFFFFFF;
			this.size = 14;
			
			if (bmp == null){
				
				tf = new TextFormat();
				tf.color = color;
				tf.size = size;
				tf.font = "Arial";
				
				txt = new TextField();
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = label;
				txt.defaultTextFormat = tf;
				txt.setTextFormat(tf);
				addChild(txt);
				
				this.graphics.beginFill(0x666666);
				this.graphics.drawRect(0,0,this.width+10,this.height+10);
				this.graphics.endFill();
				txt.x = 5;
				txt.y = 5;
				
				
				txt.mouseEnabled = false;
			} else {
				addChild(bmp);
			}
			
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK,toggleFullScreen);
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		private function toggleFullScreen(e:MouseEvent):void
		{
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState=StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState=StageDisplayState.NORMAL;
			}
		}
		// ------------------------------------------------------------------------------------------------
	}
	// ------------------------------------------------------------------------------------------------
}