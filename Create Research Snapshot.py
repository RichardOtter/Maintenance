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

    media_fldr_path = gen_root / r"GeneDB\RM_LinkedFiles"
    gen_appinst_fldr_path = ext_root / r"Genealogy\Archives\Software\RootsMagic Installers -current"
    gen_bu_path = ext_root / r"backup\RootsMagic"
    gedcom_fldr_path = ext_root / r"Genealogy\Generated Output\GEDCOM"
    file_listing_fldr_path = ext_root / r"Genealogy\Generated Output\File listings"
    HASH_listing_fldr_path = ext_root / r"Genealogy\Generated Output\External files hash listings"
    readme_path = media_fldr_path / r"Misc\for Research Snapshot--ReadMe.txt"

    # Data destination locations
    dest_gdrive = Path(r"G:\My Drive\Genealogy\Snapshots")
    dest_onedrive = Path(userprofile) / r"OneDrive\Documents\Genealogy archive\Snapshots"
    out_file_full = "RM_LinkedFiles-All.zip"
    out_file_pics = "RM_LinkedFiles_PicsOnly.zip"
    sevenzip_app = Path(os.environ['ProgramFiles']) / r"7-zip\7z.exe"
    temp_big = ext_root / "temp"
    temp_fldr = temp_big / timestamp

    misc_fldr = "Miscellaneous"
    installer_fldr = "RootsMagic software installer"

    # Create temp folder
    temp_fldr.mkdir(parents=True, exist_ok=True)

    # Generate file listing
    # Run the script and wait for it to complete
    subprocess.run(["python", f'{userprofile}/Development/Maintenance/Create File Listing.py'])

    # Find latest files
    latest_db_main_bk = get_latest_file(gen_bu_path, "Otter-Saito*.rmbackup")
    latest_db_unlink_bk = get_latest_file(gen_bu_path, "Unlinked People*.rmbackup")
    latest_db_main_ged = get_latest_file(gedcom_fldr_path, "Otter-Saito*.ged")
    latest_ex_files_HASH = get_latest_file(HASH_listing_fldr_path, "MediaFiles_HASH*.txt")
    latest_file_listings = get_latest_file(file_listing_fldr_path, "File_Listings*.txt")

    print(f"Latest backup found: {latest_db_main_bk}")
    print(f"Latest backup found: {latest_db_unlink_bk}")
    print(f"Latest GEDCOM found: {latest_db_main_ged}")
    print(f'Latest hash file found: {latest_ex_files_HASH}')
    print(f"Latest File Listings found: {latest_file_listings}")

    copy_flash = prompt_yes_no("Copy to one or more Flash Drives")
    copy_gdrive = prompt_yes_no("Copy to Google Drive")
    copy_onedrive = prompt_yes_no("Copy to One Drive")


    # https://sevenzip.osdn.jp/chm/cmdline/
    # https://7ziphelp.com/7zip-command-line

    # Zipping files (using 7-Zip via command line)
    subprocess.run(f'"{sevenzip_app}" a -bsp0 -mx0 -tzip -r -xr!Audio\\ -xr!Misc\\ -xr!Sources\\ -xr!TODO\\ "{temp_fldr / out_file_pics}" "{media_fldr_path}"', shell=True)
    subprocess.run(f'"{sevenzip_app}" a -bsp0 -mx0 -tzip -r "{temp_fldr / out_file_full}" "{media_fldr_path}"', shell=True)

#    Path(f'{temp_fldr / out_file_pics}').touch()
#    Path(f'{temp_fldr / out_file_full}').touch()



# ===================================================DIV60==
    def copy_files(dest_fldr):
        # a nested function
        dest_fldr.mkdir(parents=True, exist_ok=True)
        shutil.copy(latest_db_main_bk, dest_fldr)
        misc_path = dest_fldr / misc_fldr
        misc_path.mkdir(exist_ok=True)
        shutil.copy(latest_db_unlink_bk, misc_path)
        if latest_db_main_ged:
            shutil.copy(latest_db_main_ged, misc_path)
        if latest_ex_files_HASH:
            shutil.copy(latest_ex_files_HASH, misc_path)
        # Copy Work Logs, SW, Installer files
        shutil.copytree(gen_root / "GeneDB/Work Logs", misc_path / "Work Logs", dirs_exist_ok=True)
        shutil.copytree(gen_root / "GeneDB/SW", misc_path / "SW", dirs_exist_ok=True)
        shutil.copytree(gen_appinst_fldr_path, dest_fldr / installer_fldr, dirs_exist_ok=True)
        shutil.copy(readme_path, dest_fldr / "__ReadMe.txt")
        shutil.copy(latest_file_listings, misc_path)
        shutil.copy(temp_fldr / out_file_pics, dest_fldr)
        shutil.copy(temp_fldr / out_file_full, dest_fldr)

    with keep.running():
    # with keep.presenting():
        # Flash drive copy
        if copy_flash:
            while True:
                dest_dr = input("Enter the letter of the destination drive: ").strip().upper()
                dest_fldr = Path(f"{dest_dr}:") / timestamp
                copy_files(dest_fldr)
                if not prompt_yes_no("Another copy on another flash drive"):
                    break

        # Google Drive copy
        if copy_gdrive:
            dest_fldr = dest_gdrive / timestamp
            copy_files(dest_fldr)

        # OneDrive copy
        if copy_onedrive:
            dest_fldr = dest_onedrive / timestamp
            copy_files(dest_fldr)

        # Cleanup
        print("Done copying. Proceed to cleanup of temporary files created in this script?")
        input("Press Enter to continue...")
        shutil.rmtree(temp_fldr, ignore_errors=True)
        print("DONE")

    return 0

# ===================================================DIV60==
def get_latest_file(folder, pattern):
    files = list(Path(folder).glob(pattern))
    return max(files, key=os.path.getmtime) if files else None

# ===================================================DIV60==
def prompt_yes_no(message):
    return input(f"{message} (Yy/Nn): ").strip().lower() == 'y'

# ===================================================DIV60==
# Call the "main" function
if __name__ == '__main__':
    main()

# ===================================================DIV60==
