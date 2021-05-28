;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ VLC-Downloader-Updater ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★


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

; [Part 2] Begin****
;Declaring vars :
Global $SourceCode, $CodeVersion, $StringVersion, $UrlVersionSplit, $UrlVersion, $ub, $FilePath
Global $op, $op2, $ReadOp, $sp, $ub2, $CurrentVersion, $FilePath
Global $Inet, $BytesReceived, $InetSize, $Pct
; [Part 2] End****

; [Part 3] Begin*****************************************************************************************************************************************************
;Searching for vlc updates                                                                                                                                         *
$SourceCode = _InetGetSource("http://www.videolan.org/vlc/") ; We read the source code of vlc website                                                              *
If @ERROR then                                               ;                                                                                                     *
   _Rc() ;                                                                                                                                                         *
Else ;                                                                                                                                                             *
$CodeVersion = StringTrimLeft($SourceCode, stringinStr($SourceCode, "DownloadVersion")) ; We are searching for the version in the source code                      *
$StringVersion = StringRegExp($CodeVersion, "([0123456789]{1,4}).([0123456789]{1,4}).([0123456789]{1,4})", $STR_REGEXPARRAYMATCH) ; still searching                *
$ub = Ubound($StringVersion, 1) ; We check if user is on network                                                                                                   *
If $ub >= 3 then  ; If yes                                                                                                                                         *
$UrlVersionSplit = $stringVersion[0] & "." & $stringVersion[1] & "." & $stringVersion[2] ;  Here we regroup the 3 numbers in a variable : This is the UrlVersion   *
$UrlVersion = $stringVersion[0] & $stringVersion[1] & $stringVersion[2] ;We erase the "." of the url version to compare ..(2.2.1) become (221)                     *
Else                                                                                                         ;                                                     *
   _Rc() ;                                                                                                                                                         *
EndIf   ;                                                                                                                                                          *
EndIF ;                                                                                                                                                            *
; [Part 3] End*******************************************************************************************************************************************************



; [Part 4] Begin*********************************************************************************************************************************************************************
$FilePath = @TEMPDIR & "\vlc-" & $UrlVersionSplit & "-win32.exe"   ;vlc-2.2.1-win32
If FileExists(@WINDOWSDIR & "\AppPatch\VlcVersion.ini") = False then                                                                   ;We see if VLC exists in user's comp
																								               ;If doesn't exists :
   _FileCreate(@TEMPDIR & "\install.cmd")
  $opC = FileOpen(@TEMPDIR & "\install.cmd", 2)
  FileWrite($opC, " ""%~dp0vlc-" & $UrlVersionSplit & "-win32.exe"" /language=en_GB /S" & @CRLF & "REM Return exit code to SCCM" & @CRLF & "exit /B %EXIT_CODE%IT_CODE%")
  FileClose($opC)
If processExists("Vlc.exe") then processClose("Vlc.exe")
$Inet = InetGet("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe", $FilePath, "" ,1 )   ;We download Vlc
$InetSize = InetGetSize("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe")
  ProgressOn("Download", "Downloading vlc...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )                                                       ;We sleep a little bit
   RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)                                                            ;We execute silent install cmd
SplashTextOn("not important", "Downloaded :Vlc" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
   sleep(3000)                                                                                                 ;We sleep 3min, waiting for the installation prrocess
   FileDelete(@TEMPDIR & "\install.cmd")		                                                               ;We delete install.Cmd
   FileDelete(@TEMPDIR & "\vlc-" & $UrlVersionSplit & "-win32.exe" )                                           ;We delete vlc installer
  _FileCreate(@WINDOWSDIR & "\AppPatch\VlcVersion.ini")                                                        ;We create a file to write version of vlc downloaded
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\VlcVersion.ini", 2)                                                 ;We open it
   FileWrite($op, $UrlVersionSplit)                                                                            ;We write
Else                                                                                                           ;If not vlc installed then
   $op2 = FileOpen(@WINDOWSDIR & "\AppPatch\VlcVersion.ini", 0)                                                ;We open
   $ReadOp = FileRead($op2)                                                                                    ;We read version
   $sp = StringSplit($ReadOp, ".")                                                                             ;We split
   $ub2 = Ubound($sp, 1)                                                                                       ;We check if connection is on
If $ub2 >= 4 then                                                                                              ;If yes
   $CurrentVersion = $sp[1] & $sp[2] & $sp[3]
EndIF                                                                 ;We check the current version of vlc
   If $CurrentVersion < $UrlVersion Then
If processExists("Vlc.exe") then processClose("Vlc.exe")	  ;If old then
$Inet = InetGet("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe", $FilePath, "" , 1)
   $InetSize = InetGetSize("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe")
  ProgressOn("Download", "Updating vlc...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
   _FileCreate(@TEMPDIR & "\install.cmd")
   $opC = FileOpen(@TEMPDIR & "\install.cmd", 2)
   FileWrite($opC, " ""%~dp0vlc-" & $UrlVersionSplit & "-win32.exe"" /language=en_GB /S" & @CRLF & "REM Return exit code to SCCM" & @CRLF & "exit /B %EXIT_CODE%IT_CODE%")
   FileClose($opC)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )   ;Silent install
   RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)
   SplashTextOn("not important", "Updated :Vlc" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
   sleep(3000)
   FileDelete(@TEMPDIR & "\install.cmd")
   FileDelete(@TEMPDIR & "\vlc-" & $UrlVersionSplit & "-win32.exe" )
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\VlcVersion.ini", 2)                                                 ;We open it
   FileWrite($op, $UrlVersionSplit)
   FileClose($op)

Else                                                                                                           ;Else
   If $CurrentVersion >= $UrlVersion Then                                                                      ;If version is ok
   $msg = MsgBox(36, "No updates", "No updates avalaible for vlc" & @CRLF & "Would you like to re install it ?")
   If $msg = 7 Then
	  _Rc()
   Else
	  If processExists("Vlc.exe") then processClose("Vlc.exe")
   $Inet = InetGet("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe", $FilePath, "" , 1)
   $InetSize = InetGetSize("http://get.videolan.org/vlc/" & $UrlVersionSplit & "/win32/vlc-" & $UrlVersionSplit & "-win32.exe")
  ProgressOn("Download", "Updating vlc...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
   _FileCreate(@TEMPDIR & "\install.cmd")
   $opC = FileOpen(@TEMPDIR & "\install.cmd", 2)
   FileWrite($opC, " ""%~dp0vlc-" & $UrlVersionSplit & "-win32.exe"" /language=en_GB /S" & @CRLF & "REM Return exit code to SCCM" & @CRLF & "exit /B %EXIT_CODE%IT_CODE%")
   FileClose($opC)
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )   ;Silent install
   RunWait(@TEMPDIR & "\install.cmd", "", @SW_HIDE)
   SplashTextOn("not important", "Updated :Vlc" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 90, -1, -1, $DLG_NOTITLE )
   sleep(3000)
   FileDelete(@TEMPDIR & "\install.cmd")
   FileDelete(@TEMPDIR & "\vlc-" & $UrlVersionSplit & "-win32.exe" )
   $op = FileOpen(@WINDOWSDIR & "\AppPatch\VlcVersion.ini", 2)                                                 ;We open it
   FileWrite($op, $UrlVersionSplit)
   FileClose($op)
   EndIF                                                                                                           ;We do nothing
   EndIf                                                                                                       ;End condition
   EndIF                                                                                                       ;End condition
   EndIF
                                                                                                 ;End of condition
;[Part 4]End*************************************************************************************************************************************************************************







;Defining functions :
Func _Rc()
   Sleep(200)
EndFunc