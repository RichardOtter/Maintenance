REM  Mirror several large folders to the 2TB SSD
REM robocopy mir option will not change any files in the source folder (left argument)


REM Generate time stamp
FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%

pause run as admin

@ECHO OFF
ECHO Insert NTFS formatted flash drive and determine its drive letter.
PAUSE

SET /p DEST_DR=Enter the leter (only) of the destination drive. (Any drive is safe)

SET DEST_FLDR=%DEST_DR%:\MIRROR

SET EXT_FLDR=E:\Users Overflow\ROtter external


robocopy "%USERPROFILE%\Genealogy"   "%DEST_FLDR%\rotter\Genealogy"    /mir /mt /z /xd ".git" 
robocopy "%USERPROFILE%\Development" "%DEST_FLDR%\rotter\Development"  /mir /mt /z /xd ".git" 
robocopy "%USERPROFILE%\Documents"   "%DEST_FLDR%\rotter\Documents"    /mir /mt /z /xd ".git" 
robocopy "%USERPROFILE%\Finances"    "%DEST_FLDR%\rotter\Finances"     /mir /mt /z
robocopy "%USERPROFILE%\Desktop"     "%DEST_FLDR%\rotter\Desktop"      /mir /mt /z /xd ".git" 
robocopy "%USERPROFILE%\Downloads"   "%DEST_FLDR%\rotter\Downloads"    /mir /mt /z
robocopy "%USERPROFILE%\Pictures"    "%DEST_FLDR%\rotter\Pictures"     /mir /mt /z
robocopy "%USERPROFILE%\Music"       "%DEST_FLDR%\rotter\Music"        /mir /mt /z 
robocopy "%USERPROFILE%\Test"        "%DEST_FLDR%\rotter\Test"         /mir /mt /z /xd ".git" 

robocopy "%EXT_FLDR%\External Documents" "%DEST_FLDR%\External Documents" /mir /mt /z
robocopy "%EXT_FLDR%\git repos"          "%DEST_FLDR%\git repos"          /mir /mt /z

robocopy "E:\Shared"                      "%DEST_FLDR%\Shared"              /mir /mt /z
robocopy "F:\WindowsImageBackup"          "%DEST_FLDR%\WindowsImageBackup"  /mir /mt /z


pause

