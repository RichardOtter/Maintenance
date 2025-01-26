REM  Mirror GeneDB to flash drive- exclude git.
PAUSE Make sure drive is H

robocopy "C:\Users\rotter\Genealogy\GeneDB" "H:\GeneDB" /mir /xd .git

pause
