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
    
    var homeVM: HomeViewModel

    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PlatformWebView

        init(_ parent: PlatformWebView) {
            self.parent = parent
            self.parent.webView.allowsBackForwardNavigationGestures = true
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.homeVM.canGoBack = webView.canGoBack
            parent.homeVM.canGoForward = webView.canGoForward
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.homeVM.canGoBack = webView.canGoBack
            parent.homeVM.canGoForward = webView.canGoForward
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(webView, action: #selector(WKWebView.webViewPullToRefreshHandler(source:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
        webView.scrollView.bounces = true
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<PlatformWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}

extension WKWebView {
    @objc func webViewPullToRefreshHandler(source: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.reload()
            source.endRefreshing()
        }
    }
}
