//
//  MessageListInteractor.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 29.06.2022.
//

import Foundation

protocol MessageListInteractorInput: AnyObject {
    
    func getNewMessages(offset: Int)
    
    func getMessage(by index: IndexPath) -> MessageModel
    func getMessages() -> [MessageModel]
    func getMessages(by type: MessageType) -> [MessageModel]
    func insertMessage(message: String)
    
}

protocol MessageListInteractorOutput: AnyObject {
    
    func loadedMessages(messages: [String])
    
    func loadingMessagesError(error: APIError)
    
    func didMessagesUpdates()
    func didMessageRemoved(at index: Int)
    func didMessageInserted()
}

class MessageListInteractor {
    
    weak var output: MessageListInteractorOutput?
    
    fileprivate lazy var getMessagesService = GetMessagesService()
    
    fileprivate var isLoading = false
    
    private var dataStore = MessagesDataStore.shared
    
    var id: UUID = UUID()
    
    init() {
        dataStore.addDelegate(self)
    }
    
}

extension MessageListInteractor: MessageListInteractorInput {
    func getNewMessages(offset: Int) {
        if !isLoading {
            isLoading = true
            getMessagesService.loadMessages(offset: offset, completion: { [weak self] response, error in
                guard let strongSelf = self else { return }
                strongSelf.isLoading = false
                if let messages = response?.result, messages.count > 0 {
                    
                    strongSelf.pushMessagesToDataStore(messages: messages)
                } else {
                    strongSelf.output?.loadingMessagesError(error: error ?? .endOfArray)
                }
            })
        }
    }
    
    func pushMessagesToDataStore(messages: [String]) {
        var messageModels: [MessageModel] = []
        
        let avatarData = AvatarDataStore.shared.dictOfAvatars[.Incoming]
        
        messages.forEach {
            messageModels.append(MessageModel(id: UUID(), text: $0, type: .Incoming, avatarData: avatarData))
        }
        
        dataStore.pushMessages(messages: messageModels)
    }
    
    func getMessage(by index: IndexPath) -> MessageModel {
        return dataStore.getMessage(by: index.item)
    }
    
    func insertMessage(message: String) {
        let avatarData = AvatarDataStore.shared.dictOfAvatars[.Outgoing]
        
        dataStore.insertMessage(message: MessageModel(id: UUID(), text: message, type: .Outgoing, avatarData: avatarData), at: 0)
    }
    
    func getMessages() -> [MessageModel] {
        return dataStore.getMessages()
    }
    
    func getMessages(by type: MessageType) -> [MessageModel] {
        return dataStore.getMessages(by: type)
    }
}

extension MessageListInteractor: MessagesDataStoreDelegate {
    func didMessagesUpdates(messages: [MessageModel]) {
        output?.didMessagesUpdates()
    }
    
    func didMessageRemoved(at index: Int) {
        output?.didMessageRemoved(at: index)
    }
    
    func didMessageInserted() {
        output?.didMessageInserted()
    }
}
