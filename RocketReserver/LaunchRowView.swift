//
//  LaunchRowView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI

struct LaunchRowView: View {
    var launch: Launch
    
    var body: some View {
        Text(launch.site)
    }
}
