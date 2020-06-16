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
import KeychainSwift

class ObjectStore: ObservableObject {
    
    @Published var launches: [Launch]
    @Published var launchDetail: Launch?
    @Published var isLoading: Bool
    @Published var lastConnection: LaunchListQuery.Data.Launch?
    @Published var activeRequest: Apollo.Cancellable?
    @Published var isLoggedOut: Bool
    @Published var loginEmail: String {
       didSet {
           if self.emailValidator(loginEmail) {
               self.errorMessage = ""
           } else {
               self.errorMessage = "Valid email address needed"
           }
       }
   }
    @Published var errorMessage: String = ""

    init() {
        self.launches = []
        self.isLoading = true
        self.isLoggedOut = false
        self.loginEmail = ""
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
    
    public func loginWith(email: String) {
        self.isLoading = true
        
        activeRequest = Network.shared.apollo.perform(mutation: LoginMutation(email: email)) { result in
            self.activeRequest = nil
            
            defer {
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                if let token = results.data?.login {
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: .loginKeychainKey)
                    _ = self.checkOutLogInStatus()
                }
                
                // should be handled before production
                if let error = results.errors {
                    print(error)
                }
            case .failure(let error):
                // should be handled before production
                print(error)
            }
        }
    }
    
    public func checkOutLogInStatus() -> Bool {
        let keychain = KeychainSwift()
        isLoggedOut = keychain.get(.loginKeychainKey) == nil
        return isLoggedOut
    }

    func emailValidator(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}
