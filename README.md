# the-challenge-downloader
Download full seasons on The Challenge that are available on mtv.com or mtv.ca

Dependencies:
- [`youtube-dl`](https://github.com/rg3/youtube-dl)
- [`ffmpeg`](https://github.com/FFmpeg/FFmpeg)

By default, using youtube-dl will create multiple files per episode, broken up on the commercial breaks.  This script concats those files together with ffmpeg.

To download a season:
``` bash
./dl.rb 11
```
