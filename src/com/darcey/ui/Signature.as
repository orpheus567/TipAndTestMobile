package com.darcey.ui
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	// ------------------------------------------------------------------------------------------------
	public class Signature extends Sprite
	{
		// Singleton -----------------------------------------------------------------------------------------------------------------
		private static var Singleton:Signature;
		public static function getInstance():Signature { if ( Singleton == null ){ Singleton = new Signature(); } return Singleton;}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		// ------------------------------------------------------------------------------------------------
		private var txt:TextField;
		private var tf:TextFormat;
		
		private var color:Number = 0xFFFFFF;
		private var size:Number = 14;
		private var msg:String = "";
		// ------------------------------------------------------------------------------------------------
		
		// ------------------------------------------------------------------------------------------------
		public function Signature(msg:String = "Darcey@AllForTheCode.co.uk - Developer Examples",color:Number=0xFFFFFF,size:Number=14)
		{
			
			
		}
		// ------------------------------------------------------------------------------------------------
		
		
		// ------------------------------------------------------------------------------------------------
		public function init():void
		{
			this.color = color;
			this.size = size;
			this.msg = msg;
			
			tf = new TextFormat();
			tf.color = color;
			tf.size = size;
			tf.font = "Arial";
			
			txt = new TextField();
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = tf;
			addChild(txt);
			
			update(msg);
		}
		// ------------------------------------------------------------------------------------------------
		
		
		// ------------------------------------------------------------------------------------------------
		public function update(label:String):void
		{
			txt.text = label;
			txt.defaultTextFormat = tf;
			txt.setTextFormat(tf);
		}
		// ------------------------------------------------------------------------------------------------
	}
	// ------------------------------------------------------------------------------------------------
}