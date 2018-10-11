//
//  GitHubAPIClient.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// GitHubAPIClient provides a network based implementation
/// of the `APIClient` protocol.
public final class GitHubAPIClient: APIClient {
    
    /// The networking provider.
    private let network: Networking
    
    /// The URL for getting users.
    private let getUsersURL = URL(string: "https://api.github.com/users")
    
    /// Initializes a `GitHubAPIClient`.
    /// - Parameters:
    ///     - network: The networking provider.
    /// - Returns:
    ///     An initialized `GitHubAPIClient`.
    public init(network: Networking) {
        self.network = network
    }
    
    public func getUsers(since: Int64,
                         failure: ((NetworkError) -> Void)?,
                         success: (([GitHubUser]) -> Void)?) {
        guard let getUsersURL = getUsersURL,
            var components = URLComponents(url: getUsersURL, resolvingAgainstBaseURL: false) else {
            failure?(.badURL)
            return
        }
        components.queryItems = [URLQueryItem(name: "since", value: "\(since)")]
        guard let url = components.url else {
            failure?(.badURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        network.requestList(request: request,
                            parameters: [:],
                            queue: .main,
                            failure: failure,
                            success: success)
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
