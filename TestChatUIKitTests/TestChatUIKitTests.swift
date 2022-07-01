//
//  TestChatUIKitTests.swift
//  TestChatUIKitTests
//
//  Created by Максим Чесников on 28.06.2022.
//

import XCTest
@testable import TestChatUIKit

// хотел написать тесты, но не успел, понял что без сторонних библиотек будет очень много инитов и по времени просто не вывезу

class TestChatUIKitTests: XCTestCase {
    
    fileprivate lazy var getMessagesService = GetMessagesService()

    func testGetMessagesService() throws {
        var getMessagesResponse: GetMessagesResponse? = nil
        
        let expectation = XCTestExpectation.init(description: "loadMessages")
        
        getMessagesService.loadMessages(offset: 0, completion: { response, error in
            if error != nil
            {
                XCTFail("Fail")
            }
            getMessagesResponse = response
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 30.0)
        
        XCTAssertTrue(getMessagesResponse?.result?.count ?? 0 > 0)
    }

    
}
