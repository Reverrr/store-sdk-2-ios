import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(StoreKit2iOSPlugin)
public class StoreKit2iOSPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "StoreKit2iOSPlugin"
    public let jsName = "StoreKit2iOS"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = StoreKit2iOS()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
