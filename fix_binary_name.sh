#!/bin/bash

# 🔧 바이너리 이름 공백 문제 즉시 해결

echo "🔧 바이너리 이름 공백 문제 해결 중..."

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📋 1단계: 현재 설정 백업"
cp src-tauri/tauri.conf.json src-tauri/tauri.conf.json.backup
echo "✅ 백업 완료"

echo ""
echo "📋 2단계: productName에서 공백 제거"
# tauri.conf.json에서 productName 수정
sed -i '' 's/"productName": "Image overlay tool"/"productName": "ImageOverlayTool"/g' src-tauri/tauri.conf.json

# 창 제목도 수정
sed -i '' 's/"title": "Image overlay tool v1.4.7 - Fixed Build (Korean Support)"/"title": "Image Overlay Tool v1.4.7 - Fixed Build (Korean Support)"/g' src-tauri/tauri.conf.json

echo "✅ productName 수정 완료: Image overlay tool → ImageOverlayTool"

echo ""
echo "📋 3단계: 변경사항 확인"
echo "수정된 productName:"
grep -n "productName" src-tauri/tauri.conf.json

echo ""
echo "📋 4단계: 빌드 캐시 정리"
rm -rf src-tauri/target/release/
echo "✅ 캐시 정리 완료"

echo ""
echo "📋 5단계: 테스트 빌드 실행"
echo "🚀 새로운 설정으로 빌드 시작..."

npm run build
npm run tauri build

echo ""
echo "📋 6단계: 결과 확인"
if [ -f "src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg" ]; then
    DMG_SIZE=$(ls -lh "src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg" | awk '{print $5}')
    echo "✅ 새 DMG 생성 성공: $DMG_SIZE"
    
    if [[ "$DMG_SIZE" == *"M"* ]] && [[ "${DMG_SIZE//[!0-9]/}" -gt 10 ]]; then
        echo "🎉 성공! 정상 크기의 DMG가 생성되었습니다!"
        echo "📂 위치: src-tauri/target/release/bundle/dmg/"
        ls -la "src-tauri/target/release/bundle/dmg/"
    else
        echo "⚠️ 여전히 크기가 작습니다: $DMG_SIZE"
    fi
else
    echo "❌ 새 DMG 생성 실패 - 다른 이름으로 생성되었을 수 있음"
    echo "🔍 생성된 DMG 파일들:"
    find src-tauri/target/release/bundle/dmg/ -name "*.dmg" 2>/dev/null
fi

echo ""
echo "📋 7단계: 앱 번들 확인"
if [ -d "src-tauri/target/release/bundle/macos/ImageOverlayTool.app" ]; then
    APP_SIZE=$(du -sh "src-tauri/target/release/bundle/macos/ImageOverlayTool.app" | awk '{print $1}')
    echo "✅ 앱 번들 생성 성공: $APP_SIZE"
    
    # 실행 파일 확인
    EXEC_FILE="src-tauri/target/release/bundle/macos/ImageOverlayTool.app/Contents/MacOS/ImageOverlayTool"
    if [ -f "$EXEC_FILE" ]; then
        EXEC_SIZE=$(ls -lh "$EXEC_FILE" | awk '{print $5}')
        echo "✅ 실행 파일: $EXEC_SIZE"
        echo "🔍 파일 타입: $(file "$EXEC_FILE")"
    fi
else
    echo "❌ 앱 번들 생성 실패"
    echo "🔍 생성된 앱들:"
    find src-tauri/target/release/bundle/macos/ -name "*.app" 2>/dev/null
fi

echo ""
echo "🔄 롤백 방법:"
echo "cp src-tauri/tauri.conf.json.backup src-tauri/tauri.conf.json"
echo ""
echo "✅ 공백 문제 해결 테스트 완료!"
