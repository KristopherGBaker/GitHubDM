//
//  MessageInputViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Represents the message input view model.
public final class MessageInputViewModel {
    
    /// The post button title.
    public let postTitle: String
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// Initializes a `MessageInputViewModel`.
    /// - Parameters:
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `MessageInputViewModel`.
    public init(colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
        postTitle = NSLocalizedString("Post", comment: "")
    }

}
