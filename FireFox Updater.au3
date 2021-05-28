;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Firefox-Downloader-Updater ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
#include<FontConstants.au3>     ;~ For edit styles     ~
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

; [Part 2] Begin****
;Declaring vars :
Global $op, $InetSize, $BytesReceived, $Pct, $Inet
Global $UrlVersion, $UrlVersionSplit, $SourceCode, $trim, $u, $string
; [Part 2] End****
$SourceCode = _InetGetSource("https://www.mozilla.org/fr/firefox/new/")
If NOT @ERROR THEN
$trim = StringTrimLeft($SourceCode, StringInstr($SourceCode, "data-latest-firefox"))
$string = StringRegExp($trim, "([0123456789]{1,3}).([0123456789]{1,2}).([0123456789]{1,2})", $STR_REGEXPARRAYMATCH)
$u = Ubound($string)
If $u >= 3 Then
   $UrlVersionSplit = $string[0] & "." & $string[1] & "." & $string[2]
   $UrlVersion = $string[0] & $string[1] & $string[2]
Else
   _Rc()
EndIf
EndIF


;[Part 3]Begin***
If FileExists(@WINDOWSDIR & "\AppPatch\FirefoxVersion.ini") = False then
_FileCreate(@TempDir & "\FirefoxC\override.ini")
$op = FileOpen(@TempDir & "\FirefoxC\override.ini", 2)
FileWrite($op, "[XRE]" & @CRLF & "EnableProfileMigrator=false")
FileClose($op)
_FileCreate(@TEMPDIR & "\FirefoxC\mozilla.cfg")
$op2 = FileOpen(@TEMPDIR & "\FirefoxC\mozilla.cfg", 2)

