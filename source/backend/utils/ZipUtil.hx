package backend.utils;

import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Writer;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
import lime.utils.Bytes;d
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import utils.FileUtils;

using StringTools;

class ZipUtil
{
	public static function unzip(_path:String, _dest:String, ignoreRootFolder:String = "")
	{
		var _in_file = sys.io.File.read(_path);
		var _entries = haxe.zip.Reader.readZip(_in_file);

		_in_file.close();

		for (_entry in _entries)
		{
			var fileName = _entry.fileName;
			if (fileName.charAt(0) != "/" && fileName.charAt(0) != "\\" && fileName.split("..").length <= 1)
			{
				var dirs = ~/[\/\\]/g.split(fileName);
				if ((ignoreRootFolder != "" && dirs.length > 1) || ignoreRootFolder == "")
				{
					if (ignoreRootFolder != "")
					{
						dirs.shift();
					}

					var path = "";
					var file = dirs.pop();
					for (d in dirs)
					{
						path += d;
						sys.FileSystem.createDirectory(_dest + "/" + path);
						path += "/";
					}

					if (file == "")
					{
						if (path != "")
							trace("created " + path);
						continue; // was just a directory
					}
					path += file;
					//trace("unzip " + path);

					var data = unzipData(_entry);
					var f = File.write(_dest + "/" + path, true);
					f.write(data);
					f.close();
				}
			}
		} // _entry

		Sys.println('');
		Sys.println('unzipped successfully to ${_dest}');
	} // unzip

	public static function unzipData(f:Entry)
	{
		if (!f.compressed)
			return f.data;
		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(f.fileSize);
		var r = c.execute(f.data, 0, s, 0);
		c.close();
		if (!r.done || r.read != f.data.length || r.write != f.fileSize)
			throw "Invalid compressed data for " + f.fileName;
		f.compressed = false;
		f.dataSize = f.fileSize;
		f.data = s;
		return f.data;
	}

    function getEntries(dir:String, entries:List<haxe.zip.Entry> = null, inDir:Null<String> = null) {
        if (entries == null) entries = new List<haxe.zip.Entry>();
        if (inDir == null) inDir = dir;
        for(file in sys.FileSystem.readDirectory(dir)) {
            var path = haxe.io.Path.join([dir, file]);
            if (sys.FileSystem.isDirectory(path)) {
                getEntries(path, entries, inDir);
            } else {
                var bytes:haxe.io.Bytes = haxe.io.Bytes.ofData(sys.io.File.getBytes(path).getData());
                var entry:haxe.zip.Entry = {
                    fileName: StringTools.replace(path, inDir, ""), 
                    fileSize: bytes.length,
                    fileTime: Date.now(),
                    compressed: false,
                    dataSize: sys.FileSystem.stat(path).size,
                    data: bytes,
                    crc32: haxe.crypto.Crc32.make(bytes)
                };
                entries.push(entry);
            }
        }
        return entries;
    }
}