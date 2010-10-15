@echo off
REM This script need NSIS and plugins installed into it's default localtion (e.g. C:\Program Files\NSIS)

REM Run from 32 bit systems default location
if EXIST "%ProgramFiles%\NSIS\makensis.exe" "%ProgramFiles%\NSIS\makensis.exe" Allegiance.nsi

REM Run from 64 bit systems default location
if EXIST "%ProgramFiles(x86)%\NSIS\makensis.exe" "%ProgramFiles(x86)%\NSIS\makensis.exe" Allegiance.nsi

REM Don't close the window automaticly, if finished.
pause