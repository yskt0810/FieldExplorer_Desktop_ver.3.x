package fe.core.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class ReadXMLFile
	{
		
		private var readStream:FileStream;
		private var OutputXML:XML;
		
		public function ReadXMLFile()
		{
			readStream = new FileStream();
			OutputXML = new XML();
			
		}
		
		public function ReadMethod(readfile:File):XML{
			readStream.open(readfile,FileMode.READ);
			OutputXML = XML(readStream.readUTFBytes(readStream.bytesAvailable));
			readStream.close();
			
			return OutputXML;
			
		}
	}
}