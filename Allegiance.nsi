; Credits: imago, pkk, tigereye (maybe someone else, I don't know)

; Script generated by the HM NIS Edit Script Wizard.

SetCompressor lzma
 
 ; Vars for downloader
Var /GLOBAL filename
Var /GLOBAL url

; Installer has to run as administrator
RequestExecutionLevel admin

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Free"
!define PRODUCT_VERSION "Allegiance"
!define PRODUCT_PUBLISHER "The Free Allegiance Organization"
!define PRODUCT_WEB_SITE "http://www.freeallegiance.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; enable Modern User Interface (MUI)
!include "MUI.nsh"

; WinVer
!include "WinVer.nsh"

; Registry search plugin
!include "registry.nsh"

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
BrandingText "FreeAllegiance (Installer Build X)"

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
  File /r /x .svn ".\Resources\Allegiance\*.*" ;/x .svn excludes SVN folders
  
  ; This will fix the issue, that ASGS will overwrite R5 Allegiance.exe
  SetOutPath "$INSTDIR\Beta"
  File /r /x .svn ".\Resources\Allegiance\Allegiance.exe" ;/x .svn excludes SVN folders
  
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

; Shortcuts for Startmenu/Desktop - This needs an option, because desktop icons are annoying
Section -AdditionalIcons
  SetDetailsPrint both
  DetailPrint "Creating start menu entries..."
  SetDetailsPrint none
  SetOutPath "$INSTDIR"
  ;CreateShortCut "$DESKTOP\Allegiance.lnk" "$INSTDIR\ASGSClient.exe"
  ;CreateShortCut "$DESKTOP\Allegiance Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
  
  ; Make Icons for all users.
  SetShellVarContext all
  
  CreateDirectory "$SMPROGRAMS\Allegiance"
  CreateShortCut "$SMPROGRAMS\Allegiance\Allegiance.lnk" "$INSTDIR\ASGSClient.exe"
  CreateShortCut "$SMPROGRAMS\Allegiance\ReadMe.lnk"  "http://www.freeallegiance.org/FAW/index.php/Readme" "" "$INSTDIR\allegr.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\FreeAllegiance - Learning Guide.lnk" "http://www.freeallegiance.org/FAW/index.php/Learning_guide" "" "$INSTDIR\academy.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\FreeAllegiance - Tech Support.lnk" "http://www.freeallegiance.org/FAW/index.php/Tech_Support" "" "$INSTDIR\allegg.ico"
  CreateShortCut "$SMPROGRAMS\Allegiance\FreeAllegiance - Community home.lnk" "http://www.freeallegiance.org/forums/index.php?act=home" "" "$INSTDIR\allegg.ico"
 DetailPrint "... done"
SectionEnd

Section -Post
  SetDetailsPrint both
  DetailPrint "Creating Uninstaller..."
  SetDetailsPrint textonly

  ; Writing Uninstaller information
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  SetDetailsPrint both
  DetailPrint "... done"
  
  DetailPrint "Creating registry keys..."
  SetDetailsPrint textonly
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
    SimpleFC::AddApplication "FreeAllegiance - Game" "$INSTDIR\Allegiance.exe" 0 2 "" 1
    SimpleFC::AddApplication "FreeAllegiance - ASGS" "$INSTDIR\ASGSClient.exe" 0 2 "" 1
    SimpleFC::AddApplication "FreeAllegiance - ASGS Update" "$INSTDIR\ASGSUpdate.exe" 0 2 "" 1
    SetDetailsPrint both
    DetailPrint "... done"
  ${EndIf}
    
  DetailPrint "-- Installation Complete --"
  
  ; Check if IE is in offline mode
  ; http://support.microsoft.com/kb/180946
  ReadRegDWORD $R0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "GlobalUserOffline"
  ; If Offline Mode is active, fire up warning.
  ${If} $R0 == "1"
   MessageBox MB_OK|MB_ICONSTOP "Internet Explorer is running in Offline Mode.$\n$\nYou need to disable Offline Mode of Internet Explorer, to play Allegiance.$\n$\nOpen Internet Explorer, Open FILE menu and uncheck WORK OFFLINE.$\n$\nPress OK to contine setup."
  ${EndIf}
  
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ; THIS CAKE IS A LIE!
  !insertmacro MUI_DESCRIPTION_TEXT ${SECgame} "Basic game components."
  !insertmacro MUI_DESCRIPTION_TEXT ${SECunpackOGG} "Transcodes the game audio from OGG to WAV.$\n$\nThis option is only recommended for slow computers and will increase install time."
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHRasteroids} "This option will download additional high resolution asteroid textures.$\n$\n(about 30 MiB)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHRbackgrounds} "This option will download additional high resolution background textures, like planets and nebulas.$\n$\n(about 64 MiB)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SECdHReffects} "This option will download additional high resolution effect textures, like explosions and alephs.$\n$\n(about 5 MiB)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller - success message
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

; Uninstaller - initial message
Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "NOTICE: This uninstaller will remove ALL files and directories in the $(^Name) directory, including ones not placed there by the installer.  If you wish to save any of those files, click NO and back them up before proceeding.$\n$\nAre you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

