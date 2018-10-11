//
//  MessagesNavigationController.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// Represents the primary navigation controller for GitHubDMView.
public final class MessagesNavigationController: UINavigationController {
    
    /// The view model.
    private let viewModel: NavigationViewModel
    
    /// Initializes a `MessagesNavigationController`.
    /// - Parameters:
    ///     - viewModel: The view model.
    /// - Returns:
    ///     The initialized `MessagesNavigationController`.
    public init(viewModel: NavigationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = viewModel.colorTheme.viewControllerBackgroundColor
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: viewModel.colorTheme.primaryTextColor]
    }

}
