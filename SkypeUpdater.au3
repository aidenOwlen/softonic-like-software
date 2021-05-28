;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Skype-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
Global $SourceCode, $dilimiter, $xd, $u, $string, $UrlVersionSplit, $UrlVersion, $Inet, $InetSize, $BytesReceived, $Pct, $op, $readop, $u2, $stringop, $CurrenVersion
;[Part2 ]End****

;[Part 3]Begin****
;Searching for skype updates
$dilimiter = "."
$SourceCode = _InetGetSource("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd")
If @ERROR Then
   _Rc()
Else
$xd = StringTrimLeft($SourceCode, StringInStr($Sourcecode, "<title>"))
$string = StringRegExp($xd, "([0123456789]{1}).([0123456789]{1,5}).([0123456789]{1,5}).([0123456789]{1,5})", $STR_REGEXPARRAYMATCH)
$u = Ubound($string)
If $u >= 4 then
$UrlVersionSplit = $string[0] & "." & $string[1] & "." & $string[2] & "." & $string[3]
$UrlVersion = $string[0] & $string[1]  & $string[2]  & $string[3]
Else
   _Rc()
EndIf
EndIf
;[Part 3]End****


;[Part 4]Begin****
If FileExists(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini") = False then
   If ProcessExists("skype.exe") then processclose("skype.exe")
$Inet = InetGet("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe", @TEMPDIR & "\SkypeSetupFull.exe", "", 1)
If @ERROR then
 $Inet  = InetGet("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%207.13.32.101%20silent.exe", @TEMPDIR & "\SkypeSetupFull.Exe", "", 1)
EndIF
$InetSize = InetGetSize("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe")
ProgressOn("Download", "Downloading skype...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()


SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\SkypeSetupFull.exe", "", @SW_HIDE)
SplashTextOn("not important", "Downloaded :Skype" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\SkypeSetupFull.exe")
_FileCreate(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
Else
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini", 0)
   $readop = FileRead($op)
   $stringop = StringSplit($readop, ".")
   $u2 = Ubound($stringop)
   If $u2 >= 4 then
   $CurrentVersion = $stringop[1] & $stringop[2] & $stringop[3] & $stringop[4]
   EndIf
   If $CurrentVersion >= $UrlVersion then
	  $msg = MsgBox(36, "No update", "No updates avalaible for skype" & @CRLF & "Would you like to re install it ?")
	  If $msg = 7 Then
		 _Rc()
	  Else
If ProcessExists("skype.exe") then processclose("skype.exe")
$Inet = InetGet("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe", @TEMPDIR & "\SkypeSetupFull.exe", "", 1)
If @ERROR then
 $Inet  = InetGet("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%207.13.32.101%20silent.exe", @TEMPDIR & "\SkypeSetupFull.Exe", "", 1)
EndIF
$InetSize = InetGetSize("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe")
ProgressOn("Update", "Updating skype...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\SkypeSetupFull.exe", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Skype" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\SkypeSetupFull.exe")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
EndIF

   Else
   If $CurrentVersion < $UrlVersion then
If ProcessExists("skype.exe") Then processclose("skype.exe")
$Inet = InetGet("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe", @TEMPDIR & "\SkypeSetupFull.exe", "", 1)
$InetSize = InetGetSize("https://gallery.technet.microsoft.com/Skype-63-Silent-Installer-74a99dcd/file/142608/4/Skype%20" & $UrlVersionSplit & "%20silent.exe")
ProgressOn("Update", "Updating skype...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\SkypeSetupFull.exe", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Skype" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\SkypeSetupFull.exe")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\SkypeVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
EndIf
EndIf
EndIF



Func _Rc()
   sleep(200)
EndFunc
