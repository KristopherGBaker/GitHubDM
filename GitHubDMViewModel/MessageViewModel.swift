//
//  MessageViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation
import GitHubDMModel

/// Represents the message view model.
public final class MessageViewModel {
    
    /// The message type.
    public enum MessageType {
        /// Received message type.
        case received
        /// Sent message type.
        case sent
    }
    
    /// The underlying message.
    private let message: Message

    /// Created at date.
    public var createdAt: Date {
        return message.createdAt
    }
    
    /// From user id.
    public var fromUserId: Int64 {
        return message.fromUserId
    }
    
    /// To user id.
    public var toUserId: Int64 {
        return message.toUserId
    }
    
    /// Message text.
    public var text: String {
        return message.text
    }
    
    /// The message type.
    public var messageType: MessageType {
        return message.messageType == .received ? .received : .sent
    }
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// Initializes a `MessageViewModel` with the specified message.
    /// - Parameters:
    ///     - message: The message.
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `MessageViewModel`.
    public init(message: Message, colorTheme: ColorTheme) {
        self.message = message
        self.colorTheme = colorTheme
    }
    
}
