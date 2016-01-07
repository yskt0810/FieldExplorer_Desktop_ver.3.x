import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeWindowBoundsEvent;
import flash.events.NativeWindowDisplayStateEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;

import spark.events.TextOperationEvent;

import fe.core.setup.FEDatabase;
import fe.core.setup.FEDirectory;

import flashx.textLayout.operations.SplitParagraphOperation;

// ActionScript file
private function TemporalViewSizeChange(Event:NativeWindowBoundsEvent):void{
	
	var setWidth:Number = this.width / 2;
	var setHeight:Number = (this.height - consoles.height - SpatialViews.MapControl.height - TemporalViews.TimelineTool.height - TemporalViews.timeline.height - 100) / 2;
	
	TemporalViews.scheduleViewerWidth = setWidth;
	TemporalViews.scheduleViewerHeight = setHeight;
	SpatialViews.width = setWidth;
	//SpatialViews.height = TreeView.FileViewSpace.height;
	
	
}

private function TemporalViewFullChange(Event:NativeWindowDisplayStateEvent):void{
	
	var setWidth:Number = this.width / 2;
	var setHeight:Number = (this.height - consoles.height - SpatialViews.MapControl.height - TemporalViews.TimelineTool.height - TemporalViews.timeline.height - 100) / 2;
	
	TemporalViews.scheduleViewerWidth = setWidth;
	TemporalViews.scheduleViewerHeight = setHeight;
	SpatialViews.width = setWidth;
	//SpatialViews.height = TreeView.FileViewSpace.height;
	
	
}




private function CloseUSBSelectEvent(e:CloseEvent):void{
	
	Directory = new FEDirectory();
	Database = new FEDatabase();
	
	TreeView.Directory = new FEDirectory();
	TreeView.Database = new FEDatabase();
	
	SpatialViews.Directory = new FEDirectory();
	SpatialViews.Database = new FEDatabase();
	
	DataViews.Directory = new FEDirectory();
	DataViews.Database = new FEDatabase();
	
	
	TZ = Number((Directory.Timezone) * 60 * 60 * 1000);
	
	DataViews.TZ = TZ;
	SpatialViews.TZ = TZ;
	TemporalViews.TZ = TZ;
	
	TreeView.CategoryList = new ArrayCollection();
	TreeView.GetCategories(0);
	TreeView.TreeInitialized();
	
}





private function CloseCategoryPopup(e:CloseEvent):void{
	
	var AddedIndex:int = TreeView.GetMaxCategoryIndex();
	trace(AddedIndex);
	TreeView.GetCategories(AddedIndex);
	TreeView.GetMaxTreeFile();
	
}

private function CloseFolderPopup(e:CloseEvent):void{
	
	TreeView.GetCurrentTreeFile();
	
}

private function CloseFilePopup(e:CloseEvent):void{
	
	
	TreeView.GetCurrentTreeFile();
	TreeView.CallFileList(e);
	DataViews.ClearAllContents();
	
}

private function CloseNewMemo(e:CloseEvent):void{
	
	TreeView.CallFileList(e);
	TreeView.CodeTree.destroyItemEditor();
	
	
}

private function CloseGPSImport(e:CloseEvent):void{
	
	SpatialViews.getLogFileList();
	
}

private function SetProperties(event:Event):void{
	
	DataViews.ClearAllContents();
	if(SpatialViews.SinglePOIFlag){
		SpatialViews.MainMap.removeShape(SpatialViews.SinglePOI);
		SpatialViews.SinglePOIFlag = false;
	}
	if(SpatialViews.DayRouteOverRayFlag){
		SpatialViews.MainMap.removeShape(SpatialViews.DayRouteOverRay);
		SpatialViews.DayRouteOverRayFlag = false;
	}
	if(SpatialViews.GeoCodeFlag){
		SpatialViews.MainMap.removeShapes();
		SpatialViews.GeoCodeFlag = false;
	}
	
	
	
	if(TreeView.FileView.selectedItem != null){
		
		DataViews.Check(TreeView.FileView.selectedItem);
		if(DataViews.Latitude.text != "" && DataViews.Longitude.text != ""){
			//SpatialViews.ChoosedDate.selectedDate = new Date(TreeView.FileView.selectedItem.date);
			TemporalViews.select.selectedDate = new Date(TreeView.FileView.selectedItem.date);
			var tmpDate:Date = new Date(TreeView.FileView.selectedItem.date);
			var tmp2Date:Date = new Date(tmpDate.getFullYear(),tmpDate.getMonth(),tmpDate.getDate());
			SpatialViews.DayRouteMapping(tmp2Date);
			SpatialViews.CURRENT_LAT = DataViews.Latitude.text;
			SpatialViews.CURRENT_LON = DataViews.Longitude.text;
			SpatialViews.SinglePOISetting(Number(SpatialViews.CURRENT_LAT),Number(SpatialViews.CURRENT_LON));
			SpatialViews.CURRENT_FILE_ID = TreeView.FileView.selectedItem.file_id;
			//trace(SpatialViews.CURRENT_FILE_ID);
			CURRENT_FILE_INDEX = TreeView.FileView.selectedIndex;
			
			TemporalViews.SELECT_FILE_ID = TreeView.FileView.selectedItem.file_id;
			var current:ArrayCollection = new ArrayCollection();
			current = TreeView.FileLists;
			TemporalViews.UpdateDataWithEntryClick(current);
		}
	}
	
	
	
	
	
}

