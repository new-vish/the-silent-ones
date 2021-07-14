@echo off
setlocal
   set source=
   set target=
   set download_dir=
   set sha256_checksum=
   set ignore_checksum_mismatch=No
   
   :loop
   IF NOT "%1"=="" (
       IF "%~1"=="-source" (
           SET source=%~2
           SHIFT
       )
       IF "%~1"=="-target" (
           SET target=%~2
           SHIFT
       )
       IF "%~1"=="-sha256_checksum" (
           SET sha256_checksum="%~2"
           SHIFT
       )
       IF "%~1"=="-download_dir" (
           SET download_dir=%~2
           SHIFT
       )
       IF "%~1"=="-ignore_checksum_mismatch" (
         set ignore_checksum_mismatch=Yes
       )
       
       SHIFT
       GOTO :loop
   )
   
   if "x" == "%source%x" (
      echo Source file is missing, abandoning!
      goto :EOF
   )
   
   if "x" == "%target%x" (
      echo Target file is missing, abandoning!
      goto :EOF
   )
   
   mkdir %download_dir%
   
   if not exist "%download_dir%" (
      echo could not create\access %download_dir%, abandoning!
   )
   
   echo Source: %source% 
   echo Download Dir: %download_dir%
   echo Target: %target%
   echo SHA256 Checksum: %sha256_checksum%
   echo Ignore Checksum Mismatch: %ignore_checksum_mismatch%
   
   
   
   call :download_verify_sha256_checksum "%source%" "%target%" "%sha256_checksum%" "%ignore_checksum_mismatch%" error
   exit /b %ERRORLEVEL%
   
endlocal   
   

:download_verify_sha256_checksum
setlocal
   set source_file="%~1"
   set target_file="%~2"
   set sha256_checksum=%~3
   set ignore_checksum_mismatch=%~4
   
   call :download_file %source_file% %target_file%
   if %ERRORLEVEL% neq 0 (
      exit /b %ERRORLEVEL%
   )

   call :is_sha256_checksum_valid %target_file% %sha256_checksum%
   set error=%ERRORLEVEL%
   if %error% neq 0 (
      if "%ignore_checksum_mismatch%" == "Yes" (
         set error=0
      ) 
   )
   exit /b %error%

endlocal


:download_file
setlocal
   set source_file="%~1"
   set target_file="%~2"

   
   if not exist "%target_file%" (
      echo getting %source_file% to %target_file%
      powershell -command "iwr -outf %target_file% %source_file%"
   ) else (
      echo %target_file% already exists.
   )
   
   if not exist %target_file% (
      echo could not download %source_file% abandoning..
      exit /b 1
   )
  
goto :EOF
endlocal


:is_sha256_checksum_valid
setlocal
   set target_file="%~1"
   set sha256_checksum=%~2

   echo|set /p="verifying SHA256 checksum for %target_file%... "
   for /F "delims=" %%G in ('certutil -hashfile %target_file% SHA256') do (
      if "%%G" == "%sha256_checksum%" (
         echo verified.
         exit /b 0
         goto :EOF
      )
   )


   echo failed!
   exit /b 1
   
endlocal