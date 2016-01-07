package fe.core.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;

	public class WriteXMLFile
	{
		
		private var writeStream:FileStream;
		
		public function WriteXMLFile()
		{
			writeStream = new FileStream();
		}
		
		public function WriteMethod(WriteXML:String,WriteFile:File):void{
			
			writeStream.open(WriteFile,FileMode.WRITE);
			writeStream.writeUTFBytes(WriteXML);
			writeStream.close();
			
		}
	}
}