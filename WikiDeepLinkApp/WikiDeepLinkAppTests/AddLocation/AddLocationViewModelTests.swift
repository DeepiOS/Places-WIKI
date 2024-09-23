//
//  AddLocationViewModelTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import XCTest
import SwiftUI
@testable import WikiDeepLinkApp

final class AddLocationViewModelTests: XCTestCase {
    private var sut: AddLocationView.ViewModel!
    private var mockLocalDataStorage: MockLocalDataStore!
    var wrappedIsPresentedValue: Bool = true
    var wrappedCityListValue: [String] = []

    override func setUp() {
        super.setUp()
        mockLocalDataStorage = .init()
        let isPresentedBinding = Binding<Bool>(
            get: { self.wrappedIsPresentedValue },
            set: { self.wrappedIsPresentedValue = $0 }
        )
        let cityListBinding = Binding<[String]>(
            get: { self.wrappedCityListValue },
            set: { self.wrappedCityListValue = $0 }
        )
        sut = .init(
            cityList: cityListBinding,
            isPresented: isPresentedBinding,
            localDataStorage: mockLocalDataStorage
        )
    }

    override func tearDown() {
        mockLocalDataStorage = nil
        sut = nil
        super.tearDown()
    }

    func test_handleAction_save() {
        // Given
        sut.inputText = "Amsterdam"

        // When
        sut.handleAction(.save)

        // Then
        XCTAssertEqual(mockLocalDataStorage.storeCallCount, 1)
        XCTAssertTrue(mockLocalDataStorage.storedData.contains("Amsterdam"))
        XCTAssertFalse(wrappedIsPresentedValue)
        XCTAssertTrue(wrappedCityListValue.contains("Amsterdam"))
    }

    func test_handleAction_save_empty_input() {
        // Given
        sut.inputText = ""

        // When
        sut.handleAction(.save)

        // Then
        XCTAssertEqual(mockLocalDataStorage.storeCallCount, 0)
        XCTAssertTrue(mockLocalDataStorage.storedData.isEmpty)
        XCTAssertTrue(wrappedIsPresentedValue)
        XCTAssertTrue(wrappedCityListValue.isEmpty)
    }

    func test_handleAction_save_already_existing_input() {
        // Given
        wrappedCityListValue.append("Amsterdam")
        wrappedCityListValue.append("Mumbai")
        sut.inputText = "mumbai"

        // When
        sut.handleAction(.save)

        // Then
        XCTAssertEqual(mockLocalDataStorage.storeCallCount, 0)
        XCTAssertTrue(mockLocalDataStorage.storedData.isEmpty)
        XCTAssertTrue(wrappedIsPresentedValue)
        XCTAssertEqual(wrappedCityListValue, ["Amsterdam", "Mumbai"])
        XCTAssertTrue(sut.showInformationMessage)
    }
}
