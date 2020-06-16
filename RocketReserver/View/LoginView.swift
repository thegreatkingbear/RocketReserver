//
//  LoginView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/14.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI
import KeychainSwift
import Combine

struct LoginView: View {
    @EnvironmentObject var store: ObjectStore

    var body: some View {
        VStack {
            Text("Log In")
                .font(.title)
                .padding()
            
            TextField("email address", text: self.$store.loginEmail)
                .padding()
            
            Text(self.store.errorMessage)
                .font(.callout)
                .foregroundColor(.red)
            
            Spacer()
                .frame(height: 100)
            
            Button("Submit") {
                self.store.loginWith(email: self.store.loginEmail)
            }
            
            Spacer()
        }
    }
    
}
