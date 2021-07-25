package;


import webm.WebmPlayer;
import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.display.Application;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.Video;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleVidState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 140; // How many frames per second the game should run at.
																										// applies everywhere, if changing this DO NOT TAMPER WITH "KadeEngineData.hx"
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = true; // Whether to start the game in fullscreen on desktop targets
	// have at it for v1.10.2 // alt+enter to toggle fullscreen ffs

	public static var fpsDisplay:FPS;

	#if web
		var vHandler:VideoHandler;
	#elseif desktop
		var webmHandle:WebmHandler;
	#end

	public static var watermarks = true; // Whether to put Kade Engine literally anywhere (corrected by roz now, kade learn math n spellin broski)

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{

		// quick checks 

		Lib.current.addChild(new Main());
	}

	public static var video:Bool;
	public static var preload:Bool;

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	public static var webmHandler:WebmHandler;

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		initialState = Caching;
		
		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);

		addChild(game);

		if(video){
			var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";
	
			#if web
			var str1:String = "HTML CRAP";
			vHandler = new VideoHandler();
			vHandler.init1();
			vHandler.video.name = str1;
			addChild(vHandler.video);
			vHandler.init2();
			GlobalVideo.setVid(vHandler);
			vHandler.source(ourSource);
			#elseif desktop
			WebmPlayer.SKIP_STEP_LIMIT = 90;
			var str1:String = "WEBM SHIT"; 
			webmHandle = new WebmHandler();
			webmHandle.source(ourSource);
			webmHandle.makePlayer();
			webmHandle.webm.name = str1;
			addChild(webmHandle.webm);
			GlobalVideo.setWebm(webmHandle);
			#end
			}
		

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		#end
	}

	var game:FlxGame;

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Float)
	{
		openfl.Lib.current.stage.frameRate = cap;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}
}