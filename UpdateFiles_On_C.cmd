
@ECHO OFF
SET USB_DRIVE_LETTER=H
PAUSE  Make sure drive is H
SET FLASH_ROOT=%USB_DRIVE_LETTER%:\GeneDB
SET C_ROOT=C:\Users\rotter\Genealogy\GeneDB
SET LOG_FLDR=C:\Users\rotter\Genealogy

REM Generate time stamp
FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%

SET LOG_FILE_PATH=%LOG_FLDR%\SynchLog-%TIMESTAMP%.txt

REM  Mirror GeneDB to C drive

REM  https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy


REM /L is list only. No actual changes

robocopy "%FLASH_ROOT%" "%C_ROOT%"   /L /mir /unicode /tee /log:"%LOG_FILE_PATH%"

pause
