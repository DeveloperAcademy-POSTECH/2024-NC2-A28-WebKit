//
//  SwiftDataManager.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/18/24.
//

import Foundation
import SwiftData

final class SwiftDataManager: DataManager {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    init() {
        let schema = Schema([
            AdditionalPlatform.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func createItem(urlString: String, displayName: String) {
        let item = AdditionalPlatform(urlString: urlString, displayName: displayName)
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchItems() -> [AdditionalPlatform] {
        do {
            return try modelContext.fetch(FetchDescriptor<AdditionalPlatform>())
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func deleteItem(item: AdditionalPlatform) {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
