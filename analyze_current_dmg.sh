#!/bin/bash

echo "🔍 생성된 DMG 실제 내용 분석..."

DMG_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/dmg/Image overlay tool_1.4.7_aarch64.dmg"

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
    echo "DMG 파일 검증 중..."
    hdiutil verify "$DMG_PATH"
    exit 1
fi

echo "✅ 마운트 성공: $MOUNT_POINT"
echo ""

# 내용 상세 분석
echo "📁 DMG 내부 전체 내용:"
ls -la "$MOUNT_POINT/"
echo ""

# 각 항목 크기 확인
echo "📊 각 항목별 크기:"
du -sh "$MOUNT_POINT"/*
echo ""

# 앱 번들 상세 분석
APP_PATH="$MOUNT_POINT/Image overlay tool.app"
if [ -d "$APP_PATH" ]; then
    echo "📱 앱 번들 상세 분석:"
    echo "   전체 크기: $(du -sh "$APP_PATH" | awk '{print $1}')"
    
    # Contents 확인
    if [ -d "$APP_PATH/Contents" ]; then
        echo "   📂 Contents 폴더:"
        ls -la "$APP_PATH/Contents/"
        
        # MacOS 실행 파일
        if [ -d "$APP_PATH/Contents/MacOS" ]; then
            echo "   📂 MacOS 실행 파일들:"
            ls -lah "$APP_PATH/Contents/MacOS/"
            
            # 실행 파일 타입 확인
            for file in "$APP_PATH/Contents/MacOS"/*; do
                if [ -f "$file" ]; then
                    echo "      $(basename "$file"): $(file "$file")"
                fi
            done
        fi
        
        # Resources 확인
        if [ -d "$APP_PATH/Contents/Resources" ]; then
            echo "   📂 Resources ($(ls "$APP_PATH/Contents/Resources/" | wc -l | tr -d ' ') 파일):"
            ls -la "$APP_PATH/Contents/Resources/" | head -5
        fi
        
        # Info.plist 확인
        if [ -f "$APP_PATH/Contents/Info.plist" ]; then
            echo "   📄 Info.plist:"
            echo "      Bundle Name: $(/usr/libexec/PlistBuddy -c "Print CFBundleName" "$APP_PATH/Contents/Info.plist" 2>/dev/null)"
            echo "      Executable: $(/usr/libexec/PlistBuddy -c "Print CFBundleExecutable" "$APP_PATH/Contents/Info.plist" 2>/dev/null)"
        fi
    fi
else
    echo "❌ 앱 번들이 없습니다!"
fi

# 언마운트
echo ""
echo "📤 언마운트 중..."
hdiutil detach "$MOUNT_POINT" 2>/dev/null

echo "✅ 분석 완료!"

# 비교용: 실제 앱 번들 크기도 확인
APP_BUNDLE_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/macos/Image overlay tool.app"
if [ -d "$APP_BUNDLE_PATH" ]; then
    echo ""
    echo "🔍 빌드 폴더의 실제 앱 번들 크기:"
    du -sh "$APP_BUNDLE_PATH"
    
    echo "   실행 파일:"
    ls -lah "$APP_BUNDLE_PATH/Contents/MacOS/"
fi
