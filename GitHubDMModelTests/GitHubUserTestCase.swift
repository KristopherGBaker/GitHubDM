//
//  GitHubUserTestCase.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

@testable import GitHubDMModel
import XCTest

class GitHubUserTestCase: XCTestCase {

    func testCanLoadUserFromData() {
        guard let data = DataLoader.loadJSONData(in: Bundle(for: GitHubUserTestCase.self),
                                                 for: "user") else {
            XCTFail("could not load user data")
            return
        }
        
        let user: GitHubUser
        
        do {
            user = try GitHubUser.from(data: data)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertEqual(user.userId, 1)
        XCTAssertEqual(user.avatarURL, URL(string: "https://avatars0.githubusercontent.com/u/1?v=4"))
        XCTAssertEqual(user.htmlURL, URL(string: "https://github.com/mojombo"))
        XCTAssertEqual(user.username, "mojombo")
    }
    
    func testCanLoadUserListFromData() {
        guard let data = DataLoader.loadJSONData(in: Bundle(for: GitHubUserTestCase.self),
                                                 for: "users-since-0") else {
            XCTFail("could not load user data")
            return
        }

        let users: [GitHubUser]

        do {
            users = try GitHubUser.arrayFrom(data: data)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }

        XCTAssertEqual(users.count, 30)
    }
    
}
