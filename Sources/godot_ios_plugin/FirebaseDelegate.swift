//
//  Firebase.swift
//  godot_ios_plugin
//
//  Created by Skye Waddell on 2025-01-27.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications

protocol FirebaseClassDelegate : AnyObject {
    func didReceiveFCMToken(_ fcmToken: String)
}

class FirebaseDelegate : NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    weak var delegate : FirebaseClassDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]){granted,error in
                    print("Notifications Permissions status: \(granted)")
                }
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
    didRegisterForRemoteNotificationWithDeviceToken deviceToken: Data){
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: userInfo)
        completionHandler()
    }
    
    @objc func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        delegate?.didReceiveFCMToken(fcmToken ?? "-1")
        print("Firebase Token: \(String(describing: fcmToken))")
    }
    
    
}
