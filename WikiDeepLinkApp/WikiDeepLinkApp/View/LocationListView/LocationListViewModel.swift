//
//  LocationListViewModel.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation
import Combine
import UIKit

extension LocationListView {
    final class ViewModel: ObservableObject {
        let networkService : AsyncNetworkServicing
        let deeplinkBuilder : DeepLinkBuilding
        let locationListBuilder: LocationListViewRenderableBuilding
        let localDataStorage: LocalDataStoring
        let urlOpener: URLOpening
        @Published var isLoading: Bool = false
        @Published var showErrorMessage: Bool = false
        @Published var showAddLocation: Bool = false
        @Published var cityList: [String] = []

        init(
            networkService: AsyncNetworkServicing,
            deeplinkBuilder : DeepLinkBuilding,
            localDataStorage: LocalDataStoring,
            locationListBuilder: LocationListViewRenderableBuilding = LocationListViewRenderableBuilder(),
            urlOpener: URLOpening = UIApplication.shared
        ) {
            self.networkService = networkService
            self.deeplinkBuilder = deeplinkBuilder
            self.localDataStorage = localDataStorage
            self.locationListBuilder = locationListBuilder
            self.urlOpener = urlOpener
            initialSetUp()
        }

        func handleAction(_ action: Action) {
            switch action {
            case let .locationTapped(locationName):
                guard let url = deeplinkBuilder.build(placeholder: locationName) else {
                    return
                }
                urlOpener.openUrl(url)
            case .addLocation:
                showAddLocation = true
            case .refresh:
                initialSetUp()
            }
        }
    }
}

extension LocationListView.ViewModel {
    enum Action {
        case locationTapped(String)
        case addLocation
        case refresh
    }
}

// MARK: - Private

private extension LocationListView.ViewModel {
    func initialSetUp() {
        Task { @MainActor in
            isLoading = true
            do {
                let locationList = try await fetchLocations()
                let localStoredList = localDataStorage.getAllData()
                cityList = locationList + localStoredList
                isLoading = false
            } catch {
                cityList = localDataStorage.getAllData()
                isLoading = false
                showErrorMessage = true
            }
            
        }
    }

    func fetchLocations() async throws -> [String] {
        let fetchLocationRequest = FetchLocationRequest()
        guard let locations = try await networkService.request(fetchLocationRequest) else { return [] }
        return await buildLocationModels(locations)
    }

    func buildLocationModels(_ response: FetchLocationResponse) async -> [String] {
        return await locationListBuilder.build(response)
    }
}
