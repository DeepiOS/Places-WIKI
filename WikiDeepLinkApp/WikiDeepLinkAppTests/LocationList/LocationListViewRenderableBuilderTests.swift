//
//  LocationListViewRenderableBuilderTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import XCTest
@testable import WikiDeepLinkApp

class LocationListViewRenderableBuilderTests: XCTestCase {
    private var sut: LocationListViewRenderableBuilder!
    private var mockLocationConverter: MockLocationConverter!

    override func setUp() {
        super.setUp()
        mockLocationConverter = .init()
        sut = .init(locationConverter: mockLocationConverter)
    }

    override func tearDown() {
        mockLocationConverter = nil
        sut = nil
        super.tearDown()
    }

    func test_build_with_fetchLocationResponse_having_no_coordinates_data() async {
        // Given
        let fetchLocationResponse = FetchLocationResponse(
            locations: [
                .init(name: "Amsterdam", lat: nil, long: nil),
                .init(name: "Eindhoven", lat: nil, long: nil)
            ]
        )

        // When
        let result = await sut.build(fetchLocationResponse)

        // Then
        XCTAssertEqual(mockLocationConverter.getLocationCallCount, 0)
        XCTAssertEqual(result, ["Amsterdam", "Eindhoven"])
    }

    func test_build_with_fetchLocationResponse_having_coordinates_data() async {
        // Given
        mockLocationConverter.result = "Mumbai"
        let fetchLocationResponse = FetchLocationResponse(
            locations: [
                .init(name: "Amsterdam", lat: nil, long: nil),
                .init(name: nil, lat: 19.0823998, long: 72.8111468)
            ]
        )

        // When
        let result = await sut.build(fetchLocationResponse)

        // Then
        XCTAssertEqual(mockLocationConverter.getLocationCallCount, 1)
        XCTAssertEqual(result, ["Amsterdam", "Mumbai"])
    }
}
