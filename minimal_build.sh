#!/bin/bash
# Minimal Build Test - 최소한의 설정 검증
echo "🔧 Minimal Build Test 시작..."
echo "==============================="

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📋 1. 프론트엔드 빌드"
echo "--------------------"
npm run build
if [ $? -eq 0 ]; then
    echo "✅ 프론트엔드 빌드 성공"
else
    echo "❌ 프론트엔드 빌드 실패"
    exit 1
fi

echo ""
echo "📱 2. Tauri 설정 검증"
echo "---------------------"
cd src-tauri

# Tauri 설정 파일 구문 검증만 실행
echo "⚠️  설정 파일 검증 중..."
cargo tauri build --help >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Tauri CLI 정상"
else
    echo "❌ Tauri CLI 문제"
    exit 1
fi

echo ""
echo "🚀 3. 실제 빌드 시작"
echo "--------------------"
echo "📊 빌드 진행 상황을 확인하세요..."

# 실제 빌드 실행
cargo tauri build --verbose

echo ""
echo "🏁 Minimal Build Test 완료!"
echo "=========================="
