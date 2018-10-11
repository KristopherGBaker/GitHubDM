//
//  UserListViewModelTestCase.swift
//  GitHubDMViewModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
@testable import GitHubDMViewModel
import XCTest

class UserListViewModelTestCase: XCTestCase {
    
    var expect: XCTestExpectation?
    
    class BadNetwork: Networking {
        
        init() {
            
        }
        
        required init(configuration: URLSessionConfiguration) {
            
        }
        
        func requestData(request: URLRequest,
                         parameters: [String: CustomStringConvertible],
                         queue: DispatchQueue,
                         failure: ((NetworkError) -> Void)?,
                         success: ((Data) -> Void)?) {
        }
        
        func request<ResponseType: Entity>(request: URLRequest,
                                           parameters: [String: CustomStringConvertible],
                                           queue: DispatchQueue,
                                           failure: ((NetworkError) -> Void)?,
                                           success: ((ResponseType) -> Void)?) {
        }
        
        func requestList<ResponseType: Entity>(request: URLRequest,
                                               parameters: [String: CustomStringConvertible],
                                               queue: DispatchQueue,
                                               failure: ((NetworkError) -> Void)?,
                                               success: (([ResponseType]) -> Void)?) {
            DispatchQueue.main.async {
                failure?(.badData)
            }
        }
    }
    
    private var observations = [NSKeyValueObservation]()
    private let cache = SimpleImageCache(network: Network())
    private let theme = LightTheme()
    
    func testLoadUsers() {
        let client = MockAPIClient()
        let viewModel = UserListViewModel(client: client, imageCache: cache, colorTheme: theme)
        
        let expect = XCTestExpectation(description: "Updates Available Count")
        
        observations = [
            viewModel.observe(\.availableCount, options: [.new]) {
                (viewModel, change) in
                expect.fulfill()
            }
        ]
        viewModel.loadUsers()
        
        wait(for: [expect], timeout: 10)
    }
    
    func testBadNetworkDelegatesError() {
        let client = GitHubAPIClient(network: BadNetwork())
        let viewModel = UserListViewModel(client: client, imageCache: cache, colorTheme: theme)
        viewModel.delegate = self
        
        let expect = XCTestExpectation(description: "Bad Network Error")
        self.expect = expect
        viewModel.loadUsers()
        
        wait(for: [expect], timeout: 10)
    }
    
    func testIndexPathsToReload() {
        let client = MockAPIClient()
        let viewModel = UserListViewModel(client: client, imageCache: cache, colorTheme: theme)
        let visibleRows = (0...10).map { IndexPath(row: $0, section: 0) }
        
        let expect = XCTestExpectation(description: "Index Paths to Reload")
        
        observations = [
            viewModel.observe(\.availableCount, options: [.new]) {
                (viewModel, change) in
                let reloadPaths = viewModel.indexPathsToReload(visibleRows: visibleRows)
                XCTAssert(!reloadPaths.isEmpty)
                expect.fulfill()
            }
        ]
        viewModel.loadUsers()
        
        wait(for: [expect], timeout: 10)
    }
    
}

extension UserListViewModelTestCase: UserListViewModelDelegate {
    func userListGetUsersError(_ error: Error, viewModel: UserListViewModel) {
        expect?.fulfill()
    }
}
