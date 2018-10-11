//
//  ConversationViewModelTestCase.swift
//  GitHubDMViewModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
@testable import GitHubDMViewModel
import XCTest

class ConversationViewModelTestCase: XCTestCase {
    class MemoryPersistence: Persisting {
        func save() {
            
        }
        func saveMessage(_ message: Message, complete: (() -> Void)?) {
            
        }
        func loadMessages(for userId: Int64, failure: ((Error) -> Void)?, success: (([Message]) -> Void)?) {
            DispatchQueue.main.async {
                success?([
                    Message(createdAt: Date(), fromUserId: 1, toUserId: 2, text: "Hello!", messageType: .sent),
                    Message(createdAt: Date(), fromUserId: 2, toUserId: 1, text: "Hello! Hello!", messageType: .received)
                ])
            }
        }
        func deleteAllMessages(failure: ((Error) -> Void)?, success: (() -> Void)?) {
            
        }
    }
    
    
    private let user = GitHubUser(userId: 1,
                                  username: "mojombo",
                                  avatarURL: URL(string: "https://avatars0.githubusercontent.com/u/1?v=4")!,
                                  htmlURL: URL(string: "https://github.com/mojombo")!)
    private let cache = SimpleImageCache(network: Network())
    private let theme = LightTheme()
    private let persistence = MemoryPersistence()
    private var observations = [NSKeyValueObservation]()
    private let client = MockAPIClient()
    private lazy var userViewModel = {
        return UserViewModel(user: user,
                             imageCache: SimpleImageCache(network: Network()),
                             colorTheme: theme)
    }()
    private lazy var viewModel = {
        return ConversationViewModel(client: client,
                                     persistence: persistence,
                                     userViewModel: userViewModel,
                                     colorTheme: theme)
    }()
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testLoadMessages() {
        let client = MockAPIClient()
        let userViewModel = UserViewModel(user: user,
                                          imageCache: SimpleImageCache(network: Network()),
                                          colorTheme: theme)
        let viewModel = ConversationViewModel(client: client,
                                              persistence: persistence,
                                              userViewModel: userViewModel,
                                              colorTheme: theme)
        
        let expect = XCTestExpectation(description: "Load Messages")
        
        observations = [
            viewModel.messageList.observe(\.availableCount, options: [.new]) {
                (viewModel, change) in
                expect.fulfill()
            }
        ]
        viewModel.loadMessages()
        
        wait(for: [expect], timeout: 10)
    }
    
    func testIndexPathsToInsert() {
        let expect = XCTestExpectation(description: "Index Paths to Insert")
        
        observations = [
            viewModel.messageList.observe(\.availableCount, options: [.new]) {
                (viewModel, change) in
                let insertPaths = viewModel.indexPathsToInsert()
                XCTAssert(!insertPaths.isEmpty)
                expect.fulfill()
            }
        ]
        viewModel.loadMessages()
        
        wait(for: [expect], timeout: 10)
    }
    
    func testSendMessage() {
        let expect = XCTestExpectation(description: "Send Message")
        
        observations = [
            viewModel.messageList.observe(\.availableCount, options: [.new]) {
                (viewModel, change) in
                expect.fulfill()
            }
        ]
        viewModel.sendMessage(with: "Hello!")
        
        wait(for: [expect], timeout: 10)
    }
    
}
