//
//  HomeViewModel.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import Foundation

@Observable
final class HomeViewModel {
    var platformWebViewPresented: Bool = false
    var selectedPlatform: Platforms = .interparkTicket
    var sheetHeight: CGFloat = 0.0
    
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
    
    func setSelectedPlatform(platform: Platforms) {
        self.selectedPlatform = platform
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
