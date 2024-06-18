//
//  DataManager.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/18/24.
//

import Foundation

protocol DataManager {
    func createItem(urlString: String, displayName: String)
    func fetchItems() -> [AdditionalPlatform]
    func deleteItem(item: AdditionalPlatform)
}
