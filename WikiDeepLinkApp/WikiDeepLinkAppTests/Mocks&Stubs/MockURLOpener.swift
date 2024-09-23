//
//  MockURLOpener.swift
//  WikiDeepLinkAppTests
//
//  Created by Deepak Panigrahi on 22/09/2024.
//

import Foundation
import UIKit
@testable import WikiDeepLinkApp

final class MockURLOpener: URLOpening {
    var openedURL: URL?
    var shouldOpenSuccessfully = true // Simulates whether the URL should open successfully or not
    var openUrlCallCount: Int = 0

    func openUrl(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any],
        completion: ((Bool) -> Void)?
    ) {
        openUrlCallCount += 1
        openedURL = url
        completion?(shouldOpenSuccessfully)
    }
}
