;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Winzip-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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


;[Part2 ]End****
SplashImageOn("Splash Screen", @APPDATADIR & "\blas.jpg",210,180,-1,-1,1)
WinSetTrans("Splash Screen", "", 150)
Sleep(3000)
SplashOff()
Global $bit, $bitVersion, $SourceCode, $trim, $str, $u, $UrlVersion, $UrlVersionSplit, $UrlToDownload, $Inet, $InetSize, $BytesReceived, $Pct, $op, $ReadOp, $strsp, $u, $CurrentVersion
$SourceCode = _InetGetSource("http://www.winzip.com/win/en/dprob.htm")
If NOT @ERROR Then
$trim = StringTrimLeft($SourceCode, StringInStr($SourceCode, "bgcolor=""#f8f9f9"">WinZip"))
$str = StringRegExp($trim, "([0123456789]{2}).([0123456789]{1})", $STR_REGEXPARRAYMATCH)
$u = Ubound($str)
If $u >= 2 Then
Global $UrlVersionSplit = $str[0] & "." & $str[1]
Global $UrlVersion = $str[0] & $str[1]
EndIf
Else
  _Rc()
EndIf

$bit = StringRegExp(@ProcessorArch, "[0123456789]{2}", $STR_REGEXPARRAYMATCH)
If Not @ERROR then
Global $bitVersion = $bit[0]
EndIf

If $BitVersion = 64 then
Global $UrlToDownload = "http://download.winzip.com/winzip" & $UrlVersion & "-64.msi"
Else
Global $UrlToDownload = "http://download.winzip.com/winzip" & $UrlVersion & "-32.msi"
EndIf
If FileExists(@WINDOWSDIR & "\AppPatch\WinZipVersion.ini") = False then
If ProcessExists("WINZIP32.exe") Then ProcessClose("WINZIP32.exe")
If ProcessExists("WINZIP64.exe") Then ProcessClose("WINZIP64.exe")
If ProcessExists("WINZIP.exe") Then ProcessClose("WINZIP.exe")
If ProcessExists("WINZIP32.exe") Then ProcessClose("WINZIP32.exe")
If ProcessExists("WINZIP64.exe") Then ProcessClose("WINZIP64.exe")
If ProcessExists("WINZIP.exe") Then ProcessClose("WINZIP.exe")
$Inet = InetGet($UrlToDownload, @TEMPDIR & "\WinZipDownload.msi", "", 1)
$InetSize = InetGetSize($UrlToDownload)
ProgressOn("Download", "Downloading WinZip...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
_FileCreate(@TEMPDIR & "\install.cmd")
$opK = FileOpen(@TEMPDIR & "\install.cmd", 2)
FileWrite($opK, "msiexec /i WinZipDownload.msi /qn")
FileClose($opK)

SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Downloaded :Winzip" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
_FileCreate(@WINDOWSDIR & "\AppPatch\WinZipVersion.ini")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\WinZipVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
Else
$op = FileOpen(@WINDOWSDIR & "\AppPatch\WinZipVersion.ini", 0)
$ReadOp = FileRead($op)
$strsp = StringSplit($ReadOp, ".")
$u = Ubound($strsp)
If $u >= 2 then
$CurrentVersion = $strsp[1] & $strsp[2]
EndIf
If $CurrentVersion >= $UrlVersion then
   $msg = MsgBox(36, "No updates", "No updates avalaible for WinZip" & @CRLF & "Do you want to reinstall it ?")
   If $msg = 6 Then
   _Dl()
Else
   _Rc()
EndIF
Else
   If $CurrentVersion < $UrlVersion then
$Inet = InetGet($UrlToDownload, @TEMPDIR & "\WinZipDownload.msi", "", 1)
$InetSize = InetGetSize($UrlToDownload)
ProgressOn("Download", "Downloading WinZip...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)                        ;Inet, $InetSize, $BytesReceived, $Pct, $op, $ReadOp, $strsp, $u, $CurrentVersion
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
_FileCreate(@TEMPDIR & "\install.cmd")
$opC = FileOpen(@TEMPDIR & "\install.cmd", 2)
FileWrite($opC, "msiexec /i WinZipDownload.msi /qn")
FileClose($opC)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Winzip" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
FileDelete(@TEMPDIR & "\WinZipDownload.msi")
FileDelete(@TEMPDIR & "\install.cmd")
$op = FileOpen(@WINDOWSDIR & "\AppPatch\WinZipVersion.ini", 2)
FileWrite($op, $UrlVersionSplit)
FileClose($op)
EndIF

EndIf
EndIF
Func _Dl()
$Inet = InetGet($UrlToDownload, @WINDOWSDIR & "\WinZipDownload.msi", "", 1)
$InetSize = InetGetSize($UrlToDownload)
ProgressOn("Download", "Downloading WinZip...", "0%")
  While Not InetGetInfo($Inet, 2)
sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
_FileCreate(@WINDOWSDIR & "\install.cmd")
$opCK = FileOpen(@WINDOWSDIR & "\install.cmd", 2)
FileWrite($opCK, "msiexec /i WinZipDownload.msi /qn")
FileClose($opCK)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@WINDOWSDIR & "\install.cmd", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Winzip" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
EndFunc

Func _Rc()
   Sleep(200)
EndFunc