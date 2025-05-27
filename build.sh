#!/bin/bash

echo "🚀 Image Overlay Tool v1.4.7 - 빌드 스크립트"
echo "=============================================="

# 현재 디렉토리 확인
if [ ! -f "package.json" ]; then
    echo "❌ 오류: package.json이 없습니다. 프로젝트 루트에서 실행해주세요."
    exit 1
fi

echo ""
echo "📦 1단계: 의존성 설치"
npm install
if [ $? -ne 0 ]; then
    echo "❌ npm install 실패"
    exit 1
fi

echo ""
echo "🏗️ 2단계: 프론트엔드 빌드"
npm run build
if [ $? -ne 0 ]; then
    echo "❌ 프론트엔드 빌드 실패"
    exit 1
fi

echo ""
echo "⚙️ 3단계: Tauri 앱 빌드"
npm run tauri build
if [ $? -ne 0 ]; then
    echo "❌ Tauri 빌드 실패"
    exit 1
fi

echo ""
echo "✅ 빌드 완료!"
echo ""
echo "📁 빌드 결과물:"
if [ "$(uname)" = "Darwin" ]; then
    echo "  • macOS DMG: src-tauri/target/release/bundle/dmg/"
    ls -la src-tauri/target/release/bundle/dmg/ 2>/dev/null || echo "    (빌드된 DMG 파일 없음)"
fi

echo "  • 실행 파일: src-tauri/target/release/"
ls -la src-tauri/target/release/image-overlay* 2>/dev/null || echo "    (실행 파일 확인 필요)"

echo ""
echo "🎯 다음 단계:"
echo "  1. 앱 테스트: 빌드된 실행 파일로 기능 확인"
echo "  2. 배포: GitHub Actions 또는 수동 배포"
echo "  3. 사용자 가이드: README.md 참조"
