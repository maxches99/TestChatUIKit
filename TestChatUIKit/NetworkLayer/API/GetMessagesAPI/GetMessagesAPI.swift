//
//  GetMessagesAPI.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation

/// Listing requests to get messages
enum GetMessagesAPI {
    case getMessages(Int)
}

extension GetMessagesAPI: APIBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .getMessages(let offset):
            
            var components = URLComponents(string: baseUrl.appendingPathComponent(path).absoluteString)
            components?.queryItems = [
                    URLQueryItem(name: "offset", value: "\(offset)")
            ]
            
            guard let url = components?.url else { return URLRequest(url: baseUrl.appendingPathComponent(path)) }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return request
        }
    }
    
    var path: String {
        switch self {
        case .getMessages:
            return "getMessages"
        }
    }
    
    
}
