//
//  NetworkService.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation
import Combine

final class NetworkService {
    
    func request<T: Codable>(from endpoint: APIBuilder) -> AnyPublisher<T, APIError> {
        
        return ApiManager
            .sharedInstance
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: RunLoop.main)
            .mapError { error in
                return APIError.custom(error.localizedDescription)
            }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    return Just(data)
                        .decode(type: T.self, decoder: jsonDecoder)
                        .mapError { error in
                            APIError.decodingError
                        }
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
