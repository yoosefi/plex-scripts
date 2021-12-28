# Bash/Nemo Scripts for Plex

Helps you organize your files via symbolic links so Plex lists them correctly.

Your video files will not be renamed, moved, or modified in any way by these scripts.

To install, clone this repo in `~/.local/share/nemo/scripts`

## Scripts
- **`map/append`:** From the show's main directory, select files/directories and run this to append videos to `plex.tsv`
    - Subtitles can be mapped, too. The episode designation column must align as `EPISODE.ISO2.EXT` (e.g. `01.en.srt`)

    Once you've edited `plex.tsv` to your liking with your favorite spreadsheet program, run the `map/process` script.

- **`map/process`:** From the show's main directory, reads `plex.tsv` and creates symlinks in a reserved directory named `__plex`

    Also updates the `.plexignore` tree and **sorts** `plex.tsv`, so if you have it open make sure to reload it.

- `help/condensed-episodes`: Generates ranged designators (`xx-Exx`) for mapping multi-episode files.

- `help/split-episodes`: Generates fragmented designators (`xxa`, `xxb`, etc.) for mapping multi-file episodes.

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
        - "01a" becomes "E01a" (the `help/split-episodes` script can help you fill these)

- The third column MUST NOT be changed, it's the video path relative to the show root.
    Files in this column are added to the .plexignore tree by the processor,
    regardless of whether they get symlinked.

- There MUST NOT be any columns after the third.

## Example plex.tsv
```
		ignore-me.mp4
0	1	misc/unaired-pilot.mp4
```

## Example Processing Result
`.plexignore`
```
ignore-me.mp4
```

`misc/.plexignore`
```
unaired-pilot.mp4
```

`__plex/`
```
S00E01.mp4 -> ../misc/unaired-pilot.mp4
```

## Explanation
Even though `misc/unaired-pilot.mp4` is ignored, the symlink isn't. Plex sees `__plex/S00E01.mp4` as a video file, and uses it.

Thus, Plex can be organized without renaming or moving source videos.

