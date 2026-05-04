@echo off
echo Scanning desktop for Steam shortcut files...

REM Try to find the actual desktop path
set "desktop="
if exist "%USERPROFILE%\OneDrive\Desktop" (
    set "desktop=%USERPROFILE%\OneDrive\Desktop"
    echo Found OneDrive Desktop: %desktop%
) else if exist "%USERPROFILE%\Desktop" (
    set "desktop=%USERPROFILE%\Desktop"
    echo Found local Desktop: %desktop%
) else (
    echo No desktop directory found!
    echo Checked: %USERPROFILE%\Desktop
    echo Checked: %USERPROFILE%\OneDrive\Desktop
    pause
    exit /b 1
)

REM Initialize counter
set "processed=0"

REM Scan for .url files on desktop
echo Searching for .url files in: %desktop%
for %%f in ("%desktop%\*.url") do (
    REM Check if the file actually exists (not just the pattern)
    if exist "%%f" (
        echo Found: %%f
        call :fix_icon "%%f"
        if not errorlevel 1 set /a processed+=1
    )
)

if %processed% == 0 (
    echo No Steam shortcut files found or processed on desktop.
) else (
    echo Successfully processed %processed% Steam shortcut file^(s^).
    echo Refreshing desktop...
    call :refresh_desktop
)

echo All done.
pause
exit /b 0


REM ------------------------------------------------------------
REM Function to refresh the desktop (like pressing F5)
REM ------------------------------------------------------------
:refresh_desktop
REM Create a temporary VBScript to refresh the desktop
echo Set objShell = CreateObject("Shell.Application") > "%temp%\refresh_desktop.vbs"
echo objShell.Windows().Item().Refresh >> "%temp%\refresh_desktop.vbs"
echo For Each objWindow in objShell.Windows() >> "%temp%\refresh_desktop.vbs"
echo     If objWindow.Name = "Program Manager" Then >> "%temp%\refresh_desktop.vbs"
echo         objWindow.Refresh >> "%temp%\refresh_desktop.vbs"
echo     End If >> "%temp%\refresh_desktop.vbs"
echo Next >> "%temp%\refresh_desktop.vbs"

REM Execute the VBScript
cscript //nologo "%temp%\refresh_desktop.vbs"

REM Clean up the temporary file
del "%temp%\refresh_desktop.vbs"

echo Desktop refreshed.
exit /b 0


REM ------------------------------------------------------------
REM Function to fix the icon
REM ------------------------------------------------------------
:fix_icon

echo Processing: %~1

REM Check if the file is a .url file
if /I not "%~x1" == ".url" (
    echo File is not a .url file.
    exit /b 1
)

REM Check if the file exists
if not exist "%~1" (
    echo File does not exist.
    exit /b 1
)

REM Clear variables
set "URL="
set "IconFile="
set "gameid="

REM Read the file line by line
for /f "usebackq delims=" %%i in ("%~1") do (
    echo %%i | findstr /i "^URL=" >nul && set "%%i"
    echo %%i | findstr /i "^IconFile=" >nul && set "%%i"
)

REM Validate the URL and extract the game ID
if defined URL (
    if "%URL:~0,18%" == "steam://rungameid/" set "gameid=%URL:~18%"
)
if not defined gameid (
    echo Skipping non-Steam URL: "%URL%"
    exit /b 1
)

REM Check if IconFile is defined
if not defined IconFile (
    echo No IconFile found in shortcut.
    exit /b 1
)

REM Check if icon file already exists
if exist "%IconFile%" (
    echo Icon file already exists: "%IconFile%"
    exit /b 0
)

REM Extract the icon file name
for %%f in ("%IconFile%") do set "icon_name=%%~nxf"
if not defined icon_name (
    echo Invalid icon file path: "%IconFile%"
    exit /b 1
)

REM Download the icon file
set "icon_url=https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/%gameid%/%icon_name%"
echo Downloading icon file: "%icon_url%"
curl -o "%IconFile%" "%icon_url%"

if errorlevel 1 (
    echo Failed to download icon from: "%icon_url%"
    exit /b 1
)

echo Successfully fixed icon for game ID: %gameid%
exit /b 0
