//
//  AdditionalPlatform.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/17/24.
//

import Foundation
import SwiftData

@Model
final class AdditionalPlatform {
    @Attribute(.unique) let uuid = UUID()
    var urlString: String
    var displayName: String
    
    init(urlString: String, displayName: String) {
        self.urlString = urlString
        self.displayName = displayName
    }
}
