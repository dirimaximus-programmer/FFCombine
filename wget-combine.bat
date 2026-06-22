@echo off
:: Module: Wget Downloader
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

set "WGET=.\wget\wget.exe"

if not exist "%WGET%" (
    echo [ERROR] Executable file %WGET% is not found
    pause
    exit /b
)

:net_menu
cls
echo ======================================================
echo          NETWORK (Wget Downloader)
echo ======================================================
echo.
set /p "url=Insert URL-link for download (or 0 to exit): "
if "%url%"=="0" exit /b
if "%url%"=="" goto net_menu

cls
echo Downloading file: %url%
echo ------------------------------------------------------
%WGET% --no-check-certificate --show-progress "%url%"

:: Фиксируем код возврата Wget прямо на выходе
set "WGET_RES=%errorlevel%"
echo ------------------------------------------------------
echo.

:: Анализ точного диагноза
if %WGET_RES% equ 0 (
    echo [SUCCESS] Download completed successfully.
    goto end_sequence
)
if %WGET_RES% equ 1 (
    echo [ERROR] Generic error occurred.
    goto end_sequence
)
if %WGET_RES% equ 2 (
    echo [ERROR] Parse error - invalid command line options.
    goto end_sequence
)
if %WGET_RES% equ 3 (
    echo [ERROR] File I/O error - cannot write file to disk.
    goto end_sequence
)
if %WGET_RES% equ 4 (
    echo [ERROR] Network failure - connection refused or timed out.
    goto end_sequence
)
if %WGET_RES% equ 5 (
    echo [ERROR] SSL verification failure.
    goto end_sequence
)
if %WGET_RES% equ 6 (
    echo [ERROR] Username or password authentication failure.
    goto end_sequence
)
if %WGET_RES% equ 7 (
    echo [ERROR] Protocol error.
    goto end_sequence
)
if %WGET_RES% equ 8 (
    echo [ERROR] Server issued an error response (e.g., 404 Not Found or 503).
    goto end_sequence
)

:: На случай редких недокументированных кодов
echo [ERROR] Download failed with unknown exit code: %WGET_RES%

:end_sequence
echo.
pause
goto net_menu