private function DataPropertyFileNameDoubleClick(event:MouseEvent):void{
	// if(DataViews.file_name.text != ""){
	event.preventDefault();
	DataViews.file_name.editable = true;
	DataViews.file_name.setStyle("contentBackgroundColor",0xDDFFF6);					
	// }
	
	
}

private function DataPropertyDescriptionDoubleClick(event:MouseEvent):void{
	
	event.preventDefault();
	　// if(DataViews.description.text != ""){
	DataViews.description.editable = true;
	DataViews.description.setStyle("contentBackgroundColor",0xDDFFF6);
	
	
}

private function DataPropertyFileHourDoubleClick(event:MouseEvent):void{
	
	if(DataViews.FileHour.text != ""){
		DataViews.FileHour.editable =true;
		DataViews.FileHour.setStyle("contentBackgroundColor",0xDDFFF6);					
	}
	
}

private function DataPropertyFileMinDoubleClick(event:MouseEvent):void{
	
	if(DataViews.FileMin.text != ""){
		DataViews.FileMin.editable = true;
		DataViews.FileMin.setStyle("contentBackgroundColor",0xDDFFF6);					
	}
	
}

private function DataPropertyFilesecDoubleClick(event:MouseEvent):void{
	
	if(DataViews.FileSec.text != ""){
		DataViews.FileSec.editable = true;
		DataViews.FileSec.setStyle("contentBackgroundColor",0xDDFFF6);
	}
	
}


private function FolderChangeHandler(event:Event):void{
	
	
	TreeView.CallFileList(event);
	DataViews.ClearAllContents();
	TemporalViews.UpdateDataWithFolderChange(TreeView.CodeTree.selectedItem.@id,TreeView.Categorys.selectedItem.tab_id);
	
	if(SpatialViews.SinglePOIFlag){
		SpatialViews.MainMap.removeShapes();
	}
	
	if(SpatialViews.DayRouteOverRayFlag){
		SpatialViews.MainMap.removeShapes();
	}
	
	if(SpatialViews.MultiPOIFlag){
		SpatialViews.MainMap.removeShapes();
	}
	
	if(TreeView.FileLists != null){
		SpatialViews.SetMultiPOI(TreeView.FileLists);
	}
	
	
	
}

private function DataPropertyFileNameChangeFinish(event:FlexEvent):void{
	
	
	
	if(TreeView.FileView.selectedItem != null){
		
		DataViews.file_name.editable = false;
		DataViews.filelabel_change();
		DataViews.file_name.setStyle("contentBackgroundColor",0xFFFFFF);
		TreeView.CallFileList(event);
		TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
		
	}
	
	
}

private function DataPropertyDescriptionChangeFinish(event:TextOperationEvent):void{
	
	if(event.operation is SplitParagraphOperation){
		event.preventDefault();
		if(TreeView.FileView.selectedItem != null){
			if(DataViews.FileDate.selectedDate == null){ DataViews.FileDate.selectedDate = new Date(DataViews.FileInfo.date); }
			DataViews.description.editable = false;
			DataViews.description_change();
			DataViews.description.setStyle("contentBackgroundColor",0xFFFFFF);
			TreeView.CallFileList(event);
			TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
		}
	}
	
	
	
}

private function DataPropertyFileDateChange(event:Event):void{
	
	if(TreeView.FileView.selectedItem != null){
		DataViews.Date_Change();
		TreeView.CallFileList(event);
		TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
	}
	
}

private function DataPropertyFileHourChangeFinish(event:FlexEvent):void{
	if(TreeView.FileView.selectedItem != null){
		if(DataViews.FileHour.text == ""){ DataViews.FileHour.text = DataViews.GetDateArray[3]; }
		DataViews.FileHour.editable = false;
		DataViews.Date_Change();
		DataViews.FileHour.setStyle("contentBackgroundColor",0xFFFFFF);
		TreeView.CallFileList(event);
		TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
	}				
}

private function DataPropertyFileMinChangeFinish(event:FlexEvent):void{
	if(TreeView.FileView.selectedItem != null){
		if(DataViews.FileMin.text == ""){ DataViews.FileMin.text = DataViews.GetDateArray[4]; }
		DataViews.FileMin.editable = false;
		DataViews.Date_Change();
		DataViews.FileMin.setStyle("contentBackgroundColor",0xFFFFFF);
		TreeView.CallFileList(event);
		TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
	}
}

