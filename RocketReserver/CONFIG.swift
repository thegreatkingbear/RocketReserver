//
//  CONFIG.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/14.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

// this file should be excluded from git file system
// put CONFIG.swift in .gitignore file

import  Foundation

extension String {
    public static let loginKeychainKey = "RocketReserverLogin"
}

extension NSURL {
    public static let server = URL(string: "https://apollo-fullstack-tutorial.herokuapp.com")!
}
