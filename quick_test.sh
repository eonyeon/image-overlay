#!/bin/bash
# Quick Test Build - 설정 검증용
echo "🔍 Quick Test Build 시작..."
echo "============================="

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📋 1. Tauri 설정 검증"
echo "---------------------"
cd src-tauri
cargo tauri build --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Tauri CLI 작동 정상"
else
    echo "❌ Tauri CLI 문제 발견"
    exit 1
fi

echo ""
echo "📱 2. 빌드 테스트 (verbose)"
echo "--------------------------"
echo "⚠️  설정 오류 확인 중..."

# Verbose 모드로 빌드 시작 부분만 확인
timeout 30s cargo tauri build --verbose 2>&1 | head -50

echo ""
echo "🏁 Quick Test 완료!"
echo "==================="
echo "💡 오류가 없으면 전체 빌드를 진행하세요."
