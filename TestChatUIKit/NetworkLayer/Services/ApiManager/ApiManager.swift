//
//  ApiManager.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation

class ApiManager {
    static let sharedInstance: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = nil
        return URLSession(configuration: configuration)
    }()
}
