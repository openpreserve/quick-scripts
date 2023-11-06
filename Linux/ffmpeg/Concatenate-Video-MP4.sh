#!/bin/bash

#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Concatenate-Video

# About
# This script will join mp4 files together and then transcode the combined file into a format sutible for streaming over HTTP on the web.
# This script expects a folder called video_parts - but you can edit this below.

# Define the folder path where the video parts are located
videoFolder="video_parts"

# Initialize an array to hold the file paths
declare -A files

# Loop through the files in the folder
for file in "$videoFolder"/*.mp4; do
    filename=$(basename "$file")
    partNumber=$(echo "$filename" | cut -d '.' -f 2)
    
    # Append the file path to the array using the part number as the index
    files["$partNumber"]="$file"
done

# Determine the output filename based on the first input file
firstPartNumber="${!files[@]}"
outputFilename=$(basename "${files[$firstPartNumber]%.*}").concatenated.mp4

# Create a list of sorted file parts
sortedParts=()
for ((i=1; i<=${#files[@]}; i++)); do
    sortedParts+=("${files[$i]}")
done

# Initialize the FFmpeg command for concatenation and optimization
ffmpegCmd="ffmpeg -f concat -safe 0 -i concat.txt -vf setpts=PTS-STARTPTS -c:v libx264 -preset fast -tune film -crf 23 -c:a aac -strict experimental -b:a 192k"

# Create a text file (concat.txt) with the list of input files in sorted order
> concat.txt
for file in "${sortedParts[@]}"; do
    echo "file '$file'" >> concat.txt
done

# Concatenate the video parts and optimize for the web
eval "$ffmpegCmd" "$outputFilename"

# Clean up temporary files
rm concat.txt

echo "Video parts concatenated and optimized for web to $outputFilename"
