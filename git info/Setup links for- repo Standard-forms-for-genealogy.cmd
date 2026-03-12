
set SRC_ROOT=%USERPROFILE%\Genealogy\GeneDB\RM_LinkedFiles\Sources
set DEST_GITREPO=%USERPROFILE%\Genealogy\repo Standard-forms-for-genealogy

cd %DEST_GITREPO%
md Germany
cd Germany
mklink /J Birth     "%SRC_ROOT%\Birth\Germany\_Standard forms"
mklink /J Marriage  "%SRC_ROOT%\Marriage\Germany\_Standard forms"

cd %DEST_GITREPO%
md USA
cd USA
mklink /J Birth                   "%SRC_ROOT%\Birth\USA\_Standard forms"
mklink /J Census                  "%SRC_ROOT%\Census\_Standard forms"
mklink /J Immirgration            "%SRC_ROOT%\Passenger List\_Standard forms"
mklink /J Military                "%SRC_ROOT%\Military\USA\_Standard forms"
mklink /J Naturalization          "%SRC_ROOT%\Citizenship\_Standard forms"
mklink /J "Passport Application"  "%SRC_ROOT%\Passport Application\USA\_Standard forms"
mklink /J Military                "%SRC_ROOT%\Military\Germany\Bayern\_Standard forms"

