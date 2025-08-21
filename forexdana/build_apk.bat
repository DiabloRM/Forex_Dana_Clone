@echo off
echo 🚀 Building ForexDana APK...

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Build APK for release
echo 🔨 Building release APK...
flutter build apk --release

REM Check if build was successful
if %ERRORLEVEL% EQU 0 (
    echo ✅ APK built successfully!
    echo 📱 APK location: build\app\outputs\flutter-apk\app-release.apk
    
    REM Copy APK to a more accessible location
    copy "build\app\outputs\flutter-apk\app-release.apk" "ForexDana.apk"
    echo 📋 APK copied to: .\ForexDana.apk
    
    echo.
    echo 🎉 Your APK is ready for sharing!
    echo 📤 You can now transfer this APK file via any sharing platform.
    echo 📱 The APK will work on Android 5.0 (API 21) and above.
) else (
    echo ❌ Build failed! Please check the error messages above.
    pause
    exit /b 1
)
