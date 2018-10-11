//
//  UIViewController+EmptyBackButton.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

internal extension UIViewController {
    
    /// Sets the back button title to " " so the back button title is empty on the next screen.
    internal func useEmptyBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
}
