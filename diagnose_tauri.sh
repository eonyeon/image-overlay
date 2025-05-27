#!/bin/bash
# Tauri 버전 및 환경 진단 스크립트
echo "🔍 Tauri 환경 진단 시작..."
echo "============================"

cd /Users/eon/Desktop/testflight-clean/image-overlay

echo "📦 1. Tauri CLI 버전 확인"
echo "-------------------------"
echo "Global Tauri CLI:"
tauri --version 2>/dev/null || echo "❌ Global Tauri CLI 없음"

echo ""
echo "Local Tauri CLI (npm):"
npx tauri --version 2>/dev/null || echo "❌ Local Tauri CLI 없음"

echo ""
echo "🦀 2. Cargo 정보"
echo "----------------"
echo "Rust 버전:"
rustc --version 2>/dev/null || echo "❌ Rust 없음"

echo ""
echo "Cargo 버전:"
cargo --version 2>/dev/null || echo "❌ Cargo 없음"

echo ""
echo "📋 3. 프로젝트 의존성 버전"
echo "-------------------------"
echo "package.json의 Tauri 의존성:"
grep -A5 -B5 "tauri" package.json 2>/dev/null || echo "❌ package.json 읽기 실패"

echo ""
echo "Cargo.toml의 Tauri 의존성:"
grep -A2 -B2 "tauri" src-tauri/Cargo.toml 2>/dev/null || echo "❌ Cargo.toml 읽기 실패"

echo ""
echo "🆕 4. 새 프로젝트 템플릿 확인"
echo "-----------------------------"
echo "⚠️  임시 디렉토리에 새 Tauri 프로젝트 생성으로 올바른 템플릿 확인..."

# 임시 디렉토리에 새 프로젝트 생성
cd /tmp
rm -rf tauri-test-project 2>/dev/null

echo "새 Tauri 프로젝트 생성 중..."
npx create-tauri-app@latest tauri-test-project --template vanilla --package-manager npm --yes 2>/dev/null || echo "❌ 새 프로젝트 생성 실패"

if [ -d "tauri-test-project" ]; then
    echo "✅ 새 프로젝트 생성 성공"
    echo ""
    echo "📄 새 프로젝트의 tauri.conf.json 구조:"
    echo "======================================="
    cat tauri-test-project/src-tauri/tauri.conf.json 2>/dev/null || echo "❌ 새 프로젝트 설정 읽기 실패"
    echo ""
    echo "🦀 새 프로젝트의 Cargo.toml Tauri 버전:"
    grep "tauri.*=" tauri-test-project/src-tauri/Cargo.toml 2>/dev/null || echo "❌ 새 프로젝트 Cargo.toml 읽기 실패"
else
    echo "❌ 새 프로젝트 생성 실패"
fi

echo ""
echo "🏁 진단 완료!"
echo "============="
echo "💡 결과를 바탕으로 올바른 설정 구조를 파악하겠습니다."
