package com.darcey.utils
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class AIRTools extends EventDispatcher
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public static function getAppVersion():String {
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber[0];
			return appVersion;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public static function dirList(path:String):String
		{
			// Setup class specific tracer
			var msg:String = "";
			msg += "----------------------------------------\n";
			//var directory:File = File.applicationDirectory;
			var directory:File = File.applicationDirectory.resolvePath(path);
				msg += "AIRTools.dirList("+path+"):\n";
			var contents:Array = directory.getDirectoryListing(); 
			for (var i:uint = 0; i < contents.length; i++) 
			{
				msg += contents[i].name + "  " + contents[i].size + "\n"; 
			}
			msg += "----------------------------------------\n";
			return msg;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}