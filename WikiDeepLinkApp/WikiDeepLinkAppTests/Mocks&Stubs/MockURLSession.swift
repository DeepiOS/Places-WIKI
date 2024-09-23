//
//  MockURLSession.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

// Mock URLSession for testing
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw NetworkError.unknownError
        }
        return (data, response)
    }
}
