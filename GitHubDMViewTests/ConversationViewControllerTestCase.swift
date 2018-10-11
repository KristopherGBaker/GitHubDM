//
//  ConversationViewControllerTestCase.swift
//  GitHubDMViewTests
//
//  Created by Kris Baker on 9/10/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
import GitHubDMViewModel
@testable import GitHubDMView
import XCTest

class ConversationViewControllerTestCase: XCTestCase {
    
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
    
    func testConversationViewController() {
        let expect = XCTestExpectation(description: "Index Paths to Reload")
        let viewController = ConversationViewController(viewModel: viewModel)
        XCTAssertTrue(viewModel.messageList.loadedRowSet.isEmpty)
        viewController.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [viewModel] in
            XCTAssertTrue(viewModel.messageList.loadedRowSet.count == 2)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 10)
    }
    
}
