#!/bin/bash

# 🔧 Image Overlay Tool - 수동 DMG 생성 스크립트
# Tauri의 bundle_dmg.sh가 실패할 때 사용하는 안정적인 대안

echo "🔧 Manual DMG Creation Script"
echo "=============================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "src-tauri/Cargo.toml" ]; then
    print_error "This script must be run from the project root directory"
    exit 1
fi

APP_BUNDLE_DIR="src-tauri/target/release/bundle/macos"
DMG_OUTPUT_DIR="src-tauri/target/release/bundle/dmg"
APP_NAME="Image overlay tool.app"
VERSION="1.4.7"

print_status "Checking app bundle..."

if [ ! -d "$APP_BUNDLE_DIR/$APP_NAME" ]; then
    print_error "App bundle not found at $APP_BUNDLE_DIR/$APP_NAME"
    print_status "Please run 'npm run tauri:build' first"
    exit 1
fi

APP_SIZE=$(du -sh "$APP_BUNDLE_DIR/$APP_NAME" | awk '{print $1}')
print_success "App bundle found: $APP_NAME ($APP_SIZE)"

# Create DMG output directory if it doesn't exist
mkdir -p "$DMG_OUTPUT_DIR"

print_status "Creating DMG using create-dmg..."

# Clean up any existing DMG files
rm -f "$DMG_OUTPUT_DIR"/*.dmg 2>/dev/null || true

# Check if create-dmg is available
if ! command -v create-dmg >/dev/null 2>&1; then
    print_error "create-dmg not found. Installing via Homebrew..."
    if command -v brew >/dev/null 2>&1; then
        brew install create-dmg
    else
        print_error "Homebrew not found. Please install create-dmg manually."
        exit 1
    fi
fi

# Create temporary directory for DMG contents
TEMP_DIR=$(mktemp -d)
print_status "Temp directory: $TEMP_DIR"

# Copy app bundle to temp directory
print_status "Copying app bundle..."
cp -R "$APP_BUNDLE_DIR/$APP_NAME" "$TEMP_DIR/"

# Create Applications symlink
print_status "Creating Applications symlink..."
ln -s /Applications "$TEMP_DIR/Applications"

print_status "Verifying temp directory contents..."
ls -la "$TEMP_DIR/"

# Apply code signing (ad-hoc)
print_status "Applying code signing..."
codesign --force --deep --sign - "$TEMP_DIR/$APP_NAME" || print_warning "Code signing failed, but continuing..."

# Create DMG with create-dmg
print_status "Generating DMG file..."

DMG_NAME="Image_overlay_tool_v${VERSION}_manual.dmg"
DMG_PATH="$DMG_OUTPUT_DIR/$DMG_NAME"

create-dmg \
    --volname "Image Overlay Tool v$VERSION" \
    --volicon "$TEMP_DIR/$APP_NAME/Contents/Resources/app.icns" \
    --window-pos 200 120 \
    --window-size 800 450 \
    --icon-size 100 \
    --icon "$APP_NAME" 200 190 \
    --hide-extension "$APP_NAME" \
    --app-drop-link 600 185 \
    --no-internet-enable \
    "$DMG_PATH" \
    "$TEMP_DIR" || {
        print_warning "create-dmg failed, trying basic hdiutil method..."
        
        # Alternative: Use hdiutil directly
        BASIC_DMG_NAME="Image_overlay_tool_v${VERSION}_basic.dmg"
        BASIC_DMG_PATH="$DMG_OUTPUT_DIR/$BASIC_DMG_NAME"
        
        hdiutil create -volname "Image Overlay Tool v$VERSION" \
            -srcfolder "$TEMP_DIR" \
            -ov -format UDZO \
            "$BASIC_DMG_PATH"
            
        if [ $? -eq 0 ]; then
            print_success "Basic DMG created successfully: $BASIC_DMG_NAME"
            DMG_PATH="$BASIC_DMG_PATH"
            DMG_NAME="$BASIC_DMG_NAME"
        else
            print_error "Both create-dmg and hdiutil failed"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    }

# Clean up temp directory
rm -rf "$TEMP_DIR"

# Verify the created DMG
if [ -f "$DMG_PATH" ]; then
    DMG_SIZE=$(ls -lah "$DMG_PATH" | awk '{print $5}')
    print_success "DMG created successfully: $DMG_NAME ($DMG_SIZE)"
    
    # Simple verification
    print_status "Verifying DMG..."
    if hdiutil verify "$DMG_PATH" >/dev/null 2>&1; then
        print_success "DMG verification passed"
    else
        print_warning "DMG verification failed, but file exists"
    fi
    
    print_status "DMG location: $DMG_PATH"
else
    print_error "DMG creation failed"
    exit 1
fi

echo ""
print_success "Manual DMG creation completed successfully!"
print_status "You can now test the DMG by double-clicking it"
