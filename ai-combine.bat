@echo off
:: Module: Llama.cpp Frontend
:: License: CC0 - Public Domain
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

:select_backend
cls
echo ======================================================
echo          НЕЙРОСЕТЬ (Llama.cpp Frontend)
echo ======================================================
echo  Выберите аппаратный движок для запуска:
echo  1. CPU Режим (Универсальный)
echo  2. Vulkan Режим (Для видеокарт AMD/Intel/Nvidia)
echo  3. Назад в главное меню
echo ======================================================
echo.

choice /c 123 /n /m "Выберите вариант (1-3): "
if errorlevel 3 exit /b
if errorlevel 2 set "LLAMA_DIR=.\llama\vulkan" & goto select_model
if errorlevel 1 set "LLAMA_DIR=.\llama\cpu" & goto select_model

:select_model
if not exist "!LLAMA_DIR!\llama-cli.exe" (
    echo [ОШИБКА] Файл !LLAMA_DIR!\llama-cli.exe не найден!
    pause
    goto select_backend
)

cls
echo  Доступные модели (.gguf) в папке инструмента:
echo ------------------------------------------------------
set "count=0"
for %%f in ("!LLAMA_DIR!\*.gguf") do (
    set /a count+=1
    set "model_!count!=%%f"
    echo  !count!. %%~nxf
)
echo ------------------------------------------------------
if %count%==0 echo  Модели .gguf не найдены. Скопируйте их в папки llama\cpu или llama\vulkan & pause & goto select_backend

set /p choice="Выберите номер модели (0 - Назад): "
if "%choice%"=="0" goto select_backend
if "%choice%"=="" goto select_model
if defined model_%choice% (
    set "target_model=!model_%choice%!"
    goto ai_actions
) else (
    goto select_model
)

:ai_actions
cls
echo Выбрана модель: %target_model%
echo Движок: !LLAMA_DIR!
echo ------------------------------------------------------
echo  1. Запустить интерактивный ЧАТ (в консоли)
echo  2. Запустить локальный API-сервер
echo  3. Назад
echo ------------------------------------------------------
choice /c 123 /n /m "Выберите действие (1-3): "
if errorlevel 3 goto select_model
if errorlevel 2 (
    cls
    echo Запуск сервера на http://127.0.0.1:8080 ...
    "!LLAMA_DIR!\llama-server.exe" -m "%target_model%" -c 2048
    pause
    goto ai_actions
)
if errorlevel 1 (
    cls
    "!LLAMA_DIR!\llama-cli.exe" -m "%target_model%" -c 2048 -cnv
    pause
    goto ai_actions
)
