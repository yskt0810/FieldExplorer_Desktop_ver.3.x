import flash.events.Event;

import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;

import fe.core.codes.AddCategory;
import fe.core.codes.DeleteCategory;
import fe.core.codes.DeleteFolder;
import fe.core.codes.UpdateCategory;
import fe.core.files.Memo;
import fe.core.gps.ImportGPX;
import fe.core.gps.ImportNMEA;
import fe.core.networks.DropboxSetup;


public function menubar_change(e:MenuEvent):void{
	var popup:IFlexDisplayObject;
	var args:Object = new Object();
	var flag:int = 0;
	flag = int(e.item.@id);
	
	switch(flag){
		
		case 1:
			popup = PopUpManager.createPopUp(this,fe.core.codes.AddCategory,true);
			popup.addEventListener(CloseEvent.CLOSE, CloseCategoryPopup);
			PopUpManager.centerPopUp(popup);
			break;
		
		case 2:
			CURRENT_CAT_INDEX = TreeView.Categorys.selectedIndex;
			args.tab_name = TreeView.Categorys.selectedItem.tab_name;
			args.tab_id = TreeView.Categorys.selectedItem.tab_id;
			popup = PopUpManager.createPopUp(this,fe.core.codes.UpdateCategory,true);
			popup.addEventListener(CloseEvent.CLOSE,CloseCategoryPopup);
			IDataRenderer(popup).data = args;
			PopUpManager.centerPopUp(popup);
			break;
		
		case 3:
			args.tab_name = TreeView.Categorys.selectedItem.tab_name;
			args.tab_id = TreeView.Categorys.selectedItem.tab_id;
			popup = PopUpManager.createPopUp(this,fe.core.codes.DeleteCategory,true);
			popup.addEventListener(CloseEvent.CLOSE,CloseCategoryPopup);
			IDataRenderer(popup).data = args;
			PopUpManager.centerPopUp(popup);
			break;
		
		case 4:
			TreeView.addFolder();
			break;
		
		case 5:
			if(TreeView.CodeTree.selectedItem != null){
				args.tab_id = TreeView.Categorys.selectedItem.tab_id;
				args.tree_file = TreeView.Categorys.selectedItem.tree_file;
				args.folder_name = TreeView.CodeTree.selectedItem.@label;
				args.TargetFolder = TreeView.CodeTree.selectedItem;
				args.Tree = TreeView.Tree;
				popup = PopUpManager.createPopUp(this,fe.core.codes.DeleteFolder,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseFolderPopup);
				IDataRenderer(popup).data = args;
				PopUpManager.centerPopUp(popup);
			}
			break;
		
		case 6:
			if(TreeView.Categorys.selectedItem){
				if(TreeView.CodeTree.selectedItem){
					if(TreeView.CodeTree.selectedIndex != 0){
						args.selectedTabId = TreeView.Categorys.selectedItem.tab_id;
						args.selectedTabLabel = TreeView.Categorys.selectedItem.tab_name;
						args.selectedTreeFile = TreeView.Categorys.selectedItem.tree_file;
						args.selectedFolder = TreeView.CodeTree.selectedItem;
						args.selectedIdx = TreeView.CodeTree.selectedIndex;
						args.withFile = false;
						
						popup = PopUpManager.createPopUp(this, fe.core.files.Memo, true);
						popup.addEventListener(CloseEvent.CLOSE,CloseNewMemo);
						IDataRenderer(popup).data = args;
						PopUpManager.centerPopUp(popup);
					}
				}
			}
			break;
		
		case 7:
			TreeView.DeleteFile();
			var event:Event;
			TreeView.CallFileList(event);
			DataViews.ClearAllContents();
			break;
		
		case 8:
			popup =PopUpManager.createPopUp(this,fe.core.gps.ImportNMEA,true);
			popup.addEventListener(CloseEvent.CLOSE,CloseGPSImport);
			PopUpManager.centerPopUp(popup);
			break;
		
		case 9:
			popup =PopUpManager.createPopUp(this,fe.core.gps.ImportGPX,true);
			popup.addEventListener(CloseEvent.CLOSE,CloseGPSImport);
			PopUpManager.centerPopUp(popup);
			break;
		
		case 10:
			if(TreeView.CodeTree.selectedItem != null){
				if(TreeView.FileView.selectedItem != null){
					SpatialViews.CURRENT_FILE_ID = TreeView.FileView.selectedItem.file_id;
					SpatialViews.SetSinglePOIonMapCenter();	
				}
			}
			break;
		
		case 11:
			popup =PopUpManager.createPopUp(this,fe.core.networks.DropboxSetup,true);
			popup.addEventListener(CloseEvent.CLOSE,CloseDropboxSetup);
			PopUpManager.centerPopUp(popup);
			break;
		
		case 12:
			break;
		case 13:
			break;
		default:
			break;
	}
	
	
}