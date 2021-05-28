;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ AdobeAir-Updater-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
#include<FontConstants.au3>     ;~ For style           ~
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
Global $SourceCode, $trim, $str, $u, $BytesReceived, $Pct, $Inet, $InetSize
;[Part2 ]End****

;[Part 3]Begin****
;Searching for skype updates
$SourceCode = _InetGetSource("http://www.clubic.com/telecharger-fiche45240-adobe-air.html")
If NOT @ERROR then
$trim = StringTrimLeft($SourceCode, StringInStr($SourceCode, "softwareVersion"))

$str = StringRegExp($trim, "([0123456789]{1,3}).([0123456789]{1,3})", $STR_REGEXPARRAYMATCH)

If NOT @ERROR Then
   $UrlVersionSplit = $str[0] & "." & $str[1]
   $UrlVersion = $str[0] & $str[1]
EndIf
EndIF
;[Part 3]End****

;[Part 4]Begin****
If FileExists(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini") = False Then
$Inet = InetGet("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe", @TEMPDIR & "\AdobeAirk.exe", "", 1)
$InetSize = InetGetSize("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe")
ProgressOn("Download", "Downloading AdobeAir...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\AdobeAirk.exe -silent -eulaAccepted")
SplashTextOn("not important", "Downloaded :AdobeAir" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\AdobeAirk.exe")
_FileCreate(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
Else
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini", 0)
   $ReadVersion = FileRead($op)
   $strsp = StringSplit($ReadVersion, ".")
   $u = Ubound($strsp)
   If $u >= 2 Then
	  $CurrentVersion = $strsp[1] & $strsp[2]
   EndIf
   If $CurrentVersion < $UrlVersion then
$Inet = InetGet("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe", @TEMPDIR & "\AdobeAirk.exe", "", 1)
$InetSize = InetGetSize("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe")
ProgressOn("Update", "Updating AdobeAir...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\AdobeAirk.exe -silent -eulaAccepted")
SplashTextOn("not important", "Updated :AdobeAir" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\AdobeAirk.exe")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
Else
   If $CurrentVersion >= $UrlVersion then
	  $msg = MsgBox(36, "No updates", "No updates avalaible" & @CRLF & "Would you like to reinstall AdobeAir anyway ?")
	  If $msg = 7 Then
		 _Rc()
	  Else
$Inet = InetGet("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe", @TEMPDIR & "\AdobeAirk.exe", "", 1)
$InetSize = InetGetSize("http://lb.cdn.m6web.fr/d/c/a/d89104fb9975205da8eba780d8e79d20/563238c9/soft/logiciel/adobe-air_" & $str[0] & "-" & $str[1] & "-0-213_fr_45240.exe")
ProgressOn("Update", "Updating AdobeAir...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\AdobeAirk.exe -silent -eulaAccepted")
SplashTextOn("not important", "Updated :AdobeAir" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\AdobeAirk.exe")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\AdobeAirVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
EndIf
EndIf
EndIf
EndIF

Func _Rc()
   Sleep(200)
EndFunc