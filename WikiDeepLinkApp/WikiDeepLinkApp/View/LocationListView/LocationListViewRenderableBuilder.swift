//
//  LocationListViewRenderableBuilder.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation

/// A protocol that will build LocationList data
protocol LocationListViewRenderableBuilding {
    func build(_ response: FetchLocationResponse) async -> [String]
}

final class LocationListViewRenderableBuilder: LocationListViewRenderableBuilding {
    let locationConverter: LocationConverting

    init(locationConverter: LocationConverting = LocationConverter()) {
        self.locationConverter = locationConverter
    }

    func build(_ response: FetchLocationResponse) async -> [String] {
        await withTaskGroup(of: String?.self) { group in
            var locationNames: [String] = []

            for location in response.locations {
                if let name = location.name {
                    locationNames.append(name)
                } else if let lat = location.lat, let long = location.long {
                    group.addTask { [self] in
                        let name = await locationConverter.getLocationFromCoordinates(lat: lat, long: long)
                        return name
                    }
                }
            }

            for await name in group {
                guard let name else { continue }
                locationNames.append(name)
            }
            return locationNames
        }
    }
}
