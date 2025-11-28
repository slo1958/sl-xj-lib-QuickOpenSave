#tag Module
Protected Module mdQuickOpenSave
	#tag Method, Flags = &h0
		Function FldShowOpenFileDialog(filter as string) As FolderItem
		  return FolderItem.ShowOpenFileDialog(filter)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FldShowOpenFileDialog(filter as string, filename as string, config as clQuickOpenSaveConfig) As FolderItem
		  //
		  // Replacement for ShowOpenFIleDialog() from library
		  //
		  //
		  
		  if config = nil then
		    return FolderItem.ShowOpenFileDialog(filter)
		    
		  end if
		  
		  if config.HasHistory then
		    var fld as FolderItem = config.GetFromHistory(filename)
		    
		    if fld <> nil and fld.exists then 
		      if config.InformUser then MessageBox("File [" +  filename + "] found in history as [" + fld.NativePath+"]")
		      return fld
		      
		    end if
		    
		    fld = FolderItem.ShowOpenFileDialog(filter)
		    
		    if fld <> nil then config.SaveToHistory(filename, fld)
		    
		    return fld
		    
		  end if
		  
		  
		  if config.TestMode then
		    var fld as FolderItem = config.CalculateInputPathFromDesktop()
		    if config.InformUser then MessageBox("File [" +  filename + "] expected in  [" + fld.NativePath+"]")
		    return fld.Child(filename)
		    
		  else
		    return FolderItem.ShowOpenFileDialog(filter)
		    
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FldShowSaveFileDialog(filter as string, filename as string, config as clQuickOpenSaveConfig) As FolderItem
		  //
		  //  Replacement for ShowSaveFIleDialog() from library
		  //
		  //
		  
		  if config = nil then
		    return FolderItem.ShowSaveFIleDialog(filter, filename)
		    
		  end if
		  
		  if config.HasHistory then
		    var fld as FolderItem = config.GetFromHistory(filename)
		    
		    if fld <> nil and fld.exists then 
		      if config.InformUser then MessageBox("File [" +  filename + "] found in history as [" + fld.NativePath+"]")
		      return fld
		      
		    end if
		    
		    fld = FolderItem.ShowSaveFIleDialog(filter, filename)
		    
		    if fld <> nil then config.SaveToHistory(filename, fld)
		    
		    return fld
		    
		  end if
		  
		  
		  if config.TestMode then
		    var fld as FolderItem = config.CalculateOutputPathFromDesktop()
		    if config.InformUser then MessageBox("File [" +  filename + "] expected in  [" + fld.NativePath+"]")
		    return fld.Child(filename)
		    
		  else
		    return FolderItem.ShowSaveFIleDialog(filter, filename)
		    
		  end if
		  
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
