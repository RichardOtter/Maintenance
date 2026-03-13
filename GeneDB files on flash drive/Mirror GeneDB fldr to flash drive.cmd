REM  Mirror GenDB
REM robocopy mir option will not change any files in the source folder (left argument)
REM  https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

@ECHO OFF

REM Generate time stamp
FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%


SET LOG_LEVEL=RUN
rem LOG_ONLY
 
IF %LOG_LEVEL%==RUN (
  ECHO This run will run the mirror commands. Control C to abort
  PAUSE
) 
IF %LOG_LEVEL%==LOG_ONLY (
  ECHO This run will only LOG what would be done
  PAUSE
) 
ECHO Insert NTFS formatted flash drive and determine its drive letter.
PAUSE
SET /p DEST_DR=Enter the leter (only) of the destination drive. (Any drive is safe)


SET LOG_FLDR=%DEST_DR%:\

SET LOG_FILE_PATH=%LOG_FLDR%\SynchLog-%TIMESTAMP%.txt

SET DEST_FLDR=%DEST_DR%:\MIRROR

SET RC_COMMON_OPT= /mir /mt /z /unicode /tee /log+:"%LOG_FILE_PATH%"

if %LOG_LEVEL%==LOG_ONLY (
  SET RC_OPT_LONGONLY= /L
) ELSE (
  SET "RC_OPT_LONGONLY="
)

REM Keep awake until done
"C:\Program Files\PowerToys\PowerToys.Awake.exe" --use-parent-pid

robocopy "%USERPROFILE%\Genealogy\GeneDB"       "%DEST_FLDR%\rotter\Genealogy\GeneDB"     %RC_OPT_LONGONLY% %RC_COMMON_OPT% /xd ".git" 

pause

