//
//  KeyCreationView.swift
//  PlaygroundBook
//
//  Created by Qi on 19/4/21.
//

import PlaygroundSupport
import SwiftUI

public struct CreateKeyView: View {
    
    let publicKey: String!
    var privateKey: String!
    var symmetricKey: String!
    var repeated: Bool!
    var friendKey: String?
    @State private var publicArray = ""
    @State private var privateArray = ""
    @State private var symmetricArray = ""
    @State private var friendArray = ""
    
    
    public init(publicKey: String, privateKey: String, symmetricKey: String, repeated: Bool, friendKey: String?) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.symmetricKey = symmetricKey
        self.repeated = repeated
        self.friendKey = friendKey
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            Text("Your Symmetric Encryption Key Pair")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Section {
                HStack{
                    Image(systemName: "key.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                    Text(privateArray)
                }
                HStack{
                    Image(systemName: "key.fill")
                        .foregroundColor(repeated ? .green : .orange)
                        .font(.largeTitle)
                    Text(publicArray)
                }
            }
            if repeated {
                Spacer()
                    .frame(height: 50)
                Text("Your Symmetric Key")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(.yellow)
                        .font(.largeTitle)
                    Text(symmetricArray)
                }
                
                if friendKey != nil {
                    Text("Friend's Symmetric Key")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.yellow)
                            .font(.largeTitle)
                        Text(friendArray)
                    }
                }
            }
        }
        .onAppear {

            typedPublic(string: publicKey)
            
            if !repeated {
                typedPrivate(string: privateKey)
            } else {
                if let keyValue = PlaygroundKeyValueStore.current["privateKey"],
                   case .string(let privateKeyStored) = keyValue {
                    privateArray = privateKeyStored
                }
            }
        }
    }
    
    func typedPublic(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {(timer) in
            publicArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
                if repeated {
                    typedSymmetric(string: symmetricKey)
                    typedFriend(string: friendKey ?? "")
                }
            }
        }
        
    }
    func typedPrivate(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {(timer) in
            privateArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
        PlaygroundKeyValueStore.current["privateKey"] = .string(privateKey)
    }
    
    func typedSymmetric(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {(timer) in
            symmetricArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
    }
    func typedFriend(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {(timer) in
            friendArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
    }
}
