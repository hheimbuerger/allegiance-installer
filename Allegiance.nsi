; Credits: imago, pkk, tigereye, BackTrak (maybe someone else, I don't know)

; Script generated by the HM NIS Edit Script Wizard.

SetCompressor lzma
 
; Vars for downloader
;Var /GLOBAL filename
;Var /GLOBAL url

; Installer has to run as administrator
RequestExecutionLevel admin

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Free Allegiance"
!define SHORT_PRODUCT_NAME "Allegiance"
!define PRODUCT_VERSION "1.2"
!define PRODUCT_PUBLISHER "The Free Allegiance Organization"
!define PRODUCT_WEB_SITE "http://www.freeallegiance.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME} ${PRODUCT_VERSION}"

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
!insertmacro MUI_PAGE_LICENSE ".\Resources\ACSS\EULA.RTF"
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
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION} (Build ${__DATE__} ${__TIME__})"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "AllegSetup_X.exe"
InstallDir "$PROGRAMFILES\Microsoft Games\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}"
ShowInstDetails show
ShowUnInstDetails show

Section "${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION} Game" SECgame
  SectionIn RO
  SetDetailsPrint textonly
  DetailPrint "Checking DirectX installation..."
  Call DirectX9Check
  DetailPrint "... OK"
  DetailPrint "Checking .Net Framework 3.5 installation..."
  Call DotNetVersionCheck
  DetailPrint ".... OK"
  
  DetailPrint "Checking Visual C++ 2010 Runtime installation..."
  Call VC2010Check
  DetailPrint ".... OK"
  
  SetDetailsPrint both
  DetailPrint "Extracting game files..."
  SetDetailsPrint listonly
  
  SetOutPath "$INSTDIR"
  SetOverwrite on


  ; Copy Production
  SetOutPath "$INSTDIR\Production"
  File /r /x .svn ".\Resources\Allegiance\*.*" ;/x .svn excludes SVN folders

  ; Copy Beta
  SetOutPath "$INSTDIR\Beta"
  File /r /x .svn ".\Resources\Allegiance\*.*" ;/x .svn excludes SVN folders
  
  ; Copy ACSS
  SetOutPath "$INSTDIR"
  File /r /x .svn ".\Resources\ACSS\*.*" ;/x .svn excludes SVN folders
  
  ; Remove all .ds files
  IfFileExists "$INSTDIR\*.ds" DeleteDS DoNotDeleteDS
  DeleteDS:
  Delete "$INSTDIR\*.ds"
  DoNotDeleteDS:
  
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
  
  SetOutPath "$INSTDIR\Production\Artwork"
  ExecWait '"$INSTDIR\Production\Artwork\oggdec.exe" "$INSTDIR\Production\Artwork\*.ogg"'
  
  SetOutPath "$INSTDIR\Artwork"
  ExecWait '"$INSTDIR\Beta\Artwork\oggdec.exe" "$INSTDIR\Beta\Artwork\*.ogg"'
  
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
  CreateShortCut "$DESKTOP\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}.lnk" "$INSTDIR\Launcher.exe" "" "$INSTDIR\Launcher.exe" 0
  ;CreateShortCut "$DESKTOP\Allegiance Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
 
  CreateDirectory "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}"
  CreateShortCut "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}\Allegiance.lnk" "$INSTDIR\Launcher.exe" "" "$INSTDIR\Launcher.exe" 0
  CreateShortCut "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}\ReadMe.lnk"  "http://www.freeallegiance.org/FAW/index.php/Readme" "" "$INSTDIR\allegr.ico"
  CreateShortCut "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}\Free Allegiance - Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
  CreateShortCut "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}\Free Allegiance - Tech Support.lnk" "http://www.freeallegiance.org/FAW/index.php/Tech_Support" "" "$INSTDIR\allegg.ico"
  CreateShortCut "$SMPROGRAMS\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}\Free Allegiance - Community home.lnk" "http://www.freeallegiance.org/forums/index.php?act=home" "" "$INSTDIR\allegg.ico"
 
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
  
  ; ACSS registry keys - Note, ACSS depends on the 1.2 version of the registry. If you want to change
  ; this version number in the future, you will need to update ACSS and the Allegiance code base.
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "Lobby Path" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2\" "ClientService" "https://allsrvbox.alleg.net/CSSServer/ClientService.svc"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2\" "ManagementWebRoot" "http://allsrvbox.alleg.net"
  

  ; ArtPath - Defines Artwork path
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "ArtPath" "$INSTDIR\Production\Artwork"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "BetaArtPath" "$INSTDIR\Beta\Artwork"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "ProductionArtPath" "$INSTDIR\Production\Artwork"
  
  ; EXE Path
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "EXE Path" "$INSTDIR\Production"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "Beta EXE Path" "$INSTDIR\Beta"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "Production EXE Path" "$INSTDIR\Production"
  
  ; CfgFile
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "CfgFile" "http://allsrvbox.alleg.net/allegiance.txt"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "BetaCfgFile" "http://allsrvbox.alleg.net/allegiance-beta.txt"
  WriteRegStr HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "ProductionCfgFile" "http://allsrvbox.alleg.net/allegiance.txt"
  
  ; FIRSTRUN
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "FIRSTRUN" "1"
  ; HasTrained - Disabled
  WriteRegDWORD HKLM "Software\Microsoft\Microsoft Games\Allegiance\1.2" "HasTrained" "1"
  
  SetDetailsPrint both
  DetailPrint "... done"
  
  ; The following allows users to run Allegiance without administrator rights
  DetailPrint "Updating access control list..."
  SetDetailsPrint textonly
  ; Allow users to write into Allegiance directory
  AccessControl::EnableFileInheritance "$INSTDIR"
  AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"
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

    SimpleFC::AddApplication "${PRODUCT_NAME} ${PRODUCT_VERSION} - Game" "$INSTDIR\Production\Allegiance.exe" 0 2 "" 1
    SimpleFC::AddApplication "${PRODUCT_NAME} ${PRODUCT_VERSION} - Game Beta" "$INSTDIR\Beta\Allegiance.exe" 0 2 "" 1
    SimpleFC::AddApplication "${PRODUCT_NAME} ${PRODUCT_VERSION} - ACSS" "$INSTDIR\Launcher.exe" 0 2 "" 1
    SetDetailsPrint both
    DetailPrint "... done"
  ${EndIf}

  
 ; ACSS is not signed, so UAC will ask users to run app as administrator
 ; This will remove that message and runs Launcher as admininstrator without asking.
 ; Documentation: http://technet.microsoft.com/en-us/library/cc748912(WS.10).aspx
 ${If} ${AtLeastWinVista}
   DetailPrint "Adding programs to application compatibillity list..."
   SetDetailsPrint textonly
   SetOutPath "$TEMP"
   File ".\Resources\Compatibility\Compatibility.sdb"
   ExecWait "sdbinst /q $TEMP\Compatibility.sdb"
   Delete "$TEMP\Compatibility.sdb"
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

  ; Let people know we aren't playing 24/7
  MessageBox MB_ICONINFORMATION|MB_OK "Game servers may be empty during non-peak playing times.$\n$\nFind players online between 2 pm and midnight New York time (EST) (European evening)."
   
  ; oggdec is no longer needed, after installer is finished, so we delete it
  SetDetailsPrint textonly
  Delete "$INSTDIR\Beta\Artwork\oggdec.exe"
  Delete "$INSTDIR\Production\Artwork\oggdec.exe"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ; THIS CAKE IS A LIE!
  !insertmacro MUI_DESCRIPTION_TEXT ${SECgame} "Required game components."
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
  ; Download page for HighRes files
  ; StrCpy $url "http://www.german-borg.de/files/installer"

  Call WindowsVersionCheck
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
  Delete "$DESKTOP\${SHORT_PRODUCT_NAME} ${PRODUCT_VERSION}.lnk"
  ;Delete "$DESKTOP\Allegiance Learning Guide.lnk"

 ; Remove application compatiblity
 ; If database got renamed, this must get changed, too!
 ${If} ${AtLeastWinVista}
   ExecWait "sdbinst -n $\"Free Allegiance 1.2 - Application Compatibility Database$\""
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
    SimpleFC::RemoveApplication "$INSTDIR\Production\Allegiance.exe"
    SimpleFC::RemoveApplication "$INSTDIR\Beta\Allegiance.exe"
    SimpleFC::RemoveApplication "$INSTDIR\Launcher.exe"
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

