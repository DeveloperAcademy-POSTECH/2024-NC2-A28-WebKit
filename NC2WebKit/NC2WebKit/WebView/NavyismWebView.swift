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
    @State var isLoading = true
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: NavyismWebView

        init(_ parent: NavyismWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.querySelector('#time_area').scrollIntoView({behavior: 'smooth', block: 'start'});") { _, error in
                if error == nil {
                    self.parent.isLoading = false
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        
        guard let url = URL(string: url) else {
            return containerView
        }
        
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        
        let hostingController = UIHostingController(rootView: Text("서버시간 불러오는 중 🏃🏃"))
        hostingController.view.frame = containerView.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(hostingController.view)
        
        if !isLoading {
            webView.frame = containerView.bounds
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(webView)
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let url = URL(string: url) else { return }
        
        if isLoading {
            webView.load(URLRequest(url: url))
        } else {
            for subview in uiView.subviews {
                if subview is WKWebView {
                    subview.removeFromSuperview()
                }
            }
            
            webView.frame = uiView.bounds
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            uiView.addSubview(webView)
        }
    }
}
