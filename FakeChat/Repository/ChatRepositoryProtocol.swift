//
//  ChatRepositoryProtocol.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

protocol ChatRepositoryProtocol {
    
    /// Provides randomly generated `ChatItem`
    func getRandomChatItem(number: Int, charactersCount: Int) -> ChatItem
    
    /// Provides an array of randomly generated `ChatItems`
    func getChatItems(range: ClosedRange<Int>) -> [ChatItem]
}
