@echo off
cls
setlocal enabledelayedexpansion

   rem https://www.gtk.org/docs/installations/windows
   set "MY_PATH=%~dp0"
   IF %MY_PATH:~-1%==\ SET MY_PATH=%MY_PATH:~0,-1%
   
   set MSYS2_INSTALL_DIR=
   
   set /a arg_count=0
   
   :loop
   
      IF NOT "%1"=="" (
         set /a arg_count=%arg_count%+1
         IF "%~1"=="-msys2_location" (
            SET MSYS2_INSTALL_DIR=%2
            SHIFT
            SHIFT
            if not exist "!MSYS2_INSTALL_DIR!%bash_relative_path%" (
               goto :setup_msys2
            )
            
            goto :Install
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
   
      set "bash_relative_path=\usr\bin\bash.exe"
      if "x" == "%MSYS2_INSTALL_DIR%x" (
         set MSYS2_INSTALL_DIR=C:\MSYS2
         if exist "!MSYS2_INSTALL_DIR!%bash_relative_path%" (
            goto :Install
         )
         set MSYS2_INSTALL_DIR=%MY_PATH%\..\Programs\MSYS2
         if exist "%MY_PATH%\..\Programs\MSYS2%bash_relative_path%" (
            goto :Install
         )
      )

   :setup_msys2
      if not "x" == "!MSYS2_INSTALL_DIR!x" (      
         echo Installing MSYS2...
         
         set line=
         for /F "delims=" %%G in ('%MY_PATH%\setup_msys2.bat %* -install_dir !MSYS2_INSTALL_DIR!') do (
            set "line=%%G"
            echo !line!
            if "MSYS2 Setup Successful. Install Location: "=="!line:~0,42!" (
               set MSYS2_INSTALL_DIR=!line:~42!
               goto :Install
            )
            if "MSYS2 Setup Successful. Install Location: "=="!line:~1,42!" (
               set MSYS2_INSTALL_DIR=!line:~42!
               goto :Install
            )
         )
         goto :Install
      )
      
      goto :help
   
   :Install
   
      set bash=%MSYS2_INSTALL_DIR%%bash_relative_path% -l -c
      echo bash: %bash%
      if not "x" == "%MSYS2_INSTALL_DIR%x" (
         
         %bash% "echo Y|pacman -S mingw-w64-x86_64-gtk3"
         if 0 neq %ERRORLEVEL% (
            echo Could not install mingw-w64-x86_64-gtk3..
            exit /b %ERRORLEVEL%
         )
         
         %bash% "echo Y|pacman -S mingw-w64-x86_64-glade"
         if 0 neq %ERRORLEVEL% (
            echo Could not install mingw-w64-x86_64-glade..
            exit /b %ERRORLEVEL%
         )

         %bash% "echo Y|pacman -S mingw-w64-x86_64-python3-gobject"
         if 0 neq %ERRORLEVEL% (
            echo Could not install mingw-w64-x86_64-python3-gobject..
            exit /b %ERRORLEVEL%
         )
         
      )
      
      
      

      
      goto :EOF

   :help
   
      echo setup_gtk.bat [-msys2_location ^<msys2 install location^>] or [-installer ^<installer_url or local path for msys2^>] [-checksum ^<msys2 sha256 checksum^>] [-download_dir ^<target download directory^>] [-ignore_checksum_mismatch]
      echo     -msys2_location: msys2 install location defalut: %MY_PATH%\..\Programs\MSYS2 or C:\MSYS2      
      echo     --- OR ---
      echo     -installer : default: http://repo.msys2.org/distrib/msys2-x86_64-latest.exe
      echo     -checksum: default: 2e9bd59980aa0aa9248e5f0ad0ef26b0ac10adae7c6d31509762069bb388e600
      echo     -download_dir: default: %MY_PATH%\Downloads
      echo     -ignore_checksum_mismatch: default: No
      echo     -install_dir: default: %MY_PATH%\..\Programs\MSYS2

      
               
      goto :EOF
   
endlocal