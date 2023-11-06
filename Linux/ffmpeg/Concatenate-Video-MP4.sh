#!/bin/bash
#
# Concatenate-Video-MP4.sh
#
# About
# This script will join mp4 files together and then transcode the combined file into a format sutible for streaming over HTTP on the web.
# This script expects a folder called video_parts - but you can edit this below.
#
# filenames in the folder should have the format [video_name].[part_number_integer].mp4
#
# License: This script is provided under the Apache 2.0 License.
#


# Define the directory where the video files are located
videoDirectory="./video_parts"

# Loop through the .mp4 files in the directory and collect them in an array
files=()
while IFS= read -r -d $'\0' file; do
    files+=("$file")
done < <(find "$videoDirectory" -name "*.mp4" -print0)

# Check if any video files were found
if [ ${#files[@]} -gt 0 ]; then
    # Extract the [video_name] from the first video for the output file name
    firstFile="${files[0]}"
    videoName=$(basename "$firstFile" | cut -d '.' -f 1)

    # Sort the files based on the [number] part of the name
    sortedFiles=($(printf "%s\n" "${files[@]}" | sort -t. -k2,2n))

    outputFileName="concat.txt"
    outputVideoName="${videoName}.concat.mp4"

    # Loop through the sorted files and append each wrapped string directly to the output file
    for file in "${sortedFiles[@]}"; do
        printf "file '%s'\n" "$file" >> "$outputFileName"
    done
    echo "Video list has been created in '$outputFileName'"

    # Initialize the FFmpeg command for concatenation and optimization
    ffmpegCmd="ffmpeg -f concat -safe 0 -i concat.txt -vf setpts=PTS-STARTPTS -c:v libx264 -preset fast -tune film -crf 23 -c:a aac -strict experimental -b:a 192k"


    # Concatenate the video parts and optimize for the web
    eval "$ffmpegCmd" "$outputVideoName"

    # Clean up temporary files
    rm concat.txt

    echo "Video parts concatenated and optimized for web to $outputFileName"


else
    echo "No video files found in the '$videoDirectory' directory."
fi




