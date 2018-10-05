#Youtube-DL DASH Video and Audio merging script
#Written by QuidsUp
#Edited by Christoph Korn

Param
  (
     [parameter(Position=0)]
     [ValidateNotNullOrEmpty()]
     [String]
     $YouTubeUrl=$(throw "Usage: ytdl.ps1 url.")
  ) 

$OutputEncoding = New-Object -typename System.Text.UTF8Encoding
[Console]::OutputEncoding = New-Object -typename System.Text.UTF8Encoding

#[Console]::WriteLine('aaa Лимонад')
#Write-Host 'ccc Лимонад'
#Find what quality of videos are available
./youtube-dl -F $YouTubeUrl
Write-Host
$Qual1 = (read-host "Quality for Video (default 137): ").trim()
$Qual2 = (read-host "Quality for Video (default 140): ").trim()

#Set values if user has just pressed Return without typing anything
if ([string]::IsNullOrWhiteSpace($Qual1)) {
  $Qual1 = '137'
}

if ([string]::IsNullOrWhiteSpace($Qual2)) {
  $Qual2 = '140'
}
$File1=./youtube-dl --get-filename -f $Qual1 --encoding UTF-8 $YouTubeUrl
$File2=./youtube-dl --get-filename -f $Qual2 --encoding UTF-8 $YouTubeUrl

Write-Host "File1: $File1" -ForegroundColor DarkGreen
Write-Host "File1: $File2" -ForegroundColor DarkGreen

$File1Extension=[System.IO.Path]::GetExtension($File1)
$File2Extension=[System.IO.Path]::GetExtension($File2)

Write-Host "File1Extension: $File1Extension"
Write-Host "File2Extension: $File2Extension"

$FileName = [System.IO.Path]::GetFileNameWithoutExtension($File1)
$Out=($FileName -replace ".{12}$") + ${File1Extension} #drop last 12 characters
Write-Host "Out: $Out" -ForegroundColor DarkGreen

$File1New="video_new${File1Extension}"
$File2New="audio_new${File2Extension}"

# Download Video file with First Quality Setting
./youtube-dl -f $Qual1 --output "$File1" $YouTubeUrl
if (-not (Test-Path -LiteralPath $File1)) { 
  Write-Host "Error video file not downloaded"
  Exit
}
Write-Host "Moving video to $File1New" -ForegroundColor DarkGreen
Move-Item -LiteralPath $File1 -Destination $File1New -Force

#Download Audio file with Second Quality Setting
./youtube-dl -f $Qual2 --output "$File2" $YouTubeUrl
if (-not (Test-Path -LiteralPath $File2)) { 
  Write-Host "Error audio file not downloaded"
  Exit
}
Write-Host "Moving audio to $File2New" -ForegroundColor DarkGreen
Move-Item -LiteralPath $File2 -Destination $File2New -Force

$File1=$File1New
$File2=$File2New

#Merge Audio and Video with ffmpeg
#Delete -threads 0 if you have a Single Core CPU

Write-Host "Combining Audio and Video files with FFMpeg" -ForegroundColor DarkGreen
#ffmpeg -i "$File1" -i "$File2" -sameq -threads 0 "$Out"
Write-Host "Running $((Get-Command ffmpeg).Path) -i $File1 -i $File2 -c:v copy -c:a copy $Out"
ffmpeg -i "$File1" -i "$File2" -c:v copy -c:a copy "$Out"
if (Test-Path $Out) { 
  Write-Host "File" $Out "created" -ForegroundColor DarkGreen
  Exit
} else {
  Write-Host "Error Unable to combine Audio and Video files with FFMpeg"
  Exit
}


