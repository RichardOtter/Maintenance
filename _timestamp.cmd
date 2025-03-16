@ECHO OFF
REM Timestamp in cmd script

FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A

set DATESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%
echo YYYY-MM-DD             %DATESTAMP%

set TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%-%B:~10,2%-%B:~12,2%
echo YYYY-MM-DD-HH-MM-SS    %TIMESTAMP%

set TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%
echo YYYY-MM-DD-HHMM        %TIMESTAMP%

set TIMESTAMP=%B:~0,4%-%B:~4,2%-%B:~6,2%-%B:~8,2%%B:~10,2%%B:~12,2%
echo YYYY-MM-DD-HHMMSS       %TIMESTAMP%

pause
