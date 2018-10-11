//
//  SimpleImageCache.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Represents a simple image cache that relies on `URLCache` for the caching.
/// This should be replaced later on with something more robust,
/// perhaps something like `PINRemoteImage`, `SDWebImage`, or `AlamofireImage`.
public final class SimpleImageCache: ImageCache {
    
    /// The networking provider.
    private let network: Networking
    
    /// Initializes a `SimpleImageCache`.
    /// - Parameters:
    ///     - network: The networking provider to use for downloading images.
    /// - Returns:
    ///     An initialized `SimpleImageCache`.
    public init(network: Networking) {
        self.network = network
    }
    
    /// The default configuration's memory capacity (20 MB).
    public static let defaultMemoryCapacity = 1024*1024*20
    
    /// The default configuration's disk capacity (150 MB).
    public static let defaultDiskCapacity = 1024*1024*150
    
    /// Returns a default `URLSessionConfiguration` for caching.
    public static var defaultSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: defaultMemoryCapacity,
                                          diskCapacity: defaultDiskCapacity,
                                          diskPath: "GitHubDMSimpleImageCache")
        return configuration
    }
    
    public func getImage(url: URL,
                         failure: ((ImageCacheError) -> Void)?,
                         success: ((UIImage) -> Void)?) -> Operation? {
        let request = URLRequest(url: url)
        
        network.requestData(request: request, parameters: [:], queue: .main, failure: { error in
            DispatchQueue.main.async {
                failure?(.networkError(error))
            }
        }, success: { data in
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure?(.badData)
                }
                return
            }
            DispatchQueue.main.async {
                success?(image)
            }
        })
        
        return nil
    }

}

private class GetImageOperation: Operation {
    
}
