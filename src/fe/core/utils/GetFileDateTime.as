package fe.core.utils
{
	public class GetFileDateTime
	{
		
		public var year:String;
		public var month:String;
		public var day:String;
		
		public var hour:String;
		public var min:String;
		public var sec:String;
		
		public function GetFileDateTime()
		{
			
			year = new String();
			month = new String();
			day = new String();
			
			hour = new String();
			min = new String();
			sec = new String();
			
		}
		
		public function ConvertWithString(date:Date):Array{
			var Match:RegExp = new RegExp("^[0-9]$");
			var NewConvertDate:String;
			var NewMonth:String = (date.getMonth()+1).toString();
			var NewDate:String = (date.getDate()).toString();
			var NewHour:String = (date.getHours()).toString();
			var NewMinutes:String = (date.getMinutes()).toString();
			var NewSecond:String = (date.getSeconds()).toString();
			
			//var NewMonth:String = date.getFullYear().toString() + '/0' + (date.getMonth()+1).toString() + '/0' + date.getDate();
			
			if((date.getMonth()+1).toString().match(Match)){
				
				NewMonth = '0' + (date.getMonth()+1).toString();
				
			}
			
			if((date.getDate()).toString().match(Match)){
				
				NewDate = '0' + (date.getDate()).toString();
				
			}
			
			if((date.getHours()).toString().match(Match)){
				
				NewHour = '0' + (date.getHours()).toString();
				
			}
			
			if((date.getMinutes()).toString().match(Match)){
				
				NewMinutes = '0' + (date.getMinutes()).toString();
				
			}
			
			if((date.getSeconds()).toString().match(Match)){
				
				NewSecond = '0' + (date.getSeconds()).toString();
				
			}
			
			var NewYear:String = date.getFullYear().toString();
		
			
			var newDateArray:Array = new Array(NewYear,NewMonth,NewDate,NewHour,NewMinutes,NewSecond);
			
			return newDateArray;
			
		}
	}
}