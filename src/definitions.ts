export interface StoreKit2iOSPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
