//
//  FetchLocationResponse.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation

struct FetchLocationResponse: Codable {
    let locations: [Location]
}

struct Location: Codable {
    let name: String?
    let lat: Double?
    let long: Double?
}
