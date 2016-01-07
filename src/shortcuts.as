import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.core.IDataRenderer;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

import fe.core.codes.AddCategory;
import fe.core.codes.DeleteCategory;
import fe.core.codes.DeleteFolder;
import fe.core.codes.UpdateCategory;
import fe.core.files.Memo;
import fe.core.gps.ImportGPX;
import fe.core.gps.ImportNMEA;

// ActionScript file
//========================================================
// キーボードショートカット定義
//========================================================

/**
 * ショートカット定義のルール
 * カテゴリ関連：ALT (MacはOptionキー) + 
 * フォルダ関連：Ctrl +
 * ファイル情報操作関連：Ctrl + Alt (MacはOptionキー) +
 * GPS関連など：Alt + Shift
 */

private function onKeyDown(e:KeyboardEvent):void{
	
	args = new Object();
	if(e.altKey){
		
		switch(e.keyCode){
			
			case Keyboard.T: // Add Category
				popup = PopUpManager.createPopUp(this,fe.core.codes.AddCategory,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseCategoryPopup);
				PopUpManager.centerPopUp(popup);
				break;
			
			case Keyboard.U: // Update Category
				CURRENT_CAT_INDEX = TreeView.Categorys.selectedIndex;
				args.tab_name = TreeView.Categorys.selectedItem.tab_name;
				args.tab_id = TreeView.Categorys.selectedItem.tab_id;
				popup = PopUpManager.createPopUp(this,fe.core.codes.UpdateCategory,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseCategoryPopup);
				IDataRenderer(popup).data = args;
				PopUpManager.centerPopUp(popup);
				break;
			
			case Keyboard.D: // Delete Category
				args.tab_name = TreeView.Categorys.selectedItem.tab_name;
				args.tab_id = TreeView.Categorys.selectedItem.tab_id;
				popup = PopUpManager.createPopUp(this,fe.core.codes.DeleteCategory,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseCategoryPopup);
				IDataRenderer(popup).data = args;
				PopUpManager.centerPopUp(popup);
				break;
			
			default:
				break;
		}
	}
	
	if(e.controlKey){
		
		switch (e.keyCode){
			
			case Keyboard.F: // AddFolder
				TreeView.addFolder();
				break;
			
			case Keyboard.R: // Delete Folder
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
			
			default:
				break;
			
		}
	}
	
	if(e.controlKey && e.altKey){
		
		switch (e.keyCode){
			
			case Keyboard.K:
				TreeView.DeleteFile();
				var event:Event;
				TreeView.CallFileList(event);
				DataViews.ClearAllContents();
				break;
			
			case Keyboard.Q:
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
				
				
				
			default:
				break;
			
		}
	}
	
	
	if(e.altKey && e.shiftKey){
		
		switch (e.keyCode){
			
			case Keyboard.N: // Loading NMEA File Import
				popup =PopUpManager.createPopUp(this,fe.core.gps.ImportNMEA,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseGPSImport);
				PopUpManager.centerPopUp(popup);
				break;
			
			case Keyboard.M: // Put the marker on the center of the map.
				if(TreeView.CodeTree.selectedItem != null){
					if(TreeView.FileView.selectedItem != null){
						SpatialViews.CURRENT_FILE_ID = TreeView.FileView.selectedItem.file_id;
						SpatialViews.SetSinglePOIonMapCenter();	
					}
				}
				
				break;
			
			case Keyboard.G:
				
				popup =PopUpManager.createPopUp(this,fe.core.gps.ImportGPX,true);
				popup.addEventListener(CloseEvent.CLOSE,CloseGPSImport);
				PopUpManager.centerPopUp(popup);
				
				break;
			
			default:
				
				break;
			
		}
		
	}
	
}
