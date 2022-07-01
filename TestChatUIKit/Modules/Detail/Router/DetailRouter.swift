//
//  DetailRouter.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation
import UIKit

protocol DetailRouterInput {
    func popScene()
}

class DetailRouter: DetailRouterInput {
    weak var view: DetailViewController?
    
    func popScene() {
        view?.navigationController?.popViewController(animated: true)
    }
}
