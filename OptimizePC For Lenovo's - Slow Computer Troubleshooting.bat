@echo off

set "logPath=C:\temp\script_logs.txt"

rem Check if temp folder exists, if not, create it
if not exist C:\temp\ (
    mkdir C:\temp
    echo Temp folder created at %date% %time% >> %logPath%
) else (
    echo Temp folder already exists >> %logPath%
)

echo Script executed at %date% %time% >> %logPath%

echo Logging script output to %logPath%
echo ------------------------------- >> %logPath%
echo %date% %time% >> %logPath%
echo ------------------------------- >> %logPath%

echo Deleting temporary files...
echo Deleting temporary files... at %date% %time% >> %logPath%
del /f /s /q %temp%\* > nul 2>&1
del /f /s /q C:\Windows\Temp\* > nul 2>&1
echo Temporary files deleted at %date% %time% >> %logPath%
echo Temporary files deleted
echo.

echo Clearing DNS cache... at %date% %time% >> %logPath%
echo Clearing DNS cache...
ipconfig /flushdns > nul 2>&1
echo DNS cache cleared %date% %time% >> %logPath%
echo DNS cache cleared
echo.

echo Stopping unnecessary services... at %date% %time% >> %logPath%
echo Stopping unnecessary services...
net stop "Windows Search" > nul 2>&1
net stop "Superfetch" > nul 2>&1
net stop "Print Spooler" > nul 2>&1
net stop "Windows Update" > nul 2>&1
net stop "Windows Time" > nul 2>&1
net stop "Background Intelligent Transfer Service" > nul 2>&1
net stop "Themes" > nul 2>&1
net stop "Windows Firewall" > nul 2>&1
net stop "Windows Biometric Service" > nul 2>&1
net stop "Security Center" > nul 2>&1
net stop "Windows Error Reporting Service" > nul 2>&1
echo Additional unnecessary services stopped
echo.

echo Unnecessary services stopped at %date% %time% >> %logPath%
echo.

echo Available power schemes:
powercfg /list
echo.
echo Adjusting power settings for performance...
powercfg /s 381b4222-f694-41f0-9685-ff5bb260df2e
if %errorlevel% neq 0 (
    echo Error adjusting power settings at %date% %time% >> %logPath%
echo Error adjusting power settings
) else (
    echo Power settings adjusted for Balanced performance at %date% %time% >> %logPath%
echo Power settings adjusted for Balanced performance
)
echo.




echo Running disk cleanup...
cleanmgr /sagerun:1 > nul 2>&1
echo Disk cleanup completed at %date% %time% >> %logPath%
echo Disk cleanup completed...
echo.

echo Defragmenting hard drive...
defrag C: /O > nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Defragmentation failed at %date% %time% >> %logPath%
echo Error: Defragmentation failed
) else (
    echo Hard drive defragmentation completed at %date% %time% >> %logPath%
echo Hard drive defragmentation completed
)
echo.


echo Checking and repairing system files...
sfc /scannow > nul 2>&1
echo System file check and repair completed at %date% %time% >> %logPath%
echo System file check and repair completed 
echo.

echo Updating system...
dism /online /cleanup-image /restorehealth > nul 2>&1
echo System update completed at %date% %time% >> %logPath%
echo System update completed
echo.


@echo off
echo Lenovo System Update ... at %date% %time% >> %logPath%
echo Lenovo System Update ... 
set "systemUpdateURL=https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.08.02.25.exe"
set "installPath=C:\Program Files (x86)\Lenovo\System Update"
set "downloadPath=%TEMP%\SystemUpdate.exe"

rem Check if Lenovo System Update is already installed
if not exist "%installPath%\tvsu.exe" (
    echo Lenovo System Update is not installed. Installing... at %date% %time% >> %logPath%
    echo Lenovo System Update is not installed. Installing...

    rem Download Lenovo System Update
    powershell -Command "& { Invoke-WebRequest -Uri '%systemUpdateURL%' -OutFile '%downloadPath%' }"

    rem Check if the download was successful
    if not exist "%downloadPath%" (
        echo Failed to download SystemUpdate.exe at %date% %time% >> %logPath%
	echo Failed to download SystemUpdate.exe
        exit /b 1
    )

    rem Request elevated privileges for the installation
    powershell.exe -Command "Start-Process -FilePath '%downloadPath%' -ArgumentList '/SILENT /SUPPRESSMSGBOXES' -Verb RunAs"

    rem Wait for the installation to complete
    timeout /t 10 /nobreak

    rem Clean up the downloaded installer
    del "%downloadPath%"
)

rem Run Lenovo System Update
echo Running Lenovo System Update... at %date% %time% >> %logPath%
echo Running Lenovo System Update... at %date% %time%
cd "%installPath%"
tvsu.exe /CM -search C -action INSTALL -noicon -scheduler -defaultupdates -includerebootpackages 1,3,4 nolicense -exporttowmi > "%UserProfile%\Desktop\Install_Log.txt" 2>&1

echo Lenovo System Update completed at %date% %time% >> %logPath%
echo Lenovo System Update completed at %date% %time% 
 
echo.

