import Foundation
import Capacitor

/// Capacitor bridge for StoreKit 2 IAP.
///
/// JS name  : StoreKit2iOS
/// Methods  : getProducts · purchase · finishTransaction · restorePurchases
/// Events   : transactionUpdated
@objc(StoreKit2iOSPlugin)
public class StoreKit2iOSPlugin: CAPPlugin, CAPBridgedPlugin {

    public let identifier = "StoreKit2iOSPlugin"
    public let jsName = "StoreKit2iOS"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getProducts",       returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "purchase",          returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "finishTransaction", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "restorePurchases",  returnType: CAPPluginReturnPromise),
    ]

    private let impl = StoreKit2iOS()

    // MARK: - Lifecycle

    override public func load() {
        impl.onTransactionUpdated = { [weak self] data in
            self?.notifyListeners("transactionUpdated", data: data)
        }
        impl.startObserver()
    }

    // MARK: - getProducts

    @objc func getProducts(_ call: CAPPluginCall) {
        guard let productIds = call.getArray("productIds") as? [String], !productIds.isEmpty else {
            call.reject("productIds array is required")
            return
        }

        Task {
            do {
                let products = try await impl.getProducts(productIds: productIds)
                call.resolve(["products": products])
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    // MARK: - purchase

    @objc func purchase(_ call: CAPPluginCall) {
        guard let productId = call.getString("productId") else {
            call.reject("productId is required")
            return
        }

        Task {
            do {
                let result = try await impl.purchase(productId: productId)
                call.resolve(result)
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    // MARK: - finishTransaction

    @objc func finishTransaction(_ call: CAPPluginCall) {
        guard let transactionId = call.getString("transactionId") else {
            call.reject("transactionId is required")
            return
        }

        Task {
            await impl.finishTransaction(transactionId: transactionId)
            call.resolve()
        }
    }

    // MARK: - restorePurchases

    @objc func restorePurchases(_ call: CAPPluginCall) {
        Task {
            let transactions = await impl.restorePurchases()
            call.resolve(["transactions": transactions])
        }
    }
}
