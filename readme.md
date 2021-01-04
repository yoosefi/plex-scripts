# Bash/Nemo Scripts for Plex

Helps you organize your files via symbolic links so Plex lists them correctly.

Your video files will not be renamed, moved, or modified in any way by these scripts.

To install, clone this repo in `~/.local/share/nemo/scripts`

## Scripts
- **`map/append`:** From the show's main directory, select files/directories and run this to append videos to `plex.tsv`

    Once you've edited `plex.tsv` to your liking with your favorite spreadsheet program, run the `map/process` script.


- **`map/process`:** From the show's main directory, reads `plex.tsv` and creates symlinks in a reserved directory named `__plex`

    Also updates the `.plexignore` tree and **sorts** `plex.tsv`, so if you have it open make sure to reload it.

- `help/condensed-episodes`: Generates ranged `xx-Exx` values for mapping multi-episode files.

- `mark/*`: Adds emblems to folders.

- `ignore`: Adds selected files/directories to the `.plexignore` tree.

- `unignore`: Removes selected files/directories from the `.plexignore` tree.

- `x-reset-x`: From the show's main directory, clears the `.plexignore` tree and `__plex` symlinks (asks for confirmation)

## plex.tsv
The TSV is a map which defines what gets ignored and symlinked.

- The first column is the SEASON designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.

- The second column is the EPISODE designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.
    - A Plex-friendly designator that will be prefixed with "E" when symlinking. For example:
        - "01-E02" becomes "E01-E02" (the `help/condensed-episodes` script can help you fill these)
        - "01a" becomes "E01a"

- The third column MUST NOT be changed, it's the video path relative to the show root.
    Files in this column are added to the .plexignore tree by the processor,
    regardless of whether they get symlinked.

- There MUST NOT be any columns after the third.

## Example plex.tsv
```
		ignore-me.mp4
0	1	misc/pilot.mp4
```
