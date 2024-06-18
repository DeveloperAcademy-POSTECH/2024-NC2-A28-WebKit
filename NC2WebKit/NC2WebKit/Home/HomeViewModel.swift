//
//  HomeViewModel.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import Foundation

@Observable
final class HomeViewModel {
    let dataManager: DataManager
    
    var additionalPlatforms: [AdditionalPlatform] = []
    var platformWebViewPresented: Bool = false
    var selectedPlatformURL: String = ""
    var sheetHeight: CGFloat = 0.0
    
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    
    var showAlert: Bool = false
    
    var newItemURLInput: String = ""
    var newItemNameInput: String = ""
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func injectScript(webView: NavyismWebView, url: String) {
        let script = """
        document.querySelector('#inputhere').value = '\(url)';
        document.querySelector('#buttonFight').click();
        """
        webView.webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setSelectedPlatformURL(url: String) {
        self.selectedPlatformURL = url
    }
    
    func setSheetHeight(height: CGFloat) {
        self.sheetHeight = height
    }
    
    func convertToKR(eng: String) -> String {
        switch eng {
        case "interparkTicket":
            return "인터파크"
        case "ticketLink":
            return "티켓링크"
        case "yes24Ticket":
            return "예스24"
        case "melonTicket":
            return "멜론"
        default:
            return "잘못된 플랫폼"
        }
    }
}

// MARK: - CRUD
extension HomeViewModel {
    func createItem(urlString: String, displayName: String) {
        dataManager.createItem(urlString: urlString, displayName: displayName)
    }
    
    func fetchItems() {
        self.additionalPlatforms = dataManager.fetchItems()
    }
    
    func deleteItem(item: AdditionalPlatform) {
        dataManager.deleteItem(item: item)
    }
    
    func updateItem(item: AdditionalPlatform, urlString: String, displayName: String) {
        dataManager.updateItem(item: item, urlString: urlString, displayName: displayName)
    }
}
