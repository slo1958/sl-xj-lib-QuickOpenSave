# sl-xj-lib-QuickOpenSave
Handling input and output file paths when testing an application.

The library is made of a class and two methods, expected to replace the standard methods FolderItem.ShowOpenDialog() and FolderItem.ShowSaveDialog()

## About Xojo version
Tested with Xojo 2025 release 2.1 on Mac.

## Getting started
In the simplest form, the methods will redirect the paths to the desktop, without displaying the dialogs from the Xojo library. 


For example, to load a file selected by the user, the code would usually look like:

```xojo
	
	fld = folderItem.ShowOpenDialog(someTypes)

```

You replace all calls to folderItem.ShowOpenDialog()  with calls to fldShowOpenDialog(). The behaviour of your application does not change, since by default this method calls FolderItem.ShowOpenDialog()



```xojo
	
	fld = fldShowOpenDialog(someTypes)

```

Since it is a bit boring to use the dialog each time a test is made to go and pick the file using the dialog, you updated the code as follow:



```xojo

	// Somewhere at the beginning of the application:
	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	

	// and when you open the file
	my file = fldShowOpenDialog(someTypes, “MyAmazingTestFile.txt”, cfg)

```
 
Et voilà, the application now uses the file ‘MyAmazingTestFile.txt’ you already saved on your desktop.

Once the code is working as expected, you only need to reset cfg:

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:
	cfg = nil

	// cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	// cfg.TestMode = true
	

	// and when you open the file
	my file = fldShowOpenDialog(someTypes, “MyAmazingTestFile.txt”, cfg)

```
The method returns to the default behaviour, even if the file is still on the desktop.

The same applies for the ShowSaveDialog():

```xojo

	// Somewhere at the beginning of the application:
	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	

	// and when you save the file
	my file = fldShowSaveDialog(someTypes, “MyResults.txt”, cfg)

```

## Organising the files on the desktop

And what is you want to test your application with different input files ?


```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	cfg.OrganiseDesktop(“TestCase123”,””,””)

	// and when you open the file
	my file = fldShowOpenDialog(someTypes, “MyAmazingTestFile.txt”, cfg)

```

Now, we use the folder Desktop/TestCase123 instead of ‘Desktop’, if that path exists on the desktop.

Fine, but your amazing application uses more than one input file and produces a few output files, so the desktop is a big mess.

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	cfg.OrganiseDesktop(“”,”InputFiles”,”OutputFiles”)

	// and when you open the file
	my file = fldShowOpenDialog(someTypes, “MyAmazingTestFile.txt”, cfg)
```


Now, we use 

- the folder Desktop/InputFiles instead of ‘Desktop’ for the input files, if that path exists on the desktop,
- the folder Desktop/OutputFiles instead of ‘Desktop’ for the output files, if that path exists on the desktop.

And, of course, we can combine both options:

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	cfg.OrganiseDesktop(“TestCase123”,”InputFiles”,”OutputFiles”)

	// and when you open the file
	my file = fldShowOpenDialog(someTypes, “MyAmazingTestFile.txt”, cfg)

```

You can access the input folder or the output folder: 

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	cfg.TestMode = true
	cfg.OrganiseDesktop(“TestCase123”,”InputFiles”,”OutputFiles”)


	myInputFld = cfg.CalculateInputPathFromDesktop()

	MyOutputFld = cfg.CalculateOutputPathFromDesktop()
```

Those two methods are used to calculate the path as explained above.


## Using history

The history is a dictionary used to link the filename passed to fldShowXXXDialog and an actual path. The filename is a key in a dictionary and no longer the name of a file. The history can be saved and reloaded at the next execution.

The path used to stored the history is the folder name passed to the constructor under the appData folder.
That folder is created automatically the first time the history is saved.

History is used for ShowOpenDialog() and ShowSaveDialog(). It takes precedence on TestMode, the value of TestMode is ignored when history is active.

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	// The history is loaded, if available 
	cfg.UseHistory = true
	….

	// This will create the folder in AppData, if missing, and save the history
	cfg.SaveHistory()

```

Here, the history is saved under appData/TEST_QUICK_OPEN_SAVE/

If you want to access the folder in appData to load or save your own files:

```xojo

	// with cfg defined as clQuickOpenSaveConfig

	// Somewhere at the beginning of the application:

	cfg = new clQuickOpenSaveConfig("TEST_QUICK_OPEN_SAVE")

	// This one returns nil if the folder does not exist
	fldPath = cfg.FolderInAppData(false)

	// This one creates the folder if it does not exist
	fldPath = cfg.FolderInAppData(true)

```


## Using the library in your application

Copy and paste the folder lib-QuickOpenSave which contains

- the definition of the class clQuickOpenSaveConfig
- the methods fldShowOpenDialog() and fldShowSaveDialog()

Replace FolderItem.ShowOpenDialog() by fldShowOpenDialog() in your source code.

Replace FolderItem.ShowSaveDialog() by fldShowSaveDialog() in your source code.

Create an instance of clQuickOpenSaveConfig(), for example in the open event of your app.

Update the calls to fldShowOpenDialog() to include the configuration parameters, where it makes sense.

Update the calls to fldShowSaveDialog() to include the configuration parameters, where it makes sense.

