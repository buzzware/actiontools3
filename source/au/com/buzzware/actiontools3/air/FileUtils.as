package au.com.buzzware.actiontools3.air {

	import au.com.buzzware.actiontools3.code.StringUtils;
	
	import flash.filesystem.*;

	public class FileUtils {

		public static function toFile(aFileOrName: Object): File {
			if (!aFileOrName)
				return null
			if (aFileOrName is File) {
				return aFileOrName as File
			} else {
				return new File(String(aFileOrName))
			}
		}

		public static function toApplicationFile(aFileOrName: Object): File {
			if (!aFileOrName)
				return null
			if (aFileOrName is File) {
				return File(aFileOrName)
			} else {
				return File.applicationDirectory.resolvePath(String(aFileOrName))
			}
		}

		public static function fileToString(aFile: Object): String {
			var file:File = mustExist(toApplicationFile(aFile))
			if (!file)
				return null;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readMultiByte(file.size, File.systemCharset);
			fileStream.close();			
			return str;			
		}
		
		public static function stringToFile(aString: String,aFile: Object): void {
			var file:File = toApplicationFile(aFile)			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			//fileStream.writeString(aString);
			fileStream.writeMultiByte(aString, File.systemCharset);
			fileStream.close();			
		}
		
		public static function mustExist(aFile: File): File {
			if (!aFile)
				return null
			return (aFile.exists ? aFile : null)
		}
		
		public static function isWindowsPath(aPath: String): Boolean {
			if (!aPath)
				return null;
			var fwd: int;
			var back: int;
			for (var i:int = 0;i<aPath.length;i++) {
				if (aPath.charAt(i)=='/')
					fwd++;
				if (aPath.charAt(i)=='\\')
					back++;
			}
			return (back > fwd) ? true : false
		}				
	}
}
