//
//  WikiDeepLinkAppApp.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import SwiftUI

@main
struct WikiDeepLinkAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LocationListView(
                    viewModel: .init(
                        networkService: DefaultNetworkService(),
                        deeplinkBuilder: WikiDeepLinkBuilder(),
                        localDataStorage: LocalDataStorage()
                    )
                )
            }
        }
    }
}
