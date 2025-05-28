#!/usr/bin/env node

/**
 * 🎨 Tauri 아이콘 생성 스크립트 (ES 모듈)
 * 기본 아이콘들을 생성하여 Windows 빌드 오류를 해결합니다.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// ES 모듈에서 __dirname 대체
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('🎨 Tauri 기본 아이콘 생성 중...');

// 아이콘 디렉토리 생성
const iconsDir = path.join(__dirname, 'src-tauri', 'icons');
if (!fs.existsSync(iconsDir)) {
    fs.mkdirSync(iconsDir, { recursive: true });
    console.log('📁 아이콘 디렉토리 생성:', iconsDir);
}

// 간단한 1x1 PNG 이미지 데이터 (투명)
const simplePngBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQIHWNgAAIAAAUAAY27m/MAAAAASUVORK5CYII=';
const simplePngBuffer = Buffer.from(simplePngBase64, 'base64');

// 기본 ICO 파일 데이터 (16x16 투명 아이콘)
const basicIcoBase64 = 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABMLAAATCwAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AAAAAAA=';
const basicIcoBuffer = Buffer.from(basicIcoBase64, 'base64');

// 필요한 아이콘 파일들 생성
const iconFiles = [
    { name: '32x32.png', data: simplePngBuffer },
    { name: '128x128.png', data: simplePngBuffer },
    { name: '128x128@2x.png', data: simplePngBuffer },
    { name: 'icon.png', data: simplePngBuffer },
    { name: 'icon.ico', data: basicIcoBuffer }
];

console.log('📝 생성할 아이콘 파일들:');
iconFiles.forEach(({ name }) => {
    console.log(`   - ${name}`);
});

// 파일 생성
iconFiles.forEach(({ name, data }) => {
    const filePath = path.join(iconsDir, name);
    fs.writeFileSync(filePath, data);
    console.log(`✅ 생성 완료: ${name} (${data.length} bytes)`);
});

// macOS ICNS 파일도 생성 (동일한 데이터로)
const icnsPath = path.join(iconsDir, 'icon.icns');
fs.writeFileSync(icnsPath, basicIcoBuffer); // 임시로 ICO 데이터 사용
console.log(`✅ 생성 완료: icon.icns (${basicIcoBuffer.length} bytes)`);

console.log('');
console.log('🎉 기본 아이콘 생성 완료!');
console.log('📁 생성된 위치:', iconsDir);
console.log('');
console.log('📋 생성된 파일 목록:');
fs.readdirSync(iconsDir).forEach(file => {
    const filePath = path.join(iconsDir, file);
    const stats = fs.statSync(filePath);
    console.log(`   ${file} (${stats.size} bytes)`);
});

console.log('');
console.log('🚀 이제 Tauri 빌드를 실행할 수 있습니다:');
console.log('   npm run tauri:build');
console.log('');
console.log('💡 나중에 실제 앱 아이콘으로 교체하세요!');
