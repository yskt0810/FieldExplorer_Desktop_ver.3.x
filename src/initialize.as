import com.mapquest.LatLng;

import flash.data.SQLResult;
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.NativeWindowBoundsEvent;
import flash.events.NativeWindowDisplayStateEvent;
import flash.events.StorageVolumeChangeEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.filesystem.StorageVolumeInfo;

import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

import spark.events.TextOperationEvent;

import fe.core.networks.MyDropboxDB;
import fe.core.networks.MyDropboxDirectory;
import fe.core.networks.MyDropboxFileUpload;
import fe.core.setup.FEDatabase;
import fe.core.setup.FEDirectory;
import fe.core.setup.GetFEConfigs;
import fe.core.setup.USBSelect;
import fe.core.utils.ReadXMLFile;

import org.hamster.dropbox.DropboxClient;
import org.hamster.dropbox.DropboxConfig;


public var API_KEY:String;
public var API_SECRET:String;
public var ACC_KEY:String;
public var ACC_SECRET:String;
public var REQ_KEY:String;
public var REQ_SECRET:String;
public var MYFOLDER_NAME:String;

[Bindable] public var dropboxAPI:DropboxClient;
[Bindable] public var MY_SHARE_FOLDER:MyDropboxDirectory;
[Bindable] public var MY_FOLDER_CONFIG:MyDropboxDB;
public var DROPBOX_CONNECT:Boolean = false;


private function onCC():void{
	
	this.minWidth = 1024;
	this.minHeight = 768;
	
	TemporalViews.scheduleViewerWidth = SpatialViews.width;
	TemporalViews.scheduleViewerHeight = (this.height - consoles.height - TemporalViews.TimelineTool.height - TemporalViews.timeline.height - 100) / 2;
	//SpatialViews.height = TreeView.FileViewSpace.height;
	
	CONFIGRATION = new GetFEConfigs();
	//CodeTree.addEventListener(ListEvent.CHANGE,CallFileList);
	TreeView.CodeTree.addEventListener(ListEvent.CHANGE,FolderChangeHandler);
	TreeView.FileView.addEventListener(Event.CHANGE,SetProperties);
	SpatialViews.MainMap.setCenter(new LatLng(CONFIGRATION.START_LAT,CONFIGRATION.START_LON), 3);
	//SpatialViews.ChoosedDate.addEventListener(Event.CHANGE,onTemporalViewDateChange);
	TemporalViews.select.addEventListener(Event.CHANGE,onTemporalViewDateChange);
	SpatialViews.LogFileList.addEventListener(Event.CHANGE,onSpatialViewGPSLogChange);
	
	
	NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,true);
	
	DataViews.file_name.addEventListener(MouseEvent.DOUBLE_CLICK,DataPropertyFileNameDoubleClick);
	DataViews.file_name.addEventListener(FlexEvent.ENTER,DataPropertyFileNameChangeFinish);
	
	DataViews.description.addEventListener(MouseEvent.DOUBLE_CLICK,DataPropertyDescriptionDoubleClick);
	DataViews.description.addEventListener(TextOperationEvent.CHANGING,DataPropertyDescriptionChangeFinish);
	
	
	DataViews.FileDate.addEventListener(Event.CHANGE,DataPropertyFileDateChange);
	
	DataViews.FileHour.addEventListener(MouseEvent.DOUBLE_CLICK,DataPropertyFileHourDoubleClick);
	DataViews.FileHour.addEventListener(FlexEvent.ENTER,DataPropertyFileHourChangeFinish);
	
	DataViews.FileMin.addEventListener(MouseEvent.DOUBLE_CLICK,DataPropertyFileMinDoubleClick);
	DataViews.FileMin.addEventListener(FlexEvent.ENTER,DataPropertyFileMinChangeFinish);
	
	DataViews.FileSec.addEventListener(MouseEvent.DOUBLE_CLICK,DataPropertyFilesecDoubleClick);
	DataViews.FileSec.addEventListener(FlexEvent.ENTER,DataPropertyFileSecChangeFinish);
	
	this.addEventListener(NativeWindowBoundsEvent.RESIZING,TemporalViewSizeChange,false);
	this.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,TemporalViewFullChange,false);
	trace(SpatialViews.height,TemporalViews.height);
}

