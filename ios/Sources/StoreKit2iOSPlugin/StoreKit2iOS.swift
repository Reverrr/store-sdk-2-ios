import Foundation

@objc public class StoreKit2iOS: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
