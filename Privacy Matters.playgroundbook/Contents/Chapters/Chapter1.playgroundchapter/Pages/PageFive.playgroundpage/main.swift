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
import CryptoKit
import Foundation
//#-end-hidden-code

/*:
# End-to-End Encryption
## This page will feel very familiar to the previous encryption page, since all you have to do now is use the symmetric key and encrypt a message.
*/
//#-hidden-code
let yourPrivateKey = P256.KeyAgreement.PrivateKey()

let friendPrivateKey = P256.KeyAgreement.PrivateKey()
let friendPublicKeyData = friendPrivateKey.publicKey.compactRepresentation!

let salt = "WWDC2021".data(using: .utf8)!

let friendPublicKey = try! P256.KeyAgreement.PublicKey(compactRepresentation: friendPublicKeyData)
let yourSharedSecret = try! yourPrivateKey.sharedSecretFromKeyAgreement(with: friendPublicKey)
let yourSymmetricKey = yourSharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: 32)
var symmetricKeyString = yourSymmetricKey.withUnsafeBytes {
    Data(Array($0)).base64EncodedString()
}

if let keyValue = PlaygroundKeyValueStore.current["symmetricKey"],
   case .string(let symmetricKeyStored) = keyValue {
    symmetricKeyString = symmetricKeyStored
}

var storedPlainText: String = ""
if let keyValue = PlaygroundKeyValueStore.current["plainText"],
   case .string(let plainTextStored) = keyValue {
    storedPlainText = plainTextStored
}
//#-end-hidden-code

/*:
 - Experiment: Type a message here, or you could use the message you previously used in basic encryption by inputting storedPlaintext, to see how different the ciphertext will look.
 */
let message = /*#-editable-code message*/storedPlainText/*#-end-editable-code*/
/*:
We can now obtain the ciphertext by encrypting our message with the symmetric key using CryptoKit.
 */
let data = message.data(using: .utf8)!
let sealedBoxData = try! ChaChaPoly.seal(data, using: yourSymmetricKey).combined
let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
let cipherText = sealedBox.ciphertext.base64EncodedString()
/*:
 - Important: Run your code to see how your ciphertext looks like when encrypted with a symmetric key.
 You are now well versed in encryption basics and better understand why End-to-End Encryption is used so extensively to protect our privacy nowadays. Let's move on to the last page of this playground, for one more special thing.
 
  [One more thing...](@next)
*/

/*:
 - Note: Did you notice that the encrypted message is now completely random? Unlike when we use our own numeric key, where the spaces and symbols were not converted. In fact, this encryption can be done with files, images text and video streams!
*/


//#-hidden-code
PlaygroundPage.current.assessmentStatus = .pass(message: "### Your message is now super secure with End-to -End Encryption, your friend can now use their symmetric key to decrypt. But CryptoKit still has a niffty feature up it's sleeve\n [**One More Thing...**](@next)")
PlaygroundPage.current.setLiveView(E2EEView(cipherText: cipherText, plaintext: message, key: symmetricKeyString))
//#-end-hidden-code






