# the-challenge-downloader
Download full seasons on The Challenge that are available on mtv.com

Dependencies:
- [`youtube-dl`](https://github.com/rg3/youtube-dl)
- [`ffmpeg`](https://github.com/FFmpeg/FFmpeg)

By default, using youtube-dl will create multiple files per episode, broken up on the commercials.  This script concats those files together with ffmpeg.

Episode urls are stored in a `list.txt` in each season's directory.

To download a season:
``` bash
./dl.rb 11
```

### Canadian URLs
Some of the seasons are only available on on mtv.ca.  For some reason the canadian urls don't get the proper audio using the default settings (mp4).  Use the `--flv` option instead.
``` bash
./dl.rb --flv 19

# Then change to season directory and convert to mp4
for i in *.flv; do name=`echo $i | cut -d'.' -f1`; ffmpeg -i "$i" "${name}.mp4"; done;
rm *.flv
```
