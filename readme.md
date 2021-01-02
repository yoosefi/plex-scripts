# Plex Scripts for Nemo

Helps you organize your files with symlinks so Plex lists them correctly.

Your video files will not be renamed, moved, or modified in any way by these scripts.

## Scripts
- `map-append`: From the show's main directory, select files and run this to append them to `plex.tsv`
    Once you've edited `plex.tsv` to your liking with your favorite spreadsheet program, run the `map-process` script.
- `map-process`: Reads `plex.tsv` in the show's main directory and creates symlinks in `~plex` directory.
    Also updates the `.plexignore` tree.
- `ignore`: adds selected files/directories to the `.plexignore` tree.
- `unignore`: removes selected files/directories from the `.plexignore` tree.
- `x-reset-x`: From the show's main directory, clears the `.plexignore` tree and `~plex` symlinks (asks for confirmation)

## plex.tsv
- The first column is the SEASON designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.

- The second column is the EPISODE designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.
    - A Plex-friendly designator that will be prefixed with "E" when symlinking. For example:
        - "01-E02" becomes "E01-E02"
        - "01a" becomes "E01a"

- The third column MUST NOT be changed, it's the video path relative to the show root.
    Files in this column are added to the .plexignore tree by the processor,
    regardless of whether they get symlinked.

## Example plex.tsv
```
		ignore-me.mp4
0	1	misc/pilot.mp4
```
