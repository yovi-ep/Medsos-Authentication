//
//  AppDelegate.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupGoogleSignIn()
        self.setupFacebook(application, launchOptions)
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        setupFacebookURL(app, url, options)
        setupGoogleSingInURL(url)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

/* Google SignIn Config */
extension AppDelegate: GIDSignInDelegate {
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = BuildConfig.get(key: .GoogleSignInClientID)
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func setupGoogleSingInURL(_ url: URL) {
        GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
        }
        NotificationCenter.default.post(Notification(name: .GoogleSign, object: user, userInfo: nil))
    }
}

/* Facebook Config */
extension AppDelegate {
    private func setupFacebook(_ application: UIApplication, _ options: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: options
        )
    }
    
    private func setupFacebookURL(_ app: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey : Any]) {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
