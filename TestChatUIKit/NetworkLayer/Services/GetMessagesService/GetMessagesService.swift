//
//  GetMessagesService.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import Foundation
import Combine

/// Service to network work of get messages API
public class GetMessagesService {
    
    public init() {}
    
    fileprivate lazy var networkService = NetworkService()
    
    fileprivate var getMessagesResponse: GetMessagesResponse?
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    /// Method to get single GetMessagesResponse by offset
    /// - Parameters:
    ///   - offset: Offset of collection messages
    ///   - completion: It return's GetMessagesResponse or APIError
    func loadMessages(offset: Int, completion: @escaping (GetMessagesResponse?, APIError?) -> Void ) {
        let cancellable = networkService.request(from: GetMessagesAPI.getMessages(offset))
            .sink { [weak self] res in
                guard let strongSelf = self else { return }
                switch res {
                case .finished:
                    completion(strongSelf.getMessagesResponse, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            } receiveValue: { [weak self] response in
                self?.getMessagesResponse = response
            }
        
        cancellables.insert(cancellable)
    }
    
    
}
