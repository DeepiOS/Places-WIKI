//
//  LocalDataStorageTests.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 23/09/2024.
//

import Foundation
import XCTest
@testable import WikiDeepLinkApp

final class LocalDataStorageTests: XCTestCase {
    private var sut: LocalDataStorage!
    private let storeName: String = "TestStore"
    
    override func setUp() {
        super.setUp()
        sut = .init(storageName: storeName)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_getAllData() {
        defer {
            sut.reset()
        }
        
        // Given
        sut.store(data: "Amsterdam")
        sut.store(data: "Eindhoven")
        
        // When
        let list = sut.getAllData()
        
        // Then
        XCTAssertEqual(list, ["Amsterdam", "Eindhoven"])
    }
    
    func test_removeData() {
        defer {
            sut.reset()
        }
        
        // Given
        sut.store(data: "Amsterdam")
        sut.store(data: "Eindhoven")
        
        // When
        sut.remove(data: "Amsterdam")
        
        // Then
        let list = sut.getAllData()
        XCTAssertEqual(list, ["Eindhoven"])
    }
}
