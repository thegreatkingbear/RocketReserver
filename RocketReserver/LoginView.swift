//
//  LoginView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/14.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String
    
    var body: some View {
        VStack {
            Text("Log In")
                .font(.largeTitle)
            
            TextField("email address", text: $email)
            
            Button(action: {}) {
                Text("Submit")
            }
            
            Spacer()
        }
    }
}
