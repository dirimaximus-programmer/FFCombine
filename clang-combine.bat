@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "LLVM_BIN=.\llvm-mingw\bin"

if not exist "%LLVM_BIN%\clang.exe" (
    echo [ERROR] clang.exe not found in %LLVM_BIN%
    pause
    exit /b
)

set "src_file="
for %%f in (*.c *.cpp) do (
    set "src_file=%%f"
)

if "%src_file%"=="" (
    echo [ERROR] No .c or .cpp files found in this folder.
    pause
    exit /b
)

echo [INFO] Found source file: %src_file%
echo [INFO] Compiling for all architectures, please wait...
echo ---------------------------------------------------

for %%i in ("%src_file%") do set "base_name=%%~ni"
for %%i in ("%src_file%") do set "file_ext=%%~xi"

if /i "%file_ext%"==".cpp" (
    set "COMPILER=%LLVM_BIN%\clang++.exe"
) else (
    set "COMPILER=%LLVM_BIN%\clang.exe"
)

echo [1/5] Compiling x86_64 (64-bit PC)...
"%COMPILER%" -target x86_64-w64-mingw32 "%src_file%" -O2 -Wall -o "%base_name%_x64.exe"

echo [2/5] Compiling i686 (32-bit PC)...
"%COMPILER%" -target i686-w64-mingw32 "%src_file%" -O2 -Wall -o "%base_name%_x86.exe"

echo [3/5] Compiling AArch64 (ARM 64-bit)...
"%COMPILER%" -target aarch64-w64-mingw32 "%src_file%" -O2 -Wall -o "%base_name%_arm64.exe"

echo [4/5] Compiling ARM64EC (ARM64 Windows Emulation)...
"%COMPILER%" -target arm64ec-w64-mingw32 "%src_file%" -O2 -Wall -o "%base_name%_arm64ec.exe"

echo [5/5] Compiling ARMv7 (ARM 32-bit)...
"%COMPILER%" -target armv7-w64-mingw32 "%src_file%" -O2 -Wall -o "%base_name%_arm32.exe"

echo ---------------------------------------------------
echo [SUCCESS] Compilation completed. Check your folder!
pause
