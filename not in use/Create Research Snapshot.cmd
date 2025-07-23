@ECHO OFF

REM This script will copy specified files to a flash drive for distribution
REM and optionally to Google Drive and or One Drive for backup


REM Generate time stamp
FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%

REM data source locations
SET GEN_ROOT=%USERPROFILE%\Genealogy
SET EXT_ROOT=E:\Users Overflow\ROtter external

SET MEDIA_FLDR_PATH=%GEN_ROOT%\GeneDB\RM_LinkedFiles
SET GEN_APPINST_FLDR_PATH=%EXT_ROOT%\Archives\Genealogy\Software\RootsMagic Installers -current
SET GEN_BU_PATH=%EXT_ROOT%\backup\RootsMagic
SET GEDCOM_FLDR_PATH=%EXT_ROOT%\Genealogy\Generated Output\GEDCOM
SET FILE_LISTING_FLDR_PATH=%GEN_ROOT%\File Listings
SET README_PATH=%MEDIA_FLDR_PATH%\UNREF\for Research Snapshot--ReadMe.txt

REM data destination locations

REM Streaming google drive
SET DEST_GDRIVE=G:\My Drive\Genealogy\Snapshot
		REM Mirroring google drive
		REM DEST_GDRIVE=%USERPROFILE%\My Drive\Genealogy\Snapshot
SET DEST_ONEDRIVE=%USERPROFILE%\OneDrive\Documents\Genealogy archive\Snapshot
SET OUT_FILE_FULL=RM_LinkedFiles-zip.zip
SET OUT_FILE_PICS=RM_LinkedFiles_Pics-zip.zip

SET sevenzip_app=%ProgramFiles%\7-zip\7z.exe
SET TEMP_BIG=%EXT_ROOT%\temp
SET TEMP_FLDR=%TEMP_BIG%\%TIMESTAMP%

SET MISC_FLDR=Miscellaneous
SET INSTALLER_FLDR=RootsMagic software installer

REM  normal Temp folder is space limited on this machine
MD "%TEMP_FLDR%"


REM First check the main database files
ECHO  STATUS
ECHO .
REM find the latest backup file of main DB
FOR /F "delims=|" %%I IN ('DIR "%GEN_BU_PATH%\Otter-Saito*.rmbackup" /B /O:D') DO SET LatestDbMainBKFile=%%I
ECHO Latest backup found  "%GEN_BU_PATH%\%LatestDbMainBKFile%"
ECHO  .

REM find the latest backup file of Unlinked persons DB
FOR /F "delims=|" %%J IN ('DIR "%GEN_BU_PATH%\Unlinked People*.rmbackup" /B /O:D') DO SET LatestDbUnLinkBKFile=%%J
ECHO Latest backup found  "%GEN_BU_PATH%\%LatestDbUnLinkBKFile%"
ECHO  .


REM find the latest GEDCOM file of main DB
FOR /F "delims=|" %%J IN ('DIR "%GEDCOM_FLDR_PATH%\Otter-Saito*.ged" /B /O:D') DO SET LatestDbMainGedFile=%%J
ECHO Latest GEDCOM found  "%GEDCOM_FLDR_PATH%\%LatestDbMainGedFile%"
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

SET /p DEST_DR=Enter the leter (1 character only) of the destination drive. (Any drive is safe)  
SET DEST_FLDR=%DEST_DR%:\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO Files are going to "%DEST_FLDR%". Confirm folder before proceeding.
PAUSE

:SKIP_FLASH_DRIVE_1
IF /I %ZIP_FILES_CREATED%==Y GOTO SKIP_CREATE_ZIP_FILES


REM https://sevenzip.osdn.jp/chm/cmdline/
REM https://7ziphelp.com/7zip-command-line

REM create RM_LinkedFiles_Pics zip file
"%sevenzip_app%" a -bsp0 -mx0 -tzip -r -xr!Audio\ -xr!Misc\ -xr!Sources\  -xr!TODO\ "%TEMP_FLDR%\%OUT_FILE_PICS%"  "%MEDIA_FLDR_PATH%"

REM create RM_LinkedFiles_Full zip file
"%sevenzip_app%" a -bsp0 -mx0 -tzip -r "%TEMP_FLDR%\%OUT_FILE_FULL%" "%MEDIA_FLDR_PATH%"

