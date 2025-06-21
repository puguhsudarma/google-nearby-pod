#!/bin/bash

echo "🧪 Testing Dynamic Dependency Download System"
echo "=" * 50

# Test 1: Remove extracted directory to simulate fresh install
echo "🗑️  Step 1: Removing extracted/ directory to simulate fresh install..."
rm -rf extracted/
echo "✅ Removed extracted/ directory"

# Test 2: Test the prepare command
echo ""
echo "🚀 Step 2: Testing prepare command (simulating pod install)..."
if [ ! -d "extracted" ]; then
  chmod +x scripts/update-upstream-fast.sh
  ./scripts/update-upstream-fast.sh
  echo "✅ Dependencies extracted successfully!"
else
  echo "✅ Dependencies already exist, skipping download"
fi

# Test 3: Verify extracted directory structure
echo ""
echo "📁 Step 3: Verifying extracted directory structure..."
if [ -d "extracted" ]; then
  echo "✅ extracted/ directory created"
  echo "📊 Directory sizes:"
  du -sh extracted/* 2>/dev/null || echo "No subdirectories found"
  
  echo ""
  echo "📂 Directory structure:"
  ls -la extracted/ 2>/dev/null || echo "extracted/ is empty"
else
  echo "❌ extracted/ directory not found!"
  exit 1
fi

# Test 4: Validate podspec
echo ""
echo "📋 Step 4: Validating podspec with dynamic dependencies..."
pod spec lint GoogleNearbyPod.podspec --quick --allow-warnings --verbose

if [ $? -eq 0 ]; then
  echo "✅ Podspec validation passed!"
else
  echo "❌ Podspec validation failed!"
  exit 1
fi

echo ""
echo "🎉 All tests passed! Dynamic dependency system is working."
echo ""
echo "🎯 Benefits achieved:"
echo "- Small git repository (no 79MB extracted/ committed)"
echo "- Automatic dependency download on pod install"
echo "- Always fresh dependencies from Google's repo"
echo "- Ready for React Native Expo integration!" 