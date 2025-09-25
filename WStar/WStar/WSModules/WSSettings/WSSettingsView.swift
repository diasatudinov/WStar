//
//  WSSettingsView.swift
//  WStar
//
//  Created by Dias Atudinov on 25.09.2025.
//

import SwiftUI

struct WSSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var settingsVM = CPSettingsViewModel()
    var body: some View {
        ZStack {
            
            VStack {
                VStack(spacing: 70) {
                    HStack {
                        Image(.musicTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:35)
                        Spacer()
                        Toggle("", isOn: $settingsVM.musicEnabled)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .toggleBg))
                    }
                    
                    HStack {
                        Image(.soundsTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:35)
                        Spacer()
                        Toggle("", isOn: $settingsVM.soundEnabled)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .toggleBg))
                    }
                    
                    HStack {
                        Image(.vibroTextWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:35)
                        Spacer()
                        Toggle("", isOn: $settingsVM.vibroEnabled)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .toggleBg))
                    }
                    
                }.padding(.horizontal, 50)
                
                
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
                    
                    Image(.settingsIconWS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                    
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
            .background(
                LinearGradient(colors: [.appBgTop, .appBgBottom], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
            )
    }
}

#Preview {
    WSSettingsView()
}
