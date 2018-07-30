The canada urls work slightly differently.  The default mp4 settings don't correctly pull the audio. I modified the script to get the flv files instead, then converted those to mp4 with ffmpeg.

The youtube-dl line needs the following option: `-f hds-2048` and `.mp4` replaced with `.flv`.

To convert the files:
```bash
for i in *.flv; do name=`echo $i | cut -d'.' -f1`; ffmpeg -i "$i" "${name}.mp4"; done;
```
