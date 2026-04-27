
PAUSE DANGER be sure this is wanted

set SRC_ROOT=%USERPROFILE%\Genealogy\GeneDB\RM_LinkedFiles
set DEST_GITREPO=%USERPROFILE%\dev\Genealogy\repo Standard-forms-for-genealogy

REM The "C:\Users\rotter\dev\Genealogy\repo Standard-forms-for-genealogy" folder
REM corresponds to github:
REM https://github.com/RichardOtter/Standard-forms-for-genealogy.git


REM To reconstruct local git repo
REM rename any existing repo folder with the name we are using
REM clone the repo from github
REM delete the folders & files that should be gotten from elsewhere on the local disk
REM create the junctions in the repo folder that point to real locations of folders

REM Files in the repo folder (not linked in from other places-
REM \LICENSE
REM \README.md
REM \CONTRIBUTING.md
REM \CONTRIBUTORS.md
REM \.gitignore
REM \.vscrof

if exist "%DEST_GITREPO%" pause "'%DEST_GITREPO%' already exists, exit" && exit

git clone https://github.com/RichardOtter/Standard-forms-for-genealogy.git "%DEST_GITREPO%"

cd %DEST_GITREPO%"

del      "%DEST_GITREPO%\Standard Forms- how to use.md"
rmdir /s "%DEST_GITREPO%\USA"
rmdir /s "%DEST_GITREPO%\Germany"
rmdir /s "%DEST_GITREPO%\Transcription projects"


REM repo root folder

REM files
cd %DEST_GITREPO%
mklink /H "Standard Forms- how to use.md" "%SRC_ROOT%\Misc\Data Entry\Standard Forms- how to use.md"

REM folders
cd %DEST_GITREPO%
md "Transcription projects"
cd "Transcription projects"
mklink /j "Lohr civil marriage records index" "%SRC_ROOT%\Sources\Marriage\Germany\Lohr am Main\Transcription project -Lohr civil marriage records index"

cd %DEST_GITREPO%
md Germany
cd Germany
mklink /J Birth     "%SRC_ROOT%\Sources\Birth\Germany\_Standard forms"
mklink /J Marriage  "%SRC_ROOT%\Sources\Marriage\Germany\_Standard forms"
mklink /J Military  "%SRC_ROOT%\Sources\Military\Germany\Bayern\_Standard forms"


cd %DEST_GITREPO%

md USA
cd USA
mklink /J Birth                   "%SRC_ROOT%\Sources\Birth\USA\_Standard forms"
mklink /J Death                   "%SRC_ROOT%\Sources\Death\USA\_Standard forms"
mklink /J Census                  "%SRC_ROOT%\Sources\Census\_Standard forms"
mklink /J Immigration             "%SRC_ROOT%\Sources\Passenger List\_Standard forms"
mklink /J Military                "%SRC_ROOT%\Sources\Military\USA\_Standard forms"
mklink /J Naturalization          "%SRC_ROOT%\Sources\Citizenship\_Standard forms"
mklink /J "Passport Application"  "%SRC_ROOT%\Sources\Passport Application\USA\_Standard forms"
mklink /J "Social Security"       "%SRC_ROOT%\Sources\US Social Security\_Standard forms"

REM  check the repo history etc. Confirm OK
REM move .git folder to 