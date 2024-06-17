//
//  PlatformView.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI

struct PlatformView: View {
    let webView: PlatformWebView
    let navyismWebView: NavyismWebView
    
    var homeVM: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    navyismWebView.webView.reload()
                } label: {
                    HStack {
                        Text("서버시간 새로고침")
                        Image(systemName: "clock")
                    }
                }
                Spacer()
                Button {
                    webView.webView.goBack()
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .disabled(!homeVM.canGoBack)
                .padding(.trailing, 5)
                
                Button {
                    webView.webView.goForward()
                } label: {
                    Image(systemName: "arrow.forward")
                }
                .disabled(!homeVM.canGoForward)
            }.padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 5)
            Divider()
            webView
        }
    }
    
}
