# the-challenge-downloader

Depends on `youtube-dl` and `ffmpeg`

Episode urls are stored in a `list.txt` in each season's folder.

To download a season:
``` bash
./dl.rb 11
```

### Canadian URLs
For some reason the canadian urls don't get the proper audio using the default settings (mp4).  Use the `--flv` option instead.
``` bash
./dl.rb --flv 19
```

Then change to season directory and convert to mp4
``` bash
for i in *.flv; do name=`echo $i | cut -d'.' -f1`; ffmpeg -i "$i" "${name}.mp4"; done;
rm *.flv
```
