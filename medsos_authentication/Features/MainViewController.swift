//
//  ViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class MainViewController: BaseViewController {
    @IBOutlet weak var btnGoogleSignin: AuthButton!
    @IBOutlet weak var btnFacebookSignin: AuthButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    private let manager = LoginManager()
    private let FBPermission = ["fields":"""
        id,
        name,
        email,
        first_name,
        last_name,
        age_range,
        link,
        gender,
        locale,
        timezone,
        picture,
        updated_time,
        verified
        """
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupData()
        setupUI()
    }
    
    private func setupData() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        if AccessToken.isCurrentAccessTokenActive,
            let token = AccessToken.current,
            !token.isExpired {
            print(token.tokenString)
            fetchUserProfile()
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
        lblProfile.text = ""
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderColor = UIColor.black.cgColor
        imgAvatar.layer.borderWidth = 1
    }
}

extension MainViewController {
    @IBAction func googleSignIn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Logout" {
            GIDSignIn.sharedInstance().signOut()
            logout(sender, "Google SignIn")
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Logout" {
            manager.logOut()
            logout(sender, "Facebook SignIn")
        } else {
            manager.logIn(permissions: [], from: self) { result, error in
                if let _ = error { return }
                sender.setTitle("Logout", for: .normal)
                self.facebookSigInHandling(result)
            }
        }
    }
    
    private func logout(_ button: UIButton, _ title: String) {
        lblProfile.text = ""
        imgAvatar.image = nil
        button.setTitle(title, for: .normal)
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
    
    private func facebookSigInHandling(_ result: LoginManagerLoginResult?) {
        if result?.isCancelled == true {
            print("Cancel")
        } else {
            print(result?.token?.appID)
            print(result?.token?.tokenString)
            print(result?.token?.expirationDate)
            self.fetchUserProfile()
        }
    }
    
    private func fetchUserProfile() {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: FBPermission)) { httpResponse, result, error   in
            if let _ = error { return }
            // Handle vars
            if let json = result as? [String: Any] {
                json.forEach { key, value in
                    if key == "picture",
                        let picture = value as? [String: Any] ,
                        let data = picture["data"] as? [String: Any],
                        let url = data["url"] as? String {
                        self.imgAvatar.load(fromUrl: url)
                    } else {
                        self.lblProfile.text?.append("\(key):\(value)\n")
                    }
                }
            }
        }
        connection.start()
    }
}
