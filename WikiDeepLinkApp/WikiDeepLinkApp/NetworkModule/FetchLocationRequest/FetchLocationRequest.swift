//
//  FetchLocationRequest.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation

struct FetchLocationRequest: DataRequest {
    var url: String {
        let baseURL: String = "https://raw.githubusercontent.com"
        let path: String = "/abnamrocoesd/assignment-ios/main/locations.json"
        return baseURL + path
    }

    var queryItems: [String : String] { [:] }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> FetchLocationResponse? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let response = try decoder.decode(FetchLocationResponse.self, from: data)
        return response
    }
}
