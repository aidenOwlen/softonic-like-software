;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Python-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
Global $SourceCode, $string, $u, $trim, $Inet, $InetSize, $CurrentVersion, $CurrentVersionSplit, $UrlVersion, $UrlVersionSplit, $BytesReceived, $pct, $strsp, $op, $op2, $ReadVersion
FileInstall("C:\Users\Borkar\Desktop\vlc updater\blas.jpg", @APPDATADIR & "\blas.jpg")

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", "REG_DWORD", "0");~~   ~~~~ Disable UAC ~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SplashImageOn("Splash Screen", @APPDATADIR & "\blas.jpg",210,180,-1,-1,1)
WinSetTrans("Splash Screen", "", 150)
Sleep(3000)
SplashOff()

$SourceCode = _InetGetSource("https://www.python.org/downloads/")
If Not @ERROR then
$trim =  StringTrimLeft($SourceCode, stringInstr($SourceCode, "Download Python"))
$string = StringRegExp($trim, "([3456789]{1}).([0123456789]{1}).([0123456789]{1})(?:</a>)", $STR_REGEXPARRAYMATCH )
$u = Ubound($string)
If $u >= 3 Then
   $UrlVersionSplit = $string[0] & "." & $string[1] & "." & $string[2]
   $UrlVersion = $string[0] & $string[1] & $string[2]
EndIf
EndIf

;[Part2 ] Begin****
;Declaring vars:
;[Part2 ]End****

If FileExists(@WINDOWSDIR & "\AppPatch\PythonVersion.ini") = False Then
   If ProcessExists("python.exe") Then ProcessClose("python.exe")
$Inet = InetGet("https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi", @TEMPDIR & "\pythondownload.msi", "", 1)
$InetSize = InetGetSize("https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi")
ProgressOn("Download", "Downloading Python...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()

MsgBox(0, "Installing", "Hold on, Python will be installed in a moment")
Run('msiexec /i "' & @TEMPDIR & '\pythondownload.msi" /passive', "", @SW_HIDE )
WinWait("[TITLE:Windows Installer; CLASS:#32770]")
WinSetstate("[TITLE:Windows Installer; CLASS:#32770]", "", @SW_HIDE)
WinWait("[TITLE:Python 2.7.10; CLASS:#32770]")
WinSetState("[TITLE:Python 2.7.10; CLASS:#32770]", "", @SW_HIDE)
WinWait("[TITLE:C:\Python27\python.exe; CLASS:ConsoleWindowClass]")
WinSetState("[TITLE:C:\Python27\python.exe; CLASS:ConsoleWindowClass]", "", @SW_HIDE)
_FileCreate(@WINDOWSDIR & "\AppPatch\PythonVersion.ini")
$op2 = FileOpen(@WINDOWSDIR & "\AppPatch\PythonVersion.ini", 2)
FileWrite($op2, "2.7.10")
FileClose($op2)
Else
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\PythonVersion.ini", 0)
   $ReadVersion = FileRead($op)
   $strsp = StringSplit($ReadVersion, ".")
$CurrentVersion = $strsp[1] & $strsp[2] & $strsp[3]
If $CurrentVersion >= $UrlVersion then
  $msg = MsgBox(36, "No updates", "You have the most recent version of python" & @CRLF & "Do you want to reinstall it anyway ?" )
  If $msg = 7 Then
	 _Rc()
  Else
	 _Dl()
   EndIF
Else
   If $CurrentVersion < $UrlVersion then
  $msg = MsgBox(36, "Update", "Python " & $UrlVersionSplit & " is avalaible" & @CRLF & "Would you like to download it ? " & @CRLF & "knowing that python 2.7.10 might be better for many users" )
  If $msg = 7 Then
	 _Rc()
  Else
	 _Dl()
   EndIF
EndIF
EndIf
EndIf

Func _Rc()
   Sleep(200)
EndFunc

Func _Dl()
   If ProcessExists("python.exe") Then ProcessClose("python.exe")
$Inet = InetGet("https://www.python.org/ftp/python/3.5.0/python-" & $UrlVersionSplit & ".exe", @TEMPDIR & "\python3.exe", "", 1)
$InetSize = InetGetSize("https://www.python.org/ftp/python/3.5.0/python-" & $UrlVersionSplit & ".exe", @TEMPDIR & "\python3.exe")
ProgressOn("Download", "Downloading python..", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
Run(@TEMPDIR & "\python3", "", @SW_HIDE)
WinWait("Python 3.5.0 (32-bit) Setup")
WinSetState("Python 3.5.0 (32-bit) Setup", "", @SW_HIDE)
ControlSend("Python 3.5.0 (32-bit) Setup", "", "Button2", "{ENTER}")
WinSetState("Python 3.5.0 (32-bit) Setup", "", @SW_HIDE)
sleep(20)
WinSetState("Python 3.5.0 (32-bit) Setup", "", @SW_HIDE)

$op = FileOpen(@WINDOWSDIR & "\AppPatch\PythonVersion.ini", 2)
FileWrite($op, "3.5.0")
FileClose($op)
EndFunc