@echo off
echo Lenovo Hardware Diagnosis ... at %date% %time% >> %logPath%
echo Lenovo Hardware Diagnosis ... 
set "systemUpdateURL=https://download.lenovo.com/pccbbs/thinkvantage_en/ldiag_4.42.0_windows_x86.exe"
set "installPath=C:\Program Files (x86)\Lenovo\Lenovo Diagnostics Tool"
set "downloadPath=%TEMP%\SystemDiagnosis.exe"

rem Check if Lenovo Hardware Diagnosis is already installed
if not exist "%installPath%\LenovoDiagnosticsCLI.exe" (
    echo Lenovo Hardware Diagnosis is not installed. Installing... at %date% %time% >> %logPath%
    echo Lenovo Hardware Diagnosis is not installed. Installing...

    rem Download Lenovo Hardware Diagnosis
    powershell -Command "& { Invoke-WebRequest -Uri '%systemUpdateURL%' -OutFile '%downloadPath%' }"

    rem Check if the download was successful
    if not exist "%downloadPath%" (
        echo Failed to download SystemDiagnosis.exe at %date% %time% >> %logPath%
	echo Failed to download SystemDiagnosis.exe
        exit /b 1
    )

    rem Request elevated privileges for the installation
    powershell.exe -Command "Start-Process -FilePath '%downloadPath%' -ArgumentList '/SILENT /SUPPRESSMSGBOXES' -Verb RunAs"

    rem Wait for the installation to complete
    timeout /t 40 /nobreak

    rem Clean up the downloaded installer
    del "%downloadPath%"
)

rem Run Lenovo Hardware Diagnosis
set "outputPath=C:\temp\diagnostics_results.txt"

echo Running Lenovo Hardware Diagnosis at %date% %time% >> %logPath%
echo Running Lenovo Hardware Diagnosis at %date% %time% 

cd "%installPath%"
LenovoDiagnosticsCLI.exe -U"e" -o "%outputPath%"

echo Lenovo System Diagnosis completed at %date% %time% >> %logPath%
echo Lenovo System Diagnosis completed at %date% %time%
echo.


echo Checking and updating drivers... at %date% %time% >> %logPath%
echo Checking and updating drivers... at %date% %time%
dism /online /get-drivers > "%UserProfile%\Desktop\Driver_List.txt" 2>&1
pnputil /enum-drivers > "%UserProfile%\Desktop\Installed_Drivers.txt" 2>&1
devcon driverfiles * > "%UserProfile%\Desktop\Driver_Files.txt" 2>&1
echo Driver check and update completed  at %date% %time% >> %logPath%
echo Driver check and update completed  at %date% %time% 
echo.

echo Optimizing startup programs... at %date% %time% >> %logPath%
echo Optimizing startup programs... at %date% %time%
wmic startup get caption,command > nul 2>&1
echo Startup programs optimized at %date% %time% >> %logPath%
echo Startup programs optimized at %date% %time% 
echo.

echo Running Windows Update... at %date% %time% >> %logPath%
echo Running Windows Update... at %date% %time%
powershell -Command "Start-Process wuauclt -ArgumentList '/updatenow' -Verb RunAs" > nul 2>&1
echo Windows Update initiated at %date% %time% >> %logPath%
echo Windows Update initiated at %date% %time%
echo.


echo Rebooting system... at %date% %time% >> %logPath%
echo Rebooting system... at %date% %time%

msg * Do you want to restart the system? Click Yes to restart or No to cancel.

if %errorlevel% equ 6 (
    echo Rebooting system... at %date% %time% >> %logPath%
    echo Rebooting system... at %date% %time%
    shutdown /r /t 3
) else (
    echo Restart cancelled by user.
)















----------------------------
:: This is a commented block
:: Set paths for logs
:: set "DesktopPath=%UserProfile%\Desktop"
:: set "RAMMapPath=%ProgramFiles%\Lenovo\RAMMap.exe"

:: Check if RAMMap is already installed
:: if not exist "%RAMMapPath%" (
::     echo RAMMap not found. Downloading...
    
::     :: Download RAMMap using PowerShell
::     powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.sysinternals.com/files/RAMMap.zip', '%DesktopPath%\RAMMap.zip')"
    
::     :: Check if the download was successful
::     if exist "%DesktopPath%\RAMMap.zip" (
::         :: Extract the downloaded ZIP file
::         powershell -Command "Expand-Archive -Path '%DesktopPath%\RAMMap.zip' -DestinationPath '%ProgramFiles%\Lenovo' -Force"
        
::         :: Check if the extraction was successful
::         if exist "%RAMMapPath%" (
::             :: Clean up the downloaded ZIP file
::             del /f /q "%DesktopPath%\RAMMap.zip"
::             echo RAMMap downloaded and installed successfully.
::         ) else (
::             echo Error extracting RAMMap. Installation failed.
::             exit /b 1
::         )
::     ) else (
::         echo Error downloading RAMMap. Installation failed.
::         exit /b 1
::     )
:: ) else (
::     echo RAMMap found. Skipping download.
:: )

:: /*
:: The following code is commented out
:: Clear standby memory
:: echo Clearing standby memory...
:: "%RAMMapPath%" -emptystandbylist > nul 2>&1

:: Check if clearing standby memory was successful
:: if %errorlevel% neq 0 (
::     echo Error clearing standby memory.
:: ) else (
::     echo Standby memory cleared.
:: )
:: */

:: echo.