; Check if .net framework 3.5 is installed
Function DotNetVersionCheck
  ; http://stackoverflow.com/questions/199080/how-to-detect-what-net-framework-versions-and-service-packs-are-installed
  ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Install"
  ${If} $R0 == "1"
      goto DotNetInstalled
  ${EndIf}
  ; Fire up error, .net framework 3.5 is not installed
  MessageBox MB_ICONEXCLAMATION|MB_YESNO "$(^Name) requires the Microsoft .NET framework 3.5.$\n$\nWould you like to install it now?" IDYES InstallNetFramework35
  Goto DotNetInstalled

  InstallNetFramework35:
	; Run installer from temp folder
	SetOutPath "$TEMP"
	File ".\Resources\NetFX35\dotnetfx35setup.exe"
	ExecWait "$TEMP\dotnetfx35setup.exe"
	Delete "$TEMP\dotnetfx35setup.exe"
	SetDetailsPrint listonly
	DetailPrint "... done"

	ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Install"
	${If} $R0 != "1"		
		MessageBox MB_ICONEXCLAMATION|MB_YESNO "$(^Name) Microsoft .NET framework 3.5 install did not complete.$\n$\nWould you like to continue installing Allegiance and try again later?" IDYES DotNetInstalled
		
		MessageBox MB_ICONSTOP|MB_OK "Setup will now exit."
		StrCpy $R9 "X"
		Call RelGotoPage ; Execution ends after this call (cancel button is virtually clicked)
	${EndIf}

  DotNetInstalled:
  ; We got .net installed, so we contine setup
