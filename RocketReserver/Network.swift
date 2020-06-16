//
//  Network.swift
//  RocketReserver
//
//  Created by Mookyung Kwak on 2020/06/12.
//  Copyright © 2020 Mookyung Kwak. All rights reserved.
//

import Foundation
import Apollo
import KeychainSwift

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: NSURL.server)
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    } ()
}

extension Network: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        let keychain = KeychainSwift()
        if let token = keychain.get(.loginKeychainKey) {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
    }
}
