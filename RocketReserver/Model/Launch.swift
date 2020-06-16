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
    var site: String?
    var mission: Mission?
    var rocket: Rocket?
    var isBooked: Bool?

    static let `default` = Self(
        id: "id",
        site: "site",
        mission: Mission.default,
        rocket: Rocket.default,
        isBooked: false
    )

    static func < (lhs: Launch, rhs: Launch) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func ==(lhs: Launch, rhs: Launch) -> Bool {
        return lhs.id == rhs.id
    }

    init(id: String, site: String? = nil, mission: Mission? = nil, rocket: Rocket? = nil, isBooked: Bool? = nil) {
        self.id = id
        self.site = site
        self.mission = mission
        self.rocket = rocket
        self.isBooked = isBooked
    }
}
