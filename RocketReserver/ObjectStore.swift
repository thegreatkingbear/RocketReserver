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
    @Published var globalAlert: GlobalAlert?

    init() {
        self.launches = []
        self.isLoading = true
        self.isLoggedOut = false
        self.loginEmail = ""
        self.globalAlert = nil
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
    
    public func fetchLaunchDetails(id: String, forceReload: Bool = false) {
        self.isLoading = true
        
        let cachePolicy: CachePolicy
        if forceReload {
            cachePolicy = .fetchIgnoringCacheCompletely
        } else {
            cachePolicy = .returnCacheDataElseFetch
        }
        
        activeRequest = Network.shared.apollo.fetch(query: LaunchDetailsQuery(id: id), cachePolicy: cachePolicy) { result in
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
                self.globalAlert = GlobalAlert(
                    title: "Failure",
                    message: error.localizedDescription
                )
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
                    self.globalAlert = GlobalAlert(
                        title: "Failure",
                        message: error.description
                    )
                }
            case .failure(let error):
                self.globalAlert = GlobalAlert(
                    title: "Failure",
                    message: error.localizedDescription
                )
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
    
    public func bookTripOf(id: String) {
        self.isLoading = true
        
        activeRequest = Network.shared.apollo.perform(mutation: BookTripMutation(id: id)) { result in
            self.activeRequest = nil
            
            defer {
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                if results.data?.bookTrips.success ?? false {
                    self.launchDetail?.isBooked = true
                    self.globalAlert = GlobalAlert(
                        title: "Success",
                        message: results.data?.bookTrips.message ?? "Trip booked successfully."
                    )
                } else {
                    self.globalAlert = GlobalAlert(
                        title: "Failure",
                        message: results.data?.bookTrips.message ?? "Could not book trip."
                    )
                }
            case .failure(let error):
                self.globalAlert = GlobalAlert(
                    title: "Failure",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    public func cancelTripOf(id: String) {
        self.isLoading = true
        activeRequest = Network.shared.apollo.perform(mutation: CancelTripMutation(id: id)) { result in
            self.activeRequest = nil
            
            defer {
                self.isLoading = false
            }
            
            switch result {
            case .success(let results):
                if results.data?.cancelTrip.success ?? false {
                    self.launchDetail?.isBooked = false
                        self.globalAlert = GlobalAlert(
                            title: "Success",
                            message: results.data?.cancelTrip.message ?? "Trip canceled successfully."
                        )
                    } else {
                        self.globalAlert = GlobalAlert(
                            title: "Failure",
                            message: results.data?.cancelTrip.message ?? "Could not cancel trip."
                        )
                    }
            case .failure(let error):
                self.globalAlert = GlobalAlert(
                    title: "Failure",
                    message: error.localizedDescription
                )
            }
        }
    }
}
