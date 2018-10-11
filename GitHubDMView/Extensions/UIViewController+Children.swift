//
//  UIViewController+Children.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

internal extension UIViewController {
    
    /// Adds the specified view controller as a child
    /// of the current view controller.
    /// - Parameters:
    ///     - viewController: The child view controller.
    internal func addChild(viewController: UIViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}
