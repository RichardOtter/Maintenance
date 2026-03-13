
def validate_sets(filename):
    with open(filename, encoding="utf-8") as f:
        lines = [line.strip() for line in f]

    i = 0
    while i < len(lines):
        # Look for three consecutive separator lines
        if (i + 2 < len(lines) and
            lines[i]   == "===========================================DIV50==" and
            lines[i+1] == "===========================================DIV50==" and
            lines[i+2] == "===========================================DIV50=="):

            # Grab the next 6 lines after the separators
            set_lines = lines[i+3:i+10]

            if len(set_lines) < 6:
                print(f"Incomplete set starting at line {i+1}")
                break

            valid = True
            if not set_lines[0].startswith("_CURRENT-NAME: "):
                print(f"Line {i+4} does not start with _CURRENT-NAME: ")
                valid = False
            if not set_lines[1].startswith("_RM-PRI-NAME: "):
                print(f"Line {i+5} does not start with _RM-PRI-NAME: ")
                valid = False
            if not set_lines[2].startswith("_MATCH-ID: "):
                print(f"Line {i+6} does not start with _MATCH-ID: ")
                valid = False
            if not set_lines[3].startswith("_SERVICE:"):
                print(f"Line {i+7} does not start with _SERVICE:")
                valid = False
            if not set_lines[4].startswith("_LCA-"):
                print(f"Line {i+8} does not start with _LCA-")
                valid = False
            if not set_lines[5].startswith("_REL:"):
                print(f"Line {i+9} does not start with _REL: ")
                valid = False


            if valid:
                print(f"Set starting at line {i+1} is valid")

            # Advance past this set (3 separators + 3 data lines)
            i += 6
        else:
            # Skip unrelated lines
            i += 1


dir=r"C:\Users\rotter\Genealogy\GeneDB\RM_LinkedFiles\Status\DNA Status\\"

# validate_sets(dir + "DNA Matches -established -Richard Otter.txt")
# validate_sets(dir + "DNA matches -tentative -Richard Otter.txt")
# validate_sets(dir + "DNA Matches -research -Richard Otter.txt")

# validate_sets(dir + "DNA Matches -established -Gloria Saito.txt")
# validate_sets(dir + "DNA matches -tentative -Gloria Saito.txt")
# validate_sets(dir + "DNA Matches -research -Gloria Saito.txt")

# validate_sets(dir + "DNA Matches -tentative -Tamara Chao.txt")
