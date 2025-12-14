@echo off
setlocal EnableExtensions

:: ===============================
:: mf — Minimal File Utility
:: ===============================

:: ---------------- help ----------------
if "%1"=="" goto :HELP
if /I "%1"=="help" goto :HELP

:: ---------------- open ----------------
if /I "%1"=="open" (
    if "%2"=="" exit /b 1
    start "" "%~2"
    exit /b 0
)

:: ---------------- edit ----------------
if /I "%1"=="edit" (
    if "%2"=="" exit /b 1
    if not exist "%~2" type nul > "%~2"
    notepad "%~2"
    exit /b 0
)

:: ---------------- rm ----------------
if /I "%1"=="rm" (
    if "%2"=="" exit /b 1
    if exist "%~2\" (
        rmdir /s /q "%~2"
    ) else (
        del /f /q "%~2"
    )
    exit /b 0
)

:: ---------------- cp ----------------
if /I "%1"=="cp" (
    if "%3"=="" exit /b 1
    if exist "%~2\" (
        xcopy "%~2" "%~3" /E /I /Y > nul
    ) else (
        copy "%~2" "%~3" > nul
    )
    exit /b 0
)

:: ---------------- mv ----------------
if /I "%1"=="mv" (
    if "%3"=="" exit /b 1
    move /Y "%~2" "%~3" > nul
    exit /b 0
)

:: ---------------- tree ----------------
if /I "%1"=="tree" (
    if "%2"=="" (
        tree
    ) else (
        tree "%~2"
    )
    exit /b 0
)

:: ---------------- print ----------------
if /I "%1"=="print" (
    if "%2"=="" exit /b 1
    if exist "%~2" type "%~2"
    exit /b 0
)

:: ---------------- ls ----------------
if /I "%1"=="ls" (
    if "%2"=="" (
        dir /b
    ) else (
        dir /b "%~2"
    )
    exit /b 0
)

:: =========================================================
:: FILE IN FOLDER
:: mf file.txt in folder [--stdin]
:: =========================================================
if /I "%2"=="in" (
    if "%3"=="" exit /b 1

    set "FILE=%~1"
    set "DIR=%~3"
    set "FULL=%DIR%\%FILE%"

    if not exist "%DIR%" mkdir "%DIR%"

    if /I "%4"=="--stdin" (
        echo Paste content. Press Ctrl+Z then Enter to save.
        copy con "%FULL%" > nul
        exit /b 0
    )

    if not exist "%FULL%" type nul > "%FULL%"
    notepad "%FULL%"
    exit /b 0
)

:: =========================================================
:: FILE IN CURRENT DIR
:: =========================================================
if /I "%2"=="--stdin" (
    echo Paste content. Press Ctrl+Z then Enter to save.
    copy con "%~1" > nul
    exit /b 0
)

:: ---------------- single arg ----------------
echo %1 | find "." > nul
if errorlevel 1 (
    mkdir "%~1" 2>nul
    exit /b 0
) else (
    if not exist "%~1" type nul > "%~1"
    notepad "%~1"
    exit /b 0
)

:HELP
echo mf — Minimal File Utility
echo.
echo Usage:
echo   mf file.txt
echo   mf file.txt --stdin
echo   mf file.txt in folder
echo   mf file.txt in folder --stdin
echo   mf folder
echo   mf open path
echo   mf edit file
echo   mf rm path
echo   mf cp src dest
echo   mf mv src dest
echo   mf ls [path]
echo   mf tree [path]
echo   mf print file
echo   mf help
exit /b 0
