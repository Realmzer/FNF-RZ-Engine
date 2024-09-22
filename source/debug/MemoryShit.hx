package debug;

// FOR SOME REASON the game wont compile unless this is a seperate class to FPS
// killing myself

// NEVERMIND ITS BECAUSE OF
// F FFUU CCKING FLXCOLOR FOR SOME REASON???
// :sob:

// thank u https://stackoverflow.com/questions/63166/how-to-determine-cpu-and-memory-consumption-from-inside-a-process
// oh and https://learn.microsoft.com/en-us/windows/win32/psapi/collecting-memory-usage-information-for-a-process

#if cpp
import cpp.vm.Gc;
#end

#if windows
@:headerCode("
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <psapi.h>
")
@:unreflective
@:nativeGen
#end
class MemoryShit {
	#if windows
	// i probably need to like
	// remove the memory counter afterwards, to prevent leaking
	// .. but its FIIIINNEEE, right?
	@:functionCode('
    PROCESS_MEMORY_COUNTERS pmc;
    if( GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc)) )
        return (pmc.WorkingSetSize); // i hope Haxe can use this as an int :sob:
    else
        return 0;

    ')

	static function windowsObtainMemory():Dynamic
		return 0;

	public static function obtainMemory():Dynamic
	{
		var memory = windowsObtainMemory();
		if (memory == 0)
			return Gc.memInfo(Gc.MEM_INFO_CURRENT); // gets used memory, including uncollected garbage (should be more accurate than System.totalMemory?)

		return memory;
	}
	public static function obtainMemory():Dynamic
	{
		var memory = windowsObtainMemory();
		if (memory == 0)
		{
			#if cpp
			return Gc.memInfo(Gc.MEM_INFO_CURRENT); // gets used memory, including uncollected garbage (should be more accurate than System.totalMemory?)
			#else
			return System.totalMemory;
			#end
		}
		return memory;
	}
	#end

}