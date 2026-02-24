import { WebPlugin } from '@capacitor/core';

import type { StoreKit2iOSPlugin } from './definitions';

export class StoreKit2iOSWeb extends WebPlugin implements StoreKit2iOSPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
