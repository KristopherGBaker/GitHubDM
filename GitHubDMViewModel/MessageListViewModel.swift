//
//  MessageListViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation
import GitHubDMModel

/// Represents the message list view model.
@objcMembers
public final class MessageListViewModel: NSObject {
    
    /// The list of messages.
    public private (set) var messages = [MessageViewModel]()
    
    /// The loaded row set.
    public private (set) var loadedRowSet = Set<Int>()
    
    /// The new row set.
    private var newRowSet = Set<Int>()
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// The available message count.
    dynamic public private (set) var availableCount = 0
    
    /// Returns true if the message list is empty, false otherwise.
    public var isEmpty: Bool {
        return messages.isEmpty
    }
    
    /// Initializes a `MessageListViewModel`.
    /// - Parameters:
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `MessageListViewModel`.
    public init(colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
        super.init()
    }
    
    /// Appends a new message to the message list.
    /// - Parameters:
    ///     - message: The new message.
    public func append(_ message: MessageViewModel) {
        newRowSet.insert(messages.count)
        messages.append(message)
        availableCount = messages.count
    }
    
    /// Appends new messages to the message list.
    /// - Parameters:
    ///     - newMessages: The new messages.
    public func appendMessages(_ newMessages: [MessageViewModel]) {
        guard !newMessages.isEmpty else {
            return
        }
        
        var row = messages.count
        
        for _ in newMessages {
            newRowSet.insert(row)
            row += 1
        }
        
        messages.append(contentsOf: newMessages)
        availableCount = messages.count
    }
    
    /// Gets the index paths to insert. Only rows not already inserted will be included.
    /// Calling this method also updates the loaded set to include any new rows.
    /// - Returns:
    ///     The index paths to reload.
    public func indexPathsToInsert() -> [IndexPath] {
        newRowSet.subtract(loadedRowSet)
        guard !newRowSet.isEmpty else {
            return []
        }
        
        loadedRowSet.formUnion(newRowSet)
        return newRowSet.map { IndexPath(row: $0, section: 0) }
    }
    
}
