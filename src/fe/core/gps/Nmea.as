package fe.core.gps
{
	import mx.collections.ArrayCollection;
	
	import fe.core.setup.FEDatabase;

	public class Nmea
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
		
		private var past_date:String // 1つ前のログの日付
		private var past_time:String // 1つ前のログの時間
		
		public var GPSLogData:ArrayCollection = new ArrayCollection();
		
		[Bindable] public var progress:int;
		[Bindable] public var max_progress:int;

		
		public function Nmea()
		{
			GPSLogData = new ArrayCollection();
			
		}
		
		public function nmeaParse(logdata:Array):ArrayCollection{
			var EachData:Object = new Object();
			GPSLogData = new ArrayCollection();
			
			var tmp_time:String = "";
			var tmp_lat:String = "";
			var tmp_lon:String = "";
			var tmp_accu:String = "";
			var tmp_pdop:String = "";
			var tmp_hdop:String = "";
			var tmp_vdop:String = "";
			
			for each(var data:String in logdata){
				
				var line:Array = data.split(",");
				if(line[0] == "$GPGGA"){
					
					var hour:String = String(line[1]).substr(0,2);
					var min:String  = String(line[1]).substr(2,2);
					var sec:String  = String(line[1]).substr(4,2);
					// var sec00:String = String(line[1]).substr(7,2);
					time = hour + ":" + min + ":" + sec;
					
					var deg:Number = Number(String(line[2]).substr(0,2));
					var minimu:Number = Number(String(line[2]).substr(2,9));
					var degmin:Number = deg + minimu / 60;
					lat = line[3] + String(degmin);
					
					deg = Number(String(line[4]).substr(0,3));
					minimu = Number(String(line[4]).substr(3,9));
					degmin = deg + minimu / 60;
					lon = line[5] + String(degmin);
					
					accu = line[6];
					num_of_sat = line[7];
					hdop = line[8];
					alt = line[9];
					
				}else if(line[0] == "$GPRMC"){
					
					stat = line[2];
					
					var day:String = String(line[9]).substr(0,2);
					var month:String = String(line[9]).substr(2,2);
					var year:int = int(String(line[9].substr(4,2))) + 2000;
					
					date = String(year) + "/" + month + "/" + day;
					
					var kmspd:Number;
					
					speed = line[7];
					direc = line[8];
					kmspd = Number(speed) * 1.85;
					speed = String(int(kmspd));
					
				}else if(line[0] == "$GPVTG"){
					
					
					direc = line[1]
					speed = line[7];
					
				}else if(line[0] == "$GPGSA"){
					
					pdop = line[15];
					var csum:String;
					var tmp:Array = String(line[17]).split("\*");
					vdop = tmp[0];
					csum = tmp[1];
				}
				
				EachData = new Object();
				
				if(lat != ""){
					if(lon != ""){
						if(date != ""){
							if(time != ""){
								//var DateTime:String = date + " " + time;
								EachData.Date = date;
								EachData.Time = time;
								EachData.lat = lat;
								EachData.lon = lon;
								EachData.accu = accu;
								EachData.pdop = pdop;
								EachData.hdop = hdop;
								
								EachData.vdop = vdop;
								
								var rev_alt:Number = Number(alt); //+ "m";
								EachData.alt = rev_alt;
								EachData.stat = stat;
								EachData.direc = direc;
								
								var rev_speed:String = speed;
								EachData.speed = rev_speed;
								
								if(EachData != null){
									
									if(time != tmp_time){
										//GPSlogData.addItem(EachData);
										GPSLogData.addItem(EachData);
									}
									
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
			
			return GPSLogData;	
		}
		
		public function ImportNMEA(Result:ArrayCollection,prifex:String,fname:String):void{
			
			var Database:FEDatabase = new FEDatabase();
			Database.stmt.sqlConnection = Database.ConnectGPSDB;
			
			var hold_time:String;
			max_progress = Result.length;
			progress = 0;
			
			for each (var tmp:Object in Result){
				if(tmp.Date != ""){
					if(tmp.Time != ""){
						if(tmp.lat != ""){
							if(tmp.lon != ""){
								
								var SplitDate:Array = String(tmp.Date).split("/");
								var SplitTime:Array = String(tmp.Time).split(":");									
								
								var RegDate:Date = 
									new Date(int(SplitDate[0]),int(SplitDate[1]) - 1,int(SplitDate[2]),
										int(SplitTime[0]),int(SplitTime[1]),int(SplitTime[2]));
								
								// 事前にGoogle Map 形式の文字列にしておく
								var Latitude:String;
								var Lotation:String;
								
								if(prifex == "log"){
									var NS:String = String(tmp.lat).substr(0,1);
									
									if(NS == "N"){
										Latitude = String(tmp.lat).replace("N","");
									}else if(NS == "S"){
										Latitude = String(tmp.lat).replace("S","-");
									}
									
									var EW:String = String(tmp.lon).substr(0,1);
									
									if(EW == "E"){
										Lotation = String(tmp.lon).replace("E","");
									}else if(EW == "W"){
										Lotation = String(tmp.lon).replace("W","-");
									}
								}else if(prifex == "gpx"){
									Latitude = tmp.lat;
									Lotation = tmp.lon;
								}
								
								
									Database.stmt.text = "INSERT INTO GPSLog (date,log_filename,Latitude,Longitude) VALUES" + 
										" (" + RegDate.time + ",'" + fname + "','" + Latitude + "','" + Lotation + "');";
									Database.stmt.execute();
								
								
								hold_time = tmp.Time;
							}
						}
					}
				}
			}
			
			
		}
		
		
	}
}