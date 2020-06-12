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
    
    init() {
        self.launches = []
    }
    
    public func fetchLaunches() {
        Network.shared.apollo.fetch(query: LaunchListQuery()) { result in
            
            defer {
                // after the calling ends
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
