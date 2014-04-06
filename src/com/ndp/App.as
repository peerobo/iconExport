package com.ndp
{
	import adobe.utils.ProductManager;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Panel;
	import feathers.controls.supportClasses.TextFieldViewPort;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.layout.TiledColumnsLayout;
	import feathers.text.BitmapFontTextFormat;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PNGEncoderOptions;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.Particle;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class App extends Sprite
	{
		private var bd:BitmapData;
		private var textVals:Array;
		
		private const W:String = "width";
		private const H:String = "height";
		private const M:String = "margin";
		private const S:String = "spacing";
		private const C:String = "alpha";
		
		private const INPUT:Array = [W, H, M, S, C];
		private const SPACING:int = 10;
		private var imageSpr:Sprite;
		private var listPreview:QuadBatch;
		private var sourceTexture:Texture;
		private var shareObj:SharedObject;		
		private var panelPreview:Panel;
		private var textfield:TextField;
		
		public function App()
		{
			addEventListener(Event.ADDED_TO_STAGE, onInit);
			Util.root = this;
			shareObj = SharedObject.getLocal("tileextractor");
		}		
		
		public function process(bd:BitmapData):void 
		{
			textfield.text = "processing...";
			setTimeout(writeFile, 500, bd);
		}
		
		private function writeFile(bd:BitmapData):void
		{
			var directory:String = "iconsOutput";						
			
			var arr:Array = [1024, 512, 152, 144, 120, 114, 100, 96, 80, 76, 72, 58, 57, 50, 48, 40, 29];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var file:File = File.desktopDirectory.resolvePath(directory + "/icon_" + arr[i] +".png");
				var stream:FileStream = new FileStream();	
				stream.open(file, FileMode.WRITE);
				var newBD:BitmapData = new BitmapData(arr[i], arr[i], true, 0x00FFFFFF);
				var m:Matrix = new Matrix();
				m.scale(arr[i] / bd.width, arr[i] / bd.height);
				newBD.drawWithQuality(bd, m);
				var bArr:ByteArray = new ByteArray();
				newBD.encode(new Rectangle(0, 0, newBD.width, newBD.height), new PNGEncoderOptions(), bArr);
				stream.writeBytes(bArr, 0, bArr.length);
				stream.close();
			}
			textfield.text = "done";
		}
		
		private function onInit(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			textfield = new TextField(Util.appWidth, Util.appHeight, "Drag Image File Here...", "Verdana", 60);
			addChild(textfield);
			textfield.touchable = false;
			
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat("Arial", 32, 0x0, true, false, false, null, null, null, 10, 10);
				return textRenderer;
			}
			
			FeathersControl.defaultTextEditorFactory = function():ITextEditor
			{
				var textEditor:TextFieldTextEditor = new TextFieldTextEditor();
				textEditor.textFormat = new TextFormat("Arial", 32, 0x0, true);
				return textEditor;
			}
		}
	
	}

}