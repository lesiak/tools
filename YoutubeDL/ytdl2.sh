#!/bin/bash
#Youtube-DL DASH Video and Audio merging script
#Written by QuidsUp
#Edited by Christoph Korn

File1New=video.mp4
File2New=audio.m4a

URL=$1
if [ -z $URL ]; then
  echo "Usage: ytdl.sh url"
  exit
fi

#Find what quality of videos are available
./youtube-dl -F $URL
echo
echo -n "Quality for Video (default 137): "
read Qual1
echo -n "Quality for Audio (default 141): "
read Qual2

#Set values if user has just pressed Return without typing anything
if [ -z $Qual1 ]; then
  Qual1="137"
fi
if [ -z $Qual2 ]; then
  Qual2="141"
fi

#Set filenames from output of youtube-dl
#File1=$(./youtube-dl --get-filename -f $Qual1 $URL)
#File2=$(./youtube-dl --get-filename -f $Qual2 $URL)
Out=$(./youtube-dl --get-filename -f $Qual1+$Qual2 $URL | iconv -f WINDOWS-1252 -t UTF-8)

#echo $File1
#echo $File2
#Out=${File1:0:${#File1}-16}".mp4"
echo $Out


#Download Video and Audio files and merge witf ffmpeg
./youtube-dl -f $Qual1+$Qual2 $URL
if [[ -f $Out ]]; then
  echo
  echo "File" $Out "created"
else
  echo
  echo "Error Unable to combine Audio and Video files with FFMpeg"  $Out
  exit
fi

