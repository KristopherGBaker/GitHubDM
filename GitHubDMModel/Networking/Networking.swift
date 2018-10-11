//
//  Networking.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a networking error.
public enum NetworkError: Error {
    /// Bad data.
    case badData
    
    /// Bad response.
    case badResponse
    
    /// Bad URL.
    case badURL
    
    /// JSON decoding error.
    case jsonDecode(Error)
    
    /// HTTP status error.
    case status(Int)
    
    /// URLSession error.
    case urlSession(Error)
}

/// A type that supports requesting and sending data across the network.
public protocol Networking {
    
    /// Initializes a `Networking` type with the specified `URLSessionConfiguration`.
    /// - Parameters:
    ///     - configuration: The `URLSessionConfiguration` to use.
    init(configuration: URLSessionConfiguration)
    
    /// Requests data based on the given URLRequest and parameters.
    ///
    /// - Parameters:
    ///     - request: The URLRequest.
    ///     - parameters: The request parameters.
    ///     - queue: The DispatchQueue to call the failure and success closures on.
    ///     - failure: The failure/error closure.
    ///     - success: The success closure.
    func requestData(request: URLRequest,
                     parameters: [String: CustomStringConvertible],
                     queue: DispatchQueue,
                     failure: ((NetworkError) -> Void)?,
                     success: ((Data) -> Void)?)
    
    /// Requests an entity based on the given URLRequest and parameters.
    ///
    /// - Parameters:
    ///     - request: The URLRequest.
    ///     - parameters: The request parameters.
    ///     - queue: The DispatchQueue to call the failure and success closures on.
    ///     - failure: The failure/error closure.
    ///     - success: The success closure.
    func request<ResponseType: Entity>(request: URLRequest,
                                       parameters: [String: CustomStringConvertible],
                                       queue: DispatchQueue,
                                       failure: ((NetworkError) -> Void)?,
                                       success: ((ResponseType) -> Void)?)
    
    /// Requests an array of entities based on the given URLRequest and parameters.
    ///
    /// - Parameters:
    ///     - request: The URLRequest.
    ///     - parameters: The request parameters.
    ///     - queue: The DispatchQueue to call the failure and success closures on.
    ///     - failure: The failure/error closure.
    ///     - success: The success closure.
    func requestList<ResponseType: Entity>(request: URLRequest,
                                           parameters: [String: CustomStringConvertible],
                                           queue: DispatchQueue,
                                           failure: ((NetworkError) -> Void)?,
                                           success: (([ResponseType]) -> Void)?)
    
}
