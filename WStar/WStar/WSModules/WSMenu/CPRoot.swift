//
//  CPRoot.swift
//  WStar
//
//


import SwiftUI

struct CPRoot: View {
    
    @State private var isLoading = true
    @State var toUp: Bool = true
    @AppStorage("vers") var verse: Int = 0
    
    @StateObject private var state = AppStateManager()
    @StateObject private var fcmManager = FCMManager.shared
    var body: some View {
        ZStack {
            if verse == 1 {
                CPWVWrap(urlString: CPLinks.winStarData)
            } else {
                VStack {
                    if isLoading {
                        WSSplashView()
                    } else {
                        WSMenuView()
                            .onAppear {
                                AppDelegate.orientationLock = .portrait
                                setOrientation(.portrait)
                            }
                            .onDisappear {
                                AppDelegate.orientationLock = .all
                            }
                            
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                updateIfNeeded()
            }
           
        }
        .onAppear {
            state.stateCheck()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification"))) { notification in
            handlePushNotification(notification)
        }
    }
    
    func updateIfNeeded() {
        if CPLinks.shared.finalURL == nil {
            Task {
                if await !CPResolver.checking() {
                    verse = 1
                    toUp = false
                    isLoading = false
                    
                } else {
                    verse = 0
                    toUp = true
                    isLoading = false
                }
            }
        } else {
            isLoading = false
        }
        
        
    }
    
    func setOrientation(_ orientation: UIInterfaceOrientation) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let selector = NSSelectorFromString("setInterfaceOrientation:")
            if let responder = windowScene.value(forKey: "keyWindow") as? UIResponder, responder.responds(to: selector) {
                responder.perform(selector, with: orientation.rawValue)
            }
        }
    }
    
    private func handlePushNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        print("🔔 Push notification received: \(userInfo)")
        
        // Здесь можно добавить логику обработки пуш-уведомлений
        // Например, навигация к определенному экрану или обновление данных
    }
}

#Preview {
    CPRoot()
}
