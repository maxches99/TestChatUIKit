//
//  MessagesDataStoreDelegate.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

protocol MessagesDataStoreDelegate: AnyObject {
    
    var id: UUID { get set }
    
    func didMessagesUpdates(messages: [MessageModel])
    
    func didMessageUpdated(message: MessageModel)
    
    func didMessageRemoved(at index: Int)
    
    func didMessageInserted()
    
}

extension MessagesDataStoreDelegate {
    
    func didMessagesUpdates(messages: [MessageModel]) {}
    
    func didMessageUpdated(message: MessageModel) {}
    
    func didMessageRemoved(at index: Int) {}
    
    func didMessageInserted() {}
}
