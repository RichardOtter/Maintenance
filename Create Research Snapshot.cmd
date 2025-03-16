@ECHO OFF

REM This script will copy specified files to a flash drive for distribution
REM and optionally to Google Drive and or One Drive for backup


REM Generate time stamp
FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%

REM data source locations
SET GEN_ROOT=C:\Users\rotter\Genealogy
SET GEN_AppInstallerFldr=E:\Users Overflow\ROtter external\Archives\Genealogy\Software\RootsMagic Installers -current
SET GEN_BU=E:\Users Overflow\ROtter external\backup\RootsMagic
SET GEDCOM_FLDR=E:\Users Overflow\ROtter external\Genealogy\Generated Output\GEDCOM
SET README_PATH=C:\Users\rotter\Genealogy\GeneDB\Exhibits\Misc\for Research Snapshot-     ReadMe.txt
SET FILE_LISTING_FLDR=C:\Users\rotter\Genealogy\File Listings

REM data destination locations

SET DEST_GDRIVE=E:\Users Overflow\ROtter external\GoogleDrive\Genealogy\Snapshot
REM DEST_GDRIVE=C:\Users\rotter\My Drive\Genealogy\Snapshot
SET DEST_ONEDRIVE=C:\Users\rotter\OneDrive\Documents\Genealogy archive\Snapshot
SET OUT_FILE_FULL=Exhibits-zip.zip
SET OUT_FILE_PICS=Exhibits_Pics-zip.zip

SET sevenzip_app=%ProgramFiles%\7-zip\7z.exe
SET TEMP_BIG=E:\Users Overflow\ROtter external\temp
SET TEMP_FLDR=%TEMP_BIG%\%TIMESTAMP%

SET MISC_FLDR=Miscellaneous
SET INSTALLER_FLDR=RootsMagic software installer

REM  normal Temp folder is space limited on this machine
MD "%TEMP_FLDR%"


REM First check the main database files
ECHO  STATUS
ECHO .
REM find the latest backup file of main DB
FOR /F "delims=|" %%I IN ('DIR "%GEN_BU%\Otter-Saito*.rmbackup" /B /O:D') DO SET LatestDbMainBKFile=%%I
ECHO Latest backup found  "%GEN_BU%\%LatestDbMainBKFile%"
ECHO  .

REM find the latest backup file of Unlinked persons DB
FOR /F "delims=|" %%J IN ('DIR "%GEN_BU%\Unlinked People*.rmbackup" /B /O:D') DO SET LatestDbUnLinkBKFile=%%J
ECHO Latest backup found  "%GEN_BU%\%LatestDbUnLinkBKFile%"
ECHO  .


REM find the latest GEDCOM file of main DB
FOR /F "delims=|" %%J IN ('DIR "%GEDCOM_FLDR%\Otter-Saito*.ged" /B /O:D') DO SET LatestDbMainGedFile=%%J
ECHO Latest GEDCOM found  "%GEDCOM_FLDR%\%LatestDbMainGedFile%"
ECHO  .
ECHO  .


REM Ask whether to include GEDCOM file as it may be old.
SET /p Include_GEDCOM_answer=Include latest GEDCOM file (Yy/Nn) :?


REM Ask where to copy
ECHO  -
ECHO  -
ECHO  Where to copy to?---
SET /p FlashDrive_answer= Copyy to one or more Flash Drives (Yy/Nn) :?
SET /p GDrive_answer= Copyy to Google Drive (Yy/Nn) :?
SET /p OneDrive_answer= Copyy to One Drive (Yy/Nn) :?
ECHO  -
ECHO  -

REM Set up flash drive if it is a destination
SET ZIP_FILES_CREATED=N

IF /I NOT %FlashDrive_answer%==Y GOTO SKIP_FLASH_DRIVE_1
REM FLASH DRIVE
:FLASH_DRIVE
ECHO Insert NTFS formatted flash drive and determine its drive letter.
PAUSE

SET /p DEST_DR=Enter the leter (only) of the destination drive. (Any drive is safe)  
SET DEST_FLDR=%DEST_DR%:\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO Files are going to "%DEST_FLDR%". Confirm folder before proceeding.
PAUSE

:SKIP_FLASH_DRIVE_1
IF /I %ZIP_FILES_CREATED%==Y GOTO SKIP_CREATE_ZIP_FILES


REM https://sevenzip.osdn.jp/chm/cmdline/
REM https://7ziphelp.com/7zip-command-line

REM create Exhibits_Pics zip file
"%sevenzip_app%" a -bsp0 -mx0 -tzip -r -xr!Audio\ -xr!Misc\ -xr!Sources\  "%TEMP_FLDR%\%OUT_FILE_PICS%"  "%GEN_ROOT%\GeneDB\Exhibits"