$mozillacfg = "//Firefox Default Settings" & _
@CRLF & "// set Firefox Default homepage" & _
@CRLF & "pref(""browser.startup.homepage"",""http://www.itsupportguides.com"");" & _
@CRLF & "// disable default browser check" & _
@CRLF & "pref(""browser.shell.checkDefaultBrowser"", false);" & _
@CRLF & "pref(""browser.startup.homepage_override.mstone"", ""ignore"");" & _
@CRLF & "// disable application updates" & _
@CRLF & "pref(""app.update.enabled"", false)" & _
@CRLF & "// disables the 'know your rights' button from displaying on first run" & _
@CRLF & "pref(""browser.rights.3.shown"", true);" & _
@CRLF & "// disables the request to send performance data from displaying" & _
@CRLF & "pref(""toolkit.telemetry.prompted"", 2);" & _
@CRLF & "pref(""toolkit.telemetry.rejected"", true);"
FileWrite($op2, $mozillacfg)
FileClose($op2)
$mozillals = "pref(""general.config.obscure_value"", 0);" & @CRLF & "pref(""general.config.filename"", ""mozilla.cfg"");"
_FileCreate(@TEMPDIR & "\FirefoxC\Local-settings.js")
$opjs = FileOpen(@TEMPDIR & "\FirefoxC\Local-settings.js", 2)
FileWrite($opjs, $mozillals)
FileClose($opjs)
_FileCreate(@TEMPDIR & "\FirefoxC\install.cmd")
$mozillacmd = "REM ."                                                                                                                           & _
@CRLF & "REM Script Details:"                                                                                                                   & _
@CRLF & "REM --------------"                                                                                                                    & _
@CRLF & "REM  This script will:"                                                                                                                & _
@CRLF & "REM       + silently install or upgrade Firefox WITHOUT Firefox being the default browser"                                             & _
@CRLF & "REM       + Disables the 'Automatically check for updates' option"                                                                     & _
@CRLF & "REM       + Disables the 'Always check to see if Firefox is the default browser on startup' option"                                    & _
@CRLF & "REM       + Deletes desktop icon"                                                                                                      & _
@CRLF & "REM       + Disables the Import Wizard"                                                                                                & _
@CRLF & "REM       + Works for Windows XP / 7 /8 32-bit and 64-bit"                                                                             & _
@CRLF & "REM ."                                                                                                                                 & _
@CRLF & "REM==========================================="                                                                                        & _
@CRLF & "echo Installing Firefox - Please Wait."                                                                                                & _
@CRLF & "echo Window will close after install is complete"                                                                                      & _
@CRLF & "REM Installing Firefox"                                                                                                                & _
@CRLF & """%~dp0Firefox Setup 41.0.2.exe"" -ms"                                                                                                 & _
@CRLF & "REM Install 32-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%programfiles%\Mozilla Firefox\browser\"""                & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%programfiles%\Mozilla Firefox\"""                         & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%programfiles%\Mozilla Firefox\defaults\pref"""      & _
@CRLF & "REM Install 64-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%ProgramFiles(x86)%\Mozilla Firefox\browser\"""      & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%ProgramFiles(x86)%\Mozilla Firefox\"""               & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref""" & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows XP"                                                                                         & _
@CRLF & "if exist ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" del ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" /S"                   & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows 7 / 8"                                                                                      & _
@CRLF & "if exist ""%public%\Desktop\Mozilla Firefox.lnk"" del ""%public%\Desktop\Mozilla Firefox.lnk"""
$opcmd = FileOpen(@TEMPDIR & "\FirefoxC\install.cmd", 2)
FileWrite($opcmd, $mozillacmd)
FileClose($opcmd)
$Inet = InetGet("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe", @TEMPDIR & "\FirefoxC\Firefox Setup 41.0.2.exe", "", 1)
$InetSize = InetGetSize("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe")
  ProgressOn("Download", "Downloading firefox...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
If ProcessExists("firefox.exe") then processClose("firefox.exe")
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )                                                       ;We sleep a little bit
   RunWait(@TEMPDIR & "\FireFoxC\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
SplashTextOn("not important", "Downloaded :Firefox" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
   sleep(3000)                                                                                                 ;We sleep 3min, waiting for the installation prrocess	                                                               ;We delete install.Cmd
   _FileCreate(@WINDOWSDIR & "\AppPatch\FirefoxVersion.ini")
   $op3 = FileOpen(@WINDOWSDIR & "\Apppatch\FirefoxVersion.ini", 2)
   FileWrite($op3, $UrlVersionSplit)
   FileClose($op3)
Else
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\FirefoxVersion.ini", 0)
   $ReadVersion = FileRead($op)
   $strsp = StringSplit($ReadVersion, ".")
   $u = Ubound($strsp)
   If $u >= 3 Then
	  $CurrentVersion = $strsp[1] & $strsp[2] & $strsp[3]
   EndIf
   If $CurrentVersion >= $UrlVersion Then
	  $msg = MsgBox(36, "No updates", "No updates avalaible for firefox" & @CRLF & "Would you like to re install it anyway ?")
	  If $msg = 7 Then
		 _Rc()
	  Else
		 If FileExists(@TEMPDIR & "\FirefoxC\install.cmd") Then
			If ProcessExists("firefox.exe") then processClose("firefox.exe")
			SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
			 RunWait(@TEMPDIR & "\FireFoxC\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
            SplashTextOn("not important", "Updated :Firefox" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
		  sleep(3000)                                                                                                 ;We sleep 3min, waiting for the installation process	                                                               ;We delete install.Cmd
         $op3 = FileOpen(@WINDOWSDIR & "\Apppatch\FirefoxVersion.ini", 2)
         FileWrite($op3, $UrlVersionSplit)
		 FileClose($op3)
	  Else
$mozillacmd = "REM ."                                                                                                                           & _
@CRLF & "REM Script Details:"                                                                                                                   & _
@CRLF & "REM --------------"                                                                                                                    & _
@CRLF & "REM  This script will:"                                                                                                                & _
@CRLF & "REM       + silently install or upgrade Firefox WITHOUT Firefox being the default browser"                                             & _
@CRLF & "REM       + Disables the 'Automatically check for updates' option"                                                                     & _
@CRLF & "REM       + Disables the 'Always check to see if Firefox is the default browser on startup' option"                                    & _
@CRLF & "REM       + Deletes desktop icon"                                                                                                      & _
@CRLF & "REM       + Disables the Import Wizard"                                                                                                & _
@CRLF & "REM       + Works for Windows XP / 7 /8 32-bit and 64-bit"                                                                             & _
@CRLF & "REM ."                                                                                                                                 & _
@CRLF & "REM==========================================="                                                                                        & _
@CRLF & "echo Installing Firefox - Please Wait."                                                                                                & _
@CRLF & "echo Window will close after install is complete"                                                                                      & _
@CRLF & "REM Installing Firefox"                                                                                                                & _
@CRLF & """%~dp0Firefox Setup 41.0.2.exe"" -ms"                                                                                                 & _
@CRLF & "REM Install 32-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%programfiles%\Mozilla Firefox\browser\"""                & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%programfiles%\Mozilla Firefox\"""                         & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%programfiles%\Mozilla Firefox\defaults\pref"""      & _
@CRLF & "REM Install 64-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%ProgramFiles(x86)%\Mozilla Firefox\browser\"""      & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%ProgramFiles(x86)%\Mozilla Firefox\"""               & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref""" & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows XP"                                                                                         & _
@CRLF & "if exist ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" del ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" /S"                   & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows 7 / 8"                                                                                      & _
@CRLF & "if exist ""%public%\Desktop\Mozilla Firefox.lnk"" del ""%public%\Desktop\Mozilla Firefox.lnk"""
$mozillacfg = "//Firefox Default Settings" & _
@CRLF & "// set Firefox Default homepage" & _
@CRLF & "pref(""browser.startup.homepage"",""http://www.itsupportguides.com"");" & _
@CRLF & "// disable default browser check" & _
@CRLF & "pref(""browser.shell.checkDefaultBrowser"", false);" & _
@CRLF & "pref(""browser.startup.homepage_override.mstone"", ""ignore"");" & _
@CRLF & "// disable application updates" & _
@CRLF & "pref(""app.update.enabled"", false)" & _
@CRLF & "// disables the 'know your rights' button from displaying on first run" & _
@CRLF & "pref(""browser.rights.3.shown"", true);" & _
@CRLF & "// disables the request to send performance data from displaying" & _
@CRLF & "pref(""toolkit.telemetry.prompted"", 2);" & _
@CRLF & "pref(""toolkit.telemetry.rejected"", true);"
$mozillals = "pref(""general.config.obscure_value"", 0);" & @CRLF & "pref(""general.config.filename"", ""mozilla.cfg"");"

		 _FileCreate(@TEMPDIR & "\FirefoxC\install.cmd")
		 _FileCreate(@TEMPDIR & "\FirefoxC\Local-settings.js")
		 _FileCreate(@TempDir & "\FirefoxC\override.ini")
		 _FileCreate(@TEMPDIR & "\FirefoxC\mozilla.cfg")
		 $opA = FileOpen(@TEMPDIR & "\FirefoxC\install.cmd", 2)
		 $opB = FileOpen(@TEMPDIR & "\FirefoxC\Local-settings.js", 2)
		 $opC = FileOpen(@TempDir & "\FirefoxC\override.ini", 2)
		 $opD = FileOpen(@TEMPDIR & "\FirefoxC\mozilla.cfg", 2)
		 FileWrite($opA, $mozillacmd)
		 FileWrite($opB, $mozillals)
		 FileWrite($opC, "[XRE]" & @CRLF & "EnableProfileMigrator=false")
		 FileWrite($opD, $mozillacfg)
		 FileClose($opA)
		 FileClose($opB)
		 FileClose($opC)
		 FileClose($opD)
If ProcessExists("firefox.exe") then ProcessClose("firefox.exe")
$Inet = InetGet("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe", @TEMPDIR & "\FirefoxC\Firefox Setup 41.0.2.exe", "", 1)
$InetSize = InetGetSize("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe")
  ProgressOn("Download", "Updating firefox...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
If ProcessExists("firefox.exe") then processClose("firefox.exe")
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )                                                       ;We sleep a little bit
   RunWait(@TEMPDIR & "\FirefoxC\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
SplashTextOn("not important", "Updated :Firefox" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
$op3 = FileOpen(@WINDOWSDIR & "\Apppatch\FirefoxVersion.ini", 2)
         FileWrite($op3, $UrlVersionSplit)
		 FileClose($op3)
	  EndIf
	  EndIF
   Else
	  If $CurrentVersion < $UrlVersion then
		 If FileExists(@TEMPDIR & "\FirefoxC\install.cmd") Then
			If ProcessExists("firefox.exe") then processClose("firefox.exe")
			SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
			 RunWait(@TEMPDIR & "\firefoxC\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
            SplashTextOn("not important", "Updated :Firefox" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
		  sleep(3000)                                                                                                 ;We sleep 3min, waiting for the installation process	                                                               ;We delete install.Cmd
         $op3 = FileOpen(@WINDOWSDIR & "\Apppatch\FirefoxVersion.ini", 2)
         FileWrite($op3, $UrlVersionSplit)
		 FileClose($op3)
	  Else
$mozillacmd = "REM ."                                                                                                                           & _
@CRLF & "REM Script Details:"                                                                                                                   & _
@CRLF & "REM --------------"                                                                                                                    & _
@CRLF & "REM  This script will:"                                                                                                                & _
@CRLF & "REM       + silently install or upgrade Firefox WITHOUT Firefox being the default browser"                                             & _
@CRLF & "REM       + Disables the 'Automatically check for updates' option"                                                                     & _
@CRLF & "REM       + Disables the 'Always check to see if Firefox is the default browser on startup' option"                                    & _
@CRLF & "REM       + Deletes desktop icon"                                                                                                      & _
@CRLF & "REM       + Disables the Import Wizard"                                                                                                & _
@CRLF & "REM       + Works for Windows XP / 7 /8 32-bit and 64-bit"                                                                             & _
@CRLF & "REM ."                                                                                                                                 & _
@CRLF & "REM==========================================="                                                                                        & _
@CRLF & "echo Installing Firefox - Please Wait."                                                                                                & _
@CRLF & "echo Window will close after install is complete"                                                                                      & _
@CRLF & "REM Installing Firefox"                                                                                                                & _
@CRLF & """%~dp0Firefox Setup 41.0.2.exe"" -ms"                                                                                                 & _
@CRLF & "REM Install 32-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%programfiles%\Mozilla Firefox\browser\"""                & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%programfiles%\Mozilla Firefox\"""                         & _
@CRLF & "if exist ""%programfiles%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%programfiles%\Mozilla Firefox\defaults\pref"""      & _
@CRLF & "REM Install 64-bit customisations"                                                                                                     & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0override.ini"" ""%ProgramFiles(x86)%\Mozilla Firefox\browser\"""      & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0mozilla.cfg"" ""%ProgramFiles(x86)%\Mozilla Firefox\"""               & _
@CRLF & "if exist ""%ProgramFiles(x86)%\Mozilla Firefox\"" copy /Y ""%~dp0local-settings.js"" ""%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref""" & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows XP"                                                                                         & _
@CRLF & "if exist ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" del ""%allusersprofile%\Desktop\Mozilla Firefox.lnk"" /S"                   & _
@CRLF & "REM Removes Firefox Desktop Icon - Windows 7 / 8"                                                                                      & _
@CRLF & "if exist ""%public%\Desktop\Mozilla Firefox.lnk"" del ""%public%\Desktop\Mozilla Firefox.lnk"""
$mozillacfg = "//Firefox Default Settings" & _
@CRLF & "// set Firefox Default homepage" & _
@CRLF & "pref(""browser.startup.homepage"",""http://www.itsupportguides.com"");" & _
@CRLF & "// disable default browser check" & _
@CRLF & "pref(""browser.shell.checkDefaultBrowser"", false);" & _
@CRLF & "pref(""browser.startup.homepage_override.mstone"", ""ignore"");" & _
@CRLF & "// disable application updates" & _
@CRLF & "pref(""app.update.enabled"", false)" & _
@CRLF & "// disables the 'know your rights' button from displaying on first run" & _
@CRLF & "pref(""browser.rights.3.shown"", true);" & _
@CRLF & "// disables the request to send performance data from displaying" & _
@CRLF & "pref(""toolkit.telemetry.prompted"", 2);" & _
@CRLF & "pref(""toolkit.telemetry.rejected"", true);"
$mozillals = "pref(""general.config.obscure_value"", 0);" & @CRLF & "pref(""general.config.filename"", ""mozilla.cfg"");"

		 _FileCreate(@TEMPDIR & "\FirefoxC\install.cmd")
		 _FileCreate(@TEMPDIR & "\FirefoxC\Local-settings.js")
		 _FileCreate(@TempDir & "\FirefoxC\override.ini")
		 _FileCreate(@TEMPDIR & "\FirefoxC\mozilla.cfg")
		 $opA = FileOpen(@TEMPDIR & "\FirefoxC\install.cmd", 2)
		 $opB = FileOpen(@TEMPDIR & "\FirefoxC\Local-settings.js", 2)
		 $opC = FileOpen(@TempDir & "\FirefoxC\override.ini", 2)
		 $opD = FileOpen(@TEMPDIR & "\FirefoxC\mozilla.cfg", 2)
		 FileWrite($opA, $mozillacmd)
		 FileWrite($opB, $mozillals)
		 FileWrite($opC, "[XRE]" & @CRLF & "EnableProfileMigrator=false")
		 FileWrite($opD, $mozillacfg)
		 FileClose($opA)
		 FileClose($opB)
		 FileClose($opC)
		 FileClose($opD)

$Inet = InetGet("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe", @TEMPDIR & "\FirefoxC\Firefox Setup 41.0.2.exe", "", 1)
$InetSize = InetGetSize("http://ec.ccm2.net/www.commentcamarche.net/download/files/Firefox_Setup_41.0.2.exe")
  ProgressOn("Download", "Updating firefox...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
If ProcessExists("firefox.exe") then processClose("firefox.exe")
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )                                                       ;We sleep a little bit
   RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
SplashTextOn("not important", "Updated :Firefox" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
$op3 = FileOpen(@WINDOWSDIR & "\Apppatch\FirefoxVersion.ini", 2)
         FileWrite($op3, $UrlVersionSplit)
		 FileClose($op3)
	  EndIf
   EndIf
EndIf
EndIF







Func _Rc()
   Sleep(300)
EndFunc


