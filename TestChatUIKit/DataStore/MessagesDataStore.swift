//
//  MessagesDataStore.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

// Для передачи между экранами решил изспользовать общий датастор, хотел реализовать общую навигацию при помощи общего координатора, тогда не нужно было бы удалять ссылки вручную из массива

class MessagesDataStore {
    
    private var delegates: [MessagesDataStoreDelegate] = []
    
    private var userDefaultsHelper: UserDefaultsHelper = UserDefaultsHelper()
    
    private var avatarDataSource: AvatarDataStore = AvatarDataStore.shared
    
    private var messages: [MessageModel] = []
    
    static var shared = MessagesDataStore()
    
    func configure() {
        userDefaultsHelper.delegate = self
        avatarDataSource.delegate = self
        
        messages = userDefaultsHelper.readMessages().reversed()
    }
    
    func addDelegate(_ delegate: MessagesDataStoreDelegate) {
        delegates.append(delegate)
    }
    
    func removeDelegate(_ delegate: MessagesDataStoreDelegate) {
        delegates.removeAll(where: { delegate.id == $0.id })
    }
    
    func pushMessages(messages: [MessageModel]) {
        self.messages.append(contentsOf: messages)
        delegates.forEach { [weak self] in
            guard let strongSelf = self else { return }
            $0.didMessagesUpdates(messages: strongSelf.messages)
        }
    }
    
    func getMessage(by index: Int) -> MessageModel {
        return messages[index]
    }
    
    func getMessage(by id: UUID) -> MessageModel? {
        return messages.first(where: { $0.id == id })
    }
    
    func getMessages() -> [MessageModel] {
        return messages
    }
    
    func getMessages(by type: MessageType) -> [MessageModel] {
        return messages.filter { $0.type == type }
    }
    
    func insertMessage(message: MessageModel, at index: Int) {
        messages.insert(message, at: index)
        userDefaultsHelper.addToMessages(item: message)
    }
    
    func deleteMessage(at id: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        if messages[index].type == .Outgoing {
            messages.removeAll(where: { $0.id == id })
            userDefaultsHelper.deleteMessage(at: id)
        } else {
            messages.removeAll(where: { $0.id == id })
            delegates.forEach {
                $0.didMessageRemoved(at: index)
            }
        }
    }
    
}

extension MessagesDataStore: UserDefaultsHelperDelegate {
    func didAddedMessages() {
        delegates.forEach {
            $0.didMessageInserted()
        }
    }
    
    func didMessageDeleted(at index: Int) {
        delegates.forEach {
            $0.didMessageRemoved(at: index)
        }
    }
    
    
}

extension MessagesDataStore: AvatarDataStoreDelegate {
    func loadedImage(by type: MessageType, data: Data) {
        //
        messages = messages.map {
            if type == $0.type {
                return MessageModel(id: $0.id, text: $0.text, type: $0.type, avatarData: data)
            } else {
                return $0
            }
        }
        
        delegates.forEach {
            $0.didMessagesUpdates(messages: messages)
        }
    }
    
    
}
