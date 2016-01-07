package fe.core.gps
{
	
	import flash.data.SQLResult;
	
	import fe.core.setup.FEDatabase;

	public class Gpsutils
	{
		public var GPSDatabase:FEDatabase;
		
		public function Gpsutils()
		{
			GPSDatabase = new FEDatabase();
			GPSDatabase.stmt.sqlConnection = GPSDatabase.ConnectGPSDB;
		}
		
		public function RemoveNS(InputLat:String):String{
			var NS:String = InputLat.substr(0,1);
			var OutputLat:String;
			
			if(NS == "N"){
				OutputLat = InputLat.replace("N","");
			}else if(NS == "S"){
				OutputLat = InputLat.replace("S","-");
			}
			
			return OutputLat;
		}
		
		public function RemoveEW(InputLon:String):String{
			var EW:String = InputLon.substr(0,1);
			var OutputLon:String;
			
			if(EW == "E"){
				OutputLon = InputLon.replace("E","");
			}else if(EW == "W"){
				OutputLon = InputLon.replace("W","-");
			}
			
			return OutputLon;
			
		}
		
		public function GetMatchedLatLon(minTime:Number,maxTime:Number):Array{
			
			GPSDatabase.stmt.text = "SELECT id,date,Latitude,Longitude FROM GPSLog " + 
				"WHERE date >= " + minTime + " AND date <= " + maxTime + " ORDER BY date LIMIT 30;";
			GPSDatabase.stmt.execute();
			
			var result:SQLResult = GPSDatabase.stmt.getResult();
			var MatchedGPSArray:Array = result.data;
			
			return MatchedGPSArray;
			
		}
		
		
	}
}