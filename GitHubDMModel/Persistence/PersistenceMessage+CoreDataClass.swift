//
//  PersistenceMessage+CoreDataClass.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//
//

import Foundation
import CoreData

/// Core Data generated class for `PersistenceMessage`.
internal class PersistenceMessage: NSManagedObject {

}

extension PersistenceMessage {
    
    /// Converts the current `PersistenceMessage` to a `Message`.
    /// - Returns:
    ///     A `Message` representing the `PersistenceMessage`.
    func convertToMessage() -> Message {
        let message = Message(
            createdAt: (createdAt as Date?) ?? Date(),
            fromUserId: fromUserId,
            toUserId: toUserId,
            text: text ?? "",
            messageType: Message.MessageType(rawValue: messageType ?? "received") ?? .received
        )
        return message
    }
    
}
