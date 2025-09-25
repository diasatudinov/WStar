//
//  WSMenuView.swift
//  WStar
//
//

import SwiftUI

struct WSMenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false
    @State private var showDailyReward = false
    
    //    @StateObject var shopVM = CPShopViewModel()
    
    var body: some View {
        
        ZStack {
            
            
            VStack(spacing: 0) {
                
                HStack {
                    Button {
                        withAnimation {
                            showDailyReward = true
                        }
                    } label: {
                        Image(.dailyIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                }.padding(20)
                Spacer()
                
            }
            
            VStack(spacing: 20) {
                
                Image(.splashLogoWS)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:200)
                    .cornerRadius(20)
                
                ZZCoinBg()
                
                VStack {
                    Button {
                        showGame = true
                    } label: {
                        Image(.playIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:75)
                    }
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:75)
                    }
                    
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:75)
                    }
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                    }
                    
                }
                
            }
            
        }.frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.appBgTop, .appBgBottom], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
            )
            .fullScreenCover(isPresented: $showGame) {
                //                HKHLevelsVIew()
            }
            .fullScreenCover(isPresented: $showAchievement) {
                //                HKHAchievementsView()
            }
            .fullScreenCover(isPresented: $showShop) {
                //                HKHShopView(viewModel: shopVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
                WSSettingsView()
            }
            .fullScreenCover(isPresented: $showDailyReward) {
                //                HKHDailyView()
            }
    }
}

#Preview {
    WSMenuView()
}