REM make the zip files only once
SET ZIP_FILES_CREATED=Y
ECHO .
ECHO Update the Directoy listings file for the entire Genealogy folder
pwsh -ExecutionPolicy Bypass -File "%USERPROFILE%\Development\Maintenance\Create FileListing.ps1"

REM find the latest File_Listings file (do this after the new file is generated)
FOR /F "delims=|" %%J IN ('DIR "%FILE_LISTING_FLDR_PATH%\File_Listings*.txt" /B /O:D') DO SET LatestFile_Listings=%%J
ECHO Latest File Listings found  "%FILE_LISTING_FLDR_PATH%\%LatestFile_Listings%"
ECHO .




:SKIP_CREATE_ZIP_FILES
IF /I NOT %FlashDrive_answer%==Y GOTO SKIP_FLASH_DRIVE_2
ECHO .
ECHO .
ECHO .
ECHO Copying files to drive %DEST_DR%: 
CALL :SUB_COPY
ECHO .
ECHO .
ECHO .
SET /p AnotherCopy_answer=Another copy on another flash drive (Yy/Nn) :?
IF /I %AnotherCopy_answer%==Y GOTO FLASH_DRIVE



:SKIP_FLASH_DRIVE_2
IF /I NOT %GDrive_answer%==Y GOTO SKIP_GOOGLE_DRIVE
REM GOOGLE DRIVE
REM same copying code as above, but Dest Fldr is changed to google drive (should be subroutine)
SET DEST_FLDR=%DEST_GDRIVE%\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO .
ECHO .
ECHO .
ECHO Files are going to "%DEST_FLDR%".
ECHO Copying files to Google local folder
CALL :SUB_COPY
:SKIP_GOOGLE_DRIVE



IF /I NOT %OneDrive_answer%==Y GOTO SKIP_ONE_DRIVE
REM ONE DRIVE
REM same copying code as above, but Dest Fldr is changed to one drive (should be subroutine)
SET DEST_FLDR=%DEST_ONEDRIVE%\%TIMESTAMP%
REM create the destination folder
MD "%DEST_FLDR%" 2>NUL
ECHO .
ECHO .
ECHO .
ECHO Files are going to "%DEST_FLDR%".
ECHO Copying files to One Drive local folder
CALL :SUB_COPY
:SKIP_ONE_DRIVE


ECHO .
ECHO .
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
COPY  "%GEN_BU_PATH%\%LatestDbMainBKFile%"     "%DEST_FLDR%"

ECHO Copying Auxiliary database backup files
MD    "%DEST_FLDR%\%MISC_FLDR%"
COPY  "%GEN_BU_PATH%\%LatestDbUnLinkBKFile%"   "%DEST_FLDR%\%MISC_FLDR%"

IF /I %Include_GEDCOM_answer%==Y (
ECHO Copying GEDCOM file
COPY  "%GEDCOM_FLDR_PATH%\%LatestDbMainGedFile%"    "%DEST_FLDR%\%MISC_FLDR%"
)

ECHO Copying Work Log, SW and Installer files
xcopy "%GEN_ROOT%\GeneDB\Work Logs"     "%DEST_FLDR%\%MISC_FLDR%\Work Logs"   /E /I
xcopy "%GEN_ROOT%\GeneDB\SW"            "%DEST_FLDR%\%MISC_FLDR%\SW"          /E /I
xcopy "%GEN_APPINST_FLDR_PATH%\*"        "%DEST_FLDR%\%INSTALLER_FLDR%"        /E /I

ECHO Copying ReadMe file
COPY  "%README_PATH%"                   "%DEST_FLDR%\__ReadMe.txt"

COPY  "%FILE_LISTING_FLDR_PATH%\%LatestFile_Listings%"   "%DEST_FLDR%\%MISC_FLDR%"

ECHO Copying RM_LinkedFiles_Pics zip file
COPY "%TEMP_FLDR%\%OUT_FILE_PICS%"      "%DEST_FLDR%"

ECHO Copying RM_LinkedFiles_Full zip file
COPY "%TEMP_FLDR%\%OUT_FILE_FULL%"      "%DEST_FLDR%"

EXIT /B

REM ========================================
