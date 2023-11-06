@echo off

::   http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing,
:: software distributed under the License is distributed on an
:: "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
:: KIND, either express or implied. See the License for the
:: specific language governing permissions and limitations
:: under the License.
::
:: Concatenate-Video

:: # About
:: This script will join mp4 files together and then transcode the combined file into a format sutible for streaming over HTTP on the web.
:: 
:: 
:: ## Usage
:: The script will look for your videos in the video_parts folder, and the output will appear here in the root folder.
:: The file parts will need to be named correctly. 
:: The format of the filenames needs to be:
:: [Filename].[part-number].mp4
:: 
:: So the important part is the number. The periods/full-stops are used to extract the number, and the numbers need to start at 1, and count up.
:: for example:
:: 
:: Webinar.1.mp4
:: Webinar.2.mp4
:: ...
:: 
:: Put your correctly named files in the folder, and then double click or otherwise run the script.
:: 
:: When the process is comeplete there should be a file named:
:: [Filename].concatanated.mp4 
:: In the same folder as the script.
:: 
:: 
:: ## Notes
:: This script uses ffmpeg, so you need to have this installed first. If ffmpeg is installed and the script complains that it cannot find ffmpeg, then you need to add it to the system path, or edit the script to explicitly point to the executable.

setlocal enabledelayedexpansion

rem Define the folder path where the video parts are located
set "videoFolder=video_parts"

rem Initialize an array to hold the file paths
set "files="

rem Loop through the files in the folder
for %%i in ("%videoFolder%\*.mp4") do (
    rem Extract the filename without extension
    set "filename=%%~ni"
    
    rem Extract the part number from the filename
    for /f "tokens=2 delims=." %%a in ("!filename!") do (
        set "part_number=%%a"
        
        rem Append the file path to the array using the part number as an index
        set "files[!part_number!]=%%i"
    )
)

rem Initialize the FFmpeg command for concatenation and optimization
set "ffmpegCmd=ffmpeg -f concat -safe 0 -i concat.txt -c:v libx264 -preset fast -tune film -crf 23 -c:a aac -strict experimental -b:a 192k"

rem Create a text file (concat.txt) with the list of input files
(
    for /l %%n in (1, 1, 10) do (
        if defined files[%%n] (
            echo file '!files[%%n]!'
        )
    )
) > concat.txt

rem Determine the output filename based on the first input file
set "firstInputFile=!files[1]!"
for %%i in ("!firstInputFile!") do set "outputFilename=%%~ni_concatenated.mp4"

rem Concatenate the video parts and optimize for the web
%ffmpegCmd% "%outputFilename%"

rem Clean up temporary files
del concat.txt

echo Video parts concatenated and optimized for web to "%outputFilename%"
pause
