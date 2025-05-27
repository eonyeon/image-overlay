#!/bin/bash

echo "🔬 시스템 레벨 DMG 문제 진단 시작..."

APP_PATH="/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/target/release/bundle/macos/Image overlay tool.app"

echo ""
echo "1. 📱 앱 번들 상세 분석"
echo "=========================="

if [ -d "$APP_PATH" ]; then
    echo "✅ 앱 번들 존재: $(du -sh "$APP_PATH" | awk '{print $1}')"
    
    echo ""
    echo "📂 앱 번들 구조:"
    find "$APP_PATH" -type f -exec ls -la {} \; | head -10
    
    echo ""
    echo "🔐 앱 번들 권한:"
    ls -la "$APP_PATH"
    ls -la "$APP_PATH/Contents/"
    ls -la "$APP_PATH/Contents/MacOS/"
    
    echo ""
    echo "🏷 앱 번들 확장 속성:"
    xattr -l "$APP_PATH" 2>/dev/null || echo "확장 속성 없음"
    
    echo ""
    echo "🔒 macOS 보안 평가:"
    spctl --assess --verbose "$APP_PATH" 2>&1 || echo "보안 평가 실패"
    
    echo ""
    echo "📄 Info.plist 내용:"
    if [ -f "$APP_PATH/Contents/Info.plist" ]; then
        /usr/libexec/PlistBuddy -c "Print" "$APP_PATH/Contents/Info.plist" | head -20
    fi
    
    echo ""
    echo "🔍 실행 파일 분석:"
    EXEC_FILE="$APP_PATH/Contents/MacOS/Image overlay tool"
    if [ -f "$EXEC_FILE" ]; then
        echo "   파일 타입: $(file "$EXEC_FILE")"
        echo "   권한: $(ls -la "$EXEC_FILE" | awk '{print $1}')"
        echo "   소유자: $(ls -la "$EXEC_FILE" | awk '{print $3":"$4}')"
        echo "   확장 속성: $(xattr -l "$EXEC_FILE" 2>/dev/null || echo "없음")"
    fi
else
    echo "❌ 앱 번들이 없습니다!"
    exit 1
fi

echo ""
echo "2. 🛠 hdiutil 시스템 진단"
echo "=========================="

echo "hdiutil 버전:"
hdiutil version

echo ""
echo "현재 마운트된 디스크 이미지:"
hdiutil info | grep -A 5 "image-path"

echo ""
echo "3. 🧪 간단한 테스트 DMG 생성"
echo "=========================="

TEST_DIR="/tmp/dmg_test_$$"
TEST_DMG="/tmp/test_$$.dmg"

mkdir -p "$TEST_DIR"
echo "Hello World" > "$TEST_DIR/test.txt"

echo "테스트 디렉토리 내용:"
ls -la "$TEST_DIR/"

echo ""
echo "테스트 DMG 생성 중..."
hdiutil create -volname "Test" -srcfolder "$TEST_DIR" -ov -format UDZO "$TEST_DMG" 2>&1

if [ -f "$TEST_DMG" ]; then
    echo "✅ 테스트 DMG 생성 성공: $(ls -lh "$TEST_DMG" | awk '{print $5}')"
    
    # 테스트 DMG 마운트
    echo "테스트 DMG 마운트 시도..."
    MOUNT_POINT=$(hdiutil attach "$TEST_DMG" 2>/dev/null | grep "/Volumes" | awk '{print $3}')
    
    if [ -n "$MOUNT_POINT" ]; then
        echo "✅ 테스트 DMG 마운트 성공: $MOUNT_POINT"
        echo "내용:"
        ls -la "$MOUNT_POINT/" || echo "내용 읽기 실패"
        hdiutil detach "$MOUNT_POINT" 2>/dev/null
    else
        echo "❌ 테스트 DMG 마운트 실패"
    fi
    
    rm -f "$TEST_DMG"
else
    echo "❌ 테스트 DMG 생성 실패"
fi

rm -rf "$TEST_DIR"

echo ""
echo "4. 🔍 시스템 로그 확인"
echo "===================="

echo "최근 hdiutil 관련 로그:"
log show --predicate 'process == "hdiutil"' --info --last 1h 2>/dev/null | tail -10 || echo "로그 접근 권한 없음"

echo ""
echo "5. 💡 권장 해결책"
echo "================"

echo "🎯 즉시 시도할 수 있는 방법들:"
echo ""
echo "방법 1: ZIP 배포"
echo "cd '$APP_PATH/..' && zip -r 'Image_overlay_tool_1.4.7.zip' 'Image overlay tool.app'"
echo ""
echo "방법 2: create-dmg 도구 설치 후 사용"
echo "brew install create-dmg"
echo "create-dmg 'Image overlay tool_1.4.7_fixed.dmg' '$APP_PATH'"
echo ""
echo "방법 3: 다른 Mac에서 테스트"
echo "앱 번들을 다른 Mac으로 복사해서 DMG 생성 시도"
echo ""
echo "방법 4: 터미널 재시작 후 재시도"
echo "sudo killall Finder && sudo reboot"

echo ""
echo "🔬 진단 완료!"
