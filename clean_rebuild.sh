#!/bin/bash
# Image Overlay Tool - Clean Rebuild Script
# 완전한 클린 빌드로 번들링 문제 해결

echo "🧹 Clean Rebuild 시작..."
echo "========================="

# 현재 디렉토리 확인
if [ ! -f "package.json" ]; then
    echo "❌ package.json을 찾을 수 없습니다. 올바른 디렉토리에서 실행하세요."
    exit 1
fi

echo "📂 1단계: 기존 빌드 결과물 완전 삭제"
echo "------------------------------------"
rm -rf dist/
rm -rf src-tauri/target/
rm -rf node_modules/.cache/
echo "✅ 빌드 캐시 삭제 완료"

echo ""
echo "📦 2단계: 의존성 재설치"
echo "------------------------"
npm ci
echo "✅ Node.js 의존성 재설치 완료"

echo ""
echo "🔧 3단계: 프론트엔드 빌드"
echo "-------------------------"
npm run build
echo "✅ 프론트엔드 빌드 완료"

echo ""
echo "🦀 4단계: Rust 의존성 업데이트"
echo "-------------------------------"
cd src-tauri
cargo clean
cargo update
echo "✅ Rust 의존성 업데이트 완료"

echo ""
echo "📱 5단계: Tauri 앱 빌드"
echo "-----------------------"
echo "⚠️  번들링 과정을 주의깊게 관찰하세요..."
cargo tauri build --verbose

echo ""
echo "🔍 6단계: 빌드 결과 확인"
echo "------------------------"
cd ..

# 바이너리 확인
if [ -f "src-tauri/target/release/ImageOverlayTool" ]; then
    echo "✅ 바이너리 생성 성공: $(ls -lh src-tauri/target/release/ImageOverlayTool | awk '{print $5}')"
else
    echo "❌ 바이너리 생성 실패"
fi

# 앱 번들 확인
if [ -d "src-tauri/target/release/bundle/macos/ImageOverlayTool.app" ]; then
    echo "✅ 앱 번들 생성 성공: $(du -sh src-tauri/target/release/bundle/macos/ImageOverlayTool.app | awk '{print $1}')"
    echo "📂 앱 번들 구조:"
    ls -la "src-tauri/target/release/bundle/macos/ImageOverlayTool.app/Contents/"
else
    echo "❌ 앱 번들 생성 실패"
    echo "📂 macos 폴더 내용:"
    ls -la src-tauri/target/release/bundle/macos/ 2>/dev/null || echo "macos 폴더 없음"
fi

# DMG 확인
if [ -f "src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg" ]; then
    DMG_SIZE=$(ls -lh "src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg" | awk '{print $5}')
    echo "✅ DMG 생성 성공: $DMG_SIZE"
    
    # DMG 크기로 성공 여부 판단 (정상적인 앱이면 5MB 이상)
    DMG_SIZE_BYTES=$(stat -f%z "src-tauri/target/release/bundle/dmg/ImageOverlayTool_1.4.7_aarch64.dmg")
    if [ $DMG_SIZE_BYTES -gt 5000000 ]; then
        echo "🎉 DMG 크기 정상! 번들링 성공으로 판단됩니다."
    else
        echo "⚠️  DMG 크기가 작습니다 ($DMG_SIZE). 번들링 문제가 있을 수 있습니다."
    fi
else
    echo "❌ DMG 생성 실패"
fi

echo ""
echo "🏁 Clean Rebuild 완료!"
echo "======================"
echo "💡 문제가 지속되면 Tauri 설정을 다시 확인하세요."