private function DataPropertyFileSecChangeFinish(event:FlexEvent):void{
	if(TreeView.FileView.selectedItem != null){
		if(DataViews.FileSec.text == ""){ DataViews.FileSec.text = DataViews.GetDateArray[5]; }
		DataViews.FileSec.editable = false;
		DataViews.Date_Change();
		DataViews.FileMin.setStyle("contentBackgroundColor",0xFFFFFF);
		TreeView.CallFileList(event);	
		TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
	}
}

private function onSpatialViewGPSLogChange(event:Event):void{
	
	DataViews.ClearAllContents();
	
	Database = new FEDatabase();
	Database.stmt.sqlConnection = Database.ConnectGPSDB;
	Database.stmt.text = "SELECT id,date,Latitude,Longitude FROM GPSLog " + 
		"WHERE log_filename = '" + SpatialViews.LogFileList.selectedItem.log_filename + "';";
	Database.stmt.execute();
	
	var gps:ArrayCollection = new ArrayCollection(Database.stmt.getResult().data);
	var maxLat:Number = 0.0;
	var minLat:Number = 0.0;
	var maxLng:Number = 0.0;
	var minLng:Number = 0.0;
	var maxDate:Number = 0.0;
	var minDate:Number = 0.0;
	
	for (var i:int = 0; i<gps.length; i++){
		if(i==0){
			maxLat = gps[i].Latitude;
			minLat = gps[i].Latitude;
			maxLng = gps[i].Longitude;
			minLng = gps[i].Longitude;
			maxDate = gps[i].date;
			minDate = gps[i].date;
		}else{
			
			if(gps[i].Latitude > maxLat){
				maxLat = gps[i].Latitude;
			}
			if(gps[i].Latitude < minLat){
				minLat = gps[i].Latitude;
			}
			if(gps[i].Longitude > maxLng){
				maxLng = gps[i].Longitude;
			}
			if(gps[i].Longitude < minLng){
				minLng = gps[i].Longitude;
			}
			if(gps[i].date > maxDate){
				maxDate = gps[i].date;
			}
			if(gps[i].date < minDate){
				minDate = gps[i].date;
			}
		}
		
	}
	
	Database.stmt.sqlConnection = Database.ConnectFileDB;
	Database.stmt.text = "SELECT file_id,file_name,file_path,file_label,folder_id,tab_id,date,Latitude,Longitude FROM FWData " + 
		"WHERE (date >= " + minDate + 
		" AND date <= " + maxDate + 
		") AND Latitude >= " + minLat + 
		" AND Latitude <= " + maxLat + 
		" AND Longitude >= " + minLng + 
		" AND Longitude <= " + maxLng +
		" ORDER BY date;";
	trace(Database.stmt.text);
	Database.stmt.execute();
	var res:ArrayCollection = new ArrayCollection(Database.stmt.getResult().data);
	trace(res.length);
	
	if(SpatialViews.LogFileList.selectedItem != null){
		SpatialViews.LogRouteMapping(gps);
		TemporalViews.setDataFromGPSLog(res);
		TemporalViews.select.selectedDate = new Date(minDate);
		if(!SpatialViews.MultiPOIFlag){
			SpatialViews.SetMultiPOI(res);
		}
		TreeView.FileLists = res;
	}
	
}

private function onTemporalViewDateChange(event:Event):void{
	
	DataViews.ClearAllContents();
	
	var SelectDate:Date = TemporalViews.select.selectedDate;
	
	Database = new FEDatabase();
	Database.stmt.sqlConnection = Database.ConnectFileDB;
	Database.stmt.text = "SELECT file_id,file_name,file_path,file_label,folder_id,tab_id,date,Latitude,Longitude FROM FWData " + 
		"WHERE (date - " + TZ + ") >= " + SelectDate.time  + 
		" AND (date - " + TZ + ") <= " + (SelectDate.time + 86400000) +
		" ORDER BY date;";
	
	Database.stmt.execute();
	var res:ArrayCollection = new ArrayCollection(Database.stmt.getResult().data);
	
	if(TemporalViews.select.selectedDate != null){
		SpatialViews.DayRouteMapping(TemporalViews.select.selectedDate);
		TemporalViews.onChangeDate(TemporalViews.select.selectedDate);
		
		if(!SpatialViews.MultiPOIFlag){
			SpatialViews.SetMultiPOI(res);
		}
		
		TreeView.FileLists = res;
		
	}
	
	
	
}

private function GeoLocationChange(event:Event):void{
	
	//DataViews.ClearAllContents();
	TreeView.ReCallFileList(event);
	TreeView.FileView.selectedIndex = CURRENT_FILE_INDEX;
	
}

public function CloseDropboxSetup(event:CloseEvent):void{
	
}


