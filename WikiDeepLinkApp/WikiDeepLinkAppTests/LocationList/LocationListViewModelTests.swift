//
//  LocationListViewModelTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import XCTest
import Combine
@testable import WikiDeepLinkApp

class LocationListViewModelTests: XCTestCase {
    private var sut: LocationListView.ViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockDeepLinkBuilder: MockDeepLinkBuilder!
    private var mockLocationListViewRenderableBuilder: MockLocationListViewRenderableBuilder!
    private var mockLocalDataStore: MockLocalDataStore!
    private var mockURLOpener: MockURLOpener!
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockNetworkService = .init()
        mockDeepLinkBuilder = .init()
        mockLocationListViewRenderableBuilder = .init()
        mockLocalDataStore = .init()
        mockURLOpener = .init()
    }

    override func tearDown() {
        subscriptions.removeAll()
        mockNetworkService = nil
        mockDeepLinkBuilder = nil
        mockLocationListViewRenderableBuilder = nil
        mockLocalDataStore = nil
        mockURLOpener = nil
        sut = nil
        super.tearDown()
    }

    func setUpSut() {
        sut = .init(
            networkService: mockNetworkService,
            deeplinkBuilder: mockDeepLinkBuilder,
            localDataStorage: mockLocalDataStore,
            locationListBuilder: mockLocationListViewRenderableBuilder,
            urlOpener: mockURLOpener
        )
    }

    func presetSuccessfulSetUp() {
        mockNetworkService.result = FetchLocationResponse(
            locations: [
                .init(name: "Amsterdam", lat: nil, long: nil),
                .init(name: "Eindhoven", lat: nil, long: nil)
            ]
        )
        mockLocalDataStore.storedData = ["Utrecht", "Almere"]
        mockLocationListViewRenderableBuilder.mockResult = ["Amsterdam", "Eindhoven"]
    }

    func test_initialSetUp_onLoad() {
        // Given
        presetSuccessfulSetUp()

        // When
        setUpSut()
        let expectation = expectation(description: "initial_setup")
        sut.$cityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [expectation], timeout: 3.0)

        // Then
        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
        XCTAssertEqual(mockLocalDataStore.getAllDataCallCount, 1)
        XCTAssertEqual(mockLocationListViewRenderableBuilder.buildCallCount, 1)
        XCTAssertEqual(sut.cityList, ["Amsterdam", "Eindhoven", "Utrecht", "Almere"])
        XCTAssertFalse(sut.isLoading)
    }

    func test_initialSetUp_onLoad_error_on_fetch_server_data() {
        // Given
        mockNetworkService.error = NetworkError.responseUnsuccessful
        mockLocalDataStore.storedData = ["Utrecht", "Almere"]

        // When
        setUpSut()
        let expectation = expectation(description: "initial_setup")
        sut.$cityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [expectation], timeout: 3.0)

        // Then
        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
        XCTAssertEqual(mockLocalDataStore.getAllDataCallCount, 1)
        XCTAssertEqual(sut.cityList, ["Utrecht", "Almere"])
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showErrorMessage)
    }

    func test_handleAction_location_tapped() {
        // Given
        presetSuccessfulSetUp()
        setUpSut()
        mockDeepLinkBuilder.mockURL = URL(string: "www.google.com")

        // When
        sut.handleAction(.locationTapped("Utrecht"))

        // Then
        XCTAssertEqual(mockDeepLinkBuilder.buildCallCount, 1)
        XCTAssertEqual(mockURLOpener.openUrlCallCount, 1)
        XCTAssertEqual(mockURLOpener.openedURL, mockDeepLinkBuilder.mockURL)
    }

    func test_handleAction_add_location_tapped() {
        // Given
        presetSuccessfulSetUp()
        setUpSut()

        // When
        sut.handleAction(.addLocation)

        // Then
        XCTAssertTrue(sut.showAddLocation)
    }

    func test_handleAction_user_refresh() {
        // Given
        presetSuccessfulSetUp()
        setUpSut()

        // When
        sut.handleAction(.refresh)
        let expectation = expectation(description: "user_refresh")
        expectation.expectedFulfillmentCount = 2
        sut.$cityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [expectation], timeout: 3.0)

        // Then
        XCTAssertEqual(mockNetworkService.requestCallCount, 2)
        XCTAssertEqual(mockLocalDataStore.getAllDataCallCount, 2)
        XCTAssertEqual(mockLocationListViewRenderableBuilder.buildCallCount, 2)
        XCTAssertEqual(sut.cityList, ["Amsterdam", "Eindhoven", "Utrecht", "Almere"])
        XCTAssertFalse(sut.isLoading)
    }

    func test_isLoading_state_change_on_successful_load() {
        // Given
        presetSuccessfulSetUp()
        setUpSut()
        var isLoadingStateChanges: [Bool] = []

        // When
        let expectation = expectation(description: "user_refresh")
        sut.$isLoading
            .sink { state in
                isLoadingStateChanges.append(state)
            }
            .store(in: &subscriptions)

        sut.$cityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [expectation], timeout: 3.0)

        // Then
        XCTAssertEqual(isLoadingStateChanges, [false, true, false])
    }

    func test_isLoading_state_change_on_load_failed() {
        // Given
        mockNetworkService.error = NetworkError.responseUnsuccessful
        mockLocalDataStore.storedData = ["Utrecht", "Almere"]
        var isLoadingStateChanges: [Bool] = []

        // When
        setUpSut()
        let expectation = expectation(description: "initial_setup")
        sut.$isLoading
            .sink { state in
                isLoadingStateChanges.append(state)
            }
            .store(in: &subscriptions)
        sut.$cityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [expectation], timeout: 3.0)

        // Then
        XCTAssertEqual(isLoadingStateChanges, [false, true, false])
    }
}

