package fe.core.setup
{
	import flash.filesystem.File;
	import flash.filesystem.StorageVolume;
	import flash.filesystem.StorageVolumeInfo;
	import flash.system.Capabilities;
	
	import fe.core.utils.ReadXMLFile;

	public class FEDirectory
	{
		
		public var UsbConfigFile:File = File.userDirectory.resolvePath("FieldExplorerTemp.xml");
		public var StorageType:int;
		public var StorageName:String;
		public var StoragePath:String;
		
		public var RootDirectory:String = "iFields";
		public var ConfigDirectory:String = RootDirectory + "/" + "config";
		public var DataDirectory:String = RootDirectory + "/" + "datas";
		
		public var RefConfigDirectory:String;
		public var RefDataDirectory:String;
		
		public var Timezone:int;
		
		public function FEDirectory()
		{
			
			if(UsbConfigFile.exists){
				
				var ReadConfig:ReadXMLFile = new ReadXMLFile();
				var Config:XML = ReadConfig.ReadMethod(UsbConfigFile);
				
				StorageType = Config.Storage.StorageType;
				StorageName = Config.Storage.StorageName;
				StoragePath = Config.Storage.StorageNativePath;
				
				Timezone = Config.Timezone;
				
				if(StorageType == 1){
					SetupDirectoryOnClient();
				}else if(StorageType == 2){
					SetupDirectoryOnUsb(StorageName,StoragePath,flash.system.Capabilities.os);
				}
			}else{
				SetupDirectoryOnClient();
			}
		}
		
		private function SetupDirectoryOnClient():void{
			
			var dir:File = new File();
			dir = File.userDirectory.resolvePath(RootDirectory);
			dir.createDirectory();
			
			dir = File.userDirectory.resolvePath(ConfigDirectory);
			dir.createDirectory();
			RefConfigDirectory = dir.nativePath;
			
			dir = File.userDirectory.resolvePath(DataDirectory);
			dir.createDirectory();
			RefDataDirectory = dir.nativePath;
			
		}
		
		private function SetupDirectoryOnUsb(Name:String,Path:String,OSType:String):void{
			
			var USBDir:File = new File(Path);
			trace(USBDir.exists);
			StorageName = Name;
			StoragePath = Path;
			
			var storageVolumes:Vector.<StorageVolume> = StorageVolumeInfo.storageVolumeInfo.getStorageVolumes();
			var length:int = storageVolumes.length;
			
			var flag:int = 0;
			
			for (var i:int = 0; i < length; i++){
				if(OSType == "Windows 7" || OSType == "Windows Vista" || OSType == "Windows XP"){
					if(storageVolumes[i].drive == StorageName){flag = 1; }
				}else{
					if(storageVolumes[i].name == StorageName){ flag = 1; }
				}
			}
			
			if(flag == 1){
				if(!USBDir.exists){
					USBDir.createDirectory();
				}
			}

			
			if(OSType == "Windows 7" || OSType == "Windows Vista" || OSType == "Windows XP"){
				USBDir = new File(StoragePath + ConfigDirectory);
			}else{
				USBDir = new File(StoragePath + "/" + ConfigDirectory);
			}	
			
			
			if(flag == 1){
				if(!USBDir.exists){
					USBDir.createDirectory();
				}
			}
			RefConfigDirectory = USBDir.nativePath;
			
			if(OSType == "Windows 7" || OSType == "Windows Vista" || OSType == "Windows XP"){
				USBDir = new File(StoragePath + DataDirectory);
			}else{
				USBDir = new File(StoragePath + "/" + DataDirectory);
			}
			
			if(flag == 1){
				if(!USBDir.exists){
					USBDir.createDirectory();
					
				}
			}
			
			trace(USBDir.exists);
			RefDataDirectory = USBDir.nativePath;
			
		}
	}
}