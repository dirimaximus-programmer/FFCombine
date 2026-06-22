@echo off
:: Module: MinGW64 Portable Compiler Builder
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

set "MINGW_ENV=.\mingw64\mingwvars.bat"

if not exist "%MINGW_ENV%" (
    echo [ERROR] Setup file %MINGW_ENV% not found!
    pause
    exit /b
)

:scan_files
cls
echo ======================================================
echo          CODE BUILDER (MinGW64 Environment)
echo ======================================================
echo  Available files for compilation in current folder:
echo ------------------------------------------------------
set "count=0"
for %%f in (*.c *.cpp) do (
    set /a count+=1
    set "source_!count!=%%f"
    echo  !count!. %%f
)
echo ------------------------------------------------------
if %count%==0 echo  Source files (.c or .cpp) not found. & pause & exit /b

set /p choice="Select file for building (0 - Exit): "
if "%choice%"=="0" exit /b
if "%choice%"=="" goto scan_files
if defined source_%choice% (
    set "src_file=!source_%choice%!"
    goto compile_options
) else (
    goto scan_files
)

:compile_options
cls
echo Selected file: %src_file%
echo ------------------------------------------------------
echo  1. Fast Build (Release)
echo  2. Build with Debug Info (-g)
echo  3. Back to file selection
echo ------------------------------------------------------
choice /c 123 /n /m "Select action (1-3): "
:: Жесткая проверка errorlevel от большего к меньшему
if errorlevel 3 goto scan_files
if errorlevel 2 (
    set "flags=-g"
    goto do_compile
)
if errorlevel 1 (
    set "flags="
    goto do_compile
)

:do_compile
:: Определяем компилятор по расширению файла
set "ext=%src_file:~-4%"
if /i "%ext%"==".cpp" ( set "COMPILER=g++" ) else ( set "COMPILER=gcc" )

:: Извлекаем имя файла без расширения для имени .exe
for %%i in ("%src_file%") do set "output_name=%%~ni.exe"

cls
echo Compiling file %src_file% via %COMPILER%...
echo ------------------------------------------------------

:: Запуск компиляции внутри окружения MinGW
cmd /c "call "%MINGW_ENV%" && %COMPILER% "%src_file%" %flags% -o "%output_name%""

if %errorlevel% equ 0 (
    echo ------------------------------------------------------
    echo [SUCCESS] File successfully compiled to %output_name%
    echo.
    choice /c YN /n /m "Run compiled file right now? (Y/N): "
    if errorlevel 2 goto scan_files
    cls
    echo Running %output_name%...
    echo ------------------------------------------------------
    "%output_name%"
    echo ------------------------------------------------------
    pause
) else (
    echo ------------------------------------------------------
    echo [ERROR] Compilation failed. Check your code syntax.
    pause
)
goto scan_files
