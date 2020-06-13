//
//  LaunchDetailView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LaunchDetailView: View {
    @EnvironmentObject var store: ObjectStore
    var id: String
    var site: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                WebImage(url: URL(string:self.store.launchDetail?.mission?.missionPatch ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5)) // not sure why this is not working
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)

                VStack(alignment: .leading) {
                    Text(self.store.launchDetail?.mission?.name ?? "")
                        .font(.headline)
                    
                    Text("🚀 \(self.store.launchDetail?.rocket?.name ?? "") \(self.store.launchDetail?.rocket?.type ?? "")")
                        .font(.subheadline)
                    
                    Text("Launching from \(self.store.launchDetail?.site ?? "")")
                        .font(.body)
                }
            }
            
            Spacer()
        }
        .onAppear() {
            self.store.fetchLaunchDetails(id: self.id)
        }
    }
}
