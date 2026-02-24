'use strict';

var core = require('@capacitor/core');

const StoreKit2iOS = core.registerPlugin('StoreKit2iOS', {
    web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.StoreKit2iOSWeb()),
});

class StoreKit2iOSWeb extends core.WebPlugin {
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

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    StoreKit2iOSWeb: StoreKit2iOSWeb
});

exports.IAP = StoreKit2iOS;
exports.StoreKit2iOS = StoreKit2iOS;
//# sourceMappingURL=plugin.cjs.js.map
