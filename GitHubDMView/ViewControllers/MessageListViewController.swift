//
//  MessageListViewController.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// Represents the message list as a table view controller.
public class MessageListViewController: UITableViewController {
    
    /// KVO observations.
    private var observations = [NSKeyValueObservation]()
    
    /// The view model.
    private let viewModel: MessageListViewModel

    /// Initializes a `MessageListViewController`.
    /// - Parameters:
    ///     - viewModel: The view model.
    /// - Returns:
    ///     The initialized `MessageListViewController`.
    public init(viewModel: MessageListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        bindViewModel()
    }

    /// Configures the table view.
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
    }
    
    /// Binds the view model.
    private func bindViewModel() {
        observations = [
            viewModel.observe(\.availableCount, options: [.new]) {
                [unowned self] (messageList, change) in
                self.updateMessages()
            }
        ]
    }
    
    /// Scrolls to the last message.
    public func scrollToBottom() {
        guard !viewModel.isEmpty else {
            return
        }
        
        let indexPath = IndexPath(row: viewModel.availableCount - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    /// Inserts new rows into the table view.
    private func updateMessages() {
        let insertPaths = viewModel.indexPathsToInsert()
        guard !insertPaths.isEmpty else {
            return
        }
        
        tableView.insertRows(at: insertPaths, with: .fade)
        scrollToBottom()
    }
    
}

extension MessageListViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableCount
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath)
        
        guard let messageCell = cell as? MessageCell else {
            return cell
        }
        
        if indexPath.row < viewModel.availableCount {        
            let message = viewModel.messages[indexPath.row]
            messageCell.configure(for: message)
        }
        
        return messageCell
    }
}
