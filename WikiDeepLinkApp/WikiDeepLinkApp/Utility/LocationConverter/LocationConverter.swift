//
//  LocationConverter.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import MapKit

/// A protocol that will convert latitude and longitude information to a location name
protocol LocationConverting {
    func getLocationFromCoordinates(lat: Double, long: Double) async -> String?
}

final class LocationConverter: LocationConverting {
    func getLocationFromCoordinates(lat: Double, long: Double) async -> String? {
        let location = CLLocation(latitude: lat, longitude: long)
        return await withCheckedContinuation { continuation in
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: placemark.locality)
            }
        }
    }
}
