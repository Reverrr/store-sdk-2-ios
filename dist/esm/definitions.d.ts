import type { PluginListenerHandle } from '@capacitor/core';
export interface IAPProduct {
    id: string;
    title: string;
    description: string;
    /** Formatted localised price, e.g. "$9.99" */
    price: string;
    /** Raw numeric price value */
    priceValue: number;
    /** ISO 4217 currency code, e.g. "USD" */
    currencyCode: string;
}
export interface IAPTransaction {
    productId: string;
    transactionId: string;
    /** JWS-signed transaction token (StoreKit 2) for server-side verification */
    jwsToken: string;
}
export type IAPPurchaseStatus = 'success' | 'pending' | 'cancelled';
export interface IAPPurchaseResult {
    status: IAPPurchaseStatus;
    /** Present only when status === 'success' */
    transactionId?: string;
    /** JWS token — present only when status === 'success' */
    jwsToken?: string;
}
export interface StoreKit2iOSPlugin {
    /**
     * Fetch StoreKit 2 product metadata for the given product IDs.
     * Returns an empty array if none of the IDs are found.
     * iOS 15+ only.
     */
    getProducts(options: {
        productIds: string[];
    }): Promise<{
        products: IAPProduct[];
    }>;
    /**
     * Initiate a purchase for the given product ID.
     * - 'success' → jwsToken + transactionId are populated; send jwsToken to your
     *   server for verification, then call finishTransaction.
     * - 'pending' → purchase is awaiting parental / Ask-to-Buy approval.
     * - 'cancelled' → user dismissed the payment sheet.
     * Rejects on network or StoreKit errors.
     * iOS 15+ only.
     */
    purchase(options: {
        productId: string;
    }): Promise<IAPPurchaseResult>;
    /**
     * Mark a transaction as finished (consumed).
     * Call this only AFTER your server has successfully verified the JWS token.
     * Resolves silently if the transaction is already finished.
     * iOS 15+ only.
     */
    finishTransaction(options: {
        transactionId: string;
    }): Promise<void>;
    /**
     * Return all currently active (non-expired, non-finished) entitlements.
     * Useful for restoring purchases on a new device.
     * iOS 15+ only.
     */
    restorePurchases(): Promise<{
        transactions: IAPTransaction[];
    }>;
    /**
     * Fired when a transaction arrives via the background Transaction.updates
     * observer — e.g. an interrupted purchase that completes later.
     * Always listen to this so no transactions are missed.
     */
    addListener(event: 'transactionUpdated', listenerFunc: (transaction: IAPTransaction) => void): Promise<PluginListenerHandle>;
    removeAllListeners(): Promise<void>;
}
