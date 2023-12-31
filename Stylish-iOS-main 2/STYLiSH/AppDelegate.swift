//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit
import AdSupport
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        TPDSetup.setWithAppId(
            Bundle.STValueForInt32(key: STConstant.tapPayAppID),
            withAppKey: Bundle.STValueForString(key: STConstant.tapPayAppKey),
            with: TPDServerType.sandBox
        )

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // device ID
        let id = UUID()
        UserDefaults.standard.set(id.uuidString.lowercased(), forKey: "DeviceID")
        
        // lobby style
        UserDefaults.standard.set(Bool.random(), forKey: "IsGridLobby")
        
        // user email
        if AccessToken.current?.tokenString == nil {
            UserDefaults.standard.set(nil, forKey: "UserEmail")
        } else {
            let graphRequest = FBSDKLoginKit.GraphRequest(
                graphPath: "me",
                parameters: ["fields": "email, name"],
                tokenString: AccessToken.current?.tokenString,
                version: nil,
                httpMethod: .get
            )
            graphRequest.start { (connection, result, error) -> Void in
                if error == nil {
                    guard let userDict = result as? [String: Any] else { return }
                    if let email = userDict["email"] as? String {
                        UserDefaults.standard.set(email, forKey: "UserEmail")
                    }
                } else {
                    print("error \(error)")
                }
            }
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (granted, error) in
            if granted {
                print("允許開啟")
            } else {
                print("拒絕接受開啟")
            }
        }
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // device ID
        let id = UUID()
        UserDefaults.standard.set(id.uuidString.lowercased(), forKey: "DeviceID")
        
        // lobby style
        UserDefaults.standard.set(Bool.random(), forKey: "IsGridLobby")
//        let isGridLobby = UserDefaults.standard.object(forKey: "IsGridLobby") as? Bool
//        print(isGridLobby)
//        if let isGridLobby = isGridLobby {
//            print("Not First launch")
//            print(isGridLobby)
//        } else {
//            UserDefaults.standard.set(Bool.random(), forKey: "IsGridLobby")
//            print("First launch")
//            let setedLobby = UserDefaults.standard.object(forKey: "IsGridLobby") as? Bool
//            print(setedLobby)
//        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
