@echo off
:: Module: Universal Git Terminal Launcher (Bash / CMD Engine)
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul

:: Жестко привязываем корень проекта к локальной папке
set "ROOT_DIR=%~dp0"
set "GIT_ENGINE=%~dp0git\git-cmd.exe"

if not exist "%GIT_ENGINE%" (
    echo [ERROR] Git infrastructure not found at: %GIT_ENGINE%
    pause
    exit /b
)

:git_menu
cls
echo ======================================================
echo          AUTO-GIT (Environment Selection)
echo ======================================================
echo  1. Launch Git Bash (Linux Interface)
echo  2. Launch Git CMD  (Windows Interface)
echo  3. Back to main menu
echo ======================================================
echo.

choice /c 123 /n /m "Select environment shell (1-3): "
if errorlevel 3 exit /b
if errorlevel 2 goto launch_cmd
if errorlevel 1 goto launch_bash
goto git_menu

:launch_bash
cls
echo [INFO] Initializing Git Bash environment...
:: Запускаем базовый git-cmd и заставляем его бесшумно подтянуть bash во внешнем окне
start "Git Bash Terminal" "%GIT_ENGINE%" --command=usr/bin/bash.exe --login -i
goto end_sequence

:launch_cmd
cls
echo [INFO] Initializing Git CMD environment...
:: Открываем чистый git-cmd в оригинальном Windows-стиле с прописанными путями
start "Git CMD Terminal" "%GIT_ENGINE%"
goto end_sequence

:end_sequence
echo ------------------------------------------------------
echo  Session successfully initialized in a separate window.
echo ------------------------------------------------------
pause
exit /b

