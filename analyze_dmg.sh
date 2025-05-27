#!/bin/bash

# 🔍 DMG 내용 분석 스크립트

echo "🔍 Image Overlay Tool DMG 분석 중..."

DMG_PATH="/Users/eon/Downloads/macos-dmg (3)/Image overlay tool_1.4.7_aarch64.dmg"

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG 파일을 찾을 수 없습니다"
    exit 1
fi

echo "📏 파일 크기: $(ls -lh "$DMG_PATH" | awk '{print $5}')"

# DMG 마운트
echo "📂 DMG 마운트 중..."
MOUNT_POINT=$(hdiutil attach "$DMG_PATH" 2>/dev/null | grep "/Volumes" | awk '{print $3}')

if [ -z "$MOUNT_POINT" ]; then
    echo "❌ DMG 마운트 실패 - 파일이 손상되었을 가능성"
    exit 1
fi

echo "✅ DMG 마운트 성공: $MOUNT_POINT"

# 내용 분석
echo ""
echo "📁 DMG 내용:"
ls -la "$MOUNT_POINT"

# 앱 번들 분석
APP_PATH="$MOUNT_POINT/Image overlay tool.app"
if [ -d "$APP_PATH" ]; then
    echo ""
    echo "📱 앱 번들 분석:"
    echo "   전체 크기: $(du -sh "$APP_PATH" | awk '{print $1}')"
    echo "   실행 파일: $(ls -la "$APP_PATH/Contents/MacOS/" 2>/dev/null || echo "실행 파일 없음!")"
    echo "   리소스: $(ls -la "$APP_PATH/Contents/Resources/" 2>/dev/null | wc -l) 개 파일"
    
    # 실행 파일 크기 확인
    EXEC_FILE="$APP_PATH/Contents/MacOS/Image overlay tool"
    if [ -f "$EXEC_FILE" ]; then
        echo "   실행 파일 크기: $(ls -lh "$EXEC_FILE" | awk '{print $5}')"
        echo "   실행 파일 타입: $(file "$EXEC_FILE")"
    else
        echo "   ❌ 실행 파일이 없습니다!"
    fi
    
    # 의존성 확인
    if [ -f "$EXEC_FILE" ]; then
        echo ""
        echo "🔗 의존성 라이브러리:"
        otool -L "$EXEC_FILE" 2>/dev/null | head -10
    fi
else
    echo "❌ 앱 번들을 찾을 수 없습니다!"
fi

# 언마운트
echo ""
echo "📤 DMG 언마운트 중..."
hdiutil detach "$MOUNT_POINT" 2>/dev/null

echo "✅ 분석 완료!"
