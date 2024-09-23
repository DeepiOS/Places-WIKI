//
//  MockDeepLinkBuilder.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

final class MockDeepLinkBuilder: DeepLinkBuilding {
    var mockURL: URL?
    var buildCallCount: Int = 0

    func build(placeholder: String) -> URL? {
        buildCallCount += 1
        return mockURL
    }
}
