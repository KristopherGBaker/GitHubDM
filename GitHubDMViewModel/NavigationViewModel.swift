//
//  NavigationViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// Represents the navigation view model.
public final class NavigationViewModel {

    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// Initializes a `NavigationViewModel`.
    /// - Parameters:
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `NavigationViewModel`.
    public init(colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
    }
    
}
