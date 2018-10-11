//
//  ColorTheme.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Represents the color theme.
public protocol ColorTheme {
    
    /// The primary text color.
    var primaryTextColor: UIColor { get }
    
    /// The message text color.
    var messageTextColor: UIColor { get }
    
    /// The table background color.
    var tableBackgroundColor: UIColor { get }
    
    /// The view controller background color.
    var viewControllerBackgroundColor: UIColor { get }

    /// The right chat bubble background color.
    var rightBubbleBackgroundColor: UIColor { get }
    
    /// The left chat bubble background color.
    var leftBubbleBackgroundColor: UIColor { get }
    
    /// The window background color.
    var windowBackgroundColor: UIColor { get }
    
    /// The post button title color.
    var postTitleColor: UIColor { get }
    
}
