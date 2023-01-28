#!/bin/bash

COLOR_OFF='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

YouTubeUrl=$1
if [ -z $YouTubeUrl ]; then
  echo "Usage: ytdl.sh url"
  exit
fi

yt-dlp --sub-langs "en.*" --write-sub --skip-download $YouTubeUrl
