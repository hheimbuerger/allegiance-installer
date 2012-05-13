; Credits: imago, pkk, tigereye (maybe someone else, I don't know)

; Script generated by the HM NIS Edit Script Wizard.

SetCompressor lzma
 
; Vars for downloader
;Var /GLOBAL filename
;Var /GLOBAL url

; Installer has to run as administrator
RequestExecutionLevel admin

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Free"
!define PRODUCT_VERSION "Allegiance"
!define PRODUCT_PUBLISHER "The Free Allegiance Organization"
!define PRODUCT_WEB_SITE "http://www.freeallegiance.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

# defines for newer versions
!include Sections.nsh
# SECTION_OFF is defined in Sections.nsh as 0xFFFFFFFE
!define SECTION_ON ${SF_SELECTED} # 0x1

; enable Modern User Interface (MUI)
!include "MUI.nsh"

; WinVer
!include "WinVer.nsh"

; x64 detector
!include "x64.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP ".\Resources\Bitmaps\splash.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP ".\Resources\Bitmaps\header.bmp"
!define MUI_ICON ".\Resources\Bitmaps\allegb.ico"
!define MUI_UNICON ".\Resources\Bitmaps\allegb.ico"
!define MUI_FINISHPAGE_SHOWREADME "http://www.freeallegiance.org/FAW/index.php/Readme"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE ".\Resources\Allegiance\EULA.RTF"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

SetFont "Tahoma" 8
BrandingText "Free Allegiance (Build of ${__DATE__} ${__TIME__})"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Allegiance Setup.exe"
InstallDir "$PROGRAMFILES\Microsoft Games\Allegiance"
ShowInstDetails show
ShowUnInstDetails show

Section "Allegiance Game" SECgame
  SectionIn RO
  SetDetailsPrint both
  DetailPrint "Extracting Files..."
  SetDetailsPrint textonly
  SetOutPath "$INSTDIR"
  SetOverwrite on
  
  ; Copy Allegiance
  File /r /x .svn ".\Resources\Allegiance\*.*" ;/x .svn excludes SVN folders
  
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd

; Deploy VC runtimes
Section /o "Visual C++ 2010 Redist" SECVC
  SetDetailsPrint both
  DetailPrint "Starting Visual Studio 2010 redist setup... "
  SetDetailsPrint none
  ; Run installer from temp folder
  ; VC10 installer isn't bound at system language :)
  SetOutPath "$TEMP"
  File ".\Resources\VC10\vcredist_x86.exe"
  ExecWait "$TEMP\vcredist_x86.exe"
  Delete "$TEMP\vcredist_x86.exe"
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd

; Option to unpack OGG files to wave - ogg decoder won't get deleted
Section /o "Unpack OGG Files" SECunpackOGG
  SetDetailsPrint both
  DetailPrint "Decoding audio files... "
  SetDetailsPrint listonly
  DetailPrint "(this will take several minutes)"
  SetDetailsPrint none
  SetOutPath "$INSTDIR\Artwork"
  ExecWait '"$INSTDIR\Artwork\oggdec.exe" "$INSTDIR\Artwork\*.ogg"'
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd

/*
Example for download content

Section /o "HighRes Asteroids" SECdHRasteroids
  StrCpy $filename "HR_asteroids.7z"
  SetDetailsPrint both
  DetailPrint "Downloading asteroid textures..."
  SetDetailsPrint textonly
  Call DownloadHR
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd

Section /o "HighRes Backgrounds" SECdHRbackgrounds
  StrCpy $filename "HR_backgrounds.7z"
  SetDetailsPrint both
  DetailPrint "Downloading asteroid textures..."
  SetDetailsPrint textonly
  Call DownloadHR
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd

Section /o "HighRes Effects" SECdHReffects
  StrCpy $filename "HR_effects.7z"
  SetDetailsPrint both
  DetailPrint "Downloading asteroid textures..."
  SetDetailsPrint textonly
  Call DownloadHR
  SetDetailsPrint listonly
  DetailPrint "... done"
SectionEnd
*/

; Shortcuts for Startmenu/Desktop - This needs an option, because desktop icons are annoying
Section -AdditionalIcons
  SetDetailsPrint both
  DetailPrint "Creating start menu entries..."
  SetDetailsPrint none
  SetOutPath "$INSTDIR"

  ; Make Icons for all users.
  SetShellVarContext all

  ; IMPORTANT - You need to delete desktop shortcuts separately in the uninstaller!
  CreateShortCut "$DESKTOP\Allegiance.lnk" "$INSTDIR\ASGSClient.exe" "" "$INSTDIR\ASGSClient.exe" 0
  ;CreateShortCut "$DESKTOP\Allegiance Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
 
  CreateDirectory "$SMPROGRAMS\Allegiance"
  CreateShortCut "$SMPROGRAMS\Allegiance\Allegiance.lnk" "$INSTDIR\ASGSClient.exe" "" "$INSTDIR\ASGSClient.exe" 0
  CreateShortCut "$SMPROGRAMS\Allegiance\ReadMe.lnk"  "http://www.freeallegiance.org/FAW/index.php/Readme" "" "$INSTDIR\allegr.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\Create Account.lnk" "http://asgs.alleg.net/asgsnet/newaccount.aspx" "" "$INSTDIR\allegr.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\Free Allegiance - Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\Free Allegiance - Tech Support.lnk" "http://www.freeallegiance.org/FAW/index.php/Tech_Support" "" "$INSTDIR\allegg.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\Free Allegiance - Community home.lnk" "http://www.freeallegiance.org/forums/index.php?act=home" "" "$INSTDIR\allegg.ico"
 
  SetDetailsPrint both 
  DetailPrint "... done"
SectionEnd

Section -Post
  SetDetailsPrint both
  DetailPrint "Creating Uninstaller..."
  SetDetailsPrint textonly

  ; Writing Uninstaller information
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  SetDetailsPrint both
  DetailPrint "... done"
  
  DetailPrint "Creating registry keys..."
  SetDetailsPrint textonly
  
  ; ASGS
  ; Having a key for ASGS will not bring up OOBE error
  ; It makes no sense to write more registry keys, because ASGS will always complain about wrong Password hash.
  ; (Unable to Read Registry Values - Bad Data)
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0\ASGS\2.0" "AbnormalExit" "FALSE"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0\ASGS\2.0" "FirstRun" "False"
  
  ; Artpath
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "ArtPath" "$INSTDIR\Artwork"
  ; EXE Path - Install directory of Allegiance.exe
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "EXE Path" "$INSTDIR"
  ; CfgFile - Where to get config file
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "CfgFile" "http://autoupdate.alleg.net/allegiance.cfg"
  ; CDKey - still used?
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "CDKey" "FERAL-1234567890123456"
  ; FIRSTRUN - still used?
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "FIRSTRUN" "1"
  ; HasTrained - Disables Training mission popup
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.0" "HasTrained" "1"
  
  ; BETA ArtPath - Defines Artwork path
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "ArtPath" "$INSTDIR\Artwork"
  ; BETA EXE Path - This is why ASGS overwrites Allegiance.exe in beta mode
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "EXE Path" "$INSTDIR\Beta" ; This will fix the issue, that ASGS will overwrite R5 Allegiance.exe
  ; BETA CfgFile
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "CfgFile" "http://fazdev.alleg.net/FAZ/FAZbeta.cfg"
  ; BETA CDKey
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "CDKey" "FERAL-1234567890123456"
  ; BETA FIRSTRUN
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "FIRSTRUN" "1"
  ; BETA HasTrained
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.1" "HasTrained" "1"
  
  SetDetailsPrint both
  DetailPrint "... done"
  
  ; The following allows users to run Allegiance without administrator rights
  DetailPrint "Updating access control list..."
  SetDetailsPrint textonly
  ; Allow users to write into Allegiance directory
  AccessControl::EnableFileInheritance "$INSTDIR"
  AccessControl::GrantOnFile "$INSTDIR" "(BU)" "GenericRead + GenericWrite"
  ; Allow users to write registry settings
  ${If} ${RunningX64}
    AccessControl::EnableRegKeyInheritance  HKLM "Software\\Wow6432Node\\Microsoft\\Microsoft Games\\Allegiance"
    AccessControl::GrantOnRegKey HKLM "Software\\Wow6432Node\\Microsoft\\Microsoft Games\\Allegiance" "(BU)" "FullAccess"
  ${Else}
    AccessControl::EnableRegKeyInheritance  HKLM "Software\\Microsoft\\Microsoft Games\\Allegiance"
    AccessControl::GrantOnRegKey HKLM "Software\\Microsoft\\Microsoft Games\\Allegiance" "(BU)" "FullAccess"
  ${EndIf}
  SetDetailsPrint both
  DetailPrint "... done"
  
  ; Add exception to Windows Firewall
  SimpleFC::IsFirewallEnabled ; Is Windows Firewall enabled?
  Pop $0
  Pop $1
  ${If} $1 == 1
    ; This runs only, if Windows Firewall is active
    DetailPrint "Adding exceptions to Windows Firewall..."
    SetDetailsPrint textonly
    SimpleFC::AddApplication "Free Allegiance - Game" "$INSTDIR\Allegiance.exe" 0 2 "" 1
    SimpleFC::AddApplication "Free Allegiance - ASGS" "$INSTDIR\ASGSClient.exe" 0 2 "" 1
    SimpleFC::AddApplication "Free Allegiance - ASGS Update" "$INSTDIR\ASGSUpdate.exe" 0 2 "" 1
    SetDetailsPrint both
    DetailPrint "... done"
  ${EndIf}

  
 ; ASGS is not signed, so UAC will ask users to run app as administrator
 ; Documentation: http://technet.microsoft.com/en-us/library/cc748912(WS.10).aspx
 ${If} ${AtLeastWinVista}
   DetailPrint "Adding programs to application compatibillity list..."
   SetDetailsPrint textonly
   SetOutPath "$TEMP"
   File ".\Resources\Compatibility\Compatibility.sdb"
   ExecWait "sdbinst $TEMP\Compatibility.sdb"
   Delete "$TEMP\ASGS.sdb"
   SetDetailsPrint both
   DetailPrint "... done"
 ${EndIf}

  DetailPrint "-- Installation Complete --"
  
  ; Check if IE is in offline mode
  ; http://support.microsoft.com/kb/180946
  ReadRegDWORD $R0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "GlobalUserOffline"
  ; If Offline Mode is active, fire up warning.
  ${If} $R0 == "1"
   MessageBox MB_ICONSTOP|MB_OK "Internet Explorer is running in Offline Mode.$\n$\nYou need to disable Offline Mode of Internet Explorer, to play Allegiance.$\n$\nOpen Internet Explorer, Open FILE menu and uncheck WORK OFFLINE.$\n$\nPress OK to contine setup."
  ${EndIf}
  
  ; Ask if user wants to create new account
  MessageBox MB_ICONQUESTION|MB_YESNO "Do you want to create a new account, to play online?$\n$\nIf you already have a ASGS account, you can click on NO." IDYES 0 IDNO +2
   ExecShell "open" "http://asgs.alleg.net/asgsnet/newaccount.aspx"
   
  ; oggdec is no longer needed, after installer is finished, so we delete it
  SetDetailsPrint textonly
  Delete "$INSTDIR\Artwork\oggdec.exe"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ; THIS CAKE IS A LIE!
  !insertmacro MUI_DESCRIPTION_TEXT ${SECgame} "Basic game components."
  !insertmacro MUI_DESCRIPTION_TEXT ${SECunpackOGG} "Transcodes the game audio from OGG to WAV.$\n$\nThis option is only recommended for slow computers and will increase install time."
/*
Example of download content
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHRasteroids} "This option will download additional high resolution asteroid textures.$\n$\n(about 30 MiB)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHRbackgrounds} "This option will download additional high resolution background textures, like planets and nebulas.$\n$\n(about 64 MiB)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHReffects} "This option will download additional high resolution effect textures, like explosions and alephs.$\n$\n(about 5 MiB)"
*/
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller - success message
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

; Uninstaller - initial message
Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "NOTICE: This uninstaller will remove ALL files and directories in the $(^Name) directory, including ones not placed there by the installer. If you wish to save any of those files, click NO and back them up before proceeding.$\n$\nAre you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

; Initailisation of installer
Function .onInit
  ; VC++ is selected by default
  Push $0
  StrCpy $1 ${SECVC} ; Gotta remember which section we are at now...
  SectionGetFlags ${SECVC} $0
  IntOp $0 $0 | ${SECTION_ON}
  SectionSetFlags ${SECVC} $0
  Pop $0

  ; Download page for HighRes files
  ; StrCpy $url "http://www.german-borg.de/files/installer"

  Call WindowsVersionCheck
  Call DirectX9Check
  ;Call VC90Check
  Call DotNetVersionCheck
FunctionEnd

; Uninstaller - remove files
Section Uninstall
  SetDetailsPrint both
  DetailPrint "Please wait while Allegiance is uninstalled."
  SetDetailsPrint textonly
  SetOutPath "$INSTDIR"
  
  ; Remove startmenu
  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\Allegiance"
  
  ; Remove desktop shortcut
  Delete "$DESKTOP\Allegiance.lnk"
  ;Delete "$DESKTOP\Allegiance Learning Guide.lnk"

 ; Remove application compatiblity
 ; If database got renamed, this must get changed, too!
 ${If} ${AtLeastWinVista}
   ExecWait "sdbinst -n $\"Free Allegiance - Application Compatibility Database$\""
 ${EndIf}
  
  ; Remove installation folder
  RMDir /r "$INSTDIR"
  
  ; Remove Allegiance registry keys
  DeleteRegKey HKLM "Software\Microsoft\Microsoft Games\Allegiance"
  
  ; Remove firewall rules
  SimpleFC::IsFirewallEnabled ; Is Windows Firewall enabled?
  Pop $0
  Pop $1
  ${If} $1 == 1
    ; This runs only, if Windows Firewall is active
    SimpleFC::RemoveApplication "$INSTDIR\Allegiance.exe"
    SimpleFC::RemoveApplication "$INSTDIR\ASGSClient.exe"
    SimpleFC::RemoveApplication "$INSTDIR\ASGSUpdate.exe"
  ${EndIf}

  ; Remove uninstaller information
  DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
  
  SetAutoClose true
SectionEnd

/*

Example for download content

Function DownloadHR
  ; downloading file
  DetailPrint "Beginning download of HighRes Asteroids..."
  inetc::get "$url/$filename" "$TEMP\$filename" "/end"
  DetailPrint "... done"
  Pop $0
  ${If} $0 == "Cancelled"
    DetailPrint "Download cancelled!"
	Goto dlfailed
  ${ElseIf} $0 != "OK"
    DetailPrint "Download failed!"
	Goto dlfailed
  ${EndIf}
  
  ; extract file
  DetailPrint "Extracting download..."
  SetOutPath "$INSTDIR\artwork\Textures\"
  SetOverwrite on
  ;File "$TEMP\$filename"
  Nsis7z::ExtractWithDetails "$TEMP\$filename" "Installing package %s..."
  Delete "$TEMP\$filename"

  dlfailed:  
 FunctionEnd
 */
 
; Check of Windows version
Function WindowsVersionCheck
  ; At least XP
  ${If} ${IsWinXP}
  ; and at least Service Pack 2
  ${AndIf} ${AtLeastServicePack} 2
  ; Or 2003/Vista/Win7
  ${OrIf} ${AtLeastWin2003}
      goto ValidOS
  ${EndIf}

  ; Win9x/WinNT/Win2k/WinXPSP1
  ; Fire up error, that OS is outdated and not supported
  MessageBox MB_ICONSTOP|MB_OK "$(^Name) requires Microsoft Windows XP Service Pack 2 or higher."
  ; Abort setup
  Abort

  ValidOS:
FunctionEnd

; Check if .net framework 2.0 is installed
Function DotNetVersionCheck
  IfFileExists "$WINDIR\Microsoft.NET\Framework\v2.0.50727\MSBuild.exe" DotNetInstalled
  
  ; Fire up error, .net framework 2.0 is not installed
  MessageBox MB_ICONSTOP|MB_OK "$(^Name) requires the Microsoft .NET framework 2.0.$\n$\nNote:$\n.net Framework 3.x or 4.x are no upgrades of 2.0, they are just different runtime environments."

  MessageBox MB_ICONQUESTION|MB_YESNO "Do you want to start download of .NET framework 2.0 SP2 (x86) from Microsoft Download Center?$\n$\nDownload page:$\nhttp://www.microsoft.com/downloads/en/details.aspx?FamilyID=5b2c0358-915b-4eb5-9b1d-10e506da9d0f" IDYES 0 IDNO DoNotDownload
  
  ; Downlaod installer to temp
  inetc::get "http://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe" "$TEMP\NetFx20SP2_x86.exe" "/end"
  
  ; Run installer
  ExecWait "$TEMP\NetFx20SP2_x86.exe"
  
  ; Delete installer
  Delete "$TEMP\NetFx20SP2_x86.exe"
  
  Goto DotNetInstalled
  
  DoNotDownload:
  MessageBox MB_ICONEXCLAMATION|MB_OK "ASGS will not run without .net Framework 2.0.\n\nRestart installer or you have to download it yourself from Mircosoft Download Center or via Windows Update."
  Abort

  DotNetInstalled:
  ; We got .net installed, so we contine setup
FunctionEnd

; Check if DirectX 9.0c (at least Feb 2010) is installed
Function DirectX9Check
  ; http://www.toymaker.info/Games/html/d3dx_dlls.html
  IfFileExists "$SYSDIR\d3dx9_43.dll" DirectXInstalled

  ; Run Webinstaller from temp folder
  SetOutPath "$TEMP"
  File ".\Resources\DirectX\dxwebsetup.exe"
  ExecWait "$TEMP\dxwebsetup.exe"
  Delete "$TEMP\dxwebsetup.exe"
  
  DirectXInstalled:
  ; Contine installation
FunctionEnd