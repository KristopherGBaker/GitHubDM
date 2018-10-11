//
//  Message.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a direct message between two users.
public struct Message: Entity {
    
    /// Represents the message type (sent or received).
    public enum MessageType: String, Codable, CustomStringConvertible {
        /// Received message.
        case received
        
        /// Sent message.
        case sent
        
        public var description: String {
            return rawValue
        }
    }
    
    /// Posted when a message is received from an external sender.
    /// The userInfo dictionary contains the message as a `Message`.
    /// Use the `Message.messageKey` parameter for retrieving the message.
    public static let messageReceived = Notification.Name("GitHubDMModel.MessageReceived")
    
    /// The key for retrieving the message from a messageReceived notification.
    public static let messageKey = "GitHubDMModel.Message"
    
    /// The date the message was created.
    public let createdAt: Date
    
    /// The from user id.
    public let fromUserId: Int64
    
    /// The to user id.
    public let toUserId: Int64
    
    /// The message text.
    public let text: String
    
    /// The message type.
    public let messageType: MessageType
    
    /// Initializes a message with the specified values.
    /// - Parameters:
    ///     - createdAt: The created date.
    ///     - fromUserId: The from user id.
    ///     - toUserId: The to user id.
    ///     - text: The message text.
    ///     - messageType: The message type.
    public init(createdAt: Date,
                fromUserId: Int64,
                toUserId: Int64,
                text: String,
                messageType: MessageType) {
        self.createdAt = createdAt
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.text = text
        self.messageType = messageType
    }

}
