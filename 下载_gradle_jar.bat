@echo off
chcp 65001 >nul
title 下载 Gradle Wrapper

echo ========================================
echo   下载 gradle-wrapper.jar
echo ========================================
echo.

set WRAPPER_DIR=android\gradle\wrapper
set JAR_FILE=%WRAPPER_DIR%\gradle-wrapper.jar
set DOWNLOAD_URL=https://github.com/gradle/gradle/raw/v8.3.0/gradle/wrapper/gradle-wrapper.jar

echo 正在下载 gradle-wrapper.jar...
echo.

if not exist "%WRAPPER_DIR%" (
    mkdir "%WRAPPER_DIR%"
)

powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%JAR_FILE%'}"

if exist "%JAR_FILE%" (
    echo.
    echo ========================================
    echo   ✅ 下载成功！
    echo ========================================
    echo.
    echo 文件位置: %CD%\%JAR_FILE%
    echo.
    echo 下一步：
    echo 1. 将整个 flutter_player 文件夹上传到 GitHub
    echo 2. GitHub 会自动编译 APK
    echo.
) else (
    echo.
    echo ========================================
    echo   ❌ 下载失败
    echo ========================================
    echo.
    echo 请手动下载：
    echo %DOWNLOAD_URL%
    echo.
    echo 然后放入：
    echo %CD%\%WRAPPER_DIR%\gradle-wrapper.jar
    echo.
)

pause
