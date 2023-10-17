//
//  String+localized.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 18.10.2023.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localized(withComment: String) -> String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
