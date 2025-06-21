#!/bin/bash

set -e

GOOGLE_REPO="https://github.com/google/nearby.git"
TEMP_DIR="temp-nearby"
EXTRACTED_DIR="extracted"

echo "🔄 Fast update from Google's Nearby repository..."

# Clean previous extraction
rm -rf "$EXTRACTED_DIR"
mkdir -p "$EXTRACTED_DIR"
rm -rf "$TEMP_DIR"

# Clone main repository
echo "📥 Cloning Google's Nearby repository..."
git clone "$GOOGLE_REPO" "$TEMP_DIR"

# Extract main code
echo "📦 Extracting main code..."
mkdir -p "$EXTRACTED_DIR/nearby-core"
cp -r "$TEMP_DIR/connections" "$EXTRACTED_DIR/nearby-core/"
cp -r "$TEMP_DIR/internal" "$EXTRACTED_DIR/nearby-core/"
cp -r "$TEMP_DIR/proto" "$EXTRACTED_DIR/nearby-core/"

# Extract Swift API
if [ -d "$TEMP_DIR/connections/swift" ]; then
    cp -r "$TEMP_DIR/connections/swift" "$EXTRACTED_DIR/swift-api"
    echo "✅ Swift API extracted"
fi

# Download AbseilCpp directly (since it's a separate repo)
echo "📦 Downloading AbseilCpp separately..."
git clone --depth 1 https://github.com/abseil/abseil-cpp.git "$EXTRACTED_DIR/abseil"

# Download ukey2 separately
echo "📦 Downloading ukey2 separately..."
mkdir -p "$EXTRACTED_DIR/deps"
git clone --depth 1 https://github.com/google/ukey2.git "$EXTRACTED_DIR/deps/ukey2"

# Download smhasher
echo "📦 Downloading smhasher separately..."
git clone --depth 1 https://github.com/aappleby/smhasher.git "$EXTRACTED_DIR/deps/smhasher"

# Download google-toolbox-for-mac
echo "📦 Downloading google-toolbox-for-mac separately..."
git clone --depth 1 https://github.com/google/google-toolbox-for-mac.git "$EXTRACTED_DIR/deps/google-toolbox-for-mac"

# Clean up test files
echo "🧹 Cleaning up test files..."
find "$EXTRACTED_DIR" -name "*_test.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*Test.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*_unittest.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*_benchmark.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -type d -name "test" -exec rm -rf {} + 2>/dev/null || true
find "$EXTRACTED_DIR" -type d -name "tests" -exec rm -rf {} + 2>/dev/null || true

# Remove .git directories to save space
find "$EXTRACTED_DIR" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true

# Get version info
COMMIT_HASH=$(cd "$TEMP_DIR" && git rev-parse HEAD)
echo "$COMMIT_HASH" > UPSTREAM_VERSION
echo "Based on google/nearby commit: $COMMIT_HASH" > UPSTREAM_INFO.md

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Fast extraction complete!"
echo "📊 Directory sizes:"
du -sh "$EXTRACTED_DIR"/*

echo ""
echo "🎯 Next steps:"
echo "1. Review extracted files in: $EXTRACTED_DIR/"
echo "2. Update GoogleNearbyPod.podspec if needed"  
echo "3. Test with: cd examples && pod install"
