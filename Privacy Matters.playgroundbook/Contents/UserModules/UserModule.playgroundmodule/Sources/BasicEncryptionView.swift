//
//  BasicEncryptionView.swift
//  PlaygroundBook
//
//  Created by Qi on 19/4/21.
//

import PlaygroundSupport
import SwiftUI
import Foundation

public struct EncryptionView: View {
    var message: String!
    var cipherText: String!
    var keyEncrypt: Int!
    var keyDecrypt: Int!
    var plainText: String!
    var showDecrypt: Bool!
    @State private var textArray = ""
    
    public init(cipherText: String, message: String, keyEncrypt: Int, keyDecrypt: Int, plainText: String, showDecrypt: Bool) {
        self.message = message
        self.cipherText = cipherText
        self.keyEncrypt = keyEncrypt
        self.keyDecrypt = keyDecrypt
        self.plainText = plainText
        self.showDecrypt = showDecrypt
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(#colorLiteral(red: 0.26514732837677, green: 0.26514732837677, blue: 0.26514732837677, alpha: 1.0)))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                VStack {
                    Image("girlface")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                    if #available(iOS 14.0, *) {
                        Text("Janelle")
                            .font(.title3)
                    } else {
                        // Fallback on earlier versions
                    }
                }.padding()
            }
            Spacer()
            HStack{
                
                VStack {
                    HStack {
                        Text(showDecrypt ? "Ciphertext" : "Plaintext")
                        Image(systemName: "doc.plaintext.fill")
                            .foregroundColor(.purple)
                    }
                    Text(showDecrypt ? cipherText : message)
                        .font(.largeTitle)
                        .padding()
                }
                
                VStack {
                    HStack {
                        Text(showDecrypt ? "Decrypt with Key" : "Encrypt With Key")
                        Image(systemName: "key.fill")
                            .foregroundColor(.yellow)
                    }
                    Text(showDecrypt ? "\(keyDecrypt)" : "\(keyEncrypt)")
                        .font(.largeTitle)
                        .padding()
                }
                
                
            }
            Spacer()
                .frame(height: 50)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .trailing){
                    HStack {
                        Text(showDecrypt ? "Plaintext" : "Ciphertext")
                        Image(systemName: "lock.doc.fill")
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 40)
                    ChatBubble(direction: .right) {
                        Text(textArray)
                            .font(.largeTitle)
                            .padding(.all, 20)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                }
                Image("guyface")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding(.trailing, 20)
            }
            Spacer()
        }
        .onAppear {
            if showDecrypt {
                typedText(string: plainText)
            } else {
                typedText(string: cipherText)
            }
        }
    }
    func typedText(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {(timer) in
            textArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
    }
}

public func encrypt(_ message: String, using key: Int) -> String {
    if key == 78 {
        print("sneaky! you will get back the same string do sth")
    }
    var cipherText = ""
    for i in message {
        if i.isUppercase && i.isASCII {
            //character is uppercase
            var encryptedChar = (Int(i.asciiValue!) + key - 65) % 26 + 65
            while encryptedChar < 65 {
                encryptedChar+=26
            }
            cipherText.append(Character(UnicodeScalar(encryptedChar)!))
        } else if i.isLowercase && i.isASCII {
            //character is lowercase
            var encryptedChar = (Int(i.asciiValue!) + key - 97) % 26 + 97
            while encryptedChar < 97 {
                encryptedChar += 26
            }
            cipherText.append(Character(UnicodeScalar(encryptedChar)!))
        } else {
            //              print("\(i) is not an ascii value, don't do anything to it")
            cipherText.append(i)
        }
    }
    return cipherText
}



