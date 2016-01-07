package fe.core.setup
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	public class FEDatabase
	{
		
		public var DBDirectory:FEDirectory = new FEDirectory();
		public var FileDB:File = new File();
		public var GPSDB:File = new File();
		
		public var ConnectFileDB:SQLConnection;
		public var ConnectGPSDB:SQLConnection;
		public var stmt:SQLStatement;
		
		public function FEDatabase()
		{
			if(DBDirectory.UsbConfigFile.exists){
				if(DBDirectory.StorageType == 1){
					FileDB = File.userDirectory.resolvePath(DBDirectory.ConfigDirectory + "/files.db");
					GPSDB = File.userDirectory.resolvePath(DBDirectory.ConfigDirectory + "/gps.db");
				}else if(DBDirectory.StorageType == 2){
					FileDB = new File(DBDirectory.StoragePath + "/" + DBDirectory.ConfigDirectory + "/files.db");
					GPSDB = new File(DBDirectory.StoragePath + "/" + DBDirectory.ConfigDirectory + "/gps.db");
				}
			}else{
				FileDB = File.userDirectory.resolvePath(DBDirectory.ConfigDirectory + "/files.db");
				GPSDB = File.userDirectory.resolvePath(DBDirectory.ConfigDirectory + "/gps.db");
			}
			
			ConnectFileDB = new SQLConnection();
			ConnectFileDB.open(FileDB);
			CreateFileTable(ConnectFileDB);
			
			ConnectGPSDB = new SQLConnection();
			ConnectGPSDB.open(GPSDB);
			CreateGPSTable(ConnectGPSDB);
			
		}
		
		private function CreateFileTable(DB:SQLConnection):void{
			
			stmt = new SQLStatement();
			stmt.sqlConnection = DB;
			
			stmt.text = "CREATE TABLE IF NOT EXISTS FWData (" +
				"file_id INTEGER PRIMARY KEY, " + 
				"file_name TEXT, " + 
				"file_path TEXT, " +
				"file_label TEXT, " +
				"folder_id INTEGER, " + 
				"tab_id INTEGER, " + 
				"date REAL," + 
				"Latitude TEXT, " +
				"Longitude TEXT, " +
				"description TEXT, " +
				"Dropbox INTEGER, " +
				"Servers INTEGER, " +
				"ptop INTEGER" + ")";
			stmt.execute();
			
			// Tab テーブルの作成
			stmt.text = "CREATE TABLE IF NOT EXISTS Tab (tab_id INTEGER PRIMARY KEY, tab_name TEXT, tree_file TEXT)";
			stmt.execute();
			
			// Folder テーブルの作成
			stmt.text = "CREATE TABLE IF NOT EXISTS Folder(" +
				"folder_id INTEGER PRIMARY KEY, " +
				"folder_label TEXT, " +
				"tab_id INTEGER)";
			stmt.execute();
			
			// ローカルのConfig ディレクトリにあるデータベースに、共有したい相手の設定情報を保存するテーブルを作成する
			stmt.text = "CREATE TABLE IF NOT EXISTS OtherNetworkSetting ( " +
				"user_id INTEGER PRIMARY KEY, " +
				"name text, " +
				"method text, " + 
				"Path text );";
			stmt.execute();
			
		}
		
		private function CreateGPSTable(DB:SQLConnection):void{
			
			stmt = new SQLStatement();
			stmt.sqlConnection = DB;
			
			stmt.text = "CREATE TABLE IF NOT EXISTS GPSLog (" +
				"id INTEGER PRIMARY KEY, " +
				"log_filename TEXT, " +
				"date REAL, " +
				"Latitude TEXT, " +
				"Longitude TEXT);";
			stmt.execute();
			
			stmt.text = "CREATE TABLE IF NOT EXISTS GPSLogFile(" + 
				"logfile_id INTEGER PRIMARY KEY, " + 
				"log_filename TEXT, " +  
				"log_filelabel TEXT);";
			stmt.execute();
		}
	}
	
}