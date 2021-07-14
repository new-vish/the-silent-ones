@echo off
cls
setlocal
   rem https://www.msys2.org/
   set "MY_PATH=%~dp0"
   IF %MY_PATH:~-1%==\ SET MY_PATH=%MY_PATH:~0,-1%
   rem set "download_dir=%~1"
   set "download_dir=%MY_PATH%\Downloads"
   set msys2_installer=http://repo.msys2.org/distrib/msys2-x86_64-latest.exe
   set msys2_sha256_checksum=2e9bd59980aa0aa9248e5f0ad0ef26b0ac10adae7c6d31509762069bb388e600
   set target_file=
   set ignore_checksum_mismatch=0
   set install_dir=%MY_PATH%\..\Programs\MSYS2
   
   :loop
   IF NOT "%1"=="" (
       IF "%~1"=="-installer" (
           SET msys2_installer=%2
           SHIFT
       )
       IF "%~1"=="-checksum" (
           SET msys2_sha256_checksum=%2
           SHIFT
       )
       IF "%~1"=="-download_dir" (
           SET download_dir=%2
           SHIFT
       )
       IF "%~1"=="-ignore_checksum_mismatch" (
         set ignore_checksum_mismatch=1
       )
       IF "%~1"=="-install_dir" (
         set install_dir=%~2
       )
       
       if "%~1"=="-h" (
         goto :help
       )
       
       if "%~1"=="--help" (
         goto :help
       )
       
       if "%~1"=="/?" (
         goto :help
       )
       
       if "%~1"=="-?" (
         goto :help
       )
       
       SHIFT
       GOTO :loop
   )
   
   FOR %%i IN ("%msys2_installer%") DO (
      set target_file=%download_dir%\%%~ni%%~xi
   )
   
   
   call %MY_PATH%\download_verify.bat -source %msys2_installer% -download_dir %download_dir% -sha256_checksum %msys2_sha256_checksum% -target "%target_file%" %ignore_checksum_mismatch% 
   set error=%ERRORLEVEL%
   if %error% neq 0 (
      echo Could not download\verify msys2. Check output.
      exit /b %error%
   )
   
   %target_file% --script "%MY_PATH%\auto-install-msys2.js" --verbose InstallDir="%install_dir%"
   set error=%ERRORLEVEL%
   if %error% neq 0 (
      echo Could not setup msys2. Check output.
      exit /b %error%
   )
   
   echo MSYS2 Setup Successful. Install Location: %install_dir%
   
   exit /b 0
   
:help
   
   echo setup_msys2.bat [-installer ^<installer_url or local path^>] [-checksum ^<sha256 checksum^>] [-download_dir ^<target download directory^>] [-ignore_checksum_mismatch]
   echo     -installer : default: http://repo.msys2.org/distrib/msys2-x86_64-latest.exe
   echo     -checksum: default: 2e9bd59980aa0aa9248e5f0ad0ef26b0ac10adae7c6d31509762069bb388e600
   echo     -download_dir: default: %MY_PATH%\Downloads
   echo     -ignore_checksum_mismatch: default: No
   echo     -install_dir: default: %MY_PATH%\..\Programs\MSYS2
            
   goto :EOF

endlocal