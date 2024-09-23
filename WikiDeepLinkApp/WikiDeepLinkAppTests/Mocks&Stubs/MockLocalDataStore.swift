//
//  MockLocalDataStore.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
@testable import WikiDeepLinkApp

final class MockLocalDataStore: LocalDataStoring {
    var storedData: [String] = []
    var getAllDataCallCount: Int = 0
    var storeCallCount: Int = 0
    var removeCallCount: Int = 0
    var resetCallCount: Int = 0

    func getAllData() -> [String] {
        getAllDataCallCount += 1
        return storedData
    }

    func store(data: String) {
        storeCallCount += 1
        storedData.append(data)
    }

    func remove(data: String) {
        removeCallCount += 1
        storedData.removeAll { $0 == data }
    }

    func reset() {
        resetCallCount += 1
        storedData.removeAll()
    }
}
