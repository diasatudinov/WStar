//
//  ZZCoinBg.swift
//  WStar
//
//


import SwiftUI

struct ZZCoinBg: View {
    @StateObject var user = ZZUser.shared
    var height: CGFloat = ZZDeviceManager.shared.deviceType == .pad ? 100:55
    var body: some View {
        ZStack {
            Image(.coinsBgWS)
                .resizable()
                .scaledToFit()
            
            Text("Coins: \(user.money)")
                .font(.system(size: ZZDeviceManager.shared.deviceType == .pad ? 45:20, weight: .regular))
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .offset(x: -20)
            
            
            
        }.frame(height: height)
        
    }
}

#Preview {
    ZZCoinBg()
}