REM create Exhibits zip file
"%sevenzip_app%" a -bsp0 -mx0 -tzip -r "%TEMP_FLDR%\%OUT_FILE_FULL%" "%GEN_ROOT%\GeneDB\Exhibits"

REM make the zip files only once
SET ZIP_FILES_CREATED=Y

ECHO Update the Directoy listings file for the entire Genealogy folder
powershell -ExecutionPolicy Bypass -File "C:\Users\rotter\Development\Maintenance\_Create FileListing generator.ps1"

REM find the latest File_Listings file (do this after the new file is generated)
FOR /F "delims=|" %%J IN ('DIR "%FILE_LISTING_FLDR%\File_Listings*.txt" /B /O:D') DO SET LatestFile_Listings=%%J
ECHO Latest File Listings found  "%FILE_LISTING_FLDR%\%LatestFile_Listings%"
ECHO  .




:SKIP_CREATE_ZIP_FILES
IF /I NOT %FlashDrive_answer%==Y GOTO SKIP_FLASH_DRIVE_2
ECHO  -
ECHO  -
ECHO  -
ECHO Copying files to drive %DEST_DR%: 
CALL :SUB_COPY
ECHO  -
ECHO  -
ECHO  -
SET /p AnotherCopy_answer=Another copy on another flash drive (Yy/Nn) :?
IF /I %AnotherCopy_answer%==Y GOTO FLASH_DRIVE



:SKIP_FLASH_DRIVE_2
IF /I NOT %GDrive_answer%==Y GOTO SKIP_GOOGLE_DRIVE
REM GOOGLE DRIVE
REM same copying code as above, but Dest Fldr is changed to google drive (should be subroutine)
SET DEST_FLDR=%DEST_GDRIVE%\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO Files are going to "%DEST_FLDR%".
ECHO  -
ECHO  -
ECHO  -
ECHO Copying files to Google local folder
CALL :SUB_COPY
:SKIP_GOOGLE_DRIVE



IF /I NOT %OneDrive_answer%==Y GOTO SKIP_ONE_DRIVE
REM ONE DRIVE
REM same copying code as above, but Dest Fldr is changed to one drive (should be subroutine)
SET DEST_FLDR=%DEST_ONEDRIVE%\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO Files are going to "%DEST_FLDR%".
ECHO  -
ECHO  -
ECHO  -
ECHO Copying files to One Drive local folder
CALL :SUB_COPY
:SKIP_ONE_DRIVE



ECHO Done copying. Proceed to cleanup of temprary files created in this script ?
PAUSE
ECHO cleanup
RMDIR  "%TEMP_FLDR%" /S /Q

ECHO DONE
PAUSE
EXIT


REM ========================================

:SUB_COPY

ECHO Copying Main database backup file
COPY  "%GEN_BU%\%LatestDbMainBKFile%"     "%DEST_FLDR%"

ECHO Copying Auxiliary database backup files
MD    "%DEST_FLDR%\%MISC_FLDR%"
COPY  "%GEN_BU%\%LatestDbUnLinkBKFile%"   "%DEST_FLDR%\%MISC_FLDR%"

IF /I %Include_GEDCOM_answer%==Y (
ECHO Copying GEDCOM file
COPY  "%GEDCOM_FLDR%\%LatestDbMainGedFile%"    "%DEST_FLDR%\%MISC_FLDR%"
)

ECHO Copying Work Log, SW and Installer files
xcopy "%GEN_ROOT%\GeneDB\Work Logs"     "%DEST_FLDR%\%MISC_FLDR%\Work Logs"   /E /I
xcopy "%GEN_ROOT%\GeneDB\SW"            "%DEST_FLDR%\%MISC_FLDR%\SW"          /E /I
xcopy "%GEN_AppInstallerFldr%\*"        "%DEST_FLDR%\%INSTALLER_FLDR%"        /E /I

ECHO Copying ReadMe file
COPY  "%README_PATH%"                               "%DEST_FLDR%\__ReadMe.txt"
COPY  "%FILE_LISTING_FLDR%\%LatestFile_Listings%"   "%DEST_FLDR%\%MISC_FLDR%"

ECHO Copying Exhibits_Pics zip file
COPY "%TEMP_FLDR%\%OUT_FILE_PICS%"      "%DEST_FLDR%"

ECHO Copying Exhibits zip file
COPY "%TEMP_FLDR%\%OUT_FILE_FULL%"      "%DEST_FLDR%"

EXIT /B

REM ========================================
