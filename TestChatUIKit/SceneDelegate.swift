//
//  SceneDelegate.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
            
            MessagesDataStore.shared.configure()
            AvatarDataStore.shared.loadImagesByTypesOfMessages()
            
            window.rootViewController = UINavigationController(rootViewController: MessageListConfigurator.configure())
                self.window = window
                window.makeKeyAndVisible()
            }
    }
    
}

