
set SRC_ROOT=%USERPROFILE%\Genealogy\GeneDB\RM_LinkedFiles
set DEST_GITREPO=%USERPROFILE%\dev\Genealogy\repo Standard-forms-for-genealogy"


cd %DEST_GITREPO%
mklink /H "Standard Forms- how to use.md" "%SRC_ROOT%\Misc\Data Entry\Standard Forms- how to use.md"

md Germany
cd Germany
mklink /J Birth     "%SRC_ROOT%\Sources\Birth\Germany\_Standard forms"
mklink /J Marriage  "%SRC_ROOT%\Sources\Marriage\Germany\_Standard forms"

cd %DEST_GITREPO%

md USA
cd USA
mklink /J Birth                   "%SRC_ROOT%\Sources\Birth\USA\_Standard forms"
mklink /J Death                   "%SRC_ROOT%\Sources\Death\USA\_Standard forms"
mklink /J Census                  "%SRC_ROOT%\Sources\Census\_Standard forms"
mklink /J Immigration            "%SRC_ROOT%\Sources\Passenger List\_Standard forms"
mklink /J Military                "%SRC_ROOT%\Sources\Military\USA\_Standard forms"
mklink /J Naturalization          "%SRC_ROOT%\Sources\Citizenship\_Standard forms"
mklink /J "Passport Application"  "%SRC_ROOT%\Sources\Passport Application\USA\_Standard forms"
mklink /J Military                "%SRC_ROOT%\Sources\Military\Germany\Bayern\_Standard forms"
mklink /J "Social Security"       "%SRC_ROOT%\Sources\US Social Security\_Standard forms"

