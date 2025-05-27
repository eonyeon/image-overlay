#!/bin/bash

echo "🔍 현재 생성된 DMG 분석 중..."

DMG_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg"

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG 파일을 찾을 수 없습니다: $DMG_PATH"
    exit 1
fi

echo "📏 파일 크기: $(ls -lh "$DMG_PATH" | awk '{print $5}')"
echo "📅 생성 시간: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$DMG_PATH")"

# DMG 마운트 시도
echo ""
echo "📂 DMG 마운트 중..."
MOUNT_POINT=$(hdiutil attach "$DMG_PATH" 2>/dev/null | grep "/Volumes" | awk '{print $3}')

if [ -z "$MOUNT_POINT" ]; then
    echo "❌ DMG 마운트 실패 - 파일이 손상되었을 가능성"
    
    # DMG 검증
    echo "🔍 DMG 파일 검증 중..."
    hdiutil verify "$DMG_PATH"
    exit 1
fi

echo "✅ DMG 마운트 성공: $MOUNT_POINT"

# 내용 분석
echo ""
echo "📁 DMG 내용:"
ls -la "$MOUNT_POINT/"

# 앱 번들 찾기
APP_NAME=$(ls "$MOUNT_POINT/" | grep ".app$" | head -1)
if [ -n "$APP_NAME" ]; then
    APP_PATH="$MOUNT_POINT/$APP_NAME"
    echo ""
    echo "📱 발견된 앱 번들: $APP_NAME"
    echo "   전체 크기: $(du -sh "$APP_PATH" | awk '{print $1}')"
    
    # Contents 폴더 확인
    if [ -d "$APP_PATH/Contents" ]; then
        echo "   Contents 폴더: ✅"
        ls -la "$APP_PATH/Contents/"
        
        # MacOS 폴더 확인
        if [ -d "$APP_PATH/Contents/MacOS" ]; then
            echo ""
            echo "📂 MacOS 폴더 내용:"
            ls -la "$APP_PATH/Contents/MacOS/"
            
            # 실행 파일 분석
            EXEC_FILES=$(ls "$APP_PATH/Contents/MacOS/" 2>/dev/null)
            for file in $EXEC_FILES; do
                EXEC_PATH="$APP_PATH/Contents/MacOS/$file"
                if [ -f "$EXEC_PATH" ]; then
                    echo "   실행 파일: $file"
                    echo "   크기: $(ls -lh "$EXEC_PATH" | awk '{print $5}')"
                    echo "   타입: $(file "$EXEC_PATH")"
                    echo "   권한: $(ls -l "$EXEC_PATH" | awk '{print $1}')"
                fi
            done
        else
            echo "   ❌ MacOS 폴더가 없습니다!"
        fi
        
        # Resources 폴더 확인
        if [ -d "$APP_PATH/Contents/Resources" ]; then
            echo ""
            echo "📂 Resources 폴더:"
            ls -la "$APP_PATH/Contents/Resources/" | head -10
        fi
        
        # Info.plist 확인
        if [ -f "$APP_PATH/Contents/Info.plist" ]; then
            echo ""
            echo "📄 Info.plist 정보:"
            /usr/libexec/PlistBuddy -c "Print CFBundleName" "$APP_PATH/Contents/Info.plist" 2>/dev/null
            /usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$APP_PATH/Contents/Info.plist" 2>/dev/null
            /usr/libexec/PlistBuddy -c "Print CFBundleExecutable" "$APP_PATH/Contents/Info.plist" 2>/dev/null
        fi
    else
        echo "   ❌ Contents 폴더가 없습니다!"
    fi
else
    echo "❌ 앱 번들을 찾을 수 없습니다!"
    echo "대신 발견된 파일들:"
    ls -la "$MOUNT_POINT/"
fi

# 언마운트
echo ""
echo "📤 DMG 언마운트 중..."
hdiutil detach "$MOUNT_POINT" 2>/dev/null

echo "✅ 분석 완료!"
