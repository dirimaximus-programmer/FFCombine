@echo off
:: Project: ffcombine Hub
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

:main
cls
echo ======================================================
echo          FFCOMBINE v1.0.0
echo ======================================================
echo  1. FFmpeg Compilation (FFmpeg: View, Analyze, Convert)
echo  2. AI LLM (Llama.cpp: Chat, Server)
echo  3. GCC CODE BUILDER (MinGW64 GCC / G++ Environment)
echo  4. LLVM CODE BUILDER (Pure Clang / LLVM Cross-Compiler)
echo  5. YT-DOWNLIADER (YT-DLP: Advanced Media Downloader)
echo  6. URL DOWNLOADER (Wget: Fast URL File Downloader)
echo  7. GIT PORTABLE RUNNER (Bash / CMD Environment Selector)
echo  8. Exit
echo. 9. Credits
echo ======================================================
echo.

choice /c 123456789 /n /m "Select tool (1-9): "

if errorlevel 9 call .\credits.bat & goto main
if errorlevel 8 exit
if errorlevel 7 call .\git-combine.bat & goto main
if errorlevel 6 call .\wget-combine.bat & goto main
if errorlevel 5 call .\yt-downloader-combine.bat & goto main
if errorlevel 4 call .\clang-combine.bat & goto main
if errorlevel 3 call .\mingw-combine.bat & goto main
if errorlevel 2 call .\ai-combine.bat & goto main
if errorlevel 1 call .\ffmpeg-combine.bat & goto main

