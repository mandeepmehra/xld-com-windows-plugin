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


Dim appName
Dim dllName
 
appName = GetCommandLineArgument("-app")
dllName = GetCommandLineArgument("-dll")
	
createOrUpdateDLLComponent appName, dllName