private function onDropboxCC():void{
	
	var readSetting:ReadXMLFile = new ReadXMLFile();
	var networkSetting:XML = new XML();
	var settingFile:File = File.applicationStorageDirectory.resolvePath("networksetting.xml");
	
	if(settingFile.exists){
		networkSetting = readSetting.ReadMethod(settingFile);
		API_KEY = networkSetting.api_key;
		API_SECRET = networkSetting.api_secret;
		ACC_KEY = networkSetting.acc_key;
		ACC_SECRET = networkSetting.acc_secret;
		REQ_KEY = networkSetting.req_key;
		REQ_SECRET = networkSetting.req_secret;
		MYFOLDER_NAME = networkSetting.MyFolderName;
		
		if(API_KEY != "" && API_SECRET != "" && MYFOLDER_NAME != ""){
			
			if(ACC_KEY != "" && ACC_SECRET != ""){
				if(REQ_KEY != "" && REQ_KEY != ""){
					var config:DropboxConfig = new DropboxConfig(API_KEY,API_SECRET);
					config.accessTokenKey = ACC_KEY;
					config.accessTokenSecret = ACC_SECRET;
					config.requestTokenKey = REQ_KEY;
					config.requestTokenSecret = REQ_SECRET;
					dropboxAPI = new DropboxClient(config);
					
					MY_SHARE_FOLDER = new MyDropboxDirectory(dropboxAPI,MYFOLDER_NAME);
					MY_FOLDER_CONFIG = new MyDropboxDB(dropboxAPI,MY_SHARE_FOLDER);
					DROPBOX_CONNECT = true;
					
					DataViews.Dropbox.addEventListener(Event.CHANGE,onDropboxChecked,false);
					
				}
			}
		}
	}
	
	
}

private function onAC():void{
	
	StorageVolumeInfo.storageVolumeInfo.addEventListener(StorageVolumeChangeEvent.STORAGE_VOLUME_UNMOUNT,onVolumeUnmount);
	var popup:IFlexDisplayObject;
	
	popup = PopUpManager.createPopUp(this,fe.core.setup.USBSelect,true);
	popup.addEventListener(CloseEvent.CLOSE,CloseUSBSelectEvent);
	PopUpManager.centerPopUp(popup);
	
}

private function onVolumeUnmount(e:StorageVolumeChangeEvent):void{
	var Directory:FEDirectory = new FEDirectory();
	
	var readStream:FileStream = new FileStream();
	readStream.open(Directory.UsbConfigFile, FileMode.READ);
	
	var TempConfigXML:XML = new XML();
	TempConfigXML = XML(readStream.readUTFBytes(readStream.bytesAvailable));
	readStream.close();
	
	var StorageType:int = TempConfigXML.Storage.StorageType;
	var StoragePath:String = TempConfigXML.Storage.StorageNativePath;
	
	if(e.rootDirectory.nativePath == StoragePath){
		var popup:IFlexDisplayObject;
		// args.id = event.item.@id;
		popup = PopUpManager.createPopUp(this, USBSelect, true);
		popup.addEventListener(CloseEvent.CLOSE, CloseUSBSelectEvent);
		// IDataRenderer(popup).data = args;
		PopUpManager.centerPopUp(popup);
	}
}

private function cl():void{
	var TempFile:File = File.userDirectory.resolvePath("FieldExplorerTemp.xml");
	if(TempFile.exists){
		TempFile.deleteFile();
	}
	
	if(DROPBOX_CONNECT){
		Database = new FEDatabase();
		Database.stmt.sqlConnection = Database.ConnectFileDB;
		Database.stmt.text = "SELECT tree_file FROM Tab;";
		Database.stmt.execute();
		
		var res:SQLResult = new SQLResult();
		res = Database.stmt.getResult();
		var upload:MyDropboxFileUpload = new MyDropboxFileUpload(dropboxAPI,MY_SHARE_FOLDER,Directory);
		for(var i:int = 0; i<res.data.length; i++){
			var tree_file:File = File.userDirectory.resolvePath(Directory.ConfigDirectory + "/" + res.data[i].tree_file);
			upload.UploadTreeFiles(tree_file);
		}
		
		MY_FOLDER_CONFIG.UploadDB();
		
	}
	
}



