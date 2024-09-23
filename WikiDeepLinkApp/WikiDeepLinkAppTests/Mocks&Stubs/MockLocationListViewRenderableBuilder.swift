//
//  MockLocationListViewRenderableBuilder.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

final class MockLocationListViewRenderableBuilder: LocationListViewRenderableBuilding {
    var mockResult: [String] = []
    var buildCallCount: Int = 0

    func build(_ response: FetchLocationResponse) async -> [String] {
        buildCallCount += 1
        return mockResult
    }
}
