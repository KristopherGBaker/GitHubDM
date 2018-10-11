//
//  APIClient.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// A type that supports retrieving users and sending messages.
public protocol APIClient {

    /// Gets the next page of users starting after the `since` value.
    /// - Parameters:
    ///     - since: The last user id of the previous page.
    ///     - failure: The closure to call when an error occurs.
    ///     - success: The closture to call when the next page of users has been retrieved.
    func getUsers(since: Int64,
                  failure: ((NetworkError) -> Void)?,
                  success: (([GitHubUser]) -> Void)?)
    
    /// Sends a message.
    /// - Parameters:
    ///     - message: The message to send.
    ///     - failure: The closure to call when an error occurs.
    ///     - success: The closture to call when the message has been succesfully sent.
    func send(message: Message,
              failure: ((NetworkError) -> Void)?,
              success: ((EmptyResponse) -> Void)?)
    
}
