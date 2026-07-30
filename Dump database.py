from datetime import datetime
from pathlib import Path
import subprocess
import tempfile

# Original paths
DB_PATH = Path(r"C:\Users\rotter\Genealogy\GeneDB\Otter-Saito.rmtree")
OUTPUT_FLDR_PATH = Path(r"E:/Users Overflow/ROtter external/backup/RootsMagic/Dump to SQL")

# Convert to SQLite‑safe paths
DB_PATH_SQL = str(DB_PATH).replace("\\", "/")
OUTPUT_FLDR_PATH_SQL = str(OUTPUT_FLDR_PATH).replace("\\", "/")

# Timestamp
TIMESTAMP = datetime.now().strftime("%Y%m%d-%H%M%S")

# Output SQL file
OUTPUT_SQL_FILE = f"Otter-Saito-sql-dump-{TIMESTAMP}.sql"
OUT_FILE = f"{OUTPUT_FLDR_PATH_SQL}/{OUTPUT_SQL_FILE}"

# Temp file
TEMPFILE = Path(tempfile.gettempdir()) / f"MaintenanceTempFile_{TIMESTAMP}.txt"

with TEMPFILE.open("w", encoding="utf-8") as f:
    f.write(f'.output "{OUT_FILE}"\n')
    f.write(f'.open "{DB_PATH_SQL}"\n')
    f.write('.dump\n')
    f.write('.quit\n')

# Run sqlite3
SQLITE_EXE = r"\bin\sqlite\sqlite3.exe"
subprocess.run([SQLITE_EXE], stdin=TEMPFILE.open("r"), check=True)

# ------------------------------------------------------------
# CLEANUP TEMP FILE
# ------------------------------------------------------------

TEMPFILE.unlink(missing_ok=True)
print("\nTemp file deleted.")

input("\nPress Enter to exit...")