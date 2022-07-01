//
//  MessageListConfigurator.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 29.06.2022.
//

import Foundation
import UIKit

class MessageListConfigurator {
    
    static func configure() -> MessageListVC {
        
        print("MessageListConfigurator")
        
        let presenter = MessageListPresenter()
        
        let storyboard = UIStoryboard(name: "MessageList", bundle: nil)
        guard let rootVC = storyboard.instantiateViewController(identifier: "MessageListVC") as? MessageListVC else {
            print("ViewController not found")
            return MessageListVC()
        }
        
        let router = MessageListRouter()
        
        
        presenter.view = rootVC
        presenter.router = router
        rootVC.output = presenter
        router.view = rootVC
        
        let interactor = MessageListInteractor()
        
        interactor.output = presenter
        presenter.interactor = interactor
        
        return rootVC
        
    }
}
