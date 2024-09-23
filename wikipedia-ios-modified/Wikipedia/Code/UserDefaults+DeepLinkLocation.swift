import Foundation

private let locationName = "placeName_received_from_deep-link"

@objc public extension UserDefaults {
    @objc func setLocationNameReceivedFromDeepLink(_ name: String) {
        self.set(name, forKey: locationName)
    }

    @objc func locationNameReceiveFromDeepLink() -> String? {
        self.value(forKey: locationName) as? String
    }

    @objc func clearLocationNameReceivedFromDeepLink() {
        self.removeObject(forKey: locationName)
    }
}
