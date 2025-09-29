//
//  WSShopView.swift
//  WStar
//
//

import SwiftUI

struct WSShopView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CPShopViewModel
    @State var category: JGItemCategory = .background
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)

    var body: some View {
        ZStack {
            VStack(spacing: 35) {
                
                HStack(spacing: 20) {
                    
                    Button {
                        category = .background
                    } label: {
                        Image(category == .background ? .bgTextOnWS : .bgTextOffWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:45)
                    }
                    
                    Button {
                        category = .skin
                    } label: {
                        Image(category == .skin ? .skinsTextOnWS : .skinTextOffWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:45)
                    }
                }
                
                VStack {
                    
                    HStack {
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(category == .skin ? viewModel.shopSkinItems :viewModel.shopBgItems, id: \.self) { item in
                                achievementItem(item: item, category: category == .skin ? .skin : .background)
                                
                            }
                        }
                        
                    }
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
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    
                    Spacer()
                    
                    Image(.shopIconWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                    
                    Spacer()
                    
                    Image(.backIconWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:50)
                        .opacity(0)
                    
                }.padding()
                Spacer()
                
                
                
            }
        }.frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.appBgTop, .appBgBottom], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
            )
    }
    
    @ViewBuilder func achievementItem(item: JGItem, category: JGItemCategory) -> some View {
        ZStack {
            
            Image(item.icon)
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                Button {
                    viewModel.selectOrBuy(item, user: user, category: category)
                } label: {
                    
                    if viewModel.isPurchased(item, category: category) {
                        ZStack {
                            Image(.btnBg)
                                .resizable()
                                .scaledToFit()
                            
                            Text(viewModel.isCurrentItem(item: item, category: category) ? "used" : "use")
                                .font(.system(size: 20))
                                .bold()
                                .textCase(.uppercase)
                                .foregroundStyle(.white)
                            
                        }.frame(height: ZZDeviceManager.shared.deviceType == .pad ? 50:42)
                        
                    } else {
                        Image(.hundredCoinsWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 50:42)
                            .opacity(viewModel.isMoneyEnough(item: item, user: user, category: category) ? 1:0.6)
                    }
                    
                    
                }
            }.offset(y: 8)
            
        }.frame(height: ZZDeviceManager.shared.deviceType == .pad ? 300:160)
        
    }
}

#Preview {
    WSShopView(viewModel: CPShopViewModel())
}
