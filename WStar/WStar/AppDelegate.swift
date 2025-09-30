//
//  AppDelegate.swift
//  WStar
//
//


import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    static var orientationLock: UIInterfaceOrientationMask = .all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Настройка Firebase
        FirebaseApp.configure()
        
        // Настройка FCM
        Messaging.messaging().delegate = self
        
        // Настройка уведомлений
        UNUserNotificationCenter.current().delegate = self
        
        // Запрос разрешения на уведомления
        requestNotificationPermission()
        
        // Регистрация для remote notifications
        application.registerForRemoteNotifications()
        
        // Проверяем, было ли приложение запущено из уведомления
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            print("🚀 App launched from notification: \(userInfo)")
            handlePushNotification(userInfo)
        }
        
        return true
    }
    
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
                return
            }
            
            print(granted ? "✅ Notifications enabled" : "❌ Notifications disabled")
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: - Remote Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("✅ APNs token received")
        
        // Передаём APNs токен в Firebase
        Messaging.messaging().apnsToken = deviceToken
        
        // Для отладки можно вывести токен
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 APNs Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Обработка Data Payload в background/inactive состоянии
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("📨 Background notification received: \(userInfo)")
        
        handlePushNotification(userInfo)
        
        // Уведомляем систему о результате обработки
        completionHandler(.newData)
    }
    
    private func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
        // Отправляем уведомление в приложение
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            print("❌ FCM token is nil")
            return
        }
        
        print("🔥 FCM Token received: \(token)")
        print("🔍 Token length: \(token.count) chars")
        print("🔍 Timestamp: \(Date())")
        
        // Проверяем изменился ли токен
        let previousToken = FCMManager.shared.fcmToken
        let isTokenChanged = previousToken != token
        
        if isTokenChanged {
            if let prev = previousToken {
                print("🔄 Token CHANGED!")
                print("🔄 Previous: \(prev)")
                print("🔄 New: \(token)")
            } else {
                print("🆕 First time receiving token")
            }
        } else {
            print("✅ Same token as before")
        }
        
        // Сохраняем токен в FCMManager
        FCMManager.shared.setToken(token)
        
        // ✅ ВАЖНО: Убрали автоматическую отправку отсюда!
        // Отправка токена происходит ТОЛЬКО через AppStateManager.checkInitialURL()
        // Это исключает дублирование запросов
        print("📋 Token saved to FCMManager, sending will be handled by AppStateManager")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Обработка уведомлений когда приложение в foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("👁️ Foreground notification: \(userInfo)")
        
        handlePushNotification(userInfo)
        
        // Показываем уведомление даже когда приложение активно
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    // Обработка нажатия на уведомление
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier
        
        print("👆 Notification tapped: \(actionIdentifier)")
        print("📄 UserInfo: \(userInfo)")
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("🔄 Default action - notification tapped")
        case UNNotificationDismissActionIdentifier:
            print("❌ Notification dismissed")
        default:
            print("🔧 Custom action: \(response.actionIdentifier)")
        }
        
        handlePushNotification(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
