import Foundation
import NearbyConnections

print("🚀 Testing GoogleNearbyPod...")

// Test basic initialization
let connectionManager = ConnectionManager(
    serviceID: "com.test.nearby", 
    strategy: .pointToPoint
)

print("✅ ConnectionManager created successfully!")
print("   Service ID: \(connectionManager.serviceID)")
print("   Strategy: \(connectionManager.strategy)")

// Test that we can access the main classes
print("✅ NearbyConnections module loaded successfully!")
print("🎯 Ready for React Native integration!") 