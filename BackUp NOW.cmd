@ECHO OFF

SET src=C:\Users\rotter\Genealogy\GeneDB\*.rmtree
SET gdrive=G:\My Drive\
SET dest=%gdrive%\BackUp files\RootsMagic


REM Keep awake until done
start ""  "C:\Program Files\PowerToys\PowerToys.Awake.exe" --use-parent-pid

REM make a copy of RM database
xcopy /Y "%src%" "%dest%"

REM force immediate backup as per email from BackBlaze
"C:\Program Files (x86)\Backblaze\bztransmit.exe" -forcefullfilescan_backup_wait_for_completion

ECHO .
ECHO .
ECHO .
ECHO ==================================
ECHO ==================================
ECHO ===pause 30 sec==========
ECHO ==================================
ECHO ==================================

ECHO  will do "\bin\nircmd.exe" standby


REM   https://www.nirsoft.net/utils/nircmd.html
REM  hibernate  standby  
REM "\bin\nircmd.exe" standby

REM https://learn.microsoft.com/en-us/sysinternals/
REM create a scheduled task to run with admin, run it from command line
REN psshutdown -d -t 10
schtasks /Run /TN "RJO\Put computer to sleep"

