//
//  Persisting.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// The `Persisting` protocol is adopted by an object
/// that manages message data in a persistent store.
public protocol Persisting {

    /// Saves the current data to disk.
    func save()
    
    /// Loads existing messages from the store for the given user.
    /// - Parameters:
    ///     - userId: The user id to load messages for.
    ///     - failure: The closure to call when an error occurs.
    ///     - success: The closre to call with the list of messages.
    func loadMessages(for userId: Int64,
                      failure: ((Error) -> Void)?,
                      success: (([Message]) -> Void)?)
    
    /// Saves a mssage to the store.
    /// - Parameters:
    ///     - message: The message to save.
    ///     - complete: The closure to call on save completion.
    func saveMessage(_ message: Message,
                     complete: (() -> Void)?)
    
    /// Deletes all messages from the store.
    /// - Parameters:
    ///     - failure: The closure to call when an error occurs.
    ///     - success: The closre to call when the delete completes successfully.
    func deleteAllMessages(failure: ((Error) -> Void)?,
                           success: (() -> Void)?)
    
}
