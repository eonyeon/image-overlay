#!/bin/bash

echo "🔧 수동 DMG 생성 시작..."

APP_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/macos/Image overlay tool.app"
TEMP_DIR="/tmp/dmg_build_$$"
DMG_OUTPUT="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/dmg/Image_overlay_tool_1.4.7_manual.dmg"

# 앱 번들 존재 확인
if [ ! -d "$APP_PATH" ]; then
    echo "❌ 앱 번들을 찾을 수 없습니다: $APP_PATH"
    exit 1
fi

echo "✅ 앱 번들 발견: $(du -sh "$APP_PATH" | awk '{print $1}')"

# 임시 디렉토리 생성
echo "📁 임시 디렉토리 생성: $TEMP_DIR"
mkdir -p "$TEMP_DIR"

# 앱 복사
echo "📋 앱 번들 복사 중..."
cp -R "$APP_PATH" "$TEMP_DIR/"

# Applications 링크 생성 (선택사항)
echo "🔗 Applications 링크 생성..."
ln -s /Applications "$TEMP_DIR/Applications"

# 임시 디렉토리 내용 확인
echo "📊 임시 디렉토리 내용:"
ls -la "$TEMP_DIR/"
echo "총 크기: $(du -sh "$TEMP_DIR" | awk '{print $1}')"

# 기존 DMG 삭제 (있다면)
if [ -f "$DMG_OUTPUT" ]; then
    echo "🗑 기존 DMG 삭제..."
    rm -f "$DMG_OUTPUT"
fi

# DMG 생성
echo "🏗 DMG 생성 중..."
hdiutil create \
    -volname "Image overlay tool" \
    -srcfolder "$TEMP_DIR" \
    -ov -format UDZO \
    "$DMG_OUTPUT"

# 결과 확인
if [ -f "$DMG_OUTPUT" ]; then
    echo "✅ DMG 생성 성공!"
    echo "   파일: $DMG_OUTPUT"
    echo "   크기: $(ls -lh "$DMG_OUTPUT" | awk '{print $5}')"
    
    # DMG 내용 검증
    echo ""
    echo "🔍 생성된 DMG 검증 중..."
    MOUNT_POINT=$(hdiutil attach "$DMG_OUTPUT" | grep "/Volumes" | awk '{print $3}')
    
    if [ -n "$MOUNT_POINT" ]; then
        echo "✅ DMG 마운트 성공: $MOUNT_POINT"
        echo "📁 DMG 내용:"
        ls -la "$MOUNT_POINT/"
        
        # 앱 번들 확인
        if [ -d "$MOUNT_POINT/Image overlay tool.app" ]; then
            echo "✅ 앱 번들이 정상적으로 포함되어 있습니다!"
            echo "   크기: $(du -sh "$MOUNT_POINT/Image overlay tool.app" | awk '{print $1}')"
        else
            echo "❌ 앱 번들이 없습니다!"
        fi
        
        # 언마운트
        hdiutil detach "$MOUNT_POINT"
    else
        echo "❌ DMG 마운트 실패"
    fi
else
    echo "❌ DMG 생성 실패"
fi

# 임시 파일 정리
echo "🧹 임시 파일 정리..."
rm -rf "$TEMP_DIR"

echo "🎉 수동 DMG 생성 완료!"
