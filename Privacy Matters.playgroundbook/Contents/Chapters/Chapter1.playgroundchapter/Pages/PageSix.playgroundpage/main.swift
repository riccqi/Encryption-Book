//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code
//#-hidden-code
import PlaygroundSupport
import Foundation
import SwiftUI
import CryptoKit
import LocalAuthentication
//#-end-hidden-code

/*:
# A Commitment to Privacy

### This is where the Apple Secure Enclave hardware, built into most modern day Apple devices, comes in. It is a special hardware based key-manager that will request for user authentication before allowing access to the private key.
 
### Let's walk through the code for how we can implement Secure Enclave together with CryptoKit.
*/

/*:
- Note: To check if Secure Enclave hardware is available on your device!
*/
if SecureEnclave.isAvailable {
/*:
- Note: Specify that the private key can only be retrieved from the Secure Enclave after user device authentication.
*/
    let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, [.privateKeyUsage, .biometryCurrentSet], nil)!
    let authContext = LAContext()
/*:
- Note: Creating the private key that will be stored in the Secure Enclave.
*/
    let userPrivateKey = try? SecureEnclave.P256.Signing.PrivateKey(accessControl: accessControl, authenticationContext: authContext)
    
    let endText = /*#-editable-code message*/"Have an awesome WWDC21!"/*#-end-editable-code*/.data(using: .utf8)
    
    let signature = try userPrivateKey!.signature(for: endText!)
//#-hidden-code
    let printedSignature = signature.withUnsafeBytes{
        Data(Array($0)).base64EncodedString()
    }
    print(printedSignature)
    PlaygroundPage.current.setLiveView(EnclaveView(signature: printedSignature))
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Congrats! You have successfully retrieved your Private Key from your Secure Enclave.\n This is the end of my Playground Book. Hope you had as much fun learning about encryption as I did making this!")
//#-end-hidden-code
    
} else {
/*:
- Note: This is executed instead if Secure Enclave hardware is not available on your device. Key will be created as usual.
*/
    let userPrivateKey = P256.Signing.PrivateKey()
//#-hidden-code
    
    PlaygroundPage.current.setLiveView(NoEnclaveView())
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Looks like your MacBook does not have the Secure Enclave hardware. you could try this Playground again on a device with Secure Enclave hardware.\n This is the end of my Playground Book. Hope you had as much fun learning about encryption as I did making this!")
//#-end-hidden-code
}
/*:
- Important: Lets run your code to use your private key for encryption.
First, you will be asked to authenticate yourself, as we have specified in the code above.
If you do not have secure enclave on your device, the key will be created as usual without being authentication protected.
*/
