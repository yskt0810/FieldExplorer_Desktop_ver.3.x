package fe.core.setup
{
	
	import flash.data.SQLResult;
	
	import fe.core.gps.Gpsutils;
	import fe.core.utils.ReadXMLFile;
	import fe.core.utils.WriteXMLFile;
	
	public class GetFEConfigs
	{
		
		public var CONFIGRATION:SetFEConfigs;
		public var START_LAT:Number;
		public var START_LON:Number;
		
		public function GetFEConfigs()
		{
			
			CONFIGRATION = new SetFEConfigs();
			START_LAT = new Number();
			START_LON = new Number();
			
			
			
			var Database:FEDatabase = new FEDatabase();
			Database.stmt.sqlConnection = Database.ConnectGPSDB;
			Database.stmt.text = "SELECT Latitude, Longitude FROM GPSLog ORDER BY date DESC LIMIT 1";
			Database.stmt.execute();
			
			var result:SQLResult = Database.stmt.getResult();
			var gpsutil:Gpsutils = new Gpsutils();
			var Lat:String;
			var Lon:String;
			var HasResult:Boolean = false;
			
			if(result.data != null){
				Lat = gpsutil.RemoveNS(result.data[0].Latitude);
				Lon = gpsutil.RemoveEW(result.data[0].Longitude);
				HasResult = true;
			}
			
			SetStartLat(Lat,HasResult);
			SetStartLon(Lon,HasResult);
			
			
			
			
		}
		
		public function SetStartLat(Lat:String,HasResult:Boolean):void{
			
			var ReadXML:ReadXMLFile = new ReadXMLFile();
			var ConfigXML:XML = ReadXML.ReadMethod(CONFIGRATION.ConfigFile);
			
			var WriteXML:WriteXMLFile = new WriteXMLFile();
			var addXMLString:String;
			var addXML:XML;
			var UpdateConfigXML:String;
			
			if(ConfigXML.hasOwnProperty("StartLatitude")){
				START_LAT = Number(ConfigXML.StartLatitude);
				if(START_LAT == 0){
					if(HasResult){
						START_LAT = Number(Lat);
						ConfigXML.StartLatitude = START_LAT;
						UpdateConfigXML = String(ConfigXML);
						WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
					}
				}else{
					if(HasResult){
						if(START_LAT != Number(Lat)){
							START_LAT = Number(Lat);
							ConfigXML.StartLatitude = START_LAT;
							UpdateConfigXML = String(ConfigXML);
							WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
						}
					}
				}
			}else{
				if(HasResult){
					START_LAT = Number(Lat);
				}else{
					START_LAT = 0;
				}
				
				addXMLString = '<StartLatitude>' + START_LAT + '</StartLatitude>';
				addXML = XML(addXMLString);
				ConfigXML.appendChild(addXML);
				UpdateConfigXML = String(ConfigXML);
				WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
			}
			
		}
		
		public function SetStartLon(Lon:String,HasResult:Boolean):void{
			
			var ReadXML:ReadXMLFile = new ReadXMLFile();
			var ConfigXML:XML = ReadXML.ReadMethod(CONFIGRATION.ConfigFile);
			
			var WriteXML:WriteXMLFile = new WriteXMLFile();
			var addXMLString:String;
			var addXML:XML;
			var UpdateConfigXML:String;
			
			if(ConfigXML.hasOwnProperty("StartLongitude")){
				START_LON = Number(ConfigXML.StartLongitude);
				if(START_LON == 180){
					if(HasResult){
						START_LON = Number(Lon);
						ConfigXML.StartLongitude = START_LON;
						UpdateConfigXML = String(ConfigXML);
						WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
					}
				}else{
					if(HasResult){
						if(START_LON != Number(Lon)){
							START_LON = Number(Lon);
							ConfigXML.StartLatitude = START_LON;
							UpdateConfigXML = String(ConfigXML);
							WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
						}
					}
				}
			}else{
				if(HasResult){
					START_LON = Number(Lon);
				}else{
					START_LON = 180;
				}
				
				addXMLString = '<StartLongitude>' + START_LON + '</StartLongitude>';
				addXML = XML(addXMLString);
				ConfigXML.appendChild(addXML);
				UpdateConfigXML = String(ConfigXML);
				WriteXML.WriteMethod(UpdateConfigXML,CONFIGRATION.ConfigFile);
			}
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}