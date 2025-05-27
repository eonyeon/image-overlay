#!/bin/bash

# 🔧 문제 해결 테스트 빌드 스크립트

echo "🔧 Image Overlay Tool 문제 해결 빌드"
echo "===================================="

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📋 1단계: 현재 설정 백업"
cp src-tauri/Cargo.toml src-tauri/Cargo_backup.toml
echo "✅ 백업 완료: Cargo_backup.toml"

echo ""
echo "📋 2단계: 수정된 설정 적용"
cp src-tauri/Cargo_fixed.toml src-tauri/Cargo.toml
echo "✅ 수정된 Cargo.toml 적용"

echo ""
echo "📋 3단계: 캐시 완전 정리"
cargo clean --manifest-path src-tauri/Cargo.toml
rm -rf src-tauri/target/
echo "✅ 빌드 캐시 정리 완료"

echo ""
echo "📋 4단계: 의존성 업데이트"
cd src-tauri
cargo update
cd ..
echo "✅ 의존성 업데이트 완료"

echo ""
echo "📋 5단계: 프론트엔드 빌드"
npm run build
echo "✅ 프론트엔드 빌드 완료"

echo ""
echo "📋 6단계: Tauri 앱 빌드 (verbose)"
echo "🔍 빌드 과정을 자세히 관찰합니다..."
RUST_LOG=debug npm run tauri build

echo ""
echo "📋 7단계: 결과 확인"
if [ -f "src-tauri/target/release/bundle/dmg/Image overlay tool_1.4.7_aarch64.dmg" ]; then
    DMG_SIZE=$(ls -lh "src-tauri/target/release/bundle/dmg/Image overlay tool_1.4.7_aarch64.dmg" | awk '{print $5}')
    echo "✅ DMG 생성 완료: $DMG_SIZE"
    
    if [[ "$DMG_SIZE" == *"M"* ]] && [[ "${DMG_SIZE//[!0-9]/}" -gt 10 ]]; then
        echo "🎉 성공! 정상적인 크기의 DMG가 생성되었습니다."
    else
        echo "⚠️ 여전히 크기가 작습니다: $DMG_SIZE"
    fi
else
    echo "❌ DMG 생성 실패"
fi

echo ""
echo "📋 8단계: 실행 파일 직접 확인"
BINARY_PATH="src-tauri/target/release/image-overlay"
if [ -f "$BINARY_PATH" ]; then
    BINARY_SIZE=$(ls -lh "$BINARY_PATH" | awk '{print $5}')
    echo "✅ 실행 파일 크기: $BINARY_SIZE"
    echo "🔍 실행 파일 타입: $(file "$BINARY_PATH")"
else
    echo "❌ 실행 파일이 생성되지 않았습니다"
fi

echo ""
echo "🔄 롤백 방법:"
echo "cp src-tauri/Cargo_backup.toml src-tauri/Cargo.toml"
echo ""
echo "✅ 테스트 빌드 완료!"
