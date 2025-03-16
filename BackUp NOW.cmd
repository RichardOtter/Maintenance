
SET src=C:\Users\rotter\Genealogy\GeneDB\*.rmtree
SET gdrive=E:\Users Overflow\ROtter external\GoogleDrive
SET dest=%gdrive%\BackUp files\RootsMagic\daily latest

REM make a copy of RM database

xcopy /Y "%src%" "%dest%"


REM force immediate backup as per email from BackBlaze
"C:\Program Files (x86)\Backblaze\bztransmit.exe" -forcefullfilescan_backup_wait_for_completion



