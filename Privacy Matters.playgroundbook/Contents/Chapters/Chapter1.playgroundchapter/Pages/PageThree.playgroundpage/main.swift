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
import SpriteKit
import SwiftUI
//#-end-hidden-code

/*:
# Protect Your Key Mini-game

### Passing the secret key to your friend securely over a data network may seem like a trivial problem, but hackers are out to get your information!

### They can easily intercept your secret key through the data network if you're not careful.
*/
 
/*:
- Note: Another common and easy way a hacker can get your key would be simply to brute force and guess your key using the computation power of modern computers.
*/

/*:
- Important: Click on "Run My Code" now and play a game in fullscreen. All the best and enjoy!
 
 [Done with the game? Let's continue](@next)
*/

//#-hidden-code
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.setLiveView(GameView())
//#-end-hidden-code
