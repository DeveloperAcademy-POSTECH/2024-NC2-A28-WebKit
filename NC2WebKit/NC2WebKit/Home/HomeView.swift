//
//  HomeViewH.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI
import WebKit

struct HomeView: View {
    @State var homeVM: HomeViewModel =
    HomeViewModel(dataManager: SwiftDataManager())
    @Environment(\.dismiss) var dismiss
    
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
        .onAppear() {
            homeVM.fetchItems()
        }
        .sheet(isPresented: $homeVM.platformWebViewPresented) {
            PlatformView(
                webView: PlatformWebView(
                    url: homeVM.selectedPlatformURL,
                    homeVM: homeVM
                ),
                navyismWebView: navyismWebView,
                homeVM: homeVM
            ).presentationDetents([.height(homeVM.sheetHeight)])
        }
    }
}

extension HomeView {
    var alertContent: some View {
        VStack {
            TextField("URL", text: $homeVM.newItemURLInput)
            TextField("이름", text: $homeVM.newItemNameInput)
            Button("추가") {
                withAnimation {
                    homeVM.createItem()
                    homeVM.fetchItems()
                }
            }
            // MARK: - SwiftUI Alert 버그(추후 픽스시 주석 제거)
//            .disabled(homeVM.newItemURLInput.isEmpty || homeVM.newItemNameInput.isEmpty)
            Button("취소", role: .cancel) {}
        }
    }
    
    func additionalPlatformList(geo: GeometryProxy) -> some View {
        ForEach(homeVM.additionalPlatforms, id: \.self) { platform in
            additionalPlatformButton(
                geo: geo,
                platform: platform
            )
        }
    }
    
    func platformList(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("플랫폼 선택 ")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    homeVM.showAlert = true
                } label: {
                    Image(systemName: "plus.app")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .alert("플랫폼 추가", isPresented: $homeVM.showAlert) {
                    alertContent
                } message: {
                    Text("URL과 플랫폼 이름을 입력하세요.")
                }
            }.padding(.vertical, 20)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Platforms.allCases, id: \.self) { platform in
                        platformButton(
                            geo: geo,
                            platform: platform
                        )
                    }
                    additionalPlatformList(geo: geo)
                }.padding(.horizontal, 20)
            }.padding(.horizontal, -20)
        }
    }
    
    func platformButton(geo: GeometryProxy, platform: Platforms) -> some View {
        Button {
            homeVM.setSelectedPlatformURL(
                url: platform.rawValue
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
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
                Text(homeVM.convertToKR(eng: "\(platform)"))
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .padding(.top, 10)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
    }
    
    func additionalPlatformButton(geo: GeometryProxy, platform: AdditionalPlatform) -> some View {
        
        VStack(spacing: 0) {
            Button {
                homeVM.setSelectedPlatformURL(
                    url: platform.urlString
                )
                homeVM.injectScript(
                    webView: navyismWebView,
                    url: platform.urlString
                )
                homeVM.setSheetHeight(
                    height: geo.size.height - 90
                )
                homeVM.platformWebViewPresented = true
            } label: {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding()
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
                }.contextMenu(
                ContextMenu(
                    menuItems: {
                        Button(role: .destructive) {
                            withAnimation {
                                homeVM.deleteItem(item: platform)
                                homeVM.fetchItems()
                            }
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                )
            )
            Text(platform.displayName)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
                .padding(.top, 10)
                .foregroundStyle(.black)
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
