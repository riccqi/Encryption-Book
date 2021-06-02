//
//  IntroView.swift
//  UserModule
//
//  Created by Qi on 19/4/21.
//

import Foundation
import PlaygroundSupport
import SwiftUI


public struct IntroductionView: View {
    public init() {}
    @State private var textArray = ""
    public var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("Privacy with Encryption")
                Image(systemName: "lock.fill")
            }
            .font(.system(size:40, weight: .bold))
            
            HStack {
                Image("guyface")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                ChatBubble(direction: .left) {
                    Text("Hey Janelle, do you know how our End-to-End Encrypted chat works?")
                        .font(.title3)
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                ChatBubble(direction: .right) {
                    Text(textArray)
                        .font(.title3)
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                Image("girlface")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }
            
            Spacer()
            
        }
        .onAppear {
            let text = "Yes Tim! This is the Swift Playground where I learnt about encryption. It's easy to follow and CryptoKit is awesome!"
            typedText(string: text)
        
    }
    
    }
    
    func typedText(string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) {(timer) in
            textArray.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
        
    }
}
