//
//  Entity.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a networking entity.
public protocol Entity: Codable {

}

public extension Entity {
    
    /// Returns a value of the current type, decoded from JSON data.
    /// - Parameters:
    ///     - data: The JSON data.
    /// - Throws:
    ///     A corresponding error if the data is not valid JSON or the JSON fails to decode.
    /// - Returns:
    ///     A value of the current type, decoded from the JSON data.
    static func from(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    
    /// Returns an array of the current type, decoded from JSON data.
    /// - Parameters:
    ///     - data: The JSON data.
    /// - Throws:
    ///     A corresponding error if the data is not valid JSON or the JSON fails to decode.
    /// - Returns:
    ///     An array of the current type, decoded from the JSON data.
    static func arrayFrom(data: Data) throws -> [Self] {
        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
    
}
