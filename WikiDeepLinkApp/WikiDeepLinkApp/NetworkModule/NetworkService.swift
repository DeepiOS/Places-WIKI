//
//  NetworkService.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import Foundation

/// Protocol responsible to do a network request
protocol AsyncNetworkServicing {
    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response
}

/// Protocol to use a URLSession for network service
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

enum NetworkError: Error {
    case invalidEndpoint
    case responseUnsuccessful
    case badRequest
    case notFound
    case unknownError
    case dataParsingError
}

final class DefaultNetworkService: AsyncNetworkServicing {

    // Injecting the URLSession dependency via initializer
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response {
        guard var urlComponent = URLComponents(string: request.url) else {
            throw NetworkError.invalidEndpoint
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            throw NetworkError.invalidEndpoint
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.responseUnsuccessful }
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let responseObject = try request.decode(data)
                return responseObject
            } catch {
                throw NetworkError.dataParsingError
            }
        case 400...499:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.badRequest
        default:
            throw NetworkError.unknownError
        }
    }
}
