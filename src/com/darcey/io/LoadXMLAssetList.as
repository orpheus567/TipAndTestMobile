/*
Requires an XML input like so:

<xml>

<assets>
<!-- Main SWF -->
<asset name="plantapledge" type="swf" sizeInKB="1024" file="plantapledge.swf" />

<!-- XML -->
<asset name="config" type="xml" sizeInKB="2" file="assets/plantapledge/xml/config.xml" preventCaching="1" />
<asset name="language" type="xml" sizeInKB="100" file="assets/plantapledge/xml/lang/en.xml" />

<!-- IMAGES/TEXTURES -->
<!-- <asset name="shadow" type="image" sizeInKB="18" file="assets/plantapledge/textures/shadow.png" />-->
<asset name="earth" type="image" sizeInKB="428" file="assets/plantapledge/textures/earth.jpg" />
<asset name="hitmap" type="image" sizeInKB="32" file="assets/plantapledge/textures/hit_map.png" />		


</assets>

</xml>

http://www.greensock.com/as/docs/tween/com/greensock/loading/LoaderMax.html
http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/ApplicationDomain.html#currentDomain

*/
package com.darcey.io
{
	// -------------------------------------------------------------------------------------------------------------------------------
	import com.darcey.debug.Ttrace;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.SelfLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	// -------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// -------------------------------------------------------------------------------------------------------------------------------
	public class LoadXMLAssetList extends EventDispatcher
	{
		// ---------------------------------------------------------------------------------------------------------------------------
		private var t:Ttrace;
		public var queName:String = "";
		public var loader:LoaderMax;
		public var percentLoaded:Number = 0;
		
		public var _complete:Boolean = false;
		public function get complete():Boolean { return _complete; }
		public function set complete(arg:Boolean):void { _complete = arg; }
		
		private var r:Number = Math.round(Math.random() * 100000000000000);
		// ---------------------------------------------------------------------------------------------------------------------------
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function LoadXMLAssetList()
		{
			// Setup class specific tracer
			t = new Ttrace(false);
			t.ttrace("LoadXMLAssetList.LoadXMLAssetList()");
			
			// Var ini
			queName = "LoaderMaxQue" + r;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		// WARNING: forceBrowserReloader = true will force the browser to do a full load every time the page is loaded
		// ---------------------------------------------------------------------------------------------------------------------------
		public function load(xml:XML,auditSize:Boolean = true,requireWithRoot:Boolean = true,autoDispose:Boolean = false,showTrace:Boolean = false):void
		{
			if (showTrace){
				t.enable();
			}
			
			loader = new LoaderMax( { 
				name:queName,
				maxConnections:5,
				auditSize:auditSize,
				onProgress:progressHandler,
				onError:errorHandler,
				onChildComplete:childCompleteHandler,
				onComplete:completeHandler
			} );
						
			loader.autoDispose = autoDispose;
			//loader.defaultContext = new LoaderContext(true,ApplicationDomain.currentDomain);
			//loader.append( new SelfLoader(rootSWF) ); //just to include the root swf in the progress calculations
			//var loader:SWFLoader = new SWFLoader("1.swf", {context: new LoaderContext(true, ApplicationDomain.currentDomain)});
			
			// Parse xml data into loaderMax
			var appendToFileString:String = "";
			var cache:String = "";
			var type:String = "";
			var file:String = "";
			var name:String = "";
			var kb:Number = 0;
			
			for (var i:int = 0; i <= xml.assets.asset.length()-1; i++)
			{
				cache = xml.assets.asset[i].attribute("preventCaching");
				type = String(xml.assets.asset[i].attribute("type")).toLowerCase();
				file = xml.assets.asset[i].attribute("file");
				name = xml.assets.asset[i].attribute("name");
				kb = Number(xml.assets.asset[i].attribute("sizeInKB"));
				
				if (cache == "1"){
					t.ttrace("LoadXMLAssetList.load(): Caching prevented for [" + file + "]");
					appendToFileString = "?r="+r;
				} else {
					t.ttrace("LoadXMLAssetList.load(): Caching allowed for [" + file + "]");
					appendToFileString = "";
				}
				
				//t.ttrace("LoadXMLAssetList: Adding file:[" + file + "]  kb:[" + kb + "]");
				
				
				
				switch (type.toLowerCase())
				{
					case "swf":
						t.ttrace("LoadXMLAssetList: added swf " + file+appendToFileString);
						loader.append( new SWFLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024),autoPlay:false, context: new LoaderContext(true, ApplicationDomain.currentDomain)}) );
						break;
					
					case "mp3":
						t.ttrace("LoadXMLAssetList: added mp3 " + file+appendToFileString);
						loader.append( new MP3Loader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024) } ));
						break;
					
					case "video":
						t.ttrace("LoadXMLAssetList: added video " + file+appendToFileString);
						loader.append( new VideoLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024) } ));
						break;
					
					case "image":
						t.ttrace("LoadXMLAssetList: added image " + file+appendToFileString);
						loader.append( new ImageLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024) } ));
						break;
					
					case "xml":
						t.ttrace("LoadXMLAssetList: added xml " + file+appendToFileString);
						loader.append( new XMLLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024) } ));
						break;
					
					case "css":
						t.ttrace("LoadXMLAssetList: added css " + file+appendToFileString);
						loader.append( new CSSLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024) } ));
						break;
					
					default:
						t.warn("LoadXMLAssetList: #### WARNING #### Unhandled file type [" + type + "] loading file [" + file+appendToFileString + "] using DataLoader");
						loader.append( new DataLoader(file+appendToFileString,{ name:name,estimatedBytes:(kb*1024)}) );
						break;
				} // end switch
			} // end for
			
			
			// Start the loader going
			loader.load();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function progressHandler(e:LoaderEvent):Number
		{
			var index:int = loader.getChildIndex(e.target as LoaderCore);
			percentLoaded = Math.round(e.target.progress * 100);
			//t.ttrace("UTIL: e.target = " + e.target + " - progress = " + e.target.progress);
			
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS,false,false,e.target.bytesLoaded,e.target.bytesTotal) );
			//dispatchEvent(e);
			
			return percentLoaded;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function childCompleteHandler(e:LoaderEvent):void
		{
			var index:int = loader.getChildIndex(e.target as LoaderCore);
			//trace(e.target.name + " finished, and it is in position " + index + " of the queue.");
			//t.ttrace("Preloader().childCompleteHandler(): LOAD COMPLETE OF [" + e.target + "]");
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function errorHandler(e:LoaderEvent):void
		{
			t.wdiv();
			t.warn("LoadXMLAssetList.errorHandler(): " + e.target + " = " + e.text);
			t.warn("LoadXMLAssetList.errorHandler(): If your on a windows server ensure f4v mime type is added.");
			t.wdiv();
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function completeHandler(e:LoaderEvent):void
		{
			t.ttrace("LoadXMLAssetList.completeHandler(e)");
			this.complete = true;
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getSWF(name:String):*
		{
			t.ttrace("LoadXMLAssetList.getSWF(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			var swfLoader:SWFLoader = loader.getLoader(name);
			var swf:* = swfLoader.rawContent as Object;
			return swf;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getXML(name:String):XML
		{
			t.ttrace("LoadXMLAssetList.getXML(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			return new XML(loader.getContent(name));
		}		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getSWFLoader(name:String):*
		{
			t.ttrace("LoadXMLAssetList.getSWFLoader(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			var swfLoader:SWFLoader = loader.getLoader(name);
			return swfLoader;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getContent(name:String):*
		{
			t.ttrace("LoadXMLAssetList.getContent(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			return loader.getContent(name);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getLoader(name:String):*
		{
			t.ttrace("LoadXMLAssetList.getLoader(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			return loader.getLoader(name);
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		public function getMovieClipFromRawContent(name:String):MovieClip
		{
			t.ttrace("LoadXMLAssetList.getMovieClipFromRawContent(name:"+name+")");
			if (!checkLoaded()){ return null; }
			
			var swfLoader:SWFLoader = loader.getLoader(name);
			var mc:MovieClip = swfLoader.rawContent;
			
			return mc;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		private function checkLoaded():Boolean
		{
			if (!complete){ trace("Load has not completed - returning null!"); }
			return complete;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		// ---------------------------------------------------------------------------------------------------------------------------
		public function dispose():void
		{
			try {
				loader.dispose(true);
			} catch (e:Error) {}
			
			loader = null;
			complete = false;
		}
		// ---------------------------------------------------------------------------------------------------------------------------
		
		
		
	}
	// -------------------------------------------------------------------------------------------------------------------------------
}