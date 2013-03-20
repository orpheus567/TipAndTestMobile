package com.darcey.debug
{
	// Author: Darcey.Lloyd@gmail.com

	// ----------------------------------------------------------------------------------------------------
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	// ----------------------------------------------------------------------------------------------------

	
	// ----------------------------------------------------------------------------------------------------
	public class DebugBox extends Sprite
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var debugBoxTitle:String = "";
		private var debugBoxDefaultTitle:String = "DebugBox v1.3 - Click here to drag";
		private var grabBar:Sprite;
		private var closeButton:Sprite;
		public var txtArea:TextArea;
		private var ctrlKeyDown:Boolean = false;
		private var shiftKeyDown:Boolean = false;
		private var tf:TextFormat;
		private var txt:TextField;
		private var leftCtrlDown:Boolean = false;
		private var shiftDown:Boolean = false;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// Singleton -----------------------------------------------------------------------------------------------------------------
		public static var Singleton:DebugBox;
		public static function getInstance():DebugBox { if ( Singleton == null ){ Singleton = new DebugBox(); } return Singleton;}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function DebugBox()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function addedToStageHandler(e:Event):void
		{
			//trace("DebugBox: added to stage");
			
			grabBar.useHandCursor = true;
			grabBar.buttonMode = true;
			grabBar.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,true);
			grabBar.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);
			grabBar.addEventListener(MouseEvent.MOUSE_OUT,mouseUpHandler,false,0,true);
			stage.addEventListener(Event.MOUSE_LEAVE,mouseStageLeaveHandler,false,0,true);
			
			// Listen for key presses to show debug box
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		// ---------------------------------------------------------------------------------------------------------------------------
		public function removedFromStageHandler(e:Event):void
		{
			//trace("DebugBox: removed from stage");
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function init(w:Number = 300,h:Number = 200,visibleByDefault:Boolean=true,debugBoxTitle:String=""):void
		{
			// Ini pos
			this.x = 10;
			this.y = 10;
			this.debugBoxTitle = debugBoxTitle;
			
			// Top bar
			grabBar = new Sprite();
			grabBar.graphics.beginFill(0x333333,1);
			grabBar.graphics.drawRect(0,0,w,20);
			grabBar.graphics.endFill();
			grabBar.buttonMode = true;
			grabBar.useHandCursor = true;
			this.addChild(grabBar);
			
			// Top bar title
			tf = new TextFormat();
			tf.size = 11;
			tf.color = 0xFFFFFF;
			//tf.font = "PF Ronda Seven";
			
			txt = new TextField();
			txt.embedFonts = false;
			txt.width = w - 5;
			txt.height = h - 2;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.selectable = false;
			if (debugBoxTitle == ""){
				txt.text = debugBoxDefaultTitle;
			} else {
				txt.text = debugBoxTitle;
			}
			txt.defaultTextFormat = tf;
			txt.setTextFormat(tf);
			txt.mouseEnabled = false;
			this.addChild(txt);
			
			
			// Debug text box
			txtArea = new TextArea();
			txtArea.y = grabBar.y + grabBar.height;
			txtArea.editable = false;
			txtArea.width = w;
			txtArea.height = h;
			this.addChild(txtArea);
			
			// Close button
			closeButton = new Sprite();
			closeButton.graphics.beginFill(0x666666,1);
			closeButton.graphics.drawRect(0,0,20,20);
			closeButton.graphics.endFill();
			closeButton.graphics.lineStyle(2,0xFFFFFF,1);
			closeButton.graphics.moveTo(5,5);
			closeButton.graphics.lineTo(15,15);
			closeButton.graphics.moveTo(15,5);
			closeButton.graphics.lineTo(5,15);
			closeButton.x = w - closeButton.width;
			closeButton.buttonMode = true;
			closeButton.mouseEnabled = true;
			closeButton.useHandCursor = true;
			closeButton.addEventListener(MouseEvent.CLICK,closeButtonClickHandler);
			addChild(closeButton);
			
			// Show help
			//help();
			
			// Handle visibility
			this.visible = visibleByDefault;
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		protected function closeButtonClickHandler(event:MouseEvent):void
		{
			this.hide();
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function add(str:String):void
		{
			txtArea.text += str + "\n";
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function clear():void
		{
			txtArea.text = "";
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------------
		private function mouseStageLeaveHandler(e:Event):void
		{
			mouseUpHandler(null);
		}
		// ----------------------------------------------------------------------------------------------------
		
		// ----------------------------------------------------------------------------------------------------
		private function mouseDownHandler(e:MouseEvent):void
		{
			this.startDrag();
		}
		// ----------------------------------------------------------------------------------------------------
		
		// ----------------------------------------------------------------------------------------------------
		private function mouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		
		
		
		
		
		// ----------------------------------------------------------------------------------------------------
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 17: this.leftCtrlDown = true; return; break;
				case 16: this.shiftDown = true; return; break;
			}
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		
		
		// ----------------------------------------------------------------------------------------------------
		private function keyUpHandler(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			
			switch (e.keyCode)
			{
				case 17: this.leftCtrlDown = false; return; break;
				case 16: this.shiftDown = false; return; break;
				case 82: resetPosition(); return; break; // R
				case 68: toggleVisibility(); return; break; // D
				case 67: userClear(); return; break; // C
				case 72: help(); return; break; // H
			}
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function toggleVisibility():void
		{
			if (this.leftCtrlDown && this.shiftDown)
			{
				if (this.visible)
				{
					hide();
				} else {
					show();
				}
			}
		}
		// ----------------------------------------------------------------------------------------------------

		// ----------------------------------------------------------------------------------------------------
		public function resetPosition():void
		{
			if (this.leftCtrlDown && this.shiftDown)
			{
				this.visible = true;
				this.stopDrag();
				this.x = 10;
				this.y = 10;
			}
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function userClear():void
		{
			if (this.leftCtrlDown && this.shiftDown)
			{
				this.txtArea.text = "";
			}
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function show():void
		{
			this.visible = true;
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		// ----------------------------------------------------------------------------------------------------
		public function hide():void
		{
			this.visible = false;
		}
		// ----------------------------------------------------------------------------------------------------
		
		
		
		
		
		
		// ----------------------------------------------------------------------------------------------------
		public function help():void
		{
			var msg:String = "";

			msg = "#########################################################" + "\n";
			msg += "DebugBox(): Usage:" + "\n";
			msg += "\t" + "Press CTRL SHIFT D to toggle visibility" + "\n";
			msg += "\t" + "Press CTRL SHIFT R to reset position" + "\n";
			msg += "\t" + "Press CTRL SHIFT C to clear text" + "\n";
			msg += "\t" + "Press CTRL SHIFT H to for help" + "\n";
			msg += "#########################################################";
			add(msg);
			trace(msg);
		}
		// ----------------------------------------------------------------------------------------------------
		
		
	}
	// ----------------------------------------------------------------------------------------------------
}