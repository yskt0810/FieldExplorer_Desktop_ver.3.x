package fe.core.gps
{
	import com.adobe.gpslib.GPXService;
	import com.adobe.gpslib.gpx.Track;
	import com.adobe.gpslib.gpx.Waypoint;
	import com.adobe.gpslib.gpx.events.ParseEvent;
	
	import mx.collections.ArrayCollection;
	
	public class Gpx
	{
		
		private var time:String = ""; // 測位時刻（UTC）
		private var lat:String = ""; // 緯度
		private var lon:String = ""; // 経度
		private var accu:String = ""; // 0=受信不能／ 1=単独測位 ／ 2=DGPS
		private var num_of_sat:String = ""; // 受信衛星数
		private var hdop:String = ""; // HDOP(Horaizontal Dilution of Precision）＝水平精度劣化率
		private var alt:String = ""  // 平均海水面からの高度
		
		private var stat:String = ""; // A=有効／  V=無効
		private var date:String = ""; // 日付（UTC）
		private var direc:String = ""; // 真北に対する進行方向
		private var speed:String = ""; // 対地速度（km/h）
		private var pdop:String = ""; // PDOP(Position Dilution of Precision) = 位置精度劣化率
		private var vdop:String = ""; // VDOP(Vertical Dilution of Precision) = 垂直精度劣化率
		
		public var GPSLogData:ArrayCollection;
		
		
		public function Gpx()
		{
			
			GPSLogData = new ArrayCollection();
			
		}
		
		public function GpxLoad(logdata:XML):void{
			
			var gpxSrv:GPXService = new GPXService();
			gpxSrv.addEventListener(ParseEvent.PARSE_COMPLETE,onGpxParse);
			gpxSrv.load(logdata);
			
		}
		
		public function onGpxParse(event:ParseEvent):void{
			
			var len:int = event.gpx.arrTracks.length;
			var EachData:Object = new Object();
			GPSLogData = new ArrayCollection();
			
			var trk:Track = event.gpx.arrTracks[i] as Track;
			len = trk.trackSegment.length;
			
			for(var i:int=0; i<len; i++){
				var wpt:Waypoint = trk.trackSegment[i] as Waypoint;
				var tmpDate:Date = wpt.time;
				date = tmpDate.getUTCFullYear().toString() + "-" + (tmpDate.getUTCMonth() + 1).toString() + "-" + tmpDate.getUTCDate().toString();
				time = tmpDate.getUTCHours().toString() + ":" + tmpDate.getUTCMinutes().toString() + ":" + tmpDate.getUTCSeconds().toString();
				lat = String(wpt.latitude);
				lon = String(wpt.longitude);
				EachData = new Object();
				var tmp_time:String = "";
				var tmp_lat:String = "";
				var tmp_lon:String = "";
				var tmp_accu:String = "";
				var tmp_pdop:String = "";
				var tmp_hdop:String = "";
				var tmp_vdop:String = "";
				
				if(lat != ""){
					if(lon != ""){
						if(date != ""){
							if(time != ""){
								//var DateTime:String = date + " " + time;
								EachData.Date = date;
								EachData.Time = time;
								EachData.lat = wpt.latitude;
								EachData.lon = wpt.longitude;
								EachData.accu = accu;
								EachData.pdop = wpt.pdop;
								EachData.hdop = wpt.hdop;
								
								EachData.vdop = wpt.vdop;
								var rev_alt:Number = Number(wpt.elevation); //+ "m";
								EachData.alt = rev_alt;
								EachData.stat = stat;
								EachData.direc = direc;
								
								var rev_speed:String = speed + "km/h";
								EachData.speed = rev_speed;
								
								if(EachData != null){
									
									//GPSlogData.addItem(EachData);
									GPSLogData.addItem(EachData);
								}
								
								tmp_time = time;
								tmp_lat = lat;
								tmp_lon = lon;
								tmp_accu = accu;
								tmp_pdop = pdop;
								tmp_hdop = hdop;
								tmp_vdop = vdop;	
								
								
							}
						}
					}
				}
				
			}
		}
		
		
	}
}