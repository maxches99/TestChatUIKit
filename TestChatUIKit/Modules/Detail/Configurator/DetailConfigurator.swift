//
//  DetailConfigurator.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import UIKit

class DetailConfigurator {
    
    static func configure(id: UUID) -> UIViewController {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard let rootVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            print("ViewController not found")
            return DetailViewController()
        }
        
        let presenter = DetailPresenter(id: id)
        let interactor = DetailInteractor()
        let router = DetailRouter()
        
        rootVC.output = presenter
        presenter.view = rootVC
        
        presenter.interactor = interactor
        interactor.output = presenter
        
        presenter.router = router
        router.view = rootVC
        
        return rootVC
    }
}
