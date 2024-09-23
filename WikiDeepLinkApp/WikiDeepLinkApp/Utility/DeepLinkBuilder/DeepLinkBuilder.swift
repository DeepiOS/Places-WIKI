//
//  DeepLinkBuilder.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation

/// A protocol that will build a place into a WIKI deeplink
protocol DeepLinkBuilding {
    func build(placeholder: String) -> URL?
}

final class WikiDeepLinkBuilder: DeepLinkBuilding {
    private let urlFormate = "wikipedia://places?WMFLocationName=%@"

    func build(placeholder: String) -> URL? {
        guard !placeholder.isEmpty else { return nil }
        let deeplinkURLString = String(format: urlFormate, arguments: [placeholder])
        guard let deeplinkURL = URL(string: deeplinkURLString) else {
            return nil
        }
        return deeplinkURL
    }
}
