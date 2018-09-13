#!/bin/bash
#Youtube-DL DASH Video and Audio merging script
#Written by QuidsUp
#Edited by Christoph Korn



URL=$1
if [ -z $URL ]; then
  echo "Usage: ytdl.sh url"
  exit
fi

#Find what quality of videos are available
./youtube-dl.exe -F $URL
echo
echo -n "Quality for Video (default 137): "
read Qual1
echo -n "Quality for Audio (default 140): "
read Qual2

#Set values if user has just pressed Return without typing anything
if [ -z $Qual1 ]; then
  Qual1="137"
fi
if [ -z $Qual2 ]; then
  Qual2="140"
fi

#Set filenames from output of youtube-dl
File1=$(./youtube-dl --get-filename -f $Qual1 $URL | iconv -f WINDOWS-1252 -t UTF-8)
File2=$(./youtube-dl --get-filename -f $Qual2 $URL | iconv -f WINDOWS-1252 -t UTF-8)
echo "File1: $File1"
echo "File2: $File2"
File1Extension=$(echo "$File1" | sed 's/^.*\.//')
File2Extension=$(echo "$File2" | sed 's/^.*\.//')

echo "File1Extension: $File1Extension"
echo "File2Extension: $File2Extension"

Out=${File1:0:${#File1}-16}".$File1Extension"
echo "Out: $Out"

File1New="video_new.${File1Extension}"
File2New="audio_new.${File2Extension}"

#Download Video file with First Quality Setting
./youtube-dl -f $Qual1 --output "$File1" $URL
if [[ ! -f $File1 ]]; then
  echo
  echo "Error video file not downloaded"
  exit
fi
echo "Moving video to $File1New"
mv "$File1" "$File1New"

#Download Audio file with Second Quality Setting
./youtube-dl -f $Qual2 --output "$File2" $URL
if [[ ! -f $File2 ]]; then
  echo
  echo "Error audio file not downloaded"
  exit
fi
echo "Moving audio to $File2New"
mv "$File2" "$File2New"

File1=$File1New
File2=$File2New

#Merge Audio and Video with ffmpeg
#Delete -threads 0 if you have a Single Core CPU
echo
echo "Combining Audio and Video files with FFMpeg"
#C:/Users/Adam/Downloads/ffmpeg-latest-win32-static/ffmpeg-20140919-git-33c752b-win32-static/bin/ffmpeg -i "$File1" -i "$File2" -sameq -threads 0 "$Out"
echo "Running C:/Applications/ffmpeg-3.2.4-win32-static/bin/ffmpeg -i $File1 -i $File2 -c:v copy -c:a copy $Out"
C:/Applications/ffmpeg-3.2.4-win32-static/bin/ffmpeg.exe -i "$File1" -i "$File2" -c:v copy -c:a copy "$Out"
if [[ -f $Out ]]; then
  echo
  echo "File" $Out "created"
else
  echo
  echo "Error Unable to combine Audio and Video files with FFMpeg"
  exit
fi

#Remove old Files
#rm "$File1"
#rm "$File2"

