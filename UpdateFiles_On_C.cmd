
@ECHO OFF
SET USB_DRIVE_LETTER=H
PAUSE  Make sure drive is H
SET FLASH_ROOT=%USB_DRIVE_LETTER%:\GeneDB
SET C_ROOT=C:\Users\rotter\Genealogy\GeneDB


REM  Mirror GeneDB to C drive

robocopy "%FLASH_ROOT%" "%C_ROOT%"  /mir

pause
