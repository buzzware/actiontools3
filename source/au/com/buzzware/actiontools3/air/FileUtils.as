package au.com.buzzware.actiontools3.air {

	import flash.filesystem.*;

	public class FileUtils {

		public static function fileToString(aFilename: String): String {
			var file:File = File.applicationDirectory;
			file = file.resolvePath(aFilename);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readMultiByte(file.size, File.systemCharset);
			fileStream.close();			
			return str;			
		}

	}
}
