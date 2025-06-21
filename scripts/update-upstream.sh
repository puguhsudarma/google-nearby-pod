#!/bin/bash

set -e  # Exit on any error

GOOGLE_REPO="https://github.com/google/nearby.git"
TEMP_DIR="temp-nearby"
EXTRACTED_DIR="extracted"

echo "🔄 Updating from Google's Nearby repository..."

# Clean previous extraction
rm -rf "$EXTRACTED_DIR"
mkdir -p "$EXTRACTED_DIR"

# Clean temp directory
rm -rf "$TEMP_DIR"

# Clone Google's repository WITH submodules
echo "📥 Cloning Google's Nearby repository (this may take a while)..."
git clone "$GOOGLE_REPO" "$TEMP_DIR"

# Navigate to the cloned directory and update submodules
echo "📦 Initializing and updating submodules..."
cd "$TEMP_DIR"
git submodule update --init --recursive
cd ..

echo "✅ Repository and submodules cloned successfully"

# Extract AbseilCpp (should now be in submodules)
echo "📦 Extracting AbseilCpp..."
if [ -d "$TEMP_DIR/third_party/abseil-cpp" ]; then
    cp -r "$TEMP_DIR/third_party/abseil-cpp" "$EXTRACTED_DIR/abseil"
    echo "✅ AbseilCpp extracted from third_party/abseil-cpp"
elif [ -d "$TEMP_DIR/third_party/abseil-cpp-SwiftPM" ]; then
    # Try alternative location
    cp -r "$TEMP_DIR/third_party/abseil-cpp-SwiftPM" "$EXTRACTED_DIR/abseil"
    echo "✅ AbseilCpp extracted from third_party/abseil-cpp-SwiftPM"
else
    echo "❌ AbseilCpp still not found, listing third_party contents:"
    ls -la "$TEMP_DIR/third_party/" || echo "third_party directory not found"
    # Continue anyway - we might be able to work around this
fi

# Extract Nearby Core
echo "📦 Extracting Nearby Core..."
mkdir -p "$EXTRACTED_DIR/nearby-core"
cp -r "$TEMP_DIR/connections" "$EXTRACTED_DIR/nearby-core/"
cp -r "$TEMP_DIR/internal" "$EXTRACTED_DIR/nearby-core/"
cp -r "$TEMP_DIR/proto" "$EXTRACTED_DIR/nearby-core/"
echo "✅ Nearby Core extracted"

# Extract Swift API
echo "📦 Extracting Swift API..."
if [ -d "$TEMP_DIR/connections/swift" ]; then
    cp -r "$TEMP_DIR/connections/swift" "$EXTRACTED_DIR/swift-api"
    echo "✅ Swift API extracted"
else
    echo "❌ Swift API not found"
fi

# Extract other dependencies (now with submodules)
echo "📦 Extracting dependencies..."
mkdir -p "$EXTRACTED_DIR/deps"

# Extract ukey2
if [ -d "$TEMP_DIR/third_party/ukey2" ]; then
    cp -r "$TEMP_DIR/third_party/ukey2" "$EXTRACTED_DIR/deps/"
    echo "✅ ukey2 extracted"
else
    echo "❌ ukey2 not found"
fi

# Extract smhasher
if [ -d "$TEMP_DIR/third_party/smhasher" ]; then
    cp -r "$TEMP_DIR/third_party/smhasher" "$EXTRACTED_DIR/deps/"
    echo "✅ smhasher extracted"
else
    echo "❌ smhasher not found"
fi

# Extract google-toolbox-for-mac
if [ -d "$TEMP_DIR/third_party/google-toolbox-for-mac" ]; then
    cp -r "$TEMP_DIR/third_party/google-toolbox-for-mac" "$EXTRACTED_DIR/deps/"
    echo "✅ google-toolbox-for-mac extracted"
else
    echo "❌ google-toolbox-for-mac not found"
fi

# Extract boringssl if present
if [ -d "$TEMP_DIR/third_party/boringssl-SwiftPM" ]; then
    cp -r "$TEMP_DIR/third_party/boringssl-SwiftPM" "$EXTRACTED_DIR/deps/"
    echo "✅ boringssl-SwiftPM extracted"
else
    echo "ℹ️  boringssl-SwiftPM not found (will use CocoaPods version)"
fi

# Copy compiled proto if exists
if [ -d "$TEMP_DIR/compiled_proto" ]; then
    cp -r "$TEMP_DIR/compiled_proto" "$EXTRACTED_DIR/"
    echo "✅ compiled_proto extracted"
else
    echo "ℹ️  compiled_proto not found"
fi

# List what we actually got in third_party for debugging
echo "📋 Contents of third_party directory:"
ls -la "$TEMP_DIR/third_party/" || echo "No third_party directory"

# Clean up test files
echo "🧹 Cleaning up test files..."
find "$EXTRACTED_DIR" -name "*_test.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*Test.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*_unittest.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -name "*_benchmark.*" -delete 2>/dev/null || true
find "$EXTRACTED_DIR" -type d -name "test" -exec rm -rf {} + 2>/dev/null || true
find "$EXTRACTED_DIR" -type d -name "tests" -exec rm -rf {} + 2>/dev/null || true

# Get the commit hash for reference
COMMIT_HASH=$(cd "$TEMP_DIR" && git rev-parse HEAD)
echo "$COMMIT_HASH" > UPSTREAM_VERSION
echo "Based on google/nearby commit: $COMMIT_HASH" > UPSTREAM_INFO.md

# Get submodule information
echo "📋 Submodule versions:" >> UPSTREAM_INFO.md
cd "$TEMP_DIR"
git submodule status >> "../UPSTREAM_INFO.md"
cd ..

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Extraction complete!"
echo "📊 Directory sizes:"
du -sh "$EXTRACTED_DIR"/* 2>/dev/null || echo "Some directories may be empty"

echo ""
echo "🎯 Extracted components:"
[ -d "$EXTRACTED_DIR/abseil" ] && echo "✅ AbseilCpp" || echo "❌ AbseilCpp"
[ -d "$EXTRACTED_DIR/nearby-core" ] && echo "✅ Nearby Core" || echo "❌ Nearby Core"
[ -d "$EXTRACTED_DIR/swift-api" ] && echo "✅ Swift API" || echo "❌ Swift API"
[ -d "$EXTRACTED_DIR/deps/ukey2" ] && echo "✅ ukey2" || echo "❌ ukey2"
[ -d "$EXTRACTED_DIR/deps/smhasher" ] && echo "✅ smhasher" || echo "❌ smhasher"
[ -d "$EXTRACTED_DIR/deps/google-toolbox-for-mac" ] && echo "✅ google-toolbox-for-mac" || echo "❌ google-toolbox-for-mac"

echo ""
echo "🎯 Next steps:"
echo "1. Review extracted files in: $EXTRACTED_DIR/"
echo "2. Update GoogleNearbyPod.podspec if needed"
echo "3. Test with: cd examples && pod install"
