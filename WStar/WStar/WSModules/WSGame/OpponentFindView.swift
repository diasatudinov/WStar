//
//  OpponentFindView.swift
//  WStar
//
//

import SwiftUI

struct OpponentFindView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isEnemyFound = false
    @State private var scale: CGFloat = 1.0
    @State private var showGame = false

    var body: some View {
        ZStack {
            
            VStack(spacing: 30) {
                
                HStack(spacing: 30) {
                    
                    VStack {
                        
                        Image(.youTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:26)
                        
                        Image(.youImageWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:100)
                        
                        Image(.brigTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:26)
                    }
                    
                    Image(isEnemyFound ? .vsWS : .threeDotsWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: isEnemyFound ? 80:10)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                        .onAppear {
                            scale = 0.5
                        }
                    
                    VStack {
                        
                        Image(.enemyTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:26)
                        
                        Image(isEnemyFound ? .opponentFindWS:.opponentNotFindWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:100)
                        
                        Image(.shipTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:26)
                    }
                    
                }
                
                VStack(spacing: 22) {
                    
                    Image(.subtitleTextWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                    
                    VStack {
                        Image(.rewardTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:26)
                        
                        Image(.hundredCoinsWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:55)
                    }
                }
                
                if isEnemyFound {
                    Button {
                        showGame = true
                    } label: {
                        
                        Image(.startBtnWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                    }
                } else {
                    Image(.startBtnWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                        .opacity(0)
                }
            }
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                    Image(.battleTextWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:30)
                    
                    Spacer()
                    
                    Image(.backIconWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                        .opacity(0)
                }.padding()
                Spacer()
                
            }
        }.frame(maxWidth: .infinity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    isEnemyFound = true
                }
            }
            .background(
                ZStack {
                    Image(.findOpponentViewBgWS)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    
                    
                    
                }
            )
            .fullScreenCover(isPresented: $showGame) {
                VerticalShipsBattleView()
            }
    }
}

#Preview {
    OpponentFindView()
}
