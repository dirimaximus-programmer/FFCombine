@echo off
:: Module: Advanced YT-DLP Downloader
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

:: Указываем пути к исполняемым файлам в текущей папке модуля
set "YTDLP=%~dp0yt-dlp-ffmpeg\yt-dlp.exe"

if not exist "%YTDLP%" (
    echo [ERROR] File %YTDLP% dont exist in folder yt-dlp-ffmpeg!
    pause
    exit /b
)

:main_menu
cls
echo ======================================================
echo             PORTABLE LOADER (yt-dlp)
echo ======================================================
echo  1. DOWNLOAD VIDEO (With the choice of track and quality)
echo  2. DOWNLOAD AUDIO-ONLY (Convertation to MP3/M4A)
echo  3. Exit to main menu
echo ======================================================
echo.

choice /c 123 /n /m "Choose type of download (1-3): "
if errorlevel 3 exit /b
if errorlevel 2 set "DOWNLOAD_TYPE=audio" & goto download_menu
if errorlevel 1 set "DOWNLOAD_TYPE=video" & goto download_menu

:download_menu
cls
echo ======================================================
echo                 SETTING UP THE AUDIO TRACK
echo ======================================================
echo  1. Download RUSSIAN audio track / translate (if available)
echo  2. Download ORIGINAL audio track (no changes)
echo  3. Return to menu
echo ======================================================
echo.

choice /c 123 /n /m "Choose audio mode (1-3): "
if errorlevel 3 goto main_menu
if errorlevel 2 set "AUDIO_MODE=original" & goto wizard
if errorlevel 1 set "AUDIO_MODE=russian" & goto wizard

:wizard
cls
echo ======================================================
echo               SETTING UP DOWNLOAD PARAMETERS
echo ======================================================
echo.
set /p url="Step 1. Insert a link to a video or playlist: "
if "%url%"=="" goto main_menu

if "%DOWNLOAD_TYPE%"=="audio" goto wizard_audio

:wizard_video
echo.
echo Step 2. Select the maximum resolution limit:
echo  1. 4K UltraHD (2160p)
echo  2. 2K QHD (1440p)
echo  3. Full HD (1080p)
echo  4. HD (720p)
echo ------------------------------------------------------
choice /c 1234 /n /m "Ваш выбор (1-4): "
if errorlevel 4 set "RES_LIMIT=[height<=720]"
if errorlevel 3 set "RES_LIMIT=[height<=1080]"
if errorlevel 2 set "RES_LIMIT=[height<=1440]"
if errorlevel 1 set "RES_LIMIT=[height<=2160]"

echo.
choice /c 12 /n /m "Step 3. Choose file container (1 - MKV, 2 - MP4): "
if errorlevel 2 set "FORMAT_ARG=mp4"
if errorlevel 1 set "FORMAT_ARG=mkv"

echo.
choice /c 12 /n /m "Step 4. Embed the cover (preview) inside the video file? (1 - Yes, 2 - No): "
if errorlevel 2 set "THUMB_ARG="
if errorlevel 1 set "THUMB_ARG=--embed-thumbnail"
goto wizard_speed

:wizard_audio
echo.
choice /c 12 /n /m "Шаг 2. Выберите аудиоформат (1 - MP3, 2 - M4A): "
if errorlevel 2 set "AUDIO_FORMAT=m4a"
if errorlevel 1 set "AUDIO_FORMAT=mp3"
goto wizard_speed

:wizard_speed
echo.
choice /c 12 /n /m "Step 5. Limit download speed? (1 - No, 2 - Yes, up to 10 MB/s): "
if errorlevel 2 set "SPEED_ARG=-r 10M"
if errorlevel 1 set "SPEED_ARG="

:: Базовые аргументы (активация локального deno.exe и субтитров)
set "COMMON_ARGS=--js-runtimes deno --write-subs --embed-subs %THUMB_ARG% %SPEED_ARG% --yes-playlist"
set "FILENAME_FORMAT=-o "%%(playlist_index)s - %%(title)s.%%(ext)s""

cls
echo ======================================================
echo            START DOWNLOAD (Local engine)
echo ======================================================
echo Link: %url%
echo.

if "%DOWNLOAD_TYPE%"=="audio" goto do_audio
if "%AUDIO_MODE%"=="original" goto do_original
if "%AUDIO_MODE%"=="russian" goto do_russian

:do_russian
%YTDLP% --extractor-args "youtube:player_client=all;lang=ru" -f "bestvideo%RES_LIMIT%+bestaudio[language=ru]/bestvideo%RES_LIMIT%+bestaudio[format_note*=Русский]/best%RES_LIMIT%[language=ru]/best%RES_LIMIT%[format_note*=Русский]/best" --merge-output-format %FORMAT_ARG% %COMMON_ARGS% %FILENAME_FORMAT% "%url%"
goto download_end

:do_original
%YTDLP% --extractor-args "youtube:player_client=all" -f "bestvideo%RES_LIMIT%+bestaudio/best%RES_LIMIT%" --sub-langs "en.*,ru.*" --merge-output-format %FORMAT_ARG% %COMMON_ARGS% %FILENAME_FORMAT% "%url%"
goto download_end

:do_audio
%YTDLP% -x --audio-format %AUDIO_FORMAT% --audio-quality 0 %COMMON_ARGS% %FILENAME_FORMAT% "%url%"
goto download_end

:download_end
echo.
echo ========================================================================
echo The process is complete! The files have been saved in the script folder.
echo ========================================================================
pause
goto main_menu
