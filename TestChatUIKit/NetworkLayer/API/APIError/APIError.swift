//
//  APIError.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation

/// Custom errors of NetworkLayer
public enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case custom(String)
    case unknown
    case endOfArray
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return "APIError: decodingError"
        case .errorCode(let code):
            return "APIError: \(code)"
        case .custom(let errorDescription):
            return errorDescription
        case .unknown:
            return "APIError: unknown"
        case .endOfArray:
            return "APIError: endOfArray"
        }
    }
}
