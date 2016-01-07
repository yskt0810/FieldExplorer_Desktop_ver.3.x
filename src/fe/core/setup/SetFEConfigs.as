package fe.core.setup
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class SetFEConfigs
	{
		
		public var ConfigDirectory:FEDirectory = new FEDirectory();
		public var CONFIG_FILENAME:String = "Config.xml";
		
		public var ConfigFile:File = new File();
		
		public function SetFEConfigs()
		{
			// コンフィグファイルを読み込む（無い場合は作成する）
			// ConfigFile = File.userDirectory.resolvePath(CFDir.ConfigDirectory + "/" + CONFIG_FILENAME);
			ConfigFile = new File(ConfigDirectory.RefConfigDirectory + "/" + CONFIG_FILENAME);
			if(!ConfigFile.exists){
				var WriteXML:String;
				
				WriteXML = '<root>\n';
				WriteXML += '</root>\n';
				
				var WriteStream:FileStream = new FileStream();
				WriteStream.open(ConfigFile, FileMode.WRITE);
				WriteStream.writeUTFBytes(WriteXML);
				WriteStream.close();
			}
		}
	}
}