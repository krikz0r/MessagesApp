//
//  SceneDelegate.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MessagesListFactory.createModule()
        window?.makeKeyAndVisible()
    }
}
