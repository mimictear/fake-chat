//
//  ChatRepository.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import Foundation

final class ChatRepository: ChatRepositoryProtocol {
    
    func getRandomChatItem(number: Int, charactersCount: Int = 5) -> ChatItem {
        ChatItem(number: number, text: randomAlphanumericString(Int.random(in: 5...100)))
    }
    
    func getChatItems(range: ClosedRange<Int>) -> [ChatItem] {
        range.map { index in
            
            getRandomChatItem(
                number: index,
                charactersCount: Int.random(in: 5...100)
            )
        }
    }
    
    private func randomAlphanumericString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random = SystemRandomNumberGenerator()
        var randomString = ""
        (0..<length).forEach { _ in
            let randomIndex = Int(random.next(upperBound: len))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
}
