import { WebPlugin } from '@capacitor/core';
export class StoreKit2iOSWeb extends WebPlugin {
    async getProducts(_options) {
        throw this.unimplemented('IAP is not available on web');
    }
    async purchase(_options) {
        throw this.unimplemented('IAP is not available on web');
    }
    async finishTransaction(_options) {
        throw this.unimplemented('IAP is not available on web');
    }
    async restorePurchases() {
        throw this.unimplemented('IAP is not available on web');
    }
}
//# sourceMappingURL=web.js.map