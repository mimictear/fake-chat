//
//  ChatRepository.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import Foundation

struct ChatItem {
    let ID = UUID()
    let text: String
}

final class ChatRepository: ChatRepositoryProtocol {
    
    func getRandomChatItem(charactersCount: Int = 5) -> ChatItem {
        ChatItem(text: randomAlphanumericString(Int.random(in: 5...100)))
    }
    
    func getChatItems() -> [ChatItem] {
        var items = [ChatItem]()
        (0...20).forEach { _ in
            items.append(getRandomChatItem(charactersCount: Int.random(in: 5...100)))
        }
        return items
    }
    
    private func randomAlphanumericString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random = SystemRandomNumberGenerator()
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int(random.next(upperBound: len))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
}
