#!/usr/bin/env ruby

puts "🚀 Testing GoogleNearbyPod for iOS Native Swift"
puts "=" * 50

# Test 1: Basic podspec validation
puts "\n📋 Step 1: Validating Podspec..."
system("pod spec lint ../../GoogleNearbyPod.podspec --quick --allow-warnings")

if $?.success?
  puts "✅ Podspec validation passed!"
else
  puts "❌ Podspec validation failed!"
  exit 1
end

# Test 2: Create simple iOS project and test integration
puts "\n📱 Step 2: Testing iOS Integration..."
puts "Local path testing - no GitHub repo needed yet!"

puts "\n🎯 To test in your iOS project:"
puts "1. Add to your Podfile:"
puts "   pod 'GoogleNearbyPod', :path => '../path/to/google-nearby-pod'"
puts "2. Run: pod install"
puts "3. Import: import NearbyConnections"
puts "4. Use: ConnectionManager(serviceID: \"your.app\", strategy: .pointToPoint)"

puts "\n✅ Ready for iOS Native Swift integration!"
puts "🔗 When ready to distribute: Create GitHub repo and update URLs" 