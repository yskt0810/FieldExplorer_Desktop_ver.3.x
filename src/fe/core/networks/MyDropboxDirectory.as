package fe.core.networks
{
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxConfig;

	public class MyDropboxDirectory
	{
		
		private var dropboxAPI:DropboxClient;
		private var config:DropboxConfig;
		
		public var my_dropbox:String;
		public var my_dropboxConfig:String;
		public var my_dropboxData:String;
		
		
		public function MyDropboxDirectory(dpcl:DropboxClient,MYFOLDER_NAME:String)
		{
			
			dropboxAPI = dpcl;
			my_dropbox = MYFOLDER_NAME;
			my_dropboxConfig = my_dropbox + "/config";
			my_dropboxData = my_dropbox + "/data";
			
		}
		
	}
}