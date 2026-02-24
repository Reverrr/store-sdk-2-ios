import { registerPlugin } from '@capacitor/core';

import type { StoreKit2iOSPlugin } from './definitions';

const StoreKit2iOS = registerPlugin<StoreKit2iOSPlugin>('StoreKit2iOS', {
  web: () => import('./web').then((m) => new m.StoreKit2iOSWeb()),
});

export * from './definitions';
export { StoreKit2iOS };
