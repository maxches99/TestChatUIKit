//
//  AvatarDataSource.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

protocol AvatarDataStoreDelegate: AnyObject {
    func loadedImage(by type: MessageType, data: Data)
}

extension AvatarDataStoreDelegate {
    var id: UUID {
        UUID()
    }
}

class AvatarDataStore {
    
    var delegate: AvatarDataStoreDelegate?
    
    static var shared = AvatarDataStore()
    
    private var typesOfMessages: [MessageType] = [.Incoming, .Outgoing]
    
    var dictOfAvatars: [MessageType: Data] = [:]
    
    func loadImagesByTypesOfMessages() {
        typesOfMessages.forEach { type in
            let imageURL: URL = type.avatarURL
              let queue = DispatchQueue.global(qos: .utility)
              queue.async { [weak self] in
                  if let data = try? Data(contentsOf: imageURL){
                      self?.dictOfAvatars[type] = data
                      self?.delegate?.loadedImage(by: type, data: data)
                      
                  }
              }
        }
        
    }
}