FunctionEnd

; Check if DirectX 9.0c (at least Feb 2010) is installed
Function DirectX9Check
  ; http://www.toymaker.info/Games/html/d3dx_dlls.html
  IfFileExists "$SYSDIR\d3dx9_43.dll" DirectXInstalled

  ; Fire up error, outdated DirectX detected
  MessageBox MB_ICONSTOP|MB_YESNO "$(^Name) couldn't detect DirectX 9.0c (February 2010 Update), would you like to update your DirectX to 9.0c?" IDNO AbortDirectX
  
  ; Run Webinstaller from temp folder
  SetOutPath "$TEMP"
  File ".\Resources\DirectX\dxwebsetup.exe"
  ExecWait "$TEMP\dxwebsetup.exe"
  Delete "$TEMP\dxwebsetup.exe"
  
  AbortDirectX: 
  ; Do nothing, continue on. 
  
  DirectXInstalled:
  ; Contine installation
FunctionEnd

Function VC2010Check
	ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x86" "Installed"
	${If} $R0 == "1"
	  goto VC2010Installed
	${EndIf}
	; Fire up error, vc2010 is not installed
	MessageBox MB_ICONSTOP|MB_YESNO "$(^Name) couldn't detect Microsoft Visual C++ Runtimes v2010, would you like to install it now?" IDNO AbortVC2010
	
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
	
	; If it's still not set, then abort the installation.
	ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x86" "Installed"
	${If} $R0 != "1"
		Goto AbortVC2010
	${EndIf}
	
	Goto VC2010Installed
	
	AbortVC2010:
	MessageBox MB_ICONSTOP|MB_OK "VC++ 2010 Runtimes are required to install this application. Setup will now exit."
	StrCpy $R9 "X"
	Call RelGotoPage ; Execution ends after this call (cancel button is virtually clicked)
	
	
	VC2010Installed:
	; We got .net installed, so we contine setup
FunctionEnd

; http://nsis.sourceforge.net/Go_to_a_NSIS_page
Function RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
 
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd
