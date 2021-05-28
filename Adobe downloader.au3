;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ AdobeReader-Downloader ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
If FileExists(@WINDOWSDIR & "\AppPatch\AdobeVersion.ini") = False then
   If ProcessExists("AcroRd32.exe") Then ProcessClose("AcroRd32.exe")
   If ProcessExists("AcroRd64.exe") Then ProcessClose("AcroRd64.exe")
$Inet = InetGet("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500920069/AcroRdrDC1500920069_fr_FR.exe", @TEMPDIR & "\adobe.exe", "", 1)
$InetSize = InetGetSize("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500920069/AcroRdrDC1500920069_fr_FR.exe")
ProgressOn("Download", "Downloading Adobe Reader...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\adobe.exe /sAll /rs /msi EULA_ACCEPT=YES", "", @SW_HIDE)
SplashTextOn("not important", "Downloaded :Adobe Reader" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 110, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\adobe.exe")
_FileCreate(@WINDOWSDIR & "\AppPatch\AdobeVersion.ini")
Else
   $msg = msgbox(36, "No updates", "Adobe is already installed" & @CRLF & "Would you like to reinstall it ?")
If $msg = 7 Then
   _Rc()
Else
   If ProcessExists("AcroRd32.exe") Then ProcessClose("AcroRd32.exe")
   If ProcessExists("AcroRd64.exe") Then ProcessClose("AcroRd64.exe")
$Inet = InetGet("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500920069/AcroRdrDC1500920069_fr_FR.exe", @TEMPDIR & "\adobe.exe", "", 1)
$InetSize = InetGetSize("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500920069/AcroRdrDC1500920069_fr_FR.exe")
ProgressOn("Download", "Updating Adobe Reader...", "0%")
  While Not InetGetInfo($Inet, 2)
  sleep(500)
$BytesReceived = InetGetInfo($Inet, 0)
$Pct = Int($BytesReceived / $InetSize * 100)
ProgressSet($Pct, $Pct & "%")
Wend
ProgressOff()
SplashTextOn("not important", "Installing ..", 190, 50, -1, -1, $DLG_NOTITLE, "", 16, $FW_SEMIBOLD )
RunWait(@TEMPDIR & "\adobe.exe /sAll /rs /msi EULA_ACCEPT=YES", "", @SW_HIDE)
SplashTextOn("not important", "Updated :Adobe Reader" & @CRLF & @CRLF &  "Statut :" &  "OK(up to date)", 210, 110, -1, -1, $DLG_NOTITLE )
Sleep(4000)
FileDelete(@TEMPDIR & "\adobe.exe")
EndIf
EndIf

Func _Rc()
   Sleep(100)
EndFunc