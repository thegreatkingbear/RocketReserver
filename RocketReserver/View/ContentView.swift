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
            LaunchListView().environmentObject(self.store)
            
            ActivityIndicator(shouldAnimate: $store.isLoading)
        }
    }
}
