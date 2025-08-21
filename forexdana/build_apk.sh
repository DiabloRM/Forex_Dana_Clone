#!/bin/bash

echo "🚀 Building ForexDana APK..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK for release
echo "🔨 Building release APK..."
flutter build apk --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo "📏 APK size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
    
    # Copy APK to a more accessible location
    cp build/app/outputs/flutter-apk/app-release.apk ./ForexDana.apk
    echo "📋 APK copied to: ./ForexDana.apk"
    
    echo ""
    echo "🎉 Your APK is ready for sharing!"
    echo "📤 You can now transfer this APK file via any sharing platform."
    echo "📱 The APK will work on Android 5.0 (API 21) and above."
else
    echo "❌ Build failed! Please check the error messages above."
    exit 1
fi
