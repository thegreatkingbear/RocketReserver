//
//  LaunchRowView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LaunchRowView: View {
    var launch: Launch
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: launch.mission?.missionPatch ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5)) // not sure why this is not working
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(launch.mission?.name ?? "")
                Text(launch.site ?? "")
            }
        }
    }
}
