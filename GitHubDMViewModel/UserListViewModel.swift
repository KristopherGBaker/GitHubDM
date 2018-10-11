//
//  UserListViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation
import GitHubDMModel

/// The UserListViewModelDelegate protocol is adopted by an object
/// that responds to user list errors.
public protocol UserListViewModelDelegate: class {
    
    /// Informs the delegate of an error in getting users.
    /// - Parameters:
    ///     - error: The error.
    ///     - viewModel: The `UserListViewModel` the error occured in.
    func userListGetUsersError(_ error: Error, viewModel: UserListViewModel)
    
}

/// Represents the user list view model.
@objcMembers
public class UserListViewModel: NSObject {
    
    /// The delegate.
    public weak var delegate: UserListViewModelDelegate?
    
    /// The API client.
    private let client: APIClient
    
    /// The list of users.
    public private (set) var users = [UserViewModel]()
    
    /// The loaded rows.
    private var loadedRowSet = Set<Int>()
    
    /// The available users count.
    dynamic public private (set) var availableCount: Int = 0
    
    /// The navigation title.
    public let navigationTitle: String
    
    /// Paging parameter for client.GetUsers.
    private var since: Int64 = 0
    
    /// The total number of users in the list, hardcoding this number for now.
    public private (set) var totalUsers = 1000
    
    /// Indicates if there is a client request for users.
    private var isLoading = false
    
    /// Returns true if the users list is empty, false otherwise.
    public var isEmpty: Bool {
        return users.isEmpty
    }
    
    /// The image cache.
    public let imageCache: ImageCache
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// The get users error title.
    public let errorTitle: String
    
    /// The retry message.
    public let retryMessage: String
    
    /// The retry button title.
    public let retryTitle: String
    
    /// The cancel button title.
    public let cancelTitle: String

    /// Initializes a `UserListViewModel`.
    /// - Parameters:
    ///     - client: The API client.
    ///     - imageCache: The image cache.
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `UserListViewModel`.
    public init(client: APIClient, imageCache: ImageCache, colorTheme: ColorTheme) {
        self.client = client
        self.imageCache = imageCache
        self.colorTheme = colorTheme
        navigationTitle = NSLocalizedString("GitHub DM", comment: "")
        errorTitle = NSLocalizedString("Error", comment: "")
        retryMessage = NSLocalizedString("Error loading data.\nWould you like to retry?", comment: "")
        retryTitle = NSLocalizedString("Retry", comment: "")
        cancelTitle = NSLocalizedString("Cancel", comment: "")
        super.init()
    }
    
    /// Loads the next page of users.
    public func loadUsers() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        client.getUsers(since: since, failure: {
            [weak self] error in
            guard let `self` = self else {
                return
            }

            self.isLoading = false
            self.delegate?.userListGetUsersError(error, viewModel: self)
        }, success: {
            [weak self] gitHubUsers in
            guard let `self` = self else {
                return
            }

            self.isLoading = false
            self.since = (gitHubUsers.last?.userId ?? 0) + 1
            let mappedUsers = gitHubUsers.map { UserViewModel(user: $0, imageCache: self.imageCache, colorTheme: self.colorTheme) }
            self.users.append(contentsOf: mappedUsers)
            self.availableCount = self.users.count
        })
    }
    
    /// Gets the index paths to reload. Only rows not already loaded will be included.
    /// Calling this method also updates the loaded set to include any new rows.
    /// - Parameters:
    ///     - visibleRows: The current visible rows.
    /// - Returns:
    ///     The index paths to reload.
    public func indexPathsToReload(visibleRows: [IndexPath]) -> [IndexPath] {
        let visibleSet = Set<Int>(visibleRows.map { $0.row }).subtracting(loadedRowSet)
        guard !visibleSet.isEmpty else {
            return []
        }
        
        loadedRowSet.formUnion(visibleSet)
        return visibleSet.map { IndexPath(row: $0, section: 0) }
    }
    
    
}
