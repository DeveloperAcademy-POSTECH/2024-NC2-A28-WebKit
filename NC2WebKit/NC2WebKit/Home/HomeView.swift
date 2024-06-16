//
//  HomeViewH.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI
import WebKit

struct HomeView: View {
    @State var homeVM: HomeViewModel = HomeViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible())
    ]
    
    let navyismWebView: NavyismWebView = NavyismWebView(url: "https://time.navyism.com/")
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                navyismWebView
                    .frame(height: 90)
                
                Divider().padding(.top, 20)
                
                HStack(spacing: 0) {
                    Text("플랫폼 선택 ")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(.top, 20)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Platforms.allCases, id: \.self) { platform in
                        Button {
                            homeVM.setSelectedPlatform(platform: platform)
                            homeVM.injectScript(webView: navyismWebView, url: platform.rawValue)
                            homeVM.setSheetHeight(height: geo.size.height - 100)
                            homeVM.platformWebViewPresented = true
                        } label: {
                            PlatformIconCell(platform: platform, homeVM: homeVM)
                        }
                    }
                }.padding(.top, 20)
                
                Spacer()
                
            }.padding(.horizontal, 20)
        }
        .sheet(isPresented: $homeVM.platformWebViewPresented) {
            PlatformView(url: homeVM.selectedPlatform.rawValue)
                .presentationDetents([.height(homeVM.sheetHeight)])
        }
    }
}


#Preview {
    HomeView()
}
