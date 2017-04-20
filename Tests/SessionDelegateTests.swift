//
//  SessionDelegateTests.swift
//  AxziplinNet
//
//  Created by devedbox on 2017/4/19.
//  Copyright © 2017年 devedbox. All rights reserved.
//

import XCTest
import AxziplinNet

class SessionDelegateTests: XCTestCase {

    let delegate = SessionDelegate()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSessionTaskDidComplete() {
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let task = session.dataTask(with: URLRequest(url: URL(string:"https://itunes.apple.com/cn/app/xun-qin-ji/id1166476826?mt=8")!))
        XCTAssertNotNil(task)
        let expectation = self.expectation(description: "expectation")
        expectation.expectedFulfillmentCount = 1
        task.resume()
        delegate.taskOfSessionDidComplete = { task, session, error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
    }
}
