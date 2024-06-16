//
//  WebView.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI
import WebKit

struct NavyismWebView: UIViewRepresentable {
    var url: String
    let webView: WKWebView = WKWebView()
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: NavyismWebView

        init(_ parent: NavyismWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.querySelector('#time_area').scrollIntoView({behavior: 'smooth', block: 'start'});")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<NavyismWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}
