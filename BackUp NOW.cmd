REM make a copy of RM database
REM First prevent sleep
REM force immediate backup using BackBlaze
REM restore normal sleep timer,
REM put computer to sleep (hybrid, also creates hibernation file)


SET src=C:\Users\rotter\Genealogy\GeneDB\Otter-Saito.rmtree
SET gdrive=E:\Users Overflow\ROtter external\GoogleDrive
REM SET gdrive=G:\My Drive
SET dest=%gdrive%\BackUp files\RootsMagic\daily latest
xcopy /Y "%src%" "%dest%"


REM https://learn.microsoft.com/en-us/windows/powertoys/awake
REM "C:\Program Files\PowerToys\PowerToys.Awake.exe"  --time-limit=3600

REM force immediate backup as per email from BackBlaze
"C:\Program Files (x86)\Backblaze\bztransmit.exe" -forcefullfilescan_backup_wait_for_completion

REM reset Awake to use previously set options
REM "C:\Program Files\PowerToys\PowerToys.Awake.exe" --use-pt-config



