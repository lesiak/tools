'"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'Copyright © 2010 Ramesh Srinivasan. All rights reserved.
'Filename	 : WPTargetDir.vbs
'Description : Opens the target folder of current Desktop Background in Windows 7
'Author   	 : Ramesh Srinivasan, Microsoft MVP (Windows)
'Homepage 	 : http://www.winhelponline.com/blog
'Created 	 : Feb 02, 2010
'"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Set WshShell = WScript.CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

function getWin8WallpaperPath(regKey) 
  arr = WshShell.RegRead(regKey)
  a=arr
  fullPath = ""
  consequtiveZeroes = 0

  For I = 24 To Ubound(arr)
    if consequtiveZeroes > 1 then
      exit for
    end if

    a(I) = Cint(arr(I))

    if a(I) > 1 then
      fullPath = fullPath & Chr(a(I))
      consequtiveZeroes = 0
    else
      consequtiveZeroes = consequtiveZeroes + 1
    end if
  Next
  getWin8WallpaperPath = fullPath 
end function




strMsg = "Completed!" & Chr(10) & Chr(10) & "WPTargetDir.vbs - © 2010 Ramesh Srinivasan" & Chr(10) & Chr(10) & "Visit us at http://www.winhelponline.com/blog"
strCurWP =""

On Error Resume Next
'strCurWP = WshShell.RegRead("HKCU\Software\Microsoft\Internet Explorer\Desktop\General\WallpaperSource")
strCurWP = getWin8WallpaperPath("HKCU\Control Panel\Desktop\TranscodedImageCache_000")
'MsgBox ("File Save Error" + ": " + strCurWP)
openWallpaper("HKCU\Control Panel\Desktop\TranscodedImageCache_000")

On Error Goto 0

If Trim(strCurWP) = "" Then
	MsgBox "No Wallpaper selected for Desktop Slideshow"
Else
	If fso.FileExists(strCurWP) Then
		WshShell.run "explorer.exe" & " /select," & strCurWP
	Else
		MsgBox "Cannot find target for " & strCurWP
	End If
End If

'""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	'This script was brought to you by "The Winhelponline Blog"
	'Visit us at http://www.winhelponline.com/blog

'""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
