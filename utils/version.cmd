:: Name:     version.cmd
:: Purpose:  set the version as an environment variable
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 07 16 - initial version
::           2018 08 21 - semantic versioning added
::           2019 05 29 - new method for setting version added 

:: Using Semantic Versioning (2.0.0) and adding [.development] 
:: Major.Minor[.patch][.development]
::
:: In summary:
:: Major releases indicate a break in backward compatibility.
:: - change of folder structure
:: - change of file name of generic files
::
:: Minor releases indicate the addition of new features or a significant change to existing features.
:: - Language files added
::
:: Patch releases indicate that bugs have been fixed.
::
:: Development version used to enable auto update feature within Joomla!
::

:: Retrieving build version parameters for default settings
::
SET majorversion=""
SET minorversion=""
SET patchversion=""
SET devversion=""

IF NOT EXIST "..\..\code\src\_version.txt" (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] file ..\code\src\_version.txt with version parameters doesn't exist ...
   GOTO ERROR_EXIT_SUBSCRIPT
)

:: Read parameters file
:: Inspiration: http://www.robvanderwoude.com/battech_inputvalidation_commandline.php#ParameterFiles
::              https://ss64.com/nt/for_f.html
::
:: Remove comment lines
TYPE "..\..\code\src\_version.txt" | FINDSTR /v # >"..\..\_bin\version_clean.txt"
:: Check parameter file for unwanted characters
FINDSTR /R "( ) & ' ` \"" "..\..\_bin\version_clean.txt" > NUL
IF NOT ERRORLEVEL 1 (
	SET ERROR_MESSAGE=[ERROR] [%~n0 ] the parameter file contains unwanted characters, and cannot be parsed ...
	GOTO ERROR_EXIT
)
:: Only parse the file if no unwanted characters were found
FOR /F "tokens=1,2 delims==" %%A IN ('FINDSTR /R /X /C:"[^=][^=]*=.*" "..\..\_bin\version_clean.txt" ') DO (
	SET %%A=%%B
)

IF "%majorversion%" == "" (
	ECHO [INFO ] [%~n0 ] the majorversion is not defined. Setting it to 0 ...
	SET majorversion=0
)
IF "%minorversion%" == "" (
	ECHO [INFO ] [%~n0 ] the minorversion is not defined. Setting it to 0 ...
	SET minorversion=0
)
IF "%patchversion%" == "" (
	ECHO [INFO ] [%~n0 ] the patchversion is not defined. Setting it to 0 ...
	SET patchversion=0
)
IF "%devversion%" == "" (
	ECHO [INFO ] [%~n0 ] development version is not defined. Leaving it like that ...
)

:: Remove cleaned version file
del "..\..\_bin\version_clean.txt"

SET version=v%majorversion%.%minorversion%.%patchversion%.%devversion%
IF "%devversion%" == "" (
	SET version=v%majorversion%.%minorversion%.%patchversion%
)

GOTO CLEAN_EXIT_SUBSCRIPT

:ERROR_EXIT_SUBSCRIPT
ECHO *******************
ECHO %ERROR_MESSAGE%
ECHO *******************
::timeout /T 5
EXIT /B 1

:CLEAN_EXIT_SUBSCRIPT   
::timeout /T 5
EXIT /B 0
