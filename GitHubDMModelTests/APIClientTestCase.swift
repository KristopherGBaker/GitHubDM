//
//  APIClientTestCase.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

@testable import GitHubDMModel
import XCTest

class APIClientTestCase: XCTestCase {
    
    class GoodNetwork: Networking {
        
        init() {
            
        }
        
        required init(configuration: URLSessionConfiguration) {
            
        }
        
        func requestData(request: URLRequest,
                         parameters: [String: CustomStringConvertible],
                         queue: DispatchQueue,
                         failure: ((NetworkError) -> Void)?,
                         success: ((Data) -> Void)?) {
            let data = DataLoader.loadJSONData(in: Bundle(for: GoodNetwork.self), for: "users-since-0")!
            DispatchQueue.main.async {
                success?(data)
            }
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
            requestData(request: request, parameters: parameters, queue: .main, failure: failure, success: { data in
                let entities = try! ResponseType.arrayFrom(data: data)
                DispatchQueue.main.async {
                    success?(entities)
                }
            })
        }
    }
    
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
    
    override func setUp() {
        super.setUp()
    }
    
    func testGetUsers() {
        let expect = XCTestExpectation(description: "GitHub Users Request")
        let client = GitHubAPIClient(network: GoodNetwork())

        client.getUsers(since: 0, failure: {
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
    
    func testGetUsersBadData() {
        let expect = XCTestExpectation(description: "GitHub Users Request")
        let client = GitHubAPIClient(network: BadNetwork())
        
        client.getUsers(since: 0, failure: {
            error in
            
            switch error {
            case .badData:
                print("Bad data as expected")
            default:
                XCTFail("Wrong error: \(error.localizedDescription)")
            }
            expect.fulfill()
        }, success: {
            _ in
            
            XCTFail("Should get error")
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
    func testSendMessage() {
        let expect = XCTestExpectation(description: "Send Message")
        let client = GitHubAPIClient(network: GoodNetwork())
        let sendDate = Date()
        
        let observer = NotificationCenter.default.addObserver(forName: Message.messageReceived,
                                                              object: nil,
                                                              queue: .main,
                                                              using: {
            notification in
            guard let message = notification.userInfo?[Message.messageKey] as? Message else {
                XCTFail("Could not get message from notification")
                expect.fulfill()
                return
            }
            XCTAssertGreaterThan(message.createdAt, sendDate)
            XCTAssertEqual(message.fromUserId, 2)
            XCTAssertEqual(message.toUserId, 1)
            XCTAssertEqual(message.text, "test test")
            XCTAssertEqual(message.messageType, .received)
            expect.fulfill()
        })
        
        let message = Message(createdAt: sendDate,
                              fromUserId: 1,
                              toUserId: 2,
                              text: "test",
                              messageType: .sent)
        client.send(message: message, failure: { error in
            XCTFail("Should not get an error")
        }, success: { _ in
            print("send message success")
        })
        
        wait(for: [expect], timeout: 10)
        NotificationCenter.default.removeObserver(observer)
    }
    
}
