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
        List(self.store.launches) { launch in
            Text(launch.site)
        }
        .onAppear() {
            self.store.fetchLaunches()
        }
    }
}

struct LaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchListView()
    }
}
