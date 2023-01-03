@echo off

:: needs the three parameters - otherwise show the help
if [%1]==[] goto help
if [%2]==[] goto help
if [%3]==[] goto help

:: echo back the parameters 
echo.
echo VeraPDF (.bat):     %1
echo Source Folder:      %2
echo Destination Folder: %3 

:: set some vars
set source_path=%2
set dest_path=%3



:: remove trailing slash from path, so we can combine paths later!
IF %dest_path:~-1%==\ SET dest_path=%dest_path:~0,-1%




		:: In the loop below some of these are valid string manipulations... This comment explains what they are, so the code is easier to read
		:: The line below would just send every pdf file through the .bat with the results displayed in the console
		:: verapdf.bat "%%F"


		:: rem filename
		:: echo %%~nF  
		:: rem full path and extension
				:: echo %%F
		:: rem full path
		:: echo %%~dpF
		:: rem path without drive
		:: echo %%~pF
		:: echo 
		:: constructed output filename
				:: echo %dest_path%%%~pF%%~nF.xml

		:: check if folder exists for the result



for /R %source_path% %%F in (*.pdf) do (

	if exist %dest_path%%%~pF\ (
		echo %dest_path%%%~pF
	) else (
  		md %dest_path%%%~pF
  		echo md %dest_path%%%~pF
	)

	%1 "%%F" > "%dest_path%%%~pF%%~nF.xml"
)

goto endapp


:help
:: cls
echo.
echo Help: PDF_batch_verify.bat
echo.
echo Batch process PDF files with veraPDF and pipe the resulting XML into a seperate
echo folder. You need to pass in the path to the verapdf.bat (that should be in your
echo installation folder for verapdf). The folder with the PDFs. And the destination
echo folder where the results XMLs will be stored.
echo.
echo The output files will have a similar name to the source file. But with the XML
echo extension.
echo.
echo Usage:
echo.
echo         PDF_Batch_verify.bat [verapdf] [source-dir] [destination-dir]
echo.
echo For Example:
echo PDF_Batch_verify.bat c:\veraPDF\verapdf.bat c:\data\source_PDF\ c:\data\results
echo.
echo.

:endapp
echo Goodbye

@pause>nul
