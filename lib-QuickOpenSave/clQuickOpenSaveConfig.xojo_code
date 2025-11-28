#tag Class
Class clQuickOpenSaveConfig
	#tag Method, Flags = &h0
		Function CalculateInputPathFromDesktop() As FolderItem
		  
		  return self.CalculatePathFromDesktop(mSourceFolder, mInputSubFolder)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CalculateOutputPathFromDesktop() As FolderItem
		  
		  return self.CalculatePathFromDesktop(mSourceFolder, mOutputSubFolder)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CalculatePathFromDesktop(MainFolder as string, SubFolder as string) As FolderItem
		  
		  var tmpFolder as FolderItem = SpecialFolder.Desktop
		  
		  var folderLevels() as String
		  
		  if MainFolder <> "" then folderLevels.Add(MainFolder)
		  if SubFolder <> "" then folderLevels.Add(SubFolder)
		  
		  for each level as string in folderLevels
		    if tmpFolder.Child(level).Exists and tmpFolder.Child(level).IsFolder then
		      tmpFolder = tmpFolder.Child(level)
		      
		    end if
		    
		  next
		  
		  return tmpFolder
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(NameInAppData as string, UseHistory as Boolean)
		  
		  // 
		  // Top folder in appdata will be NameInAppData or executable name (without extension) if missing
		  //
		  // The folder is created the first time an attempt is made to write there
		  //
		  
		  var tmpName as string = NameInAppData.Trim
		  
		  if tmpName.Length = 0 then
		    
		    var sn as string = app.ExecutableFile.Name
		    
		    var p as integer = sn.IndexOf(".")
		    
		    if p >= 1 then
		      sn = sn.Left(p)
		      
		    end if
		    
		  else
		    self.AppDataTopFolder = tmpName
		    
		  end if
		  
		  
		  
		  if UseHistory then
		    self.History = new Dictionary
		    LoadHistory
		    
		  else
		    self.History = nil
		    
		  end if
		  
		  self.mSourceFolder = ""
		  self.mInputSubFolder = ""
		  self.mOutputSubFolder = ""
		  
		  self.mTestMode = DebugBuild()
		  
		  return
		  
		  
		   
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateFolderPath(folderPath as FolderItem)
		  
		  while not folderPath.Exists
		    var f1 as FolderItem = folderPath
		    
		    while not f1.Parent.Exists
		      f1 = f1.Parent
		      
		    wend
		    
		    if not f1.Exists then f1.CreateFolder
		    
		  wend
		  
		  return
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FolderInAppData(CreateIfMissing as Boolean) As FolderItem
		  
		  // 
		  // Calculate the path to the folder used to load and save peristed files
		  //
		  
		  var fld as FolderItem = SpecialFolder.ApplicationData
		  
		  var fldchild as FolderItem = fld.Child(self.AppDataTopFolder)
		  
		  if fldchild.exists then return fldchild
		  
		  if CreateIfMissing then
		    fldchild.CreateFolder
		    return fldchild
		    
		  end if
		  
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFromHistory(filename as string) As FolderItem
		  //
		  // Returns the folderitem saved in history related to filename
		  //
		  
		  return FolderItem(self.History.Lookup(Filename, nil))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasHistory() As Boolean
		  return   self.History <> nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HistoryFolder(CreateIfMissing as Boolean) As FolderItem
		  
		  // 
		  // Calculate the path to the folder used to persist history
		  //
		  
		  return FolderInAppData(CreateIfMissing)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HistoryIsActive() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadHistory()
		  
		  
		  var fld as FolderItem = self.HistoryFolder(false)
		  
		  if fld = nil then return
		  
		  if not fld.Exists then return
		  
		  fld = fld.Child(self.HistoryFileName)
		  
		  if not fld.Exists then return
		  
		  var tin as TextInputStream = TextInputStream.Open(fld)
		  
		  self.History = new Dictionary
		  
		  while not tin.EndOfFile
		    var SourceTextRow as string = tin.ReadLine
		    
		    var SplittedTextRow() as string = SourceTextRow.Split(";")
		    
		    if SplittedTextRow.Count = 2 then
		      var k as string
		      var f as FolderItem
		      
		      try
		        k = SplittedTextRow(0)
		        f = New FolderItem(SplittedTextRow(1), FolderItem.PathModes.Native)
		        
		      catch
		        System.DebugLog("Unable to process [" + SourceTextRow + "] from " + self.HistoryFileName + ".")
		        k = ""
		        f = nil
		        
		      end try
		      
		      self.SaveToHistory(k, f)
		      
		    end if
		    
		  wend
		  
		  tin.Close
		  
		  return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OrganiseDesktop(MainFolder as string, NewInputSubFolder as string, NewOutputSubFolder as string)
		  
		  // 
		  // This function is used
		  // - to define an optional parent folder used for open and save in test mode
		  // - to define (optional) input and output subfolders
		  //
		  
		  self.mSourceFolder = MainFolder
		  self.mInputSubFolder = NewInputSubFolder
		  self.mOutputSubFolder = NewOutputSubFolder
		  
		  return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetHistory()
		  self.History = new Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveHistory()
		  
		  var fld as FolderItem = self.HistoryFolder(true)
		  
		  System.DebugLog("Folder used for history [" + fld.NativePath +"] " + if(fld.Exists, "Exists","Missing")+".")
		  
		  fld = fld.Child(self.HistoryFileName)
		  
		  var tout as TextOutputStream = TextOutputStream.Create(fld)
		  
		  for each k as string in self.History.Keys
		    var tmp as FolderItem = FolderItem(self.History.Value(k))
		    
		    tout.WriteLine(k+";"+ tmp.NativePath)
		    
		  next
		  
		  tout.close
		  
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveToHistory(filename as string, fld as FolderItem)
		  
		  if filename.Length = 0 then return 
		  
		  if fld = nil then return
		  
		  self.History.Value(filename) = fld
		  
		  Return
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private AppDataTopFolder As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private History As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		inputSource As InputSources
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInputSubFolder As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOutputSubFolder As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSourceFolder As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTestMode As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTestMode
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTestMode = value
			End Set
		#tag EndSetter
		TestMode As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = HistoryFileName, Type = String, Dynamic = False, Default = \"history.txt", Scope = Public
	#tag EndConstant


	#tag Enum, Name = InputSources, Type = Integer, Flags = &h0
		Desktop
		  DesktopFolder
		  DesktopInputFolder
		  History
		UserSelected
	#tag EndEnum


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
		#tag ViewProperty
			Name="inputSource"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="InputSources"
			EditorType="Enum"
			#tag EnumValues
				"0 - Desktop"
				"1 - DesktopFolder"
				"2 - DesktopInputFolder"
				"3 - History"
				"4 - UserSelected"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestMode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
