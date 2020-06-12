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
    @Published var isLoading: Bool
    
    init() {
        self.launches = []
        self.isLoading = true
    }
    
    public func fetchLaunches() {
        Network.shared.apollo.fetch(query: LaunchListQuery()) { result in
            self.isLoading = true
            defer {
                // after the calling ends
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                let items = results.data?.launches.launches.map { Launch(id: $0?.id ?? "", site: $0?.site ?? "") }
                self.launches.append(contentsOf: items ?? [])
            case . failure(let error):
                print(error)
            }
        }
    }
}
