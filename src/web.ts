import { WebPlugin } from '@capacitor/core';

import type { IAPProduct, IAPPurchaseResult, IAPTransaction, StoreKit2iOSPlugin } from './definitions';

export class StoreKit2iOSWeb extends WebPlugin implements StoreKit2iOSPlugin {
  async getProducts(_options: { productIds: string[] }): Promise<{ products: IAPProduct[] }> {
    throw this.unimplemented('IAP is not available on web');
  }

  async purchase(_options: { productId: string }): Promise<IAPPurchaseResult> {
    throw this.unimplemented('IAP is not available on web');
  }

  async finishTransaction(_options: { transactionId: string }): Promise<void> {
    throw this.unimplemented('IAP is not available on web');
  }

  async restorePurchases(): Promise<{ transactions: IAPTransaction[] }> {
    throw this.unimplemented('IAP is not available on web');
  }
}
