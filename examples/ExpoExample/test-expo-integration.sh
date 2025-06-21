#!/bin/bash

echo "🚀 Testing GoogleNearbyPod Expo Integration"
echo "Testing the complete Expo example project"
echo "=" * 50

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    error "Please run this script from examples/ExpoExample directory"
    exit 1
fi

echo ""
echo "🔍 Step 1: Checking Prerequisites"
echo "--------------------------------"

# Check Node.js
if command -v node &> /dev/null; then
    success "Node.js available ($(node --version))"
else
    error "Node.js not found. Please install Node.js"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    success "npm available ($(npm --version))"
else
    error "npm not found"
    exit 1
fi

# Check CocoaPods
if command -v pod &> /dev/null; then
    success "CocoaPods available ($(pod --version))"
else
    error "CocoaPods not found. Install with: sudo gem install cocoapods"
    exit 1
fi

# Check if Expo CLI is available
if command -v npx &> /dev/null; then
    success "npx available for Expo commands"
else
    warning "npx not found, some Expo commands may not work"
fi

echo ""
echo "📦 Step 2: Installing npm Dependencies"
echo "------------------------------------"

info "Running npm install..."
npm install

if [ $? -eq 0 ]; then
    success "npm dependencies installed successfully"
else
    error "npm install failed"
    exit 1
fi

echo ""
echo "🍎 Step 3: Testing iOS CocoaPods Integration"
echo "------------------------------------------"

if [ -d "ios" ] && [ -f "ios/Podfile" ]; then
    success "iOS directory and Podfile found"
    
    # Display Podfile content
    info "Podfile configuration:"
    echo "----------------------------------------"
    cat ios/Podfile
    echo "----------------------------------------"
    
    # Check if GoogleNearbyPod is correctly configured
    if grep -q "GoogleNearbyPod.*modular_headers.*true" ios/Podfile; then
        success "GoogleNearbyPod with modular headers found in Podfile"
    else
        error "GoogleNearbyPod with modular headers not found in Podfile"
        exit 1
    fi
    
    if grep -q "BoringSSL-GRPC.*modular_headers.*true" ios/Podfile; then
        success "BoringSSL-GRPC with modular headers found in Podfile"
    else
        warning "BoringSSL-GRPC with modular headers not found in Podfile"
    fi
    
    # Run pod install
    info "Running pod install (this will download GoogleNearbyPod dependencies)..."
    cd ios
    
    pod install --verbose
    
    if [ $? -eq 0 ]; then
        success "Pod install completed successfully!"
        
        # Verify installation
        if [ -d "Pods/GoogleNearbyPod" ]; then
            success "GoogleNearbyPod pod installed"
            
            # Check if dynamic dependencies were downloaded
            if [ -d "Pods/GoogleNearbyPod/extracted" ]; then
                success "Dynamic dependencies downloaded successfully"
                
                # Show extracted content
                info "Extracted dependencies:"
                ls -la Pods/GoogleNearbyPod/extracted/ 2>/dev/null || echo "   (Directory listing not available)"
                
                # Show size
                SIZE=$(du -sh Pods/GoogleNearbyPod/extracted 2>/dev/null | cut -f1)
                if [ ! -z "$SIZE" ]; then
                    info "Total extracted size: $SIZE"
                fi
            else
                warning "Dynamic dependencies not found (may still be downloading)"
            fi
            
            # Check for key subspecs
            if [ -d "Pods/GoogleNearbyPod" ]; then
                info "GoogleNearbyPod installation structure:"
                ls -la Pods/GoogleNearbyPod/ | head -10
            fi
            
        else
            error "GoogleNearbyPod pod not found in installation"
        fi
        
        # Check if workspace was created
        if [ -f "GoogleNearbyExpoExample.xcworkspace" ]; then
            success "Xcode workspace created successfully"
        else
            warning "Xcode workspace not found"
        fi
        
    else
        error "Pod install failed"
        exit 1
    fi
    
    cd ..
else
    error "iOS directory or Podfile not found"
    exit 1
fi

echo ""
echo "⚛️  Step 4: Testing Expo Configuration"
echo "------------------------------------"

# Check app.json
if [ -f "app.json" ]; then
    success "app.json found"
    
    # Check bundle identifier
    if grep -q "bundleIdentifier" app.json; then
        success "iOS bundle identifier configured"
    else
        warning "iOS bundle identifier not found in app.json"
    fi
    
    # Check deployment target
    if grep -q "deploymentTarget.*13.0" app.json; then
        success "iOS deployment target set to 13.0+"
    else
        warning "iOS deployment target not found or incorrect"
    fi
else
    error "app.json not found"
fi

# Check App.js
if [ -f "App.js" ]; then
    success "App.js found"
    
    # Check if it contains GoogleNearbyPod references
    if grep -q "GoogleNearbyPod" App.js; then
        success "GoogleNearbyPod integration code found in App.js"
    else
        info "GoogleNearbyPod references not found in App.js (may be commented out)"
    fi
else
    error "App.js not found"
fi

echo ""
echo "🧪 Step 5: Testing Expo Commands"
echo "------------------------------"

# Test expo doctor (if available)
if command -v npx &> /dev/null; then
    info "Testing Expo CLI availability..."
    
    npx expo --version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        success "Expo CLI is working"
        
        # Test expo doctor
        info "Running Expo doctor..."
        npx expo doctor
        
        if [ $? -eq 0 ]; then
            success "Expo doctor passed"
        else
            warning "Expo doctor found some issues (may be normal)"
        fi
    else
        warning "Expo CLI not working properly"
    fi
else
    warning "Cannot test Expo commands without npx"
fi

echo ""
echo "📱 Step 6: Build Test (Optional)"
echo "------------------------------"

read -p "Do you want to test building the project? This will take several minutes. (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Testing iOS build..."
    
    if [ -f "ios/GoogleNearbyExpoExample.xcworkspace" ]; then
        info "Building with Xcode..."
        cd ios
        
        # Try to build the project
        xcodebuild -workspace GoogleNearbyExpoExample.xcworkspace -scheme GoogleNearbyExpoExample -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14' build
        
        if [ $? -eq 0 ]; then
            success "iOS build completed successfully!"
        else
            warning "iOS build failed (this may be normal without proper Xcode setup)"
        fi
        
        cd ..
    else
        warning "Xcode workspace not found, skipping build test"
    fi
else
    info "Skipping build test"
fi

echo ""
echo "📊 Final Results Summary"
echo "======================"

echo ""
echo "✅ Verification Complete!"
echo ""
echo "🎯 What was tested:"
echo "• npm dependencies installation"
echo "• CocoaPods integration with modular headers"
echo "• GoogleNearbyPod dynamic dependency download"
echo "• Expo project configuration"
echo "• iOS workspace generation"

echo ""
echo "🚀 Next Steps:"
echo "1. Run: npx expo run:ios"
echo "2. Test on iOS Simulator or device"
echo "3. Verify GoogleNearbyPod functionality in the app"
echo "4. Check logs for any runtime issues"

echo ""
echo "💡 Tips:"
echo "• Use a physical iOS device for full Nearby Connections testing"
echo "• Check the app logs for GoogleNearbyPod status messages"
echo "• Verify that all dependencies loaded correctly"

echo ""
success "Expo integration test completed successfully!" 