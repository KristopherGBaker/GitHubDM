//
//  PersistenceTestCase.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

@testable import GitHubDMModel
import XCTest

class PersistenceTestCase: XCTestCase {
    
    private var persistence: Persisting?
    
    override func setUp() {
        super.setUp()
        persistence = Persistence()
    }
    
    func testDeleteAllMessages() {
        let expect = XCTestExpectation(description: "Delete all messages")
        
        persistence?.deleteAllMessages(failure: {
            error in
            XCTFail(error.localizedDescription)
            expect.fulfill()
        }, success: {
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
    func testSaveMessage() {
        let expect = XCTestExpectation(description: "Save message")
        let message = Message(createdAt: Date(),
                              fromUserId: 1,
                              toUserId: 2,
                              text: "test",
                              messageType: .sent)
        
        persistence?.saveMessage(message, complete: {
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
    func testLoadMessages() {
        let expect = XCTestExpectation(description: "Load messages")
        let message = Message(createdAt: Date(),
                              fromUserId: 1,
                              toUserId: 2,
                              text: "test",
                              messageType: .sent)
        
        persistence?.saveMessage(message, complete: {
            [persistence] in
            persistence?.loadMessages(for: 1, failure: { error in
                XCTFail(error.localizedDescription)
                expect.fulfill()
            }, success: { messages in
                XCTAssertTrue(!messages.isEmpty)
                expect.fulfill()
            })
        })
        
        wait(for: [expect], timeout: 10)
    }
    
}
