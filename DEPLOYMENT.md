# 🚀 Deployment Instructions

## Current Status: Dynamic Dependencies Ready

Your GoogleNearbyPod is now configured with **dynamic dependency download** (like `node_modules`):

- ✅ `extracted/` directory excluded from git
- ✅ `prepare_command` added to podspec  
- ✅ Dependencies download automatically on `pod install`
- ✅ Repository size reduced from 79MB to ~1MB

## 📦 Deploy to GitHub

### Step 1: Remove extracted/ from git and commit changes

```bash
# Remove the large extracted directory from git
git rm -r extracted/ --cached 2>/dev/null || echo "extracted/ not in git yet"

# Add all the changes
git add .gitignore GoogleNearbyPod.podspec README.md

# Commit the dynamic dependency system
git commit -m "feat: Dynamic dependency download (like node_modules)

- Remove 79MB extracted/ from git repository  
- Add prepare_command to download dependencies automatically
- Reduce repo size from 79MB to ~1MB
- Dependencies downloaded fresh on each pod install
- Ready for React Native Expo integration"
```

### Step 2: Push to GitHub and create tag

```bash
# Push to your GitHub repository
git remote add origin https://github.com/puguhsudarma/google-nearby-pod.git
git push -u origin master

# Create and push version tag
git tag 1.0.0
git push origin 1.0.0
```

### Step 3: Test in React Native Expo project

Add to your Expo project's `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourExpoApp' do
  pod 'GoogleNearbyPod', 
    :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
    :tag => '1.0.0'
end
```

Then run:
```bash
cd ios && pod install
```

## 🎯 What Happens During Installation

1. **CocoaPods clones your repo** (~1MB, very fast)
2. **prepare_command runs automatically**:
   - Downloads Google's Nearby source (~79MB)
   - Extracts all dependencies  
   - Cleans up test files
3. **Build and link everything**
4. **Ready to use in your React Native Expo app!**

## 🧪 Test Locally First

Before deploying, test the system:

```bash
chmod +x test-dynamic-deps.sh
./test-dynamic-deps.sh
```

This will verify:
- ✅ Dependencies download correctly
- ✅ Podspec validates successfully  
- ✅ Directory structure is correct
- ✅ Ready for deployment

## 🎉 Benefits Achieved

- **Small Repository**: ~1MB instead of 79MB
- **Always Fresh**: Downloads latest Google Nearby code
- **Fast CI/CD**: Smaller repo = faster clones
- **No Maintenance**: No need to manually update extracted files
- **Expo Ready**: Perfect for React Native Expo integration 