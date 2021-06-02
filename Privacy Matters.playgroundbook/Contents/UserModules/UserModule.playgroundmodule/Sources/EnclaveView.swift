//
//  EnclaveView.swift
//  PlaygroundBook
//
//  Created by Richard Qi on 20/4/21.
//

import Foundation
import SwiftUI

public struct EnclaveView: View {
    var signature: String!
    @State private var textArray = ""
    public init(signature: String) {
        self.signature = signature
    }
    public var body: some View {
        VStack {
            Image(systemName: "lock.open.fill")
                .font(.largeTitle)
                .padding()
            Text("You have successfully retrieved your private key")
                .bold()
                .font(.largeTitle)
            Text(signature)
                .multilineTextAlignment(.center)
                .padding()
        }
        
    }
}

public struct NoEnclaveView: View {
    public init() {}
    public var body: some View {
        VStack {
            Image(systemName: "lock.open.fill")
                .font(.largeTitle)
                .padding()
            Text("Secure Enclave is not present on your device.")
                .bold()
                .font(.largeTitle)
            Text("Your Private Key has been retrieved without authentication.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
