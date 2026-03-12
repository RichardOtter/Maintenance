import os
import shutil
from datetime import datetime
from pathlib import Path
import subprocess
from wakepy import keep     # https://github.com/fohrloop/wakepy/blob/main/README.md

# ===================================================DIV60==
def main():
    # Timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d-%H%M%S")

    # Data source locations
    userprofile = os.environ['USERPROFILE']
    gen_root = Path(userprofile) / "Genealogy"
    ext_root = Path(r"E:\Users Overflow\ROtter external")

    gedcom_fldr_path = ext_root / r"Genealogy\Generated Output\GEDCOM"

    # Data destination locations
    dest_gdrive = Path(r"G:\My Drive\Genealogy\Genealogy Snapshots")
    dest_onedrive = Path(userprofile) / r"OneDrive\Documents\Genealogy archive\Genealogy Snapshots"
    out_file_full = "RM_LinkedFiles-All.zip"
    out_file_pics = "RM_LinkedFiles_PicsOnly.zip"
    sevenzip_app = Path(os.environ['ProgramFiles']) / r"7-zip\7z.exe"
    temp_big = ext_root / "temp"
    temp_fldr = temp_big / timestamp

    misc_fldr = "Miscellaneous"
    installer_fldr = "RootsMagic software installer"
    GEDCOM_name_latest = "Otter-Saito (latest) - Hardlink.ged"

    # Find latest files
    latest_db_main_ged = get_latest_file(gedcom_fldr_path, "Otter-Saito*.ged")

    gedcom_latest_path = gedcom_fldr_path / GEDCOM_name_latest

    # delete the link if it already exists
    gedcom_latest_path.unlink(missing_ok=True)

    os.link(latest_db_min_ged, gedcom_latest_path)


# ===================================================DIV60==
# Call the "main" function
if __name__ == '__main__':
    main()

# ===================================================DIV60==
