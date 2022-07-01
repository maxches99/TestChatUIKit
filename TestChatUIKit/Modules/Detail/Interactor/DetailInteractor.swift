//
//  DetailInteractor.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

protocol DetailInteractorInput: AnyObject {
    func getModel(by id: UUID)
    func deleteModel(by id: UUID)
    
    func getAvatarData(by type: MessageType) -> Data?
    
    func freeingUpMemory()
}

protocol DetailInteractorOutput: AnyObject {
    
    func loadedModel(model: MessageModel)
    func loadindModelError()
    
    func didMessageRemoved()
    
    func loadedImage(by type: MessageType)
}

class DetailInteractor {
    weak var output: DetailInteractorOutput?
    
    private let dataStore = MessagesDataStore.shared
    private let avatarDataSource = AvatarDataStore.shared
    
    var id: UUID = UUID()
    
    init() {
        dataStore.addDelegate(self)
    }
    
    func freeingUpMemory() {
        dataStore.removeDelegate(self)
    }
}

extension DetailInteractor: DetailInteractorInput {
    func getModel(by id: UUID) {
        guard let model = dataStore.getMessage(by: id) else {
            
            output?.loadindModelError()
            
            freeingUpMemory()
            
            return
        }
        
        output?.loadedModel(model: model)
    }
    
    func deleteModel(by id: UUID) {
        dataStore.deleteMessage(at: id)
    }
    
    func getAvatarData(by type: MessageType) -> Data? {
        return avatarDataSource.dictOfAvatars[type]
    }
}

extension DetailInteractor: MessagesDataStoreDelegate {
    func didMessageRemoved(at index: Int) {
        freeingUpMemory()
        
        output?.didMessageRemoved()
    }
}
