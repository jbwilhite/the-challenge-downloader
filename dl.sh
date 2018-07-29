#!/bin/bash

season=${1?season param missing}

cd ${season}-*

cat list.txt | while read line || [ -n "$line" ]
do
    echo $line
    # skip if lines starts with #
    if [[ $line == '#'* ]]
    then
        continue
    fi

    # download files to temp dir
    # mtv downloads come out in multiple pieces
    # autonumber to preserve order
    mkdir temp
    cd temp
    youtube-dl -o "%(autonumber)s.%(ext)s" $line

    # make list file of all partials
    printf "file '%s'\n" *.mp4 > partials.txt
    cd ../

    # create file name as S##E##
    printf -v episodePadded "%02d" ${line:(-2)} # last 2 chars of url
    printf -v seasonPadded "%02d" $season
    fileName="S${season}E${episodePadded}"

    # concat partials to single video
    </dev/null ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy ${fileName}.mp4
    rm -rf ./temp
done