package backend.system;

// Credits Codename Engine

#if sys
import sys.FileSystem;
class CommandLineHandler {
	public static function parseCommandLine(cmd:Array<String>) {
		var i:Int = 0;
		while(i < cmd.length) {
			switch(cmd[i]) {
				case null:
					break;
				case "-h" | "-help" | "help":
					Sys.println("-- RZ Engine Command Line help --");
					Sys.println("-help                | Show this help");
					Sys.println("-nocolor             | Disables colors in the terminal");
			//		Sys.println("-nogpubitmap         | Forces GPU only bitmaps off");
					Sys.exit(0);
				case "-nocolor":
					Main.noTerminalColor = true;
				case "-livereload":
					// do nothing
				default:
					Sys.println("Unknown command");
			}
			i++;
		}
	}
}
#end