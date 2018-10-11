//
//  DataLoader.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// The DataLoader class provides simple utility methods
/// for loading data from a bundle.
public final class DataLoader {
    
    /// Loads JSON data from the specified bundle.
    /// - Parameters:
    ///     - bundle: The bundle to load from.
    ///     - resource: The resource (filename) to load.
    /// - Returns:
    ///     The JSON data if it could be loaded, nil otherwise.
    public static func loadJSONData(in bundle: Bundle, for resource: String) -> Data? {
        return loadData(in: bundle, for: resource, with: "json")
    }

    /// Loads data from the specified bundle.
    /// - Parameters:
    ///     - bundle: The bundle to load from.
    ///     - resource: The resource (filename) to load.
    /// - Returns:
    ///     The data if it could be loaded, nil otherwise.
    public static func loadData(in bundle: Bundle, for resource: String, with ext: String) -> Data? {
        guard let url = bundle.url(forResource: resource, withExtension: ext),
            let data = try? Data(contentsOf: url) else {
                return nil
        }
        return data
    }
    
}
