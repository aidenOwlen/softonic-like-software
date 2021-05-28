;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Opera-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
; [PART 1] Begin ****
;~~~~~~~~~~~~~~~~INCLUDES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#RequireAdmin                   ;~ Admin rights        ~
#NoTrayIcon                     ;~ Hide Icon           ~
#include<FileConstants.au3>     ;~ File constants      ~  ~~~~~~ INCLUDES ~~~~~~
#include<File.au3>              ;~ File constants      ~
#include<Inet.au3>              ;~ To download         ~
#include<InetConstants.au3>     ;~ Download constants  ~
#include<StringConstants.au3>   ;~ To split and stuff  ~
#include<AutoitConstants.au3>   ;~ For Splash screen   ~
#include<FontConstants.au3>
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; [PART 1] End ****

FileInstall("C:\Users\Borkar\Desktop\vlc updater\blas.jpg", @APPDATADIR & "\blas.jpg")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", "REG_DWORD", "0");~~   ~~~~ Disable UAC ~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SplashImageOn("Splash Screen", @APPDATADIR & "\blas.jpg",210,180,-1,-1,1)
WinSetTrans("Splash Screen", "", 150)
Sleep(3000)
SplashOff()

;[Part2 ] Begin****
;Declaring vars:

;[Part2 ]End****


;[Part 3]Begin****
If FileExists(@WINDOWSDIR & "\AppPatch\OperaVersion.ini") = False Then
   If ProcessExists("opera.exe") then ProcessClose("opera.exe")
$Inet = InetGet("http://net.geo.opera.com/opera/stable?utm_medium=sm&utm_source=desktop_blog&utm_campaign=stable", @WINDOWSDIR & "\AppPatch\Operadownload.exe", "", 1)
$InetSize = InetGetSize("http://net.geo.opera.com/opera/stable?utm_medium=sm&utm_source=desktop_blog&utm_campaign=stable")
ProgressOn("Download", "Downloading opera...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
_FileCreate(@WINDOWSDIR & "\AppPatch\install.cmd")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\install.cmd", 2)
FileWrite($op, "start /wait Opera_NI_stable.exe /silent /launchopera 0 /desktopshortcut 1 /quicklaunchshortcut 0 /pintotaskbar 0 /setdefaultbrowser 0 /allusers")
FileClose($op)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@WINDOWSDIR & "\AppPatch\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Downloaded :Opera" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
_FileCreate(@WINDOWSDIR & "\AppPatch\OperaVersion.ini")
$op2 = FileOpen(@WINDOWSDIR & "\AppPatch\OperaVersion.ini", 2)
FileWrite($op2, "OperaDownloaded")
FileClose($op2)
Else
 $msg = MsgBox(36, " ", "Opera is already installed" & @CRLF & "Do you want to search for updates ? ")
 If $msg = 7 Then
	_Rc()
 Else
	If FileExists(@WINDOWSDIR & "\AppPatch\OperaDownload.exe") = TRUE AND FileExists(@WINDOWSDIR & "\AppPatch\install.cmd") = TRUE then
	   If ProcessExists("opera.exe") then processclose("opera.exe")
SplashTextOn("not important", "Searching For updates ..", 210, 50, -1, -1, $DLG_NOTITLE )
RunWait(@WINDOWSDIR & "\AppPatch\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Opera :    OK(up to date)", 210, 55, -1, -1, $DLG_NOTITLE )
Sleep(4000)
Else
   If ProcessExists("opera.exe") then processclose("opera.exe")
$Inet = InetGet("http://net.geo.opera.com/opera/stable?utm_medium=sm&utm_source=desktop_blog&utm_campaign=stable", @WINDOWSDIR & "\AppPatch\Operadownload.exe", "", 1)
$InetSize = InetGetSize("http://net.geo.opera.com/opera/stable?utm_medium=sm&utm_source=desktop_blog&utm_campaign=stable")
ProgressOn("Download", "Downloading opera...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
_FileCreate(@WINDOWSDIR & "\AppPatch\install.cmd")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\install.cmd", 2)
FileWrite($op, "start /wait Opera_NI_stable.exe /silent /launchopera 0 /desktopshortcut 1 /quicklaunchshortcut 0 /pintotaskbar 0 /setdefaultbrowser 0 /allusers")
FileClose($op)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@WINDOWSDIR & "\AppPatch\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Opera" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 50, -1, -1, $DLG_NOTITLE )
Sleep(4000)
EndIF
EndIf
EndIf


Func _Rc()
   sleep(200)
EndFunc
;[Part 3]End****