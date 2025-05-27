#!/bin/bash

echo "📦 ZIP 배포 패키지 생성..."

APP_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/macos/Image overlay tool.app"
OUTPUT_DIR="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle"
ZIP_NAME="Image_overlay_tool_1.4.7_macos.zip"
ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ 앱 번들을 찾을 수 없습니다"
    exit 1
fi

echo "✅ 앱 번들 발견: $(du -sh "$APP_PATH" | awk '{print $1}')"

# 기존 ZIP 삭제
if [ -f "$ZIP_PATH" ]; then
    echo "🗑 기존 ZIP 삭제..."
    rm -f "$ZIP_PATH"
fi

# ZIP 생성
echo "📦 ZIP 생성 중..."
cd "$(dirname "$APP_PATH")"
zip -r "$ZIP_PATH" "$(basename "$APP_PATH")" -x "*.DS_Store*"

if [ -f "$ZIP_PATH" ]; then
    echo "✅ ZIP 생성 성공!"
    echo "   파일: $ZIP_PATH"
    echo "   크기: $(ls -lh "$ZIP_PATH" | awk '{print $5}')"
    
    # ZIP 내용 확인
    echo ""
    echo "📋 ZIP 내용 확인:"
    unzip -l "$ZIP_PATH" | head -10
    
    echo ""
    echo "🎉 ZIP 배포 패키지 준비 완료!"
    echo "   → 사용자는 다운로드 후 압축해제하여 앱 사용 가능"
    echo "   → Applications 폴더로 드래그하여 설치"
else
    echo "❌ ZIP 생성 실패"
fi
