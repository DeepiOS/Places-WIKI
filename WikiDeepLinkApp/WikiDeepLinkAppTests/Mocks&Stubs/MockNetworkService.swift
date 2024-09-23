//
//  MockNetworkService.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

final class MockNetworkService: AsyncNetworkServicing {
    var result: Any? // To hold the mock result
    var error: Error? // To hold a mock error if needed
    var requestCallCount: Int = 0 // To know the request is being called

    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response {
        requestCallCount += 1
        // Check if there's a mock error to throw
        if let error = error {
            throw error
        }

        // If a result is provided, cast it to the expected type and return it
        if let result = result as? Request.Response {
            return result
        }

        // If neither a result nor an error is provided, throw an unexpected error
        throw NSError(domain: "MockNetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock response provided"])
    }
}
