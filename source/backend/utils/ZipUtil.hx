package backend.utils;

#if sys
#if (!macro && sys)
import openfl.display.BitmapData;
#end

import haxe.Exception;
import haxe.Json;
import haxe.crypto.Crc32;
import haxe.zip.Writer;
import haxe.zip.Tools;
import haxe.zip.Entry;
import haxe.zip.Uncompress;
import haxe.zip.Reader;
import haxe.zip.Compress;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import sys.thread.Thread;
import tink.io.*;
import tink.io.Gzip;

using StringTools;

class ZipUtil {
    public static var bannedNames:Array<String> = [".git", ".gitignore", ".github", ".vscode", ".gitattributes", "readme.txt"];

    /**
     * [Description] Uncompresses `zip` into the `destFolder` folder
     * @param zip
     * @param destFolder
     */
    public static function uncompressZip(zip:Reader, destFolder:String, ?prefix:String, ?prog:ZipProgress):ZipProgress {
        // we never know
        FileSystem.createDirectory(destFolder);

        var fields = zip.read();

        try {
            if (prefix != null) {
                var f = fields;
                fields = new List<Entry>();
                for (field in f) {
                    if (field.fileName.startsWith(prefix)) {
                        fields.push(field);
                    }
                }
            }

            if (prog == null)
                prog = new ZipProgress();
            prog.fileCount = fields.length;
            for (k => field in fields) {
                prog.curFile = k;
                var isFolder = field.fileName.endsWith("/") && field.fileSize == 0;
                if (isFolder) {
                    FileSystem.createDirectory('${destFolder}/${field.fileName}');
                } else {
                    var split = [for (e in field.fileName.split("/")) e.trim()];
                    split.pop();
                    FileSystem.createDirectory('${destFolder}/${split.join("/")}');

                    var data = unzip(field);
                    File.saveBytes('${destFolder}/${field.fileName}', data);
                }
            }
            prog.curFile = fields.length;
            prog.done = true;
        } catch (e) {
            prog.done = true;
            prog.error = e;
        }
        return prog;
    }

    #if (!macro && sys)
    public static function uncompressZipAsync(zip:Reader, destFolder:String, ?prog:ZipProgress, ?prefix:String):ZipProgress {
        if (prog == null)
            prog = new ZipProgress();
        Thread.create(function () {
            uncompressZip(zip, destFolder, prefix, prog);
        });
        return prog;
    }
    #end

    /**
     * [Description] Unzips a RAR file into the `destFolder` folder
     * @param rarPath
     * @param destFolder
     */
    public static function uncompressRar(rarPath:String, destFolder:String):Void {
        FileSystem.createDirectory(destFolder);
        try {
            var process = new Process("unrar", ["x", rarPath, destFolder]);
            process.close();
            trace("RAR extraction complete!");
        } catch (e:Dynamic) {
            throw "Failed to extract RAR file: " + e;
        }
    }

	public static function uncompressTarGz(gzPath:String, destFolder:String):Void {
		FileSystem.createDirectory(destFolder);
		
		try {
			var gzBytes = File.getBytes(gzPath);
			var decompressedBytes = tink.io.Gzip.uncompress(gzBytes);
			
			uncompressTar(decompressedBytes, destFolder);
			
		} catch (e:Dynamic) {
			throw "Failed to extract tar.gz file: " + e;
		}
	}

	public static function compressToTar(folderPath:String, tarPath:String):Void {
		var tarOutput = sys.io.File.write(tarPath, append = false);
		
		try {
			for (filePath in sys.FileSystem.readDirectory(folderPath)) {
				var fullFilePath = folderPath + "/" + filePath;
				var fileBytes = sys.io.File.getBytes(fullFilePath);
				var header = createTarHeader(filePath, fileBytes.length);

				tarOutput.writeFullBytes(header, 0, header.length);
				tarOutput.writeFullBytes(fileBytes, 0, fileBytes.length);
				
				var padding = 512 - (fileBytes.length % 512);
				if (padding != 512) {
					tarOutput.write(new haxe.io.Bytes(new Array<Int>(padding)), 0, padding);
				}
			}
			
			tarOutput.write(new haxe.io.Bytes(new Array<Int>(1024)), 0, 1024);
			
		} catch (e:Dynamic) {
			throw "Failed to create tar archive: " + e;
		} finally {
			tarOutput.close();
		}
	}
	
