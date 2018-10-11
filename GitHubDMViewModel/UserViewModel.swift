//
//  UserViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation
import GitHubDMModel

/// Represents the user view model.
public class UserViewModel {

    /// The user id.
    public var userId: Int64 {
        return user.userId
    }
    
    /// The username.
    public var username: String {
        return "@\(user.username)"
    }
    
    /// The avatar URL.
    public var avatarURL: URL {
        return user.avatarURL
    }
    
    /// The HTML URL.
    public var htmlURL: URL {
        return user.htmlURL
    }
    
    /// The image cache.
    public let imageCache: ImageCache
    
    /// The underlying user.
    private let user: GitHubUser
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// Initializes a `UserViewModel` with the specified user and image cache.
    /// - Parameters:
    ///     - user: The user.
    ///     - imageCache: The image cache.
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `UserViewModel`.
    public init(user: GitHubUser, imageCache: ImageCache, colorTheme: ColorTheme) {
        self.user = user
        self.imageCache = imageCache
        self.colorTheme = colorTheme
    }
    
}
