@echo off
setlocal EnableExtensions

:: =========================================================
:: 
:: Commands:
::   mf open path                - Open file or folder
::   mf edit file                - Open file in Notepad (creates if missing)
::   mf rm path                  - Remove file or folder recursively
::   mf cp src dest              - Copy file or folder
::   mf mv src dest              - Move or rename file or folder
::   mf tree [path]              - Display directory tree
::   mf print file               - Print file contents to console
::   mf ls [path]                - List directory contents
::   mf folder in file           - Create file inside folder and open in Notepad
::   mf file                     - Create or edit file in Notepad
::   mf folder                   - Create folder
::   mf help                     - Display this help
::
:: If no command is given, 'mf' displays this help.

:: ---------------------------------------------------------
:: Dispatch: detect command or default actions

if "%1"=="" goto :HELP
if /I "%1"=="help" goto :HELP
if /I "%1"=="open" goto :OPEN
if /I "%1"=="edit" goto :EDIT
if /I "%1"=="rm" goto :RM
if /I "%1"=="cp" goto :CP
if /I "%1"=="mv" goto :MV
if /I "%1"=="tree" goto :TREE
if /I "%1"=="print" goto :PRINT
if /I "%1"=="ls" goto :LS

:: Nested file creation (folder in file)
if /I "%2"=="in" goto :NESTED

:: Single argument (folder or file)
if "%2"=="" goto :SINGLE

:: Unknown command or wrong syntax
goto :UNKNOWN

:: ---------------------------------------------------------
:OPEN
    if "%2"=="" (
        echo Usage: mf open path
        exit /b 1
    )
    start "" "%~2"
    exit /b 0

:EDIT
    if "%2"=="" (
        echo Usage: mf edit file
        exit /b 1
    )
    if not exist "%~2" type nul > "%~2"
    notepad "%~2"
    exit /b 0

:RM
    if "%2"=="" (
        echo Usage: mf rm path
        exit /b 1
    )
    if exist "%~2\" (
        rmdir /s /q "%~2"
    ) else (
        del /f /q "%~2"
    )
    exit /b 0

:CP
    if "%3"=="" (
        echo Usage: mf cp source dest
        exit /b 1
    )
    if exist "%~2\" (
        xcopy "%~2" "%~3" /E /I /Y > nul
    ) else (
        copy "%~2" "%~3" > nul
    )
    exit /b 0

:MV
    if "%3"=="" (
        echo Usage: mf mv source dest
        exit /b 1
    )
    move /Y "%~2" "%~3" > nul
    exit /b 0

:TREE
    if "%2"=="" (
        tree
    ) else (
        tree "%~2"
    )
    exit /b 0

:PRINT
    if "%2"=="" (
        echo Usage: mf print file
        exit /b 1
    )
    if exist "%~2" (
        type "%~2"
    ) else (
        echo File not found: %~2
    )
    exit /b 0

:LS
    if "%2"=="" (
        dir /b
    ) else (
        dir /b "%~2"
    )
    exit /b 0

:NESTED
    if "%3"=="" (
        echo Usage: mf folder in file
        exit /b 1
    )
    set "DIR=%~1"
    set "FILE=%~3"
    set "FULL=%DIR%\%FILE%"
    if not exist "%DIR%" mkdir "%DIR%"
    if "%4"=="--stdin" (
        if not exist "%FULL%" type nul > "%FULL%"
        echo Pasting content into "%FULL%". Press Ctrl+Z then Enter when done.
        copy con "%FULL%" > nul
        echo File created
        exit /b 0
    )
    if not exist "%FULL%" type nul > "%FULL%"
    notepad "%FULL%"
    echo Opened %FULL% for editing
    exit /b 0

:SINGLE
    :: If user passes --stdin after a file name, read from stdin
    if /I "%2"=="--stdin" (
        if "%~1"=="" (
            echo Usage: mf file [--stdin]
            exit /b 1
        )
        if not exist "%~1" type nul > "%~1"
        echo Pasting content into "%~1". Press Ctrl+Z then Enter when done.
        copy con "%~1" > nul
        echo File created
        exit /b 0
    )
    :: Determine if argument has a dot (file) or not (folder)
    echo %1 | find "." > nul
    if errorlevel 1 (
        mkdir "%~1" 2>nul
        echo Folder created
    ) else (
        if not exist "%~1" type nul > "%~1"
        notepad "%~1"
        echo Opened %~1 for editing
    )
    exit /b 0

:UNKNOWN
    echo Unknown command or invalid syntax. Type "mf help" for usage.
    exit /b 1

:HELP
echo.
echo Commands:
echo   mf open path                - open file or folder
echo   mf edit file                - edit file in Notepad (creates if missing)
echo   mf rm path                  - remove file or folder recursively
echo   mf cp src dest              - copy file or folder
echo   mf mv src dest              - move or rename file or folder
echo   mf tree [path]              - show directory tree
echo   mf print file               - print file contents to console
echo   mf ls [path]                - list directory contents
echo   mf folder in file           - create file inside folder and open in Notepad
echo   mf file                     - create/edit file in Notepad
echo   mf folder                   - create folder
echo   mf help                     - show this help
exit /b 0
