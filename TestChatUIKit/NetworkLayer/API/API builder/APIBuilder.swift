//
//  APIBuilder.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

extension APIBuilder {
    var baseUrl: URL {
        return URL(string: "https://numero-logy-app.org.in/")!
    }
}
