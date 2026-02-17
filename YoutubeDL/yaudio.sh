#!/bin/bash

COLOR_OFF='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

YouTubeUrl=$1
if [ -z $YouTubeUrl ]; then
  echo "Usage: m4a.sh url"
  exit
fi

#Find what quality of videos are available
yt-dlp -F $YouTubeUrl
echo -n "Quality for Audio (default 140): "
read Qual2

#Set values if user has just pressed Return without typing anything
if [ -z $Qual2 ]; then
  Qual2="140"
fi

#Download Audio file with Second Quality Setting
yt-dlp -f $Qual2 --embed-thumbnail $YouTubeUrl

