//
//  MessageListRouter.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation
import UIKit

protocol MessageListRouterInput {
    func openDetailScene(with id: UUID)
}

class MessageListRouter: MessageListRouterInput {
    weak var view: MessageListVC?
    
    func openDetailScene(with id: UUID) {
        let vc = DetailConfigurator.configure(id: id)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
