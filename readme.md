# Bash/Nemo Scripts for Plex

Helps you organize your files via symbolic links so Plex lists them correctly.

Your files will not be renamed, moved, or modified in any way by these scripts.

To install, clone this repo in `~/.local/share/nemo/scripts`

## Scripts
- **`map/append`:** From the show or movie's directory, select files/directories and run this to append videos and subtitles to `plex.tsv`
    - Supported subtitles: `ass`, `smi`, `srt`, `ssa`, `vtt`

    Once you've edited `plex.tsv` to your liking with your favorite spreadsheet program, run the `map/process` script.

- **`map/process`:** From the show or movie's directory, reads `plex.tsv` and creates symlinks.

    Also updates the `.plexignore` tree and **sorts** `plex.tsv`, so if you have it open make sure to reload it.

- `help/condensed-episodes`: Generates ranged designators (`xx-Exx`) for mapping files containing multiple episodes.

    No files need to be selected to run this, but you will want to `map/append` the episodes to `plex.tsv` first.

    The resulting output can be pasted into an editor for the second column (episode designator) alongside the file paths.

- `help/split-episodes`: Generates fragment-designators (`ptX`) for mapping single episodes that are split among multiple files.

    No files need to be selected to run this, but you will want to `map/append` the episodes to `plex.tsv` first.

    The resulting output can be pasted into an editor for the second column (episode designator) alongside the file paths.

- `mark/*`: Adds emblems to folders.

- `ignore`: Adds selected files/directories to the `.plexignore` tree.

- `unignore`: Removes selected files/directories from the `.plexignore` tree.

- `x-reset-x`: From the show's directory, clears the `.plexignore` tree and `__plex` symlinks (asks for confirmation)

## plex.tsv
The TSV is an **unquoted** and **headless** map which defines what gets plex-ignored and symlinked.

1. The first column is the SEASON or ASSET designator, and MUST be either:
    - `#` to denote a comment-row (see section below)
    - Blank to have the processor skip symlinking
    - For shows, a season integer (0, 1, 2, 3, ...)
    - For movie extras, one of the [Local Media Asset](https://support.plex.tv/articles/local-files-for-trailers-and-extras/) tags:
        - `behindthescenes`
        - `deleted`
        - `featurette`
        - `interview`
        - `scene`
        - `short`
        - `trailer`
        - `other`

2. The second column is the EPISODE or INDEX designator, and MUST be either:
    - Blank to have the processor skip symlinking
    - For shows:
        - An episode integer (0, 1, 2, 3, ...)
        - A Plex-friendly episode designator that will be prefixed with "E" when symlinking. For example:
            - "01-E02" becomes `E01-E02` (the `help/condensed-episodes` script can help you fill these)
            - "01.pt1" becomes `E01.pt1` (the `help/split-episodes` script can help you fill these)
    - For movie extras:
        - A hyphen (`-`) to use the file name as-is and trust Plex's alphabetical sorting
        - An integer (1, 2, 3, ...) to index the extra for sorting
        - Any other label to be used literally
        
    - Subtitles can be mapped, too. The designator must be `<OWNER>.<ISO2>`
        - For example: "01.en" becomes `E01.en`, which is English subtitles for `E01`

3. The third column is the MEDIA PATH relative to the TSV's directory.
    Files in this column are added to the `.plexignore` tree by the processor,
    regardless of whether they get symlinked.

    There MUST NOT be any columns after the third.


## TV Example
`plex.tsv`:
```
#		this is a comment
		ignore-me.mp4
0	1	misc/unaired-pilot.mp4
```

### Result
`.plexignore`:
```
ignore-me.mp4
```

`misc/.plexignore`:
```
unaired-pilot.mp4
```

`__plex/` directory:
```
S00/S00E01.mp4 -> ../../misc/unaired-pilot.mp4
```

### Explanation
Even though `misc/unaired-pilot.mp4` is similarly ignored, the symlink isn't. Plex sees `__plex/S00/S00E01.mp4` as a video, and uses it.

Thus, Plex can be organized without renaming or moving source files.

### Comment Rows
Lines that begin with `#` are skipped entirely.
Since `plex.tsv` is sorted, the comment text should be placed in the third column, and multiple comments should be numbered.
```
#		1. this is a multi-line comment
#		2. which is skipped by the processor
#		3. and is kept at the top of the tsv
```

## Movie Extras Example
`plex.tsv`:
```
trailer	-	misc/Official Trailer.mp4
deleted	1	misc/Deleted Scene.mp4
deleted	2	misc/Another Deleted Scene.mp4
```

### Result
`misc/.plexignore`:
```
Official Trailer.mp4
Deleted Scene.mp4
Another Deleted Scene.mp4
```

The movie's directory:
```
Official Trailer-trailer.mp4            -> misc/Official Trailer.mp4
01. Deleted Scene-deleted.mp4           -> misc/Deleted Scene.mp4
02. Another Deleted Scene-deleted.mp4   -> misc/Another Deleted Scene.mp4
```

### Caveats
Unfortunately, the bloated "inline" way is the only way to control the sorting of movie extras.
The inline extras have to exist on the same level as the movie; there's no way to have them work in the `__plex` directory.

Also, there can't be *any* other videos in the movie file's directory except for the movie and the inline extras themselves, at all,
including the source files for the extras that would be otherwise be mapped and ignored.
The movie file's directory must purely only contain videos/symlinks that comprise the final set.
So, extras should be placed in an arbitrary subdirectory and mapped from there.

> [Local Files for Movie Trailers and Extras > Adding Local Trailers and Extras](https://support.plex.tv/articles/local-files-for-trailers-and-extras/)
>
> "Besides the extras themselves, you can only have the main movie file (or other local media assets) in the directory."

There is a known bug with the "subdirectories" approach where the sorting is seemingly random -- regardless of file name, modification time, etc.
Plex has ackowledged this bug ever since the "extras" feature was added, and they've done nothing about it.

If/when they fix the bug, the processor will be updated to use the "subdirectories" approach. Maps will not need to be updated, the code-friendly lowercase tags will continue to be used for mapping.

## Keyboard Shortcuts
Something that can greatly improve the experience of organizing large libraries is to bind some of these scripts to keyboard shortcuts.

From a shell:

```
nemo -q
touch ~/.gnome2/accels/nemo
nemo .
```

Press `CTRL+F1` to open the shortcut menu, which populates `.gnome2/accels/nemo`. Then close the dialog and the nemo window.

Edit `~/.gnome2/accels/nemo` and find the scripts you want to add shortcuts to. Here's what I have:

- `map/append` = `<Primary><Alt><Shift>a`
- `map/process` = `<Primary><Alt><Shift>p`
- `mark/complete` = `<Primary><Alt><Shift>c`
- `mark/mostly-complete` = `<Primary><Alt><Shift>i`

Note: `<Primary>` is used in the config to mean `CTRL` for normal keyboards and `CMD` for Macs. Also make sure to remove the leading `; ` which comments-out the line.

