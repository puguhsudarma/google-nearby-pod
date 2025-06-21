import Foundation

// Simple test app for GoogleNearbyPod Expo integration
print("ExpoExample app with GoogleNearbyPod support")

// Mock connection manager for testing
class ConnectionManager {
    let serviceID: String
    let strategy: String
    
    init(serviceID: String, strategy: String) {
        self.serviceID = serviceID
        self.strategy = strategy
    }
}

let manager = ConnectionManager(serviceID: "expo.test", strategy: "pointToPoint")
print("✅ ExpoExample ready with GoogleNearbyPod!") 