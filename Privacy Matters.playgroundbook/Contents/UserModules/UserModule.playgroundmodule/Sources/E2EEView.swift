//
//  E2EEView.swift
//  PlaygroundBook
//
//  Created by Qi on 19/4/21.
//


import PlaygroundSupport
import SwiftUI
import Foundation

public struct E2EEView: View {
    var plainText: String!
    var cipherText: String!
    var key: String!
    @State private var textArray = ""
    
    public init(cipherText: String, plaintext: String, key: String) {
        self.plainText = plaintext
        self.cipherText = cipherText
        self.key = key
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.gray)
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
                        Text("Janelle")
                            .font(.title)
                    }
                }.padding()
            }
            Spacer()
            HStack{
                
                VStack {
                    HStack {
                        Text("Plaintext")
                        Image(systemName: "doc.plaintext.fill")
                            .foregroundColor(.purple)
                    }
                    if #available(iOS 14.0, *) {
                        Text(plainText)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                VStack {
                    HStack {
                        Text("Encrypt with Symmetric Key")
                        Image(systemName: "key.fill")
                            .foregroundColor(.yellow)
                    }
                    if #available(iOS 14.0, *) {
                        Text("\(key)")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                
            }
            Spacer()
                .frame(height: 50)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .trailing){
                    HStack {
                        Text("Ciphertext")
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
        }.onAppear {
            typedText(string: cipherText)
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

