#!/usr/bin/env python3
"""
🎨 Tauri 아이콘 생성 스크립트
간단한 기본 아이콘들을 생성하여 Windows 빌드 오류를 해결합니다.
"""

import os
import base64
from PIL import Image, ImageDraw, ImageFont
import io

def create_icon(size, text="IO", bg_color="#4A90E2", text_color="white"):
    """지정된 크기의 아이콘 생성"""
    img = Image.new('RGBA', (size, size), bg_color)
    draw = ImageDraw.Draw(img)
    
    # 텍스트 크기 계산
    font_size = size // 4
    try:
        # 시스템 기본 폰트 사용 시도
        font = ImageFont.truetype("/System/Library/Fonts/Arial.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
        except:
            font = ImageFont.load_default()
    
    # 텍스트 중앙 정렬
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    draw.text((x, y), text, font=font, fill=text_color)
    
    return img

def create_ico_file(icon_path, ico_path):
    """PNG에서 ICO 파일 생성"""
    img = Image.open(icon_path)
    
    # ICO 파일에 필요한 여러 크기 생성
    sizes = [16, 24, 32, 48, 64, 128, 256]
    images = []
    
    for size in sizes:
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        images.append(resized)
    
    # ICO 파일로 저장
    images[0].save(ico_path, format='ICO', sizes=[(img.width, img.height) for img in images])

def main():
    print("🎨 Tauri 아이콘 생성 중...")
    
    # 아이콘 디렉토리 생성
    icons_dir = "/Users/eon/Desktop/testflight-clean/image-overlay/src-tauri/icons"
    os.makedirs(icons_dir, exist_ok=True)
    
    # 필요한 아이콘 크기들
    icon_sizes = {
        "32x32.png": 32,
        "128x128.png": 128,
        "128x128@2x.png": 256,
        "icon.png": 512
    }
    
    # PNG 아이콘들 생성
    for filename, size in icon_sizes.items():
        print(f"📱 생성 중: {filename} ({size}x{size})")
        icon = create_icon(size)
        icon_path = os.path.join(icons_dir, filename)
        icon.save(icon_path, "PNG")
        print(f"✅ 생성 완료: {filename}")
    
    # ICO 파일 생성 (Windows용)
    print("🪟 Windows ICO 파일 생성 중...")
    icon_png_path = os.path.join(icons_dir, "icon.png")
    ico_path = os.path.join(icons_dir, "icon.ico")
    
    create_ico_file(icon_png_path, ico_path)
    print("✅ icon.ico 생성 완료")
    
    # macOS ICNS 파일은 별도 도구 필요
    print("\n🍎 macOS ICNS 파일:")
    print("   sips -s format icns icon.png --out icon.icns")
    print("   (macOS에서 수동 실행 필요)")
    
    print("\n🎉 기본 아이콘 생성 완료!")
    print("📁 생성된 파일들:")
    for file in os.listdir(icons_dir):
        if file.endswith(('.png', '.ico')):
            file_path = os.path.join(icons_dir, file)
            file_size = os.path.getsize(file_path)
            print(f"   {file} ({file_size} bytes)")

if __name__ == "__main__":
    main()
