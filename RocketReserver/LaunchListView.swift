//
//  LaunchListView.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import SwiftUI

struct LaunchListView: View {
    @EnvironmentObject var store: ObjectStore

    var body: some View {
        NavigationView {
            ZStack {
                
                List(self.store.launches) { launch in
                    NavigationLink(
                        destination:
                            LaunchDetailView(
                                id: launch.id,
                                site: launch.site
                            )
                            .environmentObject(self.store)
                        )
                        {
                            LaunchRowView(launch: launch)
                        }
                }
                
            }
            .navigationBarTitle("Launches")
            .onAppear() {
                self.store.fetchLaunches()
            }
        }
    }
}
