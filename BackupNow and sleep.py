import os
import shutil
from datetime import datetime
from pathlib import Path
import subprocess
from wakepy import keep     # https://github.com/fohrloop/wakepy/blob/main/README.md
import time
import msvcrt

# ===================================================DIV60==
def main():
    _DEBUG = False

    # Timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d-%H%M%S")

    # Data source locations
    userprofile = os.environ['USERPROFILE']
    gen_root = Path(userprofile) / "Genealogy"
    ext_root = Path(r"E:\Users Overflow\ROtter external")

    production_db_path = gen_root / r"GeneDB\Otter-Saito.rmtree"
    secondary_dbs_fldr_path = gen_root / r"GeneDB" / r"Secondary Trees"

    # Data destination locations
    dest_gdrive = Path(r"G:\My Drive\misc\daily latest")
    dest_onedrive = Path(userprofile) / r"OneDrive\Documents\daily latest"

    with keep.running():

        # check for existence of google dest folder
        # may need to restart drive
        print(F"\n\nCopying files to {dest_gdrive}")      
        shutil.copy(production_db_path, dest_gdrive)
        shutil.copytree(secondary_dbs_fldr_path, dest_gdrive, dirs_exist_ok=True)

        print(F"\n\nCopying files to {dest_onedrive}")
        shutil.copy(production_db_path, dest_onedrive)
        shutil.copytree(secondary_dbs_fldr_path, dest_onedrive, dirs_exist_ok=True)

        kill_google_drive()
        restart_google_drive(GOOGLE_DRIVE_EXE)
        print("[DONE] Sync should begin immediately.")

        #   cmd.exe /c "C:\Program Files (x86)\Backblaze\bztransmit.exe" -forcefullfilescan_backup_wait_for_completion
        subprocess.run(
            ["cmd.exe", "/c", 
             r'C:\Program Files (x86)\Backblaze\bztransmit.exe',
             '-forcefullfilescan_backup_wait_for_completion'],
            creationflags=subprocess.CREATE_NEW_CONSOLE
        )
   
        timeout_with_break(600)

        # Run A Manually Scheduled Task To Sleep Computer
        subprocess.run([r"schtasks.exe", "/Run", "/TN", "\RJO\Put computer to sleep" ])

        print("DONE")

    return 0



# ---------------------------------------------------------
def timeout_with_break(seconds):
    """Emulate CMD 'timeout /t N' where any keypress interrupts the wait."""
    print(f"Waiting {seconds} seconds... (press any key to continue)")
    end_time = time.time() + seconds

    while time.time() < end_time:
        if msvcrt.kbhit():
            msvcrt.getch()  # clear keypress
            return
        time.sleep(0.1)


# ===================================================DIV60==
# Path to Google Drive executable (Drive for desktop)
GOOGLE_DRIVE_EXE = Path(
    r"C:\Program Files\Google\Drive File Stream\121.0.1.0\GoogleDriveFS.exe"
)

# ===================================================DIV60==
def copy_to_drive(src: Path, drive_folder: Path) -> Path:
    """Copy file to Google Drive folder with full diagnostics."""
    if not src.exists():
        raise FileNotFoundError(f"Source file does not exist: {src}")

    if not drive_folder.exists():
        raise FileNotFoundError(f"Google Drive folder not found: {drive_folder}")

    dest = drive_folder / src.name
    shutil.copy2(src, dest)
    print(f"[OK] Copied to Drive: {dest}")
    return dest


# ===================================================DIV60==
def kill_google_drive():
    """Terminate Google Drive processes to force a rescan."""
    processes = ["GoogleDriveFS.exe", "GoogleDriveSync.exe"]

    for proc in processes:
        subprocess.run(
            ["taskkill", "/F", "/IM", proc],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    print("[OK] Google Drive processes terminated")


# ===================================================DIV60==
def restart_google_drive(exe_path: Path):
    """Restart Google Drive to force immediate sync."""
    if not exe_path.exists():
        raise FileNotFoundError(f"Google Drive executable not found: {exe_path}")

    subprocess.Popen(
        [str(exe_path)],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    print("[OK] Google Drive restarted")
    time.sleep(3)  # allow initialization


# ===================================================DIV60==
def prompt_yes_no(message):
    return input(f"{message} (Yy/Nn): ").strip().lower() == 'y'

# ===================================================DIV60==
# Call the "main" function
if __name__ == '__main__':
    main()

# ===================================================DIV60==
