//
//  ImageCache.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Represents an image cache error.
public enum ImageCacheError: Error {
    /// Bad image data.
    case badData
    
    /// Network error.
    case networkError(NetworkError)
}

/// The `ImageCache` protocol is adopted by an object that
/// provides an image cache.
public protocol ImageCache {

    /// Gets the image for the specified `URL`.
    /// If the image is cached, the cached image will be used.
    /// Otherwise an attempt to load the image from the network will be made.
    /// - Parameters:
    ///     - url: The `URL` for the image.
    ///     - failure: The closure to call when an error occurs.
    ///     - success: The closure to call when the image has been loaded.
    func getImage(url: URL, failure: ((ImageCacheError) -> Void)?, success: ((UIImage) -> Void)?) -> Operation?
    
}
