#!/bin/bash

# 🔍 Tauri 빌드 상세 분석 스크립트

echo "🔍 Tauri 빌드 결과 상세 분석"
echo "================================"

PROJECT_ROOT="/Users/eon/Desktop/testflight-clean/image-overlay"
cd "$PROJECT_ROOT"

echo "📁 1. 빌드 결과물 전체 구조 확인"
echo "-------------------------------"
if [ -d "src-tauri/target/release" ]; then
    echo "✅ release 폴더 존재"
    echo "📏 전체 크기: $(du -sh src-tauri/target/release)"
    echo ""
    echo "📂 상세 구조:"
    find src-tauri/target/release -name "*image*" -o -name "*.app" -o -name "*.dmg" | head -20
else
    echo "❌ release 폴더가 없습니다!"
fi

echo ""
echo "📁 2. 실행 바이너리 확인"
echo "----------------------"
BINARY_PATH="src-tauri/target/release/image-overlay"
if [ -f "$BINARY_PATH" ]; then
    echo "✅ 실행 바이너리 발견: $BINARY_PATH"
    echo "📏 크기: $(ls -lh "$BINARY_PATH" | awk '{print $5}')"
    echo "🔍 파일 타입: $(file "$BINARY_PATH")"
    echo "🔗 의존성 (처음 10개):"
    otool -L "$BINARY_PATH" 2>/dev/null | head -10
else
    echo "❌ 실행 바이너리가 없습니다!"
    echo "🔍 가능한 바이너리 찾기:"
    find src-tauri/target/release -type f -perm +111 | head -10
fi

echo ""
echo "📁 3. macOS 앱 번들 확인"
echo "----------------------"
APP_BUNDLE="src-tauri/target/release/bundle/macos/Image overlay tool.app"
if [ -d "$APP_BUNDLE" ]; then
    echo "✅ 앱 번들 발견: $APP_BUNDLE"
    echo "📏 전체 크기: $(du -sh "$APP_BUNDLE")"
    echo ""
    echo "📂 앱 번들 구조:"
    ls -la "$APP_BUNDLE/Contents/"
    echo ""
    echo "📂 MacOS 폴더:"
    if [ -d "$APP_BUNDLE/Contents/MacOS" ]; then
        ls -la "$APP_BUNDLE/Contents/MacOS/"
        
        # 실행 파일 확인
        EXEC_FILE="$APP_BUNDLE/Contents/MacOS/Image overlay tool"
        if [ -f "$EXEC_FILE" ]; then
            echo "✅ 실행 파일 발견!"
            echo "📏 크기: $(ls -lh "$EXEC_FILE" | awk '{print $5}')"
            echo "🔍 파일 타입: $(file "$EXEC_FILE")"
        else
            echo "❌ 실행 파일이 없습니다!"
            echo "🔍 MacOS 폴더 내용:"
            find "$APP_BUNDLE/Contents/MacOS" -type f
        fi
    else
        echo "❌ MacOS 폴더가 없습니다!"
    fi
    
    echo ""
    echo "📂 Resources 폴더:"
    if [ -d "$APP_BUNDLE/Contents/Resources" ]; then
        ls -la "$APP_BUNDLE/Contents/Resources/" | head -10
    else
        echo "❌ Resources 폴더가 없습니다!"
    fi
else
    echo "❌ 앱 번들이 없습니다!"
    echo "🔍 bundle 폴더 확인:"
    find src-tauri/target/release/bundle -type d | head -10
fi

echo ""
echo "📁 4. DMG 내용 직접 확인"
echo "----------------------"
DMG_PATH="src-tauri/target/release/bundle/dmg/Image overlay tool_1.4.7_aarch64.dmg"
if [ -f "$DMG_PATH" ]; then
    echo "✅ DMG 파일 발견: $DMG_PATH"
    echo "📏 크기: $(ls -lh "$DMG_PATH" | awk '{print $5}')"
    
    # DMG 마운트 시도
    echo "📂 DMG 마운트 시도..."
    MOUNT_OUTPUT=$(hdiutil attach "$DMG_PATH" 2>&1)
    echo "마운트 결과: $MOUNT_OUTPUT"
    
    # 마운트된 볼륨 찾기
    MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep "/Volumes" | awk '{print $3}' | tail -1)
    if [ -n "$MOUNT_POINT" ] && [ -d "$MOUNT_POINT" ]; then
        echo "✅ 마운트 성공: $MOUNT_POINT"
        echo "📂 DMG 내용:"
        ls -la "$MOUNT_POINT/"
        
        # 앱이 있는지 확인
        if [ -d "$MOUNT_POINT"/*.app ]; then
            APP_IN_DMG=$(find "$MOUNT_POINT" -name "*.app" | head -1)
            echo "✅ DMG 내 앱 발견: $APP_IN_DMG"
            echo "📏 앱 크기: $(du -sh "$APP_IN_DMG")"
        else
            echo "❌ DMG에 앱이 없습니다!"
        fi
        
        # 언마운트
        hdiutil detach "$MOUNT_POINT" 2>/dev/null
    else
        echo "❌ DMG 마운트 실패!"
    fi
else
    echo "❌ DMG 파일이 없습니다!"
fi

echo ""
echo "📁 5. Cargo 빌드 로그 확인"
echo "------------------------"
echo "🔍 마지막 빌드에서 생성된 파일들:"
find src-tauri/target/release -newer src-tauri/Cargo.toml -type f | head -20

echo ""
echo "📁 6. 의존성 크기 추정"
echo "-------------------"
echo "🔍 Cargo.lock에서 주요 의존성 확인:"
if [ -f "src-tauri/Cargo.lock" ]; then
    grep -E "(image|imageproc|rusttype|ab_glyph|tauri)" src-tauri/Cargo.lock | head -10
else
    echo "❌ Cargo.lock이 없습니다!"
fi

echo ""
echo "✅ 분석 완료!"
echo "================================"
