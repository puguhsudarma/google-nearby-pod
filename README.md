# GoogleNearbyPod

CocoaPods wrapper for Google's Nearby Connections library, providing peer-to-peer connectivity for iOS applications.

**🚀 Features:**
- ✅ Dynamic dependency download (like `node_modules`)
- ✅ Modular subspecs (AbseilCpp, Core, Swift, Full)
- ✅ React Native Expo compatible
- ✅ iOS 13.0+ and macOS 10.15+ support
- ✅ Small git repository (~1MB vs 79MB)

## Installation

### For React Native Expo Projects

Add to your `Podfile`:

```ruby
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.0'
```

### For Native iOS Projects

```ruby
pod 'GoogleNearbyPod', 
  :git => 'https://github.com/puguhsudarma/google-nearby-pod.git',
  :tag => '1.0.0'
```

## How It Works

1. **Small Repository**: Only ~1MB in git (no large dependencies committed)
2. **Automatic Download**: Dependencies downloaded during `pod install` (like `node_modules`)
3. **Always Fresh**: Gets latest Google Nearby source code
4. **Modular**: Choose only the components you need

## Subspecs Available

- `GoogleNearbyPod/Full` (default) - Complete package
- `GoogleNearbyPod/Swift` - Swift API only
- `GoogleNearbyPod/Core` - Core C++ implementation
- `GoogleNearbyPod/AbseilCpp` - Abseil C++ utilities only

## Usage

```swift
import NearbyConnections

let connectionManager = ConnectionManager(
    serviceID: "your.app.service", 
    strategy: .pointToPoint
)
```

## Development

To update dependencies manually:
```bash
./scripts/update-upstream-fast.sh
```

## License

Apache 2.0 - Based on Google's Nearby Connections
