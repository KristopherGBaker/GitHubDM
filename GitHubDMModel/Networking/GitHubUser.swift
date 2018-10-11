//
//  GitHubUser.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a GitHub user.
public struct GitHubUser: Entity {

    /// The user's avatar URL.
    public let avatarURL: URL
    
    /// The user's HTML URL.
    public let htmlURL: URL
    
    /// The user id.
    public let userId: Int64
    
    /// The username.
    public let username: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case userId = "id"
        case username = "login"
    }
    
    /// Initializes a GitHub user.
    /// - Parameters:
    ///     - userId: The user id.
    ///     - username: The username.
    ///     - avatarURL: The avatar URL.
    ///     - htmlURL: The HTML URL.
    /// - Returns:
    ///     The initialized user.
    public init(userId: Int64, username: String, avatarURL: URL, htmlURL: URL) {
        self.userId = userId
        self.username = username
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
    }
    
}
