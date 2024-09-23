//
//  NetworkServiceTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import UIKit
import XCTest
@testable import WikiDeepLinkApp

// Example Response object
struct MockResponse: Decodable, Equatable {
    let message: String
}

// Mock Request for testing
struct MockRequest: DataRequest {
    typealias Response = MockResponse

    let url: String
    let method: HTTPMethod
    let queryItems: [String: String]
    let headers: [String: String]?

    func decode(_ data: Data) throws -> MockResponse {
        return try JSONDecoder().decode(MockResponse.self, from: data)
    }
}

class DefaultNetworkServiceTests: XCTestCase {

    var networkService: DefaultNetworkService!
    var sessionMock: MockURLSession!

    override func setUp() {
        super.setUp()
        sessionMock = MockURLSession()
        networkService = DefaultNetworkService(session: sessionMock)
    }

    override func tearDown() {
        sessionMock = nil
        networkService = nil
        super.tearDown()
    }

    func testRequest_SuccessfulResponse() async throws {
        // Given
        let request = MockRequest(
            url: "https://mockapi.com/success",
            method: .get,
            queryItems: [:],
            headers: nil
        )
        let mockData = """
        {
            "message": "Success"
        }
        """.data(using: .utf8)!
        sessionMock.data = mockData
        sessionMock.response = HTTPURLResponse(url: URL(string: request.url)!,
                                               statusCode: 200, httpVersion: nil, headerFields: nil)

        // When
        let result = try await networkService.request(request)

        // Then
        XCTAssertEqual(result.message, "Success")
    }

    func testRequest_InvalidEndpoint() async throws {
        // Given
        let request = MockRequest(
            url: "http://example.com:-80/",
            method: .get,
            queryItems: [:],
            headers: nil
        )

        do {
            // When
            _ = try await networkService.request(request)
            XCTFail("Expected NetworkError.invalidEndpoint but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidEndpoint)
        }
    }

    func testRequest_ClientErrorResponse() async throws {
        // Given
        let request = MockRequest(
            url: "https://mockapi.com/notfound",
            method: .get,
            queryItems: [:],
            headers: nil
        )
        let mockData = """
        {
            "message": "Failed"
        }
        """.data(using: .utf8)!
        sessionMock.data = mockData
        sessionMock.response = HTTPURLResponse(url: URL(string: request.url)!,
                                               statusCode: 404, httpVersion: nil, headerFields: nil)

        do {
            // When
            _ = try await networkService.request(request)
            XCTFail("Expected NetworkError.notFound but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.notFound)
        }
    }

    func testRequest_ServerErrorResponse() async throws {
        // Given
        let request = MockRequest(
            url: "https://mockapi.com/servererror",
            method: .get,
            queryItems: [:],
            headers: nil
        )
        let mockData = """
        {
            "message": "Failed"
        }
        """.data(using: .utf8)!
        sessionMock.data = mockData
        sessionMock.response = HTTPURLResponse(url: URL(string: request.url)!,
                                               statusCode: 500, httpVersion: nil, headerFields: nil)

        do {
            // When
            _ = try await networkService.request(request)
            XCTFail("Expected NetworkError.badRequest but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.badRequest)
        }
    }

    func testRequest_DataParsingError() async throws {
        // Given
        let request = MockRequest(
            url: "https://mockapi.com/malformeddata",
            method: .get,
            queryItems: [:],
            headers: nil
        )
        let malformedData = "invalid json".data(using: .utf8)!
        sessionMock.data = malformedData
        sessionMock.response = HTTPURLResponse(url: URL(string: request.url)!,
                                               statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            // When
            _ = try await networkService.request(request)
            XCTFail("Expected NetworkError.dataParsingError but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.dataParsingError)
        }
    }
}
