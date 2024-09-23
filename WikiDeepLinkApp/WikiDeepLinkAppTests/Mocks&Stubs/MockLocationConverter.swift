//
//  MockLocationConverter.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

final class MockLocationConverter: LocationConverting {
    var result: String?
    var getLocationCallCount: Int = 0

    func getLocationFromCoordinates(lat: Double, long: Double) async -> String? {
        getLocationCallCount += 1
        return result
    }
}
