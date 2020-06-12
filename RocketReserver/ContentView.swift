//
//  ContentView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: ObjectStore
    
    var body: some View {
        ZStack {
            LaunchListView()
            
            ActivityIndicator(shouldAnimate: $store.isLoading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
