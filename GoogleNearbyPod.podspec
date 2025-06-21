Pod::Spec.new do |spec|
  spec.name                 = "GoogleNearbyPod"
  spec.version              = "1.0.1"
  spec.summary              = "CocoaPods wrapper for Google Nearby Connections"
  spec.description          = <<-DESC
    A CocoaPods package that provides Google's Nearby Connections functionality
    for iOS development. Includes all necessary dependencies and Swift API.
    Dependencies are downloaded automatically during pod install (like node_modules).
    Fully compatible with Expo projects - use targeted :modular_headers => true instead of global use_modular_headers!
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
  
  # Enable modular headers support
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'CLANG_ENABLE_MODULES' => 'YES'
  }
  
  # Default subspec
  spec.default_subspec = 'Full'
  
  # AbseilCpp subspec (essential utilities only) - Modular compatible
  spec.subspec 'AbseilCpp' do |abseil|
    # Include only essential, non-conflicting Abseil components
    abseil.source_files = [
      "extracted/abseil/absl/base/attributes.h",
      "extracted/abseil/absl/base/config.h",
      "extracted/abseil/absl/base/macros.h",
      "extracted/abseil/absl/base/optimization.h",
      "extracted/abseil/absl/strings/string_view.{h,cc}",
      "extracted/abseil/absl/strings/str_cat.{h,cc}",
      "extracted/abseil/absl/strings/str_join.{h,cc}",
      "extracted/abseil/absl/types/optional.h",
      "extracted/abseil/absl/types/span.h",
      "extracted/abseil/absl/memory/memory.h",
      "extracted/abseil/absl/utility/utility.h"
    ]
    
    # Exclude all problematic files
    abseil.exclude_files = [
      "extracted/abseil/**/*_test.{h,cc}",
      "extracted/abseil/**/*_benchmark.{h,cc}",
      "extracted/abseil/**/*_testutil.{h,cc}",
      "extracted/abseil/**/internal/**/*",
      "extracted/abseil/**/testing/**/*"
    ]
    
    # Only expose clean public headers
    abseil.public_header_files = [
      "extracted/abseil/absl/base/attributes.h",
      "extracted/abseil/absl/base/config.h",
      "extracted/abseil/absl/base/macros.h",
      "extracted/abseil/absl/base/optimization.h",
      "extracted/abseil/absl/strings/string_view.h",
      "extracted/abseil/absl/strings/str_cat.h",
      "extracted/abseil/absl/strings/str_join.h",
      "extracted/abseil/absl/types/optional.h",
      "extracted/abseil/absl/types/span.h",
      "extracted/abseil/absl/memory/memory.h",
      "extracted/abseil/absl/utility/utility.h"
    ]
    
    abseil.xcconfig = {
      'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/extracted/abseil"',
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'GCC_PREPROCESSOR_DEFINITIONS' => 'ABSL_MIN_LOG_LEVEL=0',
      'USE_HEADERMAP' => 'NO',
      'ALWAYS_SEARCH_USER_PATHS' => 'NO'
    }
    
    abseil.library = 'c++'
  end
  
  # Core implementation subspec - Modular compatible
  spec.subspec 'Core' do |core|
    core.dependency 'GoogleNearbyPod/AbseilCpp'
    core.dependency 'Protobuf', '~> 3.21'
    core.dependency 'BoringSSL-GRPC', '~> 0.0.24'
    
    # Carefully selected source files to avoid conflicts
    core.source_files = [
      # Nearby core files
      "extracted/nearby-core/connections/core.{h,cc}",
      "extracted/nearby-core/connections/status.{h,cc}",
      "extracted/nearby-core/connections/payload.{h,cc}",
      "extracted/nearby-core/connections/strategy.{h,cc}",
      "extracted/nearby-core/connections/listeners.h",
      "extracted/nearby-core/connections/*_options.{h,cc}",
      
      # Platform abstraction (essential only)
      "extracted/nearby-core/internal/platform/logging.{h,cc}",
      "extracted/nearby-core/internal/platform/byte_array.{h,cc}",
      "extracted/nearby-core/internal/platform/exception.{h,cc}",
      "extracted/nearby-core/internal/platform/feature_flags.{h,cc}",
      
      # Swift adapter (public interface only)
      "extracted/swift-api/NearbyCoreAdapter/Sources/Public/**/*.{h,m,mm}",
      
      # Essential dependencies only
      "extracted/deps/ukey2/src/main/cpp/src/securegcm/*.{h,cc}",
      "extracted/deps/smhasher/src/MurmurHash3.{h,cpp}"
    ]
    
    # Exclude problematic files
    core.exclude_files = [
      "extracted/**/*_test.{h,cc}",
      "extracted/**/*Test.{h,cc}",
      "extracted/**/test/**/*",
      "extracted/**/testing/**/*",
      "extracted/nearby-core/connections/c/**/*",
      "extracted/nearby-core/connections/dart/**/*",
      "extracted/nearby-core/connections/java/**/*",
      "extracted/**/internal/platform/implementation/**/*"
    ]
    
    # Only expose essential public headers
    core.public_header_files = [
      "extracted/nearby-core/connections/core.h",
      "extracted/nearby-core/connections/status.h",
      "extracted/nearby-core/connections/payload.h",
      "extracted/nearby-core/connections/strategy.h",
      "extracted/nearby-core/connections/listeners.h",
      "extracted/nearby-core/connections/*_options.h",
      "extracted/swift-api/NearbyCoreAdapter/Sources/Public/**/*.h"
    ]
    
    core.xcconfig = {
      'HEADER_SEARCH_PATHS' => [
        '"$(PODS_TARGET_SRCROOT)/extracted"',
        '"$(PODS_TARGET_SRCROOT)/extracted/nearby-core"',
        '"$(PODS_TARGET_SRCROOT)/extracted/deps"',
        '"$(PODS_TARGET_SRCROOT)/extracted/swift-api/NearbyCoreAdapter/Sources"'
      ].join(' '),
      'GCC_PREPROCESSOR_DEFINITIONS' => 'NO_WEBRTC=1 NEARBY_SWIFTPM=1',
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'USE_HEADERMAP' => 'NO',
      'ALWAYS_SEARCH_USER_PATHS' => 'NO'
    }
    
    core.ios.framework = 'Foundation', 'Network', 'Security'
    core.osx.framework = 'Foundation', 'Network', 'Security'
    core.library = 'c++'
  end
  
  # Swift API subspec - Already modular compatible
  spec.subspec 'Swift' do |swift|
    swift.dependency 'GoogleNearbyPod/Core'
    
    swift.source_files = [
      "extracted/swift-api/NearbyConnections/Sources/**/*.swift"
    ]
    
    swift.exclude_files = [
      "extracted/swift-api/NearbyConnections/Tests/**/*"
    ]
    
    swift.pod_target_xcconfig = {
      'SWIFT_VERSION' => '5.7'
    }
    
    swift.ios.framework = 'Foundation'
    swift.osx.framework = 'Foundation'
  end
  
  # Full package (default)
  spec.subspec 'Full' do |full|
    full.dependency 'GoogleNearbyPod/Swift'
  end
end
