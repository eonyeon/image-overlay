#!/bin/bash

# Make script executable
chmod +x "$0"

# 🚀 Image Overlay Tool - Fixed Build Test Script
# This script tests the build process locally before pushing to GitHub

echo "🚀 Image Overlay Tool - Fixed Build Test"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -f "src-tauri/Cargo.toml" ]; then
    print_error "This script must be run from the project root directory"
    exit 1
fi

print_status "Checking build environment..."

# Check Node.js
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
else
    print_error "Node.js not found. Please install Node.js 18+"
    exit 1
fi

# Check npm
if command -v npm >/dev/null 2>&1; then
    NPM_VERSION=$(npm --version)
    print_success "npm found: $NPM_VERSION"
else
    print_error "npm not found"
    exit 1
fi

# Check Rust
if command -v rustc >/dev/null 2>&1; then
    RUST_VERSION=$(rustc --version)
    print_success "Rust found: $RUST_VERSION"
else
    print_error "Rust not found. Please install Rust from https://rustup.rs/"
    exit 1
fi

# Check Tauri CLI
if command -v cargo >/dev/null 2>&1 && cargo install --list | grep -q tauri-cli; then
    print_success "Tauri CLI found"
else
    print_warning "Tauri CLI not found, installing..."
    cargo install tauri-cli
fi

# Platform-specific checks
case "$(uname -s)" in
    Darwin*)
        print_status "macOS detected"
        
        # Check for create-dmg
        if command -v create-dmg >/dev/null 2>&1; then
            print_success "create-dmg found"
        else
            print_warning "create-dmg not found, installing via Homebrew..."
            if command -v brew >/dev/null 2>&1; then
                brew install create-dmg
            else
                print_error "Homebrew not found. Please install create-dmg manually."
            fi
        fi
        
        # Check codesign
        if command -v codesign >/dev/null 2>&1; then
            print_success "codesign found"
        else
            print_warning "codesign not found (Xcode Command Line Tools required)"
        fi
        ;;
        
    MINGW*|MSYS*|CYGWIN*)
        print_status "Windows detected"
        
        # Check for MSVC
        if command -v cl.exe >/dev/null 2>&1; then
            print_success "MSVC compiler found"
        else
            print_warning "MSVC compiler not found. Please install Visual Studio Build Tools."
        fi
        ;;
        
    Linux*)
        print_status "Linux detected"
        print_warning "Linux build not configured in this test script"
        ;;
esac

print_status "Installing dependencies..."

# Install npm dependencies
if [ -f "package-lock.json" ]; then
    npm ci
else
    npm install
fi

if [ $? -eq 0 ]; then
    print_success "NPM dependencies installed"
else
    print_error "Failed to install NPM dependencies"
    exit 1
fi

print_status "Building frontend..."

# Build frontend
npm run build

if [ $? -eq 0 ]; then
    print_success "Frontend build completed"
else
    print_error "Frontend build failed"
    exit 1
fi

print_status "Building Tauri application..."

case "$(uname -s)" in
    Darwin*)
        print_status "Building for macOS..."
        
        # Clear previous builds
        rm -rf src-tauri/target/release/bundle/dmg/*.dmg 2>/dev/null || true
        
        # Build the app
        npm run tauri:build
        
        if [ $? -eq 0 ]; then
            print_success "macOS build completed"
            
            # Check for app bundle
            if [ -d "src-tauri/target/release/bundle/macos/Image overlay tool.app" ]; then
                APP_SIZE=$(du -sh "src-tauri/target/release/bundle/macos/Image overlay tool.app" | awk '{print $1}')
                print_success "App bundle created: Image overlay tool.app ($APP_SIZE)"
                
                # Try to create a proper DMG
                print_status "Creating DMG..."
                cd src-tauri/target/release/bundle/macos
                
                # Apply ad-hoc code signing
                codesign --force --deep --sign - "Image overlay tool.app" || print_warning "Code signing failed"
                
                # Create DMG
                if command -v create-dmg >/dev/null 2>&1; then
                    TEMP_DIR=$(mktemp -d)
                    cp -R "Image overlay tool.app" "$TEMP_DIR/"
                    ln -s /Applications "$TEMP_DIR/Applications"
                    
                    create-dmg \
                        --volname "Image Overlay Tool v1.4.7" \
                        --window-pos 200 120 \
                        --window-size 800 450 \
                        --icon-size 100 \
                        --icon "Image overlay tool.app" 200 190 \
                        --hide-extension "Image overlay tool.app" \
                        --app-drop-link 600 185 \
                        --no-internet-enable \
                        "../dmg/Image_overlay_tool_v1.4.7_local_test.dmg" \
                        "$TEMP_DIR" || print_warning "create-dmg failed"
                    
                    rm -rf "$TEMP_DIR"
                    cd - >/dev/null
                    
                    if [ -f "src-tauri/target/release/bundle/dmg/Image_overlay_tool_v1.4.7_local_test.dmg" ]; then
                        DMG_SIZE=$(ls -lah "src-tauri/target/release/bundle/dmg/Image_overlay_tool_v1.4.7_local_test.dmg" | awk '{print $5}')
                        print_success "DMG created: Image_overlay_tool_v1.4.7_local_test.dmg ($DMG_SIZE)"
                    fi
                else
                    cd - >/dev/null
                fi
            else
                print_error "App bundle not found"
            fi
        else
            print_error "macOS build failed"
        fi
        ;;
        
    MINGW*|MSYS*|CYGWIN*)
        print_status "Building for Windows..."
        
        # Build the app
        npm run tauri:build
        
        if [ $? -eq 0 ]; then
            print_success "Windows build completed"
            
            # Check for MSI
            if ls src-tauri/target/release/bundle/msi/*.msi >/dev/null 2>&1; then
                for msi in src-tauri/target/release/bundle/msi/*.msi; do
                    MSI_SIZE=$(ls -lah "$msi" | awk '{print $5}')
                    MSI_NAME=$(basename "$msi")
                    print_success "MSI created: $MSI_NAME ($MSI_SIZE)"
                done
            else
                print_error "MSI files not found"
            fi
        else
            print_error "Windows build failed"
        fi
        ;;
esac

print_status "Build test completed!"

# Summary
echo ""
echo "📊 Build Test Summary"
echo "===================="

case "$(uname -s)" in
    Darwin*)
        if [ -d "src-tauri/target/release/bundle/macos/Image overlay tool.app" ]; then
            echo "✅ macOS app bundle: Created"
        else
            echo "❌ macOS app bundle: Failed"
        fi
        
        if ls src-tauri/target/release/bundle/dmg/*.dmg >/dev/null 2>&1; then
            echo "✅ macOS DMG: Created"
        else
            echo "❌ macOS DMG: Failed"
        fi
        ;;
        
    MINGW*|MSYS*|CYGWIN*)
        if ls src-tauri/target/release/bundle/msi/*.msi >/dev/null 2>&1; then
            echo "✅ Windows MSI: Created"
        else
            echo "❌ Windows MSI: Failed"
        fi
        ;;
esac

echo ""
echo "🚀 Ready for GitHub Actions deployment!"
echo "   Push to repository to trigger automated build"
echo ""
echo "📂 Build artifacts location:"
case "$(uname -s)" in
    Darwin*)
        echo "   App: src-tauri/target/release/bundle/macos/"
        echo "   DMG: src-tauri/target/release/bundle/dmg/"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "   MSI: src-tauri/target/release/bundle/msi/"
        ;;
esac
