//
//  ConversationViewModel.swift
//  GitHubDMViewModel
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation
import GitHubDMModel

/// Represents the conversation view model.
public final class ConversationViewModel {
    
    /// The API client.
    private let client: APIClient
    
    /// The persistence store.
    private let persistence: Persisting
    
    /// The message list view model.
    public let messageList: MessageListViewModel
    
    /// The user view model.
    public let user: UserViewModel
    
    /// The navigation title.
    public let navigationTitle: String
    
    /// The message input view model.
    public let messageInputViewModel: MessageInputViewModel
    
    /// The color theme.
    public let colorTheme: ColorTheme
    
    /// Initializes a `ConversationViewModel`.
    /// - Parameters:
    ///     - client: The API client.
    ///     - persistence: The persistence store.
    ///     - userViewModel: The user view model.
    ///     - colorTheme: The color theme.
    /// - Returns:
    ///     The initialized `ConversationViewModel`.
    public init(client: APIClient, persistence: Persisting,
                userViewModel: UserViewModel,
                colorTheme: ColorTheme) {
        self.client = client
        self.persistence = persistence
        self.colorTheme = colorTheme
        user = userViewModel
        messageList = MessageListViewModel(colorTheme: colorTheme)
        navigationTitle = user.username
        messageInputViewModel = MessageInputViewModel(colorTheme: colorTheme)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(messageReceived(_:)),
                                               name: Message.messageReceived,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Loads existing messages from the persistence store.
    public func loadMessages() {
        let theme = colorTheme
        persistence.loadMessages(for: user.userId, failure: nil, success: {
            [messageList] messages in
            let mappedMessages = messages.map { MessageViewModel(message: $0, colorTheme: theme) }
            messageList.appendMessages(mappedMessages)
        })
    }
    
    /// Called when a message received notification is observed.
    /// Appends the reeived message to the message list.
    @objc func messageReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let message = userInfo[Message.messageKey] as? Message,
            message.fromUserId == user.userId else {
            return
        }
        
        messageList.append(MessageViewModel(message: message, colorTheme: colorTheme))
    }
    
    /// Sends a message to the current user in the conversation.
    /// The message is also saved in the persistence store.
    /// - Parameters:
    ///     - text: The message text.
    public func sendMessage(with text: String) {
        guard !text.isEmpty else {
            return
        }
        
        let message = Message(createdAt: Date(),
                              fromUserId: 0,
                              toUserId: user.userId,
                              text: text,
                              messageType: .sent)
        
        messageList.append(MessageViewModel(message: message, colorTheme: colorTheme))
        client.send(message: message, failure: nil, success: nil)
        persistence.saveMessage(message, complete: nil)
    }

}
