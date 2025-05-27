#!/bin/bash

# 🔍 Tauri 번들링 문제 심층 분석

echo "🔍 Tauri 번들링 문제 심층 분석"
echo "============================="

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📋 1. 빌드 결과물 상세 확인"
echo "-------------------------"

# 바이너리 확인
BINARY_PATH="src-tauri/target/release/ImageOverlayTool"
if [ -f "$BINARY_PATH" ]; then
    echo "✅ 새 바이너리 발견: $BINARY_PATH"
    echo "📏 크기: $(ls -lh "$BINARY_PATH" | awk '{print $5}')"
    echo "🔍 타입: $(file "$BINARY_PATH")"
    echo "🔗 의존성 (첫 5개):"
    otool -L "$BINARY_PATH" 2>/dev/null | head -5
else
    echo "❌ 새 바이너리가 없습니다"
    echo "🔍 release 폴더 내 실행 파일들:"
    find src-tauri/target/release -maxdepth 1 -type f -perm +111 | head -10
fi

echo ""
echo "📋 2. 앱 번들 상세 확인"
echo "---------------------"

# 예상 앱 번들 위치들 확인
APP_LOCATIONS=(
    "src-tauri/target/release/bundle/macos/ImageOverlayTool.app"
    "src-tauri/target/release/bundle/macos/Image overlay tool.app"
    "src-tauri/target/release/ImageOverlayTool.app"
)

for location in "${APP_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        echo "✅ 앱 번들 발견: $location"
        echo "📏 크기: $(du -sh "$location" | awk '{print $1}')"
        echo "📂 구조:"
        ls -la "$location/Contents/"
        
        # 실행 파일 확인
        EXEC_PATH="$location/Contents/MacOS"
        if [ -d "$EXEC_PATH" ]; then
            echo "📱 실행 파일들:"
            ls -la "$EXEC_PATH/"
        fi
        echo "---"
    else
        echo "❌ 없음: $location"
    fi
done

echo ""
echo "📋 3. bundle 폴더 전체 스캔"
echo "------------------------"
if [ -d "src-tauri/target/release/bundle" ]; then
    echo "📂 bundle 폴더 전체 구조:"
    find src-tauri/target/release/bundle -type d | head -20
    echo ""
    echo "🔍 .app 파일 검색:"
    find src-tauri/target/release/bundle -name "*.app" 2>/dev/null
    echo ""
    echo "📱 실행 파일 검색:"
    find src-tauri/target/release/bundle -type f -perm +111 2>/dev/null | head -10
else
    echo "❌ bundle 폴더가 없습니다!"
fi

echo ""
echo "📋 4. DMG 내용 강제 확인"
echo "----------------------"
NEW_DMG="src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg"
if [ -f "$NEW_DMG" ]; then
    echo "✅ 새 DMG 발견: $NEW_DMG"
    echo "📏 크기: $(ls -lh "$NEW_DMG" | awk '{print $5}')"
    
    # DMG 마운트 시도 (자동 Y 응답)
    echo "📂 DMG 마운트 시도..."
    MOUNT_OUTPUT=$(echo "y" | hdiutil attach "$NEW_DMG" 2>&1)
    echo "마운트 출력: $MOUNT_OUTPUT"
    
    # 마운트된 볼륨 찾기
    MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep "/Volumes" | awk '{print $3}' | tail -1)
    if [ -n "$MOUNT_POINT" ] && [ -d "$MOUNT_POINT" ]; then
        echo "✅ 마운트 성공: $MOUNT_POINT"
        echo "📂 DMG 내용:"
        ls -la "$MOUNT_POINT/"
        
        # 앱 검색
        if find "$MOUNT_POINT" -name "*.app" | head -1 | read app_path; then
            echo "✅ DMG 내 앱 발견: $app_path"
            echo "📏 앱 크기: $(du -sh "$app_path" | awk '{print $1}')"
            echo "📂 앱 구조 (일부):"
            ls -la "$app_path/Contents/" 2>/dev/null | head -5
        else
            echo "❌ DMG에 앱이 없습니다!"
            echo "📁 DMG 전체 내용:"
            find "$MOUNT_POINT" -type f | head -10
        fi
        
        # 언마운트
        hdiutil detach "$MOUNT_POINT" 2>/dev/null
    else
        echo "❌ DMG 마운트 실패!"
    fi
else
    echo "❌ 새 DMG 파일이 없습니다!"
fi

echo ""
echo "📋 5. Tauri 설정 검증"
echo "--------------------"
echo "🔍 현재 productName:"
grep -n "productName" src-tauri/tauri.conf.json

echo ""
echo "🔍 현재 bundle targets:"
grep -A5 -B5 "targets" src-tauri/tauri.conf.json

echo ""
echo "📋 6. 빌드 환경 확인"
echo "------------------"
echo "🔍 Tauri 버전:"
npm list @tauri-apps/cli 2>/dev/null | grep @tauri-apps/cli || echo "Tauri CLI 정보 없음"

echo ""
echo "🔍 Rust 타겟:"
rustup target list --installed | grep apple

echo ""
echo "🔍 최근 빌드 로그 (에러만):"
if [ -f "src-tauri/target/release/build/image-overlay-*/stderr" ]; then
    echo "빌드 에러 로그:"
    cat src-tauri/target/release/build/image-overlay-*/stderr 2>/dev/null | tail -20
else
    echo "빌드 에러 로그 없음"
fi

echo ""
echo "✅ 심층 분석 완료!"
echo "==================="
