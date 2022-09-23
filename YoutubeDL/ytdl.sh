#!/bin/bash

COLOR_OFF='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

YouTubeUrl=$1
if [ -z $YouTubeUrl ]; then
  echo "Usage: ytdl.sh url"
  exit
fi

#Find what quality of videos are available
yt-dlp -F $YouTubeUrl
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
File1=$(yt-dlp --get-filename -f $Qual1 --encoding UTF-8 $YouTubeUrl)
File2=$(yt-dlp --get-filename -f $Qual2 --encoding UTF-8 $YouTubeUrl)
echo -e "${GREEN}File1: $File1${COLOR_OFF}"
echo -e "${GREEN}File2: $File2${COLOR_OFF}"

# Extract extensions:
# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
File1Extension="${File1##*.}"
File2Extension="${File2##*.}"

echo "File1Extension: $File1Extension"
echo "File2Extension: $File2Extension"

FileName="${File1%.*}"
Out=${FileName:0:${#FileName}-14}".$File1Extension" #drop last 14 characters
echo -e "${GREEN}Out: $Out${COLOR_OFF}"

File1New="video_new.${File1Extension}"
File2New="audio_new.${File2Extension}"

#Download Video file with First Quality Setting
yt-dlp -f $Qual1 --output "$File1" $YouTubeUrl
if [[ ! -f $File1 ]]; then
  echo
  echo "Error video file not downloaded"
  exit
fi
echo "Moving video to $File1New"
mv "$File1" "$File1New"

#Download Audio file with Second Quality Setting
yt-dlp -f $Qual2 --output "$File2" $YouTubeUrl
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
#ffmpeg -i "$File1" -i "$File2" -sameq -threads 0 "$Out"
echo "Running ffmpeg -i $File1 -i $File2 -c:v copy -c:a copy $Out"
ffmpeg -i "$File1" -i "$File2" -c:v copy -c:a copy "$Out"
if [[ -f $Out ]]; then
  echo
  echo -e "${GREEN}Created: $Out${COLOR_OFF}"
else
  echo
  echo "Error Unable to combine Audio and Video files with FFMpeg"
  exit
fi

#Remove old Files
#rm "$File1"
#rm "$File2"

