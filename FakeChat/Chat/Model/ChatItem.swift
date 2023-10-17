//
//  ChatItem.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 18.10.2023.
//

import Foundation

struct ChatItem: Identifiable {
    let id = UUID()
    let number: Int
    let text: String
}

extension ChatItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: ChatItem, rhs: ChatItem) -> Bool {
      lhs.id == rhs.id
    }
}
