import { StoreKit2iOS } from 'capacitor-storekit2-ios';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    StoreKit2iOS.echo({ value: inputValue })
}
