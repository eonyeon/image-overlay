# 📘 Tauri 크로스 플랫폼 빌드 완전 백서

> **Tauri 앱 개발 시 Windows/macOS 빌드 에러 없이 패키징하는 완전 가이드**  
> **Claude AI 어시스턴트가 다음 대화에서 즉시 인식하여 문제 해결 가능**

## 🎯 백서 목적

이 백서는 Tauri 앱 개발 시 아이콘 에러 및 크로스 플랫폼 빌드 문제를 **예방하고 신속하게 해결**하기 위한 완전한 가이드입니다. 특히 GitHub Actions CI/CD 환경에서 발생하는 문제들에 대한 실전 경험을 바탕으로 작성되었습니다.

---

## 📋 목차

1. [🚀 신속 시작 가이드](#-신속-시작-가이드)
2. [🔧 프로젝트 초기 설정](#-프로젝트-초기-설정)
3. [🎨 아이콘 시스템 구축](#-아이콘-시스템-구축)
4. [⚙️ GitHub Actions 설정](#️-github-actions-설정)
5. [🐛 트러블슈팅 가이드](#-트러블슈팅-가이드)
6. [✅ 체크리스트](#-체크리스트)
7. [📚 템플릿 모음](#-템플릿-모음)

---

## 🚀 신속 시작 가이드

### Claude AI 어시스턴트 인식용 컨텍스트

```markdown
**프로젝트 타입**: Tauri + Vite 크로스 플랫폼 데스크톱 앱
**주요 문제**: 아이콘 에러로 인한 Windows/macOS 빌드 실패
**해결 전략**: 3단계 접근법 (로컬 → CI/CD → 리포지토리)
**핵심 원칙**: 아이콘 파일을 Git에 포함하여 CI/CD 안정성 확보
```

### 긴급 상황 대응 (5분 해결)

```bash
# 1. 프로젝트 디렉토리 이동
cd your-tauri-project

# 2. 아이콘 문제 즉시 해결
mkdir -p src-tauri/icons

# macOS인 경우
sips -s format png --resampleWidth 512 --resampleHeight 512 \
  /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns \
  --out src-tauri/icons/icon.png

# Windows/Linux인 경우  
curl -o src-tauri/icons/icon.png "https://via.placeholder.com/512x512/4A90E2/FFFFFF?text=APP"

# 3. 모든 플랫폼 아이콘 생성
npx tauri icon src-tauri/icons/icon.png

# 4. 설정 파일 수정 (아래 템플릿 사용)
# src-tauri/tauri.conf.json의 icon 섹션 업데이트

# 5. Git 커밋
git add src-tauri/icons/ src-tauri/tauri.conf.json
git commit -m "Fix: Add all platform icons for Tauri build"
git push origin main
```

---

## 🔧 프로젝트 초기 설정

### 1. Tauri 프로젝트 구조 확인

```
your-tauri-project/
├── src/                          # 프론트엔드 소스
├── src-tauri/
│   ├── src/
│   ├── icons/                   # ⚠️ 이 폴더가 핵심!
│   ├── tauri.conf.json          # ⚠️ 아이콘 설정 중요!
│   └── Cargo.toml
├── .github/workflows/           # CI/CD 설정
├── package.json
└── README.md
```

### 2. package.json 필수 스크립트

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "tauri": "tauri",
    "tauri:dev": "tauri dev", 
    "tauri:build": "tauri build",
    "icons:generate": "npx tauri icon src-tauri/icons/icon.png",
    "icons:fix": "mkdir -p src-tauri/icons && npm run icons:generate",
    "build:safe": "npm run icons:fix && npm run tauri:build"
  },
  "devDependencies": {
    "@tauri-apps/api": "^1.5.0",
    "@tauri-apps/cli": "^1.5.0",
    "vite": "^4.4.0"
  }
}
```

### 3. tauri.conf.json 아이콘 설정 템플릿

```json
{
  "build": {
    "beforeBuildCommand": "npm run build",
    "beforeDevCommand": "npm run dev",
    "devPath": "http://localhost:5173",
    "distDir": "../dist"
  },
  "package": {
    "productName": "Your App Name",
    "version": "1.0.0"
  },
  "tauri": {
    "allowlist": {
      "all": false,
      "dialog": { "all": true },
      "fs": { "all": true },
      "path": { "all": true },
      "window": { "all": true }
    },
    "bundle": {
      "active": true,
      "category": "Productivity",
      "copyright": "Copyright © 2025 Your Company",
      "identifier": "com.yourcompany.yourapp",
      "longDescription": "Your app description",
      "icon": [
        "icons/32x32.png",
        "icons/128x128.png",
        "icons/128x128@2x.png", 
        "icons/icon.png",
        "icons/icon.ico"
      ],
      "targets": ["app", "dmg", "msi"],
      "macOS": {
        "signingIdentity": "-",
        "minimumSystemVersion": "10.13"
      },
      "windows": {
        "digestAlgorithm": "sha256",
        "webviewInstallMode": { "type": "embedBootstrapper" }
      }
    },
    "windows": [{
      "title": "Your App",
      "width": 800,
      "height": 600,
      "center": true,
      "resizable": true
    }]
  }
}
```

---

## 🎨 아이콘 시스템 구축

### 플랫폼별 아이콘 생성 방법

#### macOS (권장)
```bash
# 시스템 기본 아이콘 사용 (가장 안전)
sips -s format png --resampleWidth 512 --resampleHeight 512 \
  /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns \
  --out src-tauri/icons/icon.png

# 또는 커스텀 아이콘이 있다면
sips -s format png --resampleWidth 512 --resampleHeight 512 \
  /path/to/your/icon.png --out src-tauri/icons/icon.png
```

#### Windows
```powershell
# PowerShell에서 실행
New-Item -ItemType Directory -Path "src-tauri/icons" -Force
Invoke-WebRequest -Uri "https://via.placeholder.com/512x512/4A90E2/FFFFFF?text=APP" -OutFile "src-tauri/icons/icon.png"
```

#### Linux  
```bash
# ImageMagick 사용
sudo apt install imagemagick  # Ubuntu/Debian
convert -size 512x512 xc:"#4A90E2" -fill white -gravity center \
  -font Arial -pointsize 200 -annotate +0+0 "APP" src-tauri/icons/icon.png
```

### 자동 아이콘 생성

```bash
# 기본 512x512 아이콘에서 모든 플랫폼 아이콘 자동 생성
npx tauri icon src-tauri/icons/icon.png

# 생성되는 파일들 확인
ls -la src-tauri/icons/
```

**생성되는 필수 파일들:**
- `icon.png` (512x512) - 마스터 아이콘
- `32x32.png`, `64x64.png`, `128x128.png`, `128x128@2x.png`
- `icon.ico` - Windows 전용
- `icon.icns` - macOS 전용
- `StoreLogo.png`, `Square*Logo.png` - Windows Store용
- `android/`, `ios/` - 모바일 플랫폼용

---

## ⚙️ GitHub Actions 설정

### 완전한 워크플로우 템플릿

```yaml
# .github/workflows/build.yml
name: 🚀 Cross-Platform Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

env:
  APP_VERSION: "1.0.0"

jobs:
  # Windows 빌드
  build-windows:
    runs-on: windows-latest
    timeout-minutes: 60
    
    steps:
    - name: 📥 Checkout Repository
      uses: actions/checkout@v4

    - name: 🟢 Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: 🦀 Setup Rust
      uses: dtolnay/rust-toolchain@stable
      with:
        targets: x86_64-pc-windows-msvc

    - name: 🛠️ Install Windows Dependencies
      shell: powershell
      run: |
        choco install visualstudio2022buildtools -y --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools"

    - name: 📦 Install NPM Dependencies
      run: npm ci

    - name: 🎨 Ensure Tauri Icons (Windows)
      shell: powershell
      run: |
        Write-Host "Checking for Tauri icons..."
        
        # 아이콘이 이미 있는지 확인 (올바른 PowerShell 문법)
        if ((Test-Path "src-tauri/icons/icon.png") -and (Test-Path "src-tauri/icons/icon.ico")) {
          Write-Host "✅ Icons already exist, skipping generation"
          Get-ChildItem "src-tauri/icons" | ForEach-Object {
            Write-Host "   $($_.Name) ($([math]::Round($_.Length/1KB, 2)) KB)"
          }
        } else {
          Write-Host "🎨 Generating icons for Windows build..."
          
          # 아이콘 디렉토리 생성
          New-Item -ItemType Directory -Path "src-tauri/icons" -Force
          
          # 임시 아이콘 다운로드 (512x512)
          try {
            Invoke-WebRequest -Uri "https://via.placeholder.com/512x512/4A90E2/FFFFFF?text=APP" -OutFile "src-tauri/icons/icon.png"
            Write-Host "✅ Downloaded base icon"
            
            # Tauri CLI로 모든 아이콘 생성
            npx tauri icon src-tauri/icons/icon.png
            Write-Host "✅ Generated all platform icons"
          } catch {
            Write-Host "❌ Icon generation failed: $($_.Exception.Message)"
            exit 1
          }
        }

    - name: 🏗️ Build Frontend
      run: npm run build

    - name: 🚀 Build Tauri App (Windows)
      run: npm run tauri:build

    - name: 📤 Upload Windows MSI
      uses: actions/upload-artifact@v4
      with:
        name: windows-msi
        path: src-tauri/target/release/bundle/msi/*.msi
        retention-days: 30

  # macOS 빌드
  build-macos:
    runs-on: macos-latest
    timeout-minutes: 60
    
    steps:
    - name: 📥 Checkout Repository
      uses: actions/checkout@v4

    - name: 🟢 Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: 🦀 Setup Rust
      uses: dtolnay/rust-toolchain@stable
      with:
        targets: aarch64-apple-darwin

    - name: 📦 Install NPM Dependencies
      run: npm ci

    - name: 🎨 Ensure Tauri Icons (macOS)
      run: |
        echo "🔍 Checking for Tauri icons..."
        
        # 아이콘이 이미 있는지 확인
        if [ -f "src-tauri/icons/icon.png" ] && [ -f "src-tauri/icons/icon.icns" ]; then
          echo "✅ Icons already exist, skipping generation"
          ls -la src-tauri/icons/
        else
          echo "🎨 Generating icons for macOS build..."
          
          # 아이콘 디렉토리 생성
          mkdir -p src-tauri/icons
          
          # macOS 시스템 아이콘 사용 (가장 안전한 방법)
          if [ -f "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns" ]; then
            sips -s format png --resampleWidth 512 --resampleHeight 512 \
              /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns \
              --out src-tauri/icons/icon.png
            echo "✅ Created base icon from system resources"
          else
            # 대안: 온라인에서 다운로드
            curl -o src-tauri/icons/icon.png "https://via.placeholder.com/512x512/4A90E2/FFFFFF?text=APP"
            echo "✅ Downloaded base icon"
          fi
          
          # Tauri CLI로 모든 아이콘 생성
          npx tauri icon src-tauri/icons/icon.png
          echo "✅ Generated all platform icons"
        fi

    - name: 🏗️ Build Frontend
      run: npm run build

    - name: 🚀 Build Tauri App (macOS)
      run: npm run tauri:build
      env:
        MACOSX_DEPLOYMENT_TARGET: "10.13"

    - name: 📤 Upload macOS DMG
      uses: actions/upload-artifact@v4
      with:
        name: macos-dmg
        path: src-tauri/target/release/bundle/dmg/*.dmg
        retention-days: 30

  # 릴리즈 생성
  release:
    needs: [build-windows, build-macos]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
    - name: 📥 Download All Artifacts
      uses: actions/download-artifact@v4
      with:
        path: artifacts

    - name: 🎉 Create GitHub Release
      uses: softprops/action-gh-release@v1
      with:
        tag_name: v${{ env.APP_VERSION }}-build${{ github.run_number }}
        name: "🚀 Release v${{ env.APP_VERSION }} - Build ${{ github.run_number }}"
        body: |
          ## 🎯 Cross-Platform Desktop App Release
          
          **Version:** ${{ env.APP_VERSION }}  
          **Build:** ${{ github.run_number }}  
          **Commit:** ${{ github.sha }}
          
          ### 📥 Download
          - **Windows**: `.msi` installer
          - **macOS**: `.dmg` installer
          
          ### 🔧 Installation
          - **Windows**: Right-click MSI → "Run as administrator"
          - **macOS**: Open DMG → Drag to Applications folder
        files: |
          artifacts/windows-msi/*
          artifacts/macos-dmg/*
        draft: false
        prerelease: false
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## 🐛 트러블슈팅 가이드

### 자주 발생하는 문제와 해결법

#### 1. "Failed to create app icon" 에러

**증상:**
```
Error failed to bundle project: Failed to create app icon
```

**원인 및 해결:**
```bash
# 원인: 아이콘 파일 누락 또는 경로 오류
# 해결: 아이콘 재생성
mkdir -p src-tauri/icons
npx tauri icon src-tauri/icons/icon.png

# tauri.conf.json 확인
grep -A 10 '"icon"' src-tauri/tauri.conf.json
```

#### 2. PowerShell 문법 에러 (Windows)

**증상:**
```
Test-Path : A parameter cannot be found that matches parameter name 'and'
```

**해결:**
```powershell
# ❌ 잘못된 문법
if (Test-Path "file1" -and Test-Path "file2")

# ✅ 올바른 문법  
if ((Test-Path "file1") -and (Test-Path "file2"))
```

#### 3. "Can't read and decode source image" 에러

**증상:**
```
Error Can't read and decode source image: No such file or directory
```

**해결:**
```bash
# 원인: 기본 소스 이미지 없음
# 해결: 512x512 기본 이미지 생성 후 아이콘 생성

# macOS
sips -s format png --resampleWidth 512 --resampleHeight 512 \
  /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns \
  --out src-tauri/icons/icon.png

npx tauri icon src-tauri/icons/icon.png
```

#### 4. GitHub Actions 환경 차이

**증상:**
- 로컬에서는 성공하지만 GitHub Actions에서 실패

**해결:**
```yaml
# 조건부 아이콘 생성 로직 추가
- name: 🎨 Conditional Icon Generation
  run: |
    if [ ! -f "src-tauri/icons/icon.png" ]; then
      echo "Generating missing icons..."
      mkdir -p src-tauri/icons
      # 아이콘 생성 로직
    else
      echo "Icons already exist, skipping..."
    fi
```

#### 5. 크로스 컴파일 에러

**증상:**
```
error: failed to run custom build command for 'tauri-build'
```

**해결:**
```bash
# Rust 타겟 추가
rustup target add x86_64-pc-windows-msvc     # Windows
rustup target add aarch64-apple-darwin       # macOS ARM  
rustup target add x86_64-apple-darwin        # macOS Intel

# 빌드 시 타겟 명시
npm run tauri:build -- --target x86_64-pc-windows-msvc
```

### 디버깅 명령어 모음

```bash
# 아이콘 상태 확인
ls -la src-tauri/icons/
file src-tauri/icons/*

# Tauri 설정 검증
npx tauri info

# 의존성 확인
npm list @tauri-apps/cli
rustc --version
```

---

## ✅ 체크리스트

### 프로젝트 시작 시

- [ ] `src-tauri/icons/` 디렉토리 생성
- [ ] 512x512 기본 아이콘 생성
- [ ] `npx tauri icon` 실행하여 모든 아이콘 생성
- [ ] `tauri.conf.json`에 아이콘 경로 설정
- [ ] 로컬 빌드 테스트 (`npm run tauri:build`)
- [ ] 아이콘 파일들 Git에 커밋

### GitHub Actions 설정 시

- [ ] 워크플로우 파일 생성 (`.github/workflows/build.yml`)
- [ ] Windows/macOS 빌드 잡 설정
- [ ] 조건부 아이콘 생성 로직 추가
- [ ] PowerShell 문법 검증 (Windows)
- [ ] 아티팩트 업로드 설정
- [ ] 자동 릴리즈 설정 (선택사항)

### 배포 전 최종 점검

- [ ] 두 플랫폼 모두 빌드 성공
- [ ] 생성된 인스톨러 다운로드 테스트
- [ ] 실제 설치 및 실행 테스트
- [ ] 아이콘이 올바르게 표시되는지 확인
- [ ] 앱 메타데이터 확인 (이름, 버전, 저작권 등)

### 문제 발생 시

- [ ] 에러 메시지 정확히 확인
- [ ] 트러블슈팅 가이드 참조
- [ ] 로컬에서 먼저 해결 시도
- [ ] 아이콘 파일 재생성
- [ ] GitHub Actions 로그 확인
- [ ] 필요시 워크플로우 수정

---

## 📚 템플릿 모음

### 1. 빠른 아이콘 수정 스크립트

```bash
#!/bin/bash
# quick-fix-icons.sh

echo "🎨 Tauri 아이콘 빠른 수정 스크립트"

# 아이콘 디렉토리 생성
mkdir -p src-tauri/icons

# 플랫폼별 기본 아이콘 생성
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📱 macOS: 시스템 아이콘 사용"
    sips -s format png --resampleWidth 512 --resampleHeight 512 \
      /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns \
      --out src-tauri/icons/icon.png
else
    echo "🌐 Linux/WSL: 임시 아이콘 다운로드"
    curl -o src-tauri/icons/icon.png "https://via.placeholder.com/512x512/4A90E2/FFFFFF?text=APP"
fi

# Tauri 아이콘 생성
echo "⚙️ 모든 플랫폼 아이콘 생성"
npx tauri icon src-tauri/icons/icon.png

# 결과 확인
echo "✅ 생성된 아이콘:"
ls -la src-tauri/icons/

echo "🚀 이제 'npm run tauri:build'를 실행하세요!"
```

### 2. package.json 스크립트 확장

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build", 
    "preview": "vite preview",
    "tauri": "tauri",
    "tauri:dev": "tauri dev",
    "tauri:build": "tauri build",
    "tauri:build:debug": "tauri build --debug",
    
    "icons:generate": "npx tauri icon src-tauri/icons/icon.png",
    "icons:clean": "rm -rf src-tauri/icons && mkdir -p src-tauri/icons",
    "icons:fix": "bash quick-fix-icons.sh",
    
    "build:safe": "npm run icons:fix && npm run build && npm run tauri:build",
    "build:win": "npm run tauri:build -- --target x86_64-pc-windows-msvc",
    "build:mac": "npm run tauri:build -- --target aarch64-apple-darwin",
    
    "check:icons": "ls -la src-tauri/icons/",
    "check:config": "cat src-tauri/tauri.conf.json | grep -A 10 '\"icon\"'",
    "check:tauri": "npx tauri info"
  }
}
```

### 3. .gitignore 추가사항

```gitignore
# Tauri
src-tauri/target/

# 하지만 아이콘은 반드시 포함!
!src-tauri/icons/

# 빌드 아티팩트
*.msi
*.dmg  
*.deb
*.AppImage

# 로그 파일
*.log
npm-debug.log*
```

### 4. README.md 템플릿

```markdown
# Your Tauri App

## 🚀 개발 환경 설정

### 필수 요구사항
- Node.js 18+
- Rust
- npm 또는 yarn

### 설치 및 실행
```bash
# 의존성 설치
npm install

# 개발 서버 시작
npm run tauri:dev

# 아이콘 문제 해결 (필요시)
npm run icons:fix

# 프로덕션 빌드
npm run build:safe
```

### 빌드 문제 해결
아이콘 관련 에러가 발생하면:
1. `npm run icons:fix` 실행
2. `npm run check:icons`로 파일 확인
3. `npm run build:safe`로 안전한 빌드

자세한 내용은 [Tauri 빌드 백서](./TAURI_BUILD_WHITEPAPER.md) 참조
```

---

## 🔍 Claude AI 인식을 위한 메타데이터

```yaml
# Claude AI 컨텍스트 정보
project_type: "Tauri Desktop App"
common_issues:
  - "Icon generation failures"
  - "Cross-platform build errors" 
  - "GitHub Actions CI/CD issues"
  - "PowerShell syntax errors"

solution_strategy:
  approach: "3-stage process"
  stages:
    1: "Local icon generation and testing"
    2: "GitHub Actions workflow optimization"  
    3: "Repository icon inclusion for stability"

key_principles:
  - "Always include icon files in Git repository"
  - "Use conditional logic in CI/CD"
  - "Platform-specific fallback mechanisms"
  - "Test locally before CI/CD deployment"

critical_files:
  - "src-tauri/tauri.conf.json"
  - "src-tauri/icons/ (entire directory)"
  - ".github/workflows/build.yml"
  - "package.json"

emergency_commands:
  - "npm run icons:fix"
  - "npx tauri icon src-tauri/icons/icon.png"
  - "npm run build:safe"
```

---

## 📞 Claude AI 어시스턴트 활용 가이드

### 다음 대화에서 사용할 프롬프트 예시

```
"Tauri 앱 개발 중 아이콘 에러가 발생했습니다. TAURI_BUILD_WHITEPAPER.md를 참고하여 문제를 해결해주세요."

또는

"Tauri 크로스 플랫폼 빌드 설정을 도와주세요. 백서의 템플릿을 사용해서 GitHub Actions 워크플로우를 설정하고 싶습니다."
```

### Claude가 즉시 인식할 수 있는 정보

1. **프로젝트 타입**: Tauri + Vite 데스크톱 앱
2. **주요 문제**: 아이콘 에러, 크로스 플랫폼 빌드
3. **해결 전략**: 3단계 접근법
4. **핵심 파일들**: 위치와 역할 명시
5. **즉시 실행 명령어**: 상황별 대응 스크립트
6. **플랫폼별 특이사항**: Windows/macOS/Linux 차이점

---

## 🎯 결론

이 백서는 **실제 프로젝트에서 겪은 문제들과 해결 과정**을 바탕으로 작성되었습니다. Tauri 앱 개발 시 가장 자주 발생하는 아이콘 및 빌드 문제들을 예방하고, 발생 시 신속하게 해결할 수 있는 완전한 가이드를 제공합니다.

**핵심 원칙**: 
- 🔒 **아이콘 파일을 Git에 포함**하여 CI/CD 안정성 확보
- 🔄 **조건부 생성 로직**으로 유연한 빌드 시스템 구축  
- 🛡️ **플랫폼별 폴백 메커니즘**으로 안정성 보장
- 📋 **체계적인 체크리스트**로 실수 방지

이 백서를 활용하면 **Tauri 앱 개발 시 빌드 문제 없이 안정적으로 크로스 플랫폼 배포**가 가능합니다.

---

**📝 문서 버전**: 1.0  
**📅 작성일**: 2025-05-28  
**🔄 최종 검증**: image-overlay 프로젝트 빌드 성공 확인  
**👨‍💻 작성자**: Claude Assistant (실전 경험 기반)
