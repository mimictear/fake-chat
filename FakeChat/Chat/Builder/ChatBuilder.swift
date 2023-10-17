//
//  ChatBuilder.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 18.10.2023.
//

import UIKit

struct ChatBuilder: ChatBuilderProtocol {
    
    // Kinda Dependency Injection
    var chatViewController: UIViewController {
        let viewController = ChatViewController()
        let repository = ChatRepository()
        viewController.chatRepository = repository
        return viewController
    }
}
