//
//  MockAPIClient.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// MockAPIClient provides a mock based implementation of the `APIClient` protocol.
/// This is useful for testing. User data is loaded from a JSON file included in the bundle.
public final class MockAPIClient: APIClient {
    
    // Initializes a `MockAPIClient`.
    /// - Returns:
    ///     An initialized `MockAPIClient`.
    public init() {
        
    }
    
    public func getUsers(since: Int64,
                         failure: ((NetworkError) -> Void)?,
                         success: (([GitHubUser]) -> Void)?) {
        guard let data = DataLoader.loadJSONData(in: Bundle(for: MockAPIClient.self), for: "users-since-0"),
            let users = try? GitHubUser.arrayFrom(data: data) else {
            DispatchQueue.main.async {
                failure?(.badData)
            }
            return
        }
        
        DispatchQueue.main.async {
            success?(users)
        }
    }
    
    public func send(message: Message,
              failure: ((NetworkError) -> Void)?,
              success: ((EmptyResponse) -> Void)?) {
        // The message is not actually sent anywhere right now.
        
        // Fake reply that comes a second later.
        let reply = Message(createdAt: Date(),
                            fromUserId: message.toUserId,
                            toUserId: message.fromUserId,
                            text: "\(message.text) \(message.text)",
                            messageType: .received)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: Message.messageReceived,
                                            object: nil,
                                            userInfo: [Message.messageKey: reply])
        }
    }
    
}
