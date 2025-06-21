# Native iOS Example

This example demonstrates how to use GoogleNearbyPod in a standard native iOS project.

## 🎯 Purpose

Test the **normal installation method** that most iOS developers will use:

```ruby
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.0'
```

## 🛠️ Setup

### Prerequisites
- Xcode 14+
- CocoaPods
- iOS 13.0+ deployment target

### Installation

```bash
# Navigate to this directory
cd examples/NativeIOSExample

# Install dependencies
pod install

# Test the installation
swift main.swift
```

## 📱 What This Tests

- ✅ Normal CocoaPods installation (no modular headers)
- ✅ Dynamic dependency download (~79MB)
- ✅ GoogleNearbyPod Swift API availability
- ✅ Basic ConnectionManager functionality
- ✅ Compatibility with standard iOS projects

## 🔍 Expected Output

When you run `swift main.swift`, you should see:

```
🚀 Testing GoogleNearbyPod in Native iOS
========================================
📱 Creating ConnectionManager...
✅ ConnectionManager created successfully!
   Service ID: com.test.nativeios
   Strategy: pointToPoint

🎯 GoogleNearbyPod is working correctly in native iOS!
✅ Ready for production use

🎉 Native iOS test completed successfully!
```

## 🎯 Use Cases

This installation method is perfect for:
- Standard iOS apps
- Simple React Native projects  
- Projects without complex C++ dependencies
- Most common use cases (90% of developers)

## 🚀 Next Steps

Once this works, you can:
1. Use GoogleNearbyPod in your iOS app
2. Implement actual Nearby Connections functionality
3. Test on physical devices (required for real peer-to-peer)
4. Build your production app

## 🐛 Troubleshooting

**Issue**: Pod install fails
```bash
# Clean and retry
rm -rf Pods Podfile.lock
pod install --verbose
```

**Issue**: Swift compilation fails
- Verify iOS deployment target is 13.0+
- Check that GoogleNearbyPod installed correctly
- Ensure Xcode command line tools are installed

---

**This example validates that GoogleNearbyPod works perfectly with normal installation! 🎉** 