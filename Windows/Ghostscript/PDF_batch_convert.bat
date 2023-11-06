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
::
:: Batch Convert PDF files into PDF/A files
::
:: This script in its current form will convert source PDF to PDF/A using Ghostscript. Ghostscript needs to be installed on the system.
:: This script is a good candidate to do other batch PDF jobs like adding watermarks. Or to be rewritten in powershell, where it will be more readable too.

:: needs the three parameters - otherwise show the help
if [%1]==[] goto help
if [%2]==[] goto help
if [%3]==[] goto help

:: echo back the parameters 
echo.
echo Ghostscript exe:    %1
echo Source Folder:      %2
echo Destination Folder: %3 

:: set some vars
set source_path=%2
set dest_path=%3



:: remove trailing slash from path, so we can combine paths later!
IF %dest_path:~-1%==\ SET dest_path=%dest_path:~0,-1%


for /R %source_path% %%F in (*.pdf) do (

	if exist %dest_path%%%~pF\ (
		echo %dest_path%%%~pF
	) else (
  		md %dest_path%%%~pF
  		echo md %dest_path%%%~pF
	)

	call %1 -dPDFA -dBATCH -dNOPAUSE -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -o "%dest_path%%%~pF%%~nF.out.pdf" "%%F"
)

goto endapp


:help
:: cls
echo.
echo Help: PDF_batch_convert.bat
echo.
echo Batch process PDF files with Ghostscript and put the output PDF into a seperate
echo folder. You need to pass in the path to the gswin64c exe (Normally: c:\program 
echo files\gs\gs9.56.1\bin\ folder) The folder with the PDFs. And the destination
echo folder where the new resulting PDFs will be  stored.
echo.
echo The output files will have a similar name to the source file. But nested within 
echo the destination folder.
echo.
echo Ghostscript homepage: https://www.ghostscript.com/releases/index.html
echo.
echo Usage:
echo.
echo         PDF_Batch_convert.bat [gswin64c] [source-dir] [destination-dir]
echo.
echo For Example:
echo PDF_Batch_convert "c:\program files\gs\gs9.56.1\bin\gswin64c.exe" c:\data\pdf\ d:
echo.
echo.

:endapp
echo Goodbye

@pause>nul
