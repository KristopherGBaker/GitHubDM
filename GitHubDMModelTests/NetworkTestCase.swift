//
//  NetworkTestCase.swift
//  GitHubDMModelTests
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

@testable import GitHubDMModel
import XCTest

class NetworkTestCase: XCTestCase {
    
    struct SlideshowWrapper: Entity {
        let slideshow: Slideshow
    }
    
    struct Slideshow: Entity {
        let author: String
    }
    
    private var network: Networking?
    
    override func setUp() {
        super.setUp()
        network = Network()
    }
    
    func testRequestData() {
        let expect = XCTestExpectation(description: "https://httpbin.org/get")
        let request = URLRequest(url: URL(string: "https://httpbin.org/get")!)
        
        network?.requestData(request: request, parameters: [:], queue: .main, failure: { error in
            XCTFail(error.localizedDescription)
            expect.fulfill()
        }, success: { _ in
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
    func testRequestDataWithError() {
        let expect = XCTestExpectation(description: "https://httpbin.org/status/500")
        let request = URLRequest(url: URL(string: "https://httpbin.org/status/500")!)
        
        network?.requestData(request: request, parameters: [:], queue: .main, failure: { error in
            switch error {
            case .status(let status):
                XCTAssertEqual(status, 500)
            default:
                XCTFail("Wrong error: \(error.localizedDescription)")
            }
            expect.fulfill()
        }, success: { _ in
            XCTFail("Should be an error")
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
    func testRequest() {
        let expect = XCTestExpectation(description: "https://httpbin.org/json")
        let request = URLRequest(url: URL(string: "https://httpbin.org/json")!)
        
        network?.request(request: request, parameters: [:], queue: .main, failure: { error in
            XCTFail(error.localizedDescription)
            expect.fulfill()
        }, success: { (wrapper: SlideshowWrapper) in
            XCTAssertEqual(wrapper.slideshow.author, "Yours Truly")
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10)
    }
    
}
