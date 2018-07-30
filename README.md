# the-challenge-downloader

Depends on `youtube-dl` and `ffmpeg`

Episode urls are stored in a `list.txt` in each season's folder.  Lines can be skipped by prefixing a `#`.

To download a season:
```
./dl.rb 11
```

To download as flv (needed for sound on mtv.ca):
```
./dl.rb -flv 19
```
