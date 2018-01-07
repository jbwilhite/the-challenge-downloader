#!/bin/bash

season=${1?season param missing}

cd ${season}-*

count=1
cat list.txt | while read line
do
    #download files to temp dir
    #mtv downloads come out in multiple pieces
    #autonumber to preserve order
    mkdir temp
    cd temp
    youtube-dl -o "%(autonumber)s.%(ext)s" $line

    #make list file of all partials
    printf "file '%s'\n" *.mp4 > partials.txt
    cd ../

    #create file name as S##E##
    printf -v countPadded "%02d" $count
    printf -v seasonPadded "%02d" $season
    fileName="S${season}E${countPadded}"

    #concat partials to single video
    ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy ${fileName}.mp4
    rm -rf ./temp

    count=$((count + 1))
done