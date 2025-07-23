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

timeout /t 30
REM powercfg -hibernate off
REM rundll32.exe powrprof.dll,SetSuspendState Sleep

REM   https://www.nirsoft.net/utils/nircmd.html
REM  hibernate  standby  
"\bin\nircmd.exe" standby


