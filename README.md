# GoogleNearbyPod

CocoaPods wrapper for Google's Nearby Connections library, providing peer-to-peer connectivity for iOS applications.

**🚀 Features:**
- ✅ Dynamic dependency download (like `node_modules`)
- ✅ Modular subspecs (AbseilCpp, Core, Swift, Full)
- ✅ Works with normal pod installation AND modular headers
- ✅ React Native Expo compatible (no `use_modular_headers!` required)
- ✅ iOS 13.0+ and macOS 10.15+ support
- ✅ Small git repository (~1MB vs 79MB)

## Quick Start

### For Most iOS Projects (Recommended)

```ruby
# Simple installation - works for most projects
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.1'
```

### For Expo Projects or Complex Setups

```ruby
# For Expo or projects with header conflicts
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.1',
  :modular_headers => true

# Also add this required dependency when using modular headers
pod 'BoringSSL-GRPC', :modular_headers => true
```

## Complete Expo Podfile Example

```ruby
require File.join(File.dirname(`node --print "require.resolve('expo/package.json')"`), "scripts/autolinking")
require File.join(File.dirname(`node --print "require.resolve('react-native/package.json')"`), "scripts/react_native_pods")

platform :ios, '13.0'
install! 'cocoapods', :deterministic_uuids => false

target 'YourExpoApp' do
  use_expo_modules!
  config = use_native_modules!

  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => false,
    :fabric_enabled => false,
    :flipper_configuration => FlipperConfiguration.disabled,
    :app_path => "#{Pod::Config.instance.installation_root}/.."
  )

  # 🚀 GoogleNearbyPod with targeted modular headers
  pod 'GoogleNearbyPod', 
    :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
    :tag => '1.0.0',
    :modular_headers => true
  
  pod 'BoringSSL-GRPC', :modular_headers => true

  post_install do |installer|
    react_native_post_install(
      installer,
      config[:reactNativePath],
      :mac_catalyst_enabled => false
    )
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
```

## How It Works

1. **Small Repository**: Only ~1MB in git (no large dependencies committed)
2. **Automatic Download**: Dependencies downloaded during `pod install` (like `node_modules`)
3. **Always Fresh**: Gets latest Google Nearby source code
4. **Modular**: Choose only the components you need
5. **Flexible Installation**: Works with both normal and modular header approaches

## Usage

```swift
import NearbyConnections

let connectionManager = ConnectionManager(
    serviceID: "your.app.service", 
    strategy: .pointToPoint
)
```

## Installation Methods Comparison

| Installation Method | Use Case | Pros | Cons |
|-------------------|----------|------|------|
| **Normal** | Most iOS/RN projects | ✅ Simple<br/>✅ Fast setup<br/>✅ No extra config | ❌ May conflict in complex projects |
| **Modular Headers** | Expo/Complex projects | ✅ No conflicts<br/>✅ Expo compatible<br/>✅ Clean modules | ❌ Slightly more setup |

## Subspecs Available

- `GoogleNearbyPod/Full` (default) - Complete package
- `GoogleNearbyPod/Swift` - Swift API only
- `GoogleNearbyPod/Core` - Core C++ implementation
- `GoogleNearbyPod/AbseilCpp` - Abseil C++ utilities only

## Troubleshooting

### Common Issues

**Issue**: "Module not found" or header conflicts
```bash
# Clean and reinstall
rm -rf ios/Pods ios/Podfile.lock
cd ios && pod install --verbose
```

**Issue**: Regular installation has conflicts
- ✅ Try the modular headers approach instead
- ✅ Make sure you're using iOS 13.0+ deployment target

**Issue**: Expo build fails
- ✅ Make sure you're using `:modular_headers => true` (not global `use_modular_headers!`)
- ✅ Include `pod 'BoringSSL-GRPC', :modular_headers => true`
- ✅ Verify deployment target is iOS 13.0+

## Testing

Run comprehensive tests:
```bash
chmod +x test-all.sh
./test-all.sh
```

This tests:
- ✅ Podspec validation
- ✅ Native iOS installation
- ✅ Expo React Native installation
- ✅ Dynamic dependencies download

## Deployment Guide

### Step 1: Commit and Push
```bash
git add .
git commit -m "feat: Ready for production deployment"
git push origin master
```

### Step 2: Create Release Tag
```bash
git tag 1.0.0
git push origin 1.0.0
```

### Step 3: Test Installation
```bash
# Test in a new project
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.0'
```

## Verification

### Success Indicators

**Native iOS Installation:**
```
✅ Pod install completed successfully
✅ GoogleNearbyPod pod directory created
✅ Dynamic dependencies downloaded successfully
✅ ConnectionManager created successfully!
```

**Expo Installation:**
```
✅ GoogleNearbyPod with modular headers found in Podfile
✅ Pod install completed successfully!
✅ No conflicts with other Expo modules
✅ Xcode workspace created successfully
```

### Installation Method Decision Tree

```
Are you using Expo React Native?
├── Yes → Use Modular Headers
│   └── pod 'GoogleNearbyPod', :modular_headers => true
└── No → Are you having header conflicts?
    ├── Yes → Use Modular Headers
    │   └── pod 'GoogleNearbyPod', :modular_headers => true
    └── No → Use Normal Installation
        └── pod 'GoogleNearbyPod'
```

## Upstream Information

Based on Google Nearby commit: `0c0a59d8a1c5114c1101a1b00d88591330dd5cde`

To update dependencies manually:
```bash
./scripts/update-upstream-fast.sh
```

## License

Apache 2.0 - Based on Google's Nearby Connections
