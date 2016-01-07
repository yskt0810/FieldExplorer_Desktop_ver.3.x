package fe.core.networks
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import fe.core.setup.FEDatabase;
	import fe.core.setup.FEDirectory;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxEvent;
	import org.hamster.dropbox.models.DropboxFile;

	public class MyDropboxDB extends Sprite
	{
		
		public var MyDB:String;
		public var MyDB_FLAG:Boolean;
		public var MyDB_Local:File;
		public var MyDB_Local_Connection:SQLConnection;
		public var stmt:SQLStatement;
		
		private var dropboxAPI:DropboxClient;
		private var MY_DIR:MyDropboxDirectory;
		
		public function MyDropboxDB(getAPI:DropboxClient,MyDir:MyDropboxDirectory)
		{
			dropboxAPI = getAPI;
			MY_DIR = MyDir;
			MyDB = MyDir.my_dropboxConfig + "/" + "file.db";
			
		}
		
		public function SearchDBFile():void{
			this.addEventListener(Event.COMPLETE,CheckMyDropboxDBExists);
			dropboxAPI.metadata(MyDB,1000,"",true);
			var send:Event = new Event(Event.COMPLETE,false,false);
			var handler:Function = function(evt:DropboxEvent):void{
				dropboxAPI.removeEventListener(DropboxEvent.METADATA_RESULT,handler);
				var dbfile:DropboxFile = DropboxFile(evt.resultObject);
				if(dbfile['isDeleted']){
					MyDB_FLAG = false;
				}else{
					MyDB_FLAG = true;					
				}
				dispatchEvent(send);
			};
			
			var faultHandler:Function = function(evt:DropboxEvent):void{
				dropboxAPI.removeEventListener(DropboxEvent.METADATA_FAULT,faultHandler);
				MyDB_FLAG = false;
				dispatchEvent(send);
			};
			
			dropboxAPI.addEventListener(DropboxEvent.METADATA_RESULT,handler);
			dropboxAPI.addEventListener(DropboxEvent.METADATA_FAULT,faultHandler);
		}
		
		public function CheckMyDropboxDBExists(e:Event):void{
			this.removeEventListener(Event.COMPLETE,CheckMyDropboxDBExists);
			if(MyDB_FLAG){
				GetDB();
				ConnectMyShareDB();
			}else{
				ConnectMyShareDB();
				CreateTables();
				ImportLocalConfigData();
				UploadDB();
			}
		}
		
		public function GetDB():void{
			dropboxAPI.getFile(MyDB);
			var handler:Function = function(evt:DropboxEvent):void{
				dropboxAPI.removeEventListener(DropboxEvent.GET_FILE_RESULT,handler);
				var bytes:ByteArray = new ByteArray();
				bytes = ByteArray(evt.resultObject);
				MyDB_Local = File.applicationStorageDirectory.resolvePath("Share_files.db");
				if(MyDB_Local.exists){
					MyDB_Local.deleteFile();
				}
				var stream:FileStream = new FileStream();
				stream.open(MyDB_Local,FileMode.WRITE);
				stream.position = 0;
				stream.writeBytes(bytes,0,bytes.length);
				stream.close();
			};
			dropboxAPI.addEventListener(DropboxEvent.GET_FILE_RESULT,handler);
			
		}
		
		public function UploadDB():void{
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			MyDB_Local = File.applicationStorageDirectory.resolvePath("Share_files.db");
			if(MyDB_Local.exists){
				stream.open(MyDB_Local,FileMode.READ);
				stream.readBytes(bytes);
				stream.close();
				dropboxAPI.putFile(MY_DIR.my_dropboxConfig,"file.db",bytes);
				var handler:Function = function(evt:DropboxEvent):void{
					MyDB_FLAG = true;
				};
				dropboxAPI.addEventListener(DropboxEvent.PUT_FILE_RESULT,handler);
			}
		}
		
		public function ConnectMyShareDB():void{
			MyDB_Local = File.applicationStorageDirectory.resolvePath("Share_files.db");
			MyDB_Local_Connection = new SQLConnection();
			MyDB_Local_Connection.open(MyDB_Local);
		}
		
		public function CreateTables():void{
			if(MyDB_Local_Connection.connected){
				stmt = new SQLStatement();
				stmt.sqlConnection = MyDB_Local_Connection;
				stmt.text = "CREATE TABLE IF NOT EXISTS Share_FWData (" + 
					"share_file_id INTEGER PRIMARY KEY, " + 
					"share_file_name TEXT, " + 
					"share_tab_id INTEGER, " + 
					"share_folder_id INTEGER, " + 
					"share_file_label TEXT, " + 
					"date REAL, " + 
					"Latitude TEXT, " + 
					"Longitude TEXT, " + 
					"share_description TEXT, " + 
					"Local_fileid INTEGER)";
				stmt.execute();
				
				stmt.text = "CREATE TABLE IF NOT EXISTS Share_Comments (" +
					"comment_id INTEGER PRIMARY KEY, " + 
					"share_file_id INTEGER, " +
					"date REAL, " +
					"comment TEXT)";
				stmt.execute();
				
				stmt.text = "CREATE TABLE IF NOT EXISTS Share_Tab (tab_id INTEGER PRIMARY KEY, tab_name TEXT, tree_file TEXT);";
				stmt.execute();
				
				stmt.text = "CREATE TABLE IF NOT EXISTS Share_Folder(" +
					"folder_id INTEGER PRIMARY KEY, " +
					"folder_label TEXT, " +
					"tab_id INTEGER)";
				stmt.execute();
			}
			
			
			
		}
		
		public function ImportLocalConfigData():void{
			
			
			var Local:FEDirectory = new FEDirectory();
			var LocalDB:FEDatabase = new FEDatabase();
			var Upload:MyDropboxFileUpload = new MyDropboxFileUpload(dropboxAPI,MY_DIR,Local);
			
			LocalDB.stmt.sqlConnection = LocalDB.ConnectFileDB;
			LocalDB.stmt.text = "SELECT tab_id,tab_name,tree_file FROM Tab";
			LocalDB.stmt.execute();
			
			var result:SQLResult = LocalDB.stmt.getResult();
			trace(result.data.length);
			for(var i:int = 0; i<result.data.length; i++){
				
				var tab_id:int = result.data[i].tab_id;
				var tab_name:String = result.data[i].tab_name;
				var tree_file:File = File.userDirectory.resolvePath(Local.ConfigDirectory + "/" + result.data[i].tree_file);
				
				var Tab_SQL:String = "INSERT INTO Share_Tab (tab_id,tab_name,tree_file) VALUES (" + tab_id + ",'" + tab_name + "','" + tree_file.name + "');";
				InsertDBMyShareDB(Tab_SQL);
				Upload.UploadTreeFiles(tree_file);
			}
			
			LocalDB.stmt.text = "SELECT folder_id,folder_label,tab_id FROM Folder;";
			LocalDB.stmt.execute();
			
			result = new SQLResult();
			result = LocalDB.stmt.getResult();
			trace(result.data.length);
			for(var j:int = 0; j<result.data.length; j++){
				
				var folder_id:int = result.data[j].folder_id;
				var folder_label:String = result.data[j].folder_label;
				var tab_id2:int = result.data[j].tab_id;
				
				var Folder_SQL:String = "INSERT INTO Share_Folder (folder_id,folder_label,tab_id) VALUES (" +
					folder_id + ",'" + folder_label + "'," + tab_id2 + ");";
				InsertDBMyShareDB(Folder_SQL);
			}
			
			
		}
		
		
		public function InsertDBMyShareDB(statment:String):void{
			
			if(MyDB_Local_Connection.connected){
				stmt = new SQLStatement();
				stmt.sqlConnection = MyDB_Local_Connection;
				stmt.text = statment;
				stmt.execute();
								
			}
			
		}
		
		public function DeleteStatements(statement:String):void{
			
			if(MyDB_Local_Connection.connected){
				stmt = new SQLStatement();
				stmt.sqlConnection = MyDB_Local_Connection;
				stmt.text = statement;
				stmt.execute();
			}
		}
		
		public function CheckStatements(statement:String):SQLResult{
			var result:SQLResult = new SQLResult();
			if(MyDB_Local_Connection.connected){
				stmt = new SQLStatement();
				stmt.sqlConnection = MyDB_Local_Connection;
				stmt.text = statement;
				stmt.execute();
				result = stmt.getResult();
			}
			
			return result;
		}
		
		
		
	}
}