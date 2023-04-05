@echo off
rem "compressTIFS.bat"
rem >> compressTIFS.bat directory_input [directory_output] [-r]

rem Loop over folder with .tifs and compress files either in place (default) or to a new folder (keeping the folder structure, if recursing)

rem USAGE examples:
rem 1) Default
rem 	compressTIFS.bat C:\data 
rem 2) In place with recursion to subdirs
rem 	compressTIFS.bat C:\data "" -r
rem 3) To output dir with recursion to subdirs
rem 	compressTIFS.bat C:\data C:\data_compressed -r

rem DEPENDENCIES:
rem 1) GDAL - the command GDAL_TRANSLATE must be found on PATH
rem		this can be achieved by running this bat file within the OSGeo4W shell
rem		or manually adding GDAL to PATH

rem author: Hannes Horneber
rem v2023.04
rem based on this script: https://gist.github.com/percursoaleatorio/5293340

echo -------------------------
echo Start Batch TIF Compression
echo Processing directory: %1

if "%~1" == "" goto errorInput
if not exist "%1" goto errorDir

set inplace=false
set recurse=false
if "%~2" == "-r" (
    set recurse=true
) else (
    if "%~2" == "" (
        echo Output dir not specified... compressing in place using temp files
        set inplace=true
    ) else (
        echo Output directory: "%~2"
        if not exist "%~2" (
            mkdir "%~2"
            echo Output dir doesn't exist ... created.
        )
    )
)

if "%~3" == "-r" (
    echo Recursive processing is enabled
    set recurse=true
)

echo -------------------------

rem define gdal command. can also be used for other commands (here we only compress)
set gdal_cmd=gdal_translate -co "COMPRESS=DEFLATE"

if %recurse%==true (
  echo Processing directory recursively
  for /r "%1" %%i in (*.tif) do (
	setlocal enableDelayedExpansion
	set "file=%%i"
	if "!file:~-4!" == ".tif" (
	  rem get relative path and filename without extension .tif
	  set "rel_fname=!file:%~1=!"
	  set "rel_fname=!rel_fname:~0,-4!"
	  rem get filename without extension
	  set "fname=%%~ni"
	  set "outdir=%~2!folder!"
	  if not exist "!outdir!" mkdir "!outdir!"
	  echo Processing %%i
	  if %inplace%==true (
		%gdal_cmd% "%%i" "%1!rel_fname!_temp.tif"
		echo Deleting temp file and renaming.
		del "%%i"
		echo ren "%1!rel_fname!_temp.tif" "!fname!.tif"
		ren	"%1!rel_fname!_temp.tif" "!fname!.tif"
	  ) else (
		if exist "!outdir!\!fname!.tif" (
		  echo WARNING Output file "!outdir!\!fname!.tif" already exists... skipping.
		) else (
		  %gdal_cmd% "%%i" "!outdir!\!fname!.tif"
		)
	  )
	  endlocal
	)
  )
) else (
  echo Processing directory non-recursively
  for %%i in ("%~1\*.tif") do (
	setlocal enableDelayedExpansion
	set "fname=%%~ni"
	echo Processing %%i
	if %inplace%==true (
	  %gdal_cmd% "%%i" "%~1\!fname!_temp.tif"
	  echo Deleting temp file and renaming.
	  del "%%i"
	  echo ren "%~1\!fname!_temp.tif" "!fname!.tif"
	  ren "%~1\!fname!_temp.tif" "!fname!.tif"
	) else (
	  if exist "%~2\!fname!.tif" (
		echo WARNING Output file "%~2\!fname!.tif" already exists... skipping.
	  ) else (
		%gdal_cmd% "%%i" "%~2\!fname!.tif"
	  )
	)
	endlocal
  )
)

goto :end

:errorDir
echo ERROR Input directory doesn't exist... exiting.
goto :end
:errorInput
echo ERROR Input directory isn't specified ... exiting.
goto :end
:end
echo -------------------------