	public static function createTarHeader(fileName:String, fileSize:Int):haxe.io.Bytes {
		var header = haxe.io.Bytes.alloc(512);
	
		var nameBytes = haxe.io.Bytes.ofString(fileName);
		header.blit(0, nameBytes, 0, Math.min(100, nameBytes.length));
	
		var sizeOctal = StringTools.lpad(StringTools.hex(fileSize), "0", 11);
		var sizeBytes = haxe.io.Bytes.ofString(sizeOctal);
		header.blit(124, sizeBytes, 0, sizeBytes.length);
	
		header.set(156, 48);

		var checksum = 0;
		for (i in 0...512) checksum += header.get(i);
		var checksumOctal = StringTools.lpad(StringTools.hex(checksum), "0", 6);
		var checksumBytes = haxe.io.Bytes.ofString(checksumOctal);
		header.blit(148, checksumBytes, 0, checksumBytes.length);
		
		return header;
	}

	public static function uncompressTar(tarBytes:haxe.io.Bytes, destFolder:String):Void {
		var pos = 0;
		
		while (pos < tarBytes.length) {

			var header = tarBytes.sub(pos, 512);
			pos += 512;

			var fileName = extractFileName(header);
			var fileSize = extractFileSize(header);

			if (fileSize > 0) {
				var fileData = tarBytes.sub(pos, fileSize);
				pos += fileSize;
	
				File.saveBytes('${destFolder}/${fileName}', fileData);
			}
	
			if (fileSize % 512 != 0) {
				pos += 512 - (fileSize % 512);
			}
		}
	}

	public static function compressToTarGz(folderPath:String, tarGzPath:String):Void {
		// Create TAR archive in-memory
		var tarBytes = createTarBytes(folderPath);
		
		// Compress the TAR archive using Gzip
		var gzBytes = tink.io.Gzip.compress(tarBytes);
		
		// Save to .tar.gz file
		sys.io.File.saveBytes(tarGzPath, gzBytes);
	}
	
	public static function createTarBytes(folderPath:String):haxe.io.Bytes {
		var buffer = new haxe.io.BytesBuffer();
		
		try {
			for (filePath in sys.FileSystem.readDirectory(folderPath)) {
				var fullFilePath = folderPath + "/" + filePath;
				var fileBytes = sys.io.File.getBytes(fullFilePath);
				
				var header = createTarHeader(filePath, fileBytes.length);
				buffer.addBytes(header);
				buffer.addBytes(fileBytes);
				
				var padding = 512 - (fileBytes.length % 512);
				if (padding != 512) {
					buffer.add(haxe.io.Bytes.alloc(padding));
				}
			}
			
			buffer.add(haxe.io.Bytes.alloc(1024));
			
		} catch (e:Dynamic) {
			throw "Failed to create tar archive: " + e;
		}
		
		return buffer.getBytes();
	}

    public static function openZip(zipPath:String):Reader {
        return new ZipReader(File.read(zipPath));
    }

    public static function unzip(f:Entry) {
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

    public static function createZipFile(path:String):ZipWriter {
        var output = File.write(path);
        return new ZipWriter(output);
    }

    public static function writeFolderToZip(zip:ZipWriter, path:String, ?prefix:String, ?prog:ZipProgress, ?whitelist:Array<String>):ZipProgress {
        // Implementation as in your original code...
    }

    public static function writeFolderToZipAsync(zip:ZipWriter, path:String, ?prefix:String):ZipProgress {
        var zipProg = new ZipProgress();
        Thread.create(function () {
            writeFolderToZip(zip, path, prefix, zipProg);
        });
        return zipProg;
    }

    public static function arrayToList(array:Array<Entry>):List<Entry> {
        var list = new List<Entry>();
        for (e in array) list.push(e);
        return list;
    }
}

class ZipProgress {
    public var error:Exception = null;
    public var curFile:Int = 0;
    public var fileCount:Int = 0;
    public var done:Bool = false;
    public var percentage(get, null):Float;

    private function get_percentage() {
        return fileCount <= 0 ? 0 : curFile / fileCount;
    }

    public function new() {}
}

class ZipReader extends Reader {
    public var files:List<Entry>;

    public override function read() {
        if (files != null) return files;
        try {
            var files = super.read();
            return this.files = files;
        } catch (e) {
        }
        return new List<Entry>();
    }
}

class ZipWriter extends Writer {
    public function flush() {
        o.flush();
    }

    public function writeFile(entry:Entry) {
        writeEntryHeader(entry);
        o.writeFullBytes(entry.data, 0, entry.data.length);
    }

    public function close() {
        o.close();
    }
}

class StrNameLabel {
    public var name:String;
    public var label:String;

    public function new(name:String, label:String) {
        this.name = name;
        this.label = label;
    }
}
#end
