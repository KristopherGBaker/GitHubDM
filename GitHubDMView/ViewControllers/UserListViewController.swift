//
//  UserListViewController.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
import GitHubDMViewModel
import UIKit

/// The UserListDelegate protocol is adopted by an object
/// that responds to user list selections.
public protocol UserListDelegate: class {
    
    /// Tells the delegate a user was selected.
    func userListSelected(user: UserViewModel)
    
}

/// Reprsents the primary view controller for the user list.
public final class UserListViewController: UITableViewController {

    /// The user list delegate.
    public weak var delegate: UserListDelegate?
    
    /// The view model.
    private let viewModel: UserListViewModel
    
    /// KVO observations.
    private var observations = [NSKeyValueObservation]()
    
    /// Initializes a `UserListViewController`.
    /// - Parameters:
    ///     - viewModel: The user list view model.
    /// - Returns:
    ///     The initialized `UserListViewController`.
    public init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewModel.colorTheme.tableBackgroundColor
        
        useEmptyBackButton()
        configureTableView()
        bindViewModel()
        viewModel.loadUsers()
    }
    
    /// Configures the table view.
    private func configureTableView() {
        // Using fixed row height of 76 to avoid scroll indicator jumps with prefetching.
        // Even if the username goes across two lines, this height works (including for iPhone SE).
        tableView.rowHeight = 76
        tableView.estimatedRowHeight = 76 
        tableView.prefetchDataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
    }
    
    /// Binds the view model.
    private func bindViewModel() {
        observations = [
            viewModel.observe(\.availableCount, options: [.new]) { [unowned self] (viewModel, change) in
                self.updateUserList()
            }
        ]
        navigationItem.title = viewModel.navigationTitle
    }
    
    /// Updates the user list by reloading any rows with new data.
    private func updateUserList() {
        guard let visibleRows = tableView.indexPathsForVisibleRows, !visibleRows.isEmpty else {
            return
        }
        
        let reloadPaths = viewModel.indexPathsToReload(visibleRows: visibleRows)
        guard !reloadPaths.isEmpty else {
            return
        }
        
        tableView.reloadRows(at: reloadPaths, with: .fade)
    }

}

/// TableView methods.
extension UserListViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalUsers
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath)
        
        guard let userCell = cell as? UserListCell else {
            return cell
        }
        
        if indexPath.row < viewModel.users.count {
            let user = viewModel.users[indexPath.row]
            userCell.configure(for: user)
        } else {
            userCell.configureForEmptyCell()
        }
        
        return userCell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.users.count else {
            return
        }
        let user = viewModel.users[indexPath.row]
        delegate?.userListSelected(user: user)
    }
}

/// Prefetching.
extension UserListViewController: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastRow = indexPaths.last?.row, lastRow >= viewModel.availableCount else {
            return
        }
        
        viewModel.loadUsers()
    }
    
}
