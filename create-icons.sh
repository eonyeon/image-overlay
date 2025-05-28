#!/bin/bash

# 🎨 Tauri 아이콘 생성 스크립트 (임시 해결책)
# Windows 빌드 오류 해결을 위한 기본 아이콘 생성

echo "🎨 Creating basic Tauri icons for Windows build..."

# 아이콘 디렉토리로 이동
cd src-tauri/icons

# ImageMagick이 설치되어 있다면 사용
if command -v convert >/dev/null 2>&1; then
    echo "✅ ImageMagick found, creating icons..."
    
    # 512x512 기본 아이콘 생성 (간단한 파란색 사각형)
    convert -size 512x512 xc:"#4A90E2" -fill white -gravity center -font Arial -pointsize 200 -annotate +0+0 "IO" icon.png
    
    # 필요한 크기들 생성
    convert icon.png -resize 32x32 32x32.png
    convert icon.png -resize 128x128 128x128.png
    convert icon.png -resize 256x256 128x128@2x.png
    
    # Windows ICO 파일 생성
    convert icon.png -resize 256x256 \
            \( -clone 0 -resize 128x128 \) \
            \( -clone 0 -resize 64x64 \) \
            \( -clone 0 -resize 48x48 \) \
            \( -clone 0 -resize 32x32 \) \
            \( -clone 0 -resize 16x16 \) \
            icon.ico
    
    echo "✅ Icons created successfully!"
    ls -la *.png *.ico
    
elif command -v sips >/dev/null 2>&1; then
    echo "✅ macOS sips found, creating basic icon..."
    
    # macOS에서 간단한 아이콘 생성 (sips 사용)
    # 우선 512x512 PNG 생성이 필요하지만 복잡함
    echo "⚠️ Manual icon creation needed with sips"
    echo "Please run: npx tauri icon"
    
else
    echo "❌ No image tools found"
    echo "📝 Please install ImageMagick or run: npx tauri icon"
    echo ""
    echo "🔧 Quick fix commands:"
    echo "1. brew install imagemagick (macOS)"
    echo "2. npx tauri icon (recommended)"
fi

echo ""
echo "📋 Required icon files for Tauri:"
echo "- icon.png (512x512)"
echo "- icon.ico (Windows)"
echo "- 32x32.png, 128x128.png, 128x128@2x.png"
