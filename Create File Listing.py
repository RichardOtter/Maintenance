import os
from pathlib import Path
from datetime import datetime

# Generate recursive directory and file listings with creation and modification times


timestamp = datetime.now().strftime('%Y%m%d_%H%M')

path_to_list = Path(r'C:/Users/rotter/Genealogy')
Gene_external_root = Path(r"E:\Users Overflow\ROtter external\Genealogy")
output_file =Gene_external_root / "Generated Output\File Listings" / f'File_Listings ({timestamp}).txt'

with open(output_file, 'a', encoding='utf-8') as f:
    f.write('\r\n')
    for dirpath, dirnames, filenames in os.walk(path_to_list):
        f.write(f'Directory: {dirpath}\n')
        entries = []
        for name in filenames:
            file_path = Path(dirpath) / name
            try:
                stat = file_path.stat()
                entries.append({
                    'Name': name,
                    'Length': stat.st_size,
                    'CreationTime': datetime.fromtimestamp(stat.st_ctime).strftime('%Y-%m-%d %H:%M:%S'),
                    'LastWriteTime': datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M:%S'),
                })
            except Exception:
                entries.append({'Name': name, 'Length': 'Error', 'CreationTime': 'Error', 'LastWriteTime': 'Error'})
        # Format as table
        if entries:
            header = '{:<40} {:>12} {:<20} {:<20}'.format('Name', 'Length', 'CreationTime', 'LastWriteTime')
            f.write(header + '\n')
            f.write('-'*len(header) + '\n')
            for entry in entries:
                f.write('{:<40} {:>12} {:<20} {:<20}\n'.format(
                    entry['Name'], entry['Length'], entry['CreationTime'], entry['LastWriteTime']))
        f.write('\r\n')