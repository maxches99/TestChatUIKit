//
//  UserDefaultsHelper.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

protocol UserDefaultsHelperDelegate: AnyObject {
    func didAddedMessages()
    func didMessageDeleted(at index: Int)
}

struct UserDefaultsHelper {
    
    enum TypesOfData {
        case messages
        
        var key: String {
            switch self {
            case .messages:
                return "messages"
            }
        }
    }
    
    weak var delegate: UserDefaultsHelperDelegate?
    
    private var queue = DispatchQueue(label: "UserDefaultsQueue")
    
    func addToMessages(item: MessageModel) {
        queue.sync {
            var oldMessages = readMessages()
            
            oldMessages.append(item)
            
            if let encoded = encode(oldMessages) {
                UserDefaults.standard.set(encoded, forKey: TypesOfData.messages.key)
                
                delegate?.didAddedMessages()
            }
        }
    }
    
    func readMessages() -> [MessageModel] {
        if let decoded: [MessageModel] = decode(data: UserDefaults.standard.data(forKey: TypesOfData.messages.key)) {
            return decoded
        } else {
            return []
        }
    }
    
    func deleteMessage(at id: UUID) {
        queue.sync {
            var oldMessages = readMessages()
            
            let index = oldMessages.firstIndex(where: { $0.id == id })
            
            oldMessages.removeAll(where: { $0.id == id })
            
            if let encoded = encode(oldMessages) {
                UserDefaults.standard.set(encoded, forKey: TypesOfData.messages.key)
                
                if let index = index {
                    delegate?.didMessageDeleted(at: index)
                }
            }
                
        }
    }
    
    func decode<T: Codable>(data: Data?) -> T? {
        let decoder = JSONDecoder()
        if let data = data, let decoded = try? decoder.decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
    
    func encode<T: Codable>(_ item: T?) -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(item) {
            return encoded
        }
        return nil
    }
    
}
