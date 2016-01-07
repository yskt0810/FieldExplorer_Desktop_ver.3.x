package fe.core.networks
{
	import flash.data.SQLResult;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import fe.core.setup.FEDatabase;
	import fe.core.setup.FEDirectory;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxEvent;

	public class MyDropboxFileUpload
	{
		
		public var dropboxAPI:DropboxClient;
		public var myDropbox:MyDropboxDirectory;
		[Bindable] private var FileLists:ArrayCollection;
		
		public function MyDropboxFileUpload(api:DropboxClient,dir:MyDropboxDirectory,localDir:FEDirectory)
		{
			
			dropboxAPI = api;
			myDropbox = dir;
			
		}
		
		public function UploadDataFiles(file:File,file_id:int):void{
			var flag:Boolean = false;
			var LocalDB:FEDatabase = new FEDatabase();
			LocalDB.stmt.sqlConnection = LocalDB.ConnectFileDB;
			LocalDB.stmt.text = "SELECT file_id, file_name, file_path, file_label, folder_id, tab_id, date, Latitude, Longitude, description " +
				"FROM FWData WHERE file_id = " + file_id + ";";
			LocalDB.stmt.execute();
			
			// Share DB
			var dropboxDB:MyDropboxDB = new MyDropboxDB(dropboxAPI,myDropbox);
			dropboxDB.SearchDBFile();
			FileLists = new ArrayCollection(LocalDB.stmt.getResult().data);
			var statement:String = "INSERT INTO Share_FWData " +
				"(share_file_name,share_tab_id,share_folder_id,share_file_label," +
				"date,Latitude,Longitude,share_description,Local_fileid) VALUES ('" + FileLists[0].file_name + "'," + FileLists[0].tab_id + "," +
				FileLists[0].folder_id + ",'" + FileLists[0].file_label + "'," + FileLists[0].date + ",'" +
				FileLists[0].Latitude + "','" + FileLists[0].Longitude + "','" + FileLists[0].description +
				"'," + FileLists[0].file_id + ");";
			dropboxDB.ConnectMyShareDB();
			dropboxDB.InsertDBMyShareDB(statement);	
			
			// ファイルのアップロード
			var uploadDir:String = myDropbox.my_dropboxData;
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			if(file.exists){
				stream.open(file,FileMode.READ);
				stream.readBytes(bytes);
				stream.close();
				dropboxAPI.putFile(uploadDir,file.name,bytes);
				var handler:Function = function(evt:DropboxEvent):void{
					dropboxAPI.removeEventListener(DropboxEvent.PUT_FILE_RESULT,handler);
					flag = true;
				};
				dropboxAPI.addEventListener(DropboxEvent.PUT_FILE_RESULT,handler);
			}

		}
		
		public function DeleteDataFiles(file_id:int,file_name:String):void{
			var dropboxDB:MyDropboxDB = new MyDropboxDB(dropboxAPI,myDropbox);
			dropboxDB.ConnectMyShareDB();
			var DeleteSQL:String = "DELETE FROM Share_FWData WHERE share_file_id = " + file_id + ";";
			dropboxDB.DeleteStatements(DeleteSQL);
			
			var CheckSQL:String = "SELECT count(share_file_id) as count FROM Share_FWData " +
				"where share_file_name = '" + file_name + "';";
			
			var result:SQLResult = new SQLResult();
			result = dropboxDB.CheckStatements(CheckSQL);
			trace(result.data[0].count);
			if(result.data[0].count == 0){
				var path:String = myDropbox.my_dropboxData + "/" + file_name;
				dropboxAPI.fileDelete(path,"dropbox");
				var handler:Function = function(evt:DropboxEvent):void{
					dropboxAPI.removeEventListener(DropboxEvent.FILE_DELETE_RESULT,handler);
					trace('-- deleted ---');
				};
				dropboxAPI.addEventListener(DropboxEvent.FILE_DELETE_RESULT,handler);
			}
		}
		
		public function UploadTreeFiles(file:File):void{
			var flag:Boolean = false;
			
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			var uploadDir:String = myDropbox.my_dropboxConfig;
			
			if(file.exists){
				stream.open(file,FileMode.READ);
				stream.readBytes(bytes);
				stream.close();
				dropboxAPI.putFile(uploadDir,file.name,bytes);
				var handler:Function = function(evt:DropboxEvent):void{
					dropboxAPI.removeEventListener(DropboxEvent.PUT_FILE_RESULT,handler);
					flag = true;
				};
				dropboxAPI.addEventListener(DropboxEvent.PUT_FILE_RESULT,handler);
			}
			
		}
		
	}
}