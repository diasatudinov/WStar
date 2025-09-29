//
//  WSAchievementsView.swift
//  WStar
//
//

import SwiftUI

struct WSAchievementsView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ZZAchievementsViewModel()
    @State private var index = 0
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    
                    HStack {
                        Image(.achievementsIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                    }
                    
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconWS)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                        }
                        
                        Spacer()
                        
                    }.padding(.horizontal)
                }.padding([.top])
                
                Spacer()
                
                VStack(spacing: 20) {
                    ForEach(viewModel.achievements, id: \.self) { item in
                        ZStack {
                            Image(item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                            
                            HStack {
                                Spacer()
                                Button {
                                    viewModel.achieveToggle(item)
                                    if item.isAchieved {
                                        user.updateUserMoney(for: 10)
                                    }
                                } label: {
                                    Image(item.isAchieved ? .tenCoinsWS : .notCompletedTextWS)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:50)
                                }
                            }.padding(.trailing, 28)
                        }
                    }
                    
                }
                
                Spacer()
            }
        }.background(
            LinearGradient(colors: [.appBgTop, .appBgBottom], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
        )
    }
    
    
}

#Preview {
    WSAchievementsView()
}
