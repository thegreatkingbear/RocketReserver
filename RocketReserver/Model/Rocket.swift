//
//  Rocket.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/13.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation

struct Rocket: Equatable, Comparable {
    var name: String
    var type: String

    static let `default` = Self(
        name: "rocket name",
        type: "rocket type"
    )

    static func < (lhs: Rocket, rhs: Rocket) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Rocket, rhs: Rocket) -> Bool {
        return lhs.name == rhs.name
    }

    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}
