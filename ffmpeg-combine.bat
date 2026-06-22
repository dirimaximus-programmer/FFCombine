@echo off
:: Module: FFmpeg Root Frontend (Strict System PATH Resolution)
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul

:: Добавляем относительный путь к бинарникам в локальный PATH текущей сессии
:: Теперь система железно увидит ffmpeg.exe, ffplay.exe и ffprobe.exe напрямую
set "PATH=.\bin\ffmpeg;%PATH%"

:main_menu
cls
echo ======================================================
echo             MEDIA MODULE (FFmpeg Frontend)
echo ======================================================
echo  1. WATCH video (via ffplay)
echo  2. TECHNICAL ANALYSIS (via ffprobe)
echo  3. CONVERT video (via ffmpeg)
echo  4. Back to main menu
echo ======================================================
echo.

choice /c 1234 /n /m "Select action (1-4): "
if errorlevel 4 exit /b
if errorlevel 3 goto ffmpeg_menu
if errorlevel 2 goto probe_menu
if errorlevel 1 goto player_menu
goto main_menu

:player_menu
cls
echo  Available video files for playback:
echo ------------------------------------------------------
set "count=0"
for %%f in (*.mkv *.mp4 *.avi *.webm *.mov) do (
    set /a count+=1
    set "file_!count!=%%f"
    echo  !count!. %%f
)
echo ------------------------------------------------------
if %count%==0 echo  Media files not found. & pause & goto main_menu
set "choice="
set /p choice="Select video number (0 - Back): "
if "!choice!"=="0" goto main_menu
if "!choice!"=="" goto player_menu

if defined file_!choice! (
    for /f "delims=" %%i in ("!file_%choice%!") do set "target_media=%%i"
    cls
    echo [INFO] Playing: !target_media!
    ffplay -autoexit "!target_media!"
    goto player_menu
) else (
    goto player_menu
)

:probe_menu
cls
echo  Select file for technical analysis:
echo ------------------------------------------------------
set "count=0"
for %%f in (*.mkv *.mp4 *.avi *.webm *.mov) do (
    set /a count+=1
    set "file_!count!=%%f"
    echo  !count!. %%f
)
echo ------------------------------------------------------
if %count%==0 echo  Media files not found. & pause & goto main_menu
set "choice="
set /p choice="Select number (0 - Back): "
if "!choice!"=="0" goto main_menu
if "!choice!"=="" goto probe_menu

if defined file_!choice! (
    cls
    for /f "delims=" %%i in ("!file_%choice%!") do set "target_media=%%i"
    echo [INFO] Running technical analysis for: !target_media!
    echo ------------------------------------------------------
    
    :: Чистый вызов ffprobe без сломанных префиксов путей
    ffprobe -v error -show_format -show_streams "!target_media!"
    
    echo ------------------------------------------------------
    pause
    goto probe_menu
) else (
    goto probe_menu
)

:ffmpeg_menu
cls
echo  Select file for processing:
echo ------------------------------------------------------
set "count=0"
for %%f in (*.mkv *.mp4 *.avi *.webm *.mov) do (
    set /a count+=1
    set "file_!count!=%%f"
    echo  !count!. %%f
)
echo ------------------------------------------------------
if %count%==0 echo  Media files not found. & pause & goto main_menu
set "choice="
set /p choice="Select number (0 - Back): "
if "%choice%"=="0" goto main_menu
if "!choice!"=="" goto ffmpeg_menu

if defined file_!choice! (
    for /f "delims=" %%i in ("!file_%choice%!") do set "source_file=%%i"
    goto ffmpeg_actions
) else (
    goto ffmpeg_menu
)

:ffmpeg_actions
cls
echo Selected file: %source_file%
echo ------------------------------------------------------
echo  1. Remux to MP4 (Lossless / No quality loss)
echo  2. Remux to MKV (Lossless / No quality loss)
echo  3. Extract audio track (to MP3 format)
echo  4. Back
echo ------------------------------------------------------
choice /c 1234 /n /m "Select action (1-4): "
if errorlevel 4 goto ffmpeg_menu

:: Извлекаем имя файла без расширения
for %%i in ("%source_file%") do set "base_name=%%~ni"

if errorlevel 3 (
    ffmpeg -i "%source_file%" -q:a 0 -map a -y "audio_%base_name%.mp3"
    goto ffmpeg_end
)
if errorlevel 2 (
    ffmpeg -i "%source_file%" -c copy -y "converted_%base_name%.mkv"
    goto ffmpeg_end
)
if errorlevel 1 (
    ffmpeg -i "%source_file%" -c copy -y "converted_%base_name%.mp4"
    goto ffmpeg_end
)

:ffmpeg_end
echo.
echo Operation completed successfully!
pause
goto main_menu
