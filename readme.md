# Bash/Nemo Scripts for Plex

Helps you organize your files via symbolic links so Plex lists them correctly.

Your files will not be renamed, moved, or modified in any way by these scripts.

To install, clone this repo in `~/.local/share/nemo/scripts`

## Scripts
- **`map/append`:** From the show's main directory, select files/directories and run this to append videos and subtitles to `plex.tsv`
    - Supported subtitles: `ass`, `smi`, `srt`, `ssa`, `vtt`

    Once you've edited `plex.tsv` to your liking with your favorite spreadsheet program, run the `map/process` script.

- **`map/process`:** From the show's main directory, reads `plex.tsv` and creates symlinks in a reserved directory named `__plex`

    Also updates the `.plexignore` tree and **sorts** `plex.tsv`, so if you have it open make sure to reload it.

- `help/condensed-episodes`: Generates ranged designators (`xx-Exx`) for mapping files containing multiple episodes.

    No files need to be selected to run this, but you will want to `map/append` the episodes to `plex.tsv` first.

    The resulting output can be pasted into an editor for the second column (episode designator) alongside the file paths.

- `help/split-episodes`: Generates fragment-designators (`ptX`) for mapping single episodes that are split among multiple files.

    No files need to be selected to run this, but you will want to `map/append` the episodes to `plex.tsv` first.

    The resulting output can be pasted into an editor for the second column (episode designator) alongside the file paths.

- `help/credits`: Generates complete rows for `plex.tsv` that recombine episodes with their credits.

    **NOTE: Due to a limitation of Plex, the credits and episodes must have identical streams (audio, subtitles, and average video bitrate).**

    Anime, for example, often has the credits removed from all episodes.

    From the show root, open a tree view and select the episodes that are missing their credits, and run this.

    Enter the relative paths to the credits, the season number, and the beginning episode number.

    The resulting rows can be pasted directly into `plex.tsv`

- `mark/*`: Adds emblems to folders.

- `ignore`: Adds selected files/directories to the `.plexignore` tree.

- `unignore`: Removes selected files/directories from the `.plexignore` tree.

- `x-reset-x`: From the show's main directory, clears the `.plexignore` tree and `__plex` symlinks (asks for confirmation)

## plex.tsv
The TSV is an **unquoted** and **headless** map which defines what gets ignored and symlinked.

- The first column is the SEASON designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.

- The second column is the EPISODE designator, and MUST be either:
    - An integer (0, 1, 2, 3, ...)
    - Blank to have the processor skip symlinking.
    - A Plex-friendly designator that will be prefixed with "E" when symlinking. For example:
        - "01-E02" becomes "E01-E02" (the `help/condensed-episodes` script can help you fill these)
        - "01.pt1" becomes "E01.pt1" (the `help/split-episodes` script can help you fill these)
    - Subtitles can be mapped, too. The designator must be `<EPISODE>.<ISO2>`
        - For example: `01.en` means English subtitles for `E01`

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