; Initailisation of installer
Function .onInit
  ; Download page for HighRes files
  StrCpy $url "http://www.german-borg.de/files/installer"

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
  Delete "$DESKTOP\Allegiance.lnk"
  Delete "$DESKTOP\Allegiance Academy.lnk"
  Delete "$SMPROGRAMS\Allegiance\Allegiance.lnk"
  Delete "$SMPROGRAMS\Allegiance\Allegiance Academy.lnk"

  RMDir /r "$SMPROGRAMS\Allegiance"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd

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
  MessageBox MB_OK|MB_ICONSTOP "$(^Name) requires Microsoft Windows XP Service Pack 2 or higher."
  ; Abort setup
  Abort

  ValidOS:
FunctionEnd

; Check if .net framework 2.0 is installed
Function DotNetVersionCheck
  IfFileExists "$WINDIR\Microsoft.NET\Framework\v2.0.50727\MSBuild.exe" DotNetInstalled
  ; Fire up error, .net framework 2.0 is not installed
  MessageBox MB_OK|MB_ICONSTOP "$(^Name) requires the Microsoft .NET framework 2.0.$\n$\nNote:$\n.net Framework 3.x or 4.x are no upgrades of 2.0, they are just different runtime environments."
  MessageBox MB_YESNO "You want to start download of .NET framework 2.0 SP2 (x86) from Microsoft Download Center?$\n$\nDownload page:$\nhttp://www.microsoft.com/downloads/en/details.aspx?FamilyID=5b2c0358-915b-4eb5-9b1d-10e506da9d0f" IDYES 0 IDNO DoNotDownload
  ; Downlaod installer to temp
  inetc::get "http://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe" "$TEMP\NetFx20SP2_x86.exe" "/end"
  ; Run installer
  ExecWait "$TEMP\NetFx20SP2_x86.exe"
  ; Delete installer
  Delete "$TEMP\NetFx20SP2_x86.exe"
  Goto DotNetInstalled
  
  DoNotDownload:
  MessageBox MB_OK|MB_ICONEXCLAMATION "ASGS will not run without .net Framework 2.0.\n\nRestart installer or you have to download it yourself from Mircosoft Download Center or via Windows Update."
  Abort

  DotNetInstalled:
  ; We got .net installed, so we contine setup
FunctionEnd

; Check if DirectX 9.0c (at least Feb 2010) is installed
Function DirectX9Check
  ; http://www.toymaker.info/Games/html/d3dx_dlls.html
  IfFileExists "$SYSDIR\d3dx9_43.dll" DirectXInstalled
  ; Fire up error, outdated DirectX 9.0c is installed
  MessageBox MB_OK|MB_ICONSTOP "Can't find DirectX 9.0c (Feb 2010).$\n$\nPress OK to start installer."
  ; Run Webinstaller from temp folder
  SetOutPath "$TEMP"
  File ".\Resources\DirectX\dxwebsetup.exe"
  ExecWait "$TEMP\dxwebsetup.exe"
  Delete "$TEMP\dxwebsetup.exe"
  
  DirectXInstalled:
  ; Contine installation
 FunctionEnd

 /*
; Options:
; 1. Use the current solution (check registry for installed redistributable)
; 2. Use Lexaal's exe to detect redistributable
; 3. Ignore redistributable and just put msvcr90.dll into Allegiance folder (+ msvcp90.dll for AllSrv),
;    prime examples for this: Spore, The Guild 2, Civilisation IV, Heroes of Might and Magic V, ...
;    http://blog.kalmbach-software.de/2008/05/03/howto-deploy-vc2008-apps-without-installing-vcredist_x86exe/

; Check if VC9 is installed
Function VC90Check
  ; possible search strings: "Microsoft Visual C++ 2008 ATL Update kb973924", "Microsoft Visual C++ 2008 SP1 Redistributable", "Microsoft Visual C++ 2008 Redistributable"
  ${registry::Open} "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" "/K=0 /V=0 /S=1 /B=1 /NI='Microsoft Visual C++ 2008' /T=REG_SZ" $0
  StrCmp $0 0 0 jm_search ; If we can open registry, jump
  
  ; Error, if we con't open Registry
  MessageBox MB_OK "Could not read registry"
  ; Closing registry
  ${registry::Close} "$0"
  ${registry::Unload}
  ; exit setup
  Abort

  jm_search:
  ${registry::Find} "$0" $1 $2 $3 $4
  StrCmp $4 "REG_SZ" VC90Installed ; We found the string
  
  ; Fire up error, Visual C++ Redist is not installed
  MessageBox MB_OK|MB_ICONSTOP "You need to install Visual C++ 2008 runtimes.$\n$\nDownload and install it in your operation system language version!$\n$\nPress OK to open download page."
  ; Run Webinstaller
  ExecShell Open "http://www.microsoft.com/downloads/en/details.aspx?FamilyID=2051a0c1-c9b5-4b0a-a8f5-770a549fd78c"
  ; Exit setup
  Abort
  
  VC90Installed:
  ; Closing registry
  ${registry::Close} "$0"
  ${registry::Unload}
  ; Contine installation
 FunctionEnd
 */