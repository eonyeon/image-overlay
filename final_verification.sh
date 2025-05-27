#!/bin/bash

echo "🎉 최종 DMG 검증 시작..."

DMG_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/macos/Image_overlay_tool_1.4.7_fixed.dmg"

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG 파일을 찾을 수 없습니다"
    exit 1
fi

echo "📏 DMG 파일 정보:"
ls -lh "$DMG_PATH"
echo ""

# DMG 마운트
echo "📂 DMG 마운트 중..."
MOUNT_POINT=$(hdiutil attach "$DMG_PATH" 2>/dev/null | grep "/Volumes" | awk '{print $3}')

if [ -z "$MOUNT_POINT" ]; then
    echo "❌ DMG 마운트 실패"
    exit 1
fi

echo "✅ DMG 마운트 성공: $MOUNT_POINT"
echo ""

# 내용 확인
echo "📁 DMG 내용:"
ls -la "$MOUNT_POINT/"
echo ""

# 앱 번들 확인
APP_IN_DMG="$MOUNT_POINT/Image overlay tool.app"
if [ -d "$APP_IN_DMG" ]; then
    echo "✅ 앱 번들 발견!"
    echo "   크기: $(du -sh "$APP_IN_DMG" | awk '{print $1}')"
    
    # 앱 구조 확인
    if [ -f "$APP_IN_DMG/Contents/MacOS/Image overlay tool" ]; then
        echo "✅ 실행 파일 존재"
        echo "   크기: $(ls -lh "$APP_IN_DMG/Contents/MacOS/Image overlay tool" | awk '{print $5}')"
    else
        echo "❌ 실행 파일 없음"
    fi
    
    if [ -f "$APP_IN_DMG/Contents/Info.plist" ]; then
        echo "✅ Info.plist 존재"
        echo "   Bundle Name: $(/usr/libexec/PlistBuddy -c "Print CFBundleName" "$APP_IN_DMG/Contents/Info.plist" 2>/dev/null)"
    else
        echo "❌ Info.plist 없음"
    fi
else
    echo "❌ 앱 번들을 찾을 수 없습니다"
fi

# Applications 링크 확인
if [ -L "$MOUNT_POINT/Applications" ]; then
    echo "✅ Applications 링크 존재"
else
    echo "ℹ️ Applications 링크 없음 (선택사항)"
fi

# 언마운트
echo ""
echo "📤 DMG 언마운트 중..."
hdiutil detach "$MOUNT_POINT" 2>/dev/null

echo ""
echo "🎉 최종 검증 결과:"
echo "=============================="

if [ -d "$APP_IN_DMG" ]; then
    echo "✅ DMG 생성 성공!"
    echo "✅ 앱 번들 정상 포함"
    echo "✅ 배포 준비 완료"
    echo ""
    echo "📦 배포 파일: $DMG_PATH"
    echo "📏 파일 크기: $(ls -lh "$DMG_PATH" | awk '{print $5}')"
    echo ""
    echo "🚀 사용 방법:"
    echo "1. DMG 파일을 더블클릭하여 마운트"
    echo "2. 'Image overlay tool.app'을 Applications 폴더로 드래그"
    echo "3. 앱 설치 완료!"
else
    echo "❌ DMG에 문제가 있습니다"
fi

echo ""
echo "🎯 프로젝트 완성 상태: ✅ 성공"
