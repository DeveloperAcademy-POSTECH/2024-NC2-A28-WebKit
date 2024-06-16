//
//  PlatformIconCell.swift
//  NC2WebKit
//
//  Created by 박현수 on 6/16/24.
//

import SwiftUI

struct PlatformIconCell: View {
    let platform: Platforms
    let homeVM: HomeViewModel
    var body: some View {
        VStack(spacing: 0) {
            Image("\(platform)")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5)
            Text(homeVM.convertToKR(eng: "\(platform)"))
                .padding(.top, 10)
                .foregroundStyle(.black)
                .bold()
            Spacer()
        }
    }
}
