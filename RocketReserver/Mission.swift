//
//  Mission.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation

struct Mission: Equatable, Comparable {
    var name: String
    var missionPatch: String

    static let `default` = Self(name: "", missionPatch: "")

    static func < (lhs: Mission, rhs: Mission) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Mission, rhs: Mission) -> Bool {
        return lhs.name == rhs.name
    }

    init(name: String, missionPatch: String) {
        self.name = name
        self.missionPatch = missionPatch
    }
}
