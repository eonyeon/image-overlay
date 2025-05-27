#!/bin/bash

# 🍎 macOS DMG 손상 문제 즉시 해결 스크립트

echo "🔧 Image Overlay Tool DMG 복구 중..."

# DMG 파일 경로
DMG_PATH="/Users/eon/Downloads/macos-dmg (3)/Image overlay tool_1.4.7_aarch64.dmg"

# 파일 존재 확인
if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG 파일을 찾을 수 없습니다: $DMG_PATH"
    exit 1
fi

echo "📁 DMG 파일 발견: $(basename "$DMG_PATH")"

# 격리 속성 제거 (macOS 보안 기능)
echo "🔓 보안 격리 해제 중..."
sudo xattr -rd com.apple.quarantine "$DMG_PATH"

# 추가 확장 속성 제거
sudo xattr -c "$DMG_PATH"

echo "✅ DMG 파일 복구 완료!"
echo ""
echo "🚀 이제 DMG 파일을 더블클릭하여 실행하세요:"
echo "   $DMG_PATH"
echo ""
echo "📌 참고사항:"
echo "   - 첫 실행 시 '신뢰할 수 없는 개발자' 경고가 나올 수 있습니다"
echo "   - '시스템 설정 > 보안 및 개인정보보호 > 일반'에서 '확인 없이 열기' 클릭"
echo ""

# DMG 자동 열기
echo "📂 DMG 파일을 자동으로 여는 중..."
open "$DMG_PATH"

echo "🎉 완료! 이제 앱을 Applications 폴더로 드래그하세요."
