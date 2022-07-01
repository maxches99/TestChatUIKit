//
//  DetailPresenter.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

protocol DetailPresenterOutput: AnyObject {
    
    func dataLoaded()
    
    func loadedImage(data: Data)
}

class DetailPresenter {
    
    typealias ViewProtocol = DetailViewInput & DetailPresenterOutput
    
    weak var view: ViewProtocol?
    var interactor: DetailInteractorInput?
    var router: DetailRouterInput?
    
    var model: MessageModel?
    
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
}

extension DetailPresenter: DetailViewOutput {
    func getTextOfModel() -> String {
        return model?.text ?? ""
    }
    
    func getDateOfModel() -> String {
        return model?.date.formatted(date: .numeric, time: .shortened) ?? ""
    }
    
    func getImageOfModel() -> String {
        return model?.text ?? ""
    }
    
    func getAvatarURLOfModel() -> Data? {
        guard let type = model?.type else { return nil }
        return interactor?.getAvatarData(by: type)
    }
    
    func deleteMessage() {
        interactor?.deleteModel(by: id)
    }
    
    func viewAppeared() {
        interactor?.getModel(by: id)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func loadedModel(model: MessageModel) {
        self.model = model
        view?.dataLoaded()
    }
    
    func loadindModelError() {
        interactor?.freeingUpMemory()
        router?.popScene()
    }
    
    func didMessageRemoved() {
        interactor?.freeingUpMemory()
        router?.popScene()
    }
    
    func freeingUpMemory() {
        interactor?.freeingUpMemory()
    }
    
    func loadedImage(by type: MessageType) {
        if type == model?.type {
            guard let data = interactor?.getAvatarData(by: type) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.view?.loadedImage(data: data)
            }
        }
    }
}
