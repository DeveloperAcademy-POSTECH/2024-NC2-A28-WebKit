//
//  ContentView.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var webView: WebView = WebView(url: "https://time.navyism.com/")
    var body: some View {
        GeometryReader { geo in
            VStack {
                webView
                    .frame(height: 200)
                Divider()
                Spacer()
                Button("ticketLink") {
                    injectTicketLinkScript()
                }
                Button("naver") {
                    injectNaverScript()
                }
            }
        }
    }
    func injectTicketLinkScript() {
        let script = """
        document.querySelector('#inputhere').value = 'https://www.ticketlink.co.kr/';
        document.querySelector('#buttonFight').click();
        """
        webView.webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        print("1")
    }
    func injectNaverScript() {
        let script = """
        document.querySelector('#inputhere').value = 'https://www.naver.com/';
        document.querySelector('#buttonFight').click();
        """
        webView.webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        print("1")
    }
}


#Preview {
    ContentView()
}
