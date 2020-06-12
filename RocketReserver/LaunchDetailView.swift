//
//  LaunchDetailView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI

struct LaunchDetailView: View {
    @EnvironmentObject var store: ObjectStore
    var id: String
    var site: String
    
    var body: some View {
        Text(id)
        .navigationBarTitle(site)
    }
}
