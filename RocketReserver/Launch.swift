//
//  Launch.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation

struct Launch: Identifiable, Equatable, Comparable {
    var id: String
    var site: String
    var mission: Mission

    static let `default` = Self(id: "", site: "", mission: Mission(name: "", missionPatch: ""))

    static func < (lhs: Launch, rhs: Launch) -> Bool {
        return lhs.site < rhs.site
    }
    
    static func ==(lhs: Launch, rhs: Launch) -> Bool {
        return lhs.id == rhs.id
    }

    init(id: String, site: String, mission: Mission) {
        self.id = id
        self.site = site
        self.mission = mission
    }
}
