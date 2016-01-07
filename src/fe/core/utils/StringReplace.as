package fe.core.utils
{
	public class StringReplace
	{
		public function StringReplace()
		{
		}
		
		public function EscapeInjection(ReplaceChar:String):String{
			
			var NewChar:String = ReplaceChar.replace(/'/g, "''");
			return NewChar;
			
		}
		
		public function DateToString(date:Date):String{
			
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
			
			NewConvertDate = date.getFullYear().toString() + NewMonth + NewDate + NewHour + NewMinutes + NewSecond;
			
			return NewConvertDate;
		}
	}
}