//
//  GlobalAlert.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/16.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation

struct GlobalAlert {
    var title: String = ""
    var message: String = ""
}

extension GlobalAlert: Identifiable {
    var id: String { return title }
}
