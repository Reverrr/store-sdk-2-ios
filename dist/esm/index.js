import { registerPlugin } from '@capacitor/core';
const StoreKit2iOS = registerPlugin('StoreKit2iOS', {
    web: () => import('./web').then((m) => new m.StoreKit2iOSWeb()),
});
export * from './definitions';
// Export as StoreKit2iOS (canonical) and IAP (short alias for app usage)
export { StoreKit2iOS, StoreKit2iOS as IAP };
//# sourceMappingURL=index.js.map