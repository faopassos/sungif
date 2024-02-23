#!/bin/bash
base_dir="."
log_file=$(date +"$base_dir/log/%F_gif.log")
image_dir="$base_dir/images"
video_dir="$base_dir/videos"

exec >> $log_file 2>&1

echo "Start process in $(date +%Y%m%d-%H:%M)"
/home/operacao/scripts-sungif/get_images.bash

echo -e "\nStarting mp4/gif genaration in $(date +%Y%m%d-%H:%M)"
if [[ $(ls $image_dir/*.jpg | wc -l) -gt 300 ]]; then
	ffmpeg -r 10 -pattern_type glob -i "$image_dir/*.jpg" -c:v libx264 -profile:v main -vf format=yuv420p -c:a aac -movflags +faststart -s 238x238 "$video_dir/sun.mp4"
else
	echo -e "\nLess than 300 images where downloaded. Gif will not be generated today!\n"
	rm $image_dir/*.jpg
	exit 1
fi
if [[ -s "$video_dir/sun.mp4" ]]; then
	ffmpeg -i "$video_dir/sun.mp4" -vf "fps=10,scale=238:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,setpts=0.5*PTS" -loop 0 "$video_dir/sun.gif" -y
fi
echo "mp4/gif finished in $(date +%Y%m%d-%H:%M)"

# cp sun.gif to nodeJs folder
[ -f "$video_dir/sun.gif" ] && mv -v $video_dir/sun.gif /home/operacao/sun-node/src/assets/

# rm jpg/mp4 files
find $image_dir/ -type f -name '*.jpg' -exec rm {} \;
[ -f "$video_dir/sun.mp4" ] && rm $video_dir/sun.mp4
echo -e "\nProcess finished in $(date +%Y%m%d-%H:%M)"

[ -d "$base_dir/log/" ] && find $base_dir/log/ -type f -name '*.log' -mtime +30 -exec rm {} \;
