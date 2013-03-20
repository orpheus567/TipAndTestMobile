package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	
	import flash.external.ExternalInterface;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class JavaScriptNotification
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function JavaScriptNotification(str:String,jsFunctionName:String)
		{
			// Setup class specific tracer
			t = new Ttrace(false);
			t.ttrace("JavaScriptNotification(str:"+str+",jsFunctionName:"+jsFunctionName+")");
			
			
			var isAvailable:Boolean = ExternalInterface.available;
			if (isAvailable){
				try {
					ExternalInterface.call(jsFunctionName,str);
				} catch(e:Error) {
					t.warn("JavaScriptNotification.SendStringToJavaScript(): Failed - " + e);
				}
			} else {
				t.warn("JavaScriptNotification(): External Interface is not available - No message sent!");
			}
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}