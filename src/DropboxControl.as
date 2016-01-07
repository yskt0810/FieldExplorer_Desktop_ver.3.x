import flash.events.Event;
import flash.filesystem.File;

import fe.core.networks.MyDropboxFileUpload;
import fe.core.setup.FEDatabase;

// ActionScript file

public function onDropboxChecked(e:Event):void{
	
	if(TreeView.FileView.selectedItem != null){
		
		var DBFiles:MyDropboxFileUpload = new MyDropboxFileUpload(dropboxAPI,MY_SHARE_FOLDER,Directory);
		var UploadFile:File = File.userDirectory.resolvePath(Directory.DataDirectory + "/" + TreeView.FileView.selectedItem.file_name);
		var Upload_fileid:int = TreeView.FileView.selectedItem.file_id;
		
		if(DataViews.Dropbox.selected){
			
			Database = new FEDatabase();
			Database.stmt.sqlConnection = Database.ConnectFileDB;
			Database.stmt.text = "UPDATE FWData set Dropbox = 1 WHERE file_id = " + Upload_fileid + ";";
			Database.stmt.execute();
			
			DBFiles.UploadDataFiles(UploadFile,Upload_fileid);
			
		}else if(!DataViews.Dropbox.selected){
			
			Database = new FEDatabase();
			Database.stmt.sqlConnection = Database.ConnectFileDB;
			Database.stmt.text = "UPDATE FWData set Dropbox = 0 WHERE file_id = " + Upload_fileid + ";";
			Database.stmt.execute();
			
			DBFiles.DeleteDataFiles(Upload_fileid,UploadFile.name);
			
		}
		
		MY_FOLDER_CONFIG.UploadDB();
	}
	
}

