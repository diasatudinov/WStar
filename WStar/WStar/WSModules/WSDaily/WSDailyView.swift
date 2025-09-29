//
//  WSDailyView.swift
//  WStar
//
//

import SwiftUI

struct WSDailyView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DailyRewardsViewModel()
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    private let dayCellHeight: CGFloat = ZZDeviceManager.shared.deviceType == .pad ? 200:108
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                HStack {
                    Image(.dailyTextWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:300)
                }
                
                ZStack {
                    ScrollView(.horizontal){
                        HStack {
                            
                            ForEach(1...viewModel.totalDaysCount, id: \.self) { day in
                                VStack(spacing: 5) {
                                    
                                    Text("Day \(day)")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                    
                                    ZStack {
                                        
                                        Image(.dailyCoinBgWS)
                                            .resizable()
                                            .scaledToFit()
                                        Text("10")
                                            .font(.system(size: 35, weight: .bold))
                                            .foregroundStyle(.white)
                                            .textCase(.uppercase)
                                            .offset(x: -40)
                                        
                                    }
                                    .frame(height: 65)
                                    .opacity(viewModel.isDayClaimed(day) ? 1 : viewModel.isDayUnlocked(day) ? 0.5 : 0.1)
                                    
                                    
                                }
                            }.padding()
                        }
                    }
                }
                
                Button {
                    viewModel.claimNext()
                    
                } label: {
                    Image(.takeBtnOnWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                }
                Spacer()
                
            }.padding(.top, 48)
            
            VStack {
                ZStack {
                    
                    HStack(alignment: .top) {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconWS)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        
                        Spacer()
                        
                    }
                }.padding([.horizontal, .top])
                Spacer()
                
            }
            
        }.background(
            LinearGradient(colors: [.appBgTop, .appBgBottom], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    WSDailyView()
}
