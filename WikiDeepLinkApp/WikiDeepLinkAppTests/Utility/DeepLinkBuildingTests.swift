//
//  DeepLinkBuildingTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import XCTest
@testable import WikiDeepLinkApp

final class DeepLinkBuildingTests: XCTestCase {
    private var sut: WikiDeepLinkBuilder!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_build_url_for_input() {
        // Given
        let expectedURL = URL(string: "wikipedia://places?WMFLocationName=Amsterdam")!
        let placeHolder = "Amsterdam"

        // When
        let url = sut.build(placeholder: placeHolder)

        // Then
        XCTAssertEqual(url, expectedURL)
    }
}
