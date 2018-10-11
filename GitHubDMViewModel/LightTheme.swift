//
//  LightTheme.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Reprsents a light color theme.
public struct LightTheme: ColorTheme {
    
    /// Initializes a `LightTheme`.
    public init() {
        
    }
    
    public let primaryTextColor = UIColor(white: 0.14, alpha: 1.0)
    
    public let messageTextColor = UIColor.white
    
    public let tableBackgroundColor = UIColor.white
    
    public let viewControllerBackgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
    
    public let rightBubbleBackgroundColor = UIColor(red: 0.0, green: 0.47, blue: 0.91, alpha: 1.0)
    
    public let leftBubbleBackgroundColor = UIColor(white: 0.62, alpha:1.00)
    
    public let windowBackgroundColor = UIColor.white
    
    public let postTitleColor = UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)

}
