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
import SwiftUI

var showDecrypt = false
var plainText = ""
//#-end-hidden-code

/*:
# Basic Encryption

### Encryption simply converts data such as texts, images or video into a secret form (aka ciphertext) using a key to prevent unauthorized access. Ciphertext requires the same key to decrypt and make it understandable again.
 
### Let's demonstrate this with a simple encryption of a text message.
 */
    
/*:
- Experiment: Input your text message here. You can use uppercase, lowercase, symbols and numbers in your message, just as you would enter in a real chat messenger. In encryption, this is often referred to as plaintext.
*/
let message = /*#-editable-code message*/"Hello WWDC21!"/*#-end-editable-code*/
/*:
- Note: You could just send this off to your friend as it is without encrypting, but anyone who intercepts it over the network can read the contents, without you or your friend even finding out! That could be very dangerous, so let's make sure no one unauthorized can read the message you just typed.
*/

/*:
- Experiment: Encrypting data must be done with a secret key. Only this key will be able to reverse the data back to readable form. Let's decide on a key, which can be any integer, postive or negative.
 */
let keyForEncryption = /*#-editable-code number*/12345/*#-end-editable-code*/
/*:
Let's now encrypt the message you wanted to send to your friend using the key you just created. This would give us the ciphertext.
 */
let cipherText = encrypt(message, using: keyForEncryption)
/*:
 - Important: You have completed your basic encryption and now can send this ciphertext to your friend for them to decrypt! Press "Run My Code" in the bottom right to see how your encrypted message looks like.
 */
/*:
- Experiment: You can edit the message and key fields above to see how different messages and keys will give vastly different ciphertexts! Just run this code again after editing to see the changes take effect.
*/

/*:
### Now that your friend has recieved the ciphertext, they will have to use the same key you used to decrypt the message.

### For the sake of demostration, let's decrypt the ciphertext that we just sent, just as how your friend would.

 - Experiment: To successfully decrypt a ciphertext, use the same key you used for encryption, by inputting keyForEncryption below. You can also experiement with other incorrect integer keys to see how the result would differ.
 */
let keyForDecryption = /*#-editable-code message*/keyForEncryption/*#-end-editable-code*/
/*:
 Let's now decrypt the ciphertext you sent to your friend using the key you chosen. This should give us back the plaintext.
 
 Remove the // from the front of the "plainText" below to uncomment the code.
 */
//#-editable-code
//plainText = decrypt(cipherText, with: keyForDecryption)
//#-end-editable-code
/*:
 - Important: Run your code again to see how your decryption now in action!

 This may seem to work great, but there is real challenge involved in transferring this secret key to your friend. Hackers are out to get our data, and they can easily get a hold of your key while it is being trasnferred over the data network. Let's now see how insecure basic encryption is, through a mini-game.

 \
[Let's continue!](@next)
 */

//#-hidden-code
PlaygroundKeyValueStore.current["plainText"] = .string(message)
//#-end-hidden-code

//#-hidden-code
PlaygroundKeyValueStore.current["cipherText"] = .string(cipherText)
//#-end-hidden-code


//#-hidden-code
PlaygroundPage.current.setLiveView(EncryptionView(cipherText: cipherText, message: message, keyEncrypt: keyForEncryption, keyDecrypt: keyForDecryption, plainText: plainText, showDecrypt: showDecrypt))

if keyForEncryption != keyForDecryption {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["The key you entered was not the right one used to encrypt this message!", "If you're just experimenting with different keys and cipherTexts, go ahead and have fun!"], solution: "To use the same key that you sent over to your friend, just enter keyForEncryption in the decryption key input field.")
}



func decrypt(_ cipherText: String, with key: Int) -> String {
    PlaygroundPage.current.assessmentStatus = .pass(message: "### You have successfully decrypted the message! Now that you understand the basics of encryption, let's take a look at how it can be made more secure with Apple's CryptoKit. \n [**Click here to continue**](@next)")
    showDecrypt = true
    var plainText = ""
    for i in cipherText {
        if i.isUppercase {
            var plainChar = (Int(i.asciiValue!) - key - 65) % 26 + 65
            while plainChar < 65 {
                plainChar += 26
            }
            plainText.append(Character(UnicodeScalar(plainChar)!))
        } else if i.isLowercase{
            var plainChar = (Int(i.asciiValue!) - key - 97) % 26 + 97
            while plainChar < 97 {
                plainChar += 26
            }
            plainText.append(Character(UnicodeScalar(plainChar)!))
        } else {
            plainText.append(i)
        }
    }
    return plainText
}
//#-end-hidden-code

