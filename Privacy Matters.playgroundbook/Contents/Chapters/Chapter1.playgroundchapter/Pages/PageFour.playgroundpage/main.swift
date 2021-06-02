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
var isRepeated = false
//#-end-hidden-code

/*:
 # Using CryptoKit
 
 To first start using CryptoKit, we will need to import it into our code.
 */
import CryptoKit
/*:
### Remember, encryption is either secure or it is not. Our privacy and data deserve the highest level of protection, and for that the modern standard would be to use End-to-End Encryption (E2EE).
 
- Note: E2EE ensures that we no longer need to insecurely pass a single secret key around. Instead, it uses an algorithm to generate a pair of mathematically related keys, one public and one private, for both you and your friend. The goal is for both of you to end up with the same symmetric key.
 */
/*:
- Note: This type of encryption is also often referred to as Symmetric Encryption, because the end product should be two symmetric keys that are the same.
 
 Let's first create your random private key, using P256 elliptic curve algorithm that CryptoKit offers.
*/
let yourPrivateKey = P256.KeyAgreement.PrivateKey()
/*:
 - Note: Using your private key, CryptoKit can now generate your corresponding public key, which is mathematically linked to the private key. Hence, a key pair.
 */
let yourPublicKeyData = yourPrivateKey.publicKey.compactRepresentation!
/*:
 - Important: Run your code now to see how the public key and private key pair looks!
 */
//#-hidden-code
let friendPrivateKey = P256.KeyAgreement.PrivateKey()
let friendPublicKeyData = friendPrivateKey.publicKey.compactRepresentation!
let salt = "WWDC2021".data(using: .utf8)!
let friendPublicKey = try! P256.KeyAgreement.PublicKey(compactRepresentation: friendPublicKeyData)
var yourPublicKey = try! P256.KeyAgreement.PublicKey(compactRepresentation: yourPublicKeyData)
var publicKey = yourPublicKey.pemRepresentation
//#-end-hidden-code

/*:
 ### You can now exchange your public key with your friend over the data network. The private key stays securely protected on your device.
 
 To do the key exchange, uncomment the code below by deleting // in front of exchangePublicKey().
 */
//#-editable-code
//exchangePublicKey()
//#-end-editable-code
/*:
 Now that you have exchanged public key with your friend, time to generate your symmetric key. Once again, CryptoKit makes it really easy to do that with just a few lines of code.
 */
func generateSymmetricKey(privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) -> SymmetricKey {
    let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: 32)
    return symmetricKey
}
let yourSymmetricKey = generateSymmetricKey(privateKey: yourPrivateKey, publicKey: friendPublicKey)
let friendSymmetricKey = generateSymmetricKey(privateKey: friendPrivateKey, publicKey: yourPublicKey)
/*:
 - Important: Let's see how it looks, and prove that your friend has gotten the same symmetric key as you. Run the code now!
 
Therein lies the magic of End-to-End Encryption, where even if the hacker got their hands on your public key over the network, they would not be able to figure out the symmetric key as the private key is still securely stored on your device.
 
 
 [Let's proceed to use this key!](@next)
 */

//#-hidden-code
let symmetricKeyString = yourSymmetricKey.withUnsafeBytes {
    Data(Array($0)).base64EncodedString()
}
let friendSymmetricKeyString = friendSymmetricKey.withUnsafeBytes {
    Data(Array($0)).base64EncodedString()
}
PlaygroundKeyValueStore.current["symmetricKey"] = .string(symmetricKeyString)


PlaygroundPage.current.setLiveView(CreateKeyView(publicKey: publicKey, privateKey: yourPrivateKey.pemRepresentation, symmetricKey: symmetricKeyString, repeated: isRepeated, friendKey: friendSymmetricKeyString))

func exchangePublicKey() {
    publicKey = friendPublicKey.pemRepresentation
    isRepeated = true
    if friendSymmetricKeyString == symmetricKeyString {
        PlaygroundPage.current.assessmentStatus = .pass(message: "### Now that you have the same symmetric key as your friend, let's use it to encrypt a message.\n [**Click here to continue**](@next)")
    } else {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Looks like you and your friend got different symmetric keys, that shouldn't happen, check your code again"], solution: "Your friendSymmetricKey should be generated with friendPrivateKey and yourPublicKey.")
    }
}
//#-end-hidden-code
