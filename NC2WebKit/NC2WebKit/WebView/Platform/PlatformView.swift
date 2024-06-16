//
//  PlatformView.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI

struct PlatformView: View {
    let url: String
    var body: some View {
        VStack {
            HStack {
                Button("R") {}
                Spacer()
                Button("B") {}
                Button("F") {}
            }.padding(.horizontal, 20)
                .padding(.vertical, 10)
            Divider()
            PlatformWebView(url: url)
        }
    }
}
