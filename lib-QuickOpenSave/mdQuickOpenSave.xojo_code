#tag Module
Protected Module mdQuickOpenSave
	#tag Method, Flags = &h0
		Function ShowOpenFileDialog(extends f as FolderItem, filter as string, filename as string, config as clQuickOpenSaveConfig) As FolderItem
		  //
		  // Extends ShowOPenFIleDialog() from library
		  //
		  //
		  
		  if config = nil then
		    return f.ShowOpenFileDialog(filter)
		    
		  end if
		  
		  if config.HasHistory then
		    var fld as FolderItem = config.GetFromHistory(filename)
		    
		    if fld <> nil and fld.exists then return fld
		    
		    fld = f.ShowOpenFileDialog(filter)
		    
		    if fld <> nil then config.SaveToHistory(filename, fld)
		    
		    return fld
		    
		  end if
		  
		  
		  if config.TestMode then
		    return config.CalculateInputPathFromDesktop.Child(filename)
		    
		  else
		    return f.ShowOpenFileDialog(filter)
		    
		  end if
		  
		  
		End Function
	#tag EndMethod


End Module
#tag EndModule
