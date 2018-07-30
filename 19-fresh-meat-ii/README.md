The canada urls work slightly differently.  The default mp4 settings don't correctly pull the audio. Download as .flv instead, then convert to mp4 with ffmpeg.

```bash
./dl.rb -flv 19
```

To convert the files:
```bash
for i in *.flv; do name=`echo $i | cut -d'.' -f1`; ffmpeg -i "$i" "${name}.mp4"; done;
```
