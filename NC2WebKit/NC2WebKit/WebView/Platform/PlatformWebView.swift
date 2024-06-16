//
//  PlatformWebView.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//
import SwiftUI
import WebKit

struct PlatformWebView: UIViewRepresentable {
    var url: String
    let webView: WKWebView = WKWebView()
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PlatformWebView

        init(_ parent: PlatformWebView) {
            self.parent = parent
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
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<PlatformWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}
