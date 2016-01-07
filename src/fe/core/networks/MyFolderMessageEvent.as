package fe.core.networks
{
	import flash.events.Event;
	
	public class MyFolderMessageEvent extends Event
	{
		
		public static const COMPLETE:String = "Complete";
		
		public function MyFolderMessageEvent(type:String){
			super(type,false);
		}
		
		public override function clone():Event{
			return new MyFolderMessageEvent(type);
		}
	}
}