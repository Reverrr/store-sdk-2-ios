import Foundation
import StoreKit

/// Pure-Swift StoreKit 2 business logic.
/// No Capacitor dependencies — instantiated and owned by StoreKit2iOSPlugin.
internal final class StoreKit2iOS {

    /// Called on every transaction that arrives via the background observer.
    var onTransactionUpdated: (([String: Any]) -> Void)?

    private var observerTask: Task<Void, Never>?

    // MARK: - Observer

    func startObserver() {
        guard observerTask == nil else { return }
        observerTask = Task { [weak self] in
            for await verificationResult in Transaction.updates {
                guard case .verified(let transaction) = verificationResult else {
                    NSLog("[StoreKit2iOS] Unverified transaction in observer — skipping")
                    continue
                }
                NSLog("[StoreKit2iOS] transactionUpdated: productId=%@, id=%llu",
                      transaction.productID, transaction.id)
                self?.onTransactionUpdated?([
                    "productId": transaction.productID,
                    "transactionId": String(transaction.id),
                    "jwsToken": verificationResult.jwsRepresentation,
                ])
            }
        }
    }

    // MARK: - getProducts

    func getProducts(productIds: [String]) async throws -> [[String: Any]] {
        let products = try await Product.products(for: Set(productIds))
        return products.map { product in
            [
                "id": product.id,
                "title": product.displayName,
                "description": product.description,
                "price": product.displayPrice,
                "priceValue": NSDecimalNumber(decimal: product.price).doubleValue,
                "currencyCode": product.priceFormatStyle.currencyCode,
            ]
        }
    }

    // MARK: - purchase

    func purchase(productId: String) async throws -> [String: Any] {
        let products = try await Product.products(for: [productId])
        guard let product = products.first else {
            throw NSError(
                domain: "StoreKit2iOS",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Product not found: \(productId)"]
            )
        }

        NSLog("[StoreKit2iOS] Starting purchase for productId=%@", productId)
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            guard case .verified(let transaction) = verificationResult else {
                throw NSError(
                    domain: "StoreKit2iOS",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Transaction verification failed — JWS signature invalid"]
                )
            }
            NSLog("[StoreKit2iOS] Purchase success: productId=%@, transactionId=%llu",
                  transaction.productID, transaction.id)
            return [
                "status": "success",
                "transactionId": String(transaction.id),
                "jwsToken": verificationResult.jwsRepresentation,
            ]

        case .pending:
            NSLog("[StoreKit2iOS] Purchase pending for productId=%@", productId)
            return ["status": "pending"]

        case .userCancelled:
            NSLog("[StoreKit2iOS] Purchase cancelled by user for productId=%@", productId)
            return ["status": "cancelled"]

        @unknown default:
            throw NSError(
                domain: "StoreKit2iOS",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Unknown purchase result"]
            )
        }
    }

    // MARK: - finishTransaction

    func finishTransaction(transactionId: String) async {
        // Transaction.unfinished yields all unfinished transactions then completes.
        for await verificationResult in Transaction.unfinished {
            guard case .verified(let transaction) = verificationResult else { continue }
            if String(transaction.id) == transactionId {
                await transaction.finish()
                NSLog("[StoreKit2iOS] Finished transaction id=%@", transactionId)
                return
            }
        }
        NSLog("[StoreKit2iOS] finishTransaction: id=%@ not found (already finished?)", transactionId)
    }

    // MARK: - restorePurchases

    func restorePurchases() async -> [[String: Any]] {
        var transactions: [[String: Any]] = []
        // currentEntitlements yields all active (non-expired, non-finished) entitlements.
        for await verificationResult in Transaction.currentEntitlements {
            guard case .verified(let transaction) = verificationResult else { continue }
            transactions.append([
                "productId": transaction.productID,
                "transactionId": String(transaction.id),
                "jwsToken": verificationResult.jwsRepresentation,
            ])
        }
        NSLog("[StoreKit2iOS] restorePurchases: found %d entitlements", transactions.count)
        return transactions
    }
}
