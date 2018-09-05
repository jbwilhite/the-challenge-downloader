For some reason this season doesn't get the proper audio using the default settings (mp4).  Use the `--flv` option instead.
``` bash
./dl.rb --flv 19

# Then change to season directory and convert to mp4
for i in *.flv; do name=`echo $i | cut -d'.' -f1`; ffmpeg -i "$i" "${name}.mp4"; done;
rm *.flv
```
