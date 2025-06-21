Pod::Spec.new do |spec|
  spec.name                 = "GoogleNearbyPod"
  spec.version              = "1.0.0"
  spec.summary              = "CocoaPods wrapper for Google Nearby Connections"
  spec.description          = <<-DESC
    A CocoaPods package that provides Google's Nearby Connections functionality
    for iOS development. Includes all necessary dependencies and Swift API.
    Dependencies are downloaded automatically during pod install (like node_modules).
  DESC

  spec.homepage             = "https://github.com/puguhsudarma/google-nearby-pod"
  spec.license              = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.author               = { "puguhsudarma" => "puguhsudarma@example.com" }
  spec.source               = { 
    :git => "https://github.com/puguhsudarma/google-nearby-pod.git", 
    :tag => "#{spec.version}" 
  }

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"
  spec.swift_version = "5.7"
  
  # Automatically download and extract dependencies (like node_modules)
  spec.prepare_command = <<-CMD
    echo "🚀 Downloading Google Nearby Connections dependencies..."
    if [ ! -d "extracted" ]; then
      chmod +x scripts/update-upstream-fast.sh
      ./scripts/update-upstream-fast.sh
      echo "✅ Dependencies extracted successfully!"
    else
      echo "✅ Dependencies already exist, skipping download"
    fi
  CMD
  
  # Default subspec
  spec.default_subspec = 'Full'
  
  # AbseilCpp subspec (minimal core utilities)
  spec.subspec 'AbseilCpp' do |abseil|
    abseil.source_files = [
      "extracted/abseil/absl/base/*.{h,cc}",
      "extracted/abseil/absl/strings/*.{h,cc}",
      "extracted/abseil/absl/time/*.{h,cc}",
      "extracted/abseil/absl/types/*.{h,cc}",
      "extracted/abseil/absl/utility/*.{h,cc}",
      "extracted/abseil/absl/memory/*.{h,cc}"
    ]
    
    abseil.exclude_files = [
      "extracted/abseil/**/*_test.{h,cc}",
      "extracted/abseil/**/*_benchmark.{h,cc}",
      "extracted/abseil/**/*_testutil.{h,cc}",
      "extracted/abseil/**/internal/**/*.h"
    ]
    
    abseil.public_header_files = [
      "extracted/abseil/absl/base/*.h",
      "extracted/abseil/absl/strings/*.h", 
      "extracted/abseil/absl/time/*.h",
      "extracted/abseil/absl/types/*.h",
      "extracted/abseil/absl/utility/*.h",
      "extracted/abseil/absl/memory/*.h"
    ]
    
    abseil.xcconfig = {
      'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/extracted/abseil"',
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'GCC_PREPROCESSOR_DEFINITIONS' => 'ABSL_MIN_LOG_LEVEL=0'
    }
    
    abseil.library = 'c++'
  end
  
  # Core implementation subspec  
  spec.subspec 'Core' do |core|
    core.dependency 'GoogleNearbyPod/AbseilCpp'
    core.dependency 'Protobuf', '~> 3.21'
    core.dependency 'BoringSSL-GRPC', '~> 0.0.24'
    
    core.source_files = [
      "extracted/nearby-core/connections/core.{h,cc}",
      "extracted/nearby-core/connections/status.{h,cc}",
      "extracted/nearby-core/connections/payload.{h,cc}",
      "extracted/nearby-core/connections/strategy.{h,cc}",
      "extracted/nearby-core/connections/listeners.h",
      "extracted/nearby-core/connections/*_options.{h,cc}",
      "extracted/nearby-core/internal/platform/**/*.{h,cc}",
      "extracted/nearby-core/internal/base/**/*.{h,cc}",
      "extracted/nearby-core/internal/crypto/**/*.{h,cc}",
      "extracted/swift-api/NearbyCoreAdapter/Sources/**/*.{h,m,mm}",
      "extracted/deps/ukey2/**/*.{h,cc}",
      "extracted/deps/smhasher/**/*.{h,cpp}",
      "extracted/compiled_proto/**/*.{h,cc}"
    ]
    
    core.exclude_files = [
      "extracted/**/*_test.{h,cc}",
      "extracted/**/*Test.{h,cc}",
      "extracted/**/test/**/*",
      "extracted/nearby-core/connections/c/**/*",
      "extracted/nearby-core/connections/dart/**/*",
      "extracted/nearby-core/connections/java/**/*"
    ]
    
    core.public_header_files = [
      "extracted/swift-api/NearbyCoreAdapter/Sources/Public/**/*.h"
    ]
    
    core.xcconfig = {
      'HEADER_SEARCH_PATHS' => [
        '"$(PODS_TARGET_SRCROOT)/extracted"',
        '"$(PODS_TARGET_SRCROOT)/extracted/nearby-core"',
        '"$(PODS_TARGET_SRCROOT)/extracted/deps"',
        '"$(PODS_TARGET_SRCROOT)/extracted/compiled_proto"',
        '"$(PODS_TARGET_SRCROOT)/extracted/swift-api/NearbyCoreAdapter/Sources"'
      ].join(' '),
      'GCC_PREPROCESSOR_DEFINITIONS' => 'NO_WEBRTC=1 NEARBY_SWIFTPM=1',
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
      'CLANG_CXX_LIBRARY' => 'libc++'
    }
    
    core.ios.framework = 'Foundation', 'Network', 'Security'
    core.osx.framework = 'Foundation', 'Network', 'Security'
    core.library = 'c++'
  end
  
  # Swift API subspec
  spec.subspec 'Swift' do |swift|
    swift.dependency 'GoogleNearbyPod/Core'
    
    swift.source_files = [
      "extracted/swift-api/NearbyConnections/Sources/**/*.swift"
    ]
    
    swift.exclude_files = [
      "extracted/swift-api/NearbyConnections/Tests/**/*"
    ]
    
    swift.ios.framework = 'Foundation'
    swift.osx.framework = 'Foundation'
  end
  
  # Full package (default)
  spec.subspec 'Full' do |full|
    full.dependency 'GoogleNearbyPod/Swift'
  end
end
