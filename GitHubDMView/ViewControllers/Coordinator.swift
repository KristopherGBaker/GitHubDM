//
//  Coordinator.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
import GitHubDMViewModel
import SafariServices
import UIKit

/// The `Coordinator` coordinates the view controllers within `GitHubDMView`.
/// `Coordinator` itself is a container view controller that contains
/// a navigation controller as its only direct child view controller.
public final class Coordinator: UIViewController {
    /// The root navigation controller.
    private let navController: MessagesNavigationController
    
    /// The API client.
    private let client: APIClient
    
    /// The image cache.
    private let imageCache: ImageCache
    
    /// The persistence store.
    private let persistence: Persisting
    
    /// The color theme.
    private let colorTheme: ColorTheme
    
    /// Initializes a `Coordinator` with the specified dependencies.
    /// - Parameters:
    ///     - client: The API client.
    ///     - imageCache: The image cache.
    ///     - persistence: The persistence store.
    /// - Returns:
    ///     An initalized `Coordinator`.
    public init(client: APIClient, imageCache: ImageCache, persistence: Persisting, colorTheme: ColorTheme) {
        self.client = client
        self.imageCache = imageCache
        self.persistence = persistence
        self.colorTheme = colorTheme
        navController = MessagesNavigationController(viewModel: NavigationViewModel(colorTheme: colorTheme))
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(viewController: navController)
        addUserList()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(messageReceived(_:)),
                                               name: Message.messageReceived,
                                               object: nil)
    }
    
    /// Called when a message received notification is observed.
    /// Saves the message in the persistence store.
    @objc func messageReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let message = userInfo[Message.messageKey] as? Message else {
                return
        }
        
        persistence.saveMessage(message, complete: nil)
    }
    
    /// Adds the user list to the navigation controller.
    private func addUserList() {
        let viewModel = UserListViewModel(client: client, imageCache: imageCache, colorTheme: colorTheme)
        viewModel.delegate = self
        let userListViewController = UserListViewController(viewModel: viewModel)
        userListViewController.delegate = self
        navController.setViewControllers([userListViewController], animated: false)
    }
    
    /// Saves the data in the persistent store.
    public func save() {
        persistence.save()
    }
    
}

extension Coordinator: UserListViewModelDelegate {
    public func userListGetUsersError(_ error: Error, viewModel: UserListViewModel) {
        let alert = UIAlertController(title: viewModel.errorTitle,
                                      message: viewModel.retryMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.cancelTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: viewModel.retryTitle, style: .default) { _ in
            viewModel.loadUsers()
        })
        present(alert, animated: true, completion: nil)
    }
}

extension Coordinator: UserListDelegate {
    public func userListSelected(user: UserViewModel) {
        let viewModel = ConversationViewModel(client: client,
                                              persistence: persistence,
                                              userViewModel: user,
                                              colorTheme: colorTheme)
        let conversationViewController = ConversationViewController(viewModel: viewModel)
        conversationViewController.delegate = self
        navController.pushViewController(conversationViewController, animated: true)
    }
}

extension Coordinator: ConversationDelegate {
    public func conversationUserInfoTouched(user: UserViewModel) {
        let safariViewController = SFSafariViewController(url: user.htmlURL)
        navController.present(safariViewController, animated: true, completion: nil)
    }
}
