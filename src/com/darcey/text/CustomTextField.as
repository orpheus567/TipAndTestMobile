package com.darcey.text
{
	// -------------------------------------------------------------------------------------------		
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	// -------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------
	public class CustomTextField extends TextField
	{
		// -------------------------------------------------------------------------------------------
		private var cVO:CustomTextFieldVO;
		private var tf:TextFormat;
		// -------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------
		//http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html
		//http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html
		// -------------------------------------------------------------------------------------------
		public function CustomTextField(customTextFieldVO:CustomTextFieldVO)
		{
			tf = new TextFormat();
			this.cVO = customTextFieldVO;
			applySettings();
		}
		// -------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------
		public function applySettings():void
		{
			tf.font = cVO.font;
			tf.size = cVO.size;
			tf.color = cVO.color;
			tf.align = cVO.align;
			tf.bold = cVO.bold;
			tf.leading = cVO.leading
			
			this.embedFonts = cVO.embedFonts;
			
			this.multiline = cVO.multiLine;
			this.wordWrap = cVO.wordWrap;
			this.selectable = cVO.selectable;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.autoSize = cVO.autoSize;
						
			this.border = cVO.border;
			this.borderColor = cVO.borderColor;
			
			
			if (cVO.width > -1){
				this.width = cVO.width;
			}
			
			if (cVO.height > -1){
				this.height = cVO.height;
			}
			
			
			if (cVO.html == 1){
				this.htmlText = cVO.label;
			} else {
				this.text = cVO.label;
			}
			this.defaultTextFormat = tf;
			this.setTextFormat(tf);
		}
		// -------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------
		public function updateFromVO(customTextFieldVO:CustomTextFieldVO):void
		{
			this.cVO = customTextFieldVO;
			applySettings();
		}
		// -------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------
		public function applyFormat():void
		{
			this.defaultTextFormat = tf;
			this.setTextFormat(tf);
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		private function updateFromLocalyChangedVO():void
		{
			applySettings();
			this.defaultTextFormat = tf;
			this.setTextFormat(tf);
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		public function set fontSize(n:Number):void
		{
			cVO.size = n;
			tf.size = cVO.size;
			updateFromLocalyChangedVO();
		}
		public function get fontSize():Number
		{
			return Number(tf.size);
		}
		// -------------------------------------------------------------------------------------------
		
		
		// -------------------------------------------------------------------------------------------
		public function set leading(n:int):void
		{
			cVO.leading = n;
			tf.leading = cVO.leading;
			updateFromLocalyChangedVO();
		}
		public function get lineHeight():int
		{
			return int(tf.leading);
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		
		// -------------------------------------------------------------------------------------------
		public function set label(label:String):void
		{
			cVO.label = label
			updateFromLocalyChangedVO();
		}
		public function get label():String
		{
			return cVO.label;
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		
		
		
		// -------------------------------------------------------------------------------------------
		public function dispose():void
		{
			tf = null;
			this.cVO = null;
		}
		// -------------------------------------------------------------------------------------------
	}
}