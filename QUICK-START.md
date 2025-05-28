# 🚀 Image Overlay Tool - 빠른 시작 가이드

## 📦 즉시 사용하기

### 1️⃣ 로컬 빌드 테스트
```bash
# 스크립트 실행 권한 부여
chmod +x test-build-fixed.sh

# 빌드 테스트 실행
./test-build-fixed.sh
```

### 2️⃣ 개발 모드 실행
```bash
# 의존성 설치
npm install

# 개발 서버 시작
npm run tauri dev
```

### 3️⃣ 프로덕션 빌드
```bash
# 프론트엔드 빌드
npm run build

# 앱 빌드
npm run tauri build
```

## 🔧 문제 해결됨!

### ✅ Windows 빌드 문제
- **이전**: WebView2 패키지 찾기 오류
- **해결**: 올바른 Visual Studio Build Tools 및 Edge 설치

### ✅ macOS DMG 손상 문제  
- **이전**: DMG 파일 손상으로 앱 실행 불가
- **해결**: create-dmg와 코드 사이닝으로 정상 DMG 생성

## 🎯 GitHub Actions 배포

1. 코드를 GitHub 저장소로 푸시
2. Actions 탭에서 "Fixed Multi-Platform Build" 워크플로우 확인
3. 빌드 완료 후 Artifacts에서 다운로드
4. Windows: `.msi` 파일 / macOS: `.dmg` 파일

## 📞 도움이 필요하시나요?

**개발자 연락처**: Eric (eon232@gmail.com)

**GitHub Issues**: [문제 신고하기](https://github.com/your-repo/issues)

---

**🎉 이제 모든 빌드 문제가 해결되었습니다!**
