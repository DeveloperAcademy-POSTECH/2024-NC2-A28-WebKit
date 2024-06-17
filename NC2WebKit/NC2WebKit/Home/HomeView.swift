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
                    .frame(height: 100)
                
                Divider().padding(.top, 20)
                
                platformList(geo: geo)
                
            }.padding(.horizontal, 20)
        }
        .sheet(isPresented: $homeVM.platformWebViewPresented) {
            PlatformView(
                webView: PlatformWebView(
                    url: homeVM.selectedPlatform.rawValue,
                    homeVM: homeVM
                ),
                navyismWebView: navyismWebView,
                homeVM: homeVM
            ).presentationDetents([.height(homeVM.sheetHeight)])
        }
    }
}

extension HomeView {
    func platformList(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("플랫폼 선택 ")
                    .font(.title)
                    .bold()
                Spacer()
            }.padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Platforms.allCases, id: \.self) { platform in
                    platformButton(
                        geo: geo,
                        platform: platform
                    )
                }
            }.padding(.top, 20)
            
            Spacer()
        }
    }
    
    func platformButton(geo: GeometryProxy, platform: Platforms) -> some View {
        Button {
            homeVM.setSelectedPlatform(
                platform: platform
            )
            homeVM.injectScript(
                webView: navyismWebView,
                url: platform.rawValue
            )
            homeVM.setSheetHeight(
                height: geo.size.height - 90
            )
            homeVM.platformWebViewPresented = true
        } label: {
            VStack(spacing: 0) {
                Image("\(platform)")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 5)
                Text(homeVM.convertToKR(eng: "\(platform)"))
                    .font(.system(size: 14, weight: .bold))
                    .padding(.top, 10)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
    }    
}

#Preview {
    HomeView()
}
