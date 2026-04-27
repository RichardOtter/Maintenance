import sys
from pathlib import Path
sys.path.append(str(Path.resolve(Path(__file__).resolve().parent / '../../repo Genealogy-scripts/RMpy package')))

import RMpy.common as RMc       # noqa #type: ignore
import os
import subprocess
import shutil

# ===================================================DIV60==
def main():

    RMc.pause_with_message("DANGER be sure this is wanted")

    home_fldr = Path(os.getenv('USERPROFILE'))

    RM_linked_files_root = home_fldr / r"Genealogy\GeneDB\RM_LinkedFiles"
    repo_fldr         = home_fldr / r"dev\Genealogy\repo Standard-forms-for-genealogy"

    # repo_fldr= home_fldr / r"dev\Genealogy\_workarea\test repo"


    # The "C:\Users\rotter\dev\Genealogy\repo Standard-forms-for-genealogy" folder
    # corresponds to github:
    # https://github.com/RichardOtter/Standard-forms-for-genealogy.git


    # To reconstruct local git repo
    # rename any existing repo folder with the name we are using
    # clone the repo from github
    # delete the folders & files that should be gotten from elsewhere on the local disk
    # create the junctions in the repo folder that point to real locations of folders

    # Files in the repo folder (not linked in from other places-
    # \LICENSE
    # \README.md
    # \CONTRIBUTING.md
    # \CONTRIBUTORS.md
    # \.gitignore
    # \.vscrof

    if repo_fldr.exists():
         RMc.pause_with_message (F"{repo_fldr} already exists, exiting")
         sys.exit(1)

    subprocess.run(["git", "clone", 
                    "https://github.com/RichardOtter/Standard-forms-for-genealogy.git", 
                    str(repo_fldr)])


#   REM files
    (repo_fldr / r"Standard Forms- how to use.md").unlink()
    subprocess.run(["mklink", r"/H"
                    , repo_fldr / r"Standard Forms- how to use.md"
                    , RM_linked_files_root / r"Misc\Data Entry\Standard Forms- how to use.md"]
                    , shell=True)


#   REM folders

    TP_fldr = repo_fldr / "Transcription projects"
    shutil.rmtree(repo_fldr / TP_fldr, ignore_errors=True)
    TP_fldr.mkdir()
    subprocess.run(["mklink", r"/J"
                    , TP_fldr / r"Lohr civil marriage records index"
                    , RM_linked_files_root / r"Sources\Marriage\Germany\Lohr am Main\Transcription project -Lohr civil marriage records index"]
                    , shell=True)
#               
    Germany_fldr = repo_fldr / "Germany"
    shutil.rmtree(repo_fldr / Germany_fldr, ignore_errors=True)
    Germany_fldr.mkdir()
    subprocess.run(["mklink", r"/J"
                    , Germany_fldr / r"Birth"
                    , RM_linked_files_root / r"Sources\Birth\Germany\_Standard forms"]
                    , shell=True)
    subprocess.run(["mklink", r"/J"
                    , Germany_fldr / r"Marriage"
                    , RM_linked_files_root / r"Sources\Marriage\Germany\_Standard forms"]
                    , shell=True)
    subprocess.run(["mklink", r"/J"
                    , Germany_fldr / r"Military"
                    , RM_linked_files_root / r"Sources\Military\Germany\Bayern\_Standard forms"]
                    , shell=True)


    US_fldr = repo_fldr / "USA"
    shutil.rmtree(repo_fldr / US_fldr, ignore_errors=True)
    US_fldr.mkdir()
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Birth"
                , RM_linked_files_root / r"Sources\Birth\USA\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Death"
                , RM_linked_files_root / r"Sources\Death\USA\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Census"
                , RM_linked_files_root / r"Sources\Census\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Immigration"
                , RM_linked_files_root / r"Sources\Passenger List\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Military"
                , RM_linked_files_root / r"Sources\Military\USA\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Naturalization"
                , RM_linked_files_root / r"Sources\Citizenship\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Passport Application"
                , RM_linked_files_root / r"Sources\Passport Application\USA\_Standard forms"]
                , shell=True)
    subprocess.run(["mklink", r"/J"
                , US_fldr / r"Social Security"
                , RM_linked_files_root / r"Sources\US Social Security\_Standard forms"]
                , shell=True)

    #  check the repo history etc. Confirm OK

    #  move .git folder to 


# ===================================================DIV60==
# Call the "main" function
if __name__ == '__main__':
    main()

# ===================================================DIV60==
