Function GetCommandLineFlag(name)

    GetCommandLineFlag = false

    Dim Args
    Set Args = WScript.Arguments

    Dim index
    While index < args.count

        If lcase(args(index)) = name Then

            GetCommandLineFlag = true

            index = args.count ' exit the loop

        End If

        index = index + 1

    Wend

End Function

Sub Usage(msg)

    Dim usageInfo
	
    If msg <> "" Then
	
        usageInfo = msg & vbCrLf & vbCrLf
	
    End If

    usageInfo = usageInfo & "Usage: " & WScript.ScriptName & vbCrLf
    usageInfo = usageInfo & "    -file <xmlfile>" & vbTab & vbTab & "Required - the output file name"& vbCrLf
    usageInfo = usageInfo & "    -app <""appName"">" & vbTab & "Required - the application to dump"& vbCrLf
    usageInfo = usageInfo & "    -users" & vbTab & vbTab & vbTab & "Optional - dump users in roles"& vbCrLf
    usageInfo = usageInfo & "    -append" & vbTab & vbTab & "Optional - append the app to the xml file"& vbCrLf
    usageInfo = usageInfo & "    -replace" & vbTab & vbTab & "Optional - (implies -append) if the app is already present in the file it is replaced"& vbCrLf
    usageInfo = usageInfo & vbCrLf & WScript.ScriptName & " - Dumps out a COM+ application's configuration details in XML."

    Message usageInfo
    WScript.Quit 1

End Sub


private Function GetCommandLineArgument(name)

    Dim Args
    Set Args = WScript.Arguments

    Dim index
    While index < args.count

        If lcase(args(index)) = name Then

            On Error Resume Next
            index = index + 1
            GetCommandLineArgument = args(index)
            On Error Goto 0

            If GetCommandLineArgument = "" Then

                Usage "Error: Expected a value for argument: " & name

            End If

            index = args.count ' exit the loop

        End If

        index = index + 1

    Wend

End Function


Private Function GetOptionalCatalogObjectByName(col, name) 
    Set GetOptionalCatalogObjectByName = Nothing
    Dim obj 
    For Each obj In col
        If obj.name = name Then
            Set GetOptionalCatalogObjectByName = obj
            Exit For
        End If
    Next 
End Function

Sub Message(msg)
    Dim header
    header = WScript.ScriptName & vbCrLf & "Version: " & c_ScriptVersion & vbCrLf
    Wscript.echo  header & vbCrLf & msg
End Sub

sub createOrUpdateDLLComponent(appName, dllNameWithPath)
	Dim cat 
	Dim col 
	Dim app
	
	Set cat = CreateObject("COMAdmin.COMAdminCatalog")
	Set col = cat.GetCollection("Applications")
	col.Populate
	Set app = GetOptionalCatalogObjectByName(col, appName)

	appId = app.value("ID")

	cat.InstallComponent appID, dllNameWithPath , "", ""

	on error resume next
	If  err.number > 0 Then
		Message err.Number & " : " & err.Description
		Message "Failed to add DLL component"
		WScript.Quit(101)
	End if

	col.SaveChanges
	Message "DLL component added successfully"
end sub

sub removeComponent(appName, componentName)
	Dim cat 
	Dim col 
	Dim app
	
	Set cat = CreateObject("COMAdmin.COMAdminCatalog")
	Set col = cat.GetCollection("Applications")
	col.Populate
	Set app = GetOptionalCatalogObjectByName(col, appName)

	appId = app.value("ID")
	
	Set compCollection = col.GetCollection("Components",app.key)
	compCollection.Populate
	
	Dim index
	index=0
	For Each obj In compCollection
        If obj.name = componentName Then
            compCollection.remove index
			on error resume next
			If  err.number > 0 Then
				Message err.Number & " : " & err.Description
				Message "Failed to remove component"
				WScript.Quit(102)
			End if
			compCollection.saveChanges()
			col.saveChanges()
			Message obj.name & "Component removed successfully"
			exit for
        End If
		index = index + 1
    Next 
	
end sub

Dim appName
Dim dllName
Dim removeFlag
appName = GetCommandLineArgument("-app")
comName = GetCommandLineArgument("-com")
dllName = GetCommandLineArgument("-dll")
removeFlag = GetCommandLineFlag("-remove")

if removeFlag = True then
	removeComponent appName, comName
else
	createOrUpdateDLLComponent appName, dllName
end if



