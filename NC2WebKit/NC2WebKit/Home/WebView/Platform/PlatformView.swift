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
    
    @Bindable var homeVM: HomeViewModel
    
    var body: some View {
        VStack {
            platformViewTopBar
            Divider()
            webView
        }
    }
    
}

extension PlatformView {
    var platformViewTopBar: some View {
        HStack {
            navyismReloadButton
            
            snapshotButton
            
            Spacer()
            
            webViewBackwardButton
            
            webViewForwardButton

        }.padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 5)
    }
    
    var navyismReloadButton: some View {
        Button {
            navyismWebView.webView.reload()
        } label: {
            Image(systemName: "clock")
        }.padding(.trailing, 5)
    }
    
    var snapshotButton: some View {
        Button {
            webView.takeAndStoreSnapshot { successed in
                if successed {
                    homeVM.snapshotStored = true
                }
            }
        } label: {
            Image(systemName: "camera")
        }.alert("스크린샷 저장 완료", isPresented: $homeVM.snapshotStored) {
            Button("확인") {}
        }
    }
    
    var webViewBackwardButton: some View {
        Button {
            webView.webView.goBack()
        } label: {
            Image(systemName: "arrow.backward")
        }
        .disabled(!homeVM.canGoBack)
        .padding(.trailing, 5)
    }
    
    var webViewForwardButton: some View {
        Button {
            webView.webView.goForward()
        } label: {
            Image(systemName: "arrow.forward")
        }
        .disabled(!homeVM.canGoForward)
    }
}
