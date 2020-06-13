//
//  ObjectStore.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation
import Combine
import Apollo

class ObjectStore: ObservableObject {
    @Published var launches: [Launch]
    @Published var launchDetail: Launch?
    @Published var isLoading: Bool
    @Published var lastConnection: LaunchListQuery.Data.Launch?
    @Published var activeRequest: Apollo.Cancellable?

    init() {
        self.launches = []
        self.isLoading = true
    }
    
    public func loadLaunches() {
        guard let connection = self.lastConnection else {
            self.fetchLaunches(from: nil)
            return
        }
        
        guard connection.hasMore else {
            return
        }
        
        self.fetchLaunches(from: connection.cursor)
    }
    
    private func fetchLaunches(from cursor: String?) {
        // loading start
        self.isLoading = true
        
        activeRequest = Network.shared.apollo.fetch(query: LaunchListQuery(cursor: cursor)) { result in
            self.activeRequest = nil
            
            defer {
                // loading ends
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                if let launchConnection = results.data?.launches {
                    self.lastConnection = launchConnection
                    let items = results.data?.launches.launches.map {
                        Launch(
                            id: $0?.id ?? "",
                            site: $0?.site ?? "",
                            mission: Mission(
                                name: $0?.mission?.name ?? "",
                                missionPatch: $0?.mission?.missionPatch ?? ""
                            )
                        )
                    }
                    self.launches.append(contentsOf: items ?? [])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func fetchLaunchDetails(id: String) {
        self.isLoading = true
        
        activeRequest = Network.shared.apollo.fetch(query: LaunchDetailsQuery(id: id)) { result in
            self.activeRequest = nil
            
            defer {
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                if let launch = results.data?.launch {
                    self.launchDetail = Launch(
                        id: launch.id,
                        site: launch.site,
                        mission: Mission(
                            name: launch.mission?.name ?? "",
                            missionPatch: launch.mission?.missionPatch ?? ""
                        ),
                        rocket: Rocket(
                            name: launch.rocket?.name ?? "",
                            type: launch.rocket?.type ?? ""
                        ),
                        isBooked: launch.isBooked
                    )
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
