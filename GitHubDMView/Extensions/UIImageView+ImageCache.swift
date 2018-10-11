//
//  UIImageView+ImageCache.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
import UIKit

internal extension UIImageView {
    
    /// Sets the image from specified URL.
    /// The image cache will be used if possible.
    /// - Parameters:
    ///     - url: The image URL.
    ///     - cache: The image cache.
    internal func setImage(from url: URL?, with cache: ImageCache) {
        image = nil
        
        guard let url = url else {
            return
        }
        
        cache.getImage(url: url, failure: nil) { image in
            self.image = image
        }
    }
    
}
