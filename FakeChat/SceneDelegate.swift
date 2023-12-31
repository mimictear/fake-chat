//
//  SceneDelegate.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let chatViewController = ChatBuilder().chatViewController
        let navigationController = UINavigationController(rootViewController: chatViewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
