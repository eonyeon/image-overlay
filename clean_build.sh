#!/bin/bash

echo "🧹 클린 빌드 시작..."

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "1. 기존 빌드 결과 삭제 중..."
rm -rf src-tauri/target/release/bundle
rm -rf dist
rm -rf node_modules/.cache

echo "2. Cargo 캐시 정리..."
cd src-tauri
cargo clean

echo "3. NPM 빌드..."
cd ..
npm run build

echo "4. Tauri 빌드..."
cd src-tauri
npx tauri build

echo "5. 빌드 결과 확인..."
BUNDLE_DIR="target/release/bundle"

if [ -d "$BUNDLE_DIR/macos" ]; then
    echo "✅ macOS 앱 번들 생성됨"
    ls -la "$BUNDLE_DIR/macos/"
    
    # 앱 번들 크기 확인
    APP_PATH=$(find "$BUNDLE_DIR/macos" -name "*.app" | head -1)
    if [ -n "$APP_PATH" ]; then
        echo "   앱 번들 크기: $(du -sh "$APP_PATH" | awk '{print $1}')"
        
        # 실행 파일 확인
        EXEC_PATH=$(find "$APP_PATH/Contents/MacOS" -type f | head -1)
        if [ -n "$EXEC_PATH" ]; then
            echo "   실행 파일 크기: $(ls -lh "$EXEC_PATH" | awk '{print $5}')"
        fi
    fi
else
    echo "❌ macOS 앱 번들이 생성되지 않았습니다"
fi

if [ -d "$BUNDLE_DIR/dmg" ]; then
    echo "✅ DMG 파일 생성됨"
    ls -la "$BUNDLE_DIR/dmg/"
    
    DMG_PATH=$(find "$BUNDLE_DIR/dmg" -name "*.dmg" | head -1)
    if [ -n "$DMG_PATH" ]; then
        echo "   DMG 크기: $(ls -lh "$DMG_PATH" | awk '{print $5}')"
    fi
else
    echo "❌ DMG 파일이 생성되지 않았습니다"
fi

echo "🎉 빌드 완료!"
