//
//  LocalDataStorage.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 21/09/2024.
//

import Foundation

/// A protocol that does local storage operations
protocol LocalDataStoring {
    func getAllData() -> [String]
    func store(data: String)
    func remove(data: String)
    func reset()
}

final class LocalDataStorage: LocalDataStoring {
    private let storageName: String

    init(storageName: String = "WikiDeepLinkLocalStorage") {
        self.storageName = storageName
    }

    func getAllData() -> [String] {
        guard let fileURL = getPlistPath(storageName) else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            guard let savedList = try PropertyListSerialization
                .propertyList(from: data, options: [], format: nil) as? [String] else {
                return []
            }
            return savedList
        } catch {
            debugPrint("Error loading data from plist: \(error)")
            return []
        }
    }

    func store(data: String) {
        var storedData = getAllData()
        storedData.append(data)
        saveToStorage(storedData)
    }
    
    func remove(data: String) {
        var storedData = getAllData()
        storedData.append(data)
        saveToStorage(storedData)
    }
    
    func reset() {
        saveToStorage([])
    }
}

// MARK: - Private

private extension LocalDataStorage {
    // Get the path to the .plist file in the Documents directory
    func getPlistPath(_ name: String) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(name).plist")
    }

    // Write to plist
    func saveToStorage(_ data: [String]) {
        guard let fileURL = getPlistPath(storageName) else { return }
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try data.write(to: fileURL)
            debugPrint("Data saved successfully to \(fileURL)")
        } catch {
            debugPrint("Error saving data to plist: \(error)")
        }
    }
}
