import { WebPlugin } from '@capacitor/core';
import type { IAPProduct, IAPPurchaseResult, IAPTransaction, StoreKit2iOSPlugin } from './definitions';
export declare class StoreKit2iOSWeb extends WebPlugin implements StoreKit2iOSPlugin {
    getProducts(_options: {
        productIds: string[];
    }): Promise<{
        products: IAPProduct[];
    }>;
    purchase(_options: {
        productId: string;
    }): Promise<IAPPurchaseResult>;
    finishTransaction(_options: {
        transactionId: string;
    }): Promise<void>;
    restorePurchases(): Promise<{
        transactions: IAPTransaction[];
    }>;
}
