//
//  DataFetchingDirection.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 19.10.2023.
//

import Foundation

enum DataFetchingDirection {
    case backward(start: Int, end: Int, beforeItem: ChatItem)
    case forward(start: Int, end: Int)
}
