//
//  URLOpener.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 21/09/2024.
//

import UIKit

/// A protocol that will open a URL in a browser.
protocol URLOpening: AnyObject {
    /// Opens the given url in a browser.
    /// - Parameter url: the url to open.
    func openUrl(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completion: ((Bool) -> Void)?
    )
}

extension URLOpening {
    func openUrl(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
        completion: ((Bool) -> Void)? = nil
    ) {
        openUrl(url, options: options, completion: completion)
    }
}

extension UIApplication: URLOpening {
    public func openUrl(
        _ url: URL,
        options: [OpenExternalURLOptionsKey : Any] = [:],
        completion: ((Bool) -> Void)? = nil
    ) {
        open(url, options: options, completionHandler: completion)
    }
}
