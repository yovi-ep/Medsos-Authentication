//
//  ViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: BaseViewController {
    @IBOutlet weak var btnGoogleSignin: AuthButton!
    @IBOutlet weak var btnFacebookSignin: FBLoginButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    private let manager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupData()
        setupUI()
    }
    
    private func setupData() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        //btnFacebookSignin.delegate = self
        if AccessToken.isCurrentAccessTokenActive,
            let token = AccessToken.current,
            !token.isExpired {
            print(token.tokenString)
            btnFacebookSignin.setTitle("Logout", for: .normal)
        } else {
            btnFacebookSignin.setTitle("Facebook SignIn", for: .normal)
        }
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: .GoogleSign, object: nil, queue: nil) { notif in
            if let data = notif.object {
                switch data {
                case is GIDGoogleUser:
                    self.googleSignInHandling(data: data as! GIDGoogleUser)
                default:
                    print("not categories")
                }
            }
        }
    }
    
    private func setupUI() {
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderColor = UIColor.black.cgColor
        imgAvatar.layer.borderWidth = 1
    }
}

extension MainViewController {
    @IBAction func googleSignIn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Logout" {
            GIDSignIn.sharedInstance().signOut()
            lblProfile.text = ""
            imgAvatar.image = nil
            sender.setTitle("Google SignIn", for: .normal)
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Logout" {
            manager.logOut()
            sender.setTitle("Facebook SignIn", for: .normal)
        } else {
            manager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
                guard let _ = error else { return }
                if result?.isCancelled == true {
                    print("Cancel")
                } else {
                    print(result?.token?.appID)
                    print(result?.token?.tokenString)
                    print(result?.token?.expirationDate)
                    sender.setTitle("Logout", for: .normal)
                }
            }
        }
    }
}

extension MainViewController {
    private func googleSignInHandling(data: GIDGoogleUser) {
        self.btnGoogleSignin.setTitle("Logout", for: .normal)
        lblProfile.text = "User ID : \(data.userID ?? "")\n"
        lblProfile.text?.append("Name : \(data.profile.name ?? "")\n")
        lblProfile.text?.append("Give Name : \(data.profile.givenName ?? "")\n")
        lblProfile.text?.append("Family Name : \(data.profile.familyName ?? "")\n")
        lblProfile.text?.append("Email : \(data.profile.email ?? "")\n")
        lblProfile.text?.append("Has Image : \(data.profile.hasImage)\n")
        if data.profile.hasImage,
            let url = data.profile.imageURL(withDimension: 100)?.absoluteString{
            imgAvatar.load(fromUrl: url)
        }
        print("clientID   : \(data.authentication.clientID ?? "")\n")
        print("idToken    : \(data.authentication.idToken ?? "")")
        print("refreshToken: \(data.authentication.refreshToken ?? "")")
    }
}

extension MainViewController : LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Login")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
}
