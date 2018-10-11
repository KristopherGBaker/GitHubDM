//
//  UsersIntegrationTestCase.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

@testable import GitHubDMModel
import XCTest

// Add to GitHubDMModelTests target to test, not included by default
// to avoid exceeding rate limit.
class UsersIntegrationTestCase: XCTestCase {
    
    private var client: APIClient?
    
    override func setUp() {
        super.setUp()
        client = GitHubAPIClient(network: Network())
    }
    
    func testGetUsers() {
        let expect = XCTestExpectation(description: "GitHub Users Request")
        
        client?.getUsers(since: 0, failure: {
            error in
            
            XCTFail(error.localizedDescription)
            expect.fulfill()
        }, success: {
            users in
            
            XCTAssertEqual(users.count, 30)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
}
