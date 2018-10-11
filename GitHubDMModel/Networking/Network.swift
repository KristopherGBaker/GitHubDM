//
//  Network.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// Provides a simple URLSession based implementation of the Networking protocol.
/// We could swap this out for Alamofire later if desired.
public final class Network: Networking {
    
    /// Defines the good HTTP status code range.
    private static let goodStatusCode = 200..<300
    
    /// The queue to use for entity requests.
    private let entityQueue = DispatchQueue(label: "com.githubdm.Network.entityQueue")
    
    /// The `URLSession` used for data tasks.
    private let urlSession: URLSession
    
    /// Initializes a `Network` with the default shared `URLSession`.
    /// - Returns:
    ///     The initialized `Network`.
    public init() {
        urlSession = URLSession.shared
    }
    
    /// Initializes a `Network` with the specified `URLSessionConfiguration`.
    /// - Parameters:
    ///     - configuration: The `URLSessionConfiguration` to use with the `URLSession`.
    /// - Returns:
    ///     The initialized `Network`.
    public init(configuration: URLSessionConfiguration) {
        urlSession = URLSession(configuration: configuration)
    }

    public func requestData(request: URLRequest,
                            parameters: [String: CustomStringConvertible],
                            queue: DispatchQueue,
                            failure: ((NetworkError) -> Void)?,
                            success: ((Data) -> Void)?) {
        let task = urlSession.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                queue.async {
                    failure?(.urlSession(error))
                }
            }
            guard let response = response as? HTTPURLResponse else {
                queue.async {
                    failure?(.badResponse)
                }
                return
            }
            guard Network.goodStatusCode.contains(response.statusCode) else {
                queue.async {
                    failure?(.status(response.statusCode))
                }
                return
            }
            guard let data = data else {
                queue.async {
                    failure?(.badData)
                }
                return
            }
            queue.async {
                success?(data)
            }
        }
        task.resume()
    }
    
    public func request<ResponseType: Entity>(request: URLRequest,
                                              parameters: [String: CustomStringConvertible],
                                              queue: DispatchQueue,
                                              failure: ((NetworkError) -> Void)?,
                                              success: ((ResponseType) -> Void)?) {
        requestData(request: request,
                    parameters: parameters,
                    queue: entityQueue,
                    failure: failure) {
            data in
                        
            do {
                let entity = try ResponseType.from(data: data)
                queue.async {
                    success?(entity)
                }
            } catch {
                queue.async {
                    failure?(.jsonDecode(error))
                }
            }
        }
    }
    
    public func requestList<ResponseType: Entity>(request: URLRequest,
                                                  parameters: [String: CustomStringConvertible],
                                                  queue: DispatchQueue,
                                                  failure: ((NetworkError) -> Void)?,
                                                  success: (([ResponseType]) -> Void)?) {
        requestData(request: request,
                    parameters: parameters,
                    queue: entityQueue,
                    failure: failure) {
            data in
            
            do {
                let entityArray = try ResponseType.arrayFrom(data: data)
                queue.async {
                    success?(entityArray)
                }
            } catch {
                queue.async {
                    failure?(.jsonDecode(error))
                }
            }
        }
    }
    
}
