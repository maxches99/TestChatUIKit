//
//  MessageListPresenter.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 29.06.2022.
//

import Foundation

enum ModuleState {
    case error
    case loading
    case loaded
    case rest
}

protocol MessageListViewOutput: AnyObject {
    
    var state: ModuleState { get set }
    
    func willDisplay(forRowAt indexPath: IndexPath)
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func getNewMessages()
    
    func getMessage(by indexPath: IndexPath) -> MessageModel?
    
    func sendMessage(text: String?)
    
    func tapOnMessage(by indexPath: IndexPath)

    func viewAppeared()
    
}

class MessageListPresenter {
    
    weak var view: MessageListViewInput?
    
    var router: MessageListRouterInput?
    
    var interactor: MessageListInteractorInput?
    
    var isLoading = false
    
    var isNeededLoader = true
    
    var state: ModuleState = .rest
    
    fileprivate lazy var getMessagesService = GetMessagesService()
    
    var countOfReapetedTasks = 0
    
    func viewAppeared() {
        getNewMessages()
    }
    
    
    func getNewMessages() {
        if isLoading == false {
            isLoading = true
        }
        state = .loading
        
        let incomingCount = interactor?.getMessages(by: .Incoming).count ?? 0
        
        interactor?.getNewMessages(offset: incomingCount)
    }
    
    func getMessage(by indexPath: IndexPath) -> MessageModel? {
        guard let count = interactor?.getMessages().count else { return nil }
        if count >= indexPath.item, count > 0 {
            return interactor?.getMessages()[indexPath.item]
        }
        return nil
    }
}

extension MessageListPresenter: MessageListViewOutput {
    
    func willDisplay(forRowAt indexPath: IndexPath) {
        guard let incomingCount = interactor?.getMessages(by: .Incoming).count else { return }
        guard let count = interactor?.getMessages().count else { return }
        guard indexPath.item >= count - 5, incomingCount > 0 else { return }
        
        if isNeededLoader {
            getNewMessages()
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 {
            return interactor?.getMessages().count ?? 0
        } else if section == 1 {
            return isNeededLoader ? 1 : 0
        } else {
            return state == .error ? 1 : 0
        }
    }
    
    func sendMessage(text: String?) {
        if let text = text, !text.isEmpty {
            interactor?.insertMessage(message: text)
        }
    }
    
    func tapOnMessage(by indexPath: IndexPath) {
        guard let id = interactor?.getMessage(by: indexPath).id else {
            return
        }
        
        router?.openDetailScene(with: id)
    }
    
}

extension MessageListPresenter: MessageListInteractorOutput {
    
    func loadedMessages(messages: [String]) {
        state = .loaded
        countOfReapetedTasks = 0
    }
    
    func loadingMessagesError(error: APIError) {
        switch error {
        case .decodingError:
            countOfReapetedTasks += 1
            if countOfReapetedTasks < 5 {
                getNewMessages()
            } else {
                state = .error
            }
        case .endOfArray:
            isNeededLoader = false
            view?.deleteRows(at: [IndexPath(item: 0, section: 1)])
        default:
            break
        }
    }
    
    func didMessagesUpdates() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.reloadData()
        }
    }
    
    func didMessageRemoved(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.deleteRows(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func didMessageInserted() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.reloadRows(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
}